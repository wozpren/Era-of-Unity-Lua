local t = {}

function t:SexActive(active, Active, Select)
    local base = TrainManager:SMPlay(active, "鞭打")

    
    local s = Trainer : GetAbility("施虐属性")
    local kt = trainData.Source : get_Item("痛苦")
    local level = math.min(GetPalamLV(kt), 5)

    base.逃脱 = base.逃脱 + 1000
    base.疼痛 = base.疼痛 + (level + 1) * 500
    base.疼痛 = base.疼痛 * Trainer.Info.Str / Female.Info.Def
    base.屈从 = base.屈从 + base.疼痛 / 2

    return base
end

function t:SexType(type)
    if type == "被虐快乐" then
        return true
    elseif type == "中度SM" then
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
return t