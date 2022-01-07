function SexActive(Active, Select)
local base = ServicePlay()

base.Samen = base.Samen + 500 + base.ABLTech * 6


base.欲情追加 = base.欲情追加 + Train.AddLust()
base.屈服 = base.屈服 + 1200
base.逸脱 = base.逸脱 + 50
if Select ~= "展示肉棒" then
    base = require("Train/侍奉")
    base.不洁 = base.不洁 + 500
    base.C快乐 = trainData : CalcfStimulate("C刺激")
    
    local SR = GetPalamLV(trainData.Source : get_Item("润滑"))
    if SR < 1 then
        base.C快乐 = base.C快乐 * 0.1
        base.性行动 = base.性行动 * 0.6
    elseif SR < 2 then
        base.C快乐 = base.C快乐 * 0.3
        base.性行动 = base.性行动 * 0.8
    elseif SR < 3 then
        base.C快乐 = base.C快乐 * 0.5
    elseif SR < 4 then
        base.性行动 = base.性行动 * 1.2
    elseif SR < 5 then
        base.C快乐 = base.C快乐 * 0.9
        base.性行动 = base.性行动 * 1.4
    else
        base.C快乐 = base.C快乐 * 0.8
        base.性行动 = base.性行动 * 1.6
    end

    local b = Female : GetOutsideEquip(6)
    if b ~= nil then
        if b.type == "内裤" then
            base.C快乐 = base.C快乐 * 0.6
            base.露出 = base.露出 * 0.5
        else
            base.C快乐 = base.C快乐 * 0.2
            base.露出 = base.露出 * 0.2
        end
    end
end


return base
end

function TrainMessage()
    ImplementKoujiu("素股")
end

function SexType(type)
    if type == "侍奉快乐" then
        return true
    elseif type == "侍奉" then
        return true
    end
    return false
end

function Check()
    return true
end