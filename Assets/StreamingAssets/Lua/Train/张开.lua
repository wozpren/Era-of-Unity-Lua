function SexActive(Active, Select)
    local base = ActiveData.new()
    local lcp = Train.GetAbility("露出癖")

    if Select == "小穴" then
        base.不洁 = 200
        base.露出 = 5000
        base.屈服 = 500
        base.逸脱 = 500

        if lcp < 5 then 
            base.充足 = lcp * 500
        elseif lcp < 10 then
            base.充足 = 2500 + (lcp - 5) * 200
        else
            base.充足 = 3500 + (lcp - 10) * 100
        end
        if Train.HaveTalent("V性向") then
            base.不洁 = base.不洁 * 0.5
            base.逸脱 = base.逸脱 * 0.5
            base.充足 = base.充足 * 2
        end
        if Female.IsChu then
            base.屈服 = base.屈服 * 2
            base.露出 = base.露出 + 2000
            if Train.HaveTalent("贞操重视") then
                base.露出 = base.露出 * 2
            end
        end
        if trainData : PrevPlay("V绝顶")  ~= 0 then
            base.露出 = base.露出 * 1.5
            base.逸脱 = base.逸脱 * 1.5
        end
    elseif Select == "肛门" then
        base.不洁 = 500
        base.露出 = 4000
        base.屈服 = 1000
        base.逸脱 = 1000

        if lcp < 5 then 
            base.充足 = lcp * 500
        elseif lcp < 10 then
            base.充足 = 2500 + (lcp - 5) * 200
        else
            base.充足 = 3500 + (lcp - 10) * 100
        end
        if Train.HaveTalent("A性向") then
            base.不洁 = base.不洁 * 0.5
            base.逸脱 = base.逸脱 * 0.5
            base.充足 = base.充足 * 2
        end
        if trainData : PrevPlay("A绝顶") ~= 0 then
            base.露出 = base.露出 * 1.5
            base.逸脱 = base.逸脱 * 1.5
        end
    end



    if Train.HaveTalent("害羞") then
        base.逸脱 = base.逸脱 * 2
    end
    if Train.HaveTalent("不知羞耻") then
        base.逸脱 = base.逸脱 * 0.5
    end


    local exp = 2
    if trainData.equipItem : Contains("摄像机") then
        exp = exp + 1
        base.屈服 = base.屈服 * 1.5
        base.露出 = base.露出 * 1.5
        base.逸脱 = base.逸脱 * 1.5
    end
    if trainData.place == "野外PLAY" then
        exp = exp + 1
        base.屈服 = base.屈服 * 1.5
        base.露出 = base.露出 * 1.5
        base.逸脱 = base.逸脱 * 1.5
    end


    AddSexexp("露出经验", exp)

    return base
end

function SexType(type)
    if type == "露出" then
        return true
    elseif type == "羞耻快乐" then
        return true
    end
    return false
end

function TrainMessage()
    ImplementKoujiu("张开")
end



function Check()
    local value, text = Train.AllowAction()
    local n = Train.GetAbility("露出癖")
    value = OrderRequire(value, text, "abl", "露出癖", n * 2)
    
    n = Train.GetAbility("受虐属性")
    value = OrderRequire(value, text, "abl", "受虐属性", n * 3)
    
    value = OrderRequire(value, text, "talent", "冷漠", -5)
    value = OrderRequire(value, text, "talent", "害羞", -15)
    value = OrderRequire(value, text, "talent", "不知羞耻", 2)
    value = OrderRequire(value, text, "talent", "清楚", -10)
    value = OrderRequire(value, text, "talent", "否定快感", -5)
    value = OrderRequire(value, text, "prev", "V中出", -10)
    value = OrderRequire(value, text, "equip", "媚药", 2)
    value = OrderRequire(value, text, "equip", "摄像机", -30)
    value = OrderRequire(value, text, "place", "野外PLAY", -10)
    
    return Train.ShowOrder(value, text, 30)
end