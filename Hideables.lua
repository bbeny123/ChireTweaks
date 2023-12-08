local addonName, ns = ...
local ct = LibStub("AceAddon-3.0"):GetAddon(addonName)
local GetRaidTargetIndex, SetRaidTargetIconTexture, UnitClassification, IsResting, atlasSize = GetRaidTargetIndex, SetRaidTargetIconTexture, UnitClassification, IsResting, TextureKitConstants.UseAtlasSize

local function Hidden(unitData, key)
    return ns.GetDBBy(unitData.unit, ns.TYPE.HIDE, key)
end

local function HideOnShowAndUpdate(unitData, key, Frame, Update, HideHook)
    ct:HideOnShowAndUpdate(unitData, Hidden(unitData, key), Frame, Update, HideHook)
end

function ct.ToggleRestIcon(unitData)
    HideOnShowAndUpdate(unitData, ns.KEY.ICON_REST, unitData.restIcon, unitData.UpdateStatus)
end

function ct.ToggleLeaderIcon(unitData)
    HideOnShowAndUpdate(unitData, ns.KEY.ICON_LEADER, unitData.LeaderIcon, unitData.UpdateLeader)
end

function ct.ToggleGuideIcon(unitData)
    HideOnShowAndUpdate(unitData, ns.KEY.ICON_GUIDE, unitData.GuideIcon, unitData.UpdateLeader)
end

function ct.ToggleBattlePetIcon(unitData)
    HideOnShowAndUpdate(unitData, ns.KEY.ICON_PET_BATTLE, unitData.petBattleIcon, unitData.UpdateBattlePet)
end

function ct.ToggleThreatGlow(unitData)
    HideOnShowAndUpdate(unitData, ns.KEY.GLOW_THREAT, unitData.ThreatGlow, unitData.BaseUpdate)
end

function ct.TogglePartyPetThreatGlow(unitData)
    HideOnShowAndUpdate(unitData, ns.KEY.GLOW_THREAT_PP, unitData.PetThreatGlow, unitData.PetBaseUpdate)
end

function ct.ToggleDebuffGlow(unitData)
    HideOnShowAndUpdate(unitData, ns.KEY.GLOW_STATIC_DEBUFF, unitData.DebuffGlow, unitData.Update)
end

function ct.ToggleReputationGlow(unitData)
    HideOnShowAndUpdate(unitData, ns.KEY.GLOW_REPUTATION, unitData.ReputationGlow, unitData.UpdateReputationGlow)
end

function ct.ToggleGroupIndicator(unitData)
    HideOnShowAndUpdate(unitData, ns.KEY.INDICATOR_GROUP, unitData.groupIndicator, unitData.UpdateGroupIndicator)
end

function ct.ToggleHitIndicator(unitData)
    HideOnShowAndUpdate(unitData, ns.KEY.INDICATOR_HIT, unitData.hitIndicator)
end

function ct.ShowLevelHiddenByRoleIcon(unitData)
    if (unitData.LevelShowAfter) then
        local showLevelAfter, object = unitData.LevelShowAfter()
        local hideRoleIcon, levelVisible = Hidden(unitData, ns.KEY.ICON_ROLE), ns.GetDBBy(unitData.unit, ns.TYPE.LEVEL, ns.KEY.SHOW)
        ct:RehookOrUnhook(hideRoleIcon and levelVisible, object, showLevelAfter, function ()
            unitData.Level:Show()
        end)
    end
end

function ct.ToggleRoleIcon(unitData)
    ct.ShowLevelHiddenByRoleIcon(unitData)
    HideOnShowAndUpdate(unitData, ns.KEY.ICON_ROLE, unitData.RoleIcon, unitData.UpdateRoles)
end

function ct.TogglePVPTimer(unitData)
    HideOnShowAndUpdate(unitData, ns.KEY.TIMER_PVP, unitData.pvpTimer, unitData.UpdatePVPTimer)
end

local function TogglePVPIcon(pvpIcon, hide)
    ct:HideOnShow(hide, pvpIcon)
end

function ct.TogglePVPIcon(unitData)
    local hide = Hidden(unitData, ns.KEY.ICON_PVP)
    local PVPIconHandler = function (pvpIcons)
        ns.ForEach(pvpIcons, TogglePVPIcon, hide)
    end

    ct.Handle(unitData, unitData.PVPIcons, PVPIconHandler, unitData.UpdatePVPStatus)
end

function ct.TogglePlayerCornerOrCombatIcon(unitData, _, key)
    local playerFrame = unitData.baseFrame
    local combatIcon, cornerIcon = unitData.combatIcon, unitData.cornerIcon
    local hideCombatIcon, hideCornerIcon = Hidden(unitData, ns.KEY.ICON_COMBAT), Hidden(unitData, ns.KEY.ICON_CORNER)

    if (key == ns.KEY.ICON_COMBAT) then
        ct:HideOnShow(hideCombatIcon, combatIcon)
    else
        ct:HideOnShow(hideCornerIcon, cornerIcon)
    end

    ct:RehookOrUnhook(hideCombatIcon and not hideCornerIcon, cornerIcon, "Hide", ns.Show)
    ct:RehookOrUnhook(hideCornerIcon and not hideCombatIcon, combatIcon, "Hide", function (frame)
        if (playerFrame.inCombat or playerFrame.onHateList) then
            frame:Show()
        end
    end)

    unitData.UpdateStatus()
end

local function HideCombatGlow(frame)
    if (not IsResting()) then
        frame:Hide()
    end
end

function ct.TogglePlayerBlinkingGlow(unitData)
    local hideRestGlow, hideCombatGlow = Hidden(unitData, ns.KEY.GLOW_BLINKING_REST), Hidden(unitData, ns.KEY.GLOW_BLINKING_COMBAT)
    local playerFrame = unitData.baseFrame
    local Handler

    if (hideRestGlow and not hideCombatGlow) then
        Handler = function(frame)
            if (playerFrame.inCombat) then
                frame:SetVertexColor(1.0, 0.0, 0.0, 1.0)
            elseif (IsResting()) then
                frame:Hide()
            end
        end
    elseif (hideCombatGlow and not hideRestGlow) then
        Handler = HideCombatGlow
    end

    ct:HideOnShowAndUpdate(unitData, hideRestGlow or hideCombatGlow, unitData.statusTexture, unitData.UpdateStatus, Handler)
end

function ct.ToggleCombatGlow(unitData)
    if (unitData.statusTexture) then
        ct.TogglePlayerBlinkingGlow(unitData)
    else
        HideOnShowAndUpdate(unitData, ns.KEY.GLOW_BLINKING_COMBAT, unitData.combatGlow)
    end
end

local function ShowBossIconHiddenByQuestIcon(frame)
    local classification = UnitClassification(frame.unit)
    if (classification == "rare" or classification == "rareelite") then
        local bossIcon = frame.TargetFrameContent.TargetFrameContentContextual.BossIcon;
        bossIcon:SetAtlas("UnitFrame-Target-PortraitOn-Boss-Rare-Star", atlasSize);
        bossIcon:Show();
    end
end

local function ToggleBossOrQuestIcon(unitData, key, Icon)
    local hideBossIcon, hideQuestIcon = Hidden(unitData, ns.KEY.ICON_BOSS), Hidden(unitData, ns.KEY.ICON_QUEST)

    local Update = function(baseFrame, frame)
        if (unitData.ShowBossIconAfter) then
            local showBossIconAfter, object = unitData.ShowBossIconAfter(baseFrame)
            ct:RehookOrUnhook(hideQuestIcon and not hideBossIcon, object, showBossIconAfter, ShowBossIconHiddenByQuestIcon)
        end
        unitData.Update(baseFrame, frame)
    end

    HideOnShowAndUpdate(unitData, key, Icon, Update)
end

function ct.ToggleBossIcon(unitData)
    ToggleBossOrQuestIcon(unitData, ns.KEY.ICON_BOSS, unitData.BossIcon)
end

function ct.ToggleQuestIcon(unitData)
    ToggleBossOrQuestIcon(unitData, ns.KEY.ICON_QUEST, unitData.QuestIcon)
end

function ct:UpdateRaidIconOnEvent(baseFrame, event)
    if (event == "PLAYER_ENTERING_WORLD" or event == "RAID_TARGET_UPDATE") then
        baseFrame:UpdateRaidTargetIcon()
    end
end

local function UpdateRaidTargetIcon(unit, raidTargetIcon)
    local index = GetRaidTargetIndex(unit);
    if (index) then
        SetRaidTargetIconTexture(raidTargetIcon, index);
        raidTargetIcon:Show();
    else
        raidTargetIcon:Hide();
    end
end

local function CreateRaidIcon(unitData)
    local baseFrame, contentContext = unitData.baseFrame, unitData.contentContext
    if (not contentContext.RaidTargetIcon) then
        contentContext.RaidTargetIcon = contentContext:CreateTexture(nil, "OVERLAY", nil, 3)
        contentContext.RaidTargetIcon:Hide()
        contentContext.RaidTargetIcon:SetSize(26, 26)
        contentContext.RaidTargetIcon:SetPoint("CENTER", unitData.portrait, "TOP")
        contentContext.RaidTargetIcon:SetTexture(ns.RAID_TARGET_ICON_TEXTURE)

        baseFrame.UpdateRaidTargetIcon = function(self)
            UpdateRaidTargetIcon(self.unit, contentContext.RaidTargetIcon)
        end

        unitData.RaidIcon = contentContext.RaidTargetIcon
    end

    ct:HookSafe(baseFrame, "OnEvent", "UpdateRaidIconOnEvent")
    baseFrame:RegisterEvent("RAID_TARGET_UPDATE")
end

local function UnhookRaidIcon(baseFrame)
    ct:Unhook(baseFrame, "OnEvent")
    baseFrame:UnregisterEvent("RAID_TARGET_UPDATE")
end

function ct.ToggleRaidIcon(unitData)
    local hide = Hidden(unitData, ns.KEY.ICON_RAID)

    if (unitData.noDefaultRaidIcon) then
        if (hide and not unitData.RaidIcon) then
            return
        elseif (hide) then
            UnhookRaidIcon(unitData.baseFrame)
        else
            CreateRaidIcon(unitData)
        end
    end

    ct:HideOnShowAndUpdate(unitData, hide, unitData.RaidIcon, unitData.UpdateRaidIcon)
end

function ct.SetupHideables(unitData, skipDefault)
    local unit = unitData.unit

    for _, option in pairs(ns.OPTIONS[ns.TYPE.HIDE]) do
        if (ns.Enabled(unit, option)) then
            if (not skipDefault or ns.NotDefault(unit, option)) then
                option.Handler(unitData, option.type, option.key)
            end
        end
    end
end
