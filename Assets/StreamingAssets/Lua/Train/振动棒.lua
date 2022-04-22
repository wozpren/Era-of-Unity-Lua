function t:SexActive(Active, Select)
    Train.PosOccupy("小穴", "振动棒")
    local base = InsertAcitve(Active, "小穴")
    if not Train.Pos["小穴"] == "振动棒" then
        MultData(base, 0.3)
    end

    TrainManager:获得经验("小穴经验", 2)
    Factory : AddSwitchValue("振动棒使用数据", 1)
    Improve.V扩张(Female, 3, 3)
    return base
end

function t:TrainMessage()
    ImplementKoujiu("振动棒")
end

function t:SexType(type)
    if type == "V插入" or type == "性交" then
        return true
    end
    return false
end

function t:Check(Trainee, Female, Select)
    return true
end