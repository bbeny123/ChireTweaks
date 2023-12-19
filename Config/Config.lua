local addonName, ns = ...
local LibStub = LibStub
local ct = LibStub("AceAddon-3.0"):GetAddon(addonName)
local L = LibStub("AceLocale-3.0"):GetLocale(addonName)

local cache, optionsTableCache

local function InitCache()
    if (cache) then
        return
    end

    local unitsSorted = { ns.UNIT.PLAYER, ns.UNIT.PET, ns.UNIT.TARGET, ns.UNIT.TOT, ns.UNIT.FOCUS, ns.UNIT.TOF, ns.UNIT.BOSS, ns.UNIT.BG, ns.UNIT.PARTY }
    local formats = ns.LocalizedList(ns.FORMAT)
    local formatsBoth = ns.LocalizedList(ns.FORMAT, ns.Alt)

    cache = {
        UNITS = ns.LocalizedList(ns.UNIT),
        UNITS_SORTED = unitsSorted,
        UNITS_TARGET_SORTED = { ns.UNIT.ALL, unpack(unitsSorted) },

        CVAR_STATUS_TEXT_VALUES = ns.LocalizedList(ns.CVAR_STATUS_TEXT),
        CVAR_STATUS_TEXT_VALUES_SORTED = { ns.CVAR_STATUS_TEXT.NONE, ns.CVAR_STATUS_TEXT.NUMERIC, ns.CVAR_STATUS_TEXT.BOTH },

        FORMATS = formats,
        FORMATS_DEAD = ns.ExtendedList(formats, ns.FORMAT_DEAD),
        FORMATS_BOTH = formatsBoth,
        FORMATS_DEAD_BOTH = ns.ExtendedList(formatsBoth, ns.FORMAT_DEAD),

        STYLES = ns.LocalizedList(ns.STYLE),
        STYLES_SORTED = { ns.STYLE.NONE, ns.STYLE.OUTLINE, ns.STYLE.THICK_OUTLINE, ns.STYLE.MONOCHROME, ns.STYLE.OUTLINE_MONOCHROME, ns.STYLE.THICK_OUTLINE_MONOCHROME },
    }
end

local function GetDB(info)
    if (info.option.disabled and info.option.disabled(info)) then
        return ns.DisabledValue(info.arg.unit, info.arg.option)
    end

    return ns.GetDB(info.arg.unit, info.arg.option)
end

local function SetDB(info, value)
    ns.SetDB(info.arg.unit, info.arg.option, value)
end

local function GetRGBAColorDB(info)
    return ns.ToRGBA(GetDB(info))
end

local function SetRGBAColorDB(info, r, g, b, a)
    SetDB(info, ns.ToHex(r, g, b, a))
end

local function GetHexColorDB(info)
    return "#" .. GetDB(info):upper()
end

local function SetHexColorDB(info, value)
    if (value and value ~= "") then
        SetDB(info, ns.ARGBHex(value))
    end
end

local function ValidateHex(info, value)
    if (ns.IsValidHexOrEmpty(value)) then
        return true
    end

    local defaultColor = ns.Default(info.arg.unit, info.arg.option)
    return L["colorPicker.invalid"]:format(defaultColor)
end

local function GetOffset(info)
    return tostring(GetDB(info))
end

local function ResetOffset(info)
    ns.SetDBBy(info.arg.unit, info.arg.option.type, ns.KEY.X)
    ns.SetDBBy(info.arg.unit, info.arg.option.type, ns.KEY.Y)
end

local function ValidateNumber(_, value)
    return ns.IsValidNumberOrEmpty(value) or L["offset.invalid"]
end

local function RootHidden(info)
    return not ns.GetDBBy(info.arg.unit, info.arg.option.type, ns.KEY.SHOW)
end

local function RootImmobilized(info)
    return not ns.GetDBBy(info.arg.unit, info.arg.option.type, ns.KEY.MOVE)
end

local function TargetCastBarOrRootHidden(info)
    return ns.TargetCastBarHidden() or RootHidden(info)
end

local function TargetCastBarOrRootImmobilized(info)
    return ns.TargetCastBarHidden() or RootImmobilized(info)
end

local function CastBarDetachedOrRootImmobilized(info)
    return ns.PlayerCastBarDetached() or RootImmobilized(info)
end

local function Arg(unit, option)
    return { unit = unit, option = option }
end

local function Formats(info)
    if (info.arg.option.type == ns.TYPE.HEALTH and info.arg.option.key == ns.KEY.ZERO) then
        return ns.BothStatusText() and cache.FORMATS_DEAD_BOTH or cache.FORMATS_DEAD
    end

    return ns.BothStatusText() and cache.FORMATS_BOTH or cache.FORMATS
end

local function GoldColored(text)
    return "|cffFFD100" .. text .. "|r"
end

local function GreyColored(text)
    return "|cff808080" .. text .. "|r"
end

local function ToTriTable(value, default)
    value = value or default
    return ns.IsTable(value) and value or { value, value, value }
end

local function HeaderToggleName(type, Disabled)
    local label = L[type]

    if (not Disabled) then
        return GoldColored(label)
    end

    return function(info)
        return not Disabled(info) and GoldColored(label) or GreyColored(label)
    end
end

local function AddInlineGroup(groupArgs, groupOrder, args, disabled)
    groupArgs["group" .. groupOrder] = {
        type = "group",
        inline = true,
        order = groupOrder,
        disabled = disabled,
        name = "",
        args = args,
    }

    return groupOrder + 1
end

local function AddHeader(args, order, name)
    args["header" .. order] = {
        type = "header",
        order = order,
        name = name,
    }

    return order + 1
end

local function AddGap(args, order, width)
    args["gap" .. order] = {
        type = "description",
        order = order,
        width = width,
        name = "",
    }

    return order + 1
end

local function AddLabel(args, order, width, name, alignLeft, fontSize)
    args["label" .. order] = {
        type = "description",
        dialogControl = not alignLeft and ns.WIDGET.LABEL or nil,
        order = order,
        width = width,
        name = name,
        fontSize = fontSize or "medium",
    }

    return order + 1
end

local function AddButton(args, order, disabled, name, atlas, func, arg)
    args["button" .. order] = {
        type = "execute",
        dialogControl = ns.WIDGET.ICON,
        order = order,
        disabled = disabled,
        width = 0.12,
        name = name,
        func = function(info) func(info) end,
        image = atlas.file,
        imageCoords = { atlas.leftTexCoord, atlas.rightTexCoord, atlas.topTexCoord, atlas.bottomTexCoord },
        imageWidth = 16,
        imageHeight = 16,
        arg = arg,
    }

    return order + 1
end

local function AddInput(args, order, unit, option, disabled, width, hideButton, Validate, Get, Set)
    args["input" .. order] = {
        type = "input",
        dialogControl = hideButton and ns.WIDGET.EDIT_BOX_NO_BUTTON or ns.WIDGET.EDIT_BOX,
        order = order,
        disabled = disabled,
        width = width,
        name = "",
        get = Get,
        set = Set,
        validate = Validate,
        arg = Arg(unit, option),
    }

    return order + 1
end

local function AddResetButton(args, order, unit, option, disabled, Reset)
    return AddButton(args, order, disabled, L["button.reset"], ns.RESET_ICON_ATLAS, Reset or SetDB, Arg(unit, option))
end

local function AddRangeSlider(args, order, unit, option, disabled, width)
    args["slider" .. order] = {
        type = "range",
        dialogControl = ns.WIDGET.SLIDER,
        order = order,
        disabled = disabled,
        width = width,
        name = "",
        min = 1,
        max = 99,
        softMin = 5,
        softMax = 19,
        bigStep = 1,
        arg = Arg(unit, option),
    }

    return AddResetButton(args, order + 1, unit, option, disabled)
end

local function AddColorPicker(args, order, unit, option, disabled, width)
    local defaultColor = ns.Default(unit, option)

    order = AddInput(args, order, unit, option, disabled, width, false, ValidateHex, GetHexColorDB, SetHexColorDB)
    order = AddGap(args, order, 0.02)

    args["picker" .. order] = {
        type = "color",
        dialogControl = ns.WIDGET.COLOR_PICKER,
        order = order,
        disabled = disabled,
        width = 0.13,
        name = L["colorPicker"],
        desc = L[ns.Desc("colorPicker")]:format(defaultColor),
        get = GetRGBAColorDB,
        set = SetRGBAColorDB,
        hasAlpha = true,
        arg = Arg(unit, option),
    }

    return AddResetButton(args, order + 1, unit, option, disabled)
end

local function AddOffsetPicker(args, order, unit, option, disabled, width)
    order = AddGap(args, order, 0.02)
    order = AddLabel(args, order, 0.07, "x:", true)
    order = AddInput(args, order, unit, option, disabled, width, true, ValidateNumber, GetOffset)

    order = AddGap(args, order, 0.033)
    order = AddLabel(args, order, 0.07, "y:")
    order = AddInput(args, order, unit, ns.Option(option.type, ns.KEY.Y), disabled, width, true, ValidateNumber, GetOffset)

    order = AddGap(args, order, 0.02)
    return AddResetButton(args, order, unit, option, disabled, ResetOffset)
end

local function AddBaseSelector(args, order, get, set, values, sort, name, desc, disabled, width, arg)
    args["selector" .. order] = {
        type = "select",
        order = order,
        disabled = disabled,
        width = width or 0.8,
        name = name,
        desc = desc,
        get = get,
        set = set,
        values = values,
        sorting = sort,
        arg = arg,
    }

    return order + 1
end

local function AddSelector(args, order, unit, option, disabled, width, values, sort)
    return AddBaseSelector(args, order, nil, nil, values, sort, "", nil, disabled, width, Arg(unit, option))
end

local function AddSelectorWithReset(args, order, unit, option, disabled, width, values, sort)
    order = AddSelector(args, order, unit, option, disabled, width - 0.13, values, sort)
    order = AddGap(args, order, 0.01)
    return AddResetButton(args, order, unit, option, disabled)
end

local function AddFormatSelector(args, order, unit, option, disabled, width)
    return AddSelector(args, order, unit, option, disabled, width, Formats)
end

local function AddFontSelector(args, order, unit, option, disabled, width)
    return AddSelectorWithReset(args, order, unit, option, disabled, width, ns.Fonts)
end

local function AddStyleSelector(args, order, unit, option, disabled, width)
    return AddSelectorWithReset(args, order, unit, option, disabled, width, cache.STYLES, cache.STYLES_SORTED)
end

local function AddToggleable(args, order, unit, option, name, desc, disabled, width)
    if (not width) then
        width = name:len() < 28 and 1.18 or 1.77;
    end

    args["toggle" .. order] = {
        type = "toggle",
        order = order,
        disabled = disabled,
        width = width,
        name = name,
        desc = desc,
        arg = Arg(unit, option),
    }

    return order + 1
end

local function AddHeaderLabel(args, order, _, option, disabled, width)
    return AddLabel(args, order, width, HeaderToggleName(option.type, disabled))
end

local function AddHeaderToggle(args, order, unit, option, disabled, width)
    return AddToggleable(args, order, unit, option, HeaderToggleName(option.type, disabled), L[ns.Desc(option.type)]:format(unit), disabled, width)
end

local function AddHeaderToggleOrLabel(args, order, unit, option, disabled, width)
    return ns.Enabled(unit, option)
        and AddHeaderToggle(args, order, unit, option, disabled, width)
        or AddHeaderLabel(args, order, unit, option, disabled, width)
end

local function AddToggleableRow(args, order, unit, option, disabled, width)
    return AddToggleable(args, order, unit, option, L[option.key], L[ns.Desc(option.key)]:format(unit), disabled, width)
end

local function AddToggleables(args, order, unit, type)
    local header = L[type]

    for _, option in pairs(ns.OPTIONS_SORTED[type]) do
        if (ns.Enabled(unit, option)) then
            if (header) then
                order, header = AddHeader(args, order, header), nil
            end

            order = AddToggleable(args, order, unit, option, L[option.key], L[ns.Desc(option.key)])
        end
    end

    return order
end

local function AddRow(groupArgs, groupOrder, Constructor, unit, types, option, disabled, gapWidths, widgetWidths, skipHeader)
    option, disabled, gapWidths, widgetWidths = ToTriTable(option), ToTriTable(disabled), ToTriTable(gapWidths, 0.04), ToTriTable(widgetWidths, 1.04)
    local order, args = 0, {}

    if (not skipHeader and L[option[1]]) then
        order = AddLabel(args, order, 0.3, L[option[1]])
    end

    for i=1,3 do
        if (types[i] and option[i]) then
            order = AddGap(args, order, gapWidths[i])
            order = Constructor(args, order, unit, ns.Option(types[i], option[i]), disabled[i], widgetWidths[i])
        end
    end

    return AddInlineGroup(groupArgs, groupOrder, args)
end

local function AddFontRows(args, order, unit, types, disabled, gapWidths)
    order = AddRow(args, order, AddFontSelector, unit, types, ns.KEY.FONT, disabled, gapWidths)
    order = AddRow(args, order, AddStyleSelector, unit, types, ns.KEY.STYLE, disabled, gapWidths)
    order = AddRow(args, order, AddRangeSlider, unit, types, ns.KEY.SIZE, disabled, gapWidths, 0.92)
    return AddRow(args, order, AddColorPicker, unit, types, ns.KEY.COLOR, disabled, gapWidths, 0.77)
end

local function AddFormatsGroup(groupArgs, groupOrder, unit)
    local order, args = 0, {}
    local types, disabled = ns.TYPES_STATUS_BAR, ns.NoneStatusText

    order = AddHeader(args, order, L["formats.header"])
    order = AddRow(args, order, AddHeaderLabel, unit, types, ns.KEY.BASE, disabled, { 0.535, 0.665, 0.445 }, { 0.45, 0.4, 0.82 }, true)
    order = AddRow(args, order, AddFormatSelector, unit, types, ns.KEY.BASE, disabled)
    order = AddRow(args, order, AddFormatSelector, unit, types, ns.KEY.HOVER, disabled)
    order = AddRow(args, order, AddFormatSelector, unit, types, ns.KEY.FULL, disabled)
    order = AddRow(args, order, AddFormatSelector, unit, types, ns.KEY.ZERO, disabled)
    order = AddFontRows(args, order, unit, { ns.TYPE.HEALTH, ns.TYPE.MANA }, disabled, { 0.04, 0.59 })

    return AddInlineGroup(groupArgs, groupOrder, args)
end

local function NameLevelGroupConfig(unit)
    if (not ns.OptionIfEnabled(unit, ns.TYPE.LEVEL, ns.KEY.SHOW)) then
        return { ns.TYPE.NAME }, { ns.KEY.NAME_CENTERED }, L["nameLevel.header.name"]
    end

    local options = unit == ns.UNIT.PLAYER and { ns.KEY.NAME_CENTERED } or { ns.KEY.NAME_CENTERED, ns.KEY.COLOR_LEVEL }
    return { ns.TYPE.NAME, ns.TYPE.LEVEL }, options, L["nameLevel.header.nameLevel"]
end

local function AddNameLevelGroup(groupArgs, groupOrder, unit)
    local order, args = 0, {}
    local types, extraOptions, header = NameLevelGroupConfig(unit)

    order = AddHeader(args, order, header)
    order = AddRow(args, order, AddHeaderToggle, unit, types, ns.KEY.SHOW, nil, 0.67, 0.425)
    order = AddFontRows(args, order, unit, types, RootHidden)
    order = AddRow(args, order, AddToggleableRow, unit, types, extraOptions, RootHidden, { 0.615, 0.49 }, { 0.5, 0.7 }, true)

    return AddInlineGroup(groupArgs, groupOrder, args)
end

local function CastBarGroupConfig(unit)
    if (not ns.OptionIfEnabled(unit, ns.TYPE.CASTBAR, ns.KEY.FONT)) then
        return nil
    end

    if (unit == ns.UNIT.PLAYER) then
        return { 0.645, 0.555 }, { nil, ns.PlayerCastBarTimerInvisible }, { CastBarDetachedOrRootImmobilized, ns.PlayerCastBarTimerInvisible }, { ns.PlayerCastBarDetached }
    end

    return { 0.645, 0.69 }, { ns.TargetCastBarHidden, TargetCastBarOrRootHidden }, { TargetCastBarOrRootImmobilized, ns.TargetCastBarHidden }, ns.TargetCastBarHidden
end

local function AddCastBarGroup(groupArgs, groupOrder, unit)
    local headersGaps, disabled, offsetsDisabled, headersDisabled = CastBarGroupConfig(unit)

    if (not headersGaps) then
        return groupOrder
    end

    local order, args = 0, {}

    order = AddHeader(args, order, L["castbar.header.name"])
    order = AddRow(args, order, AddHeaderToggleOrLabel, unit, ns.TYPES_CASTBAR, { ns.KEY.MOVE, ns.KEY.SHOW }, headersDisabled or disabled, headersGaps, 0.425, true)
    order = AddRow(args, order, AddOffsetPicker, unit, ns.TYPES_CASTBAR, ns.KEY.X, offsetsDisabled, nil, 0.3536)
    order = AddFontRows(args, order, unit, { ns.TYPE.CASTBAR, ns.TYPE.CASTBAR_TIMER }, disabled)
    order = AddRow(args, order, AddToggleableRow, unit, ns.TYPES_CASTBAR, { ns.KEY.ICON }, disabled, 0.59, nil, true)

    return AddInlineGroup(groupArgs, groupOrder, args)
end

local function AddUnitTable(groupArgs, groupOrder, unit)
    local order, args = 0, {}

    order = AddToggleables(args, order, unit, ns.TYPE.HIDE)
    order = AddToggleables(args, order, unit, ns.TYPE.HP_BAR)
    order = AddFormatsGroup(args, order, unit)
    order = AddNameLevelGroup(args, order, unit)
    order = AddCastBarGroup(args, order, unit)

    groupArgs[unit] = {
        type = "group",
        order = groupOrder,
        name = L[unit],
        desc = (L[ns.Desc(unit)] and L[ns.Desc(unit)] or L["tab.desc"]):format(GoldColored(L[unit])),
        args = args,
    }

    return groupOrder + 1;
end

--local function AddChatTable(groupArgs, groupOrder)
--
--    groupArgs.chat = {
--        type = "group",
--        order = groupOrder,
--        name = L[ns.TYPE.CHAT],
--        desc = nil, -- TODO
--        args = {}
--    }
--
--end

local function AddCopySelectors(args, order)
    local from, to = ns.UNIT.PLAYER, ns.UNIT.PLAYER

    order = AddBaseSelector(
            args,
            order,
            function() return from end,
            function(_, value) from = value end,
            cache.UNITS,
            cache.UNITS_SORTED,
            L["copy.from"])

    order = AddGap(args, order, 0.03)

    order = AddBaseSelector(
            args,
            order,
            function() return to end,
            function(_, value) to = value end,
            cache.UNITS,
            cache.UNITS_TARGET_SORTED,
            L["copy.to"])

    order = AddGap(args, order, 0.02)

    return AddButton(args, order,
            function() return from == to end,
            L["button.copy"],
            ns.APPLY_ICON_ATLAS,
            function() ns.CopyDB(from, to) end)
end

local function AddMainHeader(args, order)
    order = AddLabel(args, order, 0.75, GoldColored(L[addonName]), true, "large")

    order = AddBaseSelector(
            args,
            order,
            ns.GetStatusTextCVar,
            ns.SetStatusTextCVar,
            cache.CVAR_STATUS_TEXT_VALUES,
            cache.CVAR_STATUS_TEXT_VALUES_SORTED,
            L["statusText"],
            L[ns.Desc("statusText")]
    )

    order = AddGap(args, order, 0.15)
    return AddCopySelectors(args, order)
end

local function OptionsTable()
    local order, args = 0, {}
    InitCache()

    order = AddMainHeader(args, order)

    --order = AddChatTable(args, order)

    for _, unit in pairs(cache.UNITS_SORTED) do
        order = AddUnitTable(args, order, unit)
    end

    args.profileTab = LibStub("AceDBOptions-3.0"):GetOptionsTable(ct.db)

    return {
        type = "group",
        name = "",
        get = GetDB,
        set = SetDB,
        childGroups = "tab",
        args = args
    }
end

local function OptionsTableCache()
    if (not optionsTableCache) then
        ns.RegisterCustomWidgets()
        optionsTableCache = OptionsTable()
    end
    return optionsTableCache
end

function ct:InitConfig()
    LibStub("AceConfig-3.0"):RegisterOptionsTable(addonName, OptionsTableCache)

    local configDialog = LibStub("AceConfigDialog-3.0"):AddToBlizOptions(addonName, L[addonName])
    local chatCommand = function() InterfaceOptionsFrame_OpenToCategory(configDialog) end

    self:RegisterChatCommand(addonName, chatCommand)
    self:RegisterChatCommand("ct", chatCommand)
end
