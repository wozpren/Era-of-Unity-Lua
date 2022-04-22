local b = require("Data/身体")

---@class Character
---@field 精液 function
---@field 检查性玩具 function
---@field 恢复精力 function
---@field 恢复体力 function
---@field 检查占用 function
---@field 检查能力 function
---@field 检查特性 function
---@field 获取经验 function
---@field 检查状态 function
---@field 设置状态 function
---@field 特性修正 function
---@field 获取能力 function
---@field 能力提升 function
---@field 设置能力 function
---@field 调用口上 function
---@field 计算刺激度 function
---@field 获取淫纹等级 function
---@field 获取外层装备 function
---@field 获取装备厚度 function
local chara =
{
    Type = "Character",--表类型，无需修改
    ID = 0, --ID仅在加入玩家数据时生成
    名字 = "测试人形",
    性别 = "女",--指外貌 男，女，中性
    口上 = "TestDoll", --口上将从 [口上]\KouJiu 的文件夹下搜索
    年龄 = 24,
    体力 = 100,
    精力 = 100,


    特性 = {"接受快感","唇性向"},
    特殊经验 = {},
    经验 = {},
    能力 = {顺从=2, 欲望=2},

    宝珠 = require("Data/宝珠"):New(),
    刻印 = require("Data/刻印"):New(),
    衣服 = {},
    状态 = {},

    头部 = b.头部(),
    嘴部 = b.嘴部(),
    身体 = b.身体(),
    胸部 = b.胸部(),
    手部 = b.手部(),
    胯部 = b.胯部(),
    小穴 = b.小穴(),
    子宫 = b.子宫(),
    阴部 = b.阴蒂(),
    尿道 = b.尿道(),
    菊穴 = b.菊穴(),
    腿部 = b.腿部(),
    脚部 = b.脚部(),
}


--设置元数据
CharaManager:SetMetatable(chara)
return chara