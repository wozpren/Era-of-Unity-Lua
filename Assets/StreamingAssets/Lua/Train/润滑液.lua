function t:SexActive(active, Active, Select)
    dofile("爱抚")
    local base = SexActive("爱抚","小穴")
    MultData(base, 0.8)
    base.润滑 = base.润滑 + 5000
    dofile("润滑液")
    return base
end

function t:SexType(type)
    if type == "道具" then
        return true
    end
    return false
end

function t:TrainMessage()
end


function t:Check(Trainer, Female, Select)
    return true, Select
end