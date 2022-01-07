function SexActive(Active, Select)
local base = ActiveData.new()

local pl1, pl2 = PlayPlace()

local JQ = Train.GetAbility("技巧")
base.性行动 = 100 + JQ * 100
local lcp = Train.GetAbility("露出癖")
if lcp <= 5 then
    base.露出 = 2000 + lcp * 200
    base.屈服 = 500 + lcp * 300
    base.逸脱 = 800 - lcp * 100
elseif lcp <= 10 then
    base.露出 = 3000 + (lcp - 5) * 100
    base.屈服 = 2000 + (lcp - 5) * 200
    base.逸脱 = 300 - (lcp - 5) * 50
else
    base.露出 = 3500 + (lcp - 10) * 50
    base.屈服 = 3000 + (lcp - 10) * 100
    base.逸脱 = 0
end

if Select == "小穴" then
    base.V快乐 = trainData : CalcfStimulate("V刺激", 1)
    base.V快乐 = EXABL(JQ, base.V快乐)
elseif Select == "肛门" then
    base.A快乐 = trainData : CalcfStimulate("A刺激", 1)
    base.A快乐 = EXABL(JQ, base.A快乐)
elseif Select == "胸部" then
    base.B快乐 = trainData : CalcfStimulate("B刺激", 1)
    base.B快乐 = EXABL(JQ, base.B快乐)
elseif Select == "阴核" then
    base.C快乐 = trainData : CalcfStimulate("C刺激", 1)
    base.C快乐 = EXABL(JQ, base.C快乐)
elseif Select == "尿道" then
    base.尿快乐 = trainData : CalcfStimulate("尿道刺激", 1)
    base.尿快乐 = EXABL(JQ, base.尿快乐)
end

local temp = Train.GetAbility("自慰中毒") * 300 + Train.GetAbility("露出癖") * 200
temp = temp + JQ * 10
base.充足 = Train.GetAbility("自慰中毒") * 300 + Train.GetAbility("露出癖")
local exp = Female : GetSexexp("自慰经验")
if exp < 5 then
    temp = temp - 20
elseif exp < 20 then
    temp = temp - 10
else
    temp = temp + Female : GetSexexp("自慰经验") / 5
end

temp = Mathf.Clamp(temp, -90, 400)
base[pl1.."快乐"] = base[pl1.."快乐"] * (100 + temp) / 100
base[pl2.."快乐"] = base[pl2.."快乐"] * (100 + temp) / 100


if Train.GetAbility("自慰中毒") == 0 then
    base.充足 = 0
end

local n = 1
if trainData.equipItem : Contains("媚药") then
    n = n + 1
end

AddSexexp("自慰经验", 1)
if pl1 == pl2 and pl1 ~= "B" then
    AddSexexp(pl1.."经验", 2)
else
    if pl1 ~= "B" then
        AddSexexp(pl1.."经验", 1)
    end
    if pl2 ~= "B" then
        AddSexexp(pl2.."经验", 1)
    end
end

return base
end

function SexType(type)
    if type == "自慰" or type == "露出" then
        return true
    elseif type == "羞耻快乐" then
        return true
    elseif type == "爱抚" then
        return true
    end

    return false
end


function TrainMessage()
    ImplementKoujiu("自慰")
end

local function PlayPlace()
    local p = {C = 0, V = 0, A = 0, 尿 = 0, B = 0}

    p.c = Train.GetAbility("C感觉")
    if trainData.equipItem : Contains("阴蒂夹") then
        if Train.欲望 >= 3 and p.c >= 3 then
            p.c = p.c + 3
        else
            p.c = p.c - 3
        end
    end
    if Train.HaveTalent("C性向") then
        p.c = p.c + 3
    end
    if Train.HaveTalent("淫核") then
        p.c = p.c + 5
    end
    if Female.IsJJ then
        p.c = p.c + 3
    end


    p.V = Train.GetAbility("V感觉")
    if Train.Pos["小穴"] == "振动棒" then
        if Train.欲望 >= 3 and p.V >= 3 then
            p.V = p.V + 3
        else
            p.V = p.V - 3
        end
    end
    if Train.HaveTalent("V性向") then
        p.V = p.V + 3
    end
    if Train.HaveTalent("淫壶") then
        p.V = p.V + 5
    end


    p.B = Train.GetAbility("B感觉")
    if trainData.equipItem : Contains("乳头夹") then
        if Train.欲望 >= 3 and p.B >= 3 then
            p.B = p.B + 3
        else
            p.B = p.B - 3
        end
    end
    if Train.HaveTalent("B性向") then
        p.B = p.B + 3
    end
    if Train.HaveTalent("淫乳") then
        p.B = p.B + 5
    end


    p.A = Train.GetAbility("A感觉")
    if Train.Pos["肛门"] == "肛门振动棒" then
        if Train.欲望 >= 3 and p.A >= 3 then
            p.A = p.A + 3
        else
            p.A = p.A - 3
        end
    end
    if Train.HaveTalent("A性向") then
        p.A = p.A + 3
    end
    if Train.HaveTalent("淫尻") then
        p.A = p.A + 5
    end


    p.尿 = Train.GetAbility("尿感觉")
    if Train.Pos["尿道"] == "尿道振动棒" then
        if Train.欲望 >= 3 and p.尿 >= 3 then
            p.尿 = p.尿 + 3
        else
            p.尿 = p.尿 - 3
        end
    end
    if Train.HaveTalent("尿性向") then
        p.尿 = p.尿 + 3
    end
    if Train.HaveTalent("尿道狂") then
        p.尿 = p.尿 + 5
    end

    local place = {0, 0}
    local first = "C"
    local second = "C"
    for key, value in pairs(p) do
        if value > place[2] then
            place[2] = value
            second = key
            if place[2] > place[1] then
                place[2] = place[1]
                place[1] = value
            
                second = first
                first = key
            end
        end
    end
    if first ~= second and (first <= 3 or first - second > 2) then
        second = first
    end

    return first, second
end

function Check()
    local value, text = Train.AllowAction()
    print(SB.tostr(text))
    local n = Train.GetAbility("露出癖")
    value = OrderRequire(value, text, "abl", "露出癖", n * 2)
    
    n = Train.GetAbility("自慰中毒")
    value = OrderRequire(value, text, "abl", "自慰中毒", n * 3)
    
    value = OrderRequire(value, text, "talent", "强硬", -5)
    value = OrderRequire(value, text, "talent", "冷漠", -5)
    value = OrderRequire(value, text, "talent", "害羞", -15)
    value = OrderRequire(value, text, "talent", "不知羞耻", 2)
    value = OrderRequire(value, text, "talent", "接受快感", 5)
    value = OrderRequire(value, text, "talent", "否定快感", -5)
    value = OrderRequire(value, text, "equip", "媚药", 6)
    value = OrderRequire(value, text, "equip", "振动棒", -5)
    value = OrderRequire(value, text, "equip", "肛门振动棒", -10)
    value = OrderRequire(value, text, "equip", "摄像机", -20)
    value = OrderRequire(value, text, "place", "野外PLAY", -10)
    print(SB.tostr(text))
    return Train.ShowOrder(value, text, 33)
end