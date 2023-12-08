local addonName, ns = ...
local ct = LibStub("AceAddon-3.0"):GetAddon(addonName)
local GetCVar = GetCVar

local statusTextCVarCache

function ns.GetDBRaw(unit, option)
    return ct.db.profile[unit][option.db]
end

function ns.GetDBRawBy(unit, type, key)
    return ns.GetDBRaw(unit, ns.Option(type, key))
end

function ns.NotDefault(unit, option)
    return ns.GetDBRaw(unit, option) ~= nil
end

function ns.NotDefaultBy(unit, type, key)
    return ns.GetDBRaw(unit, ns.Option(type, key)) ~= nil
end

function ns.GetDB(unit, option)
    local db = ct.db.profile[unit][option.db]

    if (db ~= nil) then
        return db
    end

    return ns.Default(unit, option)
end

function ns.GetDBBy(unit, type, key)
    return ns.GetDB(unit, ns.Option(type, key))
end

function ns.GetDBByIfEnabled(unit, type, key)
    local option = ns.OptionIfEnabled(unit, type, key)
    return option and ns.GetDB(unit, option)
end

function ns.SetDB(unit, option, value)
    if (value == ns.Default(unit, option)) then
        value = nil
    end

    ct.db.profile[unit][option.db] = value
    option.Handler(ns.UNIT_DATA[unit], option.type, option.key)
end

function ns.SetDBIfEnabled(unit, option, value)
    if (ns.Enabled(unit, option)) then
        ns.SetDB(unit, option, value)
    end
end

local function CopyDBByOption(unitFrom, unitTo, option)
    local value = ns.GetDB(unitFrom, option)

    if (unitTo == ns.UNIT.ALL) then
        for _, unit in pairs(ns.UNIT) do
            if (unit ~= ns.UNIT.ALL and unitFrom ~= unit) then
                ns.SetDBIfEnabled(unit, option, value)
            end
        end
    else
        ns.SetDBIfEnabled(unitTo, option, value)
    end
end

function ns.CopyDB(unitFrom, unitTo)
    for _, type in pairs(ns.OPTIONS) do
        for _, option in pairs(type) do
            if (ns.Enabled(unitFrom, option)) then
                CopyDBByOption(unitFrom, unitTo, option)
            end
        end
    end
end

function ns.Option(type, key)
    return ns.OPTIONS[type][key]
end

function ns.OptionIfEnabled(unit, type, key)
    local option = ns.OPTIONS[type][key]
    return ns.Enabled(unit, option) and option
end

function ns.Enabled(unit, option)
    return option.enabled == nil or ns.Nvl(option.enabled[unit], option.enabled.default)
end

function ns.Default(unit, option)
    local type = type(option.default)

    if (type == "function") then
        return option.default(unit, option)
    elseif (type == "table") then
        return ns.Nvl(option.default[unit], option.default.default)
    end

    return option.default
end

function ns.DefaultBy(unit, type, key)
    return ns.Default(unit, ns.Option(type, key))
end

function ns.DisabledValue(unit, option)
    if (option.disabledValue ~= nil) then
        return option.disabledValue
    end

    return ns.Default(unit, option)
end

function ns:SetStatusTextCVar(value)
    SetCVar(ns.CVAR.STATUS_TEXT_DISPLAY, value)
    SetCVar(ns.CVAR.STATUS_TEXT, value == ns.CVAR_STATUS_TEXT.NONE and "0" or "1")
end

function ns.CacheStatusTextCVar()
    statusTextCVarCache = GetCVar(ns.CVAR.STATUS_TEXT_DISPLAY)
end

function ns.GetStatusTextCVarRaw()
    if (not statusTextCVarCache) then
        ns.CacheStatusTextCVar()
    end

    return statusTextCVarCache
end

function ns.GetStatusTextCVar()
    local cVar = ns.GetStatusTextCVarRaw()
    return cVar == ns.CVAR_STATUS_TEXT.PERCENT and ns.CVAR_STATUS_TEXT.NUMERIC or cVar
end

function ns.NoneStatusText()
    return ns.GetStatusTextCVar() == ns.CVAR_STATUS_TEXT.NONE
end

function ns.BothStatusText()
    return ns.GetStatusTextCVar() == ns.CVAR_STATUS_TEXT.BOTH
end
