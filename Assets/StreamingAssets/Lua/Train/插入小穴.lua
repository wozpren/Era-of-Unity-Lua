local t = {}

local Data = require("Data/参数")

function t:SexActive(active, Active, Select)
    local base = require("Train/插入")(active, Active, Select)
    local Female = active.被调教者
    local jy = active.被调教者.小穴.技巧 * 100
    local n =  active.目标.扩张度 - active.执行.大小
    if n >= 3 then
        jy = jy * 0.1
    elseif n == 2 then
        jy = jy * 0.3
    elseif n == 1 then
        jy = jy * 0.7
    end
    
    if TrainManager.姿势 == "正常位" then
        if TrainManager.正面 then
            base.露出 = base.露出 + 200
            base.情爱 = base.情爱 + 500

            if active.目标.扩张度 < active.执行.大小 then
                base.阴部快感 = base.阴部快感 + Female:计算刺激度("阴部", 2, 300)
                base.阴部快感 = TrainManager:EXABL(active.被调教者 : 获取能力("性交中毒"), base.阴部快感)
            end
            jy = jy + active.被调教者:获取能力("顺从") * 100

        else
            base.露出 = base.露出 + 1000
            base.情爱 = base.情爱 + 350

            if Select == "G点" then
                for index, value in ipairs(base) do
                    value = value * 1.4
                end
            end

            jy = jy + active.被调教者:获取能力("受虐属性") * 100
        end
    elseif TrainManager.姿势 == "乘骑位" then
        if TrainManager.正面 then
            base.露出 = base.露出 + 900
            base.情爱 = base.情爱 + 500
        else
            base.露出 = base.露出 + 700
            base.情爱 = base.情爱 + 700
        end
        jy = jy + Female:获取能力("性交中毒") * 100
    elseif TrainManager.姿势 == "抱座位" then
        if TrainManager.正面 then
            base.露出 = base.露出 + 1000
            base.情爱 = base.情爱 + 300
            if Select == "子宫口" then
                for index, value in ipairs(base) do
                    value = value * 1.5
                end
            end
        else
            base.露出 = base.露出 + 500
            base.情爱 = base.情爱 + 500
        end
    elseif TrainManager.姿势 == "站立位" then
        if TrainManager.正面 then
            base.露出 = base.露出 + 700
            base.情爱 = base.情爱 + 500
        else
            base.露出 = base.露出 + 1000
            base.情爱 = base.情爱 + 300
        end
    end
    local VFeel = Female.小穴.感觉
    if Select == "子宫" then
        local temp = VFeel + Data:获取经验等级(Female : 获取经验("子宫口经验"))
        if Female:检查特性("子宮性感") then
            temp = temp + 2
        end
        TrainManager:获得经验("子宫口经验", 2)
        TrainManager:获得经验("子宫奸经验", 1)
        if active.执行.Name == "阴茎" then
            TrainManager:获得经验("子宫插入经验", 1, active.调教者)
        end
    elseif Select == "G点" then
        base.露出 = base.露出 + 400
        base.屈从 = base.屈从 + VFeel * 400
    elseif Select == "子宫口" then
        local t = VFeel
        if Female:检查特性("子宮性感") then
            t = t + 3
        end

        if active.目标.扩张度 < active.执行.大小 then
            base.阴部快感 = Female:计算刺激度("阴部", 2, 30)
            base.阴部快感 = TrainManager:EXABL(Female:获取能力("性交中毒"), base.阴部快感)
        end
        TrainManager:获得经验("小穴经验", 2)
        TrainManager:获得经验("子宫口经验", 1)
        if active.执行.Name == "阴茎" then
            TrainManager:获得经验("子宫口插入经验", 1, active.调教者)
        end
    end

    local temp1 = Female:获取能力("欲望")
    if temp1 <= 5 then
        base.屈从 = base.屈从 * (temp1 * 0.1 + 0.05)
    elseif temp1 <= 10 then
        base.屈从 = base.屈从 * ((temp1 - 5) * 0.05 + 0.55)
    else
        base.屈从 = base.屈从 * ((temp1 - 10) * 0.02 + 0.8)
    end

    local YQ = TrainManager:获取人物状态("欲情")
    if YQ < 100 then
        base.情爱 = base.情爱 * 0.3
    elseif YQ < 500 then
        base.情爱 = base.情爱 * 0.6
    elseif YQ < 3000 then
        base.情爱 = base.情爱 * 1
    elseif YQ < 10000 then
        base.情爱 = base.情爱 * 1.5
    elseif YQ >= 10000 then
        base.情爱 = base.情爱 * 1.8
    end

    local v = 1
    local vc = 0
    if active.执行.Name == "阴茎" then
        vc = 1
        if active.执行.大小 >= 2 then
            v = 2
            vc = 2
        end

        if active.执行.大小 >= math.max(active.目标.扩张度 + 1, 2) then
            TrainManager:获得经验("子宫口经验", 1)
            v = v + active.执行.大小 - active.目标.扩张度
        end
    end
    TrainManager:扩张("小穴", active.执行, active.被调教者)

    active.调教者:精液(jy)
    TrainManager:获得经验("小穴经验", v)
    TrainManager:获得经验("小穴性交经验", 1)
    TrainManager:获得经验("小穴插入经验", vc, active.调教者)

    return base
end

function t:SexType(type)
    if type == "小穴性交" then
        return true
    elseif type == "性交" then
        return true
    elseif TrainManager.姿势 == "乘骑位" and type == "侍奉快乐"  then
        return true
    end
    return false
end

function t:TrainMessage(active)
    local text = SB:New()
    text:Append("@player@将肉棒插入@target@的小穴中。")
    UIManager:GetUI("TrainView"):Append(text:ToStr(), active)
end

function t:Check(Trainer, Female, Select)

    if TrainManager.姿势 == "乘骑位" then
        local value, text = TrainManager:AllowAction(Trainer, Female)
        local n = Female:获取能力("侍奉技术")
        value = TrainManager:OrderRequire(Female, value, text, "abl", "侍奉技术", n * 2)

        local n = Female:获取能力("性交中毒")
        value = TrainManager:OrderRequire(Female, value, text, "abl", "性交中毒", n * 3)

        value = TrainManager:OrderRequire(Female, value, text, "talent", "强硬", 10)
        value = TrainManager:OrderRequire(Female, value, text, "talent", "害羞", -10)
        value = TrainManager:OrderRequire(Female, value, text, "talent", "献身", 6)
        value = TrainManager:OrderRequire(Female, value, text, "talent", "否定快感", -1)
        value = TrainManager:OrderRequire(Female, value, text, "talent", "小穴性向", 10)
        
        if Female:检查特性("处女", "小穴") then
            value = value - 20
            text:Append("处女:(-20)")
        elseif require("Data/参数"):获取经验等级(Female : 获取经验("小穴经验")) < 2 then
            value = value - 5
            text:Append("小穴经验不足:(-5)")
        end
        value = TrainManager:OrderRequire(Female, value, text, "equip", "媚药", 6)


        return TrainManager:ShowOrder(value, text, 24), Select
    else
        return true, Select
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
        执行 = trainer.阴部,
        目标 = trainee.小穴,
        sex = self,
        体力减少 = 15,
        行为 = "插入小穴",
        选择 = select,
        次数 = 1,
    }
    return o
end

return t