local _, ns = ...

local UpdateHealthBar, UpdateThreatIndicator = UnitFrameHealthBar_Update, UnitFrame_UpdateThreatIndicator
local playerFrame, petFrame, targetFrame, totFrame, focusFrame, tofFrame = PlayerFrame, PetFrame, TargetFrame, TargetFrameToT, FocusFrame, FocusFrameToT
local playerContentCtx, playerCastBar, PlayerFrame_OnEvent = playerFrame.PlayerFrameContent.PlayerFrameContentContextual, PlayerCastingBarFrame, PlayerFrame_OnEvent
local targetContentCtx = targetFrame.TargetFrameContent.TargetFrameContentContextual
local focusContentCtx = focusFrame.TargetFrameContent.TargetFrameContentContextual
local partyPool = PartyFrame.PartyMemberFramePool

ns.UNIT_DATA = {
    [ns.UNIT.PLAYER] = {
        unit = ns.UNIT.PLAYER,
        noDefaultRaidIcon = true,
        baseFrame = playerFrame,
        contentContext = playerContentCtx,
        portrait = playerFrame.portrait,
        HealthBar = playerFrame.healthbar,
        ManaBar = playerFrame.manabar,
        AlternatePowerBar = function() return playerFrame.activeAlternatePowerBar end,
        Name = playerFrame.name,
        NamePointDefault = function() return "TOPLEFT", playerFrame.state == "vehicle" and 96 or 88, -27 end,
        NamePointCentered = function() return "TOPLEFT", 99, -27 end,
        nameWidthDefault = 96,
        NameWidthCentered = function() return playerFrame.state == "vehicle" and 108 or 118 end,
        NameRecenterAfter = function() return "PlayerFrame_UpdatePlayerNameTextAnchor" end,
        Level = PlayerLevelText,
        LevelPointCentered = function() return "TOPRIGHT", -24.5, -27 end,
        LevelVisible = function() return playerFrame.state ~= "vehicle" end,
        LevelRecolorAfter = function() return "PlayerFrame_UpdateLevel" end,
        LevelShow = function()
            if (playerFrame.state ~= "vehicle") then
                PlayerFrame_UpdateRolesAssigned()
            end
        end,
        LevelShowAfter = function() return "PlayerFrame_UpdateRolesAssigned" end,
        castBar = playerCastBar,
        playerCastBar = true,
        CastBarAnchorPoint = function() return "TOPRIGHT", playerFrame, "BOTTOMRIGHT" end,
        CastBarResetPosition = function() PlayerFrame_AdjustAttachments() end,
        castBarRepositionAfter = { "PlayerFrame_AdjustAttachments", "PlayerFrame_AttachCastBar" },
        CastBarSetFontOrResizeIconAfter = function() return "SetLook", playerCastBar end,
        castBarIconShowable = true,
        castBarIconSizeAttached = 16,
        castBarIconSizeDetached = 26,
        CastIconPointAttached = function() return "RIGHT", playerCastBar, "LEFT", -5, 0 end,
        CastIconPointDetached = function () return "RIGHT", playerCastBar, "LEFT", -5, -5 end,
        CastTimePointDefault = function() return "LEFT", playerCastBar, "RIGHT", 10, 0 end,
        UpdateCastTime = function() playerCastBar:UpdateCastTimeTextShown() end,
        statusTexture = playerFrame.PlayerFrameContent.PlayerFrameContentMain.StatusTexture,
        ThreatGlow = playerFrame.threatIndicator,
        hitIndicator = playerFrame.feedbackText,
        groupIndicator = playerContentCtx.GroupIndicator,
        restIcon = playerContentCtx.PlayerRestLoop,
        cornerIcon = playerContentCtx.PlayerPortraitCornerIcon,
        combatIcon = playerContentCtx.AttackIcon,
        RoleIcon = playerContentCtx.RoleIcon,
        LeaderIcon = playerContentCtx.LeaderIcon,
        GuideIcon = playerContentCtx.GuideIcon,
        pvpTimer = PlayerPVPTimerText,
        PVPIcons = { playerContentCtx.PVPIcon, playerContentCtx.PrestigePortrait, playerContentCtx.PrestigeBadge },
        Update = PlayerFrame_Update,
        UpdateStatus = PlayerFrame_UpdateStatus,
        UpdateRoles = PlayerFrame_UpdateRolesAssigned,
        UpdateLeader = PlayerFrame_UpdatePartyLeader,
        UpdateGroupIndicator = PlayerFrame_UpdateGroupIndicator,
        UpdatePVPStatus = PlayerFrame_UpdatePvPStatus,
        UpdateHealthBar = function(_, statusBar) UpdateHealthBar(statusBar, playerFrame.unit) end,
        UpdateThreatIndicator = function() UpdateThreatIndicator(playerFrame.threatIndicator, playerFrame.threatNumericIndicator) end,
        UpdatePVPTimer = function() PlayerFrame_OnEvent(playerFrame, "PVP_TIMER_UPDATE") end,
        UpdateRaidIcon = function() playerFrame:UpdateRaidTargetIcon() end,
    },
    [ns.UNIT.PET] = {
        unit = ns.UNIT.PET,
        baseFrame = petFrame,
        ClassUnit = ns.UNIT.PLAYER,
        HealthBar = petFrame.healthbar,
        ManaBar = petFrame.manabar,
        Name = petFrame.name,
        nameWidthDefault = 68,
        nameWidthCentered = 70,
        ThreatGlow = petFrame.threatIndicator,
        combatGlow = PetAttackModeTexture,
        hitIndicator = petFrame.feedbackText,
        Update = function() petFrame:Update() end,
        UpdateHealthBar = function(_, statusBar) UpdateHealthBar(statusBar, petFrame.unit) end,
        UpdateThreatIndicator = function() UpdateThreatIndicator(petFrame.threatIndicator, petFrame.threatNumericIndicator) end,
    },
    [ns.UNIT.TARGET] = {
        unit = ns.UNIT.TARGET,
        baseFrame = targetFrame,
        HealthBar = targetFrame.healthbar,
        ManaBar = targetFrame.manabar,
        Name = targetFrame.name,
        NamePointDefault = function() return "TOPLEFT", targetFrame.TargetFrameContent.TargetFrameContentMain.ReputationColor, "TOPRIGHT", -106, -1 end,
        NamePointCentered = function() return "TOPLEFT", targetFrame.TargetFrameContent.TargetFrameContentMain.ReputationColor, "TOPRIGHT", -116, -1 end,
        nameWidthDefault = 90,
        nameWidthCentered = 124,
        nameMoveToLevel = true,
        Level = targetFrame.TargetFrameContent.TargetFrameContentMain.LevelText,
        LevelPointCentered = function() return "TOPLEFT", targetFrame.TargetFrameContent.TargetFrameContentMain.ReputationColor, "TOPRIGHT", -133, -1 end,
        LevelHighPointCentered = function() return "TOPLEFT", targetFrame.TargetFrameContent.TargetFrameContentMain.LevelText, "TOPLEFT", 4, 1 end,
        LevelRecolorAfter = function() return "CheckLevel", targetFrame end,
        levelJustify = "LEFT",
        HighLevel = targetContentCtx.HighLevelTexture,
        LevelShow = function()
            if (targetFrame.showLevel) then
                targetFrame:CheckLevel();
            end
        end,
        castBar = targetFrame.spellbar,
        targetCastbarCVar = true,
        CastBarAnchorPoint = function() return "TOPLEFT", targetFrame, "BOTTOMLEFT" end,
        CastBarResetPosition = function() targetFrame.spellbar:AdjustPosition() end,
        CastBarRepositionAfter = function() return "AdjustPosition", targetFrame.spellbar end,
        CastBarRepositionAfterScript = function() return "OnShow", targetFrame.spellbar end,
        castBarIconShield = targetFrame.spellbar.BorderShield,
        CastTimePointDefault = function() return "LEFT", targetFrame.spellbar, "RIGHT", 8, -1 end,
        UpdateCastTime = function() targetFrame.spellbar:UpdateCastTimeTextShown() end,
        ThreatGlow = targetFrame.threatIndicator,
        ReputationGlow = targetFrame.TargetFrameContent.TargetFrameContentMain.ReputationColor,
        RaidIcon = targetContentCtx.RaidTargetIcon,
        LeaderIcon = targetContentCtx.LeaderIcon,
        GuideIcon = targetContentCtx.GuideIcon,
        BossIcon = targetContentCtx.BossIcon,
        ShowBossIconAfter = function() return "CheckClassification", targetFrame end,
        QuestIcon = targetContentCtx.QuestIcon,
        petBattleIcon = targetContentCtx.PetBattleIcon,
        PVPIcons = { targetContentCtx.PvpIcon, targetContentCtx.PrestigePortrait, targetContentCtx.PrestigeBadge },
        Update = function() targetFrame:Update() end,
        UpdateLeader = function() targetFrame:Update() end,
        UpdatePVPStatus = function() targetFrame:CheckFaction() end,
        UpdateRaidIcon = function() targetFrame:UpdateRaidTargetIcon() end,
        UpdateBattlePet = function() targetFrame:CheckBattlePet() end,
        UpdateDeadText = function() targetFrame:CheckDead() end,
        UpdateHealthBar = function(_, statusBar) UpdateHealthBar(statusBar, targetFrame.unit) end,
        UpdateThreatIndicator = function() UpdateThreatIndicator(targetFrame.threatIndicator, targetFrame.threatNumericIndicator, targetFrame.feedbackUnit) end,
        UpdateReputationGlow = ns.ShowFrame,
    },
    [ns.UNIT.TOT] = {
        unit = ns.UNIT.TOT,
        baseFrame = totFrame,
        totFrame = true,
        HealthBar = totFrame.healthbar,
        ManaBar = totFrame.manabar,
        Name = totFrame.name,
        nameWidthDefault = 68,
        nameWidthCentered = 70,
        UpdateDeadText = function() totFrame:CheckDead() end,
        UpdateHealthBar = function(_, statusBar) UpdateHealthBar(statusBar, totFrame.unit) end,
    },
    [ns.UNIT.FOCUS] = {
        unit = ns.UNIT.FOCUS,
        baseFrame = focusFrame,
        HealthBar = focusFrame.healthbar,
        ManaBar = focusFrame.manabar,
        HealthBarSetFontAfter = function() return "SetSmallSize", focusFrame end,
        Name = focusFrame.name,
        NamePointDefault = function() return "TOPLEFT", focusFrame.TargetFrameContent.TargetFrameContentMain.ReputationColor, "TOPRIGHT", -106, -1 end,
        NamePointCentered = function() return "TOPLEFT", focusFrame.TargetFrameContent.TargetFrameContentMain.ReputationColor, "TOPRIGHT", -116, -1 end,
        nameWidthDefault = 90,
        nameWidthCentered = 124,
        nameMoveToLevel = true,
        Level = focusFrame.TargetFrameContent.TargetFrameContentMain.LevelText,
        LevelPointCentered = function() return "TOPLEFT", focusFrame.TargetFrameContent.TargetFrameContentMain.ReputationColor, "TOPRIGHT", -133, -1 end,
        LevelHighPointCentered = function() return "TOPLEFT", focusFrame.TargetFrameContent.TargetFrameContentMain.LevelText, "TOPLEFT", 4, 1 end,
        LevelRecolorAfter = function() return "CheckLevel", focusFrame end,
        levelJustify = "LEFT",
        HighLevel = focusContentCtx.HighLevelTexture,
        LevelShow = function()
            if (focusFrame.showLevel) then
                focusFrame:CheckLevel();
            end
        end,
        castBar = focusFrame.spellbar,
        targetCastbarCVar = true,
        CastBarAnchorPoint = function() return "TOPLEFT", focusFrame, "BOTTOMLEFT" end,
        CastBarResetPosition = function() targetFrame.spellbar:AdjustPosition() end,
        CastBarRepositionAfter = function() return "AdjustPosition", focusFrame.spellbar end,
        CastBarRepositionAfterScript = function() return "OnShow", focusFrame.spellbar end,
        castBarIconShield = focusFrame.spellbar.BorderShield,
        CastTimePointDefault = function() return "LEFT", focusFrame.spellbar, "RIGHT", 8, -1 end,
        UpdateCastTime = function() focusFrame.spellbar:UpdateCastTimeTextShown() end,
        ThreatGlow = focusFrame.threatIndicator,
        ReputationGlow = focusFrame.TargetFrameContent.TargetFrameContentMain.ReputationColor,
        RaidIcon = focusContentCtx.RaidTargetIcon,
        LeaderIcon = focusContentCtx.LeaderIcon,
        GuideIcon = focusContentCtx.GuideIcon,
        BossIcon = focusContentCtx.BossIcon,
        ShowBossIconAfter = function() return "CheckClassification", focusFrame end,
        QuestIcon = focusContentCtx.QuestIcon,
        petBattleIcon = focusContentCtx.PetBattleIcon,
        PVPIcons = { focusContentCtx.PvpIcon, focusContentCtx.PrestigePortrait, focusContentCtx.PrestigeBadge },
        Update = function() focusFrame:Update() end,
        UpdateLeader = function() focusFrame:Update() end,
        UpdatePVPStatus = function() focusFrame:CheckFaction() end,
        UpdateRaidIcon = function() focusFrame:UpdateRaidTargetIcon() end,
        UpdateBattlePet = function() focusFrame:CheckBattlePet() end,
        UpdateDeadText = function() focusFrame:CheckDead() end,
        UpdateHealthBar = function(_, statusBar) UpdateHealthBar(statusBar, focusFrame.unit) end,
        UpdateThreatIndicator = function() UpdateThreatIndicator(focusFrame.threatIndicator, focusFrame.threatNumericIndicator, focusFrame.feedbackUnit) end,
        UpdateReputationGlow = ns.ShowFrame,
        SmallSize = function() return focusFrame.smallSize end,
    },
    [ns.UNIT.TOF] = {
        unit = ns.UNIT.TOF,
        baseFrame = tofFrame,
        totFrame = true,
        HealthBar = tofFrame.healthbar,
        ManaBar = tofFrame.manabar,
        Name = tofFrame.name,
        nameWidthDefault = 68,
        nameWidthCentered = 70,
        UpdateDeadText = function() tofFrame:CheckDead() end,
        UpdateHealthBar = function(_, statusBar) UpdateHealthBar(statusBar, tofFrame.unit) end,
    },
    [ns.UNIT.BOSS] = {
        unit = ns.UNIT.BOSS,
        group = true,
        baseFrames = { Boss1TargetFrame, Boss2TargetFrame, Boss3TargetFrame, Boss4TargetFrame, Boss5TargetFrame },
        HealthBar = function(baseFrame) return baseFrame.healthbar end,
        ManaBar = function(baseFrame) return baseFrame.manabar end,
        Name = function(baseFrame) return baseFrame.name end,
        NamePointDefault = function(baseFrame) return "TOPLEFT", baseFrame.TargetFrameContent.TargetFrameContentMain.ReputationColor, "TOPRIGHT", -56, -1 end,
        NamePointCentered = function(baseFrame) return "TOPLEFT", baseFrame.TargetFrameContent.TargetFrameContentMain.ReputationColor, "TOPRIGHT", -68, -1 end,
        nameWidthDefault = 55,
        nameWidthCenteredShort = 50,
        nameWidthCentered = 80,
        nameMoveToLevel = true,
        Level = function(baseFrame) return baseFrame.TargetFrameContent.TargetFrameContentMain.LevelText end,
        LevelPointCentered = function(baseFrame) return "TOPLEFT", baseFrame.TargetFrameContent.TargetFrameContentMain.ReputationColor, "TOPRIGHT", -83, -1 end,
        LevelHighPointCentered = function(baseFrame) return "TOPLEFT", baseFrame.TargetFrameContent.TargetFrameContentMain.LevelText, "TOPLEFT", 4, 1 end,
        LevelRecolorAfter = function(baseFrame) return "CheckLevel", baseFrame end,
        levelJustify = "LEFT",
        HighLevel = function(baseFrame) return baseFrame.TargetFrameContent.TargetFrameContentContextual.HighLevelTexture end,
        LevelShow = function(baseFrame)
            if (baseFrame.showLevel) then
                baseFrame:CheckLevel();
            end
        end,
        ThreatGlow = function(baseFrame) return baseFrame.threatIndicator end,
        ReputationGlow = function(baseFrame) return baseFrame.TargetFrameContent.TargetFrameContentMain.ReputationColor end,
        RaidIcon = function(baseFrame) return baseFrame.TargetFrameContent.TargetFrameContentContextual.RaidTargetIcon end,
        BossIcon = function(baseFrame) return baseFrame.TargetFrameContent.TargetFrameContentContextual.BossIcon end,
        ShowBossIconAfter = function(baseFrame) return "CheckClassification", baseFrame end,
        QuestIcon = function(baseFrame) return baseFrame.TargetFrameContent.TargetFrameContentContextual.QuestIcon end,
        Update = function(baseFrame) baseFrame:Update() end,
        UpdateLeader = function(baseFrame) baseFrame:Update() end,
        UpdateRaidIcon = function(baseFrame) baseFrame:UpdateRaidTargetIcon() end,
        UpdateDeadText = function(baseFrame) baseFrame:CheckDead() end,
        UpdateHealthBar = function(baseFrame, statusBar) UpdateHealthBar(statusBar, baseFrame.unit) end,
        UpdateThreatIndicator = function(baseFrame) UpdateThreatIndicator(baseFrame.threatIndicator, baseFrame.threatNumericIndicator, baseFrame.feedbackUnit) end,
        UpdateReputationGlow = ns.ShowFrame,
    },
    [ns.UNIT.BG] = {
        unit = ns.UNIT.BG,
        group = true,
        baseFrames = { ArenaEnemyMatchFrame1, ArenaEnemyMatchFrame2, ArenaEnemyMatchFrame3, ArenaEnemyMatchFrame4, ArenaEnemyMatchFrame5 },
        HealthBar = function(baseFrame) return baseFrame.healthbar end,
        ManaBar = function(baseFrame) return baseFrame.manabar end,
        Name = function(baseFrame) return baseFrame.name end,
        nameWidthDefault = 0,
        nameWidthCentered = 66,
        PVPIcons = function(baseFrame) return { _G[baseFrame:GetName() .. "PVPIcon"] } end,
        UpdatePVPStatus = function(baseFrame) baseFrame:UpdatePlayer() end,
        UpdateHealthBar = function(baseFrame, statusBar) UpdateHealthBar(statusBar, baseFrame.unit) end,
    },
    [ns.UNIT.PARTY] = {
        unit = ns.UNIT.PARTY,
        group = true,
        baseFrames = ns.IteratorsToList(partyPool:EnumerateActive()),
        HealthBar = function(baseFrame) return baseFrame.healthbar end,
        ManaBar = function(baseFrame) return baseFrame.manabar end,
        HealthBarRecolorAfter = function(baseFrame) return "UpdateOnlineStatus", baseFrame end,
        Name = function(baseFrame) return baseFrame.name end,
        nameWidthDefault = 57,
        NameWidthCentered = function(baseFrame) return baseFrame.state == "vehicle" and 65 or 68 end,
        NameRecenterAfter = function(baseFrame) return "UpdateNameTextAnchors", baseFrame end,
        ThreatGlow = function(baseFrame) return baseFrame.threatIndicator end,
        DebuffGlow = function(baseFrame) return baseFrame.PartyMemberOverlay.Status end,
        RoleIcon = function(baseFrame) return baseFrame.PartyMemberOverlay.RoleIcon end,
        LeaderIcon = function(baseFrame) return baseFrame.PartyMemberOverlay.LeaderIcon end,
        GuideIcon = function(baseFrame) return baseFrame.PartyMemberOverlay.GuideIcon end,
        PVPIcons = function(baseFrame) return { baseFrame.PartyMemberOverlay.PVPIcon } end,
        PetHealthBar = function(baseFrame) return baseFrame.PetFrame.healthbar end,
        PetClassUnit = function(baseFrame) return baseFrame.unit end,
        PetThreatGlow = function(baseFrame) return baseFrame.PetFrame.threatIndicator end,
        Update = function(baseFrame) baseFrame:UpdateMember() end,
        UpdateRoles = function(baseFrame) baseFrame:UpdateAssignedRoles() end,
        UpdateLeader = function(baseFrame) baseFrame:UpdateLeader() end,
        UpdatePVPStatus = function(baseFrame) baseFrame:UpdatePvPStatus() end,
        UpdateHealthBar = function(baseFrame, statusBar) UpdateHealthBar(statusBar, baseFrame.unit) end,
        UpdatePetHealthBar = function(baseFrame, statusBar) UpdateHealthBar(statusBar, baseFrame.PetFrame.unit) end,
        UpdateThreatIndicator = function(baseFrame) UpdateThreatIndicator(baseFrame.threatIndicator, baseFrame.threatNumericIndicator) end,
        UpdatePetThreatIndicator = function(baseFrame) UpdateThreatIndicator(baseFrame.PetFrame.threatIndicator, baseFrame.PetFrame.threatNumericIndicator) end,
    },
}
