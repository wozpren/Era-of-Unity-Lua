local t = {}
function t:SexActive(active, Active, Select)
    local base = require("Data/ActionPack"):New()
    base.不洁 = 200
    base.屈从 = 100
    base.情爱 = 300
    base.性行动 = 300
    base.成就感 = 300
    local Female = active.被调教者
    local JS = active.执行.技巧 or 0


    base.嘴部快感 = Female:计算刺激度("嘴部", 1)
    base.嘴部快感 = TrainManager:EXABL(JS, base.嘴部快感)

    if TrainManager["上次行为"] == "接吻" then
        base.情爱 = base.情爱 + 200
        base.性行动 = base.性行动 + 200
        base.成就感 = base.成就感 + 100
        base.屈从 = base.屈从 + 100
    end

    if Female:检查特性("嘴部性向") then
        TrainManager:性癖增益(base, base.嘴部快感)
    end

    TrainManager:获得经验("接吻经验", 1)
    TrainManager:获得经验("接吻经验", 1, active.调教者)
    return base
end

function t:TrainMessage(active)
    local text = SB:New()
    text:Append("接吻。")
    UIManager:GetUI("TrainView"):Append(text:ToStr(), active)
end


function t:SexType(type)
    if type == "爱抚" or type == "侍奉快乐" then
        return true
    end
    return false
end


function t:Check(Trainer, Female, Select)
    local value, text = TrainManager:AllowAction(Trainer, Female)
    local n = Female:获取能力("侍奉技术")
    value = TrainManager:OrderRequire(Female, value, text, "abl", "侍奉技术", n * 2)


    value = TrainManager:OrderRequire(Female, value, text, "feel", "嘴部")

    value = TrainManager:OrderRequire(Female, value, text, "talent", "贞操重视", -20)
    value = TrainManager:OrderRequire(Female, value, text, "talent", "不在乎贞操", 20)
    value = TrainManager:OrderRequire(Female, value, text, "talent", "害羞", -3)
    value = TrainManager:OrderRequire(Female, value, text, "talent", "不知羞耻", 3)
    value = TrainManager:OrderRequire(Female, value, text, "talent", "否定快感", -1)

    return TrainManager:ShowOrder(value, text, 20), Select
end

---@return ActiveMsg
function t:GetActive(trainer, trainee, select)
    local o = 
    {
        ---@type Character
        调教者 = trainer,
        ---@type Character
        被调教者 = trainee,
        执行 = trainer.嘴部,
        目标 = trainee.嘴部,
        sex = self,
        体力减少 = 5,
        行为 = "接吻",
        选择 = select,
        次数 = 1,
    }

    return o
end

return t