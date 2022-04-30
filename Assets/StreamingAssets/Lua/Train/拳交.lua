local t = {}
function t:SexActive(active, Active, Select)
    if Select == "双穴" then
        local base = require("Train/插入")(active, Active, "小穴")
        active.目标 = active.被调教者.菊穴
        base = base + require("Train/插入")(active, Active, "菊穴")
        base = base + TrainManager:SMPlay(active, "双重拳交")
        active.乘数 = 0.75
        return base
    else
        local base = require("Train/插入")(active, Active, Select)
        base = base + TrainManager:SMPlay(active, "拳交")
        return base
    end
end

function t:SexType(type)
    if type == "重度SM" or type == "SM" or "被虐快乐" or type == "异常"  then
        return true
    end

    return false
end

function t:TrainMessage(active)
    local text = SB:New()
    text:Append("拳交")
    UIManager:GetUI("TrainView"):Append(text:ToStr(), active)
end


function t:Check(Trainer, Female, Select)
    return true,Select
end

---@return ActiveMsg
function t:GetActive(trainer, trainee, select)
    local s = select
    if select == "双穴" then
        s = "小穴"
    end
    local o = 
    {
        ---@type Character
        调教者 = trainer,
        ---@type Character
        被调教者 = trainee,
        执行 = trainer.手部,
        目标 = trainee[select],
        sex = self,
        体力减少 = 5,
        行为 = "拳交",
        选择 = select,
        次数 = 1,
    }
    return o
end

return t