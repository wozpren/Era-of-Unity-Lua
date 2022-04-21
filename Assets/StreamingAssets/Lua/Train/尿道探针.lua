local radius = 0
local t = {}
function t:SexActive(Active, Select)
    local base = InsertAcitve("探针", radius)
    return base
end

function t:SexType(type)
    if type == "SM" or type == "重度SM" or type == "被虐快乐" or type == "异常" then
        return true
    end
    return false
end

function t:TrainMessage()
    ImplementKoujiu("尿道探针")
end





function t:Check()
    local value, text = Train.AllowAction()
    local n = Train.GetAbility("露出癖")
    value = OrderRequire(value, text, "abl", "露出癖", n * 2)
    n = Train.GetAbility("受虐属性")
    value = OrderRequire(value, text, "abl", "露出癖", n * 3)
    
    value = OrderRequire(value, text, "talent", "冷漠", -5)
    value = OrderRequire(value, text, "talent", "害羞", -15)
    value = OrderRequire(value, text, "talent", "不知羞耻", 2)
    value = OrderRequire(value, text, "talent", "清楚", -10)
    value = OrderRequire(value, text, "talent", "接受快感", 5)
    value = OrderRequire(value, text, "talent", "否定快感", -5)
    value = OrderRequire(value, text, "talent", "倒错的", 10)
    value = OrderRequire(value, text, "talent", "尿道性感", 10)
    
    value = OrderRequire(value, text, "equip", "摄像机", -20)
    value = OrderRequire(value, text, "equip", "拘束", 30)
    value = OrderRequire(value, text, "equip", "媚药", 2)
    
    value = OrderRequire(value, text, "place", "野外PLAY", -10)
    value = OrderRequire(value, text, "place", "室内PLAY", -10)
    
    return Train.ShowOrder(value, text, 55)
end

return t