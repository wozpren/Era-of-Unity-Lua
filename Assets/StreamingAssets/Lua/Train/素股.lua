function t:SexActive(Active, Select)
local base = ServicePlay()

base.Samen = base.Samen + 500 + base.ABLTech * 6


base.欲情追加 = base.欲情追加 + Train.AddLust()
base.屈从 = base.屈从 + 1200
base.逃脱 = base.逃脱 + 50
if Select ~= "展示肉棒" then
    base = require("Train/侍奉")
    base.不洁 = base.不洁 + 500
    base.阴蒂快感 = Female:计算刺激度("C刺激")
    
    local SR = GetPalamLV(trainData.Source : get_Item("润滑"))
    if SR < 1 then
        base.阴蒂快感 = base.阴蒂快感 * 0.1
        base.性行动 = base.性行动 * 0.6
    elseif SR < 2 then
        base.阴蒂快感 = base.阴蒂快感 * 0.3
        base.性行动 = base.性行动 * 0.8
    elseif SR < 3 then
        base.阴蒂快感 = base.阴蒂快感 * 0.5
    elseif SR < 4 then
        base.性行动 = base.性行动 * 1.2
    elseif SR < 5 then
        base.阴蒂快感 = base.阴蒂快感 * 0.9
        base.性行动 = base.性行动 * 1.4
    else
        base.阴蒂快感 = base.阴蒂快感 * 0.8
        base.性行动 = base.性行动 * 1.6
    end

    local b = Female : 获取装备厚度("胯部")
    if b > 0 then
        local l = math.max(5 - b, 0)
        base.阴蒂快感 = base.阴蒂快感 * l * 0.2 + 0.1
        base.露出 = base.露出 * l * 0.2 + 0.1
    end
end


return base
end

function t:TrainMessage()
    ImplementKoujiu("素股")
end

function t:SexType(type)
    if type == "侍奉快乐" then
        return true
    elseif type == "侍奉" then
        return true
    end
    return false
end

function t:Check()
    return true
end