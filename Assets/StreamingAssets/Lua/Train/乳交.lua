local t = {}
function t:SexActive(active, Active, Select)
    local base = TrainManager:ServicePlay(active)
    local Female = active.被调教者
    base.不洁 = base.不洁 + 100
    base.欲情追加 = base.欲情追加 + TrainManager:AddLust(active)
    base.屈从 = base.屈从 + 1800
    base.逃脱 = base.逃脱 + 300

    if Female:检查特性("巨乳") then
        base.逃脱 = base.逃脱 - 200
    elseif Female:检查特性("贫乳") then
        base.逃脱 = base.逃脱 + 400
    end

    base.胸部快感 = Female:计算刺激度("胸部")

    if Female:检查特性("胸性向") then
        TrainManager:性癖增益(base, base.胸部快感)
    end

    TrainManager:获得经验("乳交经验", 1)
    local samen = TrainManager:精液处理(active.调教者, Female, 100, "乳")
    active.调教者:精液(samen)

    if Select == "乳夹口交" then
        TrainManager:添加行为(active.调教者, active.被调教者, "口交", "乳夹口交", 0.5)
        active.乘数 = 0.5
    end


    return base
end


function t:TrainMessage(active)
    local text = SB:New()
    text:Append("@target@用胸部将@player@肉棒包裹住。")
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
    local value, text = TrainManager:AllowAction(Trainer, Female)
    local n = Female:获取能力("侍奉技术")
    value = TrainManager:OrderRequire(Female, value, text, "abl", "侍奉技术", n * 2)
    local n = Female:获取能力("精液中毒")
    value = TrainManager:OrderRequire(Female, value, text, "abl", "侍奉技术", n * 3)

    value = TrainManager:OrderRequire(Female, value, text, "talent", "害羞", -3)
    value = TrainManager:OrderRequire(Female, value, text, "talent", "献身", 6)
    value = TrainManager:OrderRequire(Female, value, text, "talent", "否定快感", -1)
    value = TrainManager:OrderRequire(Female, value, text, "talent", "胸性向", 10)

    
    return TrainManager:ShowOrder(value, text, 30),Select
end

---@return ActiveMsg
function t:GetActive(trainer, trainee, select)
    local o = 
    {
        ---@type Character
        调教者 = trainer,
        ---@type Character
        被调教者 = trainee,
        执行 = trainee.胸部,
        目标 = trainer.阴部,
        sex = self,
        体力减少 = 5,
        行为 = "乳交",
        选择 = select,
        次数 = 1,
    }

    return o
end

return t