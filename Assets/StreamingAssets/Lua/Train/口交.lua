local t = {}



---@param active ActiveMsg
---@param Active any
---@param Select any
---@return ActionPack
function t:SexActive(active, Active, Select)
    local base = TrainManager:ServicePlay(active)
    local Female = active.被调教者
    local Trainer = active.调教者

    base.不洁 = base.不洁 + 200
    base.欲情追加 = TrainManager:AddLust(active)
    base.屈从 = base.屈从 + 1500
    base.逃脱 = base.逃脱 + 500
    base.嘴部快感 = Female:计算刺激度("嘴部", 2)

    if Select == "清洁口交" then
        base.成就感 = base.成就感 + 1000
        base.性行动 = base.性行动 + 1000
        base.嘴部快感 = base.嘴部快感 * 1.2
        base.屈从 = base.屈从 + 1000
    elseif Select == "深喉" then
        base.成就感 = base.成就感 * 1.5
        base.性行动 = base.性行动 * 1.5
        base.嘴部快感 = base.嘴部快感 * 1.5
        base.屈从 = base.屈从 * 2
        base.不洁 = base.不洁 * 1.5
        base.逃脱 = base.逃脱 * 6
        local gap = Female.嘴部.扩张度 - Trainer.阴部.大小
        if gap <= -2 then
            base.恐惧 = 3000
            base.疼痛 = 8000
        elseif gap == -1 then
            base.恐惧 = 1000
            base.疼痛 = 3000
        elseif gap == 0 then
            base.恐惧 = 500
            base.疼痛 = 1000
        elseif gap == 1 then
            base.恐惧 = 100
            base.疼痛 = 300
        end
    elseif Select == "阴茎接吻" then--修改
        base.成就感 = base.成就感 * 0.1 
        base.性行动 = base.性行动 * 0.1
        base.嘴部快感 = base.嘴部快感 * 1.5
        base.疼痛 = base.疼痛 * 0.1
        base.屈从 = base.屈从 * 0.5
        base.不洁 = base.不洁 * 1.5
        if Female.获取能力("顺从") >= 2 then
            base.逃脱 = base.逃脱 * 0.5
            base.恐惧 = base.恐惧 * 0.5
            base.情爱 = base.情爱 + 700
        else
            base.逃脱 = base.逃脱 * 1.5
            base.恐惧 = base.恐惧 * 1.5
        end
    end

    if Female:检查特性("嘴部性向") then
        TrainManager:性癖增益(base, base.嘴部快感)
    end

    local jy = (500 * active.执行.技巧) + (Female:获取能力("精液中毒") * 100) + 100
    if Female:检查特性("荡唇") then
        jy = jy * 1.5
    end
    Trainer:精液(jy)
    TrainManager:获得经验("口交经验", 1)

    if Select == "口交自慰" then
        TrainManager:添加行为(Female, Female, "自慰", nil, 0.5)
        active.乘数 = 0.5
    end

    return base
end

function t:TrainMessage(active)
    local text = SB:New()
    text:Append("@target@将@player@的肉棒含入口中。")
    UIManager:GetUI("TrainView"):Append(text:ToStr(), active)
end

function t:SexType(type)
    if type == "侍奉" then
        return true
    elseif type == "侍奉快乐" then
        return true
    elseif TrainManager.当前行为.选择 == "深喉" and type == "嗜虐快乐" then
        return true
    end
    return false
end


function t:Check(Trainee, Female, Select)
    Message:AddMessage("口交")
    local value, text = TrainManager:AllowAction(Trainee, Female)

    local temp = Female:获取能力("侍奉技术")
    value = TrainManager:OrderRequire(Female, value, text, "abl", "侍奉技术", temp * 3)
    local temp = Female:获取能力("精液中毒")
    value = TrainManager:OrderRequire(Female, value, text, "abl", "精液中毒", temp * 3)

    value = TrainManager:OrderRequire(Female, value, text, "talent", "害羞", -5)
    value = TrainManager:OrderRequire(Female, value, text, "talent", "献身", 6)
    value = TrainManager:OrderRequire(Female, value, text, "talent", "嘴部性向", 10)
    value = TrainManager:OrderRequire(Female, value, text, "talent", "荡唇", 10)
    value = TrainManager:OrderRequire(Female, value, text, "talent", "否定快感", -1)

    return TrainManager:ShowOrder(value, text, 22), Select
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
        体力减少 = 8,
        行为 = "口交",
        选择 = select,
        次数 = 1,
    }

    return o
end

return t