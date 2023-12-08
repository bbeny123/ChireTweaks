local addonName, ns = ...
local ct = LibStub("AceAddon-3.0"):GetAddon(addonName)

local function DefaultOrOppositeFor(default, ...)
    local defaultOrOppositeFor = { default = default }

    for _, v in ipairs { ... } do
        defaultOrOppositeFor[v] = not default
    end

    return defaultOrOppositeFor
end

local function DefaultFormat(unit, option)
    local statusTextCVar = ns.GetStatusTextCVarRaw()

    if (option.type == ns.TYPE.HEALTH and option.key == ns.KEY.ZERO and unit ~= ns.UNIT.PLAYER and unit ~= ns.UNIT.PET) then
        return ns.FORMAT_DEAD
    elseif ((statusTextCVar == ns.CVAR_STATUS_TEXT.NONE and option.key ~= ns.KEY.HOVER) or unit == ns.UNIT.TOT or unit == ns.UNIT.TOF) then
        return ns.FORMAT.NONE
    elseif (statusTextCVar == ns.CVAR_STATUS_TEXT.PERCENT) then
        return ns.FORMAT.PERCENT
    elseif (statusTextCVar == ns.CVAR_STATUS_TEXT.NUMERIC or statusTextCVar == ns.CVAR_STATUS_TEXT.NONE) then
        return ns.FORMAT.CURRENT_MAX
    elseif (option.type == ns.TYPE.POWER) then
        return ns.FORMAT.CURRENT
    else
        return ns.FORMAT.CURRENT_PERCENT
    end
end

local function DefaultSize(unit, option)
    return option.type == ns.TYPE.HEALTH and unit == ns.UNIT.FOCUS and ns.UNIT_DATA[ns.UNIT.FOCUS].SmallSize()
            and ns.DEFAULT_SIZE_LARGE
            or ns.DEFAULT_SIZE
end

local function BaseOption(type, key, Handler, default, enabled, disabledValue)
    return {
        type = type,
        key = key,
        db = type .. key,
        Handler = Handler,
        default = default,
        enabled = enabled,
        disabledValue = disabledValue,
    }
end

local function AddBaseOption(options, type, key, Handler, default, enabled, disabledValue)
    options[key] = BaseOption(type, key, Handler, default, enabled, disabledValue)
end

local function AddToggleableOption(options, type, key, Handler, enabled, default)
    local option = BaseOption(type, key, Handler, ns.Nvl(default, false), enabled)
    options[key] = option
    table.insert(ns.OPTIONS_SORTED[type], option)
end

local function OptionsStatusText(type, fontEnabled)
    local options = {}

    AddBaseOption(options, type, ns.KEY.BASE, ct.SetStatusBarFormat, DefaultFormat)
    AddBaseOption(options, type, ns.KEY.FULL, ct.SetStatusBarFormat, DefaultFormat)
    AddBaseOption(options, type, ns.KEY.ZERO, ct.SetStatusBarFormat, DefaultFormat)
    AddBaseOption(options, type, ns.KEY.HOVER, ct.SetStatusBarFormat, DefaultFormat)
    AddBaseOption(options, type, ns.KEY.FONT, ct.SetStatusBarFont, ns.DEFAULT_FONT, fontEnabled)
    AddBaseOption(options, type, ns.KEY.STYLE, ct.SetStatusBarFont, ns.STYLE.OUTLINE, fontEnabled)
    AddBaseOption(options, type, ns.KEY.COLOR, ct.SetStatusBarTextColor, ns.HEX_WHITE, fontEnabled)
    AddBaseOption(options, type, ns.KEY.SIZE, ct.SetStatusBarFont, DefaultSize, fontEnabled)

    return options
end

local function OptionsNameOrLevelBase(type, ShowHandler, FontHandler, ColorHandler, enabled)
    local options = {}

    AddBaseOption(options, type, ns.KEY.SHOW, ShowHandler, true, enabled)
    AddBaseOption(options, type, ns.KEY.FONT, FontHandler, ns.DEFAULT_FONT, enabled)
    AddBaseOption(options, type, ns.KEY.STYLE, FontHandler, ns.STYLE.NONE, enabled)
    AddBaseOption(options, type, ns.KEY.COLOR, ColorHandler, ns.HEX_YELLOW, enabled)
    AddBaseOption(options, type, ns.KEY.SIZE, FontHandler, ns.DEFAULT_SIZE, enabled)

    return options
end

local function OptionsName(type)
    local options = OptionsNameOrLevelBase(type, ct.ToggleName, ct.SetNameFont, ct.SetNameColor)

    AddBaseOption(options, type, ns.KEY.NAME_CENTERED, ct.ToggleNameCentered, false)

    return options
end

local function OptionsLevel(type)
    local options = OptionsNameOrLevelBase(type, ct.ToggleLevel, ct.SetLevelFont, ct.SetLevelColor,
            DefaultOrOppositeFor(false, ns.UNIT.PLAYER, ns.UNIT.TARGET, ns.UNIT.FOCUS, ns.UNIT.BOSS))

    AddBaseOption(options, type, ns.KEY.COLOR_LEVEL, ct.SetLevelColor, true,
            DefaultOrOppositeFor(false, ns.UNIT.TARGET, ns.UNIT.FOCUS, ns.UNIT.BOSS), false)

    return options
end

local function OptionsHealthbar(type)
    local options = {}

    AddToggleableOption(options, type, ns.KEY.COLOR_CLASS,
            ct.ToggleClassColoredHealthbar,
            DefaultOrOppositeFor(true, ns.UNIT.BOSS))
    AddToggleableOption(options, type, ns.KEY.COLOR_CLASS_PP,
            ct.ToggleClassColoredPartyPetHealthbar,
            DefaultOrOppositeFor(false, ns.UNIT.PARTY))
    AddToggleableOption(options, type, ns.KEY.COLOR_REACTION,
            ct.ToggleReactionColoredHealthbar,
            DefaultOrOppositeFor(true, ns.UNIT.PLAYER, ns.UNIT.PET, ns.UNIT.PARTY, ns.UNIT.BG))

    return options
end

local function OptionsHide(type)
    local options = {}

    AddToggleableOption(options, type, ns.KEY.ICON_REST,
            ct.ToggleRestIcon,
            DefaultOrOppositeFor(false, ns.UNIT.PLAYER))
    AddToggleableOption(options, type, ns.KEY.ICON_CORNER,
            ct.TogglePlayerCornerOrCombatIcon,
            DefaultOrOppositeFor(false, ns.UNIT.PLAYER))
    AddToggleableOption(options, type, ns.KEY.ICON_COMBAT,
            ct.TogglePlayerCornerOrCombatIcon,
            DefaultOrOppositeFor(false, ns.UNIT.PLAYER))
    AddToggleableOption(options, type, ns.KEY.ICON_ROLE,
            ct.ToggleRoleIcon,
            DefaultOrOppositeFor(false, ns.UNIT.PLAYER, ns.UNIT.PARTY))
    AddToggleableOption(options, type, ns.KEY.ICON_LEADER,
            ct.ToggleLeaderIcon,
            DefaultOrOppositeFor(false, ns.UNIT.PLAYER, ns.UNIT.TARGET, ns.UNIT.FOCUS, ns.UNIT.PARTY))
    AddToggleableOption(options, type, ns.KEY.ICON_GUIDE,
            ct.ToggleGuideIcon,
            DefaultOrOppositeFor(false, ns.UNIT.PLAYER, ns.UNIT.TARGET, ns.UNIT.FOCUS, ns.UNIT.PARTY))
    AddToggleableOption(options, type, ns.KEY.INDICATOR_GROUP,
            ct.ToggleGroupIndicator,
            DefaultOrOppositeFor(false, ns.UNIT.PLAYER))
    AddToggleableOption(options, type, ns.KEY.ICON_PVP,
            ct.TogglePVPIcon,
            DefaultOrOppositeFor(true, ns.UNIT.PET, ns.UNIT.TOT, ns.UNIT.TOF, ns.UNIT.BOSS))
    AddToggleableOption(options, type, ns.KEY.TIMER_PVP,
            ct.TogglePVPTimer,
            DefaultOrOppositeFor(false, ns.UNIT.PLAYER))
    AddToggleableOption(options, type, ns.KEY.ICON_BOSS,
            ct.ToggleBossIcon,
            DefaultOrOppositeFor(false, ns.UNIT.TARGET, ns.UNIT.FOCUS, ns.UNIT.BOSS))
    AddToggleableOption(options, type, ns.KEY.ICON_QUEST,
            ct.ToggleQuestIcon,
            DefaultOrOppositeFor(false, ns.UNIT.TARGET, ns.UNIT.FOCUS, ns.UNIT.BOSS))
    AddToggleableOption(options, type, ns.KEY.ICON_PET_BATTLE,
            ct.ToggleBattlePetIcon,
            DefaultOrOppositeFor(false, ns.UNIT.TARGET, ns.UNIT.FOCUS))
    AddToggleableOption(options, type, ns.KEY.ICON_RAID,
            ct.ToggleRaidIcon,
            DefaultOrOppositeFor(false, ns.UNIT.PLAYER, ns.UNIT.TARGET, ns.UNIT.FOCUS, ns.UNIT.BOSS),
            DefaultOrOppositeFor(false, ns.UNIT.PLAYER))
    AddToggleableOption(options, type, ns.KEY.INDICATOR_HIT,
            ct.ToggleHitIndicator,
            DefaultOrOppositeFor(false, ns.UNIT.PLAYER, ns.UNIT.PET))
    AddToggleableOption(options, type, ns.KEY.GLOW_REPUTATION,
            ct.ToggleReputationGlow,
            DefaultOrOppositeFor(false, ns.UNIT.TARGET, ns.UNIT.FOCUS, ns.UNIT.BOSS))
    AddToggleableOption(options, type, ns.KEY.GLOW_STATIC_DEBUFF,
            ct.ToggleDebuffGlow,
            DefaultOrOppositeFor(false, ns.UNIT.PARTY))
    AddToggleableOption(options, type, ns.KEY.GLOW_THREAT,
            ct.ToggleThreatGlow,
            DefaultOrOppositeFor(true, ns.UNIT.TOT, ns.UNIT.TOF, ns.UNIT.BG))
    AddToggleableOption(options, type, ns.KEY.GLOW_THREAT_PP,
            ct.TogglePartyPetThreatGlow,
            DefaultOrOppositeFor(false, ns.UNIT.PARTY))
    AddToggleableOption(options, type, ns.KEY.GLOW_BLINKING_COMBAT,
            ct.ToggleCombatGlow,
            DefaultOrOppositeFor(false, ns.UNIT.PLAYER, ns.UNIT.PET))
    AddToggleableOption(options, type, ns.KEY.GLOW_BLINKING_REST,
            ct.TogglePlayerBlinkingGlow,
            DefaultOrOppositeFor(false, ns.UNIT.PLAYER))

    return options
end

ns.OPTIONS_SORTED = {
    [ns.TYPE.HIDE] = {},
    [ns.TYPE.HP_BAR] = {},
}

ns.OPTIONS = {
    [ns.TYPE.HEALTH] = OptionsStatusText(ns.TYPE.HEALTH),
    [ns.TYPE.MANA] = OptionsStatusText(ns.TYPE.MANA),
    [ns.TYPE.POWER] = OptionsStatusText(ns.TYPE.POWER, DefaultOrOppositeFor(false)),
    [ns.TYPE.NAME] = OptionsName(ns.TYPE.NAME),
    [ns.TYPE.LEVEL] = OptionsLevel(ns.TYPE.LEVEL),
    [ns.TYPE.HP_BAR] = OptionsHealthbar(ns.TYPE.HP_BAR),
    [ns.TYPE.HIDE] = OptionsHide(ns.TYPE.HIDE),
    [ns.TYPE.CHAT] = {
    },
}
