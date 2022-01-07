function SexActive(Active, Select)
    local base = ActiveData.new()
    local JS = Trainer : GetAbility("技巧")
    local LCP = Train.GetAbility("露出癖")

    base.液体追加 = 200
    base.逸脱 = 200
    base.露出 = 500
    base.情爱 = 200

    AddSexexp("舔舐经验", 1, Trainer)

if Select == "胸部" then
    base.B快乐 = trainData : CalcfStimulate("B刺激", 1)
    base.B快乐 = EXABL(JS, base.B快乐)
    base.不洁 =  200
    base.情爱 = base.情爱 + Train.GetAbility("B感觉") * 100
    local b = Female : GetOutsideEquip(5)
    if b ~= nil then
        if b.Type ~= "内衣" then
            base.B快乐 = base.B快乐 * 0.6
            base.露出 = base.露出 * 0.5
        else
            base.B快乐 = base.B快乐 * 0.8
            base.露出 = base.露出 * 0.7
        end
    end
    if Train.Estrus("B") then
        base.B快乐 = base.B快乐 * 1.5
    end
elseif Select == "阴部" then
    base.C快乐 = trainData : CalcfStimulate("C刺激", 1)
    base.C快乐 = EXABL(JS, base.C快乐)
    base.V快乐 = trainData : CalcfStimulate("V刺激", 1)
    base.V快乐 = EXABL(JS, base.V快乐)
    base.不洁 =  200

    base.V快乐 = base.V快乐 * 0.6
    base.C快乐 = base.C快乐 * 0.6

    if LCP >= 1 and LCP <= 5 then
        base.露出 = base.露出 + LCP * 200
    elseif LCP <= 10 then
        base.露出 = base.露出 + (LCP - 5) * 100 + 1000
    elseif LCP > 10 then
        base.露出 = base.露出 + (LCP - 10) * 50 + 1500
    end

    AddSexexp("V经验", 1)

    if Train.HaveTalent("C性向") then
        Train.LovePlay(base, base.C快乐)
    end
    local b = Female : GetOutsideEquip(6)
    if b ~= nil then
        if b.Type ~= "内裤" then
            base.C快乐 = base.C快乐 * 0.6
            base.V快乐 = base.V快乐 * 0.6
            base.露出 = base.露出 * 0.4
        else
            base.C快乐 = base.C快乐 * 0.8
            base.V快乐 = base.V快乐 * 0.8
            base.露出 = base.露出 * 0.6
        end
    end
    if Train.Estrus("V") then
        base.C快乐 = base.C快乐 * 1.5
        base.V快乐 = base.V快乐 * 1.5
    end
elseif Select == "肛门" then
    base.A快乐 = trainData : CalcfStimulate("A刺激", 1)
    base.A快乐 = EXABL(JS, base.A快乐)
    base.不洁 = 1000
    base.逸脱 = base.逸脱 + 500
    local Aexp = Female : GetSexexp("A经验")
    if Aexp >= 300 then
        base.A快乐 = base.A快乐 * 1.6
        base.疼痛 = base.疼痛 * 0.5
        base.恐惧 = base.恐惧 * 0.2
        base.逸脱 = base.逸脱 * 0.2
    elseif Aexp >= 150 then
        base.A快乐 = base.A快乐 * 1.4
        base.疼痛 = base.疼痛 * 0.6
        base.恐惧 = base.恐惧 * 0.4
        base.逸脱 = base.逸脱 * 0.6
    elseif Aexp >= 50 then
        base.A快乐 = base.A快乐 * 1.2
        base.疼痛 = base.疼痛 * 0.9
        base.恐惧 = base.恐惧 * 0.7
        base.逸脱 = base.逸脱 * 0.8
    elseif Aexp >= 20 then

    elseif Aexp >= 5 then
        base.A快乐 = base.A快乐 * 0.5
        base.疼痛 = base.疼痛 * 1.5
        base.恐惧 = base.恐惧 * 1.5
        base.逸脱 = base.逸脱 * 1.5
    else
        base.A快乐 = base.A快乐 * 0.1
        base.疼痛 = base.疼痛 * 2
        base.恐惧 = base.恐惧 * 2
        base.逸脱 = base.逸脱 * 2
    end
    local YQ = GetPalamLV(trainData.Source : get_Item("欲情"))
    if YQ < 1 then
        base.屈服 = base.屈服 * 0.3
    elseif YQ < 2 then
        base.屈服 = base.屈服 * 0.5
    elseif YQ < 3 then
        base.屈服 = base.屈服 * 0.8
    elseif YQ < 4 then
    elseif YQ >= 4 then
        base.屈服 = base.屈服 * 1.2
    end
    if Train.HaveTalent("A性向") then
        Train.LovePlay(base, base.A快乐)
    end
    AddSexexp("A经验", 1)

elseif Select == "脚部" then
    base.不洁 = 100
    base.逸脱 = 100
    
    local sn = Train.GetAbility("施虐属性")
    if sn == 1 then
        base.情爱 = base.情爱 + 300
    elseif sn == 2 then
        base.情爱 = base.情爱 + 500
    elseif sn == 3 then
        base.情爱 = base.情爱 + 1000
    elseif sn == 4 then
        base.情爱 = base.情爱 + 1500
    elseif sn == 4 then
        base.情爱 = base.情爱 + 2000
    end
elseif Select == "肉棒" then
    base.C快乐 = trainData : CalcfStimulate("C刺激", 1)
    base.C快乐 = EXABL(JS, base.C快乐)
    base.不洁 = 200
    base.恐惧 = 500
    base.逸脱 = base.逸脱 + 1000
    base.屈服 = base.屈服 + 200
    local SC = Train.GetAbility("顺从")
    if SC < 1 then
        base.逸脱 = base.逸脱 * 2
        base.恐惧 = base.恐惧 * 2
        base.屈服 = base.屈服 * 0.2
    elseif SC < 2 then
    elseif SC < 3 then
    elseif SC < 4 then
        base.逸脱 = base.逸脱 * 0.6
        base.恐惧 = base.恐惧 * 0.6
        base.屈服 = base.屈服 * 0.2
    elseif SC < 5 then
        base.逸脱 = base.逸脱 * 0.4
        base.恐惧 = base.恐惧 * 0.4
        base.屈服 = base.屈服 * 1.6
    elseif SC >= 5 then
        base.逸脱 = base.逸脱 * 0.2
        base.恐惧 = base.恐惧 * 0.2
        base.屈服 = base.屈服 * 2
    end

    AddSexexp("口交经验", 1, Trainer)
elseif Select == "阴核" then
    base.C快乐 = trainData : CalcfStimulate("C刺激", 1)
    base.C快乐 = EXABL(JS, base.C快乐)
    base.不洁 = 200
    base.恐惧 = 100
    local SC = Train.GetAbility("顺从")
    if SC < 1 then
        base.逸脱 = base.逸脱 * 2
        base.恐惧 = base.恐惧 * 2
        base.屈服 = base.屈服 * 0.2
    elseif SC < 2 then
    elseif SC < 3 then
    elseif SC < 4 then
        base.逸脱 = base.逸脱 * 0.6
        base.恐惧 = base.恐惧 * 0.6
        base.屈服 = base.屈服 * 0.2
    elseif SC < 5 then
        base.逸脱 = base.逸脱 * 0.4
        base.恐惧 = base.恐惧 * 0.4
        base.屈服 = base.屈服 * 1.6
    elseif SC >= 5 then
        base.逸脱 = base.逸脱 * 0.2
        base.恐惧 = base.恐惧 * 0.2
        base.屈服 = base.屈服 * 2
    end
end


    return base
end

function TrainMessage()
    ImplementKoujiu("舔舐")
end

function SexType(type)
    if type == "舔舐" or type == "羞耻快乐" then
        return true
    elseif type == "爱抚" then
        return true
    end
    return false
end



function Check()
    local text = SB.new()
    SB.append(text, "要舔舐哪里\n")
    SB.append(text, AddButtonL("胸部","CoroutineResume,胸部"))
    SB.append(text, AddButtonL("阴部","CoroutineResume,阴部"))
    if Female.IsJJ then
        SB.append(text, AddButtonL("肉棒","CoroutineResume,肉棒"))
    else
        SB.append(text, AddButtonL("阴核","CoroutineResume,阴核"))
    end
    SB.append(text, AddButtonL("脚部","CoroutineResume,脚部"))
    
    Message : AddMessage(SB.tostr(text))
    Message : StartPop()
    trainData.Select = coroutine.yield()
    Message : Continue()
    return true
end