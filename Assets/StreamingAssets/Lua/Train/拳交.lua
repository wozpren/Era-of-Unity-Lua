function SexActive(Active, Select)
    if Select == "双穴" then
        local base = InsertAcitve(Active, "小穴")
        MultData(base, 0.75)
        base = base + InsertAcitve(Active, "肛门")
        base = base + SMPlay("双重拳交")
    else
        local base = InsertAcitve(Active, Select)
        base = base + SMPlay("拳交")

    end

    return base
end

function SexType(type)
    if type == "重度SM" or type == "SM" or "被虐快乐" or type == "异常"  then
        return true
    end

    return false
end

function TrainMessage()
    ImplementKoujiu("拳交")
end


function Check()
    return true
end