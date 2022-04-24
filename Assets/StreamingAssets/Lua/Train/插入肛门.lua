local t = {}
function t:SexActive(Active, Select)
dofile("Train/插入")
Train.PosOccupy("肛门", "肉棒")
local base = InsertAcitve(Active, Select)
if TrainManager.姿势 == posture.正常位 then
    if TrainManager.正面 then
        base.露出 = base.露出 + 1000
        base.情爱 = base.情爱 + 500
    else
        base.露出 = base.露出 + 2000
        base.情爱 = base.情爱 + 350
    end
elseif Active == "乘骑位" then
    if TrainManager.正面 then
        base.露出 = base.露出 + 900
        base.情爱 = base.情爱 + 500
    else
        base.露出 = base.露出 + 700
        base.情爱 = base.情爱 + 700
    end
elseif Active == "抱座位" then
    if TrainManager.正面 then
        base.露出 = base.露出 + 1300
        base.情爱 = base.情爱 + 1000
    else
        base.露出 = base.露出 + 1500
        base.情爱 = base.情爱 + 300
    end
elseif Active == "火车便当位" then
    if TrainManager.正面 then
        base.露出 = base.露出 + 1200
        base.情爱 = base.情爱 + 500
    else
        base.露出 = base.露出 + 1500
        base.情爱 = base.情爱 + 500
    end
elseif Active == "站立位" then
    if TrainManager.正面 then
        base.露出 = base.露出 + 1000
        base.情爱 = base.情爱 + 1500
    else
        base.露出 = base.露出 + 1200
        base.情爱 = base.情爱 + 500
    end
end

local YQ = trainData.Source : get_Item("欲情")
if YQ < 100 then
    base.情爱 = base.情爱 * 0.3
elseif YQ < 500 then
    base.情爱 = base.情爱 * 0.6
elseif YQ < 3000 then
    base.情爱 = base.情爱 * 1
elseif YQ < 10000 then
    base.情爱 = base.情爱 * 1.5
elseif YQ >= 10000 then
    base.情爱 = base.情爱 * 1.8
end


return base
end

function t:TrainMessage()
    ImplementKoujiu("插入肛门")
end

function t:SexType(type)
    if type == "肛门性交" then
        return true
    elseif type == "性交" then
        return true
    elseif TrainManager.姿势 == "乘骑位" and type == "侍奉快乐"  then
        return true
    end
    return false
end


function t:Check(Trainee, Female, Select)
    return true
end