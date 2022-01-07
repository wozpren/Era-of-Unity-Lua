function SexActive(Active, Select)
    local base = SMPlay("眼罩")
    Train.PosOccupy("眼", "眼罩")
    base.露出 = base.露出 + 1000
    base.逸脱 = base.逸脱 + 500
    if Train.HaveTalent("软弱") then
        base.逸脱 = base.逸脱 * 0.2
    end
    AddSexexp("拘束经验", 2)
    return base
end

function SexType(type)
    if type == "被虐快乐" or type == "轻度SM" or type == "道具" then
        return true
    end

    return false
end

function TrainMessage()
    ImplementKoujiu("穿戴")
end

function Check()
    return true
end