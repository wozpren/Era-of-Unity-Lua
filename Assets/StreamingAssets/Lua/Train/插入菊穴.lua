local t = {}
function t:SexActive(active, Active, Select)
    local base = require("Train/插入")(active, Active, Select)
    local AFeel = active.被调教者.菊穴.感觉
    local jy = active.被调教者.菊穴.技巧 * 100
    local n =  active.目标.扩张度 - active.执行.大小
    if n >= 3 then
        jy = jy * 0.1
    elseif n == 2 then
        jy = jy * 0.3
    elseif n == 1 then
        jy = jy * 0.7
    end

    if active.被调教者:检查特性("菊穴性向", "菊穴") then
        AFeel = AFeel + 2
    end
    if active.被调教者:检查特性("尻穴狂", "菊穴") then
        AFeel = AFeel + 3
    end

    if TrainManager.姿势 == "正常位" then
        if TrainManager.正面 then
            base.露出 = base.露出 + 1000
            base.情爱 = base.情爱 + 500


            jy = jy + active.被调教者:获取能力("顺从") * 100
        else
            base.露出 = base.露出 + 2000
            base.情爱 = base.情爱 + 350

            jy = jy + active.被调教者 : 获取能力("受虐属性") * 100
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
            base.露出 = base.露出 + 1300
            base.情爱 = base.情爱 + 1000
        else
            base.露出 = base.露出 + 1500
            base.情爱 = base.情爱 + 300
        end
    elseif TrainManager.姿势 == "火车便当位" then
        if TrainManager.正面 then
            base.露出 = base.露出 + 1200
            base.情爱 = base.情爱 + 500
        else
            base.露出 = base.露出 + 1500
            base.情爱 = base.情爱 + 500
        end
    elseif TrainManager.姿势 == "站立位" then
        if TrainManager.正面 then
            base.露出 = base.露出 + 1000
            base.情爱 = base.情爱 + 1500
        else
            base.露出 = base.露出 + 1200
            base.情爱 = base.情爱 + 500
        end
    end
    if Select == "乙状结肠" then
        local ta = AFeel

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
            base.菊穴快感 = Female:计算刺激度("菊穴", 2, 30)
            base.菊穴快感 = TrainManager:EXABL(Female:获取能力("性交中毒"), base.菊穴快感)
        end
        TrainManager:获得经验("菊穴经验", 2)
        TrainManager:获得经验("结肠经验", 1)
        if active.执行.Name == "阴茎" then
            TrainManager:获得经验("结肠插入经验", 1, active.调教者)
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
            TrainManager:获得经验("结肠经验", 1)
            v = v + active.执行.大小 - active.目标.扩张度
        end
    end

    TrainManager:扩张("菊穴", active.执行, active.被调教者)

    TrainManager:获得经验("菊穴经验", v)
    TrainManager:获得经验("菊穴性交经验", 1)
    TrainManager:获得经验("菊穴插入经验", vc, active.调教者)

    return base
end

function t:TrainMessage(active)
    local text = SB:New()
    text:Append("@player@将肉棒插入@target@的菊穴中。")
    UIManager:GetUI("TrainView"):Append(text:ToStr(), active)
end

function t:SexType(type)
    if type == "肛门性交" then
        return true
    elseif type == "性交" then
        return true
    elseif TrainManager.姿势 == "乘骑位" and type == "侍奉快乐"  then
        return true
    end
    return false
end


function t:Check(Trainee, Female, Select)
    if TrainManager.姿势 == "乘骑位" then
        local value, text = TrainManager:AllowAction()
        local n = Female:获取能力("侍奉技术")
        value = TrainManager:OrderRequire(Female, value, text, "abl", "侍奉技术", n * 2)

        local n = Female:获取能力("性交中毒")
        value = TrainManager:OrderRequire(Female, value, text, "abl", "性交中毒", n * 3)

        value = TrainManager:OrderRequire(Female, value, text, "talent", "强硬", 10)
        value = TrainManager:OrderRequire(Female, value, text, "talent", "害羞", -10)
        value = TrainManager:OrderRequire(Female, value, text, "talent", "献身", 6)
        value = TrainManager:OrderRequire(Female, value, text, "talent", "否定快感", -1)
        value = TrainManager:OrderRequire(Female, value, text, "talent", "菊穴性向", 10)
        
        if Female:检查特性("处女", "菊穴") then
            value = value - 20
            text:Append("菊穴处女:(-20)")
        elseif require("Data/参数"):获取经验等级(Female : 获取经验("菊穴经验")) < 2 then
            value = value - 5
            text:Append("菊穴经验不足:(-5)")
        end
        value = TrainManager:OrderRequire(Female, value, text, "equip", "媚药", 6)


        return Train.ShowOrder(value, text, 30), Select
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
        执行 = trainee.阴部,
        目标 = trainer.菊穴,
        sex = self,
        体力减少 = 20,
        行为 = "插入菊穴",
        选择 = select,
        次数 = 1,
    }
    TrainManager:添加占用(o)
    return o
end
return t