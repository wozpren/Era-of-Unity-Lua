function t:SexActive(Active, Select)
    local base = ActiveData.new()
    local JS = Trainer : GetAbility("技巧")
    local LCP = Train.GetAbility("露出癖")

    base.液体追加 = 200
    base.逃脱 = 200
    base.露出 = 500
    base.情爱 = 200

    TrainManager:获得经验("舔舐经验", 1, Trainer)

if Select == "胸部" then
    base.胸部快感 = Female:计算刺激度("B刺激", 1)
    base.胸部快感 = TrainManager:EXABL(JS, base.胸部快感)
    base.不洁 =  200
    base.情爱 = base.情爱 + Female.胸.感觉 * 100
    local b = Female : GetOutsideEquip(5)
    if b ~= nil then
        if b.Type ~= "内衣" then
            base.胸部快感 = base.胸部快感 * 0.6
            base.露出 = base.露出 * 0.5
        else
            base.胸部快感 = base.胸部快感 * 0.8
            base.露出 = base.露出 * 0.7
        end
    end
    if Train.Estrus("B") then
        base.胸部快感 = base.胸部快感 * 1.5
    end
elseif Select == "小穴" then
    base.阴蒂快感 = Female:计算刺激度("C刺激", 1)
    base.阴蒂快感 = TrainManager:EXABL(JS, base.阴蒂快感)
    base.小穴快感 = Female:计算刺激度("V刺激", 1)
    base.小穴快感 = TrainManager:EXABL(JS, base.小穴快感)
    base.不洁 =  200

    base.小穴快感 = base.小穴快感 * 0.6
    base.阴蒂快感 = base.阴蒂快感 * 0.6

    if LCP >= 1 and LCP <= 5 then
        base.露出 = base.露出 + LCP * 200
    elseif LCP <= 10 then
        base.露出 = base.露出 + (LCP - 5) * 100 + 1000
    elseif LCP > 10 then
        base.露出 = base.露出 + (LCP - 10) * 50 + 1500
    end

    TrainManager:获得经验("小穴经验", 1)

    if Female:检查特性("阴蒂性向") then
        TrainManager:性癖增益(base, base.阴蒂快感)
    end
    local b = Female : GetOutsideEquip(6)
    if b ~= nil then
        if b.Type ~= "内裤" then
            base.阴蒂快感 = base.阴蒂快感 * 0.6
            base.小穴快感 = base.小穴快感 * 0.6
            base.露出 = base.露出 * 0.4
        else
            base.阴蒂快感 = base.阴蒂快感 * 0.8
            base.小穴快感 = base.小穴快感 * 0.8
            base.露出 = base.露出 * 0.6
        end
    end
    if Train.Estrus("V") then
        base.阴蒂快感 = base.阴蒂快感 * 1.5
        base.小穴快感 = base.小穴快感 * 1.5
    end
elseif Select == "肛门" then
    base.菊穴快感 = Female:计算刺激度("菊穴", 1)
    base.菊穴快感 = TrainManager:EXABL(JS, base.菊穴快感)
    base.不洁 = 1000
    base.逃脱 = base.逃脱 + 500
    local Aexp = Female : 获取经验("菊穴经验")
    if Aexp >= 300 then
        base.菊穴快感 = base.菊穴快感 * 1.6
        base.疼痛 = base.疼痛 * 0.5
        base.恐惧 = base.恐惧 * 0.2
        base.逃脱 = base.逃脱 * 0.2
    elseif Aexp >= 150 then
        base.菊穴快感 = base.菊穴快感 * 1.4
        base.疼痛 = base.疼痛 * 0.6
        base.恐惧 = base.恐惧 * 0.4
        base.逃脱 = base.逃脱 * 0.6
    elseif Aexp >= 50 then
        base.菊穴快感 = base.菊穴快感 * 1.2
        base.疼痛 = base.疼痛 * 0.9
        base.恐惧 = base.恐惧 * 0.7
        base.逃脱 = base.逃脱 * 0.8
    elseif Aexp >= 20 then

    elseif Aexp >= 5 then
        base.菊穴快感 = base.菊穴快感 * 0.5
        base.疼痛 = base.疼痛 * 1.5
        base.恐惧 = base.恐惧 * 1.5
        base.逃脱 = base.逃脱 * 1.5
    else
        base.菊穴快感 = base.菊穴快感 * 0.1
        base.疼痛 = base.疼痛 * 2
        base.恐惧 = base.恐惧 * 2
        base.逃脱 = base.逃脱 * 2
    end
    local YQ = GetPalamLV(trainData.Source : get_Item("欲情"))
    if YQ < 1 then
        base.屈从 = base.屈从 * 0.3
    elseif YQ < 2 then
        base.屈从 = base.屈从 * 0.5
    elseif YQ < 3 then
        base.屈从 = base.屈从 * 0.8
    elseif YQ < 4 then
    elseif YQ >= 4 then
        base.屈从 = base.屈从 * 1.2
    end
    if Female:检查特性("肛性向") then
        TrainManager:性癖增益(base, base.菊穴快感)
    end
    TrainManager:获得经验("菊穴经验", 1)

elseif Select == "脚部" then
    base.不洁 = 100
    base.逃脱 = 100
    
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
    base.阴蒂快感 = Female:计算刺激度("C刺激", 1)
    base.阴蒂快感 = TrainManager:EXABL(JS, base.阴蒂快感)
    base.不洁 = 200
    base.恐惧 = 500
    base.逃脱 = base.逃脱 + 1000
    base.屈从 = base.屈从 + 200
    local SC = Train.GetAbility("顺从")
    if SC < 1 then
        base.逃脱 = base.逃脱 * 2
        base.恐惧 = base.恐惧 * 2
        base.屈从 = base.屈从 * 0.2
    elseif SC < 2 then
    elseif SC < 3 then
    elseif SC < 4 then
        base.逃脱 = base.逃脱 * 0.6
        base.恐惧 = base.恐惧 * 0.6
        base.屈从 = base.屈从 * 0.2
    elseif SC < 5 then
        base.逃脱 = base.逃脱 * 0.4
        base.恐惧 = base.恐惧 * 0.4
        base.屈从 = base.屈从 * 1.6
    elseif SC >= 5 then
        base.逃脱 = base.逃脱 * 0.2
        base.恐惧 = base.恐惧 * 0.2
        base.屈从 = base.屈从 * 2
    end

    TrainManager:获得经验("口交经验", 1, Trainer)
elseif Select == "阴核" then
    base.阴蒂快感 = Female:计算刺激度("C刺激", 1)
    base.阴蒂快感 = TrainManager:EXABL(JS, base.阴蒂快感)
    base.不洁 = 200
    base.恐惧 = 100
    local SC = Train.GetAbility("顺从")
    if SC < 1 then
        base.逃脱 = base.逃脱 * 2
        base.恐惧 = base.恐惧 * 2
        base.屈从 = base.屈从 * 0.2
    elseif SC < 2 then
    elseif SC < 3 then
    elseif SC < 4 then
        base.逃脱 = base.逃脱 * 0.6
        base.恐惧 = base.恐惧 * 0.6
        base.屈从 = base.屈从 * 0.2
    elseif SC < 5 then
        base.逃脱 = base.逃脱 * 0.4
        base.恐惧 = base.恐惧 * 0.4
        base.屈从 = base.屈从 * 1.6
    elseif SC >= 5 then
        base.逃脱 = base.逃脱 * 0.2
        base.恐惧 = base.恐惧 * 0.2
        base.屈从 = base.屈从 * 2
    end
end


    return base
end

function t:TrainMessage()
    ImplementKoujiu("舔舐")
end

function t:SexType(type)
    if type == "舔舐" or type == "羞耻快乐" then
        return true
    elseif type == "爱抚" then
        return true
    end
    return false
end



function t:Check()
    local text = SB.New()
    text:Append("要舔舐哪里\n")
    text:Append(AddButtonL("胸部","CoroutineResume,胸部"))
    text:Append(AddButtonL("小穴","CoroutineResume,小穴"))
    if Female.IsJJ then
        text:Append(AddButtonL("肉棒","CoroutineResume,肉棒"))
    else
        text:Append(AddButtonL("阴核","CoroutineResume,阴核"))
    end
    text:Append(AddButtonL("脚部","CoroutineResume,脚部"))
    
    Message : AddMessage(text:ToStr())
    Message : StartPop()
    trainData.Select = coroutine.yield()
    Message : Continue()
    return true
end