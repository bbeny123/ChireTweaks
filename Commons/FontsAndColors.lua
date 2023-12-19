local _, ns = ...
local CreateFont, CreateColor, CreateColorFromHex = CreateFont, CreateColor, CreateColorFromHexString
local SharedMedia = LibStub("LibSharedMedia-3.0")

local fontsCache, fontsList = { counter = 0 }, nil

function ns.RegisterFont(name, path)
    SharedMedia:Register("font", name, path)
end

local function FontsList()
    local fonts = {}

    for _, v in pairs(SharedMedia:List("font")) do
        fonts[v] = v
    end

    fontsList = fonts
    return fontsList
end

function ns.Fonts()
    return fontsList or FontsList()
end

local function FontCache(fontName, size)
    local fontsByName = fontsCache[fontName]

    if (not fontsByName) then
        fontsByName = { [size] = {} }
        fontsCache[fontName] = fontsByName
    elseif (not fontsByName[size]) then
        fontsByName[size] = {}
    end

    return fontsByName[size]
end

local function CacheFontObject(cache, fontName, size, style)
    fontsCache.counter = fontsCache.counter + 1

    local fontObject = CreateFont("ChireFont" .. fontsCache.counter)
    fontObject:SetFont(SharedMedia:Fetch("font", fontName), size, style)

    cache[style] = fontObject
    return fontObject
end

function ns.FontObject(fontName, size, style)
    style = (not style or style == ns.STYLE.NONE) and "" or style
    local fontCache = FontCache(fontName, size)
    local fontObject = fontCache[style]

    return fontObject or CacheFontObject(fontCache, fontName, size, style)
end

local function NonDefaultFontObject(unit, type)
    local fontOpt, sizeOpt, styleOpt = ns.Option(type, ns.KEY.FONT), ns.Option(type, ns.KEY.SIZE), ns.Option(type, ns.KEY.STYLE)
    local fontName, size, style = ns.GetDBRaw(unit, fontOpt), ns.GetDBRaw(unit, sizeOpt), ns.GetDBRaw(unit, styleOpt)

    if (fontName or size or style) then
        fontName = fontName or ns.Default(unit, fontOpt)
        size = size or ns.Default(unit, sizeOpt)
        style = style or ns.Default(unit, styleOpt)
        return ns.FontObject(fontName, size, style)
    end

    return nil
end

local function DefaultFontObject(unit, type)
    local fontName = ns.DefaultBy(unit, type, ns.KEY.FONT)
    local size = ns.DefaultBy(unit, type, ns.KEY.SIZE)
    local style = ns.DefaultBy(unit, type, ns.KEY.STYLE)
    return ns.FontObject(fontName, size, style)
end

function ns.FontObjectBy(unit, type, nonDefault, default)
    if (nonDefault) then
        return NonDefaultFontObject(unit, type)
    elseif (default) then
        return DefaultFontObject(unit, type)
    end

    local fontName = ns.GetDBBy(unit, type, ns.KEY.FONT)
    local size = ns.GetDBBy(unit, type, ns.KEY.SIZE)
    local style = ns.GetDBBy(unit, type, ns.KEY.STYLE)
    return ns.FontObject(fontName, size, style)
end

function ns.SetFont(text, fontObject)
    if (text) then
        text:SetFontObject(fontObject)
    end
end

function ns.SetStatusBarTextsFonts(statusBar, fontObject)
    ns.SetFont(statusBar.TextString, fontObject)
    ns.SetFont(statusBar.LeftText, fontObject)
    ns.SetFont(statusBar.RightText, fontObject)
    ns.SetFont(statusBar.TextCT, fontObject)
end

function ns.IsValidHexOrEmpty(hex)
    return not hex or hex == ""
            or hex:match("^#?%x%x%x%x%x%x$")
            or hex:match("^#?%x%x%x%x%x%x%x%x$")
end

function ns.ARGBHex(hex)
    local length = hex:len()
    hex = length % 2 == 0 and hex or hex:sub(2)
    return length > 7 and hex or "FF" .. hex
end

function ns.ToHexFromColor(color)
    local r, g, b, a = color:GetRGBAAsBytes()
    return ("%.2x%.2x%.2x%.2x"):format(a, r, g, b);
end

function ns.ToHex(r, g, b, a)
    return ns.ToHexFromColor(CreateColor(r, g, b, a))
end

function ns.ToRGBA(hex)
    return CreateColorFromHex(hex):GetRGBA()
end

function ns.Color(unit, type, default)
    local hexColor = default
            and ns.DefaultBy(unit, type, ns.KEY.COLOR)
            or ns.GetDBBy(unit, type, ns.KEY.COLOR)

    return ns.ToRGBA(hexColor)
end

function ns.SetColor(text, r, g, b, a)
    if (text) then
        text:SetTextColor(r, g, b, a)
    end
end

function ns.SetAllStatusBarTextsColor(statusBar, r, g, b, a)
    ns.SetColor(statusBar.TextString, r, g, b, a)
    ns.SetColor(statusBar.LeftText, r, g, b, a)
    ns.SetColor(statusBar.RightText, r, g, b, a)
    ns.SetColor(statusBar.TextCT, r, g, b, a)
end
