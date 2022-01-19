function t:SexActive(Active, Select)
    local base = ServicePlay()
    base.欲情追加 = base.欲情追加 + Train.AddLust()
    base.屈从 = base.屈从 + 400
    base.逃脱 = base.逃脱 + 400
    base.不洁 = base.不洁 + 500


    
    TrainManager:获得经验("足交经验", 1)

    base.Samen = base.Samen + 500 + base.ABLTech * 6
    base.Samen = base.Samen + Train.GetAbility("施虐属性") * 100
    MultiSet(base, "足")
    return base
end

function t:TrainMessage()
    ImplementKoujiu("足交")
end

function t:SexType(type)
    if type == "侍奉快乐" or type == "嗜虐快乐" then
        return true
    elseif type == "侍奉" then
        return true
    end
    return false
end



function t:Check()
    local value, text = Train.AllowAction()

    local n = Train.GetAbility("施虐属性")
    value = OrderRequire(value, text, "abl", "施虐属性", n * 5)
    
    n = Train.GetAbility("侍奉技术")
    value = OrderRequire(value, text, "abl", "侍奉技术", n * 5)
    
    
    n = Train.GetAbility("精液中毒")
    value = OrderRequire(value, text, "abl", "精液中毒", n * 3)
    
    
    value = OrderRequire(value, text, "talent", "强硬", 10)
    value = OrderRequire(value, text, "talent", "高傲", 5)
    value = OrderRequire(value, text, "talent", "害羞", -5)
    value = OrderRequire(value, text, "talent", "否定快感", -1)
    
    
    Train.ShowOrder(value, text, 30)
end