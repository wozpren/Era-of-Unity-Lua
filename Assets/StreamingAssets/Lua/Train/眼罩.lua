function t:SexActive(active, Active, Select)
    local base = SMPlay("眼罩")
    Train.PosOccupy("眼", "眼罩")
    base.露出 = base.露出 + 1000
    base.逃脱 = base.逃脱 + 500
    if Female:检查特性("软弱") then
        base.逃脱 = base.逃脱 * 0.2
    end
    TrainManager:获得经验("拘束经验", 2)
    return base
end

function t:SexType(type)
    if type == "被虐快乐" or type == "轻度SM" or type == "道具" then
        return true
    end

    return false
end

function t:TrainMessage()
    ImplementKoujiu("穿戴")
end

function t:Check(Trainer, Female, Select)
    return true
end