function t:SexActive(Active, Select)
    local base = SMPlay("打屁股")
    base.露出 = base.露出 + 200
    base.逃脱 = base.逃脱 + 200

    local s = Trainer : GetAbility("施虐属性")
    local kt = trainData.Source : get_Item("痛苦")
    local level = math.min(GetPalamLV(kt), 5)
    base.疼痛 = base.疼痛 + (level + 1) * 300
    base.屈从 = base.屈从 + base.疼痛 / 2 * (1 + s * 0.2)
    
    if Female:检查特性("成长期") then
        base.屈从 = base.屈从 * 1.5
    end
    if Train.Pos["小穴"] ~= "空" then
        base.疼痛 = base.疼痛 * 0.5
        base.露出 = base.露出 * 1.5
        base.屈从 = base.屈从 * 1.5
    end

    return base
end

function t:SexType(type)
    if type == "被虐快乐" then
        return true
    elseif type == "轻度SM" then
        return true
    elseif type == "SM" then
        return true
    end


    return false
end

function t:TrainMessage()
    
end



function t:Check()
    return true
end