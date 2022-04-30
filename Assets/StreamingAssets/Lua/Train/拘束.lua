local t = {}
function t:SexActive(active, Active, Select)
    local base = TrainManager:SMPlay("拘束")

    base.疼痛 = base.疼痛 + 100
    base.恐惧 = base.恐惧 + 100
    base.露出 = base.露出 + 500
    base.屈从 = base.屈从 + 1000
    base.逃脱 = base.逃脱 + 500
    TrainManager:获得经验("拘束经验", 2)
    return base
end

function t:SexType(type)
    if type == "SM" or type == "中度SM" or type == "被虐快乐" then
        return true
    end
    return false
end

function t:TrainMessage(active)
    local text = SB:New()
    text:Append("@player@将@target@绑了起来。")
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
        体力减少 = 10,
        行为 = "拘束",
        选择 = select,
        次数 = 1,
    }

    return o
end

return t