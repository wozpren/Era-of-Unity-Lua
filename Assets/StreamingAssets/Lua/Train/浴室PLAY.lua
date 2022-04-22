function t:SexActive(Active, Select)
    if trainData.equipItem : Contains("浴室PLAY") then
        trainData.equipItem : Remove("浴室PLAY")
    else
        trainData.equipItem : Add("浴室PLAY")
    end


    local base = ActiveData.new()
    base.露出 = base.露出 + 200
    
    local lv = GetPalamLV(trainData.Source : get_Item("欲情"))
    if lv == 0 then
        base.露出 = base.露出 * 0.8
    elseif lv == 1 then
        base.露出 = base.露出 * 0.9
    elseif lv == 2 then
        base.露出 = base.露出 * 1
    elseif lv == 3 then
        base.露出 = base.露出 * 1.1
    elseif lv >= 4 then
        base.露出 = base.露出 * 1.2
    end
    return base
end

function t:SexType(type)
    if type == "羞耻快乐" then
        return true
    end
    return false
end

function t:TrainMessage()
end

function t:Check(Trainee, Female, Select)
    return true
end