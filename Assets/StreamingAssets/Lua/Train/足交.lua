local t = {}
function t:SexActive(active, Active, Select)
    local base = TrainManager:ServicePlay(active)
    base.欲情追加 = base.欲情追加 + TrainManager:AddLust(active)
    base.屈从 = base.屈从 + 400
    base.逃脱 = base.逃脱 + 400
    base.不洁 = base.不洁 + 500

    local samen = TrainManager:精液处理(active.调教者,  active.被调教者, 100, "足")
    active.调教者:精液(samen)

    TrainManager:获得经验("足交经验", 1)
    return base
end

function t:TrainMessage(active)
    local text = SB:New()
    text:Append("素股")
    UIManager:GetUI("TrainView"):Append(text:ToStr(), active)
end

function t:SexType(type)
    if type == "侍奉快乐" or type == "嗜虐快乐" then
        return true
    elseif type == "侍奉" then
        return true
    end
    return false
end



function t:Check(Trainer, Female, Select)
    Message:AddMessage("足交")
    local value, text = TrainManager:AllowAction(Trainer, Female)

    local n = Female:获取能力("施虐属性")
    value = TrainManager:OrderRequire(Female, value, text, "abl", "施虐属性", n * 5)

    n = Female:获取能力("侍奉技术")
    value = TrainManager:OrderRequire(Female, value, text, "abl", "侍奉技术", n * 5)

    n = Female:获取能力("精液中毒")
    value = TrainManager:OrderRequire(Female, value, text, "abl", "精液中毒", n * 3)

    value = TrainManager:OrderRequire(Female, value, text, "talent", "强硬", 10)
    value = TrainManager:OrderRequire(Female, value, text, "talent", "高傲", 5)
    value = TrainManager:OrderRequire(Female, value, text, "talent", "害羞", -5)
    value = TrainManager:OrderRequire(Female, value, text, "talent", "否定快感", -1)

    return TrainManager:ShowOrder(value, text, 30), Select
end

---@return ActiveMsg
function t:GetActive(trainer, trainee, select)
    local o =
    {
        ---@type Character
        调教者 = trainer,
        ---@type Character
        被调教者 = trainee,
        执行 = trainee.脚部,
        目标 = trainer.阴部,
        sex = self,
        体力减少 = 5,
        行为 = "足交",
        选择 = select,
        次数 = 1,
    }
    return o
end


return t