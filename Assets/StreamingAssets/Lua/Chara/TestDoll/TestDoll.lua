local b = require("Data/身体")

---@class Character
---@field 检查占用 function
---@field 检查能力 function
---@field 检查特性 function
---@field 获取经验 function
---@field 获取能力 function
---@field 能力提升 function
---@field 设置能力 function
---@field 调用口上 function
---@field 计算刺激度 function
---@field 获取外层装备 function
---@field 获取装备厚度 function
local chara =
{
    Type = "Character",--表类型，无需修改
    ID = 0, --ID仅在加入玩家数据时生成
    名字 = "测试人形",
    性别 = "女",--指外貌 男，女，中性
    口上 = "TestDoll", --口上将从 Chara\[口上] 的文件夹下搜索
    年龄 = 24,
    体力 = 100,
    精力 = 100,


    特性 = {},
    特殊经验 = {},
    经验 = {},
    能力 = {},
    宝珠 = require("Data/宝珠"):New(),
    刻印 = require("Data/刻印"):New(),
    衣服 = {},
    状态 = {},

    头 = b.头(),
    嘴 = b.嘴(),
    身体 = b.身体(),
    胸 = b.胸(),
    手 = b.手(),
    胯部 = b.胯部(),
    小穴 = b.小穴(),
    子宫 = b.子宫(),
    阴蒂 = b.阴蒂(),
    阴茎 = b.阴茎(),
    尿道 = b.尿道(),
    菊穴 = b.菊穴(),
    腿 = b.腿(),
    脚 = b.脚(),
}

--设置元数据
CharaManager:SetMetatable(chara)
return chara