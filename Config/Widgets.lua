local _, ns = ...

local baseWidgetsCache

local function CacheBaseWidgets()
    local AceGUI = LibStub("AceGUI-3.0")
    baseWidgetsCache = {
        [ns.WIDGET.ICON] = AceGUI.WidgetRegistry["Icon"],
        [ns.WIDGET.LABEL] = AceGUI.WidgetRegistry["Label"],
        [ns.WIDGET.SLIDER] = AceGUI.WidgetRegistry["Slider"],
        [ns.WIDGET.EDIT_BOX] = AceGUI.WidgetRegistry["EditBox"],
        [ns.WIDGET.COLOR_PICKER] = AceGUI.WidgetRegistry["ColorPicker"],
        [ns.WIDGET.FONT_SELECTOR] = AceGUI.WidgetRegistry["Dropdown"],
    }
end

local function BaseWidget(widgetType)
    if (not baseWidgetsCache) then
        CacheBaseWidgets()
    end

    return baseWidgetsCache[widgetType]()
end

function ns.RegisterCustomWidgets()
    local AceGUI = LibStub("AceGUI-3.0")
    for _, widgetType in pairs(ns.WIDGET) do
        AceGUI:RegisterWidgetType(widgetType, ns[widgetType], 1)
    end
end

local function ChireWidget(widgetType)
    local widget = BaseWidget(widgetType)
    widget.type = widgetType
    return widget
end

ns[ns.WIDGET.ICON] = function()
    local widget = ChireWidget(ns.WIDGET.ICON)
    local SetLabel, SetImageSize = widget.SetLabel, widget.SetImageSize

    widget.image:SetPoint("TOP")

    widget.SetLabel = function(self, _)
        SetLabel(self, "")
        self:SetHeight(self.image:GetHeight())
    end

    widget.SetImageSize = function(self, width, height)
        SetImageSize(self, width, height)
        self:SetHeight(height)
    end

    return widget
end

ns[ns.WIDGET.LABEL] = function()
    local widget = ChireWidget(ns.WIDGET.LABEL)
    local SetText = widget.SetText

    widget.alignoffset = 5

    widget.SetText = function(self, text)
        SetText(self, text)
        self.label:SetJustifyH("RIGHT")
    end

    return widget
end

ns[ns.WIDGET.SLIDER] = function()
    local widget = ChireWidget(ns.WIDGET.SLIDER)
    local OnAcquire = widget.OnAcquire

    widget.alignoffset = 13.9,
    widget.label:Hide()
    widget.slider:ClearAllPoints()
    widget.slider:SetPoint("TOP", 0, -2)
    widget.slider:SetPoint("LEFT", 3, 0)
    widget.slider:SetPoint("RIGHT", -2.5, 0)

    widget.OnAcquire = function(self)
        OnAcquire(self)
        self:SetHeight(30)
    end

    return widget
end

ns[ns.WIDGET.EDIT_BOX] = function()
    local widget = ChireWidget(ns.WIDGET.EDIT_BOX)

    widget.editbox:SetPoint("BOTTOMLEFT", 6, 2)
    widget.button:SetPoint("RIGHT", 1, 0.5)
    widget.button:SetText("OK")

    return widget
end

ns[ns.WIDGET.COLOR_PICKER] = function()
    local widget = ChireWidget(ns.WIDGET.COLOR_PICKER)

    widget.colorSwatch:SetWidth(19.5)
    widget.colorSwatch:SetHeight(19.8)

    widget.colorSwatch.background:SetWidth(17)
    widget.colorSwatch.background:SetHeight(17)

    widget.colorSwatch.checkers:SetWidth(15.5)
    widget.colorSwatch.checkers:SetHeight(14)

    widget.text:Hide()

    return widget
end

ns[ns.WIDGET.FONT_SELECTOR] = function()
    local widget = ChireWidget(ns.WIDGET.FONT_SELECTOR)
    local OnAcquire = widget.OnAcquire

    widget.OnAcquire = function(self)
        OnAcquire(self)

        self.pullout.maxHeight = 250

        local AddItem = self.pullout.AddItem
        self.pullout.AddItem = function(pullout, item)
            if (item.text) then
                local _, size, style = item.text:GetFont()
                item.text:SetFontObject(ns.FontObject(item:GetText(), size, style))
            end

            AddItem(pullout, item)
        end
    end

    return widget
end
