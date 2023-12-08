local addonName, ns = ...
local ct = LibStub("AceAddon-3.0"):GetAddon(addonName)
local UnitCanAttack, GetDifficultyColor, GetContentDifficulty = UnitCanAttack, GetDifficultyColor, C_PlayerInfo.GetContentDifficultyCreatureForPlayer

local function RecenterLevel(unitData, baseFrame, levelFrame)
    levelFrame:SetHeight(12)
    levelFrame:SetPoint(unitData.LevelPointCentered(baseFrame))

    if (unitData.levelJustify) then
        levelFrame:SetJustifyH(unitData.levelJustify)
    end

    if (unitData.LevelHighPointCentered) then
        local highLevelFrame = unitData.group and unitData.HighLevel(baseFrame) or unitData.HighLevel
        highLevelFrame:SetPoint(unitData.LevelHighPointCentered(baseFrame))
    end

    unitData.levelCentered = true
end

function ct.SetLevelFont(unitData, _, _, fontObject)
    fontObject = fontObject or ns.FontObjectBy(unitData.unit, ns.TYPE.LEVEL)

    local recenter = not unitData.levelCentered and ns.NotDefaultBy(unitData.unit, ns.TYPE.LEVEL, ns.KEY.SIZE)

    ct.Handle(unitData, unitData.Level, function (text, baseFrame)
        ns.SetFont(text, fontObject)

        if (recenter) then
            RecenterLevel(unitData, baseFrame, text)
        end
    end)
end

local function SetLevelColor(baseFrame, levelFrame, dynamicColor, r, g, b, a)
    if (dynamicColor and UnitCanAttack("player", baseFrame.unit)) then
        local difficulty = GetContentDifficulty(baseFrame.unit)
        local color = GetDifficultyColor(difficulty);
        r, g, b = color.r, color.g, color.b
    end

    ns.SetColor(levelFrame, r, g, b, a)
end

function ct.SetLevelColor(unitData)
    local r, g, b, a = ns.Color(unitData.unit, ns.TYPE.LEVEL)
    local dynamicColor = ns.GetDBByIfEnabled(unitData.unit, ns.TYPE.LEVEL, ns.KEY.COLOR_LEVEL)

    ct.Handle(unitData, unitData.Level, function (levelFrame, baseFrame)
        if (unitData.LevelRecolorAfter) then
            local recolorAfter, object = unitData.LevelRecolorAfter(baseFrame)
            ct:Rehook(object, recolorAfter, function ()
                SetLevelColor(baseFrame, levelFrame, dynamicColor, r, g, b, a)
            end)
        end

        SetLevelColor(baseFrame, levelFrame, dynamicColor, r, g, b, a)
    end)
end

function ct.ToggleLevel(unitData, _, _, hide, skipNameRecenter)
    if (hide == nil) then
        hide = not ns.GetDBBy(unitData.unit, ns.TYPE.LEVEL, ns.KEY.SHOW)
    end

    ct.ShowLevelHiddenByRoleIcon(unitData)

    if (unitData.HighLevel) then
        ct:HideOnShowAndUpdate(unitData, hide, unitData.HighLevel, hide and ns.HideFrame)
    end

    ct:HideOnShowAndUpdate(unitData, hide, unitData.Level, hide and ns.HideFrame or unitData.LevelShow)

    if (not hide) then
        ct.SetLevelFont(unitData)
        ct.SetLevelColor(unitData)
    end

    if (not skipNameRecenter and ns.GetDBBy(unitData.unit, ns.TYPE.NAME, ns.KEY.SHOW) and ns.GetDBBy(unitData.unit, ns.TYPE.NAME, ns.KEY.NAME_CENTERED)) then
        ct.ToggleNameCentered(unitData)
    end
end

function ct:SetupLevel(unitData, skipDefault)
    local unit, type = unitData.unit, ns.TYPE.LEVEL
    local visible = ns.GetDBBy(unit, ns.TYPE.LEVEL, ns.KEY.SHOW)

    if (not skipDefault or not visible) then
        self.ToggleLevel(unitData, nil, nil, not visible, true)
    else
        local fontObject = ns.FontObjectBy(unit, type, true)
        if (fontObject) then
            self.SetLevelFont(unitData, nil, nil, fontObject)
        end

        if (ns.NotDefaultBy(unit, type, ns.KEY.COLOR) or ns.NotDefaultBy(unit, type, ns.KEY.COLOR_LEVEL)) then
            self.SetLevelColor(unitData)
        end
    end
end
