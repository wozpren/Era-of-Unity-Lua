function t:SexActive(Active, Select)
    local base = ActiveData.new()
    base.不洁 = 200
    base.屈从 = 100
    base.情爱 = 300
    base.性行动 = 300
    base.成就感 = 300

    local JS = Train.GetAbility("技巧")


    base.嘴部快感 = Female:计算刺激度("嘴", 1)
    base.嘴部快感 = TrainManager:EXABL(JS, base.嘴部快感)

    if trainData : PrevPlay("接吻")  ~= 0 then
        base.情爱 = base.情爱 + 200
        base.性行动 = base.性行动 + 200
        base.成就感 = base.成就感 + 100
        base.屈从 = base.屈从 + 100
    end

    if Female:检查特性("唇性向") then
        TrainManager:性癖增益(base, base.嘴部快感)
    end

    TrainManager:获得经验("接吻经验", 1)
    TrainManager:获得经验("接吻经验", 1, Trainer)
    return base
end

function t:TrainMessage()
    ImplementKoujiu("自慰")
end


function t:SexType(type)
    if type == "爱抚" or type == "侍奉快乐" then
        return true
    end
    return false
end


function t:Check(Trainee, Female, Select)
    local value, text = TrainManager:AllowAction()

    local temp = Train.GetAbility("侍奉技术")
    if temp > 0 then
        value = value + temp * 2
        SB.append(text,"侍奉技术: "..temp * 2)
    end
    
    if Female:检查特性("不在乎贞操") then
        value = value + 20
        SB.append(text,"不在乎贞操: 20")
    end
    
    if Female:检查特性("害羞") then
        value = value - 3
        SB.append(text,"害羞: -3")
    elseif Female:检查特性("不知羞耻") then
        value = value + 3
        SB.append(text,"不知羞耻: 3")
    end
    
    if Female:检查特性("献身") then
        value = value + 6
        SB.append(text,"献身: 6")
    end
    
    if Female:检查特性("否定快感") then
        value = value - 1
        SB.append(text,"否定快感: -1")
    end
    
    temp = enumtonumber(Female.Feel) * 5
    if temp > 0 then
        value = value + temp
        text:Append(tostring(Female.Feel)..": +"..temp)
    end
    
    
    return Train.ShowOrder(value, text, 20)
end