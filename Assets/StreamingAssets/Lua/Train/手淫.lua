local t = {}
function t:SexActive(active, Active, Select)
    local base = TrainManager:ServicePlay(active)

    base.不洁 = base.不洁 + 100
    base.欲情追加 = base.欲情追加 + TrainManager:AddLust(active)
    base.屈从 = base.屈从 + 500
    base.逃脱 = base.逃脱 + 100

    local samen = TrainManager:精液处理(active.调教者, active.被调教者, 100, "手")
    active.调教者:精液(samen)

    if Select == "手交口交" then
        TrainManager:添加行为(active["调教者"], active["被调教者"], "口交", "口交", 0.5)
        active.乘数 = 0.5
    end
    TrainManager:获得经验("手淫经验", 1)

    return base
end

function t:TrainMessage(active)
    local text = SB:New()
    text:Append("手淫")
    UIManager:GetUI("TrainView"):Append(text:ToStr(), active)
end

function t:SexType(type)
    if type == "侍奉" then
        return true
    elseif type == "侍奉快乐" then
        return true
    end
    return false
end


function t:Check(Trainer, Female, Select)
    Message:AddMessage("手淫")
    local value, text = TrainManager:AllowAction(Trainer, Female)

    local temp = Female:获取能力("侍奉技术")
    value = TrainManager:OrderRequire(Female, value, text, "abl", "侍奉技术", temp * 2)
    local temp = Female:获取能力("精液中毒")
    value = TrainManager:OrderRequire(Female, value, text, "abl", "精液中毒", temp * 2)
    
    value = TrainManager:OrderRequire(Female, value, text, "talent", "强硬", -5)
    value = TrainManager:OrderRequire(Female, value, text, "talent", "害羞", -5)
    value = TrainManager:OrderRequire(Female, value, text, "talent", "献身", 6)
    value = TrainManager:OrderRequire(Female, value, text, "talent", "否定快感", -3)
    
    return TrainManager:ShowOrder(value, text, 0), Select
end

---@return ActiveMsg
function t:GetActive(trainer, trainee, select)
    
    ---@class ActiveMsg
    local o = 
    {
        ---@type Character
        调教者 = trainer,
        ---@type Character
        被调教者 = trainee,
        执行 = trainee.手部,
        目标 = trainer.阴部,
        sex = self,
        体力减少 = 5,
        行为 = "手淫",
        选择 = select,
        次数 = 1,
    }

    return o
end

return t