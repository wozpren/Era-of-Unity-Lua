function t:SexActive(Active, Select)
    local base = ServicePlay()

    base.不洁 = base.不洁 + 100
    base.欲情追加 = base.欲情追加 + Train.AddLust()
    base.屈从 = base.屈从 + 500
    base.逃脱 = base.逃脱 + 100


    TrainManager:获得经验("手淫经验", 1)
    base.Samen = base.Samen + 500 + base.ABLTech * 7
    MultiSet(base, "手")
    if Select == "手交口交" then
        dofile("口交")
        local t = SexActive("口交")
        MultData(base, 0.5)
        MultData(t, 0.5)
        base = base + t
        dofile("手淫")
    end

    return base
end

function t:TrainMessage()
    ImplementKoujiu("手淫")
end

function t:SexType(type)
    if type == "侍奉" then
        return true
    elseif type == "侍奉快乐" then
        return true
    end
    return false
end





function t:Check(Trainee, Female, Select)
    local value, text = TrainManager:AllowAction()

    local temp = Train.GetAbility("侍奉技术")
    if temp > 0 then
        value = value + math.min(temp, 10) * 2
        SB.append(text,"侍奉技术: +"..temp)
    end
    temp = Train.GetAbility("精液中毒")
    if temp > 0 then
        value = value + math.min(temp, 5) * 2
        SB.append(text,"精液中毒: +"..temp)
    end
    
    if(Female: HaveTalent("强硬")) then
        value = value - 5
        SB.append(text,"强硬: -5")
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
        value = value - 3
        SB.append(text,"否定快感: -3")
    end
    SB.append(text," = "..value)
    if value > 14 then
        SB.append(text," > 14")
    elseif value == 14 then
        SB.append(text," = 14")
    else
        SB.append(text," < 14")
    end
    
    Message : AddMessage(text:ToStr())
    if value >= 14 then
        return true
    else
        return false
    end
end