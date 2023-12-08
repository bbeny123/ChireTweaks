local _, ns = ...
local GetAtlasInfo = C_Texture.GetAtlasInfo

ns.RESET_ICON_ATLAS = GetAtlasInfo("common-icon-undo")
ns.APPLY_ICON_ATLAS = GetAtlasInfo("common-icon-checkmark-yellow")
ns.RAID_TARGET_ICON_TEXTURE = "Interface/TargetingFrame/UI-RaidTargetingIcons"

ns.DEFAULT_FONT = "Friz Quadrata TT"
ns.DEFAULT_SIZE = 10
ns.DEFAULT_SIZE_LARGE = 13

ns.HEX_WHITE = "FFFFFFFF"
ns.HEX_YELLOW = "FFFFD100"

ns.DEAD = "dead"
ns.GHOST = "ghost"
ns.UNCONSCIOUS = "unconscious"

ns.UNIT = {
    PLAYER = "player",
    PET = "pet",
    TARGET = "target",
    TOT = "targettarget",
    FOCUS = "focus",
    TOF = "focustarget",
    BOSS = "boss",
    BG = "bg",
    PARTY = "party",
    ALL = "all",
}

ns.CVAR = {
    STATUS_TEXT_DISPLAY = "statusTextDisplay",
    STATUS_TEXT = "statusText",
}

ns.CVAR_STATUS_TEXT = {
    NUMERIC = "NUMERIC",
    PERCENT = "PERCENT",
    BOTH = "BOTH",
    NONE = "NONE",
}

ns.POWER_TYPE = {
    PRIMARY = 0,
    SECONDARY = 1,
}

ns.FORMAT = {
    NONE = 1,
    CURRENT = 2,
    CURRENT_MAX = 3,
    PERCENT = 4,
    CURRENT_PERCENT = 5,
    CURRENT_MAX_PERCENT = 6,
}

ns.FORMAT_DEAD = 7

ns.STYLE = {
    NONE = "NONE",
    OUTLINE = "OUTLINE",
    THICK_OUTLINE = "THICKOUTLINE",
    MONOCHROME = "MONOCHROME",
    OUTLINE_MONOCHROME = "OUTLINE,MONOCHROME",
    THICK_OUTLINE_MONOCHROME = "THICKOUTLINE,MONOCHROME",
}

ns.TYPE = {
    HEALTH = "health",
    MANA = "mana",
    POWER = "power",
    NAME = "name",
    LEVEL = "level",
    HP_BAR = "healthbar",
    HIDE = "hide",
    CHAT = "chat",
}

ns.TYPES_STATUS_BAR = { ns.TYPE.HEALTH, ns.TYPE.MANA, ns.TYPE.POWER }

ns.KEY = {
    BASE = "FormatBase",
    FULL = "FormatFull",
    ZERO = "FormatZero",
    HOVER = "FormatHover",
    FONT = "TextFont",
    STYLE = "TextStyle",
    SIZE = "TextSize",
    COLOR = "TextColor",
    SHOW = "Show",
    NAME_CENTERED = "NameCentered",
    COLOR_LEVEL = "ColorLevel",
    COLOR_CLASS = "ColorClass",
    COLOR_CLASS_PP = "ColorClassPet",
    COLOR_REACTION = "ColorReaction",
    GLOW_REPUTATION = "ReputationGlow",
    GLOW_THREAT = "ThreatGlow",
    GLOW_THREAT_PP = "ThreatGlowPet",
    GLOW_BLINKING_REST = "RestGlow",
    GLOW_BLINKING_COMBAT = "CombatGlow",
    GLOW_STATIC_DEBUFF = "DebuffStaticGlow",
    INDICATOR_HIT = "HitIndicator",
    INDICATOR_GROUP = "GroupIndicator",
    ICON_CORNER = "CornerIcon",
    ICON_COMBAT = "CombatIcon",
    ICON_REST = "RestIcon",
    ICON_ROLE = "RoleIcon",
    ICON_GUIDE = "GuideIcon",
    ICON_LEADER = "LeaderIcon",
    ICON_RAID = "RaidTargetIcon",
    ICON_BOSS = "BossIcon",
    ICON_QUEST = "QuestIcon",
    ICON_PET_BATTLE = "PetBattleIcon",
    ICON_PVP = "PVPIcon",
    TIMER_PVP = "PVPTimer",
}

ns.WIDGET = {
    ICON = "ChireIcon",
    LABEL = "ChireLabel",
    SLIDER = "ChireSlider",
    EDIT_BOX = "ChireEditBox",
    COLOR_PICKER = "ChireColorPicker",
    FONT_SELECTOR = "ChireFontSelector"
}
