local addonName, ns = ...
local ct = LibStub("AceAddon-3.0"):GetAddon(addonName)
local UnitClass, UnitIsPlayer, UnitPlayerControlled, UnitIsTapDenied, UnitIsConnected, UnitSelectionColor, GetClassColor = UnitClass, UnitIsPlayer, UnitPlayerControlled, UnitIsTapDenied, UnitIsConnected, UnitSelectionColor, GetClassColor

local colorCache = {}

local function CacheColoredHealthbar(healthbar, key, classUnit)
    local config = colorCache[healthbar]

    if (config) then
        config[key] = true
        config.classUnit = classUnit
    else
        colorCache[healthbar] = { [key] = true, classUnit = classUnit }
    end
end

local function ClearColoredHealthbar(healthbar, key)
    local config = colorCache[healthbar]

    if (config) then
        config[key] = nil
    end
end

local function SetHealthbarClassColor(healthbar, unit)
    local r, g, b = GetClassColor(select(2, UnitClass(unit)))
    healthbar:SetStatusBarColor(r, g, b, 1)
    healthbar:SetStatusBarDesaturated(true)
end

local function SetHealthbarReactionColor(healthbar, unit)
    if (UnitIsTapDenied(unit)) then
        healthbar:SetStatusBarColor(0.5, 0.5, 0.5, 1)
    else
        healthbar:SetStatusBarColor(UnitSelectionColor(unit))
    end
    healthbar:SetStatusBarDesaturated(true)
end

local function SetHealthbarDefaultColor(healthbar, unit)
    if (healthbar.lockColor or UnitIsConnected(unit)) then
        healthbar:SetStatusBarColor(1, 1, 1, 1)
        healthbar:SetStatusBarDesaturated(false)
    else
        healthbar:SetStatusBarColor(0.5, 0.5, 0.5, 1);
        healthbar:SetStatusBarDesaturated(true)
    end
end

local function ColorHealthbar(healthbar, unit)
    if (unit ~= healthbar.unit) then
        return
    end

    local config = colorCache[healthbar]

    if (config) then
        local classUnit = config.classUnit or unit
        if (config[ns.KEY.COLOR_CLASS] and UnitIsPlayer(classUnit)) then
            SetHealthbarClassColor(healthbar, classUnit)
        elseif (config[ns.KEY.COLOR_REACTION] and not UnitPlayerControlled(unit)) then
            SetHealthbarReactionColor(healthbar, unit)
        else
            SetHealthbarDefaultColor(healthbar, unit)
        end
    end
end

local function ColorFrameHealthBar(baseFrame)
    ColorHealthbar(baseFrame.healthbar, baseFrame.unit)
end

local function ToggleColoredHealthbar(unitData, key, cacheKey, partyPet, HealthBar, Update, ClassUnit)
    cacheKey, ClassUnit = cacheKey or key, ClassUnit or unitData.ClassUnit
    local enabled = ns.GetDBBy(unitData.unit, ns.TYPE.HP_BAR, key)

    ct:HookSafeIf(enabled, "UnitFrameHealthBar_Update", ColorHealthbar)

    local Handler = function(healthbar, baseFrame)
        if (not partyPet and unitData.HealthBarRecolorAfter) then
            local recolorAfter, object = unitData.HealthBarRecolorAfter(baseFrame)
            ct:RehookOrUnhook(enabled, object, recolorAfter, ColorFrameHealthBar)
        end

        if (enabled) then
            local classUnit = ClassUnit and unitData.group and ClassUnit(baseFrame) or ClassUnit
            CacheColoredHealthbar(healthbar, cacheKey, classUnit)
        else
            ClearColoredHealthbar(healthbar, cacheKey)
        end
    end

    ct.Handle(unitData, HealthBar or unitData.HealthBar, Handler, Update or unitData.UpdateHealthBar)
end

function ct.ToggleClassColoredHealthbar(unitData)
    ToggleColoredHealthbar(unitData, ns.KEY.COLOR_CLASS)
end

function ct.ToggleClassColoredPartyPetHealthbar(unitData)
    ToggleColoredHealthbar(unitData, ns.KEY.COLOR_CLASS_PP, ns.KEY.COLOR_CLASS, true, unitData.PetHealthBar, unitData.UpdatePetHealthBar, unitData.PetClassUnit)
end

function ct.ToggleReactionColoredHealthbar(unitData)
    ToggleColoredHealthbar(unitData, ns.KEY.COLOR_REACTION)
end

function ct.SetupHealthbarColors(unitData, skipDefault)
    local unit = unitData.unit

    for _, option in pairs(ns.OPTIONS[ns.TYPE.HP_BAR]) do
        if (ns.Enabled(unit, option)) then

            if (not skipDefault or ns.NotDefault(unit, option)) then
                option.Handler(unitData, option.type, option.key)
            end
        end
    end
end
