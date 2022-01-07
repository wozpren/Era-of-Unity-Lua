function SexActive(Active, Select)
    local base = ActiveData.new()
    base.不洁 = 200
    base.屈服 = 100
    base.情爱 = 300
    base.性行动 = 300
    base.达成感 = 300

    local JS = Train.GetAbility("技术")


    base.M快乐 = trainData : CalcfStimulate("M刺激", 1)
    base.M快乐 = EXABL(JS, base.M快乐)

    if trainData : PrevPlay("接吻")  ~= 0 then
        base.情爱 = base.情爱 + 200
        base.性行动 = base.性行动 + 200
        base.达成感 = base.达成感 + 100
        base.屈服 = base.屈服 + 100
    end

    if Train.HaveTalent("M性向") then
        Train.LovePlay(base, base.M快乐)
    end

    AddSexexp("接吻经验", 1)
    AddSexexp("接吻经验", 1, Trainer)
    return base
end

function TrainMessage()
    ImplementKoujiu("自慰")
end


function SexType(type)
    if type == "爱抚" or type == "侍奉快乐" then
        return true
    end
    return false
end


function Check()
    local value, text = Train.AllowAction()

    local temp = Train.GetAbility("侍奉技术")
    if temp > 0 then
        value = value + temp * 2
        SB.append(text,"侍奉技术: "..temp * 2)
    end
    
    if Train.HaveTalent("不在乎贞操") then
        value = value + 20
        SB.append(text,"不在乎贞操: 20")
    end
    
    if Train.HaveTalent("害羞") then
        value = value - 3
        SB.append(text,"害羞: -3")
    elseif Train.HaveTalent("不知羞耻") then
        value = value + 3
        SB.append(text,"不知羞耻: 3")
    end
    
    if Train.HaveTalent("献身") then
        value = value + 6
        SB.append(text,"献身: 6")
    end
    
    if Train.HaveTalent("否定快感") then
        value = value - 1
        SB.append(text,"否定快感: -1")
    end
    
    temp = enumtonumber(Female.Feel) * 5
    if temp > 0 then
        value = value + temp
        SB.append(text, tostring(Female.Feel)..": +"..temp)
    end
    
    
    return Train.ShowOrder(value, text, 20)
end