local t = {}
function t:SexActive(active, Active, Select)
    local base = TrainManager:SMPlay("剃毛")
    local Female = active.被调教者
    base.露出 = base.露出 + 6000
    base.屈从 = base.屈从 + 1000
    base.逃脱 = base.逃脱 + 1000

    if Select == "修正形态" then
        base.露出 = base.露出 + 4000
        base.屈从 = base.屈从 + 1000
        base.逃脱 = base.逃脱 + 1000
    else
        base.露出 = base.露出 + 6000
        base.屈从 = base.屈从 + 1500
        base.逃脱 = base.逃脱 + 5000
    end

    local n = Female:获取能力("露出癖") / 2 + Female:获取能力("受虐属性")
    if n >= 9 then
        base.充足 = base.充足 + 5000
        base.屈从 = base.屈从 * 0.3
    elseif n >= 7 then
        base.充足 = base.充足 + 3000
        base.屈从 = base.屈从 * 0.6
    elseif n >= 5 then
        base.充足 = base.充足 + 1000
        base.屈从 = base.屈从 * 0.7
    elseif n >= 1 then
        base.屈从 = base.屈从 * 1.2
    else
        base.屈从 = base.屈从 * 1.5
    end

    if table.Exist(TrainManager.调教地点特性, "摄像机") then
        base.露出 = base.露出 * 1.5
        base.屈从 = base.屈从 * 1.5
        base.逃脱 = base.逃脱 * 1.5
    end
    if table.Exist(TrainManager.调教地点特性, "室内PLAY") or table.Exist(TrainManager.调教地点特性, "野外PLAY") then
        base.露出 = base.露出 * 1.5
        base.屈从 = base.屈从 * 1.5
        base.逃脱 = base.逃脱 * 1.5
    end

    return base
end

function t:SexType(type)
    if type == "露出" or type == "羞耻快乐" or type == "被虐快乐" or type == "轻度SM" then
        return true
    end
    return false
end

function t:TrainMessage(active)
    local text = SB:New()
    text:Append("剃毛")
    UIManager:GetUI("TrainView"):Append(text:ToStr(), active)
end

function t:Check(Trainer, Female, Select)
    local value, text = TrainManager:AllowAction(Trainer, Female)
    local n = Train.GetAbility("露出癖")
    value = OrderRequire(value, text, "abl", "露出癖", n * 2)
    
    n = Train.GetAbility("受虐属性")
    value = OrderRequire(value, text, "abl", "受虐属性", n * 3)
    
    value = OrderRequire(value, text, "talent", "害羞", -15)
    value = OrderRequire(value, text, "talent", "不知羞耻", 5)
    value = OrderRequire(value, text, "talent", "倒错的", 10)
    value = OrderRequire(value, text, "equip", "拘束", 30)
    value = OrderRequire(value, text, "equip", "摄像机", -20)
    
    
    if TrainManager:ShowOrder(value, text, 60) then
        local text = SB:New()
        text:Append(AddButton("完全剃光   ","CoroutineResume,完全剃光"))
        text:Append(AddButton("修正形态   ","CoroutineResume,修正形态"))
        text:Append(AddButton("还是算了   ","CoroutineResume,还是算了"))
    
        Message : AddMessage(text:ToStr())
        Message : StartPop()
        select = coroutine.yield()
        Message : Continue()
        if select == "修正形态" then
            local text = SB:New()
            text:Append(AddButton("▼型   ","CoroutineResume,▼"))
            text:Append(AddButton("⭐型   ","CoroutineResume,⭐"))
            text:Append(AddButton("❤型   ","CoroutineResume,❤"))
        
            Message : AddMessage(text:ToStr())
            Message : StartPop()
            select = coroutine.yield()
            Message : Continue()
        elseif select == "还是算了" then
            return false
        end
    
        return true
    else
        return false
    end
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
        目标 = trainee.阴部,
        sex = self,
        体力减少 = 5,
        行为 = "张开",
        选择 = select,
        次数 = 1,
    }
    return o
end


return t