local addonName, ns = ...
local L = LibStub("AceLocale-3.0"):NewLocale(addonName, "enUS", true, "raw")

function ns.Desc(key)
    return key .. ".desc"
end

function ns.Alt(key)
    return key .. ".alt"
end

local function Gap(width)
    return (" "):rep(width)
end

L[addonName] = "Chire Tweaks"

L["colorPicker.invalid"] = "Enter a valid hex color code\n(#RRGGBB or #AARRGGBB)\nor use the color picker.\n\nDefault color: #%s"
L["colorPicker"] = "Color picker"
L[ns.Desc("colorPicker")] = "Choose a color by either using picker or typing its hexadecimal code into the field on the left (#AARRBBGG, #RRBBGG)\n\nIt can also be reset to default color (#%s) using the button on the right."

L["offset.invalid"] = "Enter valid number\n\nExample valid point: -420.69"

L["button.reset"] = "Reset to default"
L["button.copy"] = "Copy"

L["copy.from"] = "Copy settings from:"
L["copy.to"] = "Copy settings to:"

L["statusText"] = "Status text:"
L[ns.Desc("statusText")] = "Global setting, affects all unit frames.\n\nSame as: Options -> Game -> Gameplay -> Interface -> Display -> Status Text"

L["tab.desc"] = "Customize %s Unit Frame"

L["nameLevel.header.name"] = "Name"
L["nameLevel.header.nameLevel"] = "Name & Level"
L["formats.header"] = "Status Bars Text - Format & Font"

L["castbar.header.name"] = "Castbar"

L[ns.TYPE.HEALTH] = "Health"
L[ns.TYPE.MANA] = "Mana"
L[ns.TYPE.POWER] = "Other resources"
L[ns.TYPE.NAME] = "Name"
L[ns.Desc(ns.TYPE.NAME)] = "Show %s name"
L[ns.TYPE.LEVEL] = "Level"
L[ns.Desc(ns.TYPE.LEVEL)] = "Show %s level"
L[ns.TYPE.HP_BAR] = "Healthbar color"
L[ns.TYPE.HIDE] = "Icons & Indicators & Glow effects"
L[ns.TYPE.CASTBAR] = "Castbar"
L[ns.Desc(ns.TYPE.CASTBAR)] = "Move castbar.\n\nWorks only with the attached castbar."
L[ns.TYPE.CASTBAR_TIMER] = "Timer"
L[ns.Desc(ns.TYPE.CASTBAR_TIMER)] = "Show cast time"
L[ns.TYPE.CHAT] = "Chat"

L[ns.UNIT.PLAYER] = "Player"
L[ns.UNIT.PET] = "Player Pet"
L[ns.UNIT.TARGET] = "Target"
L[ns.UNIT.TOT] = "Target of Target"
L[ns.UNIT.FOCUS] = "Focus"
L[ns.UNIT.TOF] = "Target of Focus"
L[ns.UNIT.BOSS] = "Boss"
L[ns.UNIT.BG] = "BG Flag Carrier"
L[ns.UNIT.PARTY] = "Party"
L[ns.UNIT.ALL] = "All"

L[ns.CVAR_STATUS_TEXT.NUMERIC] = "Centered"
L[ns.CVAR_STATUS_TEXT.PERCENT] = "Percentage"
L[ns.CVAR_STATUS_TEXT.BOTH] = "On the sides"
L[ns.CVAR_STATUS_TEXT.NONE] = "None"

L[ns.DEAD] = "Dead"
L[ns.GHOST] = "Ghost"
L[ns.UNCONSCIOUS] = "Unconscious"

L[ns.FORMAT.NONE] = "None"
L[ns.FORMAT.CURRENT] = "Current"
L[ns.FORMAT.CURRENT_MAX] = "Current / Max"
L[ns.FORMAT.PERCENT] = "Percent"
L[ns.FORMAT.CURRENT_PERCENT] = "Current – Percent"
L[ns.FORMAT.CURRENT_MAX_PERCENT] = "Current / Max (Percent)"
L[ns.FORMAT_DEAD] = "Dead/Ghost"

L[ns.Alt(ns.FORMAT.NONE)] = "None"
L[ns.Alt(ns.FORMAT.CURRENT)] = Gap(27) .. "Current"
L[ns.Alt(ns.FORMAT.CURRENT_MAX)] = Gap(17) .. "Current / Max"
L[ns.Alt(ns.FORMAT.PERCENT)] = "Percent" .. Gap(28)
L[ns.Alt(ns.FORMAT.CURRENT_PERCENT)] = "Percent" .. Gap(16) .. "Current"
L[ns.Alt(ns.FORMAT.CURRENT_MAX_PERCENT)] = "Percent" .. Gap(6) .. "Current / Max"

L[ns.STYLE.NONE] = "None"
L[ns.STYLE.OUTLINE] = "Outline"
L[ns.STYLE.THICK_OUTLINE] = "Thick Outline"
L[ns.STYLE.MONOCHROME] = "Monochrome"
L[ns.STYLE.OUTLINE_MONOCHROME] = "Outline Monochrome"
L[ns.STYLE.THICK_OUTLINE_MONOCHROME] = "Thick Outline Monochrome"

L[ns.KEY.BASE] = "Base"
L[ns.KEY.HOVER] = "Hover"
L[ns.KEY.FULL] = "100%"
L[ns.KEY.ZERO] = "Zero"
L[ns.KEY.FONT] = "Font"
L[ns.KEY.STYLE] = "Style"
L[ns.KEY.SIZE] = "Size"
L[ns.KEY.COLOR] = "Color"
L[ns.KEY.X] = "Point"

L[ns.KEY.ICON] = "Show icon"
L[ns.Desc(ns.KEY.ICON)] = "Show castbar icon"
L[ns.KEY.COLOR_LEVEL] = "Dynamic color"
L[ns.Desc(ns.KEY.COLOR_LEVEL)] = "By default, the level color depends on the level of the enemy"
L[ns.KEY.COLOR_CLASS] = "Enable class colored healthbar"
L[ns.KEY.COLOR_CLASS_PP] = "Enable class colored pet healthbar"
L[ns.KEY.COLOR_REACTION] = "Enable reaction colored healthbar"
L[ns.KEY.NAME_CENTERED] = "Centered"
L[ns.Desc(ns.KEY.NAME_CENTERED)] = "Move name to the center."
L[ns.KEY.GLOW_REPUTATION] = "Hide reaction color glow"
L[ns.Desc(ns.KEY.GLOW_REPUTATION)] = "Hide colorful glow under name & level"
L[ns.KEY.GLOW_BLINKING_REST] = "Hide blinking yellow glow while resting"
L[ns.KEY.GLOW_BLINKING_COMBAT] = "Hide blinking red glow while in combat"
L[ns.KEY.GLOW_THREAT] = "Hide threat glow"
L[ns.KEY.GLOW_THREAT_PP] = "Hide pet threat glow"
L[ns.KEY.GLOW_STATIC_DEBUFF] = "Hide debuff glow"
L[ns.KEY.INDICATOR_GROUP] = "Hide group number indicator"
L[ns.KEY.INDICATOR_HIT] = "Hide portrait damage/heal indicator"
L[ns.KEY.ICON_REST] = "Hide rest animated icon"
L[ns.Desc(ns.KEY.ICON_REST)] = "Hide animated 'zZz' from above player portrait"
L[ns.KEY.ICON_CORNER] = "Hide corner icon"
L[ns.KEY.ICON_COMBAT] = "Hide combat icon"
L[ns.KEY.ICON_ROLE] = "Hide role icon"
L[ns.KEY.ICON_LEADER] = "Hide leader icon"
L[ns.KEY.ICON_GUIDE] = "Hide dungeon guide icon"
L[ns.KEY.ICON_RAID] = "Hide raid marker"
L[ns.Desc(ns.KEY.ICON_RAID)] = "Hide raid marker from above portrait"
L[ns.KEY.ICON_BOSS] = "Hide rare icon"
L[ns.Desc(ns.KEY.ICON_BOSS)] = "Hide the small round star icon at the bottom of the portrait"
L[ns.KEY.ICON_QUEST] = "Hide quest icon"
L[ns.Desc(ns.KEY.ICON_QUEST)] = "Hide the small round quest icon at the bottom of the portrait"
L[ns.KEY.ICON_PET_BATTLE] = "Hide pet battle icon"
L[ns.KEY.ICON_PVP] = "Hide PVP badge/icon"
L[ns.KEY.TIMER_PVP] = "Hide PVP timer"
