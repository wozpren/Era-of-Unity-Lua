function SexActive(Active, Select)
    local base = SMPlay("口枷")
    Train.PosOccupy("嘴", "口枷")
    

    base.疼痛 = 50
    base.充足 = 50
    base.露出 = 50
    base.屈服 = 150
    base.逸脱 = 80
    AddSexexp("拘束经验", 2)
    return base
end

function SexType(type)
    if type == "轻度SM" or type == "SM" or type == "道具" or type == "被虐快乐" or type == "羞耻快乐" then
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