local t = {}
function t:SexActive(active, Active, Select)
    local base = TrainManager:SMPlay(active, "强制口交")
    local Female = active.被调教者
    local Trainer = active.调教者

    base = base + TrainManager:ServicePlay(active)
    base.不洁 = 200
    base.屈从 = 3000
    base.逃脱 = 3000

    base.嘴部快感 = Female:计算刺激度("嘴部", 2)

    local c = active.目标.扩张度 - active.执行.大小
    if c <= -2 then
        base.疼痛 = 3000
        base.恐惧 = 8000
        base.嘴部快感 = 0
    elseif c == -1 then
        base.疼痛 = 1000
        base.恐惧 = 3000
        base.嘴部快感 = 0
    elseif c == 0 then
        base.疼痛 = 500
        base.恐惧 = 1000
    elseif c == 1 then
        base.疼痛 = 100
        base.恐惧 = 300
    end
    if active.执行.硬度 == 3 then
        base.疼痛 = base.疼痛 * 1.2
        base.恐惧 = base.恐惧 * 1.2
    elseif active.执行.硬度 == 4 then
        base.疼痛 = base.疼痛 * 1.5
        base.恐惧 = base.恐惧 * 1.5
    end
    local sn = Female:获取能力("受虐属性")
    if sn == 1 then
        base.屈从 = base.屈从 * 1.2
        base.恐惧 = base.恐惧 * 0.8
    elseif sn == 2 then
        base.屈从 = base.屈从 * 1.5
        base.恐惧 = base.恐惧 * 0.5
    elseif sn == 3 then
        base.屈从 = base.屈从 * 2
        base.恐惧 = base.恐惧 * 0.2
    elseif sn == 4 then
        base.屈从 = base.屈从 * 2.5
        base.恐惧 = base.恐惧 * 0.1
    elseif sn >= 5 then
        base.屈从 = base.屈从 * 3
        base.恐惧 = base.恐惧 * 0.05
    end

    if TrainManager:检查占用(Female, "嘴部", "阴茎") then
        base.屈从 = base.屈从 * 1.5
        base.恐惧 = base.恐惧 * 1.5
        base.不洁 = base.不洁 * 1.5
        base.逃脱 = base.逃脱 * 1.5
        base.性行动 = base.性行动 * 1.5
        base.成就感 = base.成就感 * 1.5
        base.嘴部快感 = base.嘴部快感 * 1.5
        base.疼痛 = base.疼痛 * 1.5
    end

    if Female:检查特性("嘴部性向") then
        TrainManager:性癖增益(base, base.嘴部快感)
    end
    
    local samen = TrainManager:精液处理(Trainer, Female, 150, "口")
    Trainer:精液(samen)

    TrainManager:获得经验("口交经验", 1, Female)
    return base
end

function t:SexType(type)
    if type == "中度SM" or type == "被虐快乐" then
        return true
    elseif type == "SM" then
        return true
    end

    return false
end

function t:TrainMessage(active)
    local text = SB:New()
    text:Append("强制口交")
    UIManager:GetUI("TrainView"):Append(text:ToStr(), active)
end


function t:Check(Trainer, Female, Select)
    local value, text = TrainManager:AllowAction(Trainer, Female)
    local n = Female:获取能力("侍奉技术")
    value = TrainManager:OrderRequire(Female, value, text, "abl", "侍奉技术", n * 2)
    
    n = Female:获取能力("受虐属性")
    value = TrainManager:OrderRequire(Female, value, text, "abl", "受虐属性", n * 3)
    
    n = Female:获取能力("精液中毒")
    value = TrainManager:OrderRequire(Female, value, text, "abl", "精液中毒", n * 3)
    
    value = TrainManager:OrderRequire(Female, value, text, "talent", "害羞", -5)
    value = TrainManager:OrderRequire(Female, value, text, "talent", "献身", 6)
    value = TrainManager:OrderRequire(Female, value, text, "talent", "否定快感", -1)
    value = TrainManager:OrderRequire(Female, value, text, "talent", "嘴部性向", 10)
    value = TrainManager:OrderRequire(Female, value, text, "equip", "拘束", 30)
    value = TrainManager:OrderRequire(Female, value, text, "equip", "环形口枷", 30)
    
    
    return TrainManager:ShowOrder(value, text, 15), Select
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
        执行 = trainee.嘴部,
        目标 = trainer.阴部,
        sex = self,
        体力减少 = 16,
        行为 = "强制口交",
        选择 = select,
        次数 = 1,
    }

    return o
end

return t