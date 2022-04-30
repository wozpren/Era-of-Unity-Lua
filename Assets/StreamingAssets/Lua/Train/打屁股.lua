local t = {}
function t:SexActive(active, Active, Select)
    local base = TrainManager:SMPlay(active, "打屁股")
    local Data = require("Data/参数")
    base.露出 = base.露出 + 200
    base.逃脱 = base.逃脱 + 200

    local s = active.调教者:获取能力("施虐属性")
    local kt = TrainManager: 获取人物状态("痛苦")



    local level = math.min(Data:获取等级(kt), 5)
    base.疼痛 = base.疼痛 + (level + 1) * 300
    base.屈从 = base.屈从 + base.疼痛 / 2 * (1 + s * 0.2)
    
    if active.被调教者:检查特性("成长期") then
        base.屈从 = base.屈从 * 1.5
    end
    if not TrainManager:检查占用(active.被调教者, "小穴") then
        base.疼痛 = base.疼痛 * 0.5
        base.露出 = base.露出 * 1.5
        base.屈从 = base.屈从 * 1.5
    end

    return base
end

function t:SexType(type)
    if type == "被虐快乐" then
        return true
    elseif type == "轻度SM" then
        return true
    elseif type == "SM" then
        return true
    end


    return false
end

function t:TrainMessage(active)
    local text = SB:New()
    text:Append("@player@用手向@target@的屁股打去。")
    UIManager:GetUI("TrainView"):Append(text:ToStr(), active)
end



function t:Check(Trainer, Female, Select)
    return true, Select
end

---@return ActiveMsg
function t:GetActive(trainer, trainee, select)
    local o = 
    {
        ---@type Character
        调教者 = trainer,
        ---@type Character
        被调教者 = trainee,
        执行 = trainer.手部,
        目标 = trainee.胯部,
        sex = self,
        体力减少 = 15,
        行为 = "打屁股",
        选择 = select,
        次数 = 1,
    }

    return o
end

return t