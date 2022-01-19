function InsertAcitve(Active, Select)
local base = ActiveData.new()

local VFeel = Female.小穴.感觉

local TTech = Trainer : GetAbility("技巧")

local YJ = Trainer : GetAbility("性交中毒")


if Active == "插入小穴" then
    if Select == "小穴" then
        base.不洁 = 800
        if Trainer.IsJJ then
            base.小穴快感 = Female:计算刺激度("V刺激", 2)
        else
            base.小穴快感 = Female:计算刺激度("V刺激", 2) * (Factory : GetStuff("假阳具") + 90) / 100
        end
        base.小穴快感 = TrainManager:EXABL(YJ, base.小穴快感)

    elseif Select == "子宫口" then
        base.不洁 = 1500
        base.小穴快感 = Female:计算刺激度("V刺激", 2)
        base.小穴快感 = TrainManager:EXABL(YJ, base.小穴快感)
        if Female:检查特性("子宫性感") then
            base.小穴快感 = base.小穴快感 * 1.25
        else
            base.小穴快感 = base.小穴快感 * 0.25
            base.恐惧 =  base.恐惧 + 500
        end

    elseif Select == "子宫" then
        base.不洁 = 2500
        base.小穴快感 = Female:计算刺激度("V刺激", 2)
        base.小穴快感 = TrainManager:EXABL(YJ, base.小穴快感)
        if Female:检查特性("子宫性感") then
            base.小穴快感 = base.小穴快感 * 1.25
        else
            base.小穴快感 = base.小穴快感 * 0.25
            base.恐惧 =  base.恐惧 + 1000
        end
    end
    Improve.V扩张(Female, Trainer.Stature.JJSize, Trainer.Stature.JJHard)
elseif Active == "插入肛门" then
    base.不洁 = 2000
    base.屈从 = 2000
    base.逃脱 = 3000
    if Trainer.IsJJ then
        base.菊穴快感 = Female:计算刺激度("菊穴", 2)
    else
        base.菊穴快感 = Female:计算刺激度("菊穴", 2) * (Factory : GetStuff("假阳具") + 90) / 100
    end
    base.菊穴快感 = TrainManager:EXABL(YJ, base.菊穴快感)
    Improve.A扩张(Female, Trainer.Stature.JJSize, Trainer.Stature.JJHard)
elseif Active == "插入尿道" then
    base.不洁 = 1000
    base.屈从 = 10000
    base.逃脱 = 1000 + Trainer.Stature.JJSize * 5000
    base.疼痛 = 500
    base.恐惧 = 500
    base.尿道快感 = Female:计算刺激度("尿道刺激", 2)
    base.尿道快感 = TrainManager:EXABL(YJ, base.尿道快感)
    Improve.尿道扩张(Female, Trainer.Stature.JJSize, Trainer.Stature.JJHard)
elseif Active == "指插入" then
    if Select == nil or Select == "G点" then
        base.不洁 = 150
        base.露出 = 300
        base.屈从 = 200 + VFeel * 200
        base.小穴快感 = Female:计算刺激度("Ｖ刺激", 1)
        if Select == "G点" then
            if VFeel >= 3 then
                base.小穴快感 = base.小穴快感 + 500 
            end
            base.不洁 = base.不洁 + 100 
            base.逃脱 = base.逃脱 + 500
        end
        base.小穴快感 = TrainManager:EXABL(TTech, base.小穴快感)

    elseif Select == "肛门" then
        base.不洁 = 500
        base.露出 = 500
        base.屈从 = 500
        base.逃脱 = 1000
        base.菊穴快感 = Female:计算刺激度("菊穴", 1)
        base.菊穴快感 = TrainManager:EXABL(TTech, base.菊穴快感)
    elseif Select == "尿道" then
        base.不洁 = 1000
        base.露出 = 300
        base.屈从 = 3000
        base.逃脱 = 1000
        base.疼痛 = 500
        base.恐惧 = 100
        base.尿道快感 = Female:计算刺激度("尿道刺激", 1)
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
        base.小穴快感 = base.小穴快感 + Female:计算刺激度("V刺激", 3)
        base.小穴快感 = TrainManager:EXABL(GetExpLV(Trainer : 获取经验("手淫经验")), base.小穴快感)
    elseif Select == "肛门" then
        base.不洁 = base.不洁 + 2000
        base.露出 = base.露出 + 1200
        base.屈从 = base.屈从 + 2000
        base.逃脱 = base.逃脱 + 20000
        base.小穴快感 = base.小穴快感 + Female:计算刺激度("菊穴", 3)
        base.小穴快感 = TrainManager:EXABL(GetExpLV(Trainer : 获取经验("手淫经验")), base.菊穴快感)
    end
elseif Active == "探针" then
    base.屈从 = base.屈从 + 5000
    base.露出 = base.露出 + 2000
    base.逃脱 = base.逃脱 + 2000
    base.恐惧 = base.恐惧 + 500

    base.U快乐 = base.U快乐 + Female:计算刺激度("尿道刺激", 0)
end


local sized = 0
local hard = 0
local size = 0
if Active == "插入小穴" then
    size = Trainer.Stature.JJSize
    hard = Trainer.Stature.JJHard
    sized = size - Train.GetAbility("V扩张")
elseif Active == "插入肛门" then
    size = Trainer.Stature.JJSize
    hard = Trainer.Stature.JJHard
    sized = Trainer.Stature.JJSize - Train.GetAbility("A扩张")
elseif Active == "插入尿道" then
    size = Trainer.Stature.JJSize
    hard = Trainer.Stature.JJHard
    sized = Trainer.Stature.JJSize - Train.GetAbility("U扩张")
elseif Active == "指插入" then
    size = 0
    hard = 1
    if Select == "小穴" or Select == "G点" then
        sized = - Train.GetAbility("V扩张")
    elseif Select == "肛门" then
        sized = - Train.GetAbility("A扩张")
    elseif Select == "尿道" then
        sized = - Train.GetAbility("U扩张")
    end
elseif Active == "拳交" then
    size = 5
    hard = 2

    if tostring(Trainer.Sex) then
        size = size - 1
    end
    if Select == "小穴" then
        sized = - Train.GetAbility("V扩张")
    elseif Select == "肛门" then
        sized = - Train.GetAbility("A扩张")
    end
elseif Active == "探针" then
    size = Mathf.Clamp(Select / 7,1,7) 
    local n = size - Female.GetAbility("尿道扩张") / 100
    if n < -1 then
        sized = -2
    elseif n < 1 then
        sized = n
    else
        sized = 1 + n / 2
    end
    sized = math.floor(sized + 0.5)
end

if Female:检查特性("柔软体质") and sized > 0 then
    sized = sized - 1
end

if sized < 0 then
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
    trainData.DownHP = trainData.DownHP * (1 + size * 0.2)
    base.小穴快感 = base.小穴快感 / math.max(size * 2, 1)
    base.菊穴快感 = base.菊穴快感 / math.max(size * 2, 1)
    base.尿道快感 = base.尿道快感 / math.max(size * 2, 1)

end

base.疼痛 = base.疼痛 + PalamLV((sized + hard + 1)/2)  
base.恐惧 = base.恐惧 + PalamLV((sized + hard + 1)/2)  
base.逃脱 = base.逃脱 + PalamLV(sized)

local palamRes = GetPalamLV(trainData.Source : get_Item("润滑")) - math.max(sized,0) - 1
local exp = 0

if Select == "小穴" or Select == "G点" or Select == "子宫口" then
    if Female.Mark[4] > 0 then
        base.充足 = base.充足 + Female.Mark[4] * 500
    end
    if Female.IsChu then
        base.疼痛 = base.疼痛 + 1000
        base.逃脱 = base.逃脱 + 500
        Train.PoChu = true
    end
    if Train.GetAbility("淫壶") or Female.Mark[4] >= 4 then
        base.疼痛 = base.疼痛 / 3
        base.恐惧 = base.恐惧 / 3
        base.逃脱 = base.逃脱 / 3
    elseif Female.Mark[4] > 0 then
        base.疼痛 = base.疼痛 / (1 - Female.Mark[4] * 0.15)
        base.恐惧 = base.恐惧 / (1 - Female.Mark[4] * 0.15)
        base.逃脱 = base.逃脱 / (1 - Female.Mark[4] * 0.15)
    end
    if trainData.equipItem : Contains("肌肉松弛剂") then
        base.小穴快感 = base.小穴快感 * 0.7
        base.疼痛 = base.小穴快感 * 0.5
    end

    exp = math.min(GetExpLV(Female : 获取经验("小穴经验")) - size - 1 - math.max(sized, 0), 5 - hard)

elseif Select == "子宫" then
    if Female.Mark[4] > 0 then
        base.充足 = base.充足 + Female.Mark[4] * 1000
    end
    local ZGLV = GetExpLV(Female.获取经验("子宫经验"))
    if ZGLV <= 1 then
        base.小穴快感 = base.小穴快感 * 0.2
        base.疼痛 = base.疼痛 + 1000
        base.恐惧 = base.恐惧 + 3000
        base.逃脱 = base.逃脱 + 30000
    elseif ZGLV <= 2 then
        base.小穴快感 = base.小穴快感 * 0.4
        base.疼痛 = base.疼痛 + 500
        base.恐惧 = base.恐惧 + 1000
        base.逃脱 = base.逃脱 + 6000
    else
        base.小穴快感 = base.小穴快感 * 0.7
        base.疼痛 = base.疼痛 + 500
        base.恐惧 = base.恐惧 + 1000
        base.逃脱 = base.逃脱 + 2000
    end
    if Female:检查特性("淫壶") or Female.Mark[4] >= 4 then
        base.疼痛 = base.疼痛 / 3 
        base.恐惧 = base.恐惧 / 3 
        base.逃脱 = base.逃脱 / 3
    elseif Female.Mark[4] >= 1 then
        base.疼痛 = base.疼痛 * 1 - (Female.Mark[4] * 0.15)
        base.恐惧 = base.恐惧 * 1 - (Female.Mark[4] * 0.15)
        base.逃脱 = base.逃脱 * 1 - (Female.Mark[4] * 0.15)
    end
    palamRes = GetPalamLV(trainData.Source : get_Item("润滑")) - math.max(sized, 0) - 1
    exp = math.min(GetExpLV(Female : 获取经验("子宫口经验")) - size - 1 - math.max(sized, 0), 5 - hard)


elseif Select == "肛门" or Select == "插入乙状结肠" then
    if Select == "乙状结肠" then
        local JCexp = GetExpLV("结肠经验")
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

    if Female:检查特性("尻穴狂") then
        base.疼痛 = base.疼痛 / 3 
        base.恐惧 = base.恐惧 / 3 
        base.逃脱 = base.逃脱 / 3 
    end
    if trainData.equipItem : Contains("肌肉松弛剂") then
        base.菊穴快感 = base.菊穴快感 * 0.7
        base.疼痛 = base.疼痛 * 0.5
    end
    if Active == "插入肛门" then
        palamRes = GetPalamLV(trainData.Source : get_Item("润滑")) - math.max(sized,0) - 1
    else
        palamRes = math.min(GetPalamLV(trainData.Source : get_Item("润滑")) - math.max(sized,0), 3)
    end

    exp = math.min(GetExpLV(Female : 获取经验("菊穴经验")) - size - 1 - math.max(sized, 0), 5 - hard)

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
    if trainData.equipItem : Contains("肌肉松弛剂") then
        base.疼痛 = base.疼痛 * 0.2
    end

    exp = math.min(GetExpLV(Female : 获取经验("尿道经验")) - size - 1 - math.max(sized, 0), 5 - hard)
end


local i = Train.JJLike()
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
    if i > 0 and Trainer.IsJJ and Female:GetAbility("V扩张") >= size then
        base.屈从 = base.屈从 + base.恐惧 * i
        base.疼痛 = base.疼痛 / i + 1
        base.恐惧 = base.恐惧 / i + 1
    end
elseif Active == "插入肛门" then
    if i > 0 and Trainer.IsJJ and Female:GetAbility("A扩张") >= size then
        base.屈从 = base.屈从 + base.恐惧 * i
        base.疼痛 = base.疼痛 / i + 1
        base.恐惧 = base.恐惧 / i + 1
    end
elseif Active == "插入尿道" then
    if i > 0 and Trainer.IsJJ and Female.GetAbility("尿扩张") >= size then
        base.屈从 = base.屈从 + base.恐惧 * i
        base.疼痛 = base.疼痛 / i + 1
        base.恐惧 = base.恐惧 / i + 1
    end
end

if sized <= 1 and (Female:GetAbility("好色") or tostring(Female.Feel) == "堕落" or Female:检查特性("柔软体质")) then
    base.疼痛 = base.疼痛 * 0.6
    base.恐惧 = base.恐惧 * 0.6
    base.屈从 = base.屈从 * 0.6

    local n = trainData : TotalPlay("绝顶") + trainData.equipItem : Contains("媚药")
    if n >= math.max(20, trainData.Libido * 2) then
        base.疼痛 = base.疼痛 * 0.2
    elseif n >= math.max(10, trainData.Libido) then
        base.疼痛 = base.疼痛 * 0.5
    elseif n >= math.max(5, trainData.Libido / 2) then
        base.疼痛 = base.疼痛 * 0.8
    end
end

if tostring(Female.Feel) == "狂堕" then
    base.逃脱 = base.逃脱 * 0.2
elseif tostring(Female.Feel) == "堕落" then
    base.逃脱 = base.逃脱 * 0.5
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
    base.液体追加 = base.液体追加 + 100 * math.min(5, PalamLV(base.疼痛))
    if Female:检查特性("阴道性向") then
        TrainManager:性癖增益(base, base.小穴快感)
    end
    local t = Female : GetSexMemory("V", Trainer.Name..Insert)
    if t >= 200 then
        base.小穴快感 = base.小穴快感 * 3
        base.屈从 = base.屈从 * 3
    elseif t >= 150 then
        base.小穴快感 = base.小穴快感 * 2.5
        base.屈从 = base.屈从 * 2.5
    elseif t >= 100 then
        base.小穴快感 = base.小穴快感 * 1.75
        base.屈从 = base.屈从 * 1.75
    elseif t >= 50 then
        base.小穴快感 = base.小穴快感 * 1.25
        base.屈从 = base.屈从 * 1.25
    end
elseif Active == "插入肛门" then
    base.液体追加 = base.液体追加 + math.man(GetPalamLV(base.疼痛) + size * 100, 100)
    if Female:检查特性("肛性向") then
        TrainManager:性癖增益(base, base.菊穴快感)
    end
    local t = Female : GetSexMemory("A", Trainer.Name..Insert)
    if t >= 200 then
        base.小穴快感 = base.菊穴快感 * 3
        base.屈从 = base.屈从 * 3
    elseif t >= 150 then
        base.小穴快感 = base.菊穴快感 * 2.5
        base.屈从 = base.屈从 * 2.5
    elseif t >= 100 then
        base.小穴快感 = base.菊穴快感 * 1.75
        base.屈从 = base.屈从 * 1.75
    elseif t >= 50 then
        base.小穴快感 = base.菊穴快感 * 1.25
        base.屈从 = base.屈从 * 1.25
    end
    if Select == "乙状结肠" then
        base.疼痛 = base.疼痛 + math.max(math.mix(DownPalamLv(base.疼痛, 1), base.疼痛 - 100), 0)
    end
elseif Active == "插入尿道" or Active == "探针" or Select == "尿道" then
    if Female:检查特性("尿道狂") then
        TrainManager:性癖增益(base, base.尿道快感)
    end
    local t = Female : GetSexMemory("U", Trainer.Name..Insert)
    if t >= 200 then
        base.小穴快感 = base.尿道快感 * 3
        base.屈从 = base.屈从 * 3
    elseif t >= 150 then
        base.小穴快感 = base.尿道快感 * 2.5
        base.屈从 = base.屈从 * 2.5
    elseif t >= 100 then
        base.小穴快感 = base.尿道快感 * 1.75
        base.屈从 = base.屈从 * 1.75
    elseif t >= 50 then
        base.小穴快感 = base.尿道快感 * 1.25
        base.屈从 = base.屈从 * 1.25
    end
    if Select == "膀胱口" then
        base.疼痛 = base.疼痛 + math.max(math.mix(DownPalamLv(base.疼痛, 1), base.疼痛 - 100), 0)
    end
elseif Active == "指插入" or Active == "拳交" then
    base.液体追加 = base.液体追加 + math.max(GetExpLV(base.疼痛) + size * 100, 100)
    if Select == "肛门" and Female:检查特性("肛性向") then
        TrainManager:性癖增益(base, base.菊穴快感)
    elseif Select == "小穴" and Female:检查特性("阴道性向") then
        TrainManager:性癖增益(base, base.小穴快感)
    end

end

return base
end