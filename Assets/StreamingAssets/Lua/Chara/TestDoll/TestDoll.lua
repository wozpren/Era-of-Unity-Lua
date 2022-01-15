local b = require("Data/身体")

---@class Character
---@field 检查占用 any
---@field 获取外层装备 Equip
---@field 获取装备厚度 Equip
local chara =
{
    Type = "Character",--表类型，无需修改
    ID = 0, --ID仅在加入玩家数据时生成
    名字 = "测试人形",
    性别 = 2,--指外貌 请使用数字 1为男，2为女，3为中性
    口上 = "TestDoll", --口上将从 Chara\口上 的搜索文件夹下搜索
    年龄 = 24,
    体力 = 100,
    精力 = 100,


    天赋 = {},
    特殊经验 = {},
    经验 = {},
    能力 = {},
    宝珠 = {},
    刻印 = {},
    衣服 = {},

    头 = b.头(),
    嘴 = b.嘴(),
    身体 = b.身体(),
    胸 = b.胸(),
    手 = b.手(),
    胯部 = b.胯部(),
    小穴 = b.小穴(),
    子宫 = b.子宫(),
    阴蒂 = b.阴蒂(),
    阴茎 = {},
    直肠 = b.直肠(),
    腿 = b.腿(),
    脚 = b.脚(),
}

--设置元数据
CharaManager:SetMetatable(chara)
return chara