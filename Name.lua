local addonName, ns = ...
local ct = LibStub("AceAddon-3.0"):GetAddon(addonName)

function ct.SetNameFont(unitData, _, _, fontObject)
    fontObject = fontObject or ns.FontObjectBy(unitData.unit, ns.TYPE.NAME)

    ct.Handle(unitData, unitData.Name, function(text)
        ns.SetFont(text, fontObject)
    end)
end

function ct.SetNameColor(unitData)
    local r, g, b, a = ns.Color(unitData.unit, ns.TYPE.NAME)

    ct.Handle(unitData, unitData.Name, function (nameFrame)
        ns.SetColor(nameFrame, r, g, b, a)
    end)
end

local function ResetNamePointIfApplicable(unitData, baseFrame, nameFrame)
    if (unitData.NamePointDefault) then
        nameFrame:SetPoint(unitData.NamePointDefault(baseFrame))
    end
end

local function ResetNamePosition(unitData, baseFrame, nameFrame)
    nameFrame:SetJustifyH("LEFT")
    nameFrame:SetWidth(unitData.nameWidthDefault)
    ResetNamePointIfApplicable(unitData, baseFrame, nameFrame)
end

local function CenterName(unitData, baseFrame, nameFrame, levelVisible)
    levelVisible = levelVisible and (not unitData.LevelVisible or unitData.LevelVisible())
    nameFrame:SetJustifyH("CENTER")

    if (levelVisible) then
        nameFrame:SetWidth(unitData.nameWidthCenteredShort or unitData.nameWidthDefault)

        if (unitData.NamePointCentered) then
            nameFrame:SetPoint(unitData.NamePointCentered(baseFrame))
        end
    else
        local width = unitData.NameWidthCentered and unitData.NameWidthCentered(baseFrame) or unitData.nameWidthCentered
        nameFrame:SetWidth(width)

        if (unitData.nameMoveToLevel) then
            nameFrame:SetPoint(unitData.LevelPointCentered(baseFrame))
        else
            ResetNamePointIfApplicable(unitData, baseFrame, nameFrame)
        end
    end
end

function ct.ToggleNameCentered(unitData)
    local center = ns.GetDBBy(unitData.unit, ns.TYPE.NAME, ns.KEY.NAME_CENTERED)
    local levelVisible = ns.GetDBByIfEnabled(unitData.unit, ns.TYPE.LEVEL, ns.KEY.SHOW)

    ct.Handle(unitData, unitData.Name, function (nameFrame, baseFrame)
        if (unitData.NameRecenterAfter) then
            local method, object = unitData.NameRecenterAfter(baseFrame)
            ct:RehookOrUnhook(center, object, method, function()
                CenterName(unitData, baseFrame, nameFrame, levelVisible)
            end)
        end

        if (center) then
            CenterName(unitData, baseFrame, nameFrame, levelVisible)
        else
            ResetNamePosition(unitData, baseFrame, nameFrame)
        end
    end)
end

function ct.ToggleName(unitData, _, _, hide)
    if (hide == nil) then
        hide = not ns.GetDBBy(unitData.unit, ns.TYPE.NAME, ns.KEY.SHOW)
    end

    ct:HideOnShowAndUpdate(unitData, hide, unitData.Name, ns.ShowFrame)

    if (not hide) then
        ct.SetNameFont(unitData)
        ct.SetNameColor(unitData)
        ct.ToggleNameCentered(unitData)
    end
end

function ct:SetupName(unitData, skipDefault)
    local unit, type = unitData.unit, ns.TYPE.NAME
    local visible = ns.GetDBBy(unit, type, ns.KEY.SHOW)

    if (not skipDefault or not visible) then
        self.ToggleName(unitData, nil, nil, not visible)
    else
        local fontObject = ns.FontObjectBy(unit, type, true)
        if (fontObject) then
            self.SetNameFont(unitData, nil, nil, fontObject)
        end

        if (ns.NotDefaultBy(unit, type, ns.KEY.COLOR)) then
            self.SetNameColor(unitData)
        end

        if (ns.NotDefaultBy(unit, type, ns.KEY.NAME_CENTERED)) then
            self.ToggleNameCentered(unitData)
        end
    end
end
