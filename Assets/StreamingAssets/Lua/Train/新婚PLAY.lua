function t:SexActive(Active, Select)
    if trainData.equipItem : Contains("新婚PLAY") then
        trainData.equipItem : Remove("新婚PLAY")
    else
        trainData.equipItem : Add("新婚PLAY")
    end


    local base = ActiveData.new()
    base.情爱 = 500
    base.逃脱 = 100

    local lv = Train.GetAbility("侍奉技术")
    if lv == 1 then
        base.情爱 = base.情爱 * 1.2
    elseif lv == 2 then
        base.情爱 = base.情爱 * 1.4
    elseif lv == 3 then
        base.情爱 = base.情爱 * 1.6
    elseif lv == 4 then
        base.情爱 = base.情爱 * 1.8
    elseif lv > 4 then
        base.情爱 = base.情爱 * 2
    end

    if Female:检查特性("好奇") then
        base.情爱 = base.情爱 * 1.5
    end
    if Female:检查特性("献身") then
        base.情爱 = base.情爱 * 1.5
    end
    if Female:检查特性("软弱") then
        base.逃脱 = base.逃脱 * 1.5
    end
    if Female:检查特性("害羞") then
        base.逃脱 = base.逃脱 * 1.5
    end
    if Female:检查特性("高傲") then
        base.逃脱 = base.逃脱 * 1.5
    end
    return base
end

function t:SexType(type)
    return false
end

function t:TrainMessage()
end


function t:Check(Trainee, Female, Select)
    return true
end