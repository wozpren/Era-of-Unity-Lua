local t = {}
function t:SexActive(active, Active, Select)
    local Female = active.被调教者
    local base = require("Data/ActionPack"):New()
    local lcp = Female:获取能力("露出癖")

    if Select == "小穴" then
        base.不洁 = 200
        base.露出 = 2500
        base.屈从 = 500
        base.逃脱 = 500

        if lcp < 5 then 
            base.充足 = lcp * 500
        elseif lcp < 10 then
            base.充足 = 2500 + (lcp - 5) * 200
        else
            base.充足 = 3500 + (lcp - 10) * 100
        end
        if Female:检查特性("小穴性向") then
            base.不洁 = base.不洁 * 0.5
            base.逃脱 = base.逃脱 * 0.5
            base.充足 = base.充足 * 2
        end
        if Female:检查特性("处女", "小穴") then
            base.屈从 = base.屈从 * 2
            base.露出 = base.露出 + 2000
            if Female:检查特性("贞操重视") then
                base.露出 = base.露出 * 2
            end
        end
        if TrainManager:获取上次信息(Female, "小穴绝顶")  ~= 0 then
            base.露出 = base.露出 * 1.5
            base.逃脱 = base.逃脱 * 1.5
        end
    elseif Select == "菊穴" then
        base.不洁 = 500
        base.露出 = 3000
        base.屈从 = 1000
        base.逃脱 = 1000

        if lcp < 5 then 
            base.充足 = lcp * 500
        elseif lcp < 10 then
            base.充足 = 2500 + (lcp - 5) * 200
        else
            base.充足 = 3500 + (lcp - 10) * 100
        end
        if Female:检查特性("菊穴性向") then
            base.不洁 = base.不洁 * 0.5
            base.逃脱 = base.逃脱 * 0.5
            base.充足 = base.充足 * 2
        end
        if TrainManager:获取上次信息(Female, "菊穴绝顶") ~= 0 then
            base.露出 = base.露出 * 1.5
            base.逃脱 = base.逃脱 * 1.5
        end
    end



    if Female:检查特性("害羞") then
        base.逃脱 = base.逃脱 * 2
    end
    if Female:检查特性("不知羞耻") then
        base.逃脱 = base.逃脱 * 0.5
    end


    local exp = 2
    if table.Exist(TrainManager.调教地点特性, "摄像机") then
        exp = exp + 1
        base.屈从 = base.屈从 * 1.5
        base.露出 = base.露出 * 1.5
        base.逃脱 = base.逃脱 * 1.5
    end
    if table.Exist(TrainManager.调教地点特性, "野外PLAY") then
        exp = exp + 1
        base.屈从 = base.屈从 * 1.5
        base.露出 = base.露出 * 1.5
        base.逃脱 = base.逃脱 * 1.5
    end


    TrainManager:获得经验("露出经验", exp)

    return base
end

function t:SexType(type)
    if type == "露出" then
        return true
    elseif type == "羞耻快乐" then
        return true
    end
    return false
end

function t:TrainMessage(active)
    local text = SB:New()
    text:Append("张开")
    UIManager:GetUI("TrainView"):Append(text:ToStr(), active)
end



function t:Check(Trainer, Female, Select)
    Message:AddMessage("张开"..Select)

    local value, text = TrainManager:AllowAction(Trainer, Female)
    local n = Female:获取能力("露出癖")
    value = TrainManager:OrderRequire(Female,value, text, "abl", "露出癖", n * 2)
    
    n = Female:获取能力("受虐属性")
    value = TrainManager:OrderRequire(Female,value, text, "abl", "受虐属性", n * 3)
    
    value = TrainManager:OrderRequire(Female, value, text, "talent", "冷漠", -5)
    value = TrainManager:OrderRequire(Female,value, text, "talent", "害羞", -15)
    value = TrainManager:OrderRequire(Female,value, text, "talent", "不知羞耻", 2)
    value = TrainManager:OrderRequire(Female,value, text, "talent", "清楚", -10)
    value = TrainManager:OrderRequire(Female,value, text, "talent", "否定快感", -5)
    value = TrainManager:OrderRequire(Female,value, text, "prev", "小穴中出", -10)
    value = TrainManager:OrderRequire(Female,value, text, "equip", "媚药", 2)
    value = TrainManager:OrderRequire(Female,value, text, "equip", "摄像机", -30)
    value = TrainManager:OrderRequire(Female,value, text, "place", "野外PLAY", -10)
    
    return TrainManager:ShowOrder(value, text, 0), Select
end

---@return ActiveMsg
function t:GetActive(trainer, trainee, select)
    local o =
    {
        ---@type Character
        调教者 = trainer,
        ---@type Character
        被调教者 = trainee,
        执行 = trainee.手部,
        目标 = trainee.小穴,
        sex = self,
        体力减少 = 5,
        行为 = "张开",
        选择 = select,
        次数 = 1,
    }
    return o
end

return t