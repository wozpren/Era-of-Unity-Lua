function t:SexActive(Active, Select)
    local base = SMPlay("拘束")

    Train.PosOccupy("活动","拘束")

    base.疼痛 = base.疼痛 + 100
    base.恐惧 = base.恐惧 + 100
    base.露出 = base.露出 + 500
    base.屈从 = base.屈从 + 1000
    base.逃脱 = base.逃脱 + 500
    TrainManager:获得经验("拘束经验", 5)
    return base
end

function t:SexType(type)
    if type == "SM" or type == "中度SM" or type == "被虐快乐" then
        return true
    end
    return false
end

function t:TrainMessage()
end


function t:Check(Trainee, Female, Select)
    return true
end