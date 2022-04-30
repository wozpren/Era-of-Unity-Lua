local t = {}
function t:SexActive(active, Active, Select)
    local base = require("Train/插入")(active, Active, Select)
    local Female = active.被调教者


    if TrainManager:检查占用(Female, "阴部", "振动棒") then
        active.乘数 = 1.3
    else
        if Select == "G点" then
            active.乘数 = 1.5
        end
    end
    if Select == "小穴" then
        TrainManager:获得经验("小穴经验", 1)
    elseif Select == "菊穴经验" then
        TrainManager:获得经验("菊穴经验", 1)
    elseif Select == "尿道" then
        TrainManager:获得经验("尿道经验", 1)
    end
    TrainManager:获得经验("手淫经验", 1, active.调教者)


    return base
end

function t:TrainMessage(active)
    local text = SB:New()
    text:Append("@player@用手指玩弄@target@的小穴。")
    UIManager:GetUI("TrainView"):Append(text:ToStr(), active)
end

function t:SexType(type)
    if type == "V插入" then
        return true
    end
    return false
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
        目标 = trainee.小穴,
        sex = self,
        体力减少 = 10,
        行为 = "指插入",
        选择 = select,
        次数 = 1,
    }

    return o
end

return t