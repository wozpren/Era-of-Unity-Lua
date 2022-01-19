local t = {}
function t:SexActive(Active, Select)
    local base = ServicePlay()
    HPDown = HPDown + 100

    

    base.不洁 = base.不洁 + 200
    base.欲情追加 = Train.AddLust()
    base.屈从 = base.屈从 + 1500
    base.逃脱 = base.逃脱 + 500
    base.嘴部快感 = Female:计算刺激度("M刺激", 2)

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

        Train.PosOccupy("嘴", "肉棒")

        local gap = Train.GetAbility("喉扩张") - Trainer.Stature.JJSize
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
        if Train.GetAbility("顺从") >= 2 then
            base.逃脱 = base.逃脱 * 0.5
            base.恐惧 = base.恐惧 * 0.5
            base.情爱 = base.情爱 + 700 
        else
            base.逃脱 = base.逃脱 * 1.5
            base.恐惧 = base.恐惧 * 1.5
        end
    end

    if Female:检查特性("唇性向") then
        TrainManager:性癖增益(base, base.嘴部快感)
    end

    base.Samen = base.Samen + 500 + base.ABLTech * 6
    base.Samen = base.Samen + Train.GetAbility("精液中毒") * 100

    TrainManager:获得经验("口交经验", 1)
    if Train.Pos["嘴"] == "JJ" then
        base.Samen = base.Samen + ABL_T(Female) * 50
        TrainManager:获得经验("喉性交经验", 1)
    end
    MultiSet(base, "口")

    if Select == "口交自慰" then
        dofile("自慰")
        local t = SexActive("自慰")
        MultData(base, 0.5)
        MultData(t, 0.5)
        base = base + t
        dofile("口交")

    end

    return base
end

function t:TrainMessage()
    ImplementKoujiu("口交")
end

function t:SexType(type)
    if type == "侍奉" then
        return true
    elseif type == "侍奉快乐" then
        return true
    elseif trainData.Select == "深喉" and type == "嗜虐快乐" then
        return true
    end
    return false
end




function t:Check()
    local value, text = Train.AllowAction()

    local temp = Train.GetAbility("侍奉技术")
    
    if temp > 0 then
        value = value + math.min(temp, 10) * 2
        SB.append(text,"侍奉技术: +"..temp)
    end
    
    temp = Train.GetAbility("精液中毒")
    if temp > 0 then
        value = value + math.min(temp, 5) * 3
        SB.append(text,"精液中毒: +"..temp)
    end
    
    if(Female: HaveTalent("害羞")) then
        value = value - 5
        SB.append(text,"害羞: -5")
    end
    if(Female: HaveTalent("献身")) then
        value = value + 6
        SB.append(text,"献身: +6")
    end
    if(Female: HaveTalent("否定快感")) then
        value = value - 1
        SB.append(text,"否定快感: -1")
    end
    if(Female: HaveTalent("唇性向")) then
        value = value + 10
        SB.append(text,"唇性向: +10")
    end
    
    return Train.ShowOrder(value, text, 24)
end

return t