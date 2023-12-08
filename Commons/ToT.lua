local addonName, ns = ...
local ct = LibStub("AceAddon-3.0"):GetAddon(addonName)

local function CreateText(statusBar, text, relative, x, y)
    if (not statusBar[text]) then
        statusBar[text] = statusBar:CreateFontString(nil, "OVERLAY", "TextStatusBarText")
        statusBar[text]:SetPoint(relative, statusBar, relative, x or 0, y or 0)
    end
end

local function HideText(statusBar, text)
    if (statusBar[text]) then
        statusBar[text]:Hide()
    end
end

local function HideStatusTexts(statusBar)
    HideText(statusBar, "TextCT")
    HideText(statusBar, "LeftText")
    HideText(statusBar, "RightText")
end

local function CreateCenterText(statusBar, x, y)
    CreateText(statusBar, "TextCT", "CENTER", x, y)
end

local function CreateLeftText(statusBar, x, y)
    CreateText(statusBar, "LeftText", "LEFT", x, y)
end

local function CreateRightText(statusBar, x, y)
    CreateText(statusBar, "RightText", "RIGHT", x, y)
end

local function CreateToTHealthbarStatusText(healthbar)
    CreateCenterText(healthbar)
    CreateLeftText(healthbar)
    CreateRightText(healthbar)
    HideStatusTexts(healthbar)
    healthbar.lockShow = 0
end

local function CreateToTManabarStatusText(manabar)
    CreateCenterText(manabar, 2)
    CreateLeftText(manabar, 4)
    CreateRightText(manabar)
    HideStatusTexts(manabar)
    manabar.lockShow = 0
end

local function ToTHooks(disable, statusBar, OnEnterHook, OnLeaveHook)
    if (disable) then
        ct:Unhook(statusBar, "OnEnter")
        ct:Unhook(statusBar, "OnLeave")
    else
        ct:HookScriptSafe(statusBar, "OnEnter", OnEnterHook)
        ct:HookScriptSafe(statusBar, "OnLeave", OnLeaveHook)
    end
end

function ns.ToggleToTStatusText(hide, type, statusBar, OnEnterHook, OnLeaveHook)
    if (hide) then
        HideStatusTexts(statusBar)
    elseif (type == ns.TYPE.HEALTH) then
        CreateToTHealthbarStatusText(statusBar)
    else
        CreateToTManabarStatusText(statusBar)
    end
    ToTHooks(hide, statusBar, OnEnterHook, OnLeaveHook)
end

function ns.ShowToTText(statusBar, sides)
    if (sides) then
        statusBar.TextCT:Hide()
        statusBar.LeftText:Show()
        statusBar.RightText:Show()
    else
        statusBar.LeftText:Hide()
        statusBar.RightText:Hide()
        statusBar.TextCT:Show()
    end
end

function ns.HideToTText(statusBar)
    statusBar.LeftText:Hide()
    statusBar.RightText:Hide()
    statusBar.TextCT:Hide()
end
