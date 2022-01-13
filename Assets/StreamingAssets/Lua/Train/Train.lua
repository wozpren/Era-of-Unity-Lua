Train = {}

function Train.Update()
    Train.UpdateProperty()
    Train.UpdateMenu()
end

function Train.Init()
    require("Train/TrainFunction")
    require("Train/插入")

    Train.HPDown = 0
    Train.fav = 0
    Train.堕落 = 0
    Train.屈服 = 0
    Train.EXP = {}
    Train.Pos = {眼 = "空", 嘴 = "空", 乳头 = "空", 小穴 = "空", 
                尿道 = "空", 肛门 = "空", 活动 = "可以"}
  

    trainData = TrainPage.train
    Trainer = Factory.Trainer
    Female = Factory.TrainChara
    Assistant = Factory.AssistantChara
    if Female.KouJiu ~= nil then
        dofile(string.format("Chara/%s/%s_train", Female.KouJiu, Female.KouJiu))
    end
    TalentTable = {}
    AbliTable = {}


    Train.Update()
    EventManager.SetListener("Update", Train.Update)
end

function Train.UpdateProperty()
    local text = SB.new()
    SB.append(text, "调教者:"..Trainer.Name.."   ")
    if(Trainer.IsJJ) then
         SB.append(text, "精液:"..GeneralPage : ShowBar(trainData.TrainerSamen.x,trainData.TrainerSamen.y,"white"))
    end
    if(Trainer: HaveTalent("泌乳")) then 
        SB.append(text, "母乳:"..GeneralPage : ShowBar(trainData.TrainerMilk.x,trainData.TrainerMilk.y,"white"))
    end
    if(Assistant ~= nil) then
        SB.append(text, "助手:"..Assistant.Name)
        if(Assistant.IsJJ) then
            SB.append(text, "精液:"..GeneralPage : ShowBar(trainData.AssiSemen.x,trainData.AssiSemen.y,"white"))
        end
        if(Assistant: HaveTalent("泌乳")) then 
            SB.append(text, "母乳:"..GeneralPage : ShowBar(trainData.AssiMilk.x,trainData.AssiMilk.y,"white"))
        end
    end
    SB.append(text, string.format("<pos=79%%>眼:%s 活动:%s</pos>", Train.Pos.眼, Train.Pos.活动))
    SB.append(text, "\n调教对象:"..Female.Name)
    SB.append(text, string.format("   体力:%s", GeneralPage : ShowBar(Female.CurrentHP,Female.BattleInfo.Final.HP, "red")))
    if(Female.IsJJ) then
        SB.append(text, "精液:"..GeneralPage : ShowBar(trainData.FemaleSamen.x,trainData.FemaleSamen.y,"white"))
    end
    if(Female: HaveTalent("泌乳")) then 
        SB.append(text, "母乳:"..GeneralPage : ShowBar(trainData.FemaleMilk.x,trainData.FemaleMilk.y,"white"))
    end
    SB.append(text, string.format("<pos=79%%>嘴:%s 乳头:%s</pos>", Train.Pos.嘴, Train.Pos.乳头))
    SB.append(text, "\n")
    SB.append(text, Female : GetOutsideEquip())
    SB.append(text, string.format("<pos=68%%>小穴:%s 肛门:%s 尿道:%s</pos>", Train.Pos.小穴, Train.Pos.肛门, Train.Pos.尿道))
    SB.append(text, "\n")

    local temp = 0;
    local itor = TrainPage.train.Source : GetEnumerator()
    while itor : MoveNext() do
        SB.append(text, string.format("<pos=%d%%>%s: %d",temp * 20 ,itor.Current.Key, itor.Current.Value))
        temp = temp + 1
        if(temp == 5) then
            temp = 0 
            SB.append(text, "\n")
        end
    end
    SB.append(text, "姿势:"..trainData.Posture)
    if trainData.IsFace then
        SB.append(text, "   正面")
    else
        SB.append(text, "   背面")
    end
    
    TrainPage.Property.text = SB.tostr(text)
end

function Train.UpdateMenu()
    local text = Train.TrainMenu()
    SB.append(text, "\n")
    SB.append(text, AddButtonSpe("更换姿势", "Train.ChangePos"))
    SB.append(text, AddButtonSpe("对象能力", "Train.Inspect,Female"))
    SB.append(text, AddButtonSpe("自己能力", "Train.Inspect,Trainer"))
    SB.append(text, AddButtonSpe("助手能力", "Train.Inspect,Assistant").."\n")
    SB.append(text, AddButtonSpe("和助手交换", "Train.ChangeAssistant"))
    SB.append(text, AddButtonSpe("避孕套设定", "Train.CondomSetting"))
    SB.append(text, AddButtonSpe("衣服管理", "Train.ClothSetting").."\n")
    SB.append(text, AddButtonSpe("调教终了", "Train.EndTrain"))
    TrainPage.Options.text = SB.tostr(text)
end

function Train.TrainMenu()
    local fsf = Trainer : GetAbility("侍奉技术")
    local fsn = Trainer : GetAbility("施虐属性")
    local text = SB.new()
    Train.Line = 0
    --爱抚
    SB.append(text, Train.Button("爱抚"))
    ---舔舐
    SB.append(text, Train.Button("舔舐"))

    if Train.Pos.嘴 == "空" then
        SB.append(text, Train.Button("接吻"))
        if fsf >= 2 then
            SB.append(text, Train.Button("身体侍奉", "肛门", "舔肛侍奉"))
            if tostring(Trainer.sex) ~= "男" then
                SB.append(text, Train.Button("身体侍奉", "小穴", "舔阴侍奉"))
            end
            SB.append(text, Train.Button("身体侍奉", "足", "舔足侍奉"))
        end
    end
    if Train.Pos.活动 == "可以" then
        SB.append(text, Train.Button("自慰"))
        if Train.Pos.小穴 == "空" then
            SB.append(text, Train.Button("张开", "小穴"))
        end
        if Train.Pos.肛门 == "空" then
            SB.append(text, Train.Button("张开", "肛门"))
        end
    end
    if Expose("v") then
        if trainData.LastActive == "指插入" then
            SB.append(text, Train.Button("指插入", "G点", "刺激G点"))
        elseif Train.Pos.小穴 == "空" then
            SB.append(text, Train.Button("指插入","小穴"))
            SB.append(text, Train.Button("插入小穴", "小穴", "插入小穴"))
            if Factory:HaveStuff("振动棒") then
                SB.append(text, Train.Button("振动棒"))
            end
        elseif Train.Pos.小穴 == "JJ" then
            SB.append(text, Train.Button("插入小穴", "小穴", "拔出肉棒"))
            if Trainer : GetAbility("技巧") >= 2 then
                SB.append(text, Train.Button("插入小穴", "G点", "刺激G点"))
                if Trainer : GetAbility("技巧") >= 3 then
                    SB.append(text, Train.Button("插入小穴", "G点", "刺激子宫口"))
                    if Female : GetSexexp("子宫口经验") > 20 then
                        SB.append(text, Train.Button("插入小穴", "子宫", "插入子宫"))
                    end
                end
            end
        elseif Train.Pos.小穴 == "振动棒" then
            SB.append(text, Train.Button("振动棒"))
        end
        if Train.Pos.肛门 == "空" then
            SB.append(text, Train.Button("指插入","肛门"))
            SB.append(text, Train.Button("插入肛门", "肛门", "插入肛门"))
            if Factory:HaveStuff("振动棒") then
                SB.append(text, Train.Button("肛门振动棒"))
            end
        elseif Train.Pos.肛门 == "JJ" then
            SB.append(text, Train.Button("插入肛门", "肛门", "拔出肉棒"))
            if Trainer : GetAbility("技巧") >= 3 then
                SB.append(text, Train.Button("插入肛门", "乙状结肠", "刺激乙状结肠"))
            end
        elseif Train.Pos.肛门 == "振动棒" then
            SB.append(text, Train.Button("振动棒"))
        end
        if Train.GetAbility("尿道扩张") >= 1 then
            if Train.Pos.尿道 == "空" then
                SB.append(text, Train.Button("指插入","尿道"))
                if Train.GetAbility("尿道扩张") > 2 then
                    SB.append(text, Train.Button("插入尿道", "尿道", "插入尿道"))
                    if Factory:HaveStuff("尿道振动棒") then
                        SB.append(text, Train.Button("尿道振动棒"))
                    end
                end
            elseif Train.Pos.尿道 == "JJ" then
                SB.append(text, Train.Button("插入尿道", "肛门", "拔出肉棒"))
                if Trainer : GetAbility("技巧") >= 3 then
                    SB.append(text, Train.Button("插入尿道", "膀胱", "刺激膀胱"))
                end
            elseif Train.Pos.尿道 == "振动棒" then
                SB.append(text, Train.Button("尿道振动棒"))
            end
        end

    end

    SB.append(text, Train.Button("手淫"))
    SB.append(text, Train.Button("口交"))
    if trainData.LastActive == "口交" then
        SB.append(text, Train.Button("口交","深喉","深喉"))
    end
    if trainData.LastActive == "手淫" or trainData.LastActive == "口交" then
        SB.append(text, Train.Button("手淫","手交口交","手交口交"))
    end
    if fsf >= 1 and (trainData.LastActive == "口交" or trainData.LastActive == "自慰") then
        SB.append(text, Train.Button("口交","口交自慰","口交自慰"))
    end

    if Expose("v") then
        SB.append(text, Train.Button("素股"))
    end

    if Expose("b") and fsf >= 1 then
        SB.append(text, Train.Button("乳交"))
        if trainData.LastActive == "乳交" or trainData.LastActive == "口交" then
            SB.append(text, Train.Button("乳交","乳夹口交","乳夹口交"))
        end
    end

    if fsn >= 1 then
        SB.append(text, Train.Button("足交"))
    end

    SB.append(text, Train.Button("什么也不做"))

    SB.append(text, Train.Button("打屁股"))
    if Factory:HaveStuff("眼罩") then
        SB.append(text, Train.Button("眼罩"))
    end
    if Factory:HaveStuff("口枷") then
        SB.append(text, Train.Button("口枷"))
    end
    if Factory:HaveStuff("绳子") then
        SB.append(text, Train.Button("拘束"))
    end
    local sn = Trainer : GetAbility("施虐属性")
    if sn >= 1 then
        if Factory:HaveStuff("鞭子") then
            SB.append(text, Train.Button("鞭打"))
        end
        if sn >= 2 then
            SB.append(text, Train.Button("强制口交"))
            SB.append(text, Train.Button("尿道探针"))
            if sn >= 3 then
                if Train.GetAbility("V扩张") > 2 then
                    SB.append(text, Train.Button("拳交","小穴","小穴拳交"))
                end
                if Train.GetAbility("A扩张") > 2 then
                    SB.append(text, Train.Button("拳交","肛门","肛门拳交"))
                end
                if Train.GetAbility("V扩张") > 2 and Train.GetAbility("A扩张") > 2 then
                    SB.append(text, Train.Button("拳交","双穴","双穴拳交"))
                end
            end
        end
    end
    if Factory:HaveStuff("剃须刀") and Female.Stature > 3 then
        SB.append(text, Train.Button("剃毛"))
    end
    if fsf >= 2 and Factory : GetSwitch("浴室") then
        SB.append(text, Train.Button("浴室PLAY"))
    end
    if Factory:HaveStuff("围裙") and Train.GetAbility("顺从") >= 3 then
        SB.append(text, Train.Button("新婚PLAY"))
    end

    if Expose("v") and Factory:HaveStuff("润滑液") then
        SB.append(text, Train.Button("润滑液"))
    end


    return text
end

function Train.PosOccupy(pos, item)
    for key, value in pairs(Train.Pos) do
        if value == item then
            Train.Pos[key] = "空"
        end
    end
    Train.Pos[pos] = item
end



local function t()
    local text = SB.new()
    SB.append(text, AddButtonL("正常位", "CoroutineResume,正常位"))
    SB.append(text, AddButtonL("乘骑位", "CoroutineResume,乘骑位"))
    SB.append(text, AddButtonL("抱座位", "CoroutineResume,抱座位"))
    SB.append(text, AddButtonL("站立位", "CoroutineResume,站立位"))
    SB.append(text, AddButtonL("改变朝向", "CoroutineResume,改变朝向"))
    Message : AddMessage(SB.tostr(text))
    Message : StartPop()
    local select = coroutine.yield()
    Message : Continue()
    Train.ChangePosture(select)
end

function Train.ChangePos()
    Coroutine = coroutine.start(t)
end

function Train.Button(arg1, arg2, arg3)
    local s
    if arg2 == nil then
        s = string.format("<link=\"Train,%s,%s\"><color=yellow>%s</color></link>",  arg1, arg1, arg1)
    elseif arg3 == nil then
        s = string.format("<link=\"Train,%s,%s\"><color=yellow>%s</color></link>",  arg1, arg2, arg1..arg2)
    else
        s = string.format("<link=\"Train,%s,%s\"><color=yellow>%s</color></link>",  arg1, arg2, arg3)
    end
    Train.Line = Train.Line + 33
    if Train.Line > 90 then
        Train.Line = 0
        s = s.."\n"
    else
        s = s.." "
    end
    return s
end

function Train.StartTrain(Active, Select)
    Coroutine = coroutine.start(Train.Start, Active, Select)
end


function Train.Start(Active, Select)
    ------------判断与上次是否相同---------------
    trainData.Active = Active
    trainData.Select = Select
    trainData : IsSameActive()
    ------------------------------------------
    dofile("Train/"..Active)
    
    if not Check() then
        Message : StartPop()
        return
    end
    Train.MainTrain()
end

function Train.MainTrain()
    CSourcePack = Train.TrainlHandle()


    Train.OrgasmHandle()
    Train.MarkGetCheck()
    Train.ExpCheck()
    Train.FriendCheck()
    Train.DepravedCheck()
    Train.ObedienceCheck()
    if Train.PoChu ~= nil then
        Train.PoChu = nil
        Female.IsChu = false
        trainData : AddContent("处女丧失")
        Message : AddMessage("处女丧失")
    end
    TrainMessage()

    ------------------结束------------------------
    Female.CurrentHP = Female.CurrentHP - Train.HPDown
    Train.SePlace = nil
    Train.fav = 0
    Train.堕落 = 0
    Train.屈服 = 0
    Train.HPDown = 0

    trainData.LastActive = trainData.Active
    trainData.LastSelect = trainData.Select
    ---------------------输出---------------------
    SettlementEXP()
    local text = SB.new()
    local text1 = SB.new()
    for key, value in pairs(CtrainPack) do
        if value ~= 0 and key ~= "ABLTech" and key ~= "multi" and key ~= "Samen" then
        SB.append(text, string.format("(%s:%d)", key, value))
        end
    end
    Message : AddMessage(SB.tostr(text))
    for key, value in pairs(CSourcePack) do
        if(value ~= 0) then
            local before = trainData.Source:get_Item(key)
            SB.append(text1, string.format("%s:%d + %s:%d = %s:%d\n", key, before, key, value, key , before + value))
            trainData.Source:set_Item(key, before + value)
        end
    end
    print("可以运行1")
    trainData : PushContent()
    Message : AddMessage(SB.tostr(text1))
    Message : StartPop()
    CSourcePack = nil
    CtrainPack = nil

    if Female.CurrentHP < 0 then
        Train.EndTrain()
    end
end
--射精检查
function Train.EjaculateCheck()
    local text = SB.new()
    SB.appendLine(text, "选择射在哪里")
    SB.append(text, AddButton("直接发射   ","CoroutineResume,直接发射"))
    SB.append(text, AddButton("射在外面   ","CoroutineResume,射在外面"))
    SB.append(text, AddButton("脸部   ","CoroutineResume,射在外面"))
    SB.append(text, AddButton("身上   ","CoroutineResume,射在外面"))
    Message : AddTopMessage(SB.tostr(text))
    local select = coroutine.yield()
    Message : Continue()
    if select == "射在外面" then
        Train.SePlace = "外面"
    elseif select == "脸部" then
        Train.SePlace = "脸部"
    elseif select == "身上" then
        Train.SePlace = "身上"
    end
end

function Train.EquipHandle()
    for key, value in pairs(Train.Pos) do
        if value ~= "空" or value ~= "可以" then
                EquipEvent[key](value)
        end
    end
end

function Train.FriendCheck()
    if Train.HaveTalent("容易迷恋") then
        Train.fav = Train.fav + 5
    end
    if Train.HaveTalent("容易迷恋") then
        Train.fav = Train.fav + 1
    end
    if Train.HaveTalent("倒错") and Female.Mark[1] > Train.GetAbility("受虐属性") then
        Train.fav = Train.fav - Female.Mark[1] + Train.GetAbility("受虐属性")
    end

    if Female.Mark[1]== 3 and (Train.HaveTalent("倒错") or  Train.GetAbility("受虐属性") >= 3) then
        Train.fav = Train.fav - Female.Mark[1] + Train.GetAbility("受虐属性")
    end

    if CSourcePack.恐怖 + CSourcePack.反感 >= 100 then
        Train.fav = Train.fav - Mathf.Pow(2, GetPalamLV(CSourcePack.恐怖 + CSourcePack.反感))
    end

    if CSourcePack.恭顺 >= 500 then
        Train.fav = Train.fav + GetPalamLV(CSourcePack.恭顺)
    end
    if Train.Mood() / 30 >= 3 then
        Train.fav = Train.fav + 1
    end
    if trainData.equipItem : Contains("媚药") then
        Train.fav = Train.fav - trainData : GetValue("媚药") / 50
        if Train.HaveTalent("否定快感") then
            Train.fav = Train.fav - 2
        end
    end
    if Train.HaveTalent("叛逆") and Train.fav > 0 then
        Train.fav = Train.fav - 1
    end
    if Train.HaveTalent("冷漠") and Train.fav > 0 then
        Train.fav = Train.fav - 1
    end
    if Train.HaveTalent("感情缺乏") and Train.fav > 0 then
        Train.fav = Train.fav - 1
    end
    if Train.HaveTalent("难以越过的底线") and Train.fav > 0 then
        Train.fav = Train.fav - 1
    end
    if Train.HaveTalent("难以越过的底线") and Train.fav > 10 then
        Train.fav = Train.fav - 2
    end
    if Train.HaveTalent("否定快感") and Train.fav > 0 then
        Train.fav = Train.fav - 1
    end
    if Train.fav > 0 then
        local hg = Female.Friend
        if hg >= 100000000 then
            Train.fav = Train.fav / 64
        elseif hg >= 10000000 then
            Train.fav = Train.fav / 32
        elseif hg >= 1000000 then
            Train.fav = Train.fav / 16
        elseif hg >= 100000 then
            Train.fav = Train.fav / 8
        elseif hg >= 10000 then
            Train.fav = Train.fav / 4
        elseif hg >= 5000 then
            Train.fav = Train.fav / 2
        end
        Train.fav = math.ceil(Train.fav)
    end
    if Train.fav >= 200 then
        Train.fav = 60 + (Train.fav - 200) / 16
    elseif Train.fav >= 100 then
        Train.fav = 48 + (Train.fav - 100) / 8
    elseif Train.fav >= 50 then
        Train.fav = 35 + (Train.fav - 50) / 4
    elseif Train.fav >= 20 then
        Train.fav = 20 + (Train.fav - 20) / 2
    end
    Train.fav = math.ceil(Train.fav)
    Female.Friend = Female.Friend + Train.fav
    if Train.fav > 0 then
        Message : AddMessage("好感度↑"..Train.fav)
    elseif Train.fav < 0 then
        Message : AddMessage("好感度↓"..-Train.fav)
    end
end

function Train.DepravedCheck()
    if Train.HaveTalent("淫乱") then
        Train.堕落 = Train.堕落 + 2
    end
    if Train.HaveTalent("好色") then
        Train.堕落 = Train.堕落 + 1
    end
    if Train.HaveTalent("接受快感") then
        Train.堕落 = Train.堕落 + 2
    end
    if Train.HaveTalent("倒错") and Train.堕落 > 0 then
        Train.堕落 = Train.堕落 + 1
    end
    if trainData.equipItem : Contains("媚药") then
        Train.堕落 = Train.堕落 * 1.5
    end

    if Train.HaveTalent("强硬") then
        Train.堕落 = Train.堕落 - 1
    end
    if Train.HaveTalent("坚强") then
        Train.堕落 = Train.堕落 - 2
    end
    if Train.HaveTalent("难以越过的底线") and Train.堕落 > 0 then
        Train.堕落 = Train.堕落 - 1
    end
    if Train.HaveTalent("难以越过的底线") and Train.堕落 > 10 then
        Train.堕落 = Train.堕落 - 2
    end
    if Train.HaveTalent("否定快感") and Train.堕落 > 0 then
        Train.堕落 = Train.堕落 - 1
    end
    if Train.堕落 > 0 then
        local hg = Female.Depraved
        if hg >= 100000000 then
            Train.堕落 = Train.堕落 / 64
        elseif hg >= 10000000 then
            Train.堕落 = Train.堕落 / 32
        elseif hg >= 1000000 then
            Train.堕落 = Train.堕落 / 16
        elseif hg >= 100000 then
            Train.堕落 = Train.堕落 / 8
        elseif hg >= 10000 then
            Train.堕落 = Train.堕落 / 4
        elseif hg >= 5000 then
            Train.堕落 = Train.堕落 / 2
        end
        Train.堕落 = math.floor(Train.堕落)
    end
    if Train.堕落 >= 200 then
        Train.堕落 = 60 + (Train.堕落 - 200) / 16
    elseif Train.堕落 >= 100 then
        Train.堕落 = 48 + (Train.堕落 - 100) / 8
    elseif Train.堕落 >= 50 then
        Train.堕落 = 35 + (Train.堕落 - 50) / 4
    elseif Train.堕落 >= 20 then
        Train.堕落 = 20 + (Train.堕落 - 20) / 2
    end

    Train.堕落 = math.floor(Train.堕落)
    Female.Depraved = Female.Depraved + Train.堕落
    if Train.堕落 > 0 then
        Message : AddMessage("堕落度↑"..Train.堕落)
    elseif Train.堕落 < 0 then
        Message : AddMessage("堕落度↓"..-Train.堕落)
    end
end

function Train.ObedienceCheck()
    if Train.HaveTalent("软弱") then
        Train.屈服 = Train.屈服 + 1
    end
    if Train.HaveTalent("容易迷恋") then
        Train.屈服 = Train.屈服 + 2
    end
    if Train.HaveTalent("献身") then
        Train.屈服 = Train.屈服 + 2
    end

    if Train.HaveTalent("高贵") then
        Train.屈服 = Train.屈服 - 1
    end
    if Train.HaveTalent("强硬") then
        Train.屈服 = Train.屈服 - 1
    end
    if Train.HaveTalent("坚强") then
        Train.屈服 = Train.屈服 - 2
    end

    
    if Train.屈服 > 0 then
        local hg = Female.Depraved
        if hg >= 100000000 then
            Train.屈服 = Train.屈服 / 64
        elseif hg >= 10000000 then
            Train.屈服 = Train.屈服 / 32
        elseif hg >= 1000000 then
            Train.屈服 = Train.屈服 / 16
        elseif hg >= 100000 then
            Train.屈服 = Train.屈服 / 8
        elseif hg >= 10000 then
            Train.屈服 = Train.屈服 / 4
        elseif hg >= 5000 then
            Train.屈服 = Train.屈服 / 2
        end
        Train.屈服 = math.ceil(Train.屈服)
    end
    if Train.屈服 >= 200 then
        Train.屈服 = 60 + (Train.屈服 - 200) / 16
    elseif Train.屈服 >= 100 then
        Train.屈服 = 48 + (Train.屈服 - 100) / 8
    elseif Train.屈服 >= 50 then
        Train.屈服 = 35 + (Train.屈服 - 50) / 4
    elseif Train.屈服 >= 20 then
        Train.屈服 = 20 + (Train.屈服 - 20) / 2
    end

    Train.屈服 = math.ceil(Train.屈服)
    Female.Obedience = Female.Obedience + Train.屈服
    if Train.屈服 > 0 then
        Message : AddMessage("服从度↑"..Train.屈服)
    elseif Train.屈服 < 0 then
        Message : AddMessage("服从度↓"..-Train.屈服)
    end
end

function Train.ChangePosture(pose)
    local text = SB.new() 
        if(pose ~= "改变朝向") then
            trainData.Posture = pose
            SB.append(text, "将姿势调整为"..pose.."\n")
        else
            trainData.IsFace = not trainData.IsFace
            if trainData.IsFace then
                SB.append(text, "面对姿势\n")
            else
                SB.append(text, "背对姿势")
            end
        end
        Message : AddMessage(SB.tostr(text))
        Message : StartPop()
end

function Train.ClothSetting()
    local text = SB.new()
    SB.append(text, Female.Name.."的穿着".."\n")
    local equips = Female : GetOutsideEquips()

    for i = 0, 7 do
        local a = ""
        if i == 0 then
            a = "头"
        elseif i == 1 then
            a = "眼"
        elseif i == 2 then
            a = "嘴"
        elseif i == 3 then
            a = "脖"
        elseif i == 4 then
            a = "手"
        elseif i == 5 then 
            a = "身"
        elseif i == 6 then
            a = "腿"
        elseif i == 7 then
            a = "脚"
        end
        if(equips[i] == nil) then
            SB.append(text, a.."[----]\n")
        else
            SB.append(text, a.."["..equips[i].Name.."]\n")
        end
    end

    Message : AddMessage(SB.tostr(text))
    Message : AddMessage(AddButton("全部穿上 ", "Train.ClothSelect,全部穿上")..AddButton("只剩内衣裤 ", "Train.ClothSelect,只剩内衣裤")..AddButton("裸体 ", "Train.ClothSelect,裸体"))
    Message : StartPop()
end

function Train.ClothSelect(type)
    trainData : ClothSetting(type)
    local text = SB.new()
    SB.append(text, Female.Name.."的穿着".."\n")
    local equips = Female : GetOutsideEquips()
    for i = 0, 7 do
        local a = ""
        if i == 0 then
            a = "头"
        elseif i == 1 then
            a = "眼"
        elseif i == 2 then
            a = "嘴"
        elseif i == 3 then
            a = "脖"
        elseif i == 4 then
            a = "手"
        elseif i == 5 then
            a = "身"
        elseif i == 6 then
            a = "腿"
        elseif i == 7 then
            a = "脚"
        end
        if(equips[i] == nil) then
            SB.append(text, a.."[----]\n")
        else
            SB.append(text, a.."["..equips[i].Name.."]\n")
        end
    end

    Message : AddMessage(SB.tostr(text))
    Message : Continue()
end


function Train.EndTrain()
    Message : AddMessage("调教结束了")
    local bouns = 0


    if Female.Libido > 0 then
        local yw = Train.GetAbility("欲望")
        local temp = trainData.Libido / Female.Libido
        if temp < 1 then
        elseif temp < 2 then
            bouns = bouns + yw * 2
            Message : AddMessage("性欲满足")
        elseif temp > 3 then
            bouns = bouns + yw * 5
            Message : AddMessage("性欲大满足")
        end
    end
    if Female.SemenDesire > 0 then
        local yw = Train.GetAbility("精液中毒")
        local temp = trainData.SemenDesire / Female.SemenDesire
        if temp < 1 then
        elseif temp < 2 then
            bouns = bouns + yw * 2
            Message : AddMessage("精液欲满足")
        elseif temp > 3 then
            bouns = bouns + yw * 5
            Message : AddMessage("精液欲大满足")
        end
    end

    if bouns > 0 then
        Message : AddMessage("BOUNS!!")
        Message : AddMessage(string.format("获得的宝珠增加了%d%%,反感之珠减少了%d%%", bouns))
    end
    if Female.Mark[3] == 3 then
        bouns = bouns - 60
        Message : AddMessage(string.format("由于反抗刻印获得的宝珠减少了%d%%,反感之珠增加了%d%%", 60))
    elseif Female.Mark[3] == 2 then
        bouns = bouns - 40
        Message : AddMessage(string.format("由于反抗刻印获得的宝珠减少了%d%%,反感之珠增加了%d%%", 40))
    elseif Female.Mark[3] == 1 then
        bouns = bouns - 20
        Message : AddMessage(string.format("由于反抗刻印获得的宝珠减少了%d%%,反感之珠增加了%d%%", 20))
    end
 
    trainData : ClothSetting("全部穿上")
    trainData : SetJuel(bouns)--转换珠子
    TrainPage : EndTrain()
    
    Female : AblUpdate()
    EventManager.SetListener("Update", Train.GoMainPage)
    Message : StartPop()
end

function Train.GoMainPage()
    EventManager.Clear("Update")
    GM : ClearPage()
    FactoryUpdate()
    FactoryView.NextTime()
end

function Train.Adjustment()
    local data = ActiveData.new()
    local multi = 0
    if Train.HaveTalent("接受快感") then
        multi = multi + 20
    end
    if Train.HaveTalent("冷漠") then
        multi = multi - 90
    end
    if Train.HaveTalent("两性通吃") then
        multi = multi + 10       
    elseif Train.HaveTalent("拒绝异性") then
        if tostring(Female.sex) == "男" and tostring(Trainer.sex) == "男" then
            multi = multi + 10
        elseif tostring(Female.sex) ~= "男" and tostring(Trainer.sex) ~= "男" then
            multi = multi + 10
        else
            multi = multi - 20
        end
    else
        if tostring(Female.sex) == "男" and tostring(Trainer.sex) == "男" then
            multi = multi - 20
        elseif tostring(Female.sex) ~= "男" and tostring(Trainer.sex) ~= "男" then
            multi = multi - 20
        else
            multi = multi + 10
        end
    end
    local Mood = Train.Mood()
    local m = math.floor(Mood / 30)
    local m1
    if Mood == 0 then
        m1 = -40
    elseif Mood == 1 then
        m1 = -20
    elseif Mood == 2 then
        m1 = -10
    else
        m1 = Mathf.Clamp(Mood - 70, 0, 100)
    end
    if Train.HaveTalent("淫乱") and m1 < 0 then
        m1 = 0
    elseif Train.HaveTalent("好色") and m1 < 0 then
        m1 = math.floor(m1 / 2)
    end
    if Train.HaveTalent("好色") and m1 > 0 then
        m1 = m1 + Mathf.Clamp(m1, 20 , 120)
    end
    local m2 = 0
    if Trainer : GetAbility("技巧") > Train.GetAbility("技巧") then
        m2 = 20
    else
        m2 = -20
    end

    Train.SixFeelAdd(data, multi)
    if m1 > 0 or (m1 < 0 and not Train.HaveTalent("淫核")) then
        data.C快乐 = data.C快乐 + m1
    end
    if m2 > 0 or (m2 < 0 and not Train.HaveTalent("C性向") and Train.GetAbility("C感觉") < 5) then
        data.C快乐 = data.C快乐 + m2
    end
    if Train.HaveTalent("淫核") then
        data.C快乐 = data.C快乐 + 20
    end
    if m1 > 0 or (m1 < 0 and not Train.HaveTalent("淫壶")) then
        data.V快乐 = data.V快乐 + m1
    end
    if m2 > 0 or (m2 < 0 and not Train.HaveTalent("V性向") and Train.GetAbility("V感觉") < 5) then
        data.V快乐 = data.V快乐 + m2
    end
    if Train.HaveTalent("淫尻") then
        data.A快乐 = data.A快乐 + 20
    end
    if m1 > 0 or (m1 < 0 and not Train.HaveTalent("淫尻")) then
        data.A快乐 = data.A快乐 + m1
    end
    if m2 > 0 or (m2 < 0 and not Train.HaveTalent("A性向") and Train.GetAbility("A感觉") < 5) then
        data.A快乐 = data.A快乐 + m2
    end
    if Train.HaveTalent("淫壶") then
        data.V快乐 = data.V快乐 + 20
    end
    if m1 > 0 or (m1 < 0 and not Train.HaveTalent("淫乳")) then
        data.B快乐 = data.B快乐 + m1
    end
    if m2 > 0 or (m2 < 0 and not Train.HaveTalent("B性向") and Train.GetAbility("B感觉") < 5) then
        data.B快乐 = data.B快乐 + m2
    end
    if Train.HaveTalent("荡唇") then
        data.M快乐 = data.M快乐 + 20
    end
    if m1 > 0 or (m1 < 0 and not Train.HaveTalent("荡唇")) then
        data.M快乐 = data.M快乐 + m1
    end
    if m2 > 0 or (m2 < 0 and not Train.HaveTalent("M性向") and Train.GetAbility("M感觉") < 5) then
        data.M快乐 = data.M快乐 + m2
    end
    if Train.HaveTalent("淫乳") then
        data.B快乐 = data.B快乐 + 20
    end
    if m1 > 0 or (m1 < 0 and not Train.HaveTalent("尿道狂")) then
        data.尿快乐 = data.尿快乐 + m1
    end
    if m2 > 0 or (m2 < 0 and not Train.HaveTalent("U性向") and Train.GetAbility("U感觉") < 5) then
        data.尿快乐 = data.尿快乐 + m2
    end
    if Train.HaveTalent("尿道狂") then
        data.尿快乐 = data.尿快乐 + 20
    end

    if Train.HaveTalent("母乳体质") then
        data.B快乐 = data.B快乐 + 50
    end
	if Female: HaveTalent("害羞") then
        data.露出 = data.露出 + 100
    elseif Female: HaveTalent("不知羞耻") then
        data.露出 = data.露出 - 50
    end
    if Train.HaveTalent("清楚") then
        data.露出 = data.露出+ 50
    end
	if Female: HaveTalent("好奇") then
        data.逸脱 = data.逸脱 - 30
    elseif Female: HaveTalent("保守") then
        data.逸脱 = data.逸脱 + 100
    end

    if Train.HaveTalent("好色") then
        data.逸脱 = data.逸脱 - 20
    end
    if Train.HaveTalent("淫乱") then
        data.逸脱 = data.逸脱 - 40
    end
    data.情爱 = enumtonumber(Female.Feel) * 10

    if not Female : HaveEquip(6) then
        data.露出 = data.露出+ 30
    end

    if trainData : CurrPlay("处女丧失") ~= 0 and enumtonumber(Female.Feel) >= 2 then
        data.情爱 = data.情爱 + 100
        data.达成感 = data.达成感 + 50
        data.疼痛 = data.疼痛 - 50
        data.逸脱 = data.逸脱 - 300
        data.反感追加 = data.反感追加 - 300
    elseif trainData : CurrPlay("处女丧失") ~= 0 then
        if Train.HaveTalent("贞操重视") then
            data.逸脱 = data.逸脱 + 200
            data.反感追加 = data.反感追加 + 200
        elseif Train.HaveTalent("不在乎贞操") then
            data.逸脱 = data.逸脱 + 25
            data.反感追加 = data.反感追加 + 25
        else
            data.逸脱 = data.逸脱 + 100
            data.反感追加 = data.反感追加 + 100
        end
    end
    if trainData : CurrPlay("同时绝顶") ~= 0 and enumtonumber(Female.Feel) > 0 then
        local n = trainData : CurrPlay("绝顶")
        data.情爱 = data.情爱 + n * 10
        data.达成感 = data.达成感 + n * 10
        data.恐惧 = data.恐惧 - n * 20
        data.反感追加 = data.反感追加 - n * 20
    end

    if Train.疲労() then
        data.情爱 = data.情爱 - 50
        data.不洁 = data.不洁 - 50
        data.充足 = data.充足 - 50
        data.达成感 = data.达成感 - 50
        data.性行动 = data.性行动 - 50
        data.欲情追加 = data.欲情追加 - 50
    end
    data.逸脱 = data.逸脱 - math.floor(trainData : GetValue("媚药") / 5)
    if trainData.equipItem : Contains("摄像机") or trainData.equipItem : Contains("野外PLAY") or trainData.equipItem : Contains("室内PLAY") then
        data.露出 = data.露出 + 20
    end


    data.逸脱 = data.逸脱 - math.max(math.min(Train.GetAbility("施虐属性"), 5), math.min(Train.GetAbility("受虐属性"), 5)) * 5
    if SexType("侍奉") then
        local n = Train.GetAbility("侍奉技术")
        if n == 1 then
            data.逸脱 = data.逸脱 - 5
        elseif n < 6 then
            data.逸脱 = data.逸脱 - 10
        elseif n < 10 then
            data.逸脱 = data.逸脱 - 20
        else
            data.逸脱 = data.逸脱 - 30
        end
    end
    if SexType("露出") then
        local n = Train.GetAbility("露出癖")
            data.逸脱 = data.逸脱 - 5
        if n < 6 then
            data.逸脱 = data.逸脱 - 10 * n
        elseif n < 10 then
            data.逸脱 = data.逸脱 - 5 * (n - 5) + 50
        else
            data.逸脱 = data.逸脱 - 75
        end
    end

    for key, value in pairs(data) do
        if key == "不洁" or key == "恐惧" or key == "逸脱" or key == "反感追加" then
            data[key] = math.max(value, -99);
        else    
            data[key] = math.max(value, -80);
        end
    end

    return data
end

function Train.AdjustTrainPack()
    local trainPack = ActiveData.Source()
    for key, value in pairs(trainPack) do
        trainPack[key] = 1
    end

    trainPack.快Ｃ = trainPack.快Ｃ * (Train.Estrus("C") * 0.5 + 1)
    trainPack.快Ｂ = trainPack.快Ｂ * (Train.Estrus("B") * 0.5 + 1)

    if tostring(Female.sex) == "男" then
        trainPack.快Ａ = 1.2
    end


    local t = trainData : GetValue("媚药")
    trainPack.快Ａ = trainPack.快Ａ + t / 100
    trainPack.快Ｂ = trainPack.快Ｂ + t / 100
    trainPack.快Ｃ = trainPack.快Ｃ + t / 100
    trainPack.快Ｍ = t / 100
    trainPack.快Ｖ = t / 100
    trainPack.快尿 = t / 100

    local level = Factory : GetSwitchValue("调教室等级")
    if level == 0 then
        trainPack.反感 = trainPack.反感 * 1.25
        trainPack.恐怖 = trainPack.恐怖 * 1.25
        trainPack.恭顺 = trainPack.恭顺 * 0.75
        trainPack.欲情 = trainPack.欲情 * 0.75
    elseif level == 1 then
        trainPack.反感 = trainPack.反感 * 0.9
        trainPack.恐怖 = trainPack.恐怖 * 0.9
    elseif level == 2 then
        trainPack.反感 = trainPack.反感 * 0.75
        trainPack.恐怖 = trainPack.恐怖 * 0.75
    elseif level == 3 then
        trainPack.反感 = trainPack.反感 * 0.5
        trainPack.恐怖 = trainPack.恐怖 * 0.5
        trainPack.习得 = trainPack.习得 * 1.2
        trainPack.恭顺 = trainPack.恭顺 * 0.2
    elseif level == 4 then
        trainPack.反感 = trainPack.反感 * 0.3
        trainPack.恐怖 = trainPack.恐怖 * 0.3
        trainPack.习得 = trainPack.习得 * 1.5
        trainPack.恭顺 = trainPack.恭顺 * 0.5
    end

    if Train.HaveTalent("软弱") then
        trainPack.恐怖 = trainPack.恐怖 * 2
        trainPack.反感 = trainPack.反感 * 0.7
    end
    if Train.HaveTalent("叛逆") then
        trainPack.恭顺 = trainPack.恭顺 * 0.75
        trainPack.欲情 = trainPack.欲情 * 0.5
        trainPack.反感 = trainPack.反感 * 1.5
    end
    if Train.HaveTalent("坚强") then
        trainPack.恭顺 = trainPack.恭顺 * 0.8
        trainPack.欲情 = trainPack.欲情 * 0.75
        trainPack.恐怖 = trainPack.恐怖 * 0.5
        trainPack.反感 = trainPack.反感 * 0.8
    end
    if Train.HaveTalent("坦率") then
        trainPack.恭顺 = trainPack.恭顺 * 2
        trainPack.反感 = trainPack.反感 * 0.8
    end
    if Train.HaveTalent("高傲") then
        trainPack.屈服 = trainPack.屈服 * 0.5
        trainPack.恐怖 = trainPack.恐怖 * 0.6
        trainPack.反感 = trainPack.反感 * 0.2
    end
    if Train.HaveTalent("谦虚") then
        trainPack.屈服 = trainPack.屈服 * 2
        trainPack.恐怖 = trainPack.恐怖 * 1.5
        trainPack.反感 = trainPack.反感 * 0.8
    end
    
    if Train.HaveTalent("强硬") then
        trainPack.羞耻 = trainPack.羞耻 * 0.8
        trainPack.恐怖 = trainPack.恐怖 * 0.5
    end
    if Train.HaveTalent("坏心眼") then
        trainPack.恭顺 = trainPack.恭顺 * 0.8
    end
    if Train.HaveTalent("冷漠") then
        trainPack.恭顺 = trainPack.恭顺 * 0.8
    end    
    if Train.HaveTalent("感情缺乏") then
        trainPack.恭顺 = trainPack.恭顺 * 0.5
        trainPack.欲情 = trainPack.欲情 * 0.5
        trainPack.屈服 = trainPack.屈服 * 0.7
        trainPack.羞耻 = trainPack.羞耻 * 0.8
        trainPack.恐怖 = trainPack.恐怖 * 0.6
        trainPack.反感 = trainPack.反感 * 0.5
    end
    if Train.HaveTalent("好奇") then
        trainPack.习得 = trainPack.习得 * 1.2
    elseif Train.HaveTalent("保守") then
        trainPack.习得 = trainPack.习得 * 0.8
    end  
    if Train.HaveTalent("容易迷恋") then
        trainPack.恭顺 = trainPack.恭顺 * 1.2
        trainPack.屈服 = trainPack.屈服 * 1.1
    end
    if Train.HaveTalent("清楚") then
        trainPack.恭顺 = trainPack.恭顺 * 1.2
        trainPack.羞耻 = trainPack.羞耻 * 1.5
    end
    if Train.HaveTalent("发情体质") then
        trainPack.欲情 = trainPack.欲情 * 1.5
    end
    if Train.HaveTalent("聪慧") then
        trainPack.习得 = trainPack.习得 * 2
    elseif Train.HaveTalent("愚笨") then
        trainPack.习得 = trainPack.习得 * 0.7
    end
    if Train.HaveTalent("献身") then
        trainPack.屈服 = trainPack.屈服 * 1.5
        trainPack.习得 = trainPack.习得 * 1.5
    end

    if Train.HaveTalent("接受快感") then
        trainPack.欲情 = trainPack.欲情 * 1.5
    elseif Train.HaveTalent("否定快感") then
        trainPack.欲情 = trainPack.欲情 * 0.5
    end
    if Train.HaveTalent("好色") then
        trainPack.欲情 = trainPack.欲情 * 1.2
        trainPack.羞耻 = trainPack.羞耻 * 0.8
    end
    if (Train.HaveTalent("好色") or (Train.HaveTalent("接受快感")) and SexType("性交")) then
        trainPack.欲情 = trainPack.欲情 * 1.3
        trainPack.恐怖 = trainPack.恐怖 * 0.5
        trainPack.反感 = trainPack.反感 * 0.5
    end
    if Train.HaveTalent("倒错") then
        trainPack.恐怖 = trainPack.恐怖 * 0.5
        trainPack.反感 = trainPack.反感 * 0.8
        if SexType("异常") then
            trainPack.欲情 = trainPack.欲情 * 1.3
            trainPack.反感 = trainPack.反感 * 0.7
        end
    end
    trainPack.反感 = trainPack.反感 - enumtonumber(Female.Feel) * 15
    local drive = Female.Drive / 100

    if Train.HaveTalent("开朗") or Train.HaveTalent("聪慧") then
        trainPack.恐怖 = trainPack.恐怖 * 0.5 - drive
        trainPack.反感 = trainPack.反感 * 0.8 - drive
    else
        trainPack.恐怖 = trainPack.恐怖 * 0.9 - drive
        trainPack.反感 = trainPack.反感 * 0.9 - drive
    end
    trainPack.习得 = trainPack.习得 + drive
    trainPack.羞耻 = trainPack.羞耻 - drive

    if Female.Oestrus then
        trainPack.欲情 = trainPack.欲情 * 2
        trainPack.屈服 = trainPack.屈服 * 0.5
        trainPack.习得 = trainPack.习得 * 0.5
        trainPack.羞耻 = trainPack.羞耻 * 0.5
        trainPack.恐怖 = trainPack.恐怖 * 0.5
        trainPack.反感 = trainPack.反感 * 0.5
    end
    trainPack.反感 = trainPack.反感 * (1 + (Female.Mark[1] / 10))

    if trainData.Posture == "六九式" then
        trainPack.欲情 = trainPack.欲情 * 1.5
        trainPack.羞耻 = trainPack.羞耻 * 1.5
    end
    local sn = Train.GetAbility("受虐属性")
    if Train.Pos["眼"] == "眼罩" then
        trainPack.恭顺 = trainPack.恭顺 * (((math.min(sn, 5) * 5 - 10) / 100) + 1)
		trainPack.欲情 = trainPack.欲情 * (((math.min(sn, 5) * 5 - 10) / 100) + 1)
        trainPack.屈服 = trainPack.屈服 * 1.2
        trainPack.习得 = trainPack.习得 * 0.5
        trainPack.恐怖 = trainPack.恐怖 * 1.2
    end
    if Train.Pos["活动"] == "拘束" then
        trainPack.痛苦 = trainPack.痛苦 * 0.7
        trainPack.羞耻 = trainPack.羞耻 * 0.7
        trainPack.恐怖 = trainPack.恐怖 * 0.7
        trainPack.恭顺 = trainPack.恭顺 * 0.8 * (1 - (math.min(sn, 5) * 5 / 100))
        trainPack.欲情 = trainPack.欲情 * (((math.min(sn, 5) * 5 - 10) / 100) + 1)
        trainPack.习得 = trainPack.习得 * 0.8
        trainPack.屈服 = trainPack.屈服 * 1.2
    end
    if Train.Pos["嘴"] == "口枷" then
        trainPack.恐怖 = trainPack.恐怖 * 1.1
        trainPack.恭顺 = trainPack.恭顺 * 0.8 * (1 - (math.min(sn, 5) * 5) / 100)
        trainPack.欲情 = trainPack.欲情 * (1 + (math.min(sn, 5) * 5 - 10) / 100)
        trainPack.习得 = trainPack.习得 * 0.9
        trainPack.屈服 = trainPack.屈服 * 1.2
    end
    if trainData.equipItem : Contains("浣肠") or trainData.Active == "排泄" then
        local c = (trainData : GetValue("肠液") * 10 + 10) / 100 + 1
        if trainData.Active == "排泄" then
            c = 2
        end
        trainPack.恐怖 = trainPack.恐怖 * c * 1.5
        trainPack.屈服 = trainPack.屈服 * c * 1.5
        trainPack.恭顺 = trainPack.恭顺 * c * 0.5 * (1 - (math.min(sn, 5) *5) / 100)
        trainPack.习得 = trainPack.习得 * c * 0.5
    end
    local tech = Trainer : GetAbility("技巧") - Train.GetAbility("技巧") 
    if tech >= 5 then
        trainPack.习得 = trainPack.习得 * 1.5
    elseif tech >= 3 then
        trainPack.习得 = trainPack.习得 * 1.3
    elseif tech >= 1 then
        trainPack.习得 = trainPack.习得 * 1.1
    end
    if trainData.equipItem : Contains("媚药") then
        local m = trainData : GetValue("媚药") / 100
        trainPack.恭顺 = trainPack.恭顺 * (1 - m)
        trainPack.习得 = trainPack.习得 * (1 - m)
        trainPack.痛苦 = trainPack.痛苦 * (1 - m)
        trainPack.恐怖 = trainPack.恐怖 * (1 - m)
        trainPack.反感 = trainPack.反感 * (1 - m)
        trainPack.欲情 = trainPack.欲情 * (1 + m / 2)
    end
    local mo = math.floor(Train.Mood() / 5) / 100
    trainPack.恭顺 = trainPack.恭顺 * (1 + mo)
    trainPack.欲情 = trainPack.欲情 * (1 + mo)
    trainPack.恐怖 = trainPack.恐怖 * (1 - mo)
    trainPack.反感 = trainPack.反感 * (1 - mo)

    if trainData.SameActive then
        trainPack.习得 = trainPack.习得 * 1.5
    end

    if Train.疲労() then
        trainPack.恭顺 = trainPack.恭顺 * 0.1
        trainPack.欲情 = trainPack.欲情 * 0.1
        trainPack.习得 = trainPack.习得 * 0.1
        trainPack.反感 = trainPack.反感 * 1.2
    end

    local nh = trainData.Source : get_Item("润滑")
    if nh > 10000 then
        trainPack.润滑 = trainPack.润滑 * 0.1
    elseif nh > 30000 then
        trainPack.润滑 = trainPack.润滑 * 0.01
    elseif nh > 60000 then
        trainPack.润滑 = trainPack.润滑 * 0.001
    end

    for key, value in pairs(trainPack) do
        if key == "恐怖" or key == "反感" then
            trainPack[key] = math.max(value, 0.1)
        else
            trainPack[key] = math.max(value, 0.2)
        end
    end

    return trainPack
end

function Train.疲労()
    return Female.CurrentHP / Female.Info.HP < 0.3
end



function Train.SixFeelAdd(data, num)
    data.C快乐 = data.C快乐 + num
    data.A快乐 = data.A快乐 + num
    data.V快乐 = data.V快乐 + num
    data.M快乐 = data.M快乐 + num
    data.B快乐 = data.B快乐 + num
    data.尿快乐 = data.尿快乐 + num
end

function Train.Mood()
    local temp = Female.Mood
    local n = trainData.Source : get_Item("恭顺") + trainData.Source : get_Item("欲情")
    if n > 240000 then
        temp = temp + 25
    elseif n > 120000 then
        temp = temp + math.floor((n - 120000) / 24000) + 20
    elseif n > 60000 then
        temp = temp + math.floor((n - 60000) / 12000) + 15
    elseif n > 30000 then
        temp = temp + math.floor((n - 30000) / 6000) + 10
    elseif n > 10000 then
        temp = temp + math.floor((n - 10000) / 4000) + 5
    else
        temp = temp + math.floor(n / 2000)
    end
    local bad = 0
    if CSourcePack ~= nil then
        bad = CSourcePack.反感 + trainData.Source : get_Item("反感") + CSourcePack.恐怖 + trainData.Source : get_Item("恐怖")
    else
        bad =  trainData.Source : get_Item("反感") + trainData.Source : get_Item("恐怖")
    end
    bad = math.floor(bad / 100)
    temp = temp - bad
    temp = Mathf.Clamp(temp, 0, 240)
    return temp
end

function Train.SettleTrain(data)
    local yuwan = Train.GetAbility("欲望")
    local SC = Train.GetAbility("顺从")
    local SN = Train.GetAbility("受虐属性")
    local LC = Train.GetAbility("露出癖")

    local trainPack = ActiveData.Source()
    trainPack.快Ｃ = data.C快乐
    trainPack.快Ｖ = data.V快乐
    trainPack.快Ａ = data.A快乐
    trainPack.快Ｂ = data.B快乐
    trainPack.快Ｍ = data.M快乐
    trainPack.快尿 = data.尿快乐


    local elseValue = DownPalamLv(data.C快乐 + data.V快乐 + data.A快乐 + data.B快乐 + data.M快乐 + data.尿快乐)
    trainPack.恭顺 = elseValue * (Mathf.Min(yuwan, 10) + 2) * 2 / 150
    trainPack.欲情 = elseValue * (Mathf.Min(yuwan, 10) + 2) * 2 / 100
    trainPack.屈服 = elseValue * (Mathf.Min(yuwan, 10) + 10) * 2 / 400
    local i = 0
    if Train.HaveTalent("淫核")  then
        i = i + data.C快乐
    elseif Train.HaveTalent("淫壶")  then
        i = i + data.V快乐
    elseif Train.HaveTalent("淫尻")  then
        i = i + data.A快乐
    elseif Train.HaveTalent("淫乳")  then
        i = i + data.B快乐
    elseif Train.HaveTalent("荡唇")  then
        i = i + data.M快乐
    elseif Train.HaveTalent("尿道狂")  then
        i = i + data.尿快乐
    end

    local SP = GetPalamLV(i) * 500
    data.充足 = data.充足 + SP * (Mathf.Min(yuwan, 10) + 2) * 2 / 100

    if SC <= 5 then 
        trainPack.恭顺 = trainPack.恭顺 + data.情爱 * (40 + SC * 10) / 100
    elseif SC <= 10 then
        trainPack.恭顺 = trainPack.恭顺 + data.情爱 * (90 + (SC - 5) * 5) / 100
    else
        trainPack.恭顺 = trainPack.恭顺 + data.情爱 * (115 + (SC - 10) * 1) / 100
    end

    if yuwan <= 5 then
        trainPack.欲情 = trainPack.欲情 + data.情爱 * yuwan * 6 / 100
    elseif yuwan <= 10 then
        trainPack.欲情 = trainPack.欲情 + data.情爱 * (30 + (yuwan - 5) * 3) / 100
    else
        trainPack.欲情 = trainPack.欲情 + data.情爱 * (45 + (yuwan - 10) * 1) / 100
    end
    --绝顶和0：干劲判断
    if trainData : GetValue("高潮") > 0 and Female.boolSwitch[0] then
        data.性行动 = data.性行动 * 2
    end
    local SF = Train.GetAbility("侍奉技术")
    if data.达成感 ~= 0 then
        if SF <= 5 then
            trainPack.习得 = data.性行动 * (100 + SF * 20) / 100
            trainPack.恭顺 = trainPack.恭顺 + data.达成感 * (40 + SF * 20) / 100
        elseif SF <= 10 then
            trainPack.习得 = data.性行动 * (200 + (SF - 5) * 10) / 100
            trainPack.恭顺 = trainPack.恭顺 + data.达成感 * (140 + (SF - 5) * 10) / 100
        else
            trainPack.习得 = data.性行动 * (250 + (SF - 10) * 2) / 100
            trainPack.恭顺 = trainPack.恭顺 + data.达成感 * (190 + (SF - 10) * 2) / 100
        end
    end
    if data.疼痛 ~= 0 then
        local 恐怖 = 0
        local 反感 = 0
        local 欲情 = 0

        if SC <= 5 then
            恐怖 = data.疼痛 * (80 - SC * 8) / 100
        elseif SC <= 10 then
            恐怖 = data.疼痛 * (40 - (SC - 5) * 4) / 100
        else
            恐怖 = data.疼痛 * ((Mathf.Max(20 - (SC - 10) * 1,1)) * 1) / 100
        end

        if SN <= 5 then
            欲情 = data.疼痛 * (SN * 15) / 100
        elseif SN <= 10 then
            欲情 = data.疼痛 * (75 + (SN - 5) * 5) / 100
        else
            欲情 = data.疼痛 * (100 + (SN - 10)) * 2 / 100
        end

        if SN+SC <= 5 then
            反感 = data.疼痛 * (80 - (SN+SC) * 10) / 100
        elseif SN+SC <= 10 then
            反感 = data.疼痛 * (30 - (SN+SC - 5) * 5) / 100
        else
            反感 = data.疼痛 * (5 + (SN+SC - 10) * 1) / 100
        end

        if Train.HaveTalent("倒错") then
            恐怖 = 恐怖 * 0.5
            反感 = 反感 * 0.5
            欲情 = 欲情 * 2
        end

        if Train.Pos["活动"] == "拘束" then
            恐怖 = 恐怖 * 2
        end

        trainPack.痛苦 = trainPack.痛苦 + data.疼痛
        trainPack.恐怖 = trainPack.恐怖 + 恐怖
        trainPack.反感 = trainPack.反感 + 反感
        trainPack.欲情 = trainPack.欲情 + 欲情
        trainPack.屈服 = trainPack.反感 + data.疼痛 + 恐怖 / 2 + 欲情
    end

    if data.充足 ~= 0 then
        local 恭顺 = 0
        local 欲情 = 0

        if yuwan <= 5 then
            恭顺 = data.充足 * (20 + yuwan * 6) / 100
            欲情 = data.充足 * (30 + yuwan * 6) / 100
        elseif yuwan <= 10 then
            恭顺 = data.充足 * (50 + (yuwan - 5) * 4) / 100
            欲情 = data.充足 * (60 + (yuwan - 5) * 4) / 100
        else
            恭顺= data.充足 * (70 + (yuwan - 10) * 1) / 100
            欲情= data.充足 * (80 + (yuwan - 10) * 1) / 100
        end
        trainPack.恭顺 = trainPack.恭顺 + 恭顺
        trainPack.欲情 = trainPack.欲情 + 欲情
        trainPack.屈服 = trainPack.屈服 + 恭顺 + 欲情
    end

    if data.不洁 ~= 0 then
        local 欲情 = data.不洁
        local 反感 = 0

        local temp = math.max(SC, yuwan)
        if temp <= 5 then
            反感 = data.不洁 * (100 - temp * 10) / 100
        elseif temp <= 10 then
            反感 = data.不洁 * (50 - (temp - 5) * 10) / 100
        else
            反感 = data.不洁 * (25 - (temp - 10) * 10) / 100
        end
        if(SN <= 10) then
            反感 = 反感 * (100 - SN * 10) / 100
        else
            反感 = 0
        end

        if Train.HaveTalent("倒错") then
            反感 = 反感 * 0.5
        end

        if 反感 <= 100 then
            反感 = 0
            欲情 = 欲情 / 10
        elseif 反感 <= 500 then
            欲情 = 欲情 / 20
        else
            欲情 = 0
        end

        trainPack.反感 = trainPack.反感 + 反感
        trainPack.欲情 = trainPack.欲情 + 欲情
    end
    if data.露出 ~= 0 then
        local 羞耻 = data.露出
        local 欲情 = 0
        local 反感 = 0

        if LC <= 5 then
            欲情 = data.露出 * (5 + LC * 11) / 100
        elseif LC <= 10 then
            欲情 = data.露出 * (60 + (LC - 5) * 6) / 100
        else
            欲情 = data.露出 * (90 + (LC - 10) * 2) / 100
        end
        local temp = math.max(SC, yuwan)
        if temp <= 5 then
            反感 = data.露出 * (30 + temp * 4) / 100
        elseif temp <= 10 then
            反感 = data.露出 * (10 + (temp - 5)) / 100
        else
            反感 = data.露出 * (5 + (temp - 10)) / 100
        end

        if Train.HaveTalent("倒错") then
            反感 = 反感 * 0.5
            欲情 = 欲情 * 1.5
        end
        if Train.HaveTalent("表现欲") then
            反感 = 反感 * 0.1
        end
        trainPack.反感 = trainPack.反感 + 反感
        trainPack.欲情 = trainPack.欲情 + DownPalamLv(欲情)
        trainPack.羞耻 = trainPack.羞耻 + 羞耻
    end
    if data.屈服 ~= 0 then 
        trainPack.屈服 = data.屈服
    end

    if data.逸脱 ~= 0 then
        local 欲情 = data.逸脱
        local 反感 = 0

        local temp = math.max(SC, yuwan)
        if temp <= 5 then
            反感 = data.逸脱 * (80 - temp * 10) / 100
        elseif temp <= 10 then
            反感 = data.逸脱 * (30 - (temp - 5) * 5) / 100
        else
            反感 = data.逸脱 * (5 - (temp - 10) * 1) / 100
        end

        if Train.HaveTalent("倒错") or Train.HaveTalent("好奇心") then
            反感 = 反感 * 0.5
        end
        if SN >= 3 then
            反感 = 反感 * 0.5
        end

        if Train.HaveTalent("倒错") and SN >= 3 then
            欲情 = 欲情 * 0.5
        elseif Train.HaveTalent("倒错") or SN >= 3 then
            欲情 = 欲情 * 0.2
        else
            欲情 = 0
        end
        trainPack.欲情 = trainPack.欲情 + 欲情
        trainPack.反感 = trainPack.反感 + 反感
    end

    trainPack.恐怖 = trainPack.恐怖 + data.恐惧
    trainPack.润滑 = trainPack.润滑 + data.液体追加
    trainPack.恭顺 = trainPack.恭顺 + data.恭顺追加
    trainPack.欲情 = trainPack.欲情 + data.欲情追加
    if data.反感追加 ~= 0 then
        if SC <= 5 then
            trainPack.反感 = trainPack.反感 + data.反感追加 * (100 - SC * 10) / 100
        elseif SC <= 10 then
            trainPack.反感 = trainPack.反感 + data.反感追加 * (50 - (SC - 5) * 8) / 100
        else
            trainPack.反感 = trainPack.反感 + data.反感追加 * (10 - (SC - 10) * 1) / 100
        end
    end
   
    local Bfeel = Train.GetAbility("A感觉")
    if Train.GetAbility("淫乳") then
        Bfeel = Bfeel + 1
    end
    trainPack.快Ｂ = Train.PleasureLimiter(trainPack.快Ｂ, Bfeel)
    local Afeel = Train.GetAbility("A感觉")
    if Train.GetAbility("淫尻") then
        Afeel = Afeel + 1
    end
    trainPack.快Ａ = Train.PleasureLimiter(trainPack.快Ａ, Afeel)
    local Cfeel = Train.GetAbility("C感觉")
    if Train.GetAbility("淫核") then
        Cfeel = Cfeel + 1
    end
    trainPack.快Ｃ = Train.PleasureLimiter(trainPack.快Ｃ, Cfeel)

    local Mfeel = Train.GetAbility("M感觉")
    if Train.GetAbility("荡唇") then
        Mfeel = Mfeel + 1
    end
    trainPack.快Ｍ = Train.PleasureLimiter(trainPack.快Ｍ, Mfeel)

    local Vfeel = Train.GetAbility("V感觉")
    if Train.GetAbility("淫壶") then
        Vfeel = Vfeel + 1
    end
    trainPack.快Ｖ = Train.PleasureLimiter(trainPack.快Ｖ, Vfeel)

    local nfeel = Train.GetAbility("尿感觉")
    if Train.GetAbility("尿道狂") then
        nfeel = nfeel + 1
    end
    trainPack.快尿 = Train.PleasureLimiter(trainPack.快尿, nfeel)

    if trainData.SameActive then
        trainPack.快尿 = trainPack.快尿 * 1.25
        trainPack.快Ｖ = trainPack.快Ｖ * 1.25
        trainPack.快Ｍ = trainPack.快Ｍ * 1.25
        trainPack.快Ｃ = trainPack.快Ｃ * 1.25
        trainPack.快Ａ = trainPack.快Ａ * 1.25
        trainPack.快Ｂ = trainPack.快Ｂ * 1.25
    end

    if trainPack.痛苦 >= 100 then
        local i = Mathf.Clamp(100 - GetPalamLV(trainPack.痛苦) * 20 + Train.GetAbility("受虐属性") * 20, 10, 150)
        trainPack.快尿 = trainPack.快尿 * i / 100
        trainPack.快Ｖ = trainPack.快Ｖ * i / 100
        trainPack.快Ｍ = trainPack.快Ｍ * i / 100
        trainPack.快Ｃ = trainPack.快Ｃ * 1 / 100
        trainPack.快Ａ = trainPack.快Ａ * 1 / 100
        trainPack.快Ｂ = trainPack.快Ｂ * 1 / 100
        Train.HPDown = Train.HPDown * (100 + (GetPalamLV(trainPack.痛苦) * (GetPalamLV(trainPack.痛苦) + 1) / 2) * 10 ) / 100
    end
    local friend = Female.Friend
    if friend <= -50 then
        trainPack.恭顺 = trainPack.恭顺 * 0.2
        trainPack.反感 = trainPack.反感 * 1.5
    elseif friend <= 0 then
        trainPack.恭顺 = trainPack.恭顺 * 0.5
        trainPack.反感 = trainPack.反感 * 1.2
    elseif friend <= 50 then
        trainPack.恭顺 = trainPack.恭顺 * 0.8
        trainPack.反感 = trainPack.反感 * 1
    elseif friend <= 100 then
        trainPack.恭顺 = trainPack.恭顺 * 1
        trainPack.反感 = trainPack.反感 * 0.8
    elseif friend <= 500 then
        trainPack.恭顺 = trainPack.恭顺 * 1.2
        trainPack.反感 = trainPack.反感 * 0.5
    elseif friend <= 1000 then      
        trainPack.恭顺 = trainPack.恭顺 * 1.4
        trainPack.反感 = trainPack.反感 * 0.4
    elseif friend <= 2000 then 
        trainPack.恭顺 = trainPack.恭顺 * 1.6
        trainPack.反感 = trainPack.反感 * 0.3
    elseif friend <= 10000 then      
        trainPack.恭顺 = trainPack.恭顺 * 1.8
        trainPack.反感 = trainPack.反感 * 0.2
    else
        trainPack.恭顺 = trainPack.恭顺 * 2
        trainPack.反感 = trainPack.反感 * 0.1
    end
    local Obedience = Female.Obedience
    if Obedience <= -50 then
        trainPack.屈服 = trainPack.屈服 * 0.2
        trainPack.习得 = trainPack.习得 * 0.2
    elseif Obedience <= 0 then
        trainPack.屈服 = trainPack.屈服 * 0.5
        trainPack.习得 = trainPack.习得 * 0.5
    elseif Obedience <= 50 then
        trainPack.屈服 = trainPack.屈服 * 0.75
        trainPack.习得 = trainPack.习得 * 0.75
    elseif Obedience <= 100 then
        trainPack.屈服 = trainPack.屈服 * 0.9
        trainPack.习得 = trainPack.习得 * 0.9
    elseif Obedience <= 500 then
        trainPack.屈服 = trainPack.屈服 * 1.1
        trainPack.习得 = trainPack.习得 * 1.1
    elseif Obedience <= 2000 then      
        trainPack.屈服 = trainPack.屈服 * 1.3
        trainPack.习得 = trainPack.习得 * 1.3
    elseif Obedience <= 5000 then 
        trainPack.屈服 = trainPack.屈服 * 1.5
        trainPack.习得 = trainPack.习得 * 1.5
    elseif Obedience <= 10000 then      
        trainPack.屈服 = trainPack.屈服 * 1.8
        trainPack.习得 = trainPack.习得 * 1.8
    else
        trainPack.屈服 = trainPack.屈服 * 2
        trainPack.习得 = trainPack.习得 * 2
    end
    local Happy = 1
    local Depraved = Female.Depraved
    if Depraved <= -50 then
        trainPack.欲情 = trainPack.欲情 * 0.2
        Happy =  0.2
    elseif Depraved <= 0 then
        trainPack.欲情 = trainPack.欲情 * 0.5
        Happy = 0.5
    elseif Depraved <= 200 then
        trainPack.欲情 = trainPack.欲情 * 0.8
        Happy = 0.8
    elseif Depraved <= 500 then
        trainPack.欲情 = trainPack.欲情 * 1
        Happy = 1
    elseif Depraved <= 1000 then
        trainPack.欲情 = trainPack.欲情 * 1.2
        Happy = 1.2
    elseif Depraved <= 2000 then      
        trainPack.欲情 = trainPack.欲情 * 1.4
        Happy = 1.4
    elseif Depraved <= 5000 then 
        trainPack.欲情 = trainPack.欲情 * 1.6
        Happy = 1.6
    elseif Depraved <= 10000 then      
        trainPack.欲情 = trainPack.欲情 * 1.8
        Happy = 1.8
    else
        trainPack.欲情 = trainPack.欲情 * 2
        Happy = 2
    end

    trainPack.快尿 = trainPack.快尿 * Happy 
    trainPack.快Ａ = trainPack.快Ａ * Happy 
    trainPack.快Ｂ = trainPack.快Ｂ * Happy 
    trainPack.快Ｃ = trainPack.快Ｃ * Happy 
    trainPack.快Ｍ = trainPack.快Ｍ * Happy 
    trainPack.快Ｖ = trainPack.快Ｖ * Happy 

    if trainPack.恐怖 <= 10 then
        trainPack.恐怖 = 0
    end
    if trainPack.反感 <= 10 then
        trainPack.反感 = 0
    end
    return trainPack
end

function Train.TrainlHandle()
    CtrainPack = SexActive(trainData.Active, trainData.Select)
    local adjustPack = Train.Adjustment()
    for key, value in pairs(CtrainPack) do
        CtrainPack[key] = value * ((100 + adjustPack[key]) / 100)
    end
    Train.HPHandle()
    if CtrainPack.Samen > 0 and Trainer.IsJJ then
        Train.EjaculateCheck()
        Train.SamenHandle()
    end

    local CSourcePack = Train.SettleTrain(CtrainPack)
    local adjustTrainPack = Train.AdjustTrainPack()
    for key, value in pairs(CSourcePack) do
        CSourcePack[key] = value * adjustTrainPack[key]
        if key == "恐怖" or key == "反感" then
            if CSourcePack[key] < 10 then
                CSourcePack[key] = 0
            end
        end
        if CSourcePack[key] > 0 and CSourcePack[key] < adjustTrainPack[key] then
            CSourcePack[key] = adjustTrainPack[key]
        end
    end

    if Train.HaveTalent("A性向") or Train.HaveTalent("淫尻") then
        CSourcePack.快Ａ = CSourcePack.快Ａ * 2
    end
    if Train.HaveTalent("B性向") or Train.HaveTalent("淫乳") then
        CSourcePack.快Ｂ = CSourcePack.快Ｂ * 2
    end
    if Train.HaveTalent("C性向") or Train.HaveTalent("淫核") then
        CSourcePack.快Ｃ = CSourcePack.快Ｃ * 2
    end
    if Train.HaveTalent("V性向") or Train.HaveTalent("淫壶") then
        CSourcePack.快Ｖ = CSourcePack.快Ｖ * 2
    end
    if Train.HaveTalent("M性向") or Train.HaveTalent("荡唇") then
        CSourcePack.快Ｍ = CSourcePack.快Ｍ * 2
    end
    if Train.HaveTalent("U性向") or Train.HaveTalent("尿道狂") then
        CSourcePack.快尿 = CSourcePack.快尿 * 2
    end
    if CSourcePack.快Ｃ > 0 then
        local n = Train.GetAbility("C感觉")
        if Train.HaveTalent("淫核") then
            n = n + 1
        end
        if Train.HaveTalent("C性向") then
            n = n + 1
        end
        CSourcePack.快Ｃ = Train.PleasureLimiter(CSourcePack.快Ｃ, n)
    end
    if CSourcePack.快Ｖ > 0 then
        local n = Train.GetAbility("V感觉")
        if Train.HaveTalent("淫壶") then
            n = n + 1
        end
        if Train.HaveTalent("V性向") then
            n = n + 1
        end
        CSourcePack.快Ｖ = Train.PleasureLimiter(CSourcePack.快Ｖ, n)
    end
    if CSourcePack.快Ａ > 0 then
        local n = Train.GetAbility("A感觉")
        if Train.HaveTalent("淫尻") then
            n = n + 1
        end
        if Train.HaveTalent("A性向") then
            n = n + 1
        end
        CSourcePack.快Ａ = Train.PleasureLimiter(CSourcePack.快Ａ, n)
    end
    if CSourcePack.快Ｂ > 0 then
        local n = Train.GetAbility("B感觉")
        if Train.HaveTalent("淫乳") then
            n = n + 1
        end
        if Train.HaveTalent("B性向") then
            n = n + 1
        end
        CSourcePack.快Ｂ = Train.PleasureLimiter(CSourcePack.快Ｂ, n)
    end
    if CSourcePack.快Ｍ > 0 then
        local n = Train.GetAbility("M感觉")
        if Train.HaveTalent("荡唇") then
            n = n + 1
        end
        if Train.HaveTalent("M性向") then
            n = n + 1
        end
        CSourcePack.快Ｍ = Train.PleasureLimiter(CSourcePack.快Ｍ, n)
    end
    if CSourcePack.快尿 > 0 then
        local n = Train.GetAbility("尿感觉")
        if Train.HaveTalent("尿道狂") then
            n = n + 1
        end
        if Train.HaveTalent("U性向") then
            n = n + 1
        end
        CSourcePack.快尿 = Train.PleasureLimiter(CSourcePack.快尿, n)
    end
    if trainData.SameActive then
        CSourcePack.快Ｃ = CSourcePack.快Ｃ * 1.25
        CSourcePack.快Ｖ = CSourcePack.快Ｖ * 1.25
        CSourcePack.快Ａ = CSourcePack.快Ａ * 1.25
        CSourcePack.快Ｂ = CSourcePack.快Ｂ * 1.25
        CSourcePack.快Ｍ = CSourcePack.快Ｍ * 1.25
        CSourcePack.快尿 = CSourcePack.快尿 * 1.25
    end
    if CSourcePack.痛苦 >= 100 then
        local n = Mathf.Clamp(100 - GetPalamLV(CSourcePack.痛苦) * 20 + Train.GetAbility("受虐属性") * 20, 10, 110)
        CSourcePack.快Ｃ = CSourcePack.快Ｃ * (n / 100)
        CSourcePack.快Ｖ = CSourcePack.快Ｖ * (n / 100)
        CSourcePack.快Ａ = CSourcePack.快Ａ * (n / 100)
        CSourcePack.快Ｂ = CSourcePack.快Ｂ * (n / 100)
        CSourcePack.快Ｍ = CSourcePack.快Ｍ * (n / 100)
        CSourcePack.快尿 = CSourcePack.快尿 * (n / 100)

        trainData.DownHP = (100 + (GetPalamLV(CSourcePack.痛苦) * (GetPalamLV(CSourcePack.痛苦) + 1) / 2) * 10) / 100 * trainData.DownHP
    end
    return CSourcePack
end

function Train.HPHandle()
    local waist = false
    local strength = false
    local tits = false
    local mouse = false
    local hand = false

    if SexType("爱抚") then
        Train.HPDown = Train.HPDown + 50
    elseif SexType("道具") then
        Train.HPDown = Train.HPDown + 100
    elseif SexType("性交") then
        Train.HPDown = Train.HPDown + 100
        waist = true
    elseif trainData.Active == "磨镜" then
        Train.HPDown = Train.HPDown + 150
        waist = true
    elseif trainData.Active == "双乳间抽插" then
        Train.HPDown = Train.HPDown + 100
        tits = true
    elseif trainData.Active == "口交" then
        Train.HPDown = Train.HPDown + 150
        if Train.Pos["嘴"] == "JJ" then
            Train.HPDown = Train.HPDown + 50
        end
        mouse = true
    elseif trainData.Active == "强制口交" then
        Train.HPDown = Train.HPDown + 200
        if Train.Pos["嘴"] == "JJ" then
            Train.HPDown = Train.HPDown + 50
        end
        mouse = true
    elseif trainData.Select == "深喉" then
        Train.HPDown = Train.HPDown + 50
        mouse = true
    elseif trainData.Active == "肛门侍奉" or trainData.Active == "舔阴侍奉" then
        Train.HPDown = Train.HPDown + 50
        mouse = true
    elseif trainData.Active == "手淫" then
        Train.HPDown = Train.HPDown + 100
        hand = true
    elseif trainData.Active == "素股" then
        Train.HPDown = Train.HPDown + 100
        tits = true
    elseif trainData.Active == "乳交" then
        Train.HPDown = Train.HPDown + 100
        tits = true
    elseif trainData.Active == "泡泡浴" then
        Train.HPDown = Train.HPDown + 100
        tits = true
        waist = true
    elseif SexType("侍奉") then
        Train.HPDown = Train.HPDown + 100
    elseif SexType("轻度SM") then
        Train.HPDown = Train.HPDown + 50
    elseif SexType("中度SM") then
        Train.HPDown = Train.HPDown + 100
    elseif SexType("重度SM") then
        Train.HPDown = Train.HPDown + 200
    end
    if Train.PoChu ~= nil then
        Train.HPDown = Train.HPDown + 50
    end
    local hpdown = Train.HPDown
    Train.HPDown = Female.Info.HP * 0.1 * (Train.HPDown / 100)
    Train.HPDown = math.min(Train.HPDown, hpdown)
    Train.HPDown = math.ceil(Train.HPDown)
end


function Train.MarkGetCheck()
    local happy = math.max(CSourcePack.快尿, CSourcePack.快Ａ, CSourcePack.快Ｂ, CSourcePack.快Ｃ, CSourcePack.快Ｍ, CSourcePack.快Ｖ,
    (CSourcePack.快尿 + CSourcePack.快Ａ + CSourcePack.快Ｂ + CSourcePack.快Ｃ + CSourcePack.快Ｍ + CSourcePack.快Ｖ) / 2)
    local happyMark = 0
    if happy > 30000 then
        happyMark = 3
    elseif happy > 10000 then
        happyMark = 2
    elseif happy > 3000 then
        happyMark = 1
    end

    if happyMark > Female.Mark[0] then
        local text = "取得了快乐刻印Lv"..happyMark
        Female.Mark[0] = happyMark
        if Train.GetAbility("顺从") < happyMark - 1 and not Train.HaveTalent("冷漠") and not Train.HaveTalent("感情缺乏") then
            Female : AddAbility("顺从", 1)
            AbliTable["顺从"] = nil
            text = text.."\n同时顺从变成了Lv"..Female : GetAbility("顺从")
        end
        Message : AddMessage(text)
    end

    local pain = CSourcePack.痛苦
    local painMark = 0
    if pain > 30000 then
        painMark = 3
    elseif pain > 20000 then
        painMark = 2
    elseif pain > 10000 then
        painMark = 1
    end
    if painMark > Female.Mark[1] then
        local text = "取得了痛苦刻印Lv"..painMark
        Female.Mark[1] = painMark
        Message : AddMessage(text)
    end

    local surrender = CSourcePack.屈服
    local surrenderMark = 0
    if surrender > 30000 then
        surrenderMark = 3
    elseif surrender > 20000 then
        surrenderMark = 2
    elseif surrender > 10000 then
        surrenderMark = 1
    end
    if surrenderMark > Female.Mark[2] then
        local text = "取得了屈服刻印Lv"..surrenderMark
        Female.Mark[2] = surrenderMark
        Message : AddMessage(text)
    end
    local Revolt = CSourcePack.反感
    local RevoltMark = 0
    if Female.Mark[0] == 1 then
        Revolt = Revolt - 100
    elseif Female.Mark[0] == 2 then
        Revolt = Revolt - 500
    elseif Female.Mark[0] == 3 then
        Revolt = Revolt - 1000
    end
    if Female.Mark[1] == 1 then
        Revolt = Revolt - 500
    elseif Female.Mark[1] == 2 then
        Revolt = Revolt - 1500
    elseif Female.Mark[1] == 3 then
        Revolt = Revolt - 4000
    end
    if Female.Mark[2] == 1 then
        Revolt = Revolt - 500
    elseif Female.Mark[2] == 2 then
        Revolt = Revolt - 1500
    elseif Female.Mark[2] == 3 then
        Revolt = Revolt - 2000
    end
    if Revolt > 3000 then
        RevoltMark = 3
    elseif Revolt > 1500 then
        RevoltMark = 2
    elseif Revolt > 800 then
        RevoltMark = 1
    end
    if RevoltMark > Female.Mark[3] then
        local text = "取得了反抗刻印Lv"..RevoltMark
        Female.Mark[3] = RevoltMark
        if Train.GetAbility("顺从") > 0 and Train.GetAbility("顺从") < 3 and not Train.HaveTalent("感情缺乏") then
            Female : SetAbility("顺从", math.max(Train.GetAbility("顺从") - RevoltMark, 0))
            AbliTable["顺从"] = nil
            text = text.."\n同时顺从下降到了Lv"..Female : GetAbility("顺从")
        end
        Message : AddMessage(text)
    end

end

function Train.OrgasmHandle()
    local data = ActiveData.new()
    local feels = {"尿", "Ａ", "Ｂ", "Ｃ", "Ｖ", "Ｍ"}
    local Orgasms = {快Ｃ = 0, 快Ｖ = 0, 快Ａ = 0, 快尿 = 0, 快Ｂ = 0, 快Ｍ = 0}
    for index, value in ipairs(feels) do
        local valuea = "快"..value
        local es = CSourcePack[valuea] + trainData.Source : get_Item(valuea)
        if es >= 100000 then
            Orgasms[valuea] = 5
            trainData : AddContent(value.."绝顶", 5)
        elseif es >= 60000 then
            Orgasms[valuea] = 4
            trainData : AddContent(value.."绝顶", 4)
        elseif es >= 30000 then
            Orgasms[valuea] = 3
            trainData : AddContent(value.."绝顶", 3)
        elseif es >= 20000 then
            Orgasms[valuea] = 2
            trainData : AddContent(value.."绝顶", 2)
        elseif es >= 10000 then
            Orgasms[valuea] = 1
            trainData : AddContent(value.."绝顶", 1)
        end
    end
    local orgasmsNumber = 0
    local Otypes = 0

    if Orgasms["快Ｃ"] > 0 then
        data.露出 = 300 * Orgasms["快Ｃ"]
        if Train.HaveTalent("C性向") or Train.HaveTalent("淫核") then
            data.屈服 = data.屈服 + 1000
            Train.fav = Train.fav + 2
        end
        orgasmsNumber = orgasmsNumber + Orgasms["快Ｃ"]
        Otypes = Otypes + 1
    end
    if Orgasms["快Ｖ"] > 0 then
        data.露出 = data.露出 + 500 * Orgasms["快Ｖ"]
        data.屈服 = data.屈服 + 500
        if Train.HaveTalent("V性向") or Train.HaveTalent("淫壶") then
            data.屈服 = data.屈服 + 1000
            Train.fav = Train.fav + 2
        end
        data.欲情追加 = data.欲情追加 + 500
        orgasmsNumber = orgasmsNumber + Orgasms["快Ｖ"]
        Otypes = Otypes + 1
    end
    if Orgasms["快Ａ"] > 0 then
        data.露出 = data.露出 + 1000 * Orgasms["快Ａ"]
        data.屈服 = data.屈服 + 2000
        if Train.HaveTalent("A性向") or Train.HaveTalent("淫尻") then
            data.屈服 = data.屈服 + 1000
            Train.fav = Train.fav + 2
        end
        data.欲情追加 = data.欲情追加 + 500
        orgasmsNumber = orgasmsNumber + Orgasms["快Ａ"]
        Otypes = Otypes + 1
    end
    if Orgasms["快尿"] > 0 then
        data.露出 = data.露出 + 1000 * Orgasms["快尿"]
        data.屈服 = data.屈服 + 2000
        if Train.HaveTalent("U性向") or Train.HaveTalent("尿道狂") then
            data.屈服 = data.屈服 + 1000
            Train.fav = Train.fav + 2
        end
        data.欲情追加 = data.欲情追加 + 500
        orgasmsNumber = orgasmsNumber + Orgasms["快尿"]
        Otypes = Otypes + 1
    end
    if Orgasms["快Ｂ"] > 0 then
        data.露出 = data.露出 + 300 * Orgasms["快Ｂ"]
        if Train.HaveTalent("B性向") or Train.HaveTalent("淫乳") then
            data.屈服 = data.屈服 + 1000
            Train.fav = Train.fav + 2
        end
        orgasmsNumber = orgasmsNumber + Orgasms["快Ｂ"]
        Otypes = Otypes + 1
    end
    if Orgasms["快Ｍ"] > 0 then
        data.情爱 = data.情爱 + 500 * Orgasms["快Ｍ"]
        if Train.HaveTalent("M性向") or Train.HaveTalent("荡唇") then
            data.屈服 = data.屈服 + 1000
            Train.fav = Train.fav + 2
        end
        orgasmsNumber = orgasmsNumber + Orgasms["快Ｍ"]
        Otypes = Otypes + 1
    end

    if Otypes == 0 then
        return
    end
    trainData : AddContent("绝顶", Otypes)


    Train.fav = Train.fav + Otypes
    Train.堕落 = Train.堕落 + Otypes
    trainData : AddContent("绝顶", Otypes)
    data.逸脱 = data.逸脱 - 20
    data.露出 = data.露出 - 20
    data.反感追加 = data.反感追加 -  20
    data.屈服 = data.屈服 * Otypes
    data.欲情追加 = data.欲情追加 * Otypes
    data.恭顺追加 = data.恭顺追加 * Otypes

    if tostring(Female.sex) == "男" then
        data.液体追加 = 500 * orgasmsNumber
    end
    if Otypes >= 2 then
        local mu = 0
        if trainData.equipItem : Contains("媚药") then
            mu = (Otypes - 1) * 100
        else
            mu = (Otypes - 1) * 1000
        end
        for index, value in ipairs(feels) do
            trainData.Orbs : set_Item("快"..value, mu * Orgasms[value])
        end
    end
    if not tostring(Female.sex) == "男" then
        local temp = 0
        for index, value in ipairs(feels) do
            value = "快"..value
            temp = temp + CSourcePack[value]
        end
        if temp >= 10000 then
            temp = 500
        elseif temp >= 3000 then
            temp = 200
        elseif temp >= 500 then
            temp = 50
        elseif temp >= 100 then
            temp = 20
        else
            temp = 5
        end
        temp = temp + math.max(orgasmsNumber * 100, 600)
        if Train.HaveTalent("容易湿") then
            data.液体追加 = data.液体追加 + UpPalamLv(temp)
            data.露出 = data.露出 + UpPalamLv(temp) / 2
        elseif Train.HaveTalent("容易湿") then
            data.液体追加 = data.液体追加 + DownPalamLv(temp)
            data.露出 = data.露出 + DownPalamLv(temp) / 2
        else
            data.液体追加 = data.液体追加 + temp
            data.露出 = data.露出 + temp / 2
        end
    end

    local level = 1
    if Orgasms["Ｖ绝顶"] > 2 then
        level = 2
    elseif Orgasms["Ａ绝顶"] > 3 or Orgasms["Ｖ绝顶"] > 3 then
        level = 3
    elseif Orgasms["Ｃ绝顶"] + Orgasms["尿绝顶"] >= 4 and Orgasms["Ａ绝顶"] >= 4 then
        level = 4
    elseif Orgasms["Ｃ绝顶"] + Orgasms["尿绝顶"] >= 4 and Orgasms["Ａ绝顶"] >= 4 and Orgasms["Ｖ绝顶"] >= 4 then
        level = 5
    end
    if Train.HaveTalent("冷漠") then
        level = level - 1
    end

    local jd = CSourcePack.快Ｃ * trainData.FemaleSamen.y / 10000
    trainData.FemaleSamen.x = trainData.FemaleSamen.x + math.floor(jd)
    if trainData.Position[4] or trainData.Active == "肛门拳交" or  trainData.Active == "双穴拳交" then
        trainData.FemaleSamen.x = trainData.FemaleSamen.x + CSourcePack.快Ａ * trainData.FemaleSamen.y / 20000
    end
    if trainData.FemaleSamen.x > trainData.FemaleSamen.y then
        local s = 0
        if trainData.FemaleSamen.x >= trainData.FemaleSameny * 4 then
            s = 3
        elseif trainData.FemaleSamen.x >= trainData.FemaleSameny * 2 then
            s = 2
        else
            s = 1
        end

        trainData.AddContent(Female.."射精")
        local level = Female : SetSexexp("射精经验")
        if GetExpLV(level) < 1 then
            data.屈服 = data.屈服 + 650 * s
        elseif GetExpLV(level) < 2 then
            data.屈服 = data.屈服 + 550 * s
        elseif GetExpLV(level) < 3 then
            data.屈服 = data.屈服 + 450 * s
        elseif GetExpLV(level) < 4 then
            data.屈服 = data.屈服 + 400 * s
        elseif GetExpLV(level) < 5 then
            data.屈服 = data.屈服 + 300 * s
        else
            data.屈服 = data.屈服 + 200 * s
        end

        AddSexexp("射精经验", 1)
        AddSexexp("精液经验", s, Trainer)
        trainData.FemaleSamen.x = 0
        if s == 3 then
            Message : AddMessage(Female.."超强射精")
        elseif s == 2 then
            Message : AddMessage(Female.."强射精")
        else
            Message : AddMessage(Female.."射精")
        end       
    end

    if Train.HaveTalent("母乳体质") then
        local milk = math.random(0,1000)
        if CSourcePack.快Ｂ <= 10000 then
            milk = milk + CSourcePack.快Ｂ
        else
            milk = milk + (10000 + DownPalamLv(CSourcePack.快Ｂ - 10000))
        end
        if Train.HaveTalent("巨乳") then
            milk = milk + 500
        end
        if Train.HaveTalent("淫乳") then
            milk = milk + 500
        end
        if Female.IsPregnancy then
            milk = milk + 1000
        end

        trainData.FemaleMilk.x = trainData.FemaleMilk.x + milk
        local b = 0
        if CSourcePack.快Ｂ and Orgasms["快Ｂ"] and trainData.FemaleMilk.x > trainData.FemaleMilk.y then

            if trainData.FemaleMilk.x > trainData.FemaleMilk.y * 3 then
                b = 3
            elseif trainData.FemaleMilk.x > trainData.FemaleMilk.y * 3 then
                b = 2
            else
                b = 1
            end
        end
        if b > 0 then
            trainData.AddContent("喷乳")
            Female : AddSexexp("喷乳经验", b)
            data.露出 = data.露出 + 500 * b
            trainData.FemaleMilk.x = 0
            if Train.HaveTalent("倒错") then
                Train.fav = Train.fav + 2
            end

            
            if b >= 2 then
                Message : AddMessage(Female.."的乳头喷出了大量的母乳")
            elseif b == 1 then
                Message : AddMessage(Female.."的乳头喷出了的母乳")
            else
                Message : AddMessage(Female.."的乳头滲出了的母乳")
            end
        end

    end


    local pack = Train.SettleTrain(data)
    CSourcePack = CSourcePack + pack

    --经验
    local text = SB.new()
    if Otypes == 5 then
        SB.append(text,"五重绝顶")
    elseif Otypes == 4 then
        SB.append(text,"四重绝顶")
    else
        for key, value in pairs(feels) do
            if Orgasms["快"..feels] >= 4 then
                SB.append(text, feels.."超强绝顶")
            elseif Orgasms["快"..feels] > 2 then
                SB.append(text, feels.."强绝顶")
            else
                SB.append(text, feels.."绝顶")
            end
        end
        Message : AddMessage(SB.tostr(text))
    end

    if Train.GetAbility("欲望") < level then
        Female : SetAbility(level)
        Train.AbliTable["欲望"] = nil
        Message : AddMessage("欲望变成了Lv"..level)
    end
    if Train.HaveTalent("否定快感") and level >= 3 then
        Female : DelTalent("否定快感")
        Train.TalentTable["否定快感"] = false
        Message : AddMessage("失去了否定快感")
        local fg = Female : GetOrbs("反感")
        if fg > 0 then
            fg = fg / 2
            Female : SetOrbs("反感", fg)
            Message : AddMessage("反感之珠减半了")
        end
    end
    if not Train.HaveTalent("尿道性感") and Orgasms["Ｃ绝顶"] + Orgasms["尿绝顶"] then
        Female : SetTalent("尿道性感")
        Train.TalentTable["尿道性感"] = nil
        text = "因为被玩弄尿道而绝顶、打开了新世界的大门\n获得了[尿道性感]"
        Message : AddMessage(text)
    end

    Female.Depraved = Female.Depraved + orgasmsNumber
    if Train.HaveTalent("淫乱") then
        Female.Depraved = Female.Depraved + orgasmsNumber
    end
    Female : AddSexexp("绝顶经验", orgasmsNumber)
    Message : AddMessage("绝顶经验增加了"..orgasmsNumber)
    Message : AddMessage("堕落度上升到了"..Female.Depraved)
end

function Train.ExpCheck()
    if tostring(Female.sex) ~= "男" and tostring(Trainer.sex) ~= "男" then
        AddSexexp("百合经验", 1)
    elseif tostring(Female.sex) == "男" and tostring(Trainer.sex) == "男" then
        AddSexexp("断袖经验", 1)
    end


    local value = CSourcePack.快Ａ + CSourcePack.快Ｃ + CSourcePack.快Ｖ + CSourcePack.快Ｂ + CSourcePack.快Ｍ + CSourcePack.快尿 + CSourcePack.欲情
    local LOCAL = 0
    if value >= 30000 then
        LOCAL = 3
    elseif value >= 10000 then
        LOCAL = 2
    elseif value >= 3000 then
        LOCAL = 1
    else
        LOCAL = 0
    end
    local temp = 0
    local text = SB.new()
    if SexType("侍奉快乐") then
        temp = LOCAL + 1
        if trainData.equipItem : Contains("媚药") then
            temp = temp - math.floor(trainData : GetValue("媚药") / 50)
        end
        if trainData : CurrPlay("绝顶") > 0 then
            temp = temp + 1
        end
        if SexType("嗜虐快乐") and Train.GetAbility("侍奉技术") <= Train.GetAbility("施虐属性") then
            temp = temp - 1
        end
    end
    if Trainer.Name ~= Factory.Characters[0].Name then
        temp = temp / 2
        temp = math.floor(temp)
    end
    Female : AddSexexp("侍奉快乐经验", math.max(temp,0))
    if temp > 0 then
        SB.appendLine(text, "侍奉快乐经验 +"..temp)
    end
    Female.Mood = Female.Mood + temp / 2
    temp = 0
    if SexType("嗜虐快乐") then
        temp = LOCAL + 1
        if trainData.equipItem : Contains("媚药") then
            temp = temp - math.floor(trainData : GetValue("媚药") / 50)
        end
        if trainData : CurrPlay("绝顶") > 0 then
            temp = temp + 1
        end
        if SexType("侍奉快乐") and Train.GetAbility("侍奉技术") >= Train.GetAbility("施虐属性") then
            temp = temp - 1
        end
    end
    if Trainer.Name ~= Factory.Characters[0].Name then
        temp = temp / 2
        temp = math.floor(temp)
    end
    Female : AddSexexp("嗜虐快乐经验", math.max(temp,0))
    if temp > 0 then
        SB.appendLine(text, "嗜虐快乐经验 +"..temp)
    end
    Female.Mood = Female.Mood + temp / 2
    LOCAL = math.min(value, CSourcePack.羞耻)
    if LOCAL >= 30000 then
        LOCAL = 3
    elseif LOCAL >= 10000 then
        LOCAL = 2
    elseif LOCAL >= 3000 then
        LOCAL = 1
    else
        LOCAL = 0
    end
    temp = 0
    if SexType("羞耻快乐") then
        temp = LOCAL + 1
        if trainData.equipItem : Contains("媚药") then
            temp = temp - math.floor(trainData : GetValue("媚药") / 50)
        end
        if trainData : CurrPlay("绝顶") > 0 then
            temp = temp + 1
        end
    end
    Female : AddSexexp("羞耻快乐经验", math.max(temp,0))
    if temp > 0 then
        SB.appendLine(text, "羞耻快乐经验 +"..temp)
    end
    Female.Mood = Female.Mood + temp / 2
    LOCAL = math.min(value, CSourcePack.痛苦)
    if LOCAL >= 30000 then
        LOCAL = 3
    elseif LOCAL >= 10000 then
        LOCAL = 2
    elseif LOCAL >= 3000 then
        LOCAL = 1
    else
        LOCAL = 0
    end
    temp = 0
    if SexType("被虐快乐") then
        temp = LOCAL + 1
        if trainData.equipItem : Contains("媚药") then
            temp = temp - math.floor(trainData : GetValue("媚药") / 50)
        end
        if trainData : CurrPlay("绝顶") > 0 then
            temp = temp + 1
        end
    end
    Female : AddSexexp("被虐快乐经验", math.max(temp,0))
    if temp > 0 then
        SB.appendLine(text, "被虐快乐经验 +"..temp)
    end
    Female.Mood = Female.Mood + temp / 2
end


function Train.SamenHandle()
    if trainData.TrainerSamen.x < trainData.TrainerSamen.y then
        return
    end
    local jy = Train.GetAbility("精液中毒")
    local s = 0
    if trainData.TrainerSamen.x > trainData.TrainerSamen.y * 3 then
        s = 3
    elseif trainData.TrainerSamen.x > trainData.TrainerSamen.y * 2 then
        s = 2
    else
        s = 1
    end
    local sj = s * 20
    if Trainer : HaveTalent("精子浓厚") then
        sj = sj * 2
    elseif Trainer : HaveTalent("精子稀薄") then
        sj = 20
    end
    sj = sj * math.random(50, 180) / 100
    AddSexexp("射精经验", s, Trainer)
    CtrainPack.达成感 = CtrainPack.达成感 * (jy * 0.5 + 1)
    CtrainPack.屈服 = CtrainPack.屈服 * (jy * 0.5 + 1)

    if Train.SePlace == "小穴" then
        local n = 50 * Female.Mark[4]
        CtrainPack.充足 = CtrainPack.充足 + n * (jy - 1)
        CtrainPack.不洁 = CtrainPack.不洁 + 20
        Female : AddSexexp("腔内精液经验", s)
    elseif Train.SePlace == "肛门" then
        CtrainPack.充足 = CtrainPack.充足 + 50 * (jy - 1)
        CtrainPack.不洁 = CtrainPack.不洁 + 50
        Female : AddSexexp("肛内精液经验", s)
    elseif Train.SePlace == "尿道" then
        CtrainPack.充足 = CtrainPack.充足 + 100 * (jy - 1)
        CtrainPack.不洁 = CtrainPack.不洁 + 200
        Female : AddSexexp("膀胱精液经验", s)
    elseif Train.SePlace == "口腔" then
        CtrainPack.充足 = CtrainPack.充足 + 250 * (jy - 1)
        CtrainPack.不洁 = CtrainPack.不洁 + 50
        Female : AddSexexp("饮精经验", s)
    elseif Train.SePlace == "胸部" then
        CtrainPack.充足 = CtrainPack.充足 + 200 * (jy - 1)
        CtrainPack.不洁 = CtrainPack.不洁 + 100
        Female : AddSexexp("精液经验", s)
    elseif Train.SePlace == "身上" then
        CtrainPack.充足 = CtrainPack.充足 + 150 * (jy - 1)
        CtrainPack.不洁 = CtrainPack.不洁 + 100
        Female : AddSexexp("精液经验", s)
    elseif Train.SePlace == "脸部" then
        CtrainPack.充足 = CtrainPack.充足 + 300 * (jy - 1)
        CtrainPack.不洁 = CtrainPack.不洁 + 100
        Female : AddSexexp("颜射经验", s)
    end
    if Train.SePlace == "小穴" then
        local SPERM = sj * (10 + math.random(0,21))
        if trainData.Select == "子宫" then
            SPERM = SPERM * 10
        end
        Female.InternalSamen = Female.InternalSamen + SPERM
        if Train.HaveTalent("吸精体质") then
            SPERM = math.max(math.min(1 + trainData : TotalPlay("V中出")* 2, SPERM), SPERM / 2)
        end
    end
    trainData : AddContent("V中出")
    trainData.TrainerSamen.x = 0
end

----------------------------------------------------------------------
----------------------------------------------------------------------

function Train.HaveTalent(Talent)
    if TalentTable[Talent] == nil then
        TalentTable[Talent] = Female : HaveTalent(Talent)
    end
    return TalentTable[Talent]
end
function Train.GetAbility(Ability)
    if AbliTable[Ability] == nil then
        AbliTable[Ability] = Female : GetAbility(Ability)
    end
    return AbliTable[Ability]
end


function Train.JJLike()
    local i = 0
    if tostring(Female.Feel) == "陷落" then
        i = i + 1
    elseif tostring(Female.Feel) == "堕落" then
        i = i + 2
    elseif tostring(Female.Feel) == "狂堕" then
        i = i + 3
    end

    if Female:HaveTalent("好色") or Female:HaveTalent("接受快感") then
        i = i + 1
    end
    if Female:HaveTalent("淫壶") or Female:HaveTalent("尻穴狂") then
        i = i + 1
    end
    if Female:GetAbility("精液中毒") >= 3 then
        i = i + 1
    end
    if Female:GetAbility("侍奉技术") >= 5 then
        i = i + 1
    end
    return i
end

function Train.LovePlay(base, value)
    base.充足 = base.充足 + DownPalamLv(value, 1) + 100
    base.不洁 = base.不洁 + math.max(DownPalamLv(base.不洁, 1) - 500, 0)
    base.逸脱 = base.逸脱 + math.max(DownPalamLv(base.逸脱, 1) - 500, 0)
    base.恐惧 = base.恐惧 + math.max(DownPalamLv(base.恐惧, 1) - 500, 0)
    base.反感追加 = base.反感追加 + math.max(DownPalamLv(base.反感追加, 1) - 500, 0)
end

function Train.AddLust()
    if SexType("侍奉快乐") and SexType("嗜虐快乐") then
        return 150 * math.max(Train.GetAbility("侍奉技术"), Train.GetAbility("施虐属性"))
    elseif SexType("侍奉快乐") then
        return 150 * Train.GetAbility("侍奉技术")
    else
        return 150 * Train.GetAbility("施虐属性")
    end
end

function Train.Estrus(type)
    local temp = 0
    if type == "B" then
        if Train.HaveTalent("淫乳") then
            temp = temp + 1
        end
        if Train.GetAbility("B感觉") >= 5 or trainData.Source : get_Item("欲情") >= 10000 or trainData : PrevPlay("B绝顶") > 0 then
            temp = temp + 1
        end
        if trainData.Source : get_Item("欲情") >= 30000 then
            temp = temp + 1
        end
        if trainData.FemaleClimax[3] >= 5 then
            temp = temp + 1
        end

    elseif type == "V" then
        if tostring(Female.sex) == "男" then
            return 0
        end

        if Train.HaveTalent("淫壶") then
            temp = temp + 1
        end
        if trainData.Source : get_Item("欲情") >= 10000 or trainData.equipItem : Contains("媚药") then
            temp = temp + 1
        end
        if Train.GetAbility("V感觉") >= 3 or trainData.Source : get_Item("欲情") >= 3000 then
            temp = temp + 1
        end
        if trainData : PrevPlay("Ｖ绝顶") > 0 or trainData.FemaleClimax[1] >= 3 then
            temp = temp + 1
        end
        if trainData : PrevPlay("Ｖ绝顶") > 4 or trainData.FemaleClimax[1] >= 10 then
            temp = temp + 1
        end
    elseif type == "C" then
        if trainData.Source : get_Item("欲情") >= 30000 then
            temp = temp + 1
        end
        if (Train.GetAbility("C感觉") >= 5 and trainData.Source : get_Item("欲情") >= 3000) or trainData : PrevPlay("Ｃ绝顶") > 0 then
            temp = temp + 1
        end
        if trainData : PrevPlay("C绝顶") > 4 then
            temp = temp + 1
        end
        if Train.HaveTalent("淫核") and trainData.Source : get_Item("欲情") >= 10000 then
            temp = temp + 1
        end
    end
    return temp
end

function Train.AllowAction()
    local value = 0
    local text = SB.new()

    local temp = math.min(Train.GetAbility("顺从"), 10)
    if(temp > 0) then
        value = value + temp
        SB.append(text,"顺从: +"..temp)
    end
    temp = math.min(Train.GetAbility("欲望"), 10)
    if(temp > 0) then
        value = value + temp
        SB.append(text,"欲望: +"..temp)
    end

    if(Female.Mark[1] > 0) then
        value = value + Female.Mark[1] * 5--痛苦刻印
        SB.append(text,"痛苦刻印: +"..Female.Mark[1])
    end
    if(Female.Mark[2] > 0) then
        value = value + Female.Mark[2] * 3--痛苦刻印
        SB.append(text,"痛苦刻印: +"..Female.Mark[2])
    end
    if(Female.Mark[0] > 0) then
        value = value + Female.Mark[0] * 2--快乐刻印
        SB.append(text,"快乐刻印: +"..Female.Mark[0])
    end
    if(Female.Mark[4] > 0) then
        value = value + Female.Mark[4] * 1--快乐刻印
        SB.append(text,"快乐刻印: +"..Female.Mark[4])
    end

    temp = math.min(GetExpLV(Female.Friend) / 5, 16)
    if(temp > 0) then
        value = value + temp
        SB.append(text,"好感度: +"..temp)
    end

    temp = GetPalamLV(trainData.Source : get_Item("欲情"))
    if(temp > 0) then
        value = value + temp
        SB.append(text,"欲情: +"..temp)
    end
    temp = GetPalamLV(trainData.Source : get_Item("恐怖"))
    if(temp > 0) then
        value = value + temp
        SB.append(text,"恐怖: +"..temp)
    end
    if(Female: HaveTalent("叛逆")) then
        value = value - 10
        SB.append(text,"叛逆: -10")
    end
    if(Female: HaveTalent("坚强")) then
        value = value - 5
        SB.append(text,"坚强: -5")
    end
    if(Female: HaveTalent("坦率")) then
        value = value + 5
        SB.append(text,"坦率: +5")
    end
    if(Female: HaveTalent("高傲")) then
        value = value - 15
        SB.append(text,"高傲: -15")
    end
    if(Female: HaveTalent("谦虚")) then
        value = value + 5
        SB.append(text,"谦虚: +5")
    end
    if(Female: HaveTalent("喜欢引人注目")) then
        value = value + 2
        SB.append(text,"喜欢引人注目: +2")
    end
    if(Female: HaveTalent("好色")) then
        value = value + 2
        SB.append(text,"好色: +2")
    end
    if(Female: HaveTalent("淫乱")) then
        value = value + 2
        SB.append(text,"淫乱: +2")
    end
    

    if  Female.sex : ToInt()  + Trainer.sex : ToInt() >= 3 or Female.sex == Trainer.sex then
        if Female: HaveTalent("同性接受") then
            value = value + 5
            SB.append(text,"同性接受: +5")
        elseif Female: HaveTalent("拒绝同性") then
            value = value - 5
            SB.append(text,"拒绝同性: -5")
        end
    end

    if Female.Feel : ToInt() < 4 and Female.Feel : ToInt() > 0 then
        value = value + 5 * Female.Feel : ToInt()
        SB.append(text, tostring(Female.Feel)..": +"..5 * Female.Feel : ToInt())
    end

    if trainData.equipItem : Contains("摄像机") then
        value = value - 10
        SB.append(text,"摄像机: -10")
    end
    if trainData.equipItem : Contains("野外PLAY") then
        value = value - 10
        SB.append(text,"野外PLAY: -10")
    end
    
    return value, text
end



function Train.ShowOrder(value, text, need)
    SB.append(text," = "..value)
    if value > need then
        SB.append(text," > "..need)
    elseif value == need then
        SB.append(text," = "..need)
    else
        SB.append(text," < "..need)
    end
    
    Message : AddMessage(SB.tostr(text))
    if value >= need then
        return true
    else
        return false
    end

end


function Train.PleasureLimiter(num, level)
    local yq = trainData.Source : get_Item("欲情")
    if yq < 100 then
        level = level - 3
    elseif yq < 3000 then
        level = level - 2
    elseif yq < 10000 then
        level = level - 1
    end
    local mood = math.floor(Train.Mood() / 30)
    if mood == 0 then
        level = level - 4
    elseif mood == 1 then
        level = level - 3
    elseif mood == 2 then
        level = level - 2
    elseif mood == 3 then
        level = level - 1
    end
    level = level + math.floor(trainData : GetValue("媚药") / 100)
    if trainData : PrevPlay("绝顶") ~= 0 then
        level = level + 1
    end
    if level < 0 then
        level = 0
    end
    local base = 0
    local top = 0
    if level == 0 then
        base = 100
        top = 500
    elseif level == 1 then
        base = 500
        top = 3000
    elseif level < 5 then
        base = 3000
        top = 6000
    elseif level < 9 then
        base = 6000
        top = 10000
    elseif level < 11 then
        base = 10000
        top = 20000
    else
        base = 10000 + 1000 * (level - 10)
        top = 20000 + 2000 * (level - 10)
    end
    if num < base then
        base = num
    else
        base = base + (num - base) / 5
        if base > top then
            base = top + (base - top) / 20
        end
    end
    return math.floor(base)
end