equipEvent = {}

function equipEvent.眼(type)
    if trainData.Active == "眼罩" then
        return
    end

    local base = SMPlay("眼罩")
    Train.PosOccupy("眼", "眼罩")
    base.露出 = base.露出 + 1000
    base.逸脱 = base.逸脱 + 500
    if Train.HaveTalent("软弱") then
        base.逸脱 = base.逸脱 * 0.2
    end
    AddSexexp("拘束经验", 1)
    MultData(base, 0.2)
    return base
end

function equipEvent.嘴(type)
    if type == "肉棒" then
        if trainData.Active == "深喉" then
            return
        end

        local base = ServicePlay("口交")
        base.屈服 = base.屈服 + 1500
        base.逸脱 = base.逸脱 + 500
        base.达成感 = base.达成感 * 1.5
        base.性行动 = base.性行动 * 1.5
        base.M快乐 = base.M快乐 * 1.5
        base.屈服 = base.屈服 * 2
        base.不洁 = base.不洁 * 1.5
        base.逸脱 = base.逸脱 * 6
        base.M快乐 = trainData : CalcfStimulate("M刺激", 2)
        local gap = Train.GetAbility("喉扩张") - Trainer.Stature.JJSize
        if gap <= -2 then
            base.恐惧 = 3000
            base.疼痛 = 8000
        elseif gap == -1 then
            base.恐惧 = 1000
            base.疼痛 = 3000
        elseif gap == 0 then
            base.恐惧 = 500
            base.疼痛 = 1000
        elseif gap == 1 then
            base.恐惧 = 100
            base.疼痛 = 300
        end
        MultData(base, 0.2)
        base.Samen = base.Samen + 100 + base.ABLTech * 6
        base.Samen = base.Samen + Train.GetAbility("精液中毒") * 20
        AddSexexp("口交经验", 1)
        AddSexexp("喉性交经验", 1)
        return base
    elseif type == "口枷" then
        if trainData.Active == "口枷" then
            return
        end
        local base = SMPlay("口枷")
        base.疼痛 = 50
        base.充足 = 50
        base.露出 = 50
        base.屈服 = 150
        base.逸脱 = 80
        MultData(base, 0.2)
        AddSexexp("拘束经验", 1)
        return base
    end
end

function equipEvent.肛门(type)
    if type == "肉棒" then
        if trainData.Active == "插入肛门" then
            return
        end
        local base = InsertAcitve("插入肛门", "肛门")
        base.露出 = base.露出 + 1000
        base.情爱 = base.情爱 + 1000
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
        MultData(base, 0.2)
        return base
    elseif type == "肛门振动棒" then
        if trainData.Active == "肛门振动棒" then
            return
        end
        local base = InsertAcitve("肛门振动棒", "肛门")
        MultData(base, 0.2)
        return base
    end
end

function equipEvent.小穴(type)
    if type == "肉棒" then
        if trainData.Active == "插入小穴" then
            return
        end
        local base = InsertAcitve("插入小穴", "小穴")
        local VFeel = Train.GetAbility("V感觉")
        base.露出 = base.露出 + 1000
        base.情爱 = base.情爱 + 1000
    
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
        
        MultData(base, 0.2)
        return base
    elseif type == "振动棒" then
        if trainData.Active == "振动棒" then
            return
        end
        local base = InsertAcitve("振动棒", "小穴")
        MultData(base, 0.2)
        return base
    end
end

function equipEvent.尿道(type)
    if type == "肉棒" then
        if trainData.Active == "插入尿道" then
            return
        end
        local base = InsertAcitve("插入尿道", "尿道")
        base.露出 = base.露出 + 1000
        base.情爱 = base.情爱 + 500

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
        MultData(base, 0.2)

        AddSexexp("尿道经验",1)
        AddSexexp("尿道调教经验", 2, Trainer)
        AddSexexp("尿道性交经验", 1)
        AddSexexp("尿道插入经验", 1, Trainer)
        return base
    elseif type == "尿道振动棒" then
        if trainData.Active == "尿道振动棒" then
            return
        end
        local base = InsertAcitve("尿道振动棒", "尿道")
        MultData(base, 0.2)
        AddSexexp("尿道经验",1)
        AddSexexp("尿道调教经验", 1, Trainer)
        return base
    end
end

function equipEvent.活动(type)
    local base = SMPlay("拘束")
    base.疼痛 = base.疼痛 + 100
    base.恐惧 = base.恐惧 + 100
    base.露出 = base.露出 + 500
    base.屈服 = base.屈服 + 1000
    base.逸脱 = base.逸脱 + 500
    AddSexexp("拘束经验", 3)
    MultData(base, 0.2)
    return base
end

function equipEvent.阴蒂夹(data)

end

function equipEvent.乳头夹(data)

end

function equipEvent.摄像机(data)
    if trainData.Active == "张开" then
        data.露出 = data.露出 * 1.5 
        data.屈服 = data.屈服 * 1.5 
        data.逸脱 = data.逸脱 * 1.5 
    elseif trainData.Active == "自慰" then
        data.露出 = data.露出 * 1.5 
    end

end


function equipEvent.室内露出(data)
    if trainData.Active == "张开"then
            data.露出 = data.露出 * 1.5 
            data.屈服 = data.屈服 * 1.5 
            data.逸脱 = data.逸脱 * 1.5 
    end



end

function equipEvent.野外(data)
    if trainData.Active == "张开"then
            data.露出 = data.露出 * 1.5 
            data.屈服 = data.屈服 * 1.5 
            data.逸脱 = data.逸脱 * 1.5 
    end



end