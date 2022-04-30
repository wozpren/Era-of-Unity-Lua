local t = {}
function t:SexActive(active, Active, Select)
    local base = require("Train/插入")(active, Active, Select)
    local Female = active.被调教者
    local Trainer = active.调教者
    if TrainManager.姿势 == "正常位" then
        if TrainManager.正面 then
            base.露出 = base.露出 + 1000
            base.情爱 = base.情爱 + 500
        else
            base.露出 = base.露出 + 1000
            base.情爱 = base.情爱 + 350
        end
    elseif Active == "乘骑位" then
        if TrainManager.正面 then
            base.露出 = base.露出 + 900
            base.情爱 = base.情爱 + 500
        else
            base.露出 = base.露出 + 700
            base.情爱 = base.情爱 + 700
        end
    elseif Active == "抱座位" then
        if TrainManager.正面 then
            base.露出 = base.露出 + 1300
            base.情爱 = base.情爱 + 1000
        else
            base.露出 = base.露出 + 1500
            base.情爱 = base.情爱 + 300
        end
    elseif Active == "火车便当位" then
        if TrainManager.正面 then
            base.露出 = base.露出 + 1200
            base.情爱 = base.情爱 + 500
        else
            base.露出 = base.露出 + 1500
            base.情爱 = base.情爱 + 500
        end
    elseif Active == "站立位" then
        if TrainManager.正面 then
            base.露出 = base.露出 + 1000
            base.情爱 = base.情爱 + 1500
        else
            base.露出 = base.露出 + 1200
            base.情爱 = base.情爱 + 500
        end
    end


    
    if Female.尿道.扩张度 > Trainer.阴部.大小 then
        base.尿道快感 = Female:计算刺激度("尿道", 2, 30)
        base.尿道快感 = TrainManager:EXABL(Trainer: GetAbility("性交中毒"), base.尿道快感)
    end
    if Select == "膀胱口" then
        local ta = active.被调教者.尿道.感觉

        if ta <= 2 then
            base.屈从 = base.屈从 + 100
            base.疼痛 = base.疼痛 + 3000
        elseif ta <= 4 then
            base.屈从 = base.屈从 + 200
            base.疼痛 = base.疼痛 + 1500
        elseif ta <= 6 then
            base.屈从 = base.屈从 + 500
            base.疼痛 = base.疼痛 + 500
        else
            base.屈从 = base.屈从 + 100 * ta
        end
        if active.目标.扩张度 < active.执行.大小 then
            base.尿道快感 = Female:计算刺激度("尿道", 2, 30)
            base.尿道快感 = TrainManager:EXABL(Female:获取能力("性交中毒"), base.尿道快感)
        end
        TrainManager:获得经验("尿道经验", 2)
        TrainManager:获得经验("膀胱口经验", 1)
        if active.执行.Name == "阴茎" then
            TrainManager:获得经验("膀胱口插入经验", 1, active.调教者)
        end
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
            TrainManager:获得经验("膀胱口经验", 1)
            v = v + active.执行.大小 - active.目标.扩张度
        end
    end

    TrainManager:获得经验("尿道经验",v)
    TrainManager:获得经验("尿道调教经验", 2, Trainer)
    TrainManager:获得经验("尿道性交经验", 1)
    TrainManager:获得经验("尿道插入经验", vc, Trainer)
    --尿道扩张(Female, Trainer.Stature.JJDiam)
    return base
end

function t:TrainMessage(active)
    local text = SB:New()
    text:Append("@player@将肉棒插入@target@的尿道中。")
    UIManager:GetUI("TrainView"):Append(text:ToStr(), active)
end

function t:SexType(type)
    if type == "尿道性交" or type == "异常"  then
        return true
    elseif type == "性交" then
        return true
    end
    return false
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
        value = TrainManager:OrderRequire(Female, value, text, "talent", "尿道性向", 10)
        
        if require("Data/参数"):获取经验等级(Female : 获取经验("尿道调教经验")) < 2 then
            value = value - 5
            text:Append("尿道经验不足:(-5)")
        end
        value = TrainManager:OrderRequire(Female, value, text, "equip", "媚药", 3)


        return TrainManager:ShowOrder(value, text, 50), Select
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
        目标 = trainee.尿道,
        sex = self,
        体力减少 = 30,
        行为 = "插入尿道",
        选择 = select,
        次数 = 1,
    }
    TrainManager:添加占用(o)
    return o
end

return t