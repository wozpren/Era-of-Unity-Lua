function SexActive(Active, Select)
    local base = SMPlay("拘束")

    Train.PosOccupy("活动","拘束")

    base.疼痛 = base.疼痛 + 100
    base.恐惧 = base.恐惧 + 100
    base.露出 = base.露出 + 500
    base.屈服 = base.屈服 + 1000
    base.逸脱 = base.逸脱 + 500
    AddSexexp("拘束经验", 5)
    return base
end

function SexType(type)
    if type == "SM" or type == "中度SM" or type == "被虐快乐" then
        return true
    end
    return false
end

function TrainMessage()
end


function Check()
    return true
end