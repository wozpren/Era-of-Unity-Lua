local radius = 0
local t = {}
function t:SexActive(active, Active, Select)
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





function t:Check(Trainer, Female, Select)
    local value, text = TrainManager:AllowAction(Trainer, Female)
    local n = Train.GetAbility("露出癖")
    value = OrderRequire(Female, value, text, "abl", "露出癖", n * 2)
    n = Train.GetAbility(Female, "受虐属性")
    value = OrderRequire(Female, value, text, "abl", "露出癖", n * 3)
 
    value = OrderRequire(Female, value, text, "talent", "冷漠", -5)
    value = OrderRequire(Female, value, text, "talent", "害羞", -15)
    value = OrderRequire(Female, value, text, "talent", "不知羞耻", 2)
    value = OrderRequire(Female, value, text, "talent", "清楚", -10)
    value = OrderRequire(Female, value, text, "talent", "接受快感", 5)
    value = OrderRequire(Female, value, text, "talent", "否定快感", -5)
    value = OrderRequire(Female, value, text, "talent", "倒错的", 10)
    value = OrderRequire(Female, value, text, "talent", "尿道性感", 10)

    value = OrderRequire(Female, value, text, "equip", "摄像机", -20)
    value = OrderRequire(Female, value, text, "equip", "拘束", 30)
    value = OrderRequire(Female, value, text, "equip", "媚药", 2)

    value = OrderRequire(Female, value, text, "place", "野外PLAY", -10)
    value = OrderRequire(Female, value, text, "place", "室内PLAY", -10)
    
    return TrainManager:ShowOrder(value, text, 55), Select
end

return t