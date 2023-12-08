local _, ns = ...
local FORMAT = ns.FORMAT
local UnitIsDead, UnitIsDeadOrGhost, UnitIsUnconscious = UnitIsDead, UnitIsDeadOrGhost, UnitIsUnconscious
local dead, ghost, unconscious = ns.Localize(ns.DEAD), ns.Localize(ns.GHOST), ns.Localize(ns.UNCONSCIOUS)

local function ReadableNumber(num)
    if not num then
        return 0
    elseif num >= 1e9 then
        return ("%.2f"):format(num / 1e9) .. "B"
    elseif num >= 1e8 then
        return ("%.f"):format(num / 1e6) .. "M"
    elseif num >= 1e7 then
        return ("%.1f"):format(num / 1e6) .. "M"
    elseif num >= 1e6 then
        return ("%.2f"):format(num / 1e6) .. "M"
    elseif num >= 1e5 then
        return ("%.f"):format(num / 1e3) .. "k"
    elseif num >= 1e3 then
        return ("%.1f"):format(num / 1e3) .. "k"
    else
        return num
    end
end

local function FormatPercent(percent)
    if (percent >= 99.95) then
        return "100%"
    elseif percent < 0.05 then
        return "0%"
    end

    return ("%.1f%%"):format(percent)
end

function ns.FormatText(textFormat, currentValue, maxValue, percent, deadText)
    if (deadText) then
        return deadText
    elseif (textFormat == FORMAT.PERCENT) then
        return FormatPercent(percent)
    elseif (textFormat == FORMAT.CURRENT) then
        return ReadableNumber(currentValue)
    elseif (textFormat == FORMAT.CURRENT_PERCENT) then
        return ReadableNumber(currentValue) .. " – " .. FormatPercent(percent)
    elseif (textFormat == FORMAT.CURRENT_MAX) then
        return ReadableNumber(currentValue) .. " / " .. ReadableNumber(maxValue)
    elseif (textFormat == FORMAT.CURRENT_MAX_PERCENT) then
        return ReadableNumber(currentValue) .. " / " .. ReadableNumber(maxValue) .. " (" .. FormatPercent(percent) .. ")"
    elseif (textFormat == FORMAT.NONE) then
        return nil
    end
end

function ns.FormatBothText(textFormat, currentValue, maxValue, percent, deadText)
    if (deadText) then
        return nil, deadText
    elseif (textFormat == FORMAT.PERCENT) then
        return FormatPercent(percent), nil
    elseif (textFormat == FORMAT.CURRENT) then
        return nil, ReadableNumber(currentValue)
    elseif (textFormat == FORMAT.CURRENT_PERCENT) then
        return FormatPercent(percent), ReadableNumber(currentValue)
    elseif (textFormat == FORMAT.CURRENT_MAX) then
        return nil, ReadableNumber(currentValue) .. " / " .. ReadableNumber(maxValue)
    elseif (textFormat == FORMAT.CURRENT_MAX_PERCENT) then
        return FormatPercent(percent), ReadableNumber(currentValue) .. " / " .. ReadableNumber(maxValue)
    elseif (textFormat == FORMAT.NONE) then
        return nil, nil
    end
end

function ns.DeadText(unit)
    if (UnitIsDeadOrGhost(unit)) then
        return UnitIsDead(unit) and dead or ghost
    elseif (UnitIsUnconscious(unit)) then
        return unconscious
    end
end
