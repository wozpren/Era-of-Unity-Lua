function SexActive(Active, Select)
    base.Samen = base.Samen + VFeel * 100
    local n = Trainer.Stature.JJSize - Train.GetAbility("V扩张")
    if n >= 3 then
        base.Samen = base.Samen * 0.1
    elseif n == 2 then
        base.Samen = base.Samen * 0.3
    elseif n == 1 then
        base.Samen = base.Samen * 0.7
    end

    Train.PosOccupy("小穴", "肉棒")
    
    
    local base = InsertAcitve(Active, Select)
    if trainData.Posture == "正常位" then
        if trainData.IsFace then
            base.露出 = base.露出 + 200
            base.情爱 = base.情爱 + 500

        
            if Train.GetAbility("V扩张") > Trainer.Stature.JJSize then
                base.C快乐 = base.C快乐 + trainData : CalcfStimulate("C刺激", 2, 300)
                base.C快乐 = EXABL(Trainer : GetAbility("性交中毒"), base.C快乐)
            end
            base.Samen = base.Samen + Train.GetAbility("顺从") * 100

        else
            base.露出 = base.露出 + 1000
            base.情爱 = base.情爱 + 350

            if Select == "G点" then
                for index, value in ipairs(base) do
                    value = value * 1.4
                end
            end

            base.Samen = base.Samen + Train.GetAbility("受虐属性") * 100
        end
    elseif trainData.Posture == "乘骑位" then
        if trainData.IsFace then
            base.露出 = base.露出 + 900
            base.情爱 = base.情爱 + 500
        else
            base.露出 = base.露出 + 700
            base.情爱 = base.情爱 + 700
        end
        base.Samen = base.Samen + Train.GetAbility("性交中毒") * 100
    elseif trainData.Posture == "抱座位" then
        if trainData.IsFace then
            base.露出 = base.露出 + 1000
            base.情爱 = base.情爱 + 300
            if Select == "子宫口" then
                for index, value in ipairs(base) do
                    value = value * 1.5
                end
            end
        else
            base.露出 = base.露出 + 500
            base.情爱 = base.情爱 + 500
        end
    elseif trainData.Posture == "站立位" then
        if trainData.IsFace then
            base.露出 = base.露出 + 700
            base.情爱 = base.情爱 + 500
        else
            base.露出 = base.露出 + 1000
            base.情爱 = base.情爱 + 300
        end
    end
    local VFeel = Train.GetAbility("V感觉")
    if Select == "子宫" then
        local temp = VFeel + GetExpLV(Female : GetSexexp("子宫口经验"))
        if Train.HaveTalent("子宮性感") then
            temp = temp + 1
        end
        if temp <= 4 then
            base.疼痛 = base.疼痛 + 3000 
        elseif temp == 5 then
            base.疼痛 = base.疼痛 + 2000
        elseif temp == 6 then
            base.屈服 = base.屈服 + 100
            base.疼痛 = base.疼痛 + 1000
        elseif temp == 7 then
            base.屈服 = base.屈服 + 200
            base.疼痛 = base.疼痛 + 500
        elseif temp == 8 then
            base.屈服 = base.屈服 + 500
            base.疼痛 = base.疼痛 + 200
        elseif temp >= 9 then
            temp = temp - GetExpLV(Female : GetSexexp("子宫口经验"))
            base.屈服 = base.屈服 + 100 * temp
        end
        AddSexexp("子宫口经验", 2)
        AddSexexp("子宫奸经验", 1)
    elseif Select == "G点" then
        base.露出 = base.露出 + 400
        base.屈服 = base.屈服 + VFeel * 400
    elseif Select == "子宫口" then
        local t = VFeel
        if Train.HaveTalent("子宮性感") then
            t = t + 3
        end
        if t <= 2 then
            base.屈服 = base.屈服 + 100
            base.疼痛 = base.疼痛 + 1000
        elseif t <= 4 then
            base.屈服 = base.屈服 + 200
            base.疼痛 = base.疼痛 + 500
        elseif t <= 6 then
            base.屈服 = base.屈服 + 500
            base.疼痛 = base.疼痛 + 200
        else
            base.屈服 = base.屈服 + 100 * t
        end
        if Train.GetAbility("V扩张") > Size then
            base.C快乐 = trainData : CalcfStimulate("C刺激", 2, 30)
            base.C快乐 = EXABL(Trainer: GetAbility("性交中毒"), base.C快乐)
        end
        AddSexexp("V经验", 1)
        AddSexexp("子宫口经验", 1)
        if Trainer.IsJJ then
            AddSexexp("V插入经验", vc, Trainer)
        end
    end

    local temp1 = Train.GetAbility("欲望")
    if temp1 <= 5 then
        base.屈服 = base.屈服 * (temp1 * 0.1 + 0.05)
    elseif temp <= 10 then
        base.屈服 = base.屈服 * ((temp1 - 5) * 0.05 + 0.55)
    else
        base.屈服 = base.屈服 * ((temp1 - 10) * 0.02 + 0.8)
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

    local v = 1
    local vc = 0
    if Trainer.IsJJ then
        vc = 1
        if Trainer.Stature.JJSize >= 2 then
            v = 2
            vc = 2
        end

        if Trainer.Stature.JJSize >= math.max(Train.GetAbility("V扩张") + 1, 2) then
            AddSexexp("子宫口经验", 1)
            v = v + Trainer.Stature.JJSize - Train.GetAbility("V扩张")
            Expand("v", Trainer.Stature.JJSize, Trainer.Stature.JJHard)
        end
    end
    AddSexexp("V经验", v)
    AddSexexp("V性交经验", 1)
    AddSexexp("V插入经验", vc, Trainer)

    return base
end

function SexType(type)
    if type == "小穴性交" then
        return true
    elseif type == "性交" then
        return true
    elseif trainData.Posture == "乘骑位" and type == "侍奉快乐"  then
        return true
    end
    return false
end

function TrainMessage()
    ImplementKoujiu("插入小穴")
end

function Check()

if trainData.Posture == "乘骑位" then
    local value, text = Train.AllowAction()
    local n = Train.GetAbility("侍奉技术")
    value = OrderRequire(value, text, "abl", "侍奉技术", n * 2)

    local n = Train.GetAbility("性交中毒")
    value = OrderRequire(value, text, "abl", "性交中毒", n * 3)

    value = OrderRequire(value, text, "talent", "强硬", 10)
    value = OrderRequire(value, text, "talent", "害羞", -10)
    value = OrderRequire(value, text, "talent", "献身", 6)
    value = OrderRequire(value, text, "talent", "否定快感", -1)
    value = OrderRequire(value, text, "talent", "V性向", 10)
    
    if Female.IsChu then
        value = value - 20
        SB.append(text, "处女: -20 ")
    elseif GetExpLV(Female : GetSexexp("V经验")) < 2 then
        value = value - 5
        SB.append(text, "V经验不足: -5 ")
    end
    value = OrderRequire(value, text, "equip", "媚药", 6)


    return Train.ShowOrder(value, text, 24)
else
    return true
end
end
