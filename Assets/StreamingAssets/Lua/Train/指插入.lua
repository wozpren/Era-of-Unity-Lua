function t:SexActive(Active, Select)
    local base
    if Train.Pos["小穴"] == "振动棒" then
        base = InsertAcitve(Active, Select)
        MultData(base, 1.3)
    else
        base = InsertAcitve(Active, Select)
        if Select == "G点" then
            MultData(base, 1.5)
        end
    end
    if Select == "小穴" then
        TrainManager:获得经验("小穴经验", 1)
    elseif Select == "肛门" then
        TrainManager:获得经验("菊穴经验", 1)
    elseif Select == "尿道" then
        TrainManager:获得经验("尿道经验", 1)
    end
    TrainManager:获得经验("手淫经验", 1)


    return base
end

function t:TrainMessage()
    ImplementKoujiu("指插入")
end

function t:SexType(type)
    if type == "V插入" then
        return true
    end
    return false
end

function t:Check(Trainee, Female, Select)
    return true
end