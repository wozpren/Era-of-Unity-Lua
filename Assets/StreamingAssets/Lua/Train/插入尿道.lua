function SexActive(Active, Select)
local base = dofile("Train/插入")

Train.PosOccupy("尿道", "肉棒")
if trainData.Posture == posture.正常位 then
    if trainData.IsFace then
        base.露出 = base.露出 + 1000
        base.情爱 = base.情爱 + 500
    else
        base.露出 = base.露出 + 1000
        base.情爱 = base.情爱 + 350
    end
elseif Active == "乘骑位" then
    if trainData.IsFace then
        base.露出 = base.露出 + 900
        base.情爱 = base.情爱 + 500
    else
        base.露出 = base.露出 + 700
        base.情爱 = base.情爱 + 700
    end
elseif Active == "抱座位" then
    if trainData.IsFace then
        base.露出 = base.露出 + 1300
        base.情爱 = base.情爱 + 1000
    else
        base.露出 = base.露出 + 1500
        base.情爱 = base.情爱 + 300
    end
elseif Active == "火车便当位" then
    if trainData.IsFace then
        base.露出 = base.露出 + 1200
        base.情爱 = base.情爱 + 500
    else
        base.露出 = base.露出 + 1500
        base.情爱 = base.情爱 + 500
    end
elseif Active == "站立位" then
    if trainData.IsFace then
        base.露出 = base.露出 + 1000
        base.情爱 = base.情爱 + 1500
    else
        base.露出 = base.露出 + 1200
        base.情爱 = base.情爱 + 500
    end
end

if Train.GetAbility("尿道扩张") > Trainer.Stature.JJSize then
    base.C快乐 = trainData : CalcfStimulate("C刺激", 2, 30)
    base.C快乐 = EXABL(Trainer: GetAbility("性交中毒"), base.C快乐)
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

AddSexexp("尿道经验",1)
AddSexexp("尿道调教经验", 2, Trainer)
AddSexexp("尿道性交经验", 1)
AddSexexp("尿道插入经验", 1, Trainer)
Improve.尿道扩张(Female, Trainer.Stature.JJDiam)
return base
end

function TrainMessage()
    ImplementKoujiu("插入尿道")
end

function SexType(type)
    if type == "尿道性交" or type == "异常"  then
        return true
    elseif type == "性交" then
        return true
    end
    return false
end

function Check()
    return true
end