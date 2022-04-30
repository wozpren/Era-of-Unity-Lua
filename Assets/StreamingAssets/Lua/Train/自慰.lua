local t = {}

local function PlayPlace()
    local data = require("Data/参数")
    local p = {阴部 = 8, 小穴 = 4, 菊穴 = 2, 尿道 = 0, 胸部 = 6}
    local Female = TrainManager.被调教者
    p.阴部 = p.阴部 + Female.阴部.感觉
    p.阴部 = p.阴部 + data:获取经验等级(Female.经验.阴部经验)
    if Female:检查性玩具("阴蒂夹","阴部") then
        if Female:获取能力("欲望") >= 3 and p.阴部 >= 3 then
            p.阴部 = p.阴部 + 5
        else
            p.阴部 = p.阴部 - 3
        end
    end
    if Female:检查特性("阴部性向") then
        p.阴部 = p.阴部 + 5
    end
    if Female:检查特性("淫核", "阴部") then
        p.阴部 = p.阴部 + 5
    end
    if Female.阴部.Name == "阴茎" then
        p.阴部 = p.阴部 + 3
    end


    p.小穴 = p.小穴 + Female.小穴.感觉
    p.小穴 = p.小穴 + data:获取经验等级(Female.经验.小穴经验)
    if Female:检查性玩具("振动棒","小穴") then
        if Female:获取能力("欲望") >= 3 and p.小穴 >= 3 then
            p.小穴 = p.小穴 + 6
        else
            p.小穴 = p.小穴 - 3
        end
    end
    if Female:检查特性("小穴性向") then
        p.小穴 = p.小穴 + 6
    end
    if Female:检查特性("淫壶", "小穴") then
        p.小穴 = p.小穴 + 5
    end


    p.胸部 = p.胸部 + Female.胸部.感觉
    p.胸部 = p.胸部 + data:获取经验等级(Female.经验.胸部经验)
    if Female:检查性玩具("乳头夹","胸部") then
        if Female:获取能力("欲望") >= 3 and p.胸部 >= 3 then
            p.胸部 = p.胸部 + 3
        else
            p.胸部 = p.胸部 - 3
        end
    end
    if Female:检查特性("胸性向") then
        p.胸部 = p.胸部 + 3
    end
    if Female:检查特性("淫乳", "胸部") then
        p.胸部 = p.胸部 + 5
    end


    p.菊穴 = p.菊穴 + Female.菊穴.感觉
    p.菊穴 = p.菊穴 + data:获取经验等级(Female.经验.菊穴经验)
    if Female:检查性玩具("肛门振动棒","菊穴") then
        if Female:检查能力("欲望", 3) and p.菊穴 >= 3 then
            p.菊穴 = p.菊穴 + 3
        else
            p.菊穴 = p.菊穴 - 3
        end
    end
    if Female:检查特性("菊穴性向") then
        p.菊穴 = p.菊穴 + 3
    end
    if Female:检查特性("淫尻", "菊穴") then
        p.菊穴 = p.菊穴 + 5
    end


    p.尿道 = p.尿道 + Female:获取能力("尿感觉")
    p.尿道 = p.尿道 + data:获取经验等级(Female.经验.尿道经验)
    if Female:检查性玩具("尿道振动棒","尿道") then
        if Female:获取能力("欲望") >= 3 and p.尿道 >= 3 then
            p.尿道 = p.尿道 + 6
        else
            p.尿道 = p.尿道 - 3
        end
    end
    if Female:检查特性("尿道性向") then
        p.尿道 = p.尿道 + 6
    end
    if Female:检查特性("尿道狂", "尿道") then
        p.尿道 = p.尿道 + 5
    end

    local place = 0
    local first = "阴部"
    for key, value in pairs(p) do
        if value > place then
            place = value
            first = key
        end
    end

    return first
end

---@param active ActiveMsg
function t:SexActive(active, Active, Select)
    local base = require("Data/ActionPack"):New()
    local Female = active.被调教者

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

    local hname = active.选择.."快感"

    base[hname] = Female:计算刺激度(active.选择, 1)
    base[hname] = TrainManager:EXABL(JQ, base[hname])

    local temp = Female:获取能力("自慰中毒") * 300 + Female:获取能力("露出癖") * 200
    temp = temp + JQ * 10
    base.充足 = Female:获取能力("自慰中毒") * 300 + Female:获取能力("露出癖")
    local exp = Female : 获取经验("自慰经验")
    if exp < 5 then
        temp = temp - 20
    elseif exp < 20 then
        temp = temp - 10
    else
        temp = temp + (exp / 5)
    end

    temp = UnityEngine.Mathf.Clamp(temp, -90, 400)
    base[hname] = base[hname] * (100 + temp) / 100


    if Female:获取能力("自慰中毒") == 0 then
        base.充足 = 0
    end

    local n = 1
    if Female.状态["媚药"] then
        n = n + 1
    end

    TrainManager:获得经验("自慰经验", n)
    TrainManager:获得经验(active.选择.."经验", n)

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

function t:Check(Trainer, Female, Select)
    Message:AddMessage("自慰")
    local value, text = TrainManager:AllowAction(Trainer, Female)
    local n = Female:获取能力("露出癖")
    value = TrainManager:OrderRequire(Female, value, text, "abl", "露出癖", n * 2)

    n = Female:获取能力("自慰中毒")
    value = TrainManager:OrderRequire(Female, value, text, "abl", "自慰中毒", n * 3)

    value = TrainManager:OrderRequire(Female, value, text, "talent", "强硬", -5)
    value = TrainManager:OrderRequire(Female, value, text, "talent", "冷漠", -5)
    value = TrainManager:OrderRequire(Female, value, text, "talent", "害羞", -15)
    value = TrainManager:OrderRequire(Female, value, text, "talent", "不知羞耻", 2)
    value = TrainManager:OrderRequire(Female, value, text, "talent", "接受快感", 5)
    value = TrainManager:OrderRequire(Female, value, text, "talent", "否定快感", -5)
    value = TrainManager:OrderRequire(Female, value, text, "state", "媚药", 10)
    value = TrainManager:OrderRequire(Female, value, text, "equip", "振动棒", -5)
    value = TrainManager:OrderRequire(Female, value, text, "equip", "肛门振动棒", -10)
    value = TrainManager:OrderRequire(Female, value, text, "place", "摄像机", -20)
    value = TrainManager:OrderRequire(Female, value, text, "place", "野外PLAY", -10)

    return TrainManager:ShowOrder(value, text, 33), Select
end

---@return ActiveMsg
function t:GetActive(trainer, trainee)
    local s = PlayPlace()
    ---@class ActiveMsg
    local o =
    {
        ---@type Character
        调教者 = trainee,
        ---@type Character
        被调教者 = trainee,
        执行 = trainee.手部,
        目标 = trainee[s],
        sex = self,
        体力减少 = 8,
        行为 = "自慰",
        选择 = s,
        次数 = 1,
    }

    return o
end

return t