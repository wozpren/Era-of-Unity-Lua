function SexActive(Active, Select)
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
        AddSexexp("V经验", 1)
    elseif Select == "肛门" then
        AddSexexp("A经验", 1)
    elseif Select == "尿道" then
        AddSexexp("尿道经验", 1)
    end
    AddSexexp("手淫经验", 1)


    return base
end

function TrainMessage()
    ImplementKoujiu("指插入")
end

function SexType(type)
    if type == "V插入" then
        return true
    end
    return false
end

function Check()
    return true
end