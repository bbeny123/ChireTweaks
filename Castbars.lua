local addonName, ns = ...
local ct = LibStub("AceAddon-3.0"):GetAddon(addonName)

function ct.MoveCastbar(unitData)
    local movable = ns.GetDBBy(unitData.unit, ns.TYPE.CASTBAR, ns.KEY.MOVE)
    local x, y = ns.GetDBBy(unitData.unit, ns.TYPE.CASTBAR, ns.KEY.X), ns.GetDBBy(unitData.unit, ns.TYPE.CASTBAR, ns.KEY.Y)
    local point, relativeTo, relativePoint = unitData.CastBarAnchorPoint()
    local Handler

    if (unitData.playerCastBar) then
        Handler = function(castBar)
            local Reposition = function()
                if (castBar.attachedToPlayerFrame) then
                    castBar:SetPoint(point, relativeTo, relativePoint, x, y)
                end
            end

            ns.ForEach(unitData.castBarRepositionAfter, function(repositionAfter)
                ct:RehookOrUnhook(movable, nil, repositionAfter, Reposition)
            end)
        end
    else
        local Reposition = function(bar) bar:SetPoint(point, relativeTo, relativePoint, x, y) end

        Handler = function()
            local repositionAfter, object = unitData.CastBarRepositionAfter()
            ct:RehookOrUnhook(movable, object, repositionAfter, Reposition)

            repositionAfter, object = unitData.CastBarRepositionAfterScript()
            ct:RehookOrUnhookScript(movable, object, repositionAfter, Reposition)
        end
    end

    ct.Handle(unitData, unitData.castBar, Handler, unitData.CastBarResetPosition)
end

local function ResizeIcon(unitData, castBar)
    local size = castBar.attachedToPlayerFrame and unitData.castBarIconSizeAttached or unitData.castBarIconSizeDetached
    local Point = castBar.attachedToPlayerFrame and unitData.CastIconPointAttached or unitData.CastIconPointDetached

    castBar.Icon:SetSize(size, size)
    castBar.Icon:SetPoint(Point())
end

local function AfterSetLookHook(unitData)
    local hookAfter, object = unitData.CastBarSetFontOrResizeIconAfter()
    local Handler

    if (unitData.castBarIconHook and unitData.castBarFontHook) then
        Handler = function (castBar)
            ns.SetFont(castBar.Text, unitData.castBarFontHook)
            ResizeIcon(unitData, castBar)
        end
    elseif (unitData.castBarIconHook) then
        Handler = function (castBar)
            ResizeIcon(unitData, castBar)
        end
    elseif (unitData.castBarFontHook) then
        Handler = function (castBar)
            ns.SetFont(castBar.Text, unitData.castBarFontHook)
        end
    end

    ct:RehookOrUnhook(Handler, object, hookAfter, Handler)
end

function ct.SetSpellNameFont(unitData, _, _, fontObject)
    fontObject = fontObject or ns.FontObjectBy(unitData.unit, ns.TYPE.CASTBAR)

    ct.Handle(unitData, unitData.castBar, function (castBar)
        if (unitData.playerCastBar) then
            unitData.castBarFontHook = fontObject
            AfterSetLookHook(unitData)
        end

        ns.SetFont(castBar.Text, fontObject)
    end)
end

function ct.SetSpellNameColor(unitData)
    local r, g, b, a = ns.Color(unitData.unit, ns.TYPE.CASTBAR)

    ct.Handle(unitData, unitData.castBar, function (castBar)
        ns.SetColor(castBar.Text, r, g, b, a)
    end)
end

local function ResizeIconIfApplicable(show, unitData, castBar)
    if (not unitData.playerCastBar) then
        return
    end

    unitData.castBarIconHook = show
    AfterSetLookHook(unitData)
    ResizeIcon(unitData, castBar)
end

function ct.ToggleIcon(unitData)
    local show = ns.GetDBBy(unitData.unit, ns.TYPE.CASTBAR, ns.KEY.ICON)

    ct.Handle(unitData, unitData.castBar, function (castBar)
        ct:HideOnShow(not show, castBar.Icon)

        if (unitData.castBarIconShield) then
            castBar.showShield = show
            ct:HideOnShow(not show, unitData.castBarIconShield)
        end

        if (unitData.castBarIconShowable) then
            ct:ShowOnHide(show, castBar.Icon)
        end

        ResizeIconIfApplicable(show, unitData, castBar)

        castBar.Icon:SetShown(show)
    end)
end

function ct.ToggleCastTime(unitData)
    local show = ns.GetDBBy(unitData.unit, ns.TYPE.CASTBAR_TIMER, ns.KEY.SHOW)

    ct.Handle(unitData, unitData.castBar, function (castBar)
        if (show and not castBar.CastTimeText) then
            castBar.CastTimeText = castBar:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
        end
        castBar.showCastTimeSetting = show
    end, unitData.UpdateCastTime)

    if (show) then
        ct.MoveCastTime(unitData)
        ct.SetCastTimeFont(unitData)
        ct.SetCastTimeColor(unitData)
    end
end

function ct.MoveCastTime(unitData, _, _, xOffset, yOffset)
    xOffset = xOffset or ns.GetDBBy(unitData.unit, ns.TYPE.CASTBAR_TIMER, ns.KEY.X)
    yOffset = yOffset or ns.GetDBBy(unitData.unit, ns.TYPE.CASTBAR_TIMER, ns.KEY.Y)

    local point, relativeTo, relativePoint, x, y = unitData.CastTimePointDefault()

    ct.Handle(unitData, unitData.castBar, function (castBar)
        castBar.CastTimeText:SetPoint(point, relativeTo, relativePoint, x + xOffset, y + yOffset)
    end)
end

function ct.SetCastTimeFont(unitData, _, _, fontObject)
    fontObject = fontObject or ns.FontObjectBy(unitData.unit, ns.TYPE.CASTBAR_TIMER)

    ct.Handle(unitData, unitData.castBar, function (castBar)
        ns.SetFont(castBar.CastTimeText, fontObject)
    end)
end

function ct.SetCastTimeColor(unitData)
    local r, g, b, a = ns.Color(unitData.unit, ns.TYPE.CASTBAR_TIMER)

    ct.Handle(unitData, unitData.castBar, function (castBar)
        ns.SetColor(castBar.CastTimeText, r, g, b, a)
    end)
end

local function SetupPlayerCastTime(unitData, skipDefault)
    local unit, type = unitData.unit, ns.TYPE.CASTBAR_TIMER

    local xOffset, yOffset = ns.GetDB(unitData.unit, type, ns.KEY.X), ns.GetDBBy(unitData.unit, type, ns.KEY.Y)
    if (not skipDefault or xOffset ~= 0 or yOffset ~= 0) then
        ct.MoveCastTime(unitData, nil, nil, xOffset, yOffset)
    end

    local fontObject = ns.FontObjectBy(unit, type, skipDefault)
    if (fontObject) then
        ct.SetCastTimeFont(unitData, nil, nil, fontObject)
    end

    if (not skipDefault or ns.NotDefaultBy(unit, type, ns.KEY.COLOR)) then
        ct.SetCastTimeColor(unitData)
    end
end

function ct:SetupCastbar(unitData, skipDefault)
    if (not unitData.castBar or (unitData.targetCastbarCVar and ns.TargetCastBarHidden())) then
        return
    end

    local unit, type = unitData.unit, ns.TYPE.CASTBAR

    if (not skipDefault or ns.NotDefaultBy(unit, type, ns.KEY.MOVE)) then
        self.MoveCastbar(unitData)
    end

    if (not skipDefault or ns.NotDefaultBy(unit, type, ns.KEY.ICON)) then
        self.ToggleIcon(unitData)
    end

    local fontObject = ns.FontObjectBy(unit, type, skipDefault)
    if (fontObject) then
        self.SetSpellNameFont(unitData, nil, nil, fontObject)
    end

    if (not skipDefault or ns.NotDefaultBy(unit, type, ns.KEY.COLOR)) then
        self.SetSpellNameColor(unitData)
    end

    if (unitData.playerCastBar) then
        SetupPlayerCastTime(unitData, skipDefault)
    elseif (not skipDefault or ns.NotDefaultBy(unitData.unit, ns.TYPE.CASTBAR_TIMER, ns.KEY.SHOW)) then
        self.ToggleCastTime(unitData)
    end
end
