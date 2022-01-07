function SexActive(Active, Select)
local base = ServicePlay()

base.不洁 = base.不洁 + 100
base.欲情追加 = base.欲情追加 + Train.AddLust()
base.屈服 = base.屈服 + 1800
base.逸脱 = base.逸脱 + 300

if Train.HaveTalent("巨乳") then
    base.逸脱 = base.逸脱 - 200
elseif Train.HaveTalent("贫乳") then
    base.逸脱 = base.逸脱 + 400
end

base.B快乐 = trainData : CalcfStimulate("B刺激")

if Train.HaveTalent("B性向") then
    Train.LovePlay(base, base.B快乐)
end

AddSexexp("乳交经验", 1)
base.Samen = base.Samen + 500 + base.ABLTech * 6
base.Samen = base.Samen + Train.GetAbility("精液中毒") * 100

MultiSet(base, "乳")

if Select == "乳夹口交" then
    dofile("口交")
    local t = SexActive("口交")
    MultData(base, 0.5)
    MultData(t, 0.5)
    base = base + t
    dofile("乳交")
end


return base
end


function TrainMessage()
    ImplementKoujiu("乳交")
end


function SexType(type)
    if type == "侍奉" then
        return true
    elseif type == "侍奉快乐" then
        return true
    end
    return false
end



function Check()
    local value, text = Train.AllowAction()

    local temp = Train.GetAbility("侍奉技术")
    if temp > 0 then
        value = value + temp * 2
        SB.append(text,"侍奉技术: "..temp * 2)
    end
    temp = Train.GetAbility("精液中毒")
    if temp > 0 then
        value = value + math.min(temp, 5) * 3
        SB.append(text,"精液中毒: "..math.min(temp, 5) * 3)
    end
    
    if(Female: HaveTalent("害羞")) then
        value = value - 3
        SB.append(text,"害羞: -3")
    end
    if(Female: HaveTalent("献身")) then
        value = value + 6
        SB.append(text,"献身: 6")
    end
    if(Female: HaveTalent("否定快感")) then
        value = value - 1
        SB.append(text,"否定快感: -1")
    end
    if(Female: HaveTalent("B性向")) then
        value = value + 10
        SB.append(text,"B性向: 10")
    end
    
    
    return Train.ShowOrder(value, text, 20)
end