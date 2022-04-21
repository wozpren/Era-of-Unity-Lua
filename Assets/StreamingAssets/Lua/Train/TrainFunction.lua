function PlayerSamenHandle(data)
    if data.Samen == 0 then
        return
    end
    if SexDisgust() then
        data.multi = data.multi * 0.7
    end
    data.multi = data.multi * Mathf.Clamp((0.8 + GetExpLV(trainData.Source : get_Item("欲情")) * 0.1), 0.9, 1.2)
    data.multi = data.multi * math.min(Train.GetAbility("侍奉技术") * 0.1 + GetExpLV(Female : 获取经验("侍奉快乐精神")) * 0.05, 1)
    data.Samen = data.Samen * data.multi / 1000
    local temp = Mathf.Clamp(0.05 * (Train.GetAbility("技巧") - Trainer : GetAbility("技巧") - 1), -0.3, 0.3)
    temp = math.max(temp, -0.7)
    data.Samen = data.Samen * (1 + temp)

    if Trainer.Name == Factory.Characters[0].Name then
        if enumtonumber(Female.Feel) > 1 then
            if data.Samen * 3 < trainData.TrainerSamen.y then
                data.Samen = data.Samen + trainData.TrainerSamen.y / 5
            end
        else
            if Train.HaveTalent("第一次的对象") then
                data.Samen = data.Samen * 1.1
            end
        end
    end
    if Train.Pos["眼"] == "眼罩" then
        data.Samen = data.Samen * 0.8
    end
    if Train.Pos["活动"] == "拘束" then
        data.Samen = data.Samen * 0.8
    end
    if Female.Info.HP < 500 then
        data.Samen = data.Samen * 0.8
    end

    if SexType("清洁口交") or SexType("展示肉棒") or SexType("肉棒接吻") then
        data.Samen = data.Samen * 0.1
    end
    data.Samen = math.floor(data.Samen)
    trainData.TrainerSamen.x = trainData.TrainerSamen.x + data.Samen

end

function AddSexexp(name, value, Chara)
    if Chara == nil then
        Chara = Female
        trainData : AddEXP(name, value)
    end

    if Train.EXP[Chara.Name] == nil then
        Train.EXP[Chara.Name] = { chara = Chara}
    end
    if Train.EXP[Chara.Name][name] == nil then
        Train.EXP[Chara.Name][name] = value
    else
        Train.EXP[Chara.Name][name] = Train.EXP[Chara.Name][name] + value
    end
    
end

function SettlementEXP()
    local text = SB:New()
    for name, Chara in pairs(Train.EXP) do
        for key, value in pairs(Chara) do
            if key ~= "chara" and value > 0 then
                Chara.chara : AddSexexp(key, value)
                text:AppendLine(name..key..":"..value) 
                if key == Female.Name then
                    trainData.EXP : set_Item(key, value)
                end
            end
        end
    end
    Message : AddMessage(text:ToStr())
    ResetEXP()
end

function ResetEXP()
    for name, Chara in pairs(Train.EXP) do
        for key, value in pairs(Chara) do
            if key ~= "chara" and value > 0 then
                Chara[key] = 0
            end
        end
    end
end

function Abl_U(Chara)
    local temp = 10 + Chara : 获取经验("尿道经验") * 2 + Chara : 获取经验("尿道性交经验") * 5 + Chara : GetAbility("尿道名器") * 10
    if Chara : HaveTalent("尿道性感") then
        temp = temp + 5
    end
    if Chara : HaveTalent("尿道狂") then
        temp = temp + 20
    end
    local kz = Chara : GetAbility("尿道扩张")
    if kz == 0 then
        temp = temp + 5
    elseif kz == 1 then
        temp = temp * 1.2 + 10
        temp = math.floor(temp)
    elseif kz == 2 then
        temp = temp * 1.5 + 20
        temp = math.floor(temp)
    elseif kz >= 3 then
        temp = temp * 2 + 30
    end
    return temp
end

function Abl_V(Chara, abs)
    if tostring(Chara.sex) == "男" then
        return 0
    end
    local kz = Chara : GetAbility("V扩张")
    local js = Chara : GetAbility("V技术")

    local LOCAL = 25 + js * 5 + kz
    if kz > js then
        LOCAL = LOCAL - (kz - js) * GetExpLV(Chara : 获取经验("小穴经验")) * 2
    end
    if LOCAL < 10 then
        LOCAL = 10
    end
    local vexp = 0
    local vsexexp = 0
    local vkzexp = 0
    if abs then
        vexp = Chara : 获取经验("小穴经验") 
        vsexexp = Chara : 获取经验("V性交经验") 
        vkzexp = Chara : 获取经验("V扩张经验") 
    else
        vexp = Chara : 获取经验("小穴经验") - trainData.EXP : get_Item("小穴经验")
        vsexexp = Chara : 获取经验("V性交经验") - trainData.EXP : get_Item("V性交经验")
        vkzexp = Chara : 获取经验("V扩张经验") - trainData.EXP : get_Item("V扩张经验")
    end
    local MULTI_VALUE = Mathf.Clamp(100 * (100 + vexp * 2) / (100 + vexp + vkzexp * 10), 20 , 100)
    MULTI_VALUE = Mathf.Clamp(MULTI_VALUE * (100 + vexp + vsexexp * 4) / (100 + vexp * 2), 20, 200)

    if Chara.Info.Str > 50 then
        MULTI_VALUE = MULTI_VALUE + 10
    end
    if Chara : HaveTalent("淫壶") then
        MULTI_VALUE = MULTI_VALUE + 20
    end

    if MULTI_VALUE > 100 then
        LOCAL = (LOCAL + Chara : HaveTalent("V名器") * 10 * MULTI_VALUE) / 100
    else
        LOCAL = (LOCAL * MULTI_VALUE) / 100 + Chara : HaveTalent("V名器") * 10
    end
    return LOCAL
end

function Abl_A(Chara, abs)
    local kz = Chara : GetAbility("A扩张")
    local js = Chara : GetAbility("A技术")
    local LOCAL = 30 + js * 5 + kz
    if kz > js then
        LOCAL = LOCAL - (kz - js) * GetExpLV(Chara : 获取经验("菊穴经验")) * 2
    end
    if LOCAL < 10 then
        LOCAL = 10
    end

    local vexp = 0
    local vsexexp = 0
    local vkzexp = 0
    if abs then
        vexp = Chara : 获取经验("菊穴经验")
        vsexexp = Chara : 获取经验("A性交经验")
        vkzexp = Chara : 获取经验("A扩张经验")
    else
        vexp = Chara : 获取经验("菊穴经验") - trainData.EXP : get_Item("菊穴经验")
        vsexexp = Chara : 获取经验("A性交经验") - trainData.EXP : get_Item("A性交经验")
        vkzexp = Chara : 获取经验("A扩张经验") - trainData.EXP : get_Item("A扩张经验")
    end
    local MULTI_VALUE = 0
    if Chara.Info.Str > 50 then
        MULTI_VALUE = MULTI_VALUE + 10
    end
    if Chara : HaveTalent("淫尻") then
        MULTI_VALUE = MULTI_VALUE + 20
    end

    if MULTI_VALUE > 100 then
        LOCAL = (LOCAL + Chara : HaveTalent("A名器") * 10 * MULTI_VALUE) / 100
    else
        LOCAL = (LOCAL * MULTI_VALUE) / 100 + Chara : HaveTalent("A名器") * 10
    end
    return LOCAL
end

function Abl_T(Chara)
    local LOCAL = 20 + Chara : GetAbility("技巧") + Chara : GetAbility("侍奉技术") * 2
    local hkz = Chara : GetAbility("喉扩张")
    if hkz == 1 then
        LOCAL = LOCAL + 5
    elseif hkz == 2 then
        LOCAL = LOCAL * 1.2 + 10
    elseif hkz == 3 then
        LOCAL = LOCAL * 1.5 + 20
    elseif hkz >= 4 then
        LOCAL = LOCAL * 2 + 30
    end

    return math.floor(LOCAL)
end

function SexDisgust()
    if Train.HaveTalent("两性通吃") then
           return false
    elseif Train.HaveTalent("拒绝异性") then
        if tostring(Female.sex) == "男" and tostring(Trainer.sex) == "男" then
            return false
        elseif tostring(Female.sex) ~= "男" and tostring(Trainer.sex) ~= "男" then
            return false
        else
            return true
        end
    else
        if tostring(Female.sex) == "男" and tostring(Trainer.sex) == "男" then
            return true
        elseif tostring(Female.sex) ~= "男" and tostring(Trainer.sex) ~= "男" then
            return true
        else
            return false
        end
    end
end

function Expose(pos)
    if pos == "v" then
        local equip = Female : GetOutsideEquip(6)
        if equip == nil or equip.Type == "内裤" then
            return true
        end
    elseif pos == "b" then
        local equip = Female : GetOutsideEquip(5)
        if equip == nil or equip.Type == "内衣" then
            return true
        end
    end

    return false
end

function SetSexValue(Chara)
    if Chara == nil then
        return
    end
    local LOCAL = 10000 + Mathf.Clamp(Chara : GetAbility("技巧") - 1, 0, 20) * 1000
    if Chara : HaveTalent("早泄") then
        LOCAL = LOCAL / 2
    else
        LOCAL = LOCAL * 2
    end
    Chara.Climax = LOCAL
    Chara.Samen = math.max(LOCAL * 0.7, 10000)
    Chara.Milk = LOCAL * 1 + 0.1 * math.max(5, Chara:GetAbility("B感觉"))
end


function MultiSet(base ,type)
    if type == "乳" then
        if Train.HaveTalent("淫乳") then
            base.multi = base.multi * 1.5
        end
        base.multi = TrainManager:EXABL(base.multi, GetExpLV("乳交经验"))
        local b = Female.Stature.b
        if b >= 5 then
            base.multi = base.multi * 2
        elseif b == 4 then
            base.multi = base.multi * 1.5
        elseif b == 3 then
            base.multi = base.multi * 1.2
        elseif b < 2 then
            base.multi = base.multi * 0.7
        end
    elseif type == "小穴" then
        if Trainer : 获取经验("V插入经验") + Trainer : 获取经验("A插入经验") == 0 then
            base.multi = base.multi * 3
        end
        if Female.IsCHu then
            base.multi = base.multi * 1.5
        else
            base.multi = (base.multi * (GetExpLV(Female : 获取经验("V性交经验")) + 100) / 100)
        end
        local n = Train.GetAbility("V扩张") - Trainer.Stature.JJSize
        if n <= 0 then
            base.multi = base.multi * 1.2
        elseif n <= Female.小穴.感觉 then
            local t = Mathf.Clamp(150 * Female.CurrentHP / Female.HP, 25 , 100)
            base.multi = base.multi * t / 100
        else
            local t = Mathf.Clamp(120 * Female.CurrentHP / Female.HP, 10 , 100)
            base.multi = base.multi * t / 100
        end
    elseif type == "口" then

    elseif type == "手" then
        base.multi = TrainManager:EXABL(base.multi, GetExpLV("手淫经验"))
    elseif type == "足" then
        base.multi = TrainManager:EXABL(base.multi, GetExpLV("足交经验"))
    end
end

function OrderRequire(value, text, type, name, num)
    if type == "talent" then
        if Train.HaveTalent(name) then
            value = value + num
        else
            return value
        end
    elseif type == "abl" then
        if num > 0 then
            value = value + num
        else
            return value
        end
    elseif type == "equip" then
        if trainData.equipItem : Contains(name) then
            value = value + num
        else
            return value
        end
    elseif type == "prev" then
        if trainData : PrevPlay(name) ~= 0 then
            value = value + num
        else
            return value
        end
    elseif type == "sex" then
        if tostring(Female.Sex) == name then
            value = value + num
        else
            return value
        end
    elseif type == "place" then
        if trainData.Place == name then
            value = value + num
        else
            return value
        end
    else
        return value
    end
    text:Append(name..": "..num.." ")
    return value, text
end

function Expand(type, size, hard)
    local Add = 0
    local exp = 0
    if hard > 2 then
        Add = Add + 1
    end
    if Train.HaveTalent("扩张适应") then
        Add = Add + 1
    end
    if type == "v" then
        Add = Add + size - Train.GetAbility("V扩张") - 2
        if Female.IsChu then
            Add = Add - 1
        end
    else
        Add = Add + size - Train.GetAbility("A扩张") - 2
    end

    trainData.DownHP = trainData.DownHP + 50 * Add

    if size < 2 then
        return 0
    end

    local temp = 0
    if type == "v" then
        exp = size - Train.GetAbility("V扩张")
        temp = ExpLV(GetExpLV(Female : 获取经验("V扩张经验")) + 1)
    else
        exp = size - Train.GetAbility("A扩张")
        temp = ExpLV(GetExpLV(Female : 获取经验("A扩张经验")) + 1)
    end
    if exp <= - 2 then
        if size >= 4 then
            Add = 1
        else
            return
        end
    elseif exp == -1 then
        if size >= 3 then
            Add = 1
        else
            return
        end
    elseif exp == 0 then
        Add = 1
    elseif exp == 1 then
        Add = Mathf.Round((temp + 5) / 10)
        if hard == 1 then
            Add = 1
        elseif hard == 2 then
            Add = math.min(Add, 2)
        end
    elseif exp == 2 then
        Add = Mathf.Round((temp + 1) / 3)
    elseif exp >= 3 then
        Add = temp
    end
    if hard >= 3 then
        Add = math.max(Add, size)
    end

    Add = Mathf.Clamp(Add, 1, 20)
    local kzexp = 0
    local orgexp = 0
    if type == "v" then
        kzexp = Female : 获取经验("V扩张经验")
        orgexp = exp - trainData.EXP : get_Item("V扩张经验")
    else
        kzexp = Female : 获取经验("A扩张经验")
        orgexp = exp - trainData.EXP : get_Item("A扩张经验")
    end
    if orgexp > 0 then
        if kzexp >= math.max(ExpLV(size), 1) and size <= 2 then
            return
        end

        if exp <= -1 then
            if size >= 3 and hard >= 3 then
                Add = 1
            else
                return
            end
        elseif exp <= 1 then
            if hard >= 3 then
                Add = math.max(Add / 2, 1)
            else
                Add = Add / 2
            end
        elseif exp > 1 then
            if hard == 1 then
                Add = 1
            elseif hard == 2 then
                Add = math.min(Add, 2)
            end
        end

        if size == 1 then
            Add = math.min(Add, 1)
        elseif size == 2 then
            Add = math.min(Add, 2)
        elseif size == 3 then
            Add = math.min(Add, 5)
        elseif size == 4 then
            Add = math.min(Add, 10)
        else
            Add = math.min(Add, size * 4)
        end
    end

    if type == "v" then
        AddSexexp("V扩张经验", Add)
    else
        AddSexexp("A扩张经验", Add)
    end
end


function ImplementKoujiu(type)
    if Koujiu ~= nil and Koujiu[type] ~= nil then
        Koujiu[type]()
    end
end


function SMPlay(type)
    local base = ActiveData.new()
    local m = Train.GetAbility("受虐属性")
    local s = Trainer : GetAbility("施虐属性")


    if type == "鼻钩" then
        base.充足 = m * 100 * (1 + s * 0.2)
        base.情爱 = m * 100 * (1 + s * 0.2)
    elseif type == "眼罩" then
        base.充足 = m * 100 * (1 + s * 0.2)
        base.情爱 = m * 100 * (1 + s * 0.2)
    elseif type == "打屁股" then
        base.充足 = m * 200 * (1 + s * 0.2)
        base.情爱 = m * 200 * (1 + s * 0.2)
    elseif type == "拘束" or type == "口枷" or type == "剃毛" or type == "喝套内精液" then
        if m <= 1 then
            return
        end
        base.充足 = m * 200 * (1 + s * 0.2)
        base.情爱 = m * 200 * (1 + s * 0.2)
    elseif type == "鞭打" then
        if m <= 1 then
            return
        end
        base.充足 = m * 250 * (1 + s * 0.4)
        base.情爱 = m * 250 * (1 + s * 0.4)
    elseif type == "强制口交" then
        if m <= 1 then
            return
        end
        base.充足 = m * 250 * (1 + s * 0.4)
        base.情爱 = m * 250 * (1 + s * 0.4)
    elseif type == "浣肠" or type == "拳交" then
        if m <= 2 then
            return
        end
        base.充足 = m * 300 * (1 + s * 0.4)
        base.情爱 = m * 300 * (1 + s * 0.4)
    elseif type == "双重拳交" then
        if m <= 3 then
            return
        end
        base.充足 = m * 300 * (1 + s * 0.4)
        base.情爱 = m * 300 * (1 + s * 0.4)
    end
    return base
end

function ServicePlay(Active)
    if Active == nil then
        Active = trainData.Active
    end
    local base = ActiveData.new()
    local sf = Train.GetAbility("侍奉技术")
    if sf == 0 then
        base.性行动 = 100
        base.成就感 = 50
    elseif sf == 1 then
        base.性行动 = 500
        base.成就感 = 200
    elseif sf <= 5 then
        base.性行动 = 500 + (sf - 1) * 100
        base.成就感 = 200 + (sf - 1) * 50
    elseif sf <= 10 then
        base.性行动 = 900 + (sf - 5) * 60
        base.成就感 = 400 + (sf - 5) * 20
    else
        base.性行动 = 1200 + (sf - 10) * 30
        base.成就感 = 500 + (sf - 10) * 10
    end

    local temp = Train.GetAbility("技巧")
    if Active == "侍奉舔阴" then
        base.性行动 = base.性行动 * 1.8
        base.成就感 = base.成就感 * 1.8
        temp = temp + GetExpLV(Female : 获取经验("口交经验"))
    elseif Active == "手淫" then
        temp = temp + GetExpLV(Female : 获取经验("手淫经验"))
    elseif Active == "口交" then
        base.性行动 = base.性行动 * 1.5
        base.成就感 = base.成就感 * 1.5
        temp = temp + GetExpLV(Female : 获取经验("口交经验"))
    elseif Active == "乳交" then
        temp = temp + GetExpLV(Female : 获取经验("乳交经验"))
    elseif Active == "素股" then
        temp = temp + Train.GetAbility("性交中毒")
    elseif Active == "强制口交" or Active == "肛门侍奉" then
        base.性行动 = base.性行动 * 2
        base.成就感 = base.成就感 * 2
        temp = temp + Train.GetAbility("口交经验")
    elseif Active == "足交" then
        temp = temp + Train.GetAbility("施虐属性") * 0.5 + GetExpLV(Female : 获取经验("足交经验")) * 0.5
    elseif Active == "舔足" then
        temp = temp + Train.GetAbility("受虐属性")
    end
    temp = math.floor(temp)

    if temp <= 5 then
        base.性行动 = base.性行动 * (temp * 0.2 + 1)
        base.成就感 = base.成就感 * (temp * 0.2 + 1)
    elseif temp <= 10 then
        base.性行动 = base.性行动 * ((temp - 5) * 0.1 + 2)
        base.成就感 = base.成就感 * ((temp - 5) * 0.1 + 2)
    else
        base.性行动 = base.性行动 * ((temp - 10) * 0.05 + 2.5)
        base.成就感 = base.成就感 * ((temp - 10) * 0.05 + 2.5)
    end
return base
end