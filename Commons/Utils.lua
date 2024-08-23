local addonName, ns = ...
local L = LibStub("AceLocale-3.0"):GetLocale(addonName)

function ns.Nvl(value, default)
    if (value ~= nil) then
        return value
    end

    return default
end

function ns.IsTable(object)
    return type(object) == "table"
end

function ns.IsNumber(object)
    return type(object) == "number"
end

function ns.IsValidNumberOrEmpty(number)
    return number == nil or number == "" or tonumber(number)
end

function ns.Localize(key)
    return L[key]
end

function ns.ConcatLists(...)
    local result = {}

    for _, list in ipairs { ... } do
        for item in pairs(list) do
            table.insert(result, item)
        end
    end

    return result
end

function ns.LocalizedList(list, Key)
    local result = {}

    for _, key in pairs(list) do
        result[key] = L[Key and Key(key) or key]
    end

    return result
end

function ns.ExtendedList(list, ...)
    local result = { unpack(list) }

    for _, key in ipairs { ... } do
        result[key] = L[key]
    end

    return result
end

function ns.IteratorsToList(...)
    local result = {}

    for _, iterator in ipairs { ... } do
        for item in iterator do
            table.insert(result, item)
        end
    end

    return result
end

function ns.ForEach(list, Handler, ...)
    for _, item in pairs(list) do
        Handler(item, ...)
    end
end

function ns.Show(frame)
    frame:Show()
end

function ns.ShowFrame(_, frame)
    frame:Show()
end

function ns.Hide(frame)
    frame:Hide()
end

function ns.HideFrame(_, frame)
    frame:Hide()
end
