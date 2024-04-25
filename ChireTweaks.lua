local addonName, ns = ...
local LibStub = LibStub
local ct = LibStub("AceAddon-3.0"):NewAddon(addonName, "AceConsole-3.0", "AceHook-3.0")

function ct:OnInitialize()
    self.db = LibStub("AceDB-3.0"):New("ChireTweaksDB", { profile = { ['**'] = {} } }, true)
    self.db.RegisterCallback(self, "OnProfileChanged", "OnProfileChanged")
    self.db.RegisterCallback(self, "OnProfileCopied", "OnProfileChanged")
    self.db.RegisterCallback(self, "OnProfileReset", "OnProfileChanged")

    self:InitConfig()
end

local function OnEnableOrProfileChange(startup)
    for _, unitData in pairs(ns.UNIT_DATA) do
        ct.SetupHideables(unitData, startup)

        if (not ns.NoneStatusText()) then
            ct:SetStatusBarsFormats(unitData, startup)
        end

        ct.SetupHealthbarColors(unitData, startup)
        ct:SetupLevel(unitData, startup)
        ct:SetupName(unitData, startup)
        ct:SetupCastbar(unitData, startup)
    end
end

function ct:OnEnable()
    self:SecureHook("SetCVar", "SetCVarHook")
    OnEnableOrProfileChange(true)
end

function ct:OnProfileChanged(_, database, _)
    self.db = database
    OnEnableOrProfileChange()
end

function ct:HookSafe(object, method, Handler)
    if (not self:IsHooked(object, method)) then
        self:SecureHook(object, method, Handler)
    end
end

function ct:HookScriptSafe(object, script, Handler)
    if (not self:IsHooked(object, script)) then
        self:SecureHookScript(object, script, Handler)
    end
end

function ct:HookSafeIf(hook, object, method, Handler)
    if (hook) then
        self:HookSafe(object, method, Handler)
    end
end

function ct:UnhookIf(unhook, object, method)
    if (unhook) then
        self:Unhook(object, method)
    end
end

function ct:Rehook(object, method, Handler)
    self:Unhook(object, method)
    self:SecureHook(object, method, Handler)
end

function ct:RehookOrUnhook(hook, object, method, Handler)
    self:Unhook(object, method)

    if (hook) then
        self:SecureHook(object, method, Handler)
    end
end

function ct:RehookOrUnhookScript(hook, object, script, Handler)
    self:Unhook(object, script)

    if (hook) then
        self:SecureHookScript(object, script, Handler)
    end
end

local function Handle(baseFrame, frame, Handler, Update)
    Handler(frame, baseFrame)
    if (Update) then
        Update(baseFrame, frame)
    end
end

function ct.Handle(unitData, Frame, Handler, Update)
    if (unitData.group) then
        for _, baseFrame in pairs(unitData.baseFrames) do
            Handle(baseFrame, Frame(baseFrame), Handler, Update)
        end
    else
        Handle(unitData.baseFrame, Frame, Handler, Update)
    end
end

function ct:HideOnShow(hide, frame, HideHook)
    self:RehookOrUnhook(hide, frame, "Show", HideHook or ns.Hide)
    self:RehookOrUnhook(hide, frame, "SetShown", HideHook or ns.Hide)
end

function ct:ShowOnHide(show, frame, ShowHook)
    self:RehookOrUnhook(show, frame, "Hide", ShowHook or ns.Show)
    self:RehookOrUnhook(show, frame, "SetShown", ShowHook or ns.Show)
end

function ct:HideOnShowAndUpdate(unitData, hide, Frame, Update, HideHook)
    local Handler = function(frame)
        self:HideOnShow(hide, frame, HideHook)
    end
    self.Handle(unitData, Frame, Handler, Update)
end

function ct:SetCVarHook(cVar, _)
    if (cVar == ns.CVAR.STATUS_TEXT_DISPLAY) then
        ns.CacheStatusTextCVar()

        local hide = ns.NoneStatusText()

        for _, unitData in pairs(ns.UNIT_DATA) do
            ct:SetStatusBarsFormats(unitData, false, hide)
        end
    elseif (cVar == ns.CVAR.TARGET_CAST_BAR) then
        ns.CacheTargetCastBarCVar()
        for _, unitData in pairs(ns.UNIT_DATA) do
            if (unitData.targetCastbarCVar) then
                ct:SetupCastbar(unitData, false)
            end
        end
    end
end
