function t:SexActive(Active, Select)
    local base = SMPlay("强制口交")
    base = base + ServicePlay()
    base.不洁 = 200
    base.屈从 = 3000
    base.逃脱 = 3000

    base.嘴部快感 = Female:计算刺激度("M刺激")

    local c = Train.GetAbility("喉扩张") - Trainer.Stature.JJSize
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
    if Trainer.Stature.JJHard == 3 then
        base.疼痛 = base.疼痛 * 1.2
        base.恐惧 = base.恐惧 * 1.2
    elseif Trainer.Stature.JJHard == 4 then
        base.疼痛 = base.疼痛 * 1.5
        base.恐惧 = base.恐惧 * 1.5
    end
    local sn = Train.GetAbility("受虐属性")
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

    if Train.Pos["嘴"] == "JJ" then
        base.屈从 = base.屈从 * 1.5
        base.恐惧 = base.恐惧 * 1.5
        base.不洁 = base.不洁 * 1.5
        base.逃脱 = base.逃脱 * 1.5
        base.性行动 = base.性行动 * 1.5
        base.成就感 = base.成就感 * 1.5
        base.嘴部快感 = base.嘴部快感 * 1.5
        base.疼痛 = base.疼痛 * 1.5

    end

    if Female:检查特性("唇性向") then
        TrainManager:性癖增益(base, base.嘴部快感)
    end
    
    if Train.Pos["嘴"] == "JJ" then
        base.Samen =  base.Samen + Abl_T(Female) * 100
    else
        base.Samen =  base.Samen + Abl_T(Female) * 30
    end
    local c = Trainer.Stature.JJSize - Train.GetAbility("喉扩张")
    if c >= 3 then
        base.Samen = base.Samen * 0.1
    elseif c == 2 then
        base.Samen = base.Samen * 0.3
    elseif c == 1 then
        base.Samen = base.Samen * 0.7
    end


    TrainManager:获得经验("口交经验", 1, Female)
    TrainManager:获得经验("喉性交经验", 1, Female)

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

function t:TrainMessage()
end


function t:Check()
    local value, text = Train.AllowAction()
    local n = Train.GetAbility("侍奉技术")
    value = OrderRequire(value, text, "abl", "侍奉技术", n * 2)
    
    n = Train.GetAbility("受虐属性")
    value = OrderRequire(value, text, "abl", "受虐属性", n * 3)
    
    n = Train.GetAbility("精液中毒")
    value = OrderRequire(value, text, "abl", "精液中毒", n * 3)
    
    value = OrderRequire(value, text, "talent", "害羞", -5)
    value = OrderRequire(value, text, "talent", "献身", 6)
    value = OrderRequire(value, text, "talent", "否定快感", -1)
    value = OrderRequire(value, text, "talent", "唇性向", 10)
    value = OrderRequire(value, text, "equip", "拘束", 30)
    value = OrderRequire(value, text, "equip", "环形口枷", 30)
    
    
    return Train.ShowOrder(value, text, 40)
end