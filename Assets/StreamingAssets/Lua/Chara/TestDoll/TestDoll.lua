---@class Character
local chara =
{
    Type = "Character",--表类型，无需修改
    ID = 0, --ID仅在加入玩家数据时生成
    名字 = "测试人形",
    性别 = 0,--指外貌 请使用数字 1为男，2为女，3为中性
    口上 = "TestDoll", --口上将从 Chara\口上 的搜索文件夹下搜索
    年龄 = 24,
    天赋 = {},
    特殊经验 = {},
    经验 = {},
    能力 = {},
    宝珠 = {},
    刻印 = {},
}

--设置元数据
CharaManager:SetMetatable(chara)
return chara