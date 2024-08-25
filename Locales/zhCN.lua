local addonName, ns = ...
local L = LibStub("AceLocale-3.0"):NewLocale(addonName, "zhCN")
if not L then return end

function ns.Desc(key)
    return key .. ".desc"
end

function ns.Alt(key)
    return key .. ".alt"
end

local function Gap(width)
    return (" "):rep(width)
end

L[addonName] = "Chire Tweaks"

L["colorPicker.invalid"] = "请输入有效的十六进制颜色代码。\n(格式是 #RRGGBB 或 #AARRGGBB)\n或者使用选色器。\n\n默认颜色：#%s"
L["colorPicker"] = "选色器"
L[ns.Desc("colorPicker")] = "你可以用选色器更改颜色，或者在左侧输入框直接输入颜色的 16 进位制颜色代码，格式是 #AARRBBGG、#RRBBGG。\n\n右侧的按钮可以将颜色重置为默认（ #%s）。"

L["offset.invalid"] = "请输入有效的数字。\n\n范例座标：-420.69"

L["button.reset"] = "重置为默认值"
L["button.copy"] = "复制"

L["copy.from"] = "复制设置自："
L["copy.to"] = "复制设置至："

L["statusText"] = "状态文字："
L[ns.Desc("statusText")] = "全局设置，会套用至所有框架中。\n\n等同于 esc > 选项 > 界面 > 状态文字"

L["tab.desc"] = "设置 %s 单位框架"

L["nameLevel.header.name"] = "名字"
L["nameLevel.header.nameLevel"] = "名字 & 等级"
L["formats.header"] = "状态条文字 - 格式与字体"

L["castbar.header.name"] = "施法条"

L[ns.TYPE.HEALTH] = "血量值"
L[ns.TYPE.MANA] = "法力值"
L[ns.TYPE.POWER] = "其他资源"
L[ns.TYPE.NAME] = "名字"
L[ns.Desc(ns.TYPE.NAME)] = "显示 %s 名字"
L[ns.TYPE.LEVEL] = "等级"
L[ns.Desc(ns.TYPE.LEVEL)] = "显示 %s 等级"
L[ns.TYPE.HP_BAR] = "血量值状态条颜色"
L[ns.TYPE.HIDE] = "图标 & 边角指示 & 发光效果"
L[ns.TYPE.CASTBAR] = "施法条"
L[ns.Desc(ns.TYPE.CASTBAR)] = "移动施法条。\n\n只作用于依附在头像下方的施法条。Works only with the attached castbar."
L[ns.TYPE.CASTBAR_TIMER] = "施法时间"
L[ns.Desc(ns.TYPE.CASTBAR_TIMER)] = "显示施法时间"
L[ns.TYPE.CHAT] = "Chat"

L[ns.UNIT.PLAYER] = "玩家"
L[ns.UNIT.PET] = "玩家宠物"
L[ns.UNIT.TARGET] = "目标"
L[ns.UNIT.TOT] = "目标的目标"
L[ns.UNIT.FOCUS] = "焦点"
L[ns.UNIT.TOF] = "焦点目标"
L[ns.UNIT.BOSS] = "首领"
L[ns.UNIT.BG] = "战场旗手"
L[ns.UNIT.PARTY] = "队伍"
L[ns.UNIT.ALL] = "全部"

L[ns.CVAR_STATUS_TEXT.NUMERIC] = "置中"
L[ns.CVAR_STATUS_TEXT.PERCENT] = "百分比"
L[ns.CVAR_STATUS_TEXT.BOTH] = "在两侧"
L[ns.CVAR_STATUS_TEXT.NONE] = "无"

L[ns.DEAD] = "死亡"
L[ns.GHOST] = "鬼魂"
L[ns.UNCONSCIOUS] = "不省人事"

L[ns.FORMAT.NONE] = "无"
L[ns.FORMAT.CURRENT] = "当前值"
L[ns.FORMAT.CURRENT_MAX] = "当前值 / 最大值"
L[ns.FORMAT.PERCENT] = "百分比"
L[ns.FORMAT.CURRENT_PERCENT] = "当前值 – 当前百分比"
L[ns.FORMAT.CURRENT_MAX_PERCENT] = "当前值 / 最大值 (百分比)"
L[ns.FORMAT_DEAD] = "死亡/鬼魂"

L[ns.Alt(ns.FORMAT.NONE)] = "无"
L[ns.Alt(ns.FORMAT.CURRENT)] = Gap(27) .. "当前值"
L[ns.Alt(ns.FORMAT.CURRENT_MAX)] = Gap(17) .. "当前值 / 最大值"
L[ns.Alt(ns.FORMAT.PERCENT)] = "百分比" .. Gap(28)
L[ns.Alt(ns.FORMAT.CURRENT_PERCENT)] = "百分比" .. Gap(16) .. "当前值"
L[ns.Alt(ns.FORMAT.CURRENT_MAX_PERCENT)] = "百分比" .. Gap(6) .. "当前值 / 最大值"

L[ns.STYLE.NONE] = "无"
L[ns.STYLE.OUTLINE] = "描边"
L[ns.STYLE.THICK_OUTLINE] = "厚描边"
L[ns.STYLE.MONOCHROME] = "像素字"
L[ns.STYLE.OUTLINE_MONOCHROME] = "像素描边"
L[ns.STYLE.THICK_OUTLINE_MONOCHROME] = "像素厚描边"

L[ns.KEY.BASE] = "通常"
L[ns.KEY.HOVER] = "指向"
L[ns.KEY.FULL] = "100%"
L[ns.KEY.ZERO] = "归零"
L[ns.KEY.FONT] = "字体"
L[ns.KEY.STYLE] = "样式"
L[ns.KEY.SIZE] = "大小"
L[ns.KEY.COLOR] = "颜色"
L[ns.KEY.X] = "位置"

L[ns.KEY.ICON] = "显示图标"
L[ns.Desc(ns.KEY.ICON)] = "显示施法条图标"
L[ns.KEY.COLOR_LEVEL] = "动态染色"
L[ns.Desc(ns.KEY.COLOR_LEVEL)] = "默认情况下，等级文字的颜色取决于敌对目标的等级。"
L[ns.KEY.COLOR_CLASS] = "血量条职业染色"
L[ns.KEY.COLOR_CLASS_PP] = "宠物血量条职业染色"
L[ns.KEY.COLOR_REACTION] = "血量条阵营染色"
L[ns.KEY.NAME_CENTERED] = "置中"
L[ns.Desc(ns.KEY.NAME_CENTERED)] = "将名字置中。"
L[ns.KEY.GLOW_REPUTATION] = "隐藏阵营底色"
L[ns.Desc(ns.KEY.GLOW_REPUTATION)] = "隐藏名字和等级背后的背景色。"
L[ns.KEY.GLOW_BLINKING_REST] = "隐藏休息时在头像上闪烁的黄色发光效果"
L[ns.KEY.GLOW_BLINKING_COMBAT] = "隐藏战斗中在头像上闪烁的红色发光效果"
L[ns.KEY.GLOW_THREAT] = "隐藏仇恨高亮"
L[ns.KEY.GLOW_THREAT_PP] = "隐藏宠物仇恨高亮"
L[ns.KEY.GLOW_STATIC_DEBUFF] = "隐藏减益图标高亮"
L[ns.KEY.INDICATOR_GROUP] = "隐藏队伍编号"
L[ns.KEY.INDICATOR_HIT] = "隐藏头像上的战斗文字"
L[ns.KEY.ICON_REST] = "隐藏休息动画"
L[ns.Desc(ns.KEY.ICON_REST)] = "隐藏头像上方的 zZz 休息动画"
L[ns.KEY.ICON_CORNER] = "隐藏边角图标"
L[ns.KEY.ICON_COMBAT] = "隐藏战斗状态图标"
L[ns.KEY.ICON_ROLE] = "隐藏职责图标"
L[ns.KEY.ICON_LEADER] = "隐藏队长图标"
L[ns.KEY.ICON_GUIDE] = "隐藏地城向导图标"
L[ns.KEY.ICON_RAID] = "隐藏团队标记"
L[ns.Desc(ns.KEY.ICON_RAID)] = "隐藏头像上方的团队标记"
L[ns.KEY.ICON_BOSS] = "隐藏稀有图标"
L[ns.Desc(ns.KEY.ICON_BOSS)] = "Hide the small round star icon at the bottom of the portrait"
L[ns.KEY.ICON_QUEST] = "隐藏任务图标"
L[ns.Desc(ns.KEY.ICON_QUEST)] = "Hide the small round quest icon at the bottom of the portrait"
L[ns.KEY.ICON_PET_BATTLE] = "隐藏小宠物战斗图标"
L[ns.KEY.ICON_PVP] = "隐藏 PVP 状态图标"
L[ns.KEY.TIMER_PVP] = "隐藏 PVP 状态计时"
