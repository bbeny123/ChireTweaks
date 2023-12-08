local addonName, ns = ...
local ct = LibStub("AceAddon-3.0"):GetAddon(addonName)
local TextStatusBar_UpdateTextString = TextStatusBar_UpdateTextString
local KEY, POWER_TYPE, FORMAT, FORMAT_DEAD = ns.KEY, ns.POWER_TYPE, ns.FORMAT, ns.FORMAT_DEAD
local DeadText, FormatText, FormatBothText, BothStatusText, ShowToTText, HideToTText = ns.DeadText, ns.FormatText, ns.FormatBothText, ns.BothStatusText, ns.ShowToTText, ns.HideToTText
local configCache = {}

local function CacheStatusBarConfig(statusbar, unit, type, powerType, key, clear)
    if (not configCache[statusbar]) then
        configCache[statusbar] = {}
    end

    if (clear) then
        configCache[statusbar][powerType] = nil
        return
    end

    local config = configCache[statusbar][powerType]

    if (key and config) then
        config[key] = ns.GetDBBy(unit, type, key)
    else
        config = {
            [KEY.BASE] = ns.GetDBBy(unit, type, KEY.BASE),
            [KEY.FULL] = ns.GetDBBy(unit, type, KEY.FULL),
            [KEY.HOVER] = ns.GetDBBy(unit, type, KEY.HOVER),
            [KEY.ZERO] = ns.GetDBBy(unit, type, KEY.ZERO),
        }
        configCache[statusbar][powerType] = config
    end

    if (not key or key == KEY.ZERO) then
        config.deadable = config[KEY.ZERO] == FORMAT_DEAD or nil
    end
end

local function SetStatusBarText(config, statusBar, textString, value, valueMax, percent, formatKey, ignoreDeadText)
    local format = config[formatKey]
    local deadText = not ignoreDeadText and config.deadable and format ~= FORMAT.NONE and DeadText(statusBar.unit)

    if (BothStatusText() and statusBar.LeftText and statusBar.RightText) then
        local leftText, rightText = FormatBothText(format, value, valueMax, percent, deadText)
        statusBar.LeftText:SetText(leftText)
        statusBar.RightText:SetText(rightText)
    else
        textString:SetText(FormatText(format, value, valueMax, percent, deadText))
    end
end

local function UpdateStatusBarText(config, statusBar, textString, value, valueMax)
    local percent = value and (value / valueMax) * 100 or 100

    if (statusBar.lockShow > 0) then
        SetStatusBarText(config, statusBar, textString, value, valueMax, percent, KEY.HOVER, true)
    elseif (percent >= 99.95) then
        SetStatusBarText(config, statusBar, textString, value, valueMax, percent, KEY.FULL)
    elseif (percent < 0.05) then
        SetStatusBarText(config, statusBar, textString, value, valueMax, percent, KEY.ZERO)
    else
        SetStatusBarText(config, statusBar, textString, value, valueMax, percent, KEY.BASE)
    end
end

local function UpdateTextStringWithValues(statusBar, textString, value, _, valueMax)
    if (not statusBar.pauseUpdates and valueMax and valueMax > 0) then
        local statusBarConfig = configCache[statusBar]
        if (statusBarConfig) then
            local powerType = statusBar.powerType ~= nil and statusBar.powerType > 0 and POWER_TYPE.SECONDARY or POWER_TYPE.PRIMARY
            local config = statusBarConfig[powerType]
            if (config) then
                UpdateStatusBarText(config, statusBar, textString, value, valueMax)
            end
        end
    end
end

local function UpdateToTTextString(statusBar)
    if (statusBar.TextCT and not statusBar.pauseUpdates) then
        local _, valueMax = statusBar:GetMinMaxValues();

        if (statusBar.forceHideText or not valueMax or valueMax <= 0) then
            HideToTText(statusBar)
        else
            local value = statusBar:GetValue();
            ShowToTText(statusBar, BothStatusText())
            UpdateTextStringWithValues(statusBar, statusBar.TextCT, value, nil, valueMax)
        end
    end
end

local function OnEnterToTStatuBar(statusBar)
    statusBar.lockShow = statusBar.lockShow + 1
    UpdateToTTextString(statusBar);
end

local function OnLeaveToTStatuBar(statusBar)
    if (statusBar.lockShow > 0) then
        statusBar.lockShow = statusBar.lockShow - 1;
    end
    UpdateToTTextString(statusBar);
end

local function HideDeadTexts(hide, unitData, statusBar, baseFrame)
    local update

    if (statusBar.DeadText) then
        ct:HideOnShow(hide, statusBar.DeadText)
        update = true
    end

    if (statusBar.UnconsciousText) then
        ct:HideOnShow(hide, statusBar.UnconsciousText)
        update = true
    end

    if (update and unitData.UpdateDeadText) then
        unitData.UpdateDeadText(baseFrame)
    end
end

function ct.SetStatusBarFormat(unitData, type, key, disable)
    local StatusBar = type == ns.TYPE.HEALTH and unitData.HealthBar or unitData.ManaBar
    local powerType = type == ns.TYPE.POWER and POWER_TYPE.SECONDARY or POWER_TYPE.PRIMARY

    local Handler = function (statusBar)
        CacheStatusBarConfig(statusBar, unitData.unit, type, powerType, key, disable)
    end

    if (unitData.totFrame) then
        ns.ToggleToTStatusText(disable, type, StatusBar, OnEnterToTStatuBar, OnLeaveToTStatuBar)
    end

    ct.Handle(unitData, StatusBar, Handler, function (baseFrame, statusBar)
        HideDeadTexts(not disable, unitData, statusBar, baseFrame)
        TextStatusBar_UpdateTextString(statusBar)
    end)
end

function ct:StatusBarFormatHooks(unhook)
    if (unhook) then
        self:Unhook("TextStatusBar_UpdateTextStringWithValues")
        self:Unhook("TextStatusBar_UpdateTextString")
    else
        self:HookSafe("TextStatusBar_UpdateTextStringWithValues", UpdateTextStringWithValues)
        self:HookSafe("TextStatusBar_UpdateTextString", UpdateToTTextString)
    end
end

local function SetHealthBarTextsFont(baseFrame)
    local fontObject = ns.FontObjectBy(baseFrame.unit, ns.TYPE.HEALTH)
    ns.SetStatusBarTextsFonts(baseFrame.healthbar, fontObject)
end

function ct.SetStatusBarFont(unitData, type, _, fontObject)
    local StatusBar = type == ns.TYPE.HEALTH and unitData.HealthBar or unitData.ManaBar
    fontObject = fontObject or ns.FontObjectBy(unitData.unit, type)

    ct.Handle(unitData, StatusBar, function (statusBar, baseFrame)
        if (unitData.HealthBarSetFontAfter) then
            local setFontAfter, object = unitData.HealthBarSetFontAfter(baseFrame)
            ct:Rehook(object, setFontAfter, SetHealthBarTextsFont)
        end

        ns.SetStatusBarTextsFonts(statusBar, fontObject)
    end)
end

function ct.SetStatusBarTextColor(unitData, type, _, default)
    local StatusBar = type == ns.TYPE.HEALTH and unitData.HealthBar or unitData.ManaBar
    local r, g, b, a = ns.Color(unitData.unit, type, default)

    ct.Handle(unitData, StatusBar, function (statusBar)
        ns.SetAllStatusBarTextsColor(statusBar, r, g, b, a)
    end)
end

function ct:SetStatusBarsFormats(unitData, skipDefault, disable)
    local unit = unitData.unit

    for _, type in pairs(ns.TYPES_STATUS_BAR) do
        self.SetStatusBarFormat(unitData, type, nil, disable)

        if (type ~= ns.TYPE.POWER) then
            local fontObject = ns.FontObjectBy(unit, type, skipDefault, disable)

            if (fontObject) then
                self.SetStatusBarFont(unitData, type, nil, fontObject)
            end

            if (not skipDefault or ns.NotDefaultBy(unit, type, KEY.COLOR)) then
                self.SetStatusBarTextColor(unitData, type, nil, disable)
            end
        end
    end
end
