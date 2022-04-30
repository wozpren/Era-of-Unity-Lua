local t = {}
function t:SexActive(active, Active, Select)
    local base = TrainManager:SMPlay("口枷")
    Train.PosOccupy("嘴", "口枷")
    

    base.疼痛 = 50
    base.充足 = 50
    base.露出 = 50
    base.屈从 = 150
    base.逃脱 = 80
    TrainManager:获得经验("拘束经验", 2)
    return base
end

function t:SexType(type)
    if type == "轻度SM" or type == "SM" or type == "道具" or type == "被虐快乐" or type == "羞耻快乐" then
        return true
    end
    return false
end

function t:TrainMessage()
    ImplementKoujiu("穿戴")
end


function t:Check(Trainer, Female, Select)
    return true, Select
end

return t