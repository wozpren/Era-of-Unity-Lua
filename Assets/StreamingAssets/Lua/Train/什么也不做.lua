local t = {}
function t:SexActive(active, Active, Select)
    local base = require("Data/ActionPack"):New()
    return base
end

function t:SexType(type)
    return false
end

function t:TrainMessage(active)
    local text = SB:New()
    text:Append("什么也不做。")
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
        执行 = trainer,
        目标 = trainee,
        sex = self,
        体力减少 = 5,
        行为 = "什么也不做",
        选择 = select,
        次数 = 1,
    }

    return o
end
return t