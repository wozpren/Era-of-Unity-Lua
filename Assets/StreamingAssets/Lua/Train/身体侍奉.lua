local t = {}
function t:SexActive(active, Active, Select)
    local base = TrainManager:ServicePlay(active)
    base.不洁 = base.不洁 + 200
    base.欲情追加 = base.欲情追加 + TrainManager:AddLust(active)
    if Select == "菊穴" then
        base.逃脱 = base.逃脱 + 3000
        base.屈从 = base.屈从 + 5000
    elseif Select == "小穴" then
        base.逃脱 = base.逃脱 + 1000
        base.屈从 = base.屈从 + 500
    elseif Select == "脚部" then
        base.逃脱 = base.逃脱 + 2000
        base.屈从 = base.屈从 + 4000
    end
    return base
end




function t:SexType(type)
    if type == "侍奉" or type == "侍奉快乐" then
        return true
    end
    return false
end

function t:TrainMessage(active)
    local text = SB:New()
    text:Append("!!!。")
    UIManager:GetUI("TrainView"):Append(text:ToStr(), active)
end

function t:Check(Trainer, Female, Select)
    local value, text = TrainManager:AllowAction(Trainer, Female)
    local n = Female:获取能力("侍奉技术")
    value = TrainManager:OrderRequire(Female, value, text, "abl", "侍奉技术", n * 2)
    if Select == "脚部" then   
        local n = Female:获取能力("受虐属性")
        value = TrainManager:OrderRequire(Female,value, text, "abl", "受虐属性", n * 3)
    end
    value = TrainManager:OrderRequire(Female,value, text, "talent", "害羞", -5)
    value = TrainManager:OrderRequire(Female,value, text, "talent", "献身", 6)
    value = TrainManager:OrderRequire(Female,value, text, "talent", "否定快感", -1)
    
    if Select == "小穴" then
        value = TrainManager:OrderRequire(Female,value, text, "sex", "男", 10)
    end
    
    return TrainManager:ShowOrder(value, text, 40)
end


---@return ActiveMsg
function t:GetActive(trainer, trainee, select)
    local o = 
    {
        ---@type Character
        调教者 = trainer,
        ---@type Character
        被调教者 = trainee,
        执行 = trainee,
        目标 = trainer,
        sex = self,
        体力减少 = 10,
        行为 = "身体侍奉",
        选择 = select,
        次数 = 1,
    }

    return o
end

return t