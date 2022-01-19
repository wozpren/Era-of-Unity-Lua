function t:SexActive(Active, Select)
    local base = ServicePlay()
    base.不洁 = base.不洁 + 200
    base.欲情追加 = base.欲情追加 + Train.AddLust()
    if Select == "肛门" then
        base.逃脱 = base.逃脱 + 3000
        base.屈从 = base.屈从 + 5000
    elseif Select == "小穴" then
        base.逃脱 = base.逃脱 + 1000
        base.屈从 = base.屈从 + 500
    elseif Select == "足" then
        base.逃脱 = base.逃脱 + 2000
        base.屈从 = base.屈从 + 4000
    end
    return base
end




function t:SexType(type)
    if type == "侍奉" or type == "侍奉快乐" then
        return true
    end
    return false
end

function t:TrainMessage()
    ImplementKoujiu("肛门侍奉")
end




function t:Check()
    local value, text = Train.AllowAction()
    local n = Train.GetAbility("侍奉技术")
    value = OrderRequire(value, text, "abl", "侍奉技术", n * 2)
    if Select == "足" then   
        local n = Train.GetAbility("受虐属性")
        value = OrderRequire(value, text, "abl", "受虐属性", n * 3)
    end
    value = OrderRequire(value, text, "talent", "害羞", -5)
    value = OrderRequire(value, text, "talent", "献身", 6)
    value = OrderRequire(value, text, "talent", "否定快感", -1)
    
    if Select == "小穴" then   
        value = OrderRequire(value, text, "sex", "男", 10)
    end
    
    return Train.ShowOrder(value, text, 40)
end