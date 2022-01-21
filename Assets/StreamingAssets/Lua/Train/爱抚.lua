local t ={}
---@type Character



function t:SexActive(active, Active, Select)
    Message : AddMessage("爱抚"..Select)
    ---@type Character
    local Female = active.被调教者
    local 调教者 = active.调教者
    local base = require("Data/ActionPack"):New()
    local yuwan = Female:获取能力("欲望")
    local abl = Female:获取能力("顺从")
    local tec = 调教者.手.技巧

    local CFeel = 0
    if Female.阴蒂 ~= nil then
        CFeel = Female.阴蒂.感觉
    end
    local VFeel = 0
    if Female.小穴 ~= nil then
        VFeel = Female.小穴.感觉
    end
    local BFeel = 0
    if Female.胸 ~= nil then
        BFeel = Female.胸.感觉
    end
    local AFeel = 0
    if Female.菊穴 ~= nil then
        BFeel = Female.菊穴.感觉
    end
    base.情爱 = 100
    base.逃脱 = 50

    if Select == "头部" then
        if abl <= 5 then
            base.情爱 = base.情爱 + 150 * abl
            base.屈从 = base.屈从 + 150 * (abl + 1)
        elseif abl <= 10 then
            base.情爱 = base.情爱 + 125 * (abl - 5) + 750
            base.屈从 = base.屈从 + 125 * (abl - 5) + 900
        elseif abl <= 15 then
            base.情爱 = base.情爱 + 100 * (abl - 10) + 1375
            base.屈从 = base.屈从 + 100 * (abl - 10) + 1525
        elseif abl > 15 then
            base.情爱 = base.情爱 + 50 * (abl - 15) + 1875
            base.屈从 = base.屈从 + 50 * (abl - 15) + 2025
        end


    elseif Select == "胸部" then
        base.胸部快感 = Female:计算刺激度("胸", 1)
        base.胸部快感 = TrainManager:EXABL(tec, base.胸部快感)


        if Female:检查特性("胸性向") then
            TrainManager:性癖增益(base, base.胸部快感)
            BFeel = BFeel + 1
        end

        base.露出 = 200
        base.情爱 = base.情爱 + BFeel * 100
        if BFeel == 0 then
            base.逃脱 = base.逃脱 * 2
        elseif BFeel == 1 then
            base.逃脱 = base.逃脱 * 1.5
        elseif BFeel == 2 then
            base.逃脱 = base.逃脱 * 1.2
        elseif BFeel == 3 then
            base.逃脱 = base.逃脱 * 0.9
        elseif BFeel == 4 then
            base.逃脱 = base.逃脱 * 0.5
        elseif BFeel == 5 then
            base.逃脱 = base.逃脱 * 0.2
        end
        TrainManager:获得经验("胸经验", 1)
        TrainManager:获得经验("手淫经验", 1, 调教者)
        local b = Female:获取装备厚度("身体")
        if b > 0 then
            local l = math.max(5 - b, 0)
            base.胸部快感 = base.胸部快感 * l * 0.2
            base.露出 = base.露出 * l * 0.2
        end
    elseif Select == "小穴" then
        base.阴蒂快感 = Female:计算刺激度("阴蒂", 1)
        base.阴蒂快感 = TrainManager:EXABL(tec, base.阴蒂快感)
        base.小穴快感 = Female:计算刺激度("小穴", 1)
        base.小穴快感 = TrainManager:EXABL(tec, base.小穴快感)
        if Female:检查特性("处女") then
            if Female:检查特性("贞操重视") then
                base.逃脱 = base.逃脱 + 1000
            elseif Female:检查特性("不在乎贞操") then
                base.逃脱 = base.逃脱 + 300
            else
                base.逃脱 = base.逃脱 + 500
            end
        end

        base.情爱 = base.情爱 + (VFeel +  CFeel) * 50
        base.液体追加 = 20
        base.不洁 = 20
        base.露出 = 300
        if Female:检查特性("小穴性向") then
            TrainManager:性癖增益(base, base.小穴快感)
        end
        if VFeel == 0 then
            base.逃脱 = base.逃脱 * 2
        elseif VFeel == 1 then
            base.逃脱 = base.逃脱 * 1.5
        elseif VFeel == 2 then
            base.逃脱 = base.逃脱 * 1.2
        elseif VFeel == 3 then
            base.逃脱 = base.逃脱 * 0.9
        elseif VFeel == 4 then
            base.逃脱 = base.逃脱 * 0.5
        elseif VFeel == 5 then
            base.逃脱 = base.逃脱 * 0.2
        end
        TrainManager:获得经验("手淫经验", 1, 调教者)
        TrainManager:获得经验("小穴经验", 1)
        local b = Female:获取装备厚度("身体")
        if b > 0 then
            local l = math.max(5 - b, 0)
            base.阴蒂快感 = base.阴蒂快感 * l * 0.2
            base.小穴快感 = base.小穴快感 * l * 0.2
            base.露出 = base.露出 * l * 0.2
        end
    elseif Select == "菊穴" then
        base.菊穴快感 = Female:计算刺激度("菊穴", 1)
        base.菊穴快感 = TrainManager:EXABL(tec, base.菊穴快感)
        base.情爱 = base.情爱 + AFeel * 100
        base.逃脱 = base.逃脱 + 900
        base.不洁 = 20
        base.露出 = 300
        local Aexp = Female : 获取经验("菊穴经验")
        if Aexp >= 300 then
            base.菊穴快感 = base.菊穴快感 * 1.6
            base.逃脱 = base.逃脱 * 0.2
            base.恐惧 = base.恐惧 * 0.2
        elseif Aexp >= 150 then
            base.菊穴快感 = base.菊穴快感 * 1.4
            base.恐惧 = base.恐惧 * 0.7
            base.逃脱 = base.逃脱 * 0.6
        elseif Aexp >= 50 then
            base.菊穴快感 = base.菊穴快感 * 1.2
            base.恐惧 = base.恐惧 * 0.7
        elseif Aexp >= 20 then
            base.逃脱 = base.逃脱 * 1.2
        elseif Aexp >= 5 then
            base.菊穴快感 = base.菊穴快感 * 0.5
            base.逃脱 = base.逃脱 * 1.5
            base.恐惧 = base.恐惧 * 1.5
        else   
            base.菊穴快感 = base.菊穴快感 * 0.1
            base.逃脱 = base.逃脱 * 2
            base.恐惧 = base.恐惧 * 2
        end

        if yuwan <= 100 then
            base.屈从 = base.屈从 * 0.3
        elseif yuwan <= 500 then
            base.屈从 = base.屈从 * 0.5
        elseif yuwan <= 3000 then
            base.屈从 = base.屈从 * 0.8
        elseif yuwan <= 10000 then
            base.屈从 = base.屈从 * 1
        else
            base.屈从 = base.屈从 * 1.2
        end

        if Female:检查特性("肛性向") then
            TrainManager:性癖增益(base, base.菊穴快感)
        end
        TrainManager:获得经验("手淫经验", 1, 调教者)
        TrainManager:获得经验("调教菊穴经验", 1, 调教者)
        TrainManager:获得经验("菊穴经验", 1)
        local b = Female:获取装备厚度("身体")
        if b > 0 then
            local l = math.max(5 - b, 0)
            base.菊穴快感 = base.菊穴快感 * l * 0.2
            base.露出 = base.露出 * l * 0.2
        end
    elseif Select == "振动棒" then
    elseif Select == "肛门振动棒" then
    end

    return base
end

function t:TrainMessage()
    local text = SB:New()
    text:Append("[player]用手")
    if trainData.Select == "头部" then
        text:Random("轻轻","温柔","细致")
        text:Append("地反复")
        text:Random("抚摸","爱抚")
        text:Append("着[target]的头部")
    elseif trainData.Select == "胸部" then
        local equip Female:获取外层装备("身体")
        local size = Female.胸.大小
        text:Append("将")
        if equip ~= nil and equip.Type == "护甲" then
            text:Append("隔着坚固的护甲，感受来自胸部的温暖")
        else
            if equip ~= nil then
                if equip.Type == "内衣" then
                    text:Append("胸罩掀起，")       
                else
                    text:Append("拉开胸前的衣物，")
                end
                text:Append("对着暴露在空气中的")
            end
            if size > 5 then
                text:Append("如同棉花糖般柔软的巨房")
                if Female.胸.感觉 >= 3 then

                else
                    text:Random("用手揉捏成各种形状","随着手的变成各种样子","握在手中，乳肉从指间溢出")
                end
            elseif size > 2 then
                text:Append("大小适中的乳房")
                text:Random("用手揉不断揉捻着","用手享受着柔软的触感")
            elseif size > 1 then
                text:Append("微微发育的乳房")
                text:Random("用手按摩着","手指围着可爱的乳头画圈")
            else
                text:Append("飞机场般的乳房")
                text:Random("手指围着可爱的乳头画圈","双手覆盖上去，手掌感受中间的突起")
            end
        end
    elseif trainData.Select == "小穴" then
        text:Append("爱抚着[taget]的小穴")
    end
     text:ToStr()

    ImplementKoujiu("爱抚")
end

function t:SexType(type)
    if type == "爱抚" then
        return true
    end
    return false
end


function t:Check()
    local text = SB:New()
    text:Append( "要爱抚哪里\n")
    text:Append( AddButtonL("头部","CoroutineResume,头"))
    text:Append( AddButtonL("胸部","CoroutineResume,胸"))
    if TrainManager.被调教者.小穴 ~= nil then
        text:Append( AddButtonL("小穴","CoroutineResume,小穴"))
    end
    text:Append( AddButtonL("臀部","CoroutineResume,菊穴"))
    Message : AddMessage(text:ToStr())
    Message : StartPop()
    ---@type string
    local Select = coroutine.yield()
    Message : Continue()

    ---@class ActiveMsg
    local o = 
    {
        调教者 = TrainManager.调教者,
        被调教者 = TrainManager.被调教者,
        执行 = TrainManager.调教者.手,
        目标 = TrainManager.被调教者[Select],
        sex = self,
        体力减少 = 10,
        行为 = "爱抚",
        选择 = Select,
        次数 = 1,
    }
    return o
end

return t