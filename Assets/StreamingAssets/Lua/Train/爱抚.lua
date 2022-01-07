function SexActive(Active, Select)
    Message : AddMessage("爱抚"..Select)
    local base = ActiveData.new()
    local yuwan = Train.GetAbility("欲望")
    local abl = Train.GetAbility("顺从")
    local tec = Trainer : GetAbility("技巧")

    local CFeel = Train.GetAbility("C感觉")
    local VFeel = Train.GetAbility("V感觉")
    local BFeel = Train.GetAbility("B感觉")
    local AFeel = Train.GetAbility("A感觉")

    base.情爱 = 100
    base.逸脱 = 50



    if Select == "头部" then
        if abl <= 5 then
            base.情爱 = base.情爱 + 150 * abl
            base.屈服 = base.屈服 + 150 * (abl + 1)
        elseif abl <= 10 then
            base.情爱 = base.情爱 + 125 * (abl - 5) + 750
            base.屈服 = base.屈服 + 125 * (abl - 5) + 900
        elseif abl <= 15 then
            base.情爱 = base.情爱 + 100 * (abl - 10) + 1375
            base.屈服 = base.屈服 + 100 * (abl - 10) + 1525
        elseif abl > 15 then
            base.情爱 = base.情爱 + 50 * (abl - 15) + 1875
            base.屈服 = base.屈服 + 50 * (abl - 15) + 2025
        end


    elseif Select == "胸部" then

        base.B快乐 = trainData : CalcfStimulate("B刺激", 1)
        base.B快乐 = EXABL(tec, base.B快乐)
        if Train.HaveTalent("B性向") then
            Train.LovePlay(base, base.B快乐)
            BFeel = BFeel + 1
        end

        base.露出 = 200
        base.情爱 = base.情爱 + BFeel * 100
        if BFeel == 0 then
            base.逸脱 = base.逸脱 * 2
        elseif BFeel == 1 then
            base.逸脱 = base.逸脱 * 1.5
        elseif BFeel == 2 then
            base.逸脱 = base.逸脱 * 1.2
        elseif BFeel == 3 then
            base.逸脱 = base.逸脱 * 0.9
        elseif BFeel == 4 then
            base.逸脱 = base.逸脱 * 0.5
        elseif BFeel == 5 then
            base.逸脱 = base.逸脱 * 0.2
        end
        AddSexexp("B经验", 1)
        AddSexexp("手淫经验", 1, Trainer)
    elseif Select == "阴部" then
        base.C快乐 = trainData : CalcfStimulate("C刺激", 1)
        base.C快乐 = EXABL(tec, base.C快乐)
        base.V快乐 = trainData : CalcfStimulate("V刺激", 1)
        base.V快乐 = EXABL(tec, base.V快乐)
        if Female.IsChu then
            if Train.HaveTalent("贞操重视") then
                base.逸脱 = base.逸脱 + 1000
            elseif Train.HaveTalent("不在乎贞操") then
                base.逸脱 = base.逸脱 + 300
            else
                base.逸脱 = base.逸脱 + 500
            end
        end

        base.情爱 = base.情爱 + (VFeel +  CFeel) * 50
        base.液体追加 = 20
        base.不洁 = 20
        base.露出 = 300
        if Train.HaveTalent("V性向") then
            Train.LovePlay(base, base.V快乐)
        end
        if VFeel == 0 then
            base.逸脱 = base.逸脱 * 2
        elseif VFeel == 1 then
            base.逸脱 = base.逸脱 * 1.5
        elseif VFeel == 2 then
            base.逸脱 = base.逸脱 * 1.2
        elseif VFeel == 3 then
            base.逸脱 = base.逸脱 * 0.9
        elseif VFeel == 4 then
            base.逸脱 = base.逸脱 * 0.5
        elseif VFeel == 5 then
            base.逸脱 = base.逸脱 * 0.2
        end
        AddSexexp("手淫经验", 1, Trainer)
        AddSexexp("V经验", 1)



    elseif Select == "臀部" then
        base.A快乐 = trainData : CalcfStimulate("A刺激", 1)
        base.A快乐 = EXABL(tec, base.A快乐)
        base.情爱 = base.情爱 + AFeel * 100
        base.逸脱 = base.逸脱 + 900
        base.不洁 = 20
        base.露出 = 300
        local Aexp = Female : GetSexexp("A经验")
        if Aexp >= 300 then
            base.A快乐 = base.A快乐 * 1.6
            base.逸脱 = base.逸脱 * 0.2
            base.恐惧 = base.恐惧 * 0.2
        elseif Aexp >= 150 then
            base.A快乐 = base.A快乐 * 1.4
            base.恐惧 = base.恐惧 * 0.7
            base.逸脱 = base.逸脱 * 0.6
        elseif Aexp >= 50 then
            base.A快乐 = base.A快乐 * 1.2
            base.恐惧 = base.恐惧 * 0.7
        elseif Aexp >= 20 then
            base.逸脱 = base.逸脱 * 1.2
        elseif Aexp >= 5 then
            base.A快乐 = base.A快乐 * 0.5
            base.逸脱 = base.逸脱 * 1.5
            base.恐惧 = base.恐惧 * 1.5
        else   
            base.A快乐 = base.A快乐 * 0.1
            base.逸脱 = base.逸脱 * 2
            base.恐惧 = base.恐惧 * 2
        end

        if yuwan <= 100 then
            base.屈服 = base.屈服 * 0.3 
        elseif yuwan <= 500 then
            base.屈服 = base.屈服 * 0.5
        elseif yuwan <= 3000 then
            base.屈服 = base.屈服 * 0.8
        elseif yuwan <= 10000 then
            base.屈服 = base.屈服 * 1
        else
            base.屈服 = base.屈服 * 1.2
        end

        if Train.HaveTalent("A性向") then
            Train.LovePlay(base, base.A快乐)
        end
        AddSexexp("手淫经验", 1, Trainer)
        AddSexexp("调教A经验", 1, Trainer)
        AddSexexp("A经验", 1)
        
    elseif Select == "振动棒" then
    elseif Select == "肛门振动棒" then
    end
    local b = Female : GetOutsideEquip(5)
    if b ~= nil then
        if b.Type == "内衣" and Select == "胸部"  then
            base.B快乐 = base.B快乐 * 0.6
            base.露出 = base.露出 * 0.5
        elseif b.Type == "护甲" and Select == "胸部" then
            base.B快乐 = base.B快乐 * 0.1
            base.露出 = base.露出 * 0.1
        else
            base.B快乐 = base.B快乐 * 0.3
            base.露出 = base.露出 * 0.2
        end
    end
    return base
end

function TrainMessage()
    local text = SB.new()
    SB.append(text, "[player]用手")
    if trainData.Select == "头部" then
        SB.random(text,"轻轻","温柔","细致")
        SB.append(text,"地反复")
        SB.random(text,"抚摸","爱抚")
        SB.append(text,"着[target]的头部")
    elseif trainData.Select == "胸部" then
        local equip = Female : GetOutsideEquip(5)
        local size = Female.Stature.b
        SB.append(text,"将")    
        if equip ~= nil and equip.Type == "护甲" then
            SB.append(text,"隔着坚固的护甲，感受来自胸部的温暖")
        else
            if equip ~= nil then
                if equip.Type == "内衣" then
                    SB.append(text,"胸罩掀起，")       
                else
                    SB.append(text,"拉开胸前的衣物，")
                end
                SB.append(text,"对着暴露在空气中的")
            end
            if size > 5 then
                SB.append(text,"如同棉花糖般柔软的巨房")
                if Train.GetAbility("B感觉") >= 3 then

                else
                    SB.random(text,"用手揉捏成各种形状","随着手的变成各种样子","握在手中，乳肉从指间溢出")
                end
            elseif size > 2 then
                SB.append(text,"大小适中的乳房")
                SB.random(text,"用手揉不断揉捻着","用手享受着柔软的触感")
            elseif size > 1 then
                SB.append(text,"微微发育的乳房")
                SB.random(text,"用手按摩着","手指围着可爱的乳头画圈")
            else
                SB.append(text,"飞机场般的乳房")
                SB.random(text,"手指围着可爱的乳头画圈","双手覆盖上去，手掌感受中间的突起")
            end
        end
    elseif trainData.Select == "阴部" then
        SB.append(text,"爱抚着[taget]的阴部")
    end
    TrainPage : Write(SB.tostr(text))

    ImplementKoujiu("爱抚")
end



function SexType(type)
    if type == "爱抚" then
        return true
    end
    return false
end


function Check()
    local text = SB.new()
    SB.append(text, "要爱抚哪里\n")
    SB.append(text, AddButtonL("头部","CoroutineResume,头部"))
    SB.append(text, AddButtonL("胸部","CoroutineResume,胸部"))
    SB.append(text, AddButtonL("阴部","CoroutineResume,阴部"))
    SB.append(text, AddButtonL("臀部","CoroutineResume,臀部"))
    Message : AddMessage(SB.tostr(text))
    Message : StartPop()
    trainData.Select = coroutine.yield()
    Message : Continue()

    return true
end