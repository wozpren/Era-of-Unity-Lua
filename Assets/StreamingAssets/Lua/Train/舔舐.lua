local t = {}
---@param active ActiveMsg
function t:SexActive(active, Active, Select)
    local base = require("Data/ActionPack"):New()
    local JS = active.执行.技巧
    local LCP = active.被调教者:获取能力("露出癖")
    local Female = active.被调教者
    base.液体追加 = 200
    base.逃脱 = 200
    base.露出 = 500
    base.情爱 = 200

    TrainManager:获得经验("舔舐经验", 1, active.调教者)

    if Select == "胸部" then
        base.胸部快感 = Female:计算刺激度("胸部", 1)
        base.胸部快感 = TrainManager:EXABL(JS, base.胸部快感)
        base.不洁 =  200
        base.情爱 = base.情爱 + Female.胸部.感觉 * 100


        if Female:检查特性("胸部性向") then
            TrainManager:性癖增益(base, base.胸部快感)
        end


        local b = Female : 获取外层装备("身体")
        if b ~= nil then
            if b.厚度 <= 1 then
                base.胸部快感 = base.胸部快感 * 0.8
                base.露出 = base.露出 * 0.7
            else
                base.胸部快感 = base.胸部快感 * 0.6
                base.露出 = base.露出 * 0.4
            end
        end
    elseif Select == "小穴" then
        base.阴部快感 = Female:计算刺激度("阴部", 1)
        base.阴部快感 = TrainManager:EXABL(JS, base.阴部快感)
        base.小穴快感 = Female:计算刺激度("小穴", 1)
        base.小穴快感 = TrainManager:EXABL(JS, base.小穴快感)
        base.不洁 =  200

        base.小穴快感 = base.小穴快感 * 0.6
        base.阴部快感 = base.阴部快感 * 0.6

        if LCP >= 1 and LCP <= 5 then
            base.露出 = base.露出 + LCP * 200
        elseif LCP <= 10 then
            base.露出 = base.露出 + (LCP - 5) * 100 + 1000
        elseif LCP > 10 then
            base.露出 = base.露出 + (LCP - 10) * 50 + 1500
        end

        TrainManager:获得经验("阴部经验", 1)
        TrainManager:获得经验("小穴经验", 1)

        if Female:检查特性("阴部性向") then
            TrainManager:性癖增益(base, base.阴部快感)
        end
        local b = Female : 获取外层装备("胯部")
        if b ~= nil then
            if b.厚度 > 1 then
                base.阴部快感 = base.阴部快感 * 0.6
                base.小穴快感 = base.小穴快感 * 0.6
                base.露出 = base.露出 * 0.4
            else
                base.阴部快感 = base.阴部快感 * 0.8
                base.小穴快感 = base.小穴快感 * 0.8
                base.露出 = base.露出 * 0.6
            end
        end
    elseif Select == "肛门" then
        base.菊穴快感 = Female:计算刺激度("菊穴", 1)
        base.菊穴快感 = TrainManager:EXABL(JS, base.菊穴快感)
        base.不洁 = 1000
        base.逃脱 = base.逃脱 + 500
        local Aexp = Female : 获取经验("菊穴经验")
        if Aexp >= 500 then
            base.菊穴快感 = base.菊穴快感 * 1.6
            base.疼痛 = base.疼痛 * 0.5
            base.恐惧 = base.恐惧 * 0.2
            base.逃脱 = base.逃脱 * 0.2
        elseif Aexp >= 250 then
            base.菊穴快感 = base.菊穴快感 * 1.4
            base.疼痛 = base.疼痛 * 0.6
            base.恐惧 = base.恐惧 * 0.4
            base.逃脱 = base.逃脱 * 0.6
        elseif Aexp >= 100 then
            base.菊穴快感 = base.菊穴快感 * 1.2
            base.疼痛 = base.疼痛 * 0.9
            base.恐惧 = base.恐惧 * 0.7
            base.逃脱 = base.逃脱 * 0.8
        elseif Aexp >= 50 then

        elseif Aexp >= 10 then
            base.菊穴快感 = base.菊穴快感 * 0.5
            base.疼痛 = base.疼痛 * 1.5
            base.恐惧 = base.恐惧 * 1.5
            base.逃脱 = base.逃脱 * 1.5
        else
            base.菊穴快感 = base.菊穴快感 * 0.1
            base.疼痛 = base.疼痛 * 2
            base.恐惧 = base.恐惧 * 2
            base.逃脱 = base.逃脱 * 2
        end
        local id = TrainManager:查找ID(Female)
 
        local YQ = require("Data/参数"):GetPalamLV(TrainManager.FeelPack[id].欲情)
        if YQ < 1 then
            base.屈从 = base.屈从 * 0.3
        elseif YQ < 2 then
            base.屈从 = base.屈从 * 0.5
        elseif YQ < 3 then
            base.屈从 = base.屈从 * 0.8
        elseif YQ < 4 then
        elseif YQ >= 4 then
            base.屈从 = base.屈从 * 1.2
        end
        if Female:检查特性("菊穴性向") then
            TrainManager:性癖增益(base, base.菊穴快感)
        end
        TrainManager:获得经验("菊穴经验", 1)

    elseif Select == "脚部" then
        base.不洁 = 100
        base.逃脱 = 100
        local sn = Train.GetAbility("施虐属性")
        if sn == 1 then
            base.情爱 = base.情爱 + 300
        elseif sn == 2 then
            base.情爱 = base.情爱 + 500
        elseif sn == 3 then
            base.情爱 = base.情爱 + 1000
        elseif sn == 4 then
            base.情爱 = base.情爱 + 1500
        elseif sn == 4 then
            base.情爱 = base.情爱 + 2000
        end



    elseif Select == "阴部" then
        base.阴部快感 = Female:计算刺激度("阴部", 1)
        base.阴部快感 = TrainManager:EXABL(JS, base.阴部快感)
        base.不洁 = 200
        base.恐惧 = 100
        local SC = Train.GetAbility("顺从")
        if SC < 1 then
            base.逃脱 = base.逃脱 * 2
            base.恐惧 = base.恐惧 * 2
            base.屈从 = base.屈从 * 0.2
        elseif SC < 2 then
        elseif SC < 3 then
        elseif SC < 4 then
            base.逃脱 = base.逃脱 * 0.6
            base.恐惧 = base.恐惧 * 0.6
            base.屈从 = base.屈从 * 0.2
        elseif SC < 5 then
            base.逃脱 = base.逃脱 * 0.4
            base.恐惧 = base.恐惧 * 0.4
            base.屈从 = base.屈从 * 1.6
        elseif SC >= 5 then
            base.逃脱 = base.逃脱 * 0.2
            base.恐惧 = base.恐惧 * 0.2
            base.屈从 = base.屈从 * 2
        end
    end
    if active.目标.Name == "阴茎" then
        local jy = (500 * active.执行.技巧) + (active.调教者:获取能力("精液中毒") * 100) + 100
        if active.调教者:检查特性("荡唇") then
            jy = jy * 1.5
        end

        Female:精液(jy)
        TrainManager:获得经验("口交经验", 1, active.调教者)
    end

    return base
end

function t:TrainMessage(active)
    local text = SB:New()
    text:Append("@player@舔舐着@target@的"..active.选择)
    UIManager:GetUI("TrainView"):Append(text:ToStr(), active)
end

function t:SexType(type)
    if type == "舔舐" or type == "羞耻快乐" then
        return true
    elseif type == "爱抚" then
        return true
    end
    return false
end



function t:Check(Trainee, Female, Select)
    Message:AddMessage("舔舐")
    local text = SB:New()
    text:Append("要舔舐哪里\n")
    text:Append(AddButtonL("胸部","CoroutineResume,胸部"))
    text:Append(AddButtonL("小穴","CoroutineResume,小穴"))
    if Female.Name == "阴茎" then
        text:Append(AddButtonL("肉棒","CoroutineResume,阴部"))
    else
        text:Append(AddButtonL("阴蒂","CoroutineResume,阴部"))
    end
    text:Append(AddButtonL("脚部","CoroutineResume,脚部"))
    
    Message : AddMessage(text:ToStr())
    Message : StartPop()
    local Select = coroutine.yield()
    Message : Continue()
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
        执行 = trainer.嘴部,
        目标 = trainee[select],
        sex = self,
        体力减少 = 10,
        行为 = "舔舐",
        选择 = select,
        次数 = 1,
    }

    return o
end

return t