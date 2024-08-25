local addonName, ns = ...
local L = LibStub("AceLocale-3.0"):NewLocale(addonName, "zhTW")
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

L["colorPicker.invalid"] = "請輸入有效的十六進位制顏色代碼。\n(格式是 #RRGGBB 或 #AARRGGBB)\n或者使用選色器。\n\n預設顏色：#%s"
L["colorPicker"] = "選色器"
L[ns.Desc("colorPicker")] = "你可以用選色器更改顏色，或者在左側輸入框直接輸入顏色的十六進位制顏色代碼，格式是 #AARRBBGG、#RRBBGG。\n\n右側的按鈕可以將顏色重置為預設（ #%s）。"

L["offset.invalid"] = "請輸入有效數字。\n\n座標設定範例：-420.69"

L["button.reset"] = "重置為預設值"
L["button.copy"] = "複製"

L["copy.from"] = "複製設定自："
L["copy.to"] = "複製設定至："

L["statusText"] = "狀態文字："
L[ns.Desc("statusText")] = "全局設定，會套用至所有框架中。\n\n等同於 esc > 選項 > 介面 > 狀態文字"

L["tab.desc"] = "設定 %s 單位框架"

L["nameLevel.header.name"] = "名字"
L["nameLevel.header.nameLevel"] = "名字 & 等級"
L["formats.header"] = "狀態條文字 - 格式與字型"

L["castbar.header.name"] = "施法條"

L[ns.TYPE.HEALTH] = "血量值"
L[ns.TYPE.MANA] = "法力值"
L[ns.TYPE.POWER] = "其他資源"
L[ns.TYPE.NAME] = "名字"
L[ns.Desc(ns.TYPE.NAME)] = "顯示 %s 名字"
L[ns.TYPE.LEVEL] = "等級"
L[ns.Desc(ns.TYPE.LEVEL)] = "顯示 %s 等級"
L[ns.TYPE.HP_BAR] = "血量值狀態條顏色"
L[ns.TYPE.HIDE] = "圖示 & 邊角指示 & 光暈發光效果"
L[ns.TYPE.CASTBAR] = "施法條"
L[ns.Desc(ns.TYPE.CASTBAR)] = "移動施法條。\n\nWorks only with the attached castbar."
L[ns.TYPE.CASTBAR_TIMER] = "施法時間"
L[ns.Desc(ns.TYPE.CASTBAR_TIMER)] = "顯示施法時間"
L[ns.TYPE.CHAT] = "Chat"

L[ns.UNIT.PLAYER] = "玩家"
L[ns.UNIT.PET] = "玩家寵物"
L[ns.UNIT.TARGET] = "目標"
L[ns.UNIT.TOT] = "目標的目標"
L[ns.UNIT.FOCUS] = "專注目標"
L[ns.UNIT.TOF] = "專注目標的目標"
L[ns.UNIT.BOSS] = "首領"
L[ns.UNIT.BG] = "戰場旗手"
L[ns.UNIT.PARTY] = "隊伍"
L[ns.UNIT.ALL] = "All"

L[ns.CVAR_STATUS_TEXT.NUMERIC] = "置中"
L[ns.CVAR_STATUS_TEXT.PERCENT] = "百分比"
L[ns.CVAR_STATUS_TEXT.BOTH] = "在兩側"
L[ns.CVAR_STATUS_TEXT.NONE] = "無"

L[ns.DEAD] = "死亡"
L[ns.GHOST] = "鬼魂"
L[ns.UNCONSCIOUS] = "Unconscious"

L[ns.FORMAT.NONE] = "無"
L[ns.FORMAT.CURRENT] = "當前值"
L[ns.FORMAT.CURRENT_MAX] = "當前值 / 最大值"
L[ns.FORMAT.PERCENT] = "百分比"
L[ns.FORMAT.CURRENT_PERCENT] = "當前值 – 當前百分比"
L[ns.FORMAT.CURRENT_MAX_PERCENT] = "當前值 / 最大值 (百分比)"
L[ns.FORMAT_DEAD] = "死亡/鬼魂"

L[ns.Alt(ns.FORMAT.NONE)] = "無"
L[ns.Alt(ns.FORMAT.CURRENT)] = Gap(27) .. "當前值"
L[ns.Alt(ns.FORMAT.CURRENT_MAX)] = Gap(17) .. "當前值 / 最大值"
L[ns.Alt(ns.FORMAT.PERCENT)] = "百分比" .. Gap(28)
L[ns.Alt(ns.FORMAT.CURRENT_PERCENT)] = "百分比" .. Gap(16) .. "當前值"
L[ns.Alt(ns.FORMAT.CURRENT_MAX_PERCENT)] = "百分比" .. Gap(6) .. "當前值 / 最大值"

L[ns.STYLE.NONE] = "無"
L[ns.STYLE.OUTLINE] = "描邊"
L[ns.STYLE.THICK_OUTLINE] = "厚描邊"
L[ns.STYLE.MONOCHROME] = "點陣"
L[ns.STYLE.OUTLINE_MONOCHROME] = "點陣字描邊"
L[ns.STYLE.THICK_OUTLINE_MONOCHROME] = "點陣字厚描邊"

L[ns.KEY.BASE] = "通常"
L[ns.KEY.HOVER] = "指向"
L[ns.KEY.FULL] = "100%"
L[ns.KEY.ZERO] = "歸零"
L[ns.KEY.FONT] = "字型"
L[ns.KEY.STYLE] = "樣式"
L[ns.KEY.SIZE] = "大小"
L[ns.KEY.COLOR] = "顏色"
L[ns.KEY.X] = "位置"

L[ns.KEY.ICON] = "顯示圖示"
L[ns.Desc(ns.KEY.ICON)] = "顯示施法條圖示"
L[ns.KEY.COLOR_LEVEL] = "動態著色"
L[ns.Desc(ns.KEY.COLOR_LEVEL)] = "預設情況下，等級文字的顏色取決於敵對目標的等級。"
L[ns.KEY.COLOR_CLASS] = "血量條職業著色"
L[ns.KEY.COLOR_CLASS_PP] = "寵物血量條職業著色"
L[ns.KEY.COLOR_REACTION] = "血量條陣營著色"
L[ns.KEY.NAME_CENTERED] = "置中"
L[ns.Desc(ns.KEY.NAME_CENTERED)] = "將名字置中。"
L[ns.KEY.GLOW_REPUTATION] = "隱藏陣營底色"
L[ns.Desc(ns.KEY.GLOW_REPUTATION)] = "隱藏名字和等級背後的背景色。"
L[ns.KEY.GLOW_BLINKING_REST] = "隱藏休息時在頭像上閃爍的黃色光暈"
L[ns.KEY.GLOW_BLINKING_COMBAT] = "隱藏戰鬥中在頭像上閃爍的紅色光暈"
L[ns.KEY.GLOW_THREAT] = "隱藏仇恨高亮"
L[ns.KEY.GLOW_THREAT_PP] = "隱藏寵物仇恨高亮"
L[ns.KEY.GLOW_STATIC_DEBUFF] = "隱藏減益圖示高亮"
L[ns.KEY.INDICATOR_GROUP] = "隱藏隊伍編號"
L[ns.KEY.INDICATOR_HIT] = "隱藏頭像上的戰鬥文字"
L[ns.KEY.ICON_REST] = "隱藏休息動畫"
L[ns.Desc(ns.KEY.ICON_REST)] = "隱藏頭像上方的「zZz」休息動畫"
L[ns.KEY.ICON_CORNER] = "隱藏邊角圖示"
L[ns.KEY.ICON_COMBAT] = "隱藏戰鬥狀態圖示"
L[ns.KEY.ICON_ROLE] = "隱藏職責圖示"
L[ns.KEY.ICON_LEADER] = "隱藏隊長圖示"
L[ns.KEY.ICON_GUIDE] = "隱藏地城嚮導圖示"
L[ns.KEY.ICON_RAID] = "隱藏團隊標記"
L[ns.Desc(ns.KEY.ICON_RAID)] = "隱藏頭像上方的團隊標記"
L[ns.KEY.ICON_BOSS] = "隱藏稀有圖示"
L[ns.Desc(ns.KEY.ICON_BOSS)] = "Hide the small round star icon at the bottom of the portrait"
L[ns.KEY.ICON_QUEST] = "隱藏任務圖示"
L[ns.Desc(ns.KEY.ICON_QUEST)] = "Hide the small round quest icon at the bottom of the portrait"
L[ns.KEY.ICON_PET_BATTLE] = "隱藏寵物戰鬥圖示"
L[ns.KEY.ICON_PVP] = "隱藏 PVP 狀態圖示"
L[ns.KEY.TIMER_PVP] = "隱藏 PVP 狀態計時"
