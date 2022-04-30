local t = {}
function t:SexActive(active, Active, Select)
    local base = TrainManager:ServicePlay(active)
    local Female = active.调教者


    base.欲情追加 = base.欲情追加 + TrainManager:AddLust(active)
    base.屈从 = base.屈从 + 1200
    base.逃脱 = base.逃脱 + 50


    if Select ~= "展示肉棒" then
        base = require("Train/侍奉")
        base.不洁 = base.不洁 + 500
        base.阴部快感 = Female:计算刺激度("阴部")
        
        local SR = GetPalamLV(trainData.Source : get_Item("润滑"))
        if SR < 1 then
            base.阴部快感 = base.阴部快感 * 0.1
            base.性行动 = base.性行动 * 0.6
        elseif SR < 2 then
            base.阴部快感 = base.阴部快感 * 0.3
            base.性行动 = base.性行动 * 0.8
        elseif SR < 3 then
            base.阴部快感 = base.阴部快感 * 0.5
        elseif SR < 4 then
            base.性行动 = base.性行动 * 1.2
        elseif SR < 5 then
            base.阴部快感 = base.阴部快感 * 0.9
            base.性行动 = base.性行动 * 1.4
        else
            base.阴部快感 = base.阴部快感 * 0.8
            base.性行动 = base.性行动 * 1.6
        end

        local b = Female : 获取装备厚度("胯部")
        if b > 0 then
            local l = math.max(5 - b, 0)
            base.阴部快感 = base.阴部快感 * l * 0.2 + 0.1
            base.露出 = base.露出 * l * 0.2 + 0.1
        end
    end

    local samen = TrainManager:精液处理(active.调教者, active.被调教者, 100, "素股")
    active.调教者:精液(samen)

    return base
end

function t:TrainMessage(active)
    local text = SB:New()
    text:Append("素股")
    UIManager:GetUI("TrainView"):Append(text:ToStr(), active)
end

function t:SexType(type)
    if type == "侍奉快乐" then
        return true
    elseif type == "侍奉" then
        return true
    end
    return false
end

function t:Check(Trainer, Female, Select)
    Message:AddMessage("口交")
    return true,Select
end

---@return ActiveMsg
function t:GetActive(trainer, trainee, select)
    
    ---@class ActiveMsg
    local o = 
    {
        ---@type Character
        调教者 = trainer,
        ---@type Character
        被调教者 = trainee,
        执行 = trainer.阴部,
        目标 = trainee.小穴,
        sex = self,
        体力减少 = 5,
        行为 = "素股",
        选择 = select,
        次数 = 1,
    }

    return o
end

return t