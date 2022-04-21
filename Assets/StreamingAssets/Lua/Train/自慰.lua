local t = {}

local function PlayPlace()
    local p = {阴部 = 0, 小穴 = 0, 菊穴 = 0, 尿道 = 0, 胸 = 0}
    local Female = TrainManager.被调教者
    p.阴部 = Female.阴部.感觉
    if Female.阴部.装备["阴蒂夹"] then
        if Female:获取能力("欲望") >= 3 and p.阴部 >= 3 then
            p.阴部 = p.阴部 + 3
        else
            p.阴部 = p.阴部 - 3
        end
    end
    if Female:检查特性("阴部性向") then
        p.阴部 = p.阴部 + 3
    end
    if Female.阴部.特性["淫核"] then
        p.阴部 = p.阴部 + 5
    end
    if Female.阴部.IsJJ then
        p.阴部 = p.阴部 + 3
    end


    p.小穴 = Female.小穴.感觉
    if Female.小穴.装备["振动棒"] then
        if Female:获取能力("欲望") >= 3 and p.小穴 >= 3 then
            p.小穴 = p.小穴 + 3
        else
            p.小穴 = p.小穴 - 3
        end
    end
    if Female:检查特性("小穴性向") then
        p.小穴 = p.小穴 + 3
    end
    if Female.小穴.特性["淫壶"] then
        p.小穴 = p.小穴 + 5
    end


    p.胸 = Female.胸.感觉
    if Female.胸.装备["乳头夹"] then
        if Female:获取能力("欲望") >= 3 and p.胸 >= 3 then
            p.胸 = p.胸 + 3
        else
            p.胸 = p.胸 - 3
        end
    end
    if Female:检查特性("胸性向") then
        p.胸 = p.胸 + 3
    end
    if Female.胸.特性["淫乳"] then
        p.胸 = p.胸 + 5
    end


    p.菊穴 = Female.菊穴.感觉
    if Female.菊穴.装备["肛门振动棒"] then
        if Female:获取能力("欲望") >= 3 and p.菊穴 >= 3 then
            p.菊穴 = p.菊穴 + 3
        else
            p.菊穴 = p.菊穴 - 3
        end
    end
    if Female:检查特性("菊穴性向") then
        p.菊穴 = p.菊穴 + 3
    end
    if Female.菊穴.特性["淫尻"] then
        p.菊穴 = p.菊穴 + 5
    end


    p.尿道 = Female:获取能力("尿感觉")
    if Female.尿道.装备["尿道振动棒"] then
        if Female:获取能力("欲望") >= 3 and p.尿道 >= 3 then
            p.尿道 = p.尿道 + 3
        else
            p.尿道 = p.尿道 - 3
        end
    end
    if Female:检查特性("尿道性向") then
        p.尿道 = p.尿道 + 3
    end
    if Female.尿道.特性["尿道狂"] then
        p.尿道 = p.尿道 + 5
    end

    local place = {0, 0}
    local first = "阴部"
    local second = "阴部"
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

---@param active ActiveMsg
function t:SexActive(active, Active, Select)
    local base = require("Data/ActionPack"):New()
    local Female = active.被调教者
    local pl1, pl2 = PlayPlace()

    local JQ = active.执行.技巧
    if JQ then
        JQ = 0
    end
    base.性行动 = 100 + JQ * 100
    local lcp = Female:获取能力("露出癖")
    if lcp <= 5 then
        base.露出 = 2000 + lcp * 200
        base.屈从 = 500 + lcp * 300
        base.逃脱 = 800 - lcp * 100
    elseif lcp <= 10 then
        base.露出 = 3000 + (lcp - 5) * 100
        base.屈从 = 2000 + (lcp - 5) * 200
        base.逃脱 = 300 - (lcp - 5) * 50
    else
        base.露出 = 3500 + (lcp - 10) * 50
        base.屈从 = 3000 + (lcp - 10) * 100
        base.逃脱 = 0
    end

    if pl1 == "小穴" then
        base.小穴快感 = Female:计算刺激度("小穴", 1)
        base.小穴快感 = TrainManager:EXABL(JQ, base.小穴快感)
    elseif pl1 == "菊穴" then
        base.菊穴快感 = Female:计算刺激度("菊穴", 1)
        base.菊穴快感 = TrainManager:EXABL(JQ, base.菊穴快感)
    elseif pl1 == "胸" then
        base.胸部快感 = Female:计算刺激度("胸", 1)
        base.胸部快感 = TrainManager:EXABL(JQ, base.胸部快感)
    elseif pl1 == "阴核" then
        base.阴部快感 = Female:计算刺激度("阴部", 1)
        base.阴部快感 = TrainManager:EXABL(JQ, base.阴部快感)
    elseif pl1 == "尿道" then
        base.尿道快感 = Female:计算刺激度("尿道", 1)
        base.尿道快感 = TrainManager:EXABL(JQ, base.尿道快感)
    end
    if pl2 == "小穴" then
        base.小穴快感 = Female:计算刺激度("小穴", 1)
        base.小穴快感 = TrainManager:EXABL(JQ, base.小穴快感)
    elseif pl2 == "菊穴" then
        base.菊穴快感 = Female:计算刺激度("菊穴", 1)
        base.菊穴快感 = TrainManager:EXABL(JQ, base.菊穴快感)
    elseif pl2 == "胸" then
        base.胸部快感 = Female:计算刺激度("胸", 1)
        base.胸部快感 = TrainManager:EXABL(JQ, base.胸部快感)
    elseif pl2 == "阴部" then
        base.阴部快感 = Female:计算刺激度("阴部", 1)
        base.阴部快感 = TrainManager:EXABL(JQ, base.阴部快感)
    elseif pl2 == "尿道" then
        base.尿道快感 = Female:计算刺激度("尿道", 1)
        base.尿道快感 = TrainManager:EXABL(JQ, base.尿道快感)
    end

    local temp = Female:获取能力("自慰中毒") * 300 + Female:获取能力("露出癖") * 200
    temp = temp + JQ * 10
    base.充足 = Female:获取能力("自慰中毒") * 300 + Female:获取能力("露出癖")
    local exp = Female : 获取经验("自慰经验")
    if exp < 5 then
        temp = temp - 20
    elseif exp < 20 then
        temp = temp - 10
    else
        temp = temp + Female : 获取经验("自慰经验") / 5
    end

    temp = Mathf.Clamp(temp, -90, 400)
    base[pl1.."快感"] = base[pl1.."快感"] * (100 + temp) / 100
    base[pl2.."快感"] = base[pl2.."快感"] * (100 + temp) / 100


    if Female:获取能力("自慰中毒") == 0 then
        base.充足 = 0
    end

    local n = 1
    if Female.状态["媚药"] then
        n = n + 1
    end

    TrainManager:获得经验("自慰经验", n)
    if pl1 == pl2 and pl1 ~= "B" then
        TrainManager:获得经验(pl1.."经验", 2)
    else
        if pl1 ~= "B" then
            TrainManager:获得经验(pl1.."经验", 1)
        end
        if pl2 ~= "B" then
            TrainManager:获得经验(pl2.."经验", 1)
        end
    end

    return base
end

function t:SexType(type)
    if type == "自慰" or type == "露出" then
        return true
    elseif type == "羞耻快乐" then
        return true
    elseif type == "爱抚" then
        return true
    end

    return false
end


function t:TrainMessage(active)
    local text = SB:New()

    UIManager:GetUI("TrainView"):Append(text:ToStr(), active)
end

function t:Check()
    local value, text = Train.AllowAction()
    local n = Female:获取能力("露出癖")
    value = TrainManager:OrderRequire(value, text, "abl", "露出癖", n * 2)
    
    n = Female:获取能力("自慰中毒")
    value = TrainManager:OrderRequire(value, text, "abl", "自慰中毒", n * 3)
    
    value = TrainManager:OrderRequire(value, text, "talent", "强硬", -5)
    value = TrainManager:OrderRequire(value, text, "talent", "冷漠", -5)
    value = TrainManager:OrderRequire(value, text, "talent", "害羞", -15)
    value = TrainManager:OrderRequire(value, text, "talent", "不知羞耻", 2)
    value = TrainManager:OrderRequire(value, text, "talent", "接受快感", 5)
    value = TrainManager:OrderRequire(value, text, "talent", "否定快感", -5)
    value = TrainManager:OrderRequire(value, text, "state", "媚药", 10)
    value = TrainManager:OrderRequire(value, text, "equip", "振动棒", -5)
    value = TrainManager:OrderRequire(value, text, "equip", "肛门振动棒", -10)
    value = TrainManager:OrderRequire(value, text, "place", "摄像机", -20)
    value = TrainManager:OrderRequire(value, text, "place", "野外PLAY", -10)
    print(text:ToStr())
    return Train.ShowOrder(value, text, 33)
end

return t