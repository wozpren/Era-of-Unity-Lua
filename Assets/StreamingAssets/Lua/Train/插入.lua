local function InsertAcitve(active, Active, Select)
    local base = require("Data/ActionPack"):New()
    local data = require("Data/参数")
    ---@type Character
    local Female = active.被调教者
    ---@type Character
    local Trainer = active.调教者
    
    local VFeel = Female.小穴.感觉
    local TTech = active.执行.技巧
    
    local id = TrainManager:查找ID(Female)
    
    if Active == "插入小穴" then
        if Select == "小穴" then
            base.不洁 = 500
            base.小穴快感 = Female:计算刺激度("小穴", 2)
            base.小穴快感 = TrainManager:EXABL(TTech, base.小穴快感)
        elseif Select == "子宫口" then
            base.不洁 = 1500
            base.小穴快感 = Female:计算刺激度("小穴", 2)
            base.小穴快感 = TrainManager:EXABL(TTech, base.小穴快感)
            if Female:检查特性("子宫性感") then
                base.小穴快感 = base.小穴快感 * 1.25
            else
                base.小穴快感 = base.小穴快感 * 0.25
                base.恐惧 =  base.恐惧 + 500
            end
        elseif Select == "子宫" then
            base.不洁 = 2500
            base.小穴快感 = Female:计算刺激度("小穴", 2)
            base.小穴快感 = TrainManager:EXABL(TTech, base.小穴快感)
            if Female:检查特性("子宫性感") then
                base.小穴快感 = base.小穴快感 * 1.25
            else
                base.小穴快感 = base.小穴快感 * 0.25
                base.恐惧 =  base.恐惧 + 1000
            end
        end
    elseif Active == "插入菊穴" then
        base.不洁 = 2000
        base.屈从 = 2000
        base.逃脱 = 3000
        base.菊穴快感 = Female:计算刺激度("菊穴", 2)
        base.菊穴快感 = TrainManager:EXABL(TTech, base.菊穴快感)
    elseif Active == "插入尿道" then
        base.不洁 = 1000
        base.屈从 = 10000
        base.逃脱 = 1000 + active.执行.大小 * 5000
        base.疼痛 = 500
        base.恐惧 = 500
        base.尿道快感 = Female:计算刺激度("尿道", 2)
        base.尿道快感 = TrainManager:EXABL(TTech, base.尿道快感)
    elseif Active == "指插入" then
        if Select == nil or Select == "G点" then
            base.不洁 = 150
            base.露出 = 300
            base.屈从 = 200 + VFeel * 200
            base.小穴快感 = Female:计算刺激度("小穴", 1)
            if Select == "G点" then
                if VFeel >= 3 then
                    base.小穴快感 = base.小穴快感 + 500
                end
                base.不洁 = base.不洁 + 100
                base.逃脱 = base.逃脱 + 500
            end
            base.小穴快感 = TrainManager:EXABL(TTech, base.小穴快感)
    
        elseif Select == "菊穴" then
            base.不洁 = 500
            base.露出 = 500
            base.屈从 = 500
            base.逃脱 = 800
            base.菊穴快感 = Female:计算刺激度("菊穴", 1)
            base.菊穴快感 = TrainManager:EXABL(TTech, base.菊穴快感)
        elseif Select == "尿道" then
            base.不洁 = 1000
            base.露出 = 300
            base.屈从 = 3000
            base.逃脱 = 1000
            base.疼痛 = 500
            base.恐惧 = 100
            base.尿道快感 = Female:计算刺激度("尿道", 1)
            base.尿道快感 = TrainManager:EXABL(TTech, base.尿道快感)
        end
    elseif Active == "振动棒" then
        base.逃脱 = 500
    elseif Active == "拳交" then
        if Select == "小穴" then
            base.不洁 = base.不洁 + 1000
            base.露出 = base.露出 + 1200
            base.屈从 = base.屈从 + 2000
            base.逃脱 = base.逃脱 + 10000
            base.小穴快感 = base.小穴快感 + Female:计算刺激度("小穴", 3)
            base.小穴快感 = TrainManager:EXABL(TTech, base.小穴快感)
        elseif Select == "菊穴" then
            base.不洁 = base.不洁 + 2000
            base.露出 = base.露出 + 1200
            base.屈从 = base.屈从 + 2000
            base.逃脱 = base.逃脱 + 20000
            base.小穴快感 = base.小穴快感 + Female:计算刺激度("菊穴", 3)
            base.小穴快感 = TrainManager:EXABL(TTech, base.菊穴快感)
        end
    elseif Active == "探针" then
        base.屈从 = base.屈从 + 5000
        base.露出 = base.露出 + 2000
        base.逃脱 = base.逃脱 + 2000
        base.恐惧 = base.恐惧 + 500
    
        base.尿道快感 = Female:计算刺激度("尿道", 0)
    end
    
    
    
    local hard = active.执行.硬度
    local size = active.执行.大小
    if Active == "指插入" then
        size = 1
        hard = 2
    elseif Active == "拳交" then
        size = 5
        hard = 3
    end


    local sized = size - active.目标.扩张度
    
    if Female:检查特性("柔软体质") and sized > 0 then
        sized = sized - 1
    end
    
    sized = math.floor(sized)
    
    if sized <= 0 then
        if sized == -1 then
            base.菊穴快感 = base.菊穴快感 * 1.2
            base.小穴快感 = base.小穴快感 * 1.2
            base.尿道快感 = base.尿道快感 * 1.2
        else
            base.菊穴快感 = base.菊穴快感 * math.max(1.2 + sized * 0.2, 0.5)
            base.小穴快感 = base.小穴快感 * math.max(1.2 + sized * 0.2, 0.5)
            base.尿道快感 = base.尿道快感 * math.max(1.2 + sized * 0.2, 0.5)
        end
    
        base.小穴快感 = base.小穴快感 * (hard * 0.1 + 0.8)
        base.小穴快感 = base.小穴快感 * (size * 0.1 + 0.9)
        base.菊穴快感 = base.菊穴快感 * (hard * 0.1 + 0.8)
        base.菊穴快感 = base.菊穴快感 * (size * 0.1 + 0.9)
        base.尿道快感 = base.尿道快感 * (hard * 0.1 + 0.8)
        base.尿道快感 = base.尿道快感 * (size * 0.1 + 0.9)
    
        if size >= 2 then 
            base.成就感 = base.成就感 + size * size * 500
        end
    else
        active.体力减少 = active.体力减少 + 10 * sized
        base.小穴快感 = base.小穴快感 / math.max(size * 2, 1)
        base.菊穴快感 = base.菊穴快感 / math.max(size * 2, 1)
        base.尿道快感 = base.尿道快感 / math.max(size * 2, 1)
    
    end
    
    base.疼痛 = base.疼痛 + data:获取等级数值(sized + ((hard + 1)/2))
    base.恐惧 = base.恐惧 + data:获取等级数值(sized + ((hard + 1)/2))
    base.逃脱 = base.逃脱 + data:获取等级数值(sized)
    
    local palamRes = 0
    local id = TrainManager:查找ID(Female)
    if Select == "菊穴" then
        palamRes = data:获取等级(TrainManager.FeelPack[id].菊穴润滑) - math.max(sized,0) - 1
    else
        palamRes = data:获取等级(TrainManager.FeelPack[id].小穴润滑) - math.max(sized,0) - 1
    end
    
    
    local exp = 0
    
    if Select == "小穴" or Select == "G点" or Select == "子宫口" then
        local level = Female:获取淫纹等级()
        if level > 0 then
            base.充足 = base.充足 + level * 500
        end
        if Female:检查特性("处女", "小穴") == true then
            TrainManager:添加记录(id, "破处", 1)
            Female:设置特性("处女", false, "小穴")
            base.疼痛 = base.疼痛 + 1000
            base.逃脱 = base.逃脱 + 500
        end
        if 检查特性(Female["小穴"], "淫壶") or level >= 4 then
            base.疼痛 = base.疼痛 / 3
            base.恐惧 = base.恐惧 / 3
            base.逃脱 = base.逃脱 / 3
        elseif level > 0 then
            base.疼痛 = base.疼痛 / (1 - level * 0.15)
            base.恐惧 = base.恐惧 / (1 - level * 0.15)
            base.逃脱 = base.逃脱 / (1 - level * 0.15)
        end
    
        exp = math.min(data:获取经验等级(Female : 获取经验("小穴经验")) - size - 1 - math.max(sized, 0), 5 - hard)
    
    elseif Select == "子宫" then
        local level = Female:获取淫纹等级()
        if level > 0 then
            base.充足 = base.充足 + level * 1000
        end
        local ZGLV = data:获取经验等级(Female.获取经验("子宫经验"))
        if ZGLV <= 1 then
            base.小穴快感 = base.小穴快感 * 0.2
            base.疼痛 = base.疼痛 + 10000
            base.恐惧 = base.恐惧 + 3000
            base.逃脱 = base.逃脱 + 30000
        elseif ZGLV <= 2 then
            base.小穴快感 = base.小穴快感 * 0.4
            base.疼痛 = base.疼痛 + 5000
            base.恐惧 = base.恐惧 + 1000
            base.逃脱 = base.逃脱 + 6000
        else
            base.小穴快感 = base.小穴快感 * 0.7
            base.疼痛 = base.疼痛 + 2000
            base.恐惧 = base.恐惧 + 1000
            base.逃脱 = base.逃脱 + 2000
        end
        if 检查特性(Female["小穴"], "淫壶") or level then
            base.疼痛 = base.疼痛 / 3 
            base.恐惧 = base.恐惧 / 3 
            base.逃脱 = base.逃脱 / 3
        elseif level >= 1 then
            base.疼痛 = base.疼痛 * 1 - (level * 0.15)
            base.恐惧 = base.恐惧 * 1 - (level * 0.15)
            base.逃脱 = base.逃脱 * 1 - (level * 0.15)
        end
        palamRes = data:获取等级(TrainManager.FeelPack[id].小穴润滑) - math.max(sized, 0) - 1
        exp = math.min(data:获取经验等级(Female : 获取经验("子宫口经验")) - size - 1 - math.max(sized, 0), 5 - hard)
    
    
    elseif Select == "菊穴" or Select == "乙状结肠" then
        if Select == "乙状结肠" then
            local JCexp = data:获取经验等级(Female : 获取经验("结肠经验"))
            if JCexp <= 0 then 
                base.小穴快感 = base.小穴快感 * 0.2
                base.屈从 = base.屈从 + 500
                base.疼痛 = base.疼痛 + 1000
                base.恐惧 = base.恐惧 + 10000
                base.逃脱 = base.逃脱 + 10000
            elseif JCexp <= 1 then
                base.小穴快感 = base.小穴快感 * 0.5
                base.屈从 = base.屈从 + 1000
                base.疼痛 = base.疼痛 + 500
                base.恐惧 = base.恐惧 + 3000
                base.逃脱 = base.逃脱 + 3000
            elseif JCexp <= 2 then
                base.小穴快感 = base.小穴快感 * 1.2
                base.屈从 = base.屈从 + 2000
                base.疼痛 = base.疼痛 + 100
                base.恐惧 = base.恐惧 + 500
                base.逃脱 = base.逃脱 + 1000
            elseif JCexp <= 3 then
                base.小穴快感 = base.小穴快感 * 1.5
                base.屈从 = base.屈从 + 3000
            end
        end
    
        if 检查特性(Female.菊穴,"尻穴狂") then
            base.疼痛 = base.疼痛 / 3
            base.恐惧 = base.恐惧 / 3
            base.逃脱 = base.逃脱 / 3
        end
        local id = TrainManager:查找ID(Female)
        if Active == "插入菊穴" then
            palamRes =data:获取等级(TrainManager.FeelPack[id].菊穴润滑) - math.max(sized,0) - 1
        else
            palamRes = math.min(data:获取等级数值(TrainManager.FeelPack[id].菊穴润滑) - math.max(sized,0), 3)
        end
    
        exp = math.min(data:获取经验等级(Female : 获取经验("菊穴经验")) - size - 1 - math.max(sized, 0), 5 - hard)
    
    elseif Select == "尿道" or Active == "探针" then
        if Active == "插入尿道" then
            base.恐惧 = base.恐惧 + 5000 
            base.逃脱 = base.逃脱 + 20000
    
        end
        palamRes = 3
    
        if Female:检查特性("尿道狂") then
            base.恐惧 = base.恐惧 * 0.1 
            base.逃脱 = base.逃脱 * 0.1 
            base.疼痛 = base.疼痛 * 0.05
        elseif Female:检查特性("尿道性感") then
            base.恐惧 = base.恐惧 * 0.2
            base.逃脱 = base.逃脱 * 0.2 
            base.疼痛 = base.疼痛 * 0.2
        end
    
        exp = math.min(data:获取经验等级(Female : 获取经验("尿道经验")) - size - 1 - math.max(sized, 0), 5 - hard)
    end
    
    
    local i = Female:获取能力("肉棒成瘾")
    if Active == "指插入" then
        if TTech == 1 then
            base.疼痛 = base.疼痛
            * 0.8
        elseif TTech == 2 then
            base.疼痛 = base.疼痛 * 0.5
        elseif TTech >= 3 then
            base.疼痛 = math.min(base.疼痛 / 5 , 500)
        end
    elseif Active == "插入小穴" then
        if i > 0 and Trainer.阴部.Name == "阴茎" and Female.小穴["扩张度"]>= size then
            base.屈从 = base.屈从 + base.恐惧 * i
            base.疼痛 = base.疼痛 / i + 1
            base.恐惧 = base.恐惧 / i + 1
        end
    elseif Active == "插入菊穴" then
        if i > 0 and Trainer.阴部.Name == "阴茎" and Female.菊穴["扩张度"] >= size then
            base.屈从 = base.屈从 + base.恐惧 * i
            base.疼痛 = base.疼痛 / i + 1
            base.恐惧 = base.恐惧 / i + 1
        end
    elseif Active == "插入尿道" then
        if i > 0 and Trainer.阴部.Name == "阴茎" and Female.尿道["扩张度"] >= size then
            base.屈从 = base.屈从 + base.恐惧 * i
            base.疼痛 = base.疼痛 / i + 1
            base.恐惧 = base.恐惧 / i + 1
        end
    end
    
    if exp >= 3 then
        base.疼痛 = base.疼痛 * 0.05
        base.恐惧 = base.恐惧 * 0.05
        base.逃脱 = base.逃脱 * 0.05
    elseif exp == 2 then
        base.疼痛 = base.疼痛 * 0.3
        base.恐惧 = base.恐惧 * 0.3
        base.逃脱 = base.逃脱 * 0.3
    elseif exp == 1 then
        base.疼痛 = base.疼痛 * 0.7
        base.恐惧 = base.恐惧 * 0.7
        base.逃脱 = base.逃脱 * 0.7
    elseif exp == 0 then
        base.恐惧 = base.恐惧 * 0.7
    elseif exp == -1 then
        base.疼痛 = base.疼痛 * 1.5
        base.逃脱 = base.逃脱 * 1.2
    elseif exp == -2 then
        base.疼痛 = base.疼痛 * 2
        base.恐惧 = base.恐惧 * 1.5
        base.逃脱 = base.逃脱 * 2
    else
        base.疼痛 = base.疼痛 * 3
        base.恐惧 = base.恐惧 * 3
        base.逃脱 = base.逃脱 * 3
    end
    if palamRes >= 4 then
        base.疼痛 = base.疼痛 * 0.2
    elseif palamRes ==3 then
        base.疼痛 = base.疼痛 * 0.5
    elseif palamRes ==2 then
        base.疼痛 = base.疼痛 * 0.8
        base.小穴快感 = base.小穴快感 * 0.8
        base.菊穴快感 = base.菊穴快感 * 0.8
    elseif palamRes ==1 then
        base.疼痛 = base.疼痛 + 100
        base.小穴快感 = base.小穴快感 * 0.4
        base.菊穴快感 = base.菊穴快感 * 0.4
    else
        base.疼痛 = base.疼痛 + 500
        base.小穴快感 = base.小穴快感 * 0.1
        base.菊穴快感 = base.菊穴快感 * 0.1
    end
    
    if Active == "插入小穴" then
        base.小穴液体追加 = base.小穴液体追加 + 50 * math.min(5, data:获取等级(base.疼痛))
        if Female:检查特性("小穴性向") then
            TrainManager:性癖增益(base, base.小穴快感)
        end
    elseif Active == "插入菊穴" then
        base.菊穴液体追加 = base.菊穴液体追加 + math.max(data:获取等级(base.疼痛) + size * 100, 100)
        if Female:检查特性("菊穴性向") then
            TrainManager:性癖增益(base, base.菊穴快感)
        end
        if Select == "乙状结肠" then
            base.疼痛 = base.疼痛 + math.max(math.min(data:DownPalamLv(base.疼痛, 1), base.疼痛 - 100), 0)
        end
    elseif Active == "插入尿道" or Active == "探针" or Select == "尿道" then
        if Female:检查特性("尿道狂") then
            TrainManager:性癖增益(base, base.尿道快感)
        end
        if Select == "膀胱口" then
            base.疼痛 = base.疼痛 + math.max(math.min(data:DownPalamLv(base.疼痛, 1), base.疼痛 - 100), 0)
        end
    elseif Active == "指插入" or Active == "拳交" then
        base.小穴液体追加 = base.小穴液体追加 + math.max(data:获取等级(base.疼痛) + size * 100, 100)
        if Select == "菊穴" and Female:检查特性("菊穴性向") then
            TrainManager:性癖增益(base, base.菊穴快感)
        elseif Select == "小穴" and Female:检查特性("小穴性向") then
            TrainManager:性癖增益(base, base.小穴快感)
        end
    end
    
    return base
end

return InsertAcitve