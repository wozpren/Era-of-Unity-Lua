function t:SexActive(Active, Select)
    local base = ActiveData.new()
    return base
end

function t:SexType(type)
    return false
end

function t:TrainMessage()
    ImplementKoujiu("什么都不做")
end

function t:Check(Trainee, Female, Select)
    return true
end