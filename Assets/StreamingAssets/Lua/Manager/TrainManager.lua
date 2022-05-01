TrainManager = 
{  
    FeelPack = {},
    FeelList =
    {
        "嘴部快感",
        "胸部快感",
        "阴部快感",
        "小穴快感",
        "菊穴快感",
        "尿道快感",
        "小穴润滑",
        "菊穴润滑",
        "欲情",
        "恭顺",
        "屈从",
        "习得",
        "羞耻",
        "痛苦",
        "恐怖",
        "反感",
    }
}
----注册的事件----
----
-----------------

local 本次记录 = {}
local 上次记录 = {}


function TrainManager:StartTrainAI(ai, chara)
    self.AI = ai
    self.AI.Chara.当前体力 = self.AI.Chara.体力
    self.AI.Chara.当前精力 = self.AI.Chara.精力
    self:StartTrain(ai.Chara, chara)
end

---开始调试所用方法
---第一个作为调教者，第二个作为被调教者，第三个为助手，后续为其他被调教者
---@param ... Character
function TrainManager:StartTrain(...)
    local t = {...}
    local pack = require("Data/FeelPack")
    if #t < 2 then
        return false
    end
    ---@type FeelPack[]
    self.FeelPack = {}
    self.总记录 = {}

    for i, value in ipairs(t) do
        if value.Type == nil or value.Type ~= "Character" then
            Message:AddTopMessage("调教管理器：传入参数类型不符")
            return false
        end
        self.FeelPack[i] = pack:New()
        self.总记录[i] = {}
        本次记录[i] = {}
        上次记录[i] = {}

    end

    --初始化
    self.回合数 = 1
    self.上次行为 = ""
    self.上次选择 = ""
    self.行为 = ""
    self.选择 = ""
    self.体力减少 = 0
    self.经验栈 = {}
    self.行为栈 = {}
    self.调教地点特性 = {}
    self.参与人员 = t
    self.调教者 = t[1]
    self.被调教者 = t[2]
    self.衣服堆 = {}
    self.使用堆 = {}
    self.占用堆 = {}
    self.姿势 = "正常位"
    self.正面 = true
    if #t >= 3 then
        self.助手 = t[3]
    else
        self.助手 = nil
    end
    self.Line = 0

    if self.AI ~= nil then
        self.AI:Init()
    end
    return true
end

function TrainManager.EndTrain(reason)
    local self = TrainManager
    reason = reason or "调教结束"
    Message:AddMessage(reason)

    for index, value in ipairs(self.FeelPack) do
        local chara = self.参与人员[index]
        if(chara.宝珠) then
            local orb = self:转化宝珠(chara, value)
            local of = require("Data/宝珠")
            of:Add(chara.宝珠, orb)
            Message:AddMessage(("%s的感觉转化为了宝珠"):format(chara.名字))
            Message:AddMessage(of:Message(orb))
            if DataManager.PlayerData.Debug then
                Message:AddMessage("现在的宝珠情况:")
                Message:AddMessage(of:Message(chara.宝珠))
            end

    
            --require("Manager/ABLManager"):强化能力(chara)
        end
    end

    self.AI = nil
    self.总记录 = nil
    self.FeelPack = nil
    本次记录 = nil
    上次记录 = nil
    self.衣服堆 = nil
    self.经验栈 = nil
    self.行为栈 = nil
    self.调教地点特性 = nil
    self.参与人员 = nil
    self.调教者 = nil
    self.被调教者 = nil
    self.助手 = nil

    Message:AddMessage("command,UIManager.Back")
    Message:StartPop()
end



function TrainManager:检查占用(female, pos, equip)
    local fid = self:查找ID(female)
    if fid == nil then
        Message:AddTopMessage("找不到人物")
        return
    end
    if self.占用堆[fid] == nil or #self.占用堆[fid] == 0 then
        return false
    end
    if equip ~= nil then
        if self.占用堆[fid][pos].Name == equip then
            return true
        end
    else
        if self.占用堆[fid][pos] ~= nil then
            return true
        end
    end
    return false
end

function TrainManager:添加占用(active)
    local tid = self:查找ID(active.调教者)
    local fid = self:查找ID(active.被调教者)

    if tid == nil or fid == nil then
        Message:AddTopMessage("找不到人物")
        return
    end
    if self.使用堆[tid] ~= nil and self.使用堆[tid][active.执行.Name] ~= nil then
        local t = self.使用堆[tid][active.执行.Name]
        self.使用堆[t.fid][t.目标.Name] = nil
    end

    if self.占用堆[fid] == nil then
        self.占用堆[fid] = {}
    end
    if type(self.占用堆[fid][active.目标.Name]) == "table" then
        local t = self.使用堆[fid][active.目标.Name]
        self.使用堆[t.tid][t.执行.Name] = nil
    end

    self.占用堆[fid][active.目标.Name] = {调教者 = tid,  执行 = active.执行, }
end

function TrainManager:GetOptions()
    local opt = SB:New()
    ---@type Character
    local 调教者 = self.调教者
    ---@type Character
    local 目标 = self.被调教者
    TrainManager.Line = 0


    if 调教者.手部 ~= nil then
        opt:Append(self.Button("爱抚"))
    end
    if 调教者.嘴部 ~= nil then
        opt:Append(self.Button("舔舐"))
        if not self:检查占用(调教者, "嘴部") and not self:检查占用(目标, "嘴部") then
            opt:Append(self.Button("接吻"))
        end
    end


    local id = self:查找ID(调教者)
    local 胯部装备 = 目标:获取外层装备("胯部")

    --张开
    if not 目标:检查状态("拘束") and 目标:获取装备厚度("胯部") < 5 then
        opt:Append(self.Button("自慰"))
        if 胯部装备 == nil and not self:检查占用(目标, "小穴") then
            opt:Append(self.Button("张开", "小穴"))
        end
        if 胯部装备 == nil and not self:检查占用(目标, "菊穴") then
            opt:Append(self.Button("张开", "肛门"))
        end
    end

    --指插入系
    if 胯部装备 == nil and not self:检查占用(目标, "小穴") and not self:检查占用(调教者, "手部") then
        opt:Append(self.Button("指插入", "小穴"))
    end
    if 胯部装备 == nil and self.上次行为 == "指插入小穴" then
        opt.Append(self.Button("指插入", "G点", "刺激G点"))
    end
    if 胯部装备 == nil and not self:检查占用(目标, "菊穴") and not self:检查占用(调教者, "手部") then
        opt:Append(self.Button("指插入", "菊穴"))
    end

    --道具系
    if 胯部装备 == nil and DataManager:HaveSexItem("阴蒂夹") then
        if not self:检查占用(目标, "阴部") then
            opt:Append(self.Button("阴蒂夹"))
        end
        if self:检查占用(目标, "阴部", "阴蒂夹") then
            opt:Append(self.Button("取下阴蒂夹"))
        end
    end
    if 胯部装备 == nil and DataManager:HaveSexItem("振动棒") then
        if not self:检查占用(目标, "小穴") then
            opt:Append(self.Button("振动棒"))
        end
        if self:检查占用(目标, "小穴", "振动棒") then
            opt:Append(self.Button("取下振动棒"))
        end
    end

    --插入
    if 调教者.阴部.Name == "阴茎" then
        if 胯部装备 == nil and not self:检查占用(目标, "小穴") then
            opt:Append(self.Button("插入小穴", "小穴", "插入小穴"))
            if 调教者.阴部.技巧 >= 2 then
                opt:Append(self.Button("插入小穴", "G点", "刺激G点"))
                if 调教者.阴部.技巧 >= 3 then
                    opt:Append(self.Button("插入小穴", "子宫口", "刺激子宫口"))
                    if 目标.获取经验("子宫口经验") then
                        opt:Append(self.Button("插入小穴", "子宫", "插入子宫"))
                    end
                end
            end
        end
    end


    if 调教者.阴部.Name == "阴茎" then
        if 胯部装备 == nil and not self:检查占用(目标, "菊穴") then
            opt:Append(self.Button("插入菊穴", "菊穴", "插入菊穴"))
            if 调教者.阴部.技巧 >= 2 then
                opt:Append(self.Button("插入菊穴", "乙状结肠", "刺激乙状结肠"))
            end
        end
    end

    --侍奉
    opt:Append(self.Button("手淫"))
    opt:Append(self.Button("口交"))
    opt:Append(self.Button("乳交"))
    opt:Append(self.Button("足交"))

    --opt:Append(self.Button("身体侍奉"))


    --SM
    opt:Append(self.Button("打屁股"))
    opt:Append(self.Button("拳交", "小穴", "小穴拳交"))
    opt:Append(self.Button("拳交", "菊穴", "菊穴拳交"))
    return opt
end




function TrainManager.Back()
    TrainManager.参与人员 = nil
    TrainManager.调教者 = nil
    TrainManager.被调教者 = nil
    TrainManager.助手 = nil

    UIManager:Back()
end


function TrainManager.AIOption(arg1, arg2)
    TrainManager.行为 = arg1
    TrainManager.选择 = arg2
    协程 = coroutine.start(TrainManager.AI.Option, TrainManager.AI, arg1, arg2)
end

local function AddOption(arg1, arg2)
    local train = require("Train/"..arg1)
    local res = false -- 结果
    if train ~= nil and train.Check ~= nil then
        res, arg2 = train:Check(TrainManager.调教者, TrainManager.被调教者, arg2) --check返回两个值，第一个是能否执行，第二个是所选的选项
        if res then
            TrainManager:添加行为(TrainManager.调教者, TrainManager.被调教者, arg1, arg2)
            TrainManager:Execute()
        else
            Message:StartPop()
        end
    end
end

function TrainManager.Option(arg1, arg2)
    协程 = coroutine.start(AddOption, arg1, arg2)
end




local function 被调教者修正(chara, 部位, func)
    for index, value in ipairs(chara.特性) do
        local tex = require("Data/特性/"..value)
        if tex ~= nil and tex.Type == "特性" then
            func(部位, tex)
        end
    end
    for index, value in ipairs(chara.部位.特性) do
        local tex = require("Data/特性/"..value)
        if tex ~= nil and tex.Type == "特性" then
            func(部位, tex)
        end
    end
end

local function 特性修正(active, func)
    if active.调教者 ~= nil then
        for index, value in ipairs(active.调教者.特性) do
            local tex = require("Data/特性/"..value)
            if tex ~= nil and tex.Type == "特性" then
                func("调教者", tex)
            end
        end
    end
    if active.被调教者 ~= nil then
        for index, value in ipairs(active.被调教者.特性) do
            local tex = require("Data/特性/"..value)
            if tex ~= nil and tex.Type == "特性" then
                func("被调教者", tex)
            end
        end
    end
    if active.执行 ~= nil and active.调教者 ~= active.执行 then
    for index, value in ipairs(active.执行.特性) do
        local tex = require("Data/特性/"..value)
        if tex ~= nil and tex.Type == "特性" then
            func("执行", tex)
        end
    end
    end
    if active.目标 ~= nil and active.被调教者 ~= active.目标 then
        for index, value in ipairs(active.目标.特性) do
            local tex = require("Data/特性/"..value)
            if tex ~= nil and tex.Type == "特性" then
                func("目标", tex)
            end
        end
    end

    for index, value in ipairs(TrainManager.调教地点特性) do
        local tex = require("Data/特性/"..value)
        if tex ~= nil and tex.Type == "特性" then
            func("地点", tex)
        end
    end
end

---@param trainer Character
---@param trainee Character
---@param action string
---@param select string
function TrainManager:添加行为(trainer, trainee, action, select, mutil)
    local sex = require("Train/"..action)
    if sex ~= nil then   
        local active = sex:GetActive(trainer, trainee, select)
        if active ~= nil then
            if mutil ~= nil then
                active.乘数 = mutil
            end
            table.insert(self.行为栈, active)
        end
    else
        Message:AddTopMessage("行为不存在")
        return false
    end
end

local function 执行行为(self)
    TrainManager.当前行为 = self

    local action = self.sex:SexActive(self, self.行为, self.选择)
    if self.调教者.阴部 ~= nil and self.调教者.阴部.Name == "阴茎" and self.调教者.阴部.精液 > 10000 then
        TrainManager:射精处理(self, action)
    end
    TrainManager:行为补正(self, action)
    local feel = TrainManager:ToFeelPack(self, action)
    TrainManager:感觉补正(self, feel)
    TrainManager:绝顶处理(self, feel)
    TrainManager:体力处理(self)

    TrainManager:最终补正(self, feel)
    TrainManager:经验处理(self, self.feelpack)
    if self.没有口上 == nil then
        TrainManager:输出口上(self)
    end

end


--执行调教选项
function TrainManager:Execute()
    for i = 1, #self.行为栈 do
        执行行为(self.行为栈[i])
    end
    self.当前行为 = nil
    local trainees = {}
    --
    for index, value in ipairs(self.行为栈) do
        local id = self:查找ID(value.被调教者)
        if id ~= -1 then
            if trainees[id] == nil then
                trainees[id] = require("Data/FeelPack"):New()
            end

            --将计算好的包加入总
            for key, t in pairs(self.FeelPack[id]) do
                trainees[id][key] = trainees[id][key] + math.floor(value.feelpack[key])
                self.FeelPack[id][key] = self.FeelPack[id][key] + math.floor(value.feelpack[key])
            end
        end
    end

    for key, value in pairs(trainees) do
        local chara = self.参与人员[key]
        self:刻印处理(chara, value)
        self:其他处理()
    end

    self:输出(trainees)
    self:重置变量()
    self:最终处理()
end

function TrainManager.Button(arg1, arg2, arg3)
    local s
    if arg2 == nil then
        s = string.format("<pos=%s%%><link=\"TrainManager.Option,%s,%s\"><color=yellow>%s</color></link></pos>", TrainManager.Line, arg1, arg1, arg1)
    elseif arg3 == nil then
        s = string.format("<pos=%s%%><link=\"TrainManager.Option,%s,%s\"><color=yellow>%s</color></link></pos>", TrainManager.Line, arg1, arg2, arg1..arg2)
    else
        s = string.format("<pos=%s%%><link=\"TrainManager.Option,%s,%s\"><color=yellow>%s</color></link></pos>", TrainManager.Line, arg1, arg2, arg3)
    end
    TrainManager.Line = TrainManager.Line + 17
    if TrainManager.Line > 90 then
        TrainManager.Line = 0
        s = s.."\n"
    else
        s = s.." "
    end
    return s
end

function TrainManager:EXABL(tec, body)
    local value = 0
    local abl = math.min(tec, 6)
    local id = self:查找ID(self.当前行为.被调教者)
    if self:获取上次信息(id, "绝顶") then
        value = (body + abl * 20) * (1 + abl * 0.01)
    else
        value = (body + abl * 100) * (1 + abl * 0.03)
    end
    if tec > 6 then
        value = value + value * ((tec - 6) * 0.01)
    end
    return value
end

---@param active ActiveMsg
function TrainManager:ToFeelPack(active, pack)
    local yuwan = active.被调教者.获取能力("欲望")
    local SC = active.被调教者.获取能力("顺从")
    local SN = active.被调教者.获取能力("受虐属性")
    local SF = active.被调教者.获取能力("侍奉精神")
    local LC = active.被调教者.获取能力("露出癖")

    local feel = require("Data/FeelPack"):New()
    feel.阴部快感 = pack.阴部快感
    feel.小穴快感 = pack.小穴快感
    feel.菊穴快感 = pack.菊穴快感
    feel.胸部快感 = pack.胸部快感
    feel.嘴部快感 = pack.嘴部快感
    feel.尿道快感 = pack.尿道快感

    local elseValue = require("Data/参数"):DownPalamLv(pack.阴部快感 + pack.小穴快感 + pack.菊穴快感 + pack.胸部快感 + pack.嘴部快感 + pack.尿道快感)
    feel.恭顺 = elseValue * (math.min(yuwan, 10) + 2) * 2 / 150
    feel.欲情 = elseValue * (math.min(yuwan, 10) + 2) * 2 / 100
    feel.屈从 = elseValue * (math.min(yuwan, 10) + 10) * 2 / 400

    if SC <= 5 then 
        feel.恭顺 = feel.恭顺 + pack.情爱 * (40 + SC * 10) / 100
    elseif SC <= 10 then
        feel.恭顺 = feel.恭顺 + pack.情爱 * (90 + (SC - 5) * 5) / 100
    else
        feel.恭顺 = feel.恭顺 + pack.情爱 * (115 + (SC - 10) * 1) / 100
    end
    if yuwan <= 5 then
        feel.欲情 = feel.欲情 + pack.情爱 * yuwan * 6 / 100
    elseif yuwan <= 10 then
        feel.欲情 = feel.欲情 + pack.情爱 * (30 + (yuwan - 5) * 3) / 100
    else
        feel.欲情 = feel.欲情 + pack.情爱 * (45 + (yuwan - 10) * 1) / 100
    end

    if pack.成就感 ~= 0 then
        local 习得 = 0
        local 恭顺 = 0
        if SF <= 5 then
            习得 = pack.性行动 * (100 + SF * 20) / 100
            恭顺 = pack.成就感 * (40 + SF * 20) / 100
        elseif SF <= 10 then
            习得 = pack.性行动 * (200 + (SF - 5) * 10) / 100
            恭顺 = pack.成就感 * (140 + (SF - 5) * 10) / 100
        else
            习得 = pack.性行动 * (250 + (SF - 10) * 2) / 100
            恭顺 = pack.成就感 * (190 + (SF - 10) * 2) / 100
        end
        特性修正(active, function (type, tex)
            if tex.行为包转感觉包修正 ~= nil then
                习得, 恭顺 = tex:行为包转感觉包修正(active, type, "成就感", 习得, 恭顺)
            end
        end)
        feel.习得 = feel.习得 + 习得
        feel.恭顺 = feel.恭顺 + 恭顺
    end
    if pack.疼痛 ~= 0 then
        local 恐怖 = 0
        local 反感 = 0
        local 欲情 = 0

        if SC <= 5 then
            恐怖 = pack.疼痛 * (80 - SC * 8) / 100
        elseif SC <= 10 then
            恐怖 = pack.疼痛 * (40 - (SC - 5) * 4) / 100
        else
            恐怖 = pack.疼痛 * ((UnityEngine.Mathf.Max(20 - (SC - 10) * 1,1)) * 1) / 100
        end

        if SN <= 5 then
            欲情 = pack.疼痛 * (SN * 15) / 100
        elseif SN <= 10 then
            欲情 = pack.疼痛 * (75 + (SN - 5) * 5) / 100
        else
            欲情 = pack.疼痛 * (100 + (SN - 10)) * 2 / 100
        end

        if SN+SC <= 5 then
            反感 = pack.疼痛 * (80 - (SN+SC) * 10) / 100
        elseif SN+SC <= 10 then
            反感 = pack.疼痛 * (30 - (SN+SC - 5) * 5) / 100
        else
            反感 = pack.疼痛 * (5 + (SN+SC - 10) * 1) / 100
        end

        特性修正(active, function (type, tex)
            if tex.行为包转感觉包修正 then
                恐怖, 反感, 欲情 = tex:行为包转感觉包修正(active, type, "疼痛", 恐怖, 反感, 欲情)
            end
        end)

        feel.痛苦 = feel.痛苦 + pack.疼痛
        feel.恐怖 = feel.恐怖 + 恐怖
        feel.反感 = feel.反感 + 反感
        feel.欲情 = feel.欲情 + 欲情
        feel.屈从 = feel.反感 + pack.疼痛 + 恐怖 / 2 + 欲情
    end
    if pack.充足 ~= 0 then
        local 恭顺 = 0
        local 欲情 = 0

        if yuwan <= 5 then
            恭顺 = pack.充足 * (20 + yuwan * 6) / 100
            欲情 = pack.充足 * (30 + yuwan * 6) / 100
        elseif yuwan <= 10 then
            恭顺 = pack.充足 * (50 + (yuwan - 5) * 4) / 100
            欲情 = pack.充足 * (60 + (yuwan - 5) * 4) / 100
        else
            恭顺= pack.充足 * (70 + (yuwan - 10) * 1) / 100
            欲情= pack.充足 * (80 + (yuwan - 10) * 1) / 100
        end

        特性修正(active, function (type, tex)
            if tex.行为包转感觉包修正 then
                恭顺, 欲情 = tex:行为包转感觉包修正(active, type, "充足",恭顺, 欲情)
            end
        end)

        feel.恭顺 = feel.恭顺 + 恭顺
        feel.欲情 = feel.欲情 + 欲情
        feel.屈从 = feel.屈从 + 恭顺 + 欲情
    end
    if pack.不洁 ~= 0 then
        local 欲情 = pack.不洁
        local 反感 = 0

        local temp = math.max(SC, yuwan)
        if temp <= 5 then
            反感 = pack.不洁 * (100 - temp * 10) / 100
        elseif temp <= 10 then
            反感 = pack.不洁 * (50 - (temp - 5) * 10) / 100
        else
            反感 = pack.不洁 * (25 - (temp - 10) * 10) / 100
        end
        if(SN <= 10) then
            反感 = 反感 * (100 - SN * 10) / 100
        else
            反感 = 0
        end

        特性修正(active, function (type, tex)
            if tex.行为包转感觉包修正 then
                欲情, 反感 = tex:行为包转感觉包修正(active, type, "不洁", 欲情, 反感)
            end
        end)


        if 反感 <= 100 then
            反感 = 0
            欲情 = 欲情 / 10
        elseif 反感 <= 500 then
            欲情 = 欲情 / 20
        else
            欲情 = 0
        end

        feel.反感 = feel.反感 + 反感
        feel.欲情 = feel.欲情 + 欲情
    end
    if pack.露出 ~= 0 then
        local 羞耻 = pack.露出
        local 欲情 = 0
        local 反感 = 0

        if LC <= 5 then
            欲情 = pack.露出 * (5 + LC * 11) / 100
        elseif LC <= 10 then
            欲情 = pack.露出 * (60 + (LC - 5) * 6) / 100
        else
            欲情 = pack.露出 * (90 + (LC - 10) * 2) / 100
        end
        local temp = math.max(SC, yuwan)
        if temp <= 5 then
            反感 = pack.露出 * (30 + temp * 4) / 100
        elseif temp <= 10 then
            反感 = pack.露出 * (10 + (temp - 5)) / 100
        else
            反感 = pack.露出 * (5 + (temp - 10)) / 100
        end

        特性修正(active, function (type, tex)
            if tex.行为包转感觉包修正 then
                羞耻, 欲情, 反感 = tex:行为包转感觉包修正(active, type, "露出", 羞耻, 欲情, 反感)
            end
        end)

        feel.反感 = feel.反感 + 反感
        feel.欲情 = feel.欲情 + require("Data/参数"):DownPalamLv(欲情)
        feel.羞耻 = feel.羞耻 + 羞耻
    end
    if pack.屈从 ~= 0 then
        特性修正(active, function (type, tex)
            if tex.行为包转感觉包修正 then
                pack.屈从 = tex:行为包转感觉包修正(active, type, "屈从", pack.屈从)
            end
        end)
        feel.屈从 = pack.屈从
    end
    if pack.逃脱 ~= 0 then
        local 欲情 = pack.逃脱
        local 反感 = 0

        local temp = math.max(SC, yuwan)
        if temp <= 5 then
            反感 = pack.逃脱 * (80 - temp * 10) / 100
        elseif temp <= 10 then
            反感 = pack.逃脱 * (30 - (temp - 5) * 5) / 100
        else
            反感 = pack.逃脱 * (5 - (temp - 10) * 1) / 100
        end

        特性修正(active, function (type, tex)
            if tex.行为包转感觉包修正 then
                欲情, 反感 = tex:行为包转感觉包修正(active, type, "逃脱", 欲情, 反感)
            end
        end)
        feel.欲情 = feel.欲情 + 欲情
        feel.反感 = feel.反感 + 反感
    end

    feel.恐怖 = feel.恐怖 + pack.恐惧
    feel.小穴润滑 = feel.小穴润滑 + pack.小穴液体追加
    feel.菊穴润滑 = feel.菊穴润滑 + pack.菊穴液体追加
    feel.恭顺 = feel.恭顺 + pack.恭顺追加
    feel.欲情 = feel.欲情 + pack.欲情追加
    if pack.反感追加 ~= 0 then
        if SC <= 5 then
            feel.反感 = feel.反感 + pack.反感追加 * (100 - SC * 10) / 100
        elseif SC <= 10 then
            feel.反感 = feel.反感 + pack.反感追加 * (50 - (SC - 5) * 8) / 100
        else
            feel.反感 = feel.反感 + pack.反感追加 * (10 - (SC - 10) * 1) / 100
        end
    end
    return feel;
end

---@param pack ActionPack
---@param active ActiveMsg
function TrainManager:行为补正(active, pack)
    local multiPack = require("Data/ActionPack"):New()
    local multi = 0
    local Female = active.被调教者
    local Trainer = active.调教者

    if Female:检查特性("接受快感") then
        multi = multi + 30
    end
    if Female:检查特性("顿感") then
        multi = multi - 60
    end
    if Female:检查特性("两性通吃") then
        multi = multi + 10       
    elseif Female:检查特性("拒绝异性") then
        if Trainer.性别 == 3 or Trainer.性别 == Female.性别 then
            multi = multi + 10
        else
            multi = multi - 20
        end
    else
        if Trainer.性别 == Female.性别 then
            multi = multi - 20
        end
    end
    self.六感同加(multiPack, multi)

    特性修正(active, function(t, tex)
        if tex.调教行为补正 then
            tex:调教行为补正(active, multiPack, t)
        end
    end)

    for key, value in pairs(multiPack) do
        if key == "不洁" or key == "恐惧" or key == "逃脱" or key == "反感追加" then
            multiPack[key] = math.max(value, -99);
        else
            multiPack[key] = math.max(value, -80);
        end
        pack[key] = pack[key] * ((100 + multiPack[key]) / 100)
    end

end

---@param feel ActionPack
function TrainManager:感觉补正(active, feel)
    local pack = require("Data/FeelPack"):New()

    特性修正(active, function(type, tex)
        if tex.调教感觉补正 then
            tex:调教感觉补正(active, pack, type)
        end
    end)
end

function TrainManager:快感限制(chara, num, level)
    local id = TrainManager:查找ID(chara)
    if id ~= -1 then
        local yq = TrainManager.FeelPack[id].欲情
        if yq < 100 then
            level = level - 3
        elseif yq < 3000 then
            level = level - 2
        elseif yq < 10000 then
            level = level - 1
        end
    end
    if chara.状态.媚药 ~= nil and chara.状态.媚药 > 0 then
        level = level + math.floor(chara.状态 / 100)
    end

    if self:获取上次信息(id, "绝顶") ~= nil and self:获取上次信息(id, "绝顶") > 0 then
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

---@param active ActiveMsg
---@param pack FeelPack
function TrainManager:最终补正(active, pack)
    ---@type Character
    local trainee = active.被调教者

    if trainee.胸部 == nil then
        pack.胸部快感 = 0
    else
        local Bfeel = trainee.胸部.感觉
        if 检查特性(trainee.胸部, "淫乳") then
            Bfeel = Bfeel + 1
        end
        if trainee:检查特性("胸部性向") then
            Bfeel = Bfeel + 1
        end
        pack.胸部快感 = TrainManager:快感限制(trainee, pack.胸部快感, Bfeel)
    end
    if trainee.嘴部 == nil then
        pack.嘴部快感 = 0
    else
        local feel = trainee.嘴部.感觉
        if 检查特性(trainee.嘴部, "荡唇") then
            feel = feel + 1
        end
        if trainee:检查特性("嘴部性向") then
            feel = feel + 1
        end
        pack.嘴部快感 = TrainManager:快感限制(trainee, pack.嘴部快感, feel)
    end
    if trainee.阴部 == nil then
        pack.阴部快感 = 0
    else
        local feel = trainee.阴部.感觉
        if 检查特性(trainee.阴部, "淫核") then
            feel = feel + 1
        end
        if trainee:检查特性("阴部性向") then
            feel = feel + 1
        end
        pack.阴部快感 = TrainManager:快感限制(trainee, pack.阴部快感, feel)
    end
    if trainee.小穴 == nil then
        pack.小穴快感 = 0
    else
        local feel = trainee.小穴.感觉
        if 检查特性(trainee.小穴, "淫壶") then
            feel = feel + 1
        end
        if trainee:检查特性("小穴性向") then
            feel = feel + 1
        end
        pack.小穴快感 = TrainManager:快感限制(trainee, pack.小穴快感, feel)
    end
    if trainee.尿道 == nil then
        pack.尿道快感 = 0
    else
        local feel = trainee.尿道.感觉
        if 检查特性(trainee.尿道, "尿道狂") then
            feel = feel + 1
        end
        if trainee:检查特性("尿道性向") then
            feel = feel + 1
        end
        pack.尿道快感 = TrainManager:快感限制(trainee, pack.尿道快感, feel)
    end
    if trainee.菊穴 == nil then
        pack.菊穴快感 = 0
    else
        local feel = trainee.菊穴.感觉
        if 检查特性(trainee.菊穴, "淫尻") then
            feel = feel + 1
        end
        if trainee:检查特性("尿道性向") then
            feel = feel + 1
        end
        pack.菊穴快感 = TrainManager:快感限制(trainee, pack.尿道快感, feel)
    end
    if self.相同行动 then
        self.六感同加(pack, 1.25)
    end
    if pack.痛苦 >= 100 then
        local data = require("Data/参数")
        local n = UnityEngine.Mathf.Clamp(100 - data:获取等级(pack.痛苦) * 20 + trainee.获取能力("受虐属性") * 20, 10, 110)
        self.六感同加(pack, (n / 100))

        active.体力减少 = (100 + (data:获取等级(pack.痛苦) * (data:获取等级(pack.痛苦) + 1) / 2) * 10) / 100 * active.体力减少
    end
    if active.乘数 ~= nil then
        for key, value in pairs(pack) do
            pack[key] = value * active.乘数
        end
    end

    active.feelpack = pack
end

---@param active ActiveMsg
function TrainManager:体力处理(active)
   local hp = active.体力减少;

   特性修正(active, function(t, tex)
    if tex.调教体力修正 ~= nil then
        hp = tex:调教体力修正(active, hp, t)
    end
    end)
    active.体力减少 = active.体力减少 + hp
end


---@param active ActiveMsg
---@param pack ActionPack
function TrainManager:射精处理(active, pack)
    local text = SB:New()
    text:AppendLine("选择射在哪里")
    text:Append(AddButton("直接发射   ","CoroutineResume,直接发射"))
    text:Append(AddButton("射在外面   ","CoroutineResume,射在外面"))
    text:Append(AddButton("脸部   ","CoroutineResume,脸部"))
    text:Append(AddButton("身上   ","CoroutineResume,身上"))
    Message : AddMessage(text:ToStr())
    Message : StartPop()
    local select = coroutine.yield()
    Message : Continue()
    local place = ""
    if select == "射在外面" then
        place = "外面"
    elseif select == "脸部" then
        place = "脸部"
    elseif select == "身上" then
        place = "身上"
    elseif select == "直接发射" then
        if active.调教者.阴部.位置 == nil or active.调教者.阴部.位置 == "" then
            place = "外面"
        else
            place = active.调教者.阴部.位置
        end
    end

    local jy = active.被调教者:获取能力("精液成瘾")
    local s = math.floor(active.调教者.阴部.精液 / 10000)
    local 精子数 = math.random(50, 150);--基本值
    if active.调教者:检查特性("精液浓厚") then
        精子数 = 精子数 * s * 1.5
    elseif active.调教者:检查特性("精液稀薄") then
        精子数 = 精子数 * s * 0.5
    end
    TrainManager:获得经验("射精经验", s, active.调教者)

    pack.成就感 = pack.成就感 * (jy * 0.5 + 1)
    pack.屈从 = pack.屈从 * (jy * 0.5 + 1)
    if place == "小穴" then
        local n = 50 * Female.Mark[4]
        pack.充足 = pack.充足 + n * (jy - 1)
        pack.不洁 = pack.不洁 + 20
        TrainManager:获得经验("腔内精液经验", s)
    elseif place == "肛门" then
        pack.充足 = pack.充足 + 50 * (jy - 1)
        pack.不洁 = pack.不洁 + 50
        TrainManager:获得经验("肛内精液经验", s)
    elseif place == "尿道" then
        pack.充足 = pack.充足 + 100 * (jy - 1)
        pack.不洁 = pack.不洁 + 200
        TrainManager:获得经验("膀胱精液经验", s)
    elseif place == "口腔" then
        pack.充足 = pack.充足 + 250 * (jy - 1)
        pack.不洁 = pack.不洁 + 50
        TrainManager:获得经验("饮精经验", s)
    elseif place == "胸部" then
        pack.充足 = pack.充足 + 200 * (jy - 1)
        pack.不洁 = pack.不洁 + 100
        TrainManager:获得经验("精液经验", s)
    elseif place == "身上" then
        pack.充足 = pack.充足 + 150 * (jy - 1)
        pack.不洁 = pack.不洁 + 100
        TrainManager:获得经验("精液经验", s)
    elseif place == "脸部" then
        pack.充足 = pack.充足 + 300 * (jy - 1)
        pack.不洁 = pack.不洁 + 100
        TrainManager:获得经验("颜射经验", s)
    end

    if place == "小穴" then
        local SPERM = 精子数 + (math.random(-10,11) * 10)
        if SPERM < 0 then
            return
        end
        if place == "子宫" then
            SPERM = SPERM * 3
        end
        active.调教者.阴部.精液 = 0
        active.被调教者.子宫.精子数 = SPERM
    end
end


---@param active ActiveMsg
---@param feel FeelPack
function TrainManager:绝顶处理(active, feel)
    local Orgasms = {阴部快感 = 0, 小穴快感 = 0, 菊穴快感 = 0, 尿道快感 = 0, 胸部快感 = 0, 嘴部快感 = 0}
    local data = require("Data/ActionPack"):New()
    local id = self:查找ID(active.被调教者)
    local trainee = active.被调教者
    for key, value in pairs(Orgasms) do
        if feel[key] >= 100000 then
            Orgasms[key] = 5
        elseif feel[key] >= 60000 then
            Orgasms[key] = 4
        elseif feel[key] >= 30000 then
            Orgasms[key] = 3
        elseif feel[key] >= 20000 then
            Orgasms[key] = 2
        elseif feel[key] >= 10000 then
            Orgasms[key] = 1
        end
        local ty = string.sub(key, 1, 2)
        if Orgasms[key] > 0 then
            self:添加记录(id, ty.."绝顶", Orgasms[key])
        end
    end

    local orgasmsNumber = 0
    local Otypes = 0

    if Orgasms["阴部快感"] > 0 then
        data.露出 = 300 * Orgasms["阴部快感"]
        if 检查特性(trainee.阴部, "淫核") or trainee:检查特性("阴部性向") then
            data.屈从 = data.屈从 + 1000
        end
        orgasmsNumber = orgasmsNumber + Orgasms["阴部快感"]
        Otypes = Otypes + 1

        被调教者修正(trainee, "阴部", function (部位, tex)
            if tex.绝顶修正 ~= nil then
                tex:绝顶修正(trainee, data, 部位, Orgasms["阴部快感"])
            end
        end)
    end
    if Orgasms["小穴快感"] > 0 then
        data.露出 = data.露出 + 500 * Orgasms["小穴快感"]
        data.屈从 = data.屈从 + 500
        data.欲情追加 = data.欲情追加 + 500
        if 检查特性(trainee.小穴, "淫壶") or trainee:检查特性("小穴性向") then
            data.屈从 = data.屈从 + 1000
        end
        orgasmsNumber = orgasmsNumber + Orgasms["小穴快感"]
        Otypes = Otypes + 1

        local wlevel = Orgasms["小穴快感"] * 150

        data.小穴液体追加 = data.小穴液体追加 + wlevel
        data.露出 = data.露出 + wlevel / 2

        被调教者修正(trainee, "小穴", function (部位, tex)
            if tex.绝顶修正 ~= nil then
                tex:绝顶修正(trainee, data, 部位, Orgasms["小穴快感"])
            end
        end)
    end
    if Orgasms["菊穴快感"] > 0 then
        data.露出 = data.露出 + 1000 * Orgasms["菊穴快感"]
        data.屈从 = data.屈从 + 2000
        data.欲情追加 = data.欲情追加 + 500
        if 检查特性(trainee.菊穴, "淫尻") or trainee:检查特性("菊穴性向") then
            data.屈从 = data.屈从 + 1000
        end
        orgasmsNumber = orgasmsNumber + Orgasms["菊穴快感"]
        Otypes = Otypes + 1

        被调教者修正(trainee, "菊穴", function (部位, tex)
            if tex.绝顶修正 ~= nil then
                tex:绝顶修正(trainee, data, 部位, Orgasms["菊穴快感"])
            end
        end)
    end
    if Orgasms["尿道快感"] > 0 then
        data.露出 = data.露出 + 1000 * Orgasms["尿道快感"]
        data.屈从 = data.屈从 + 2000
        if trainee:检查特性("尿道性向") or 检查特性(trainee.尿道, "尿道狂") then
            data.屈从 = data.屈从 + 1000
        end
        data.欲情追加 = data.欲情追加 + 500
        orgasmsNumber = orgasmsNumber + Orgasms["尿道快感"]
        Otypes = Otypes + 1

        被调教者修正(trainee, "尿道", function (部位, tex)
            if tex.绝顶修正 ~= nil then
                tex:绝顶修正(trainee, data, 部位, Orgasms["尿道快感"])
            end
        end)
    end
    if Orgasms["胸部快感"] > 0 then
        data.露出 = data.露出 + 300 * Orgasms["胸部快感"]
        if 检查特性(trainee.胸部, "淫乳") or trainee:检查特性("胸部性向") then
            data.屈从 = data.屈从 + 1000
        end
        orgasmsNumber = orgasmsNumber + Orgasms["胸部快感"]
        Otypes = Otypes + 1

        被调教者修正(trainee, "胸部", function (部位, tex)
            if tex.绝顶修正 ~= nil then
                tex:绝顶修正(trainee, data, 部位, Orgasms["胸部快感"])
            end
        end)
    end
    if Orgasms["嘴部快感"] > 0 then
        data.露出 = data.露出 + 300 * Orgasms["嘴部快感"]
        if 检查特性(trainee.嘴部, "嘴部性向") or trainee:检查特性("嘴部性向") then
            data.屈从 = data.屈从 + 1000
        end
        orgasmsNumber = orgasmsNumber + Orgasms["嘴部快感"]
        Otypes = Otypes + 1
        被调教者修正(trainee, "嘴部", function (部位, tex)
            if tex.绝顶修正 ~= nil then
                tex:绝顶修正(trainee, data, 部位, Orgasms["嘴部快感"])
            end
        end)
    end

    
    if Otypes == 0 then
        return
    end

    data.逃脱 = data.逃脱 - 20
    data.露出 = data.露出 - 20
    data.反感追加 = data.反感追加 -  20
    data.屈从 = data.屈从 * Otypes
    data.欲情追加 = data.欲情追加 * Otypes
    data.恭顺追加 = data.恭顺追加 * Otypes

    self:添加记录(id, "绝顶", Otypes)
    TrainManager:获得经验("绝顶经验", orgasmsNumber)
    local Reactive = { 被调教者 = trainee, 行为 = "绝顶"}
    local Refeel = TrainManager:ToFeelPack(Reactive, data)

    require("Data/FeelPack"):Add(feel, Refeel)
    --文本
    local text = SB:New()
    if Otypes == 6 then
        text:Append("六重")
    elseif Otypes == 5 then
        text:Append("五重")
    elseif Otypes == 4 then
        text:Append("四重")
    elseif Otypes == 3 then
        text:Append("三重")
    elseif Otypes == 2 then
        text:Append("二重")
    else
        for key, value in pairs(Orgasms) do
            if value > 0 then
                text:Append(key)
            end
        end
    end
    local avg = orgasmsNumber / Otypes
    if avg > 4 then
        text:Append("超强绝顶")
    elseif avg > 2 then
        text:Append("强绝顶")
    else
        text:Append("绝顶")
    end
    Message : AddMessage(text:ToStr())
    trainee:调用口上("绝顶", Orgasms, Otypes, orgasmsNumber)
end

function TrainManager:经验处理(active, pack)
    local 调教者 =active.调教者
    local 被调教者 =active.被调教者

    if 调教者.性别 == "女" and 被调教者.性别 == "女" then
        self:获得经验("百合经验", 1)
    elseif 调教者.性别 == "男" and 被调教者.性别 == "男" then
        self:获得经验("断袖经验", 1)
    end
    

    local value = pack.菊穴快感 + pack.阴部快感 + pack.小穴快感 + pack.胸部快感 + pack.嘴部快感 + pack.尿道快感 + pack.欲情
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

    if active.sex:SexType("侍奉快乐") then
        temp = LOCAL + 1
        if 被调教者.状态.媚药 ~= nil and 被调教者.状态.媚药 > 0 then
            temp = temp - math.floor(被调教者.状态.媚药 / 50)
        end
        if active.sex:SexType("嗜虐快乐") and 被调教者:获取能力("侍奉精神") <= 被调教者:获取能力("施虐属性") then
            temp = temp - 1
        end
        if temp > 0 then
            TrainManager:获得经验("侍奉快乐经验", temp)
        end
    end

    temp = 0
    if active.sex:SexType("嗜虐快乐") then
        temp = LOCAL + 1
        if 被调教者.状态.媚药 ~= nil and 被调教者.状态.媚药 > 0 then
            temp = temp - math.floor(被调教者.状态.媚药 / 50)
        end
        if active.sex:SexType("侍奉快乐") and 被调教者:获取能力("侍奉精神") >= 被调教者:获取能力("施虐属性") then
            temp = temp - 1
        end
        if temp > 0 then
            TrainManager:获得经验("嗜虐快乐经验", temp)
        end
    end


    LOCAL = math.min(value, pack.羞耻)
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
    if active.sex:SexType("羞耻快乐") then
        temp = LOCAL + 1
        if 被调教者.状态.媚药 ~= nil and 被调教者.状态.媚药 > 0 then
            temp = temp - math.floor(被调教者.状态.媚药 / 50)
        end
        if temp > 0 then
            TrainManager:获得经验("羞耻快乐经验", temp)
        end
    end
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
    if active.sex:SexType("被虐快乐") then
        temp = LOCAL + 1
        if 被调教者.状态.媚药 ~= nil and 被调教者.状态.媚药 > 0 then
            temp = temp - math.floor(被调教者.状态.媚药 / 50)
        end
        if temp > 0 then
            TrainManager:获得经验("被虐快乐经验", math.max(temp,0))
        end
    end

end

function TrainManager:刻印处理(trainee, pack)
    local Orgasms = {"阴部快感", "小穴快感", "菊穴快感", "尿道快感", "胸部快感", "嘴部快感"}
    local happy = 0
    for int, value in ipairs(Orgasms) do
        happy = happy + pack[value]
    end
    local happyMark = 0
    if happy > 30000 then
        happyMark = 3
    elseif happy > 10000 then
        happyMark = 2
    elseif happy > 3000 then
        happyMark = 1
    end

    if happyMark > trainee.刻印["快乐刻印"] then
        local text = "取得了快乐刻印Lv"..happyMark
        trainee.刻印["快乐刻印"] = happyMark
        if trainee:获取能力("顺从") < happyMark - 1 and not trainee:检查特性("冷漠") and not trainee:检查特性("感情缺乏") then
            trainee:能力提升("顺从", 1)
            AbliTable["顺从"] = nil
            text = text.."\n同时顺从变成了Lv"..trainee:获取能力("顺从")
        end
        Message : AddMessage(text)
    end

    local pain = pack.痛苦
    local painMark = 0
    if pain > 30000 then
        painMark = 3
    elseif pain > 20000 then
        painMark = 2
    elseif pain > 10000 then
        painMark = 1
    end
    if painMark > trainee.刻印["痛苦刻印"] then
        local text = "取得了痛苦刻印Lv"..painMark
        trainee.刻印["痛苦刻印"] = painMark
        Message : AddMessage(text)
    end

    local surrender = pack.屈从
    local surrenderMark = 0
    if surrender > 30000 then
        surrenderMark = 3
    elseif surrender > 20000 then
        surrenderMark = 2
    elseif surrender > 10000 then
        surrenderMark = 1
    end
    if surrenderMark > trainee.刻印["屈从刻印"] then
        local text = "取得了屈从刻印Lv"..surrenderMark
        trainee.刻印["屈从刻印"] = surrenderMark
        Message : AddMessage(text)
    end

    local Revolt = pack.反感
    local RevoltMark = 0
    if trainee.刻印["快乐刻印"] == 1 then
        Revolt = Revolt - 100
    elseif trainee.刻印["快乐刻印"] == 2 then
        Revolt = Revolt - 500
    elseif trainee.刻印["快乐刻印"] == 3 then
        Revolt = Revolt - 1000
    end
    if trainee.刻印["痛苦刻印"]  == 1 then
        Revolt = Revolt - 500
    elseif trainee.刻印["痛苦刻印"]  == 2 then
        Revolt = Revolt - 1500
    elseif trainee.刻印["痛苦刻印"]  == 3 then
        Revolt = Revolt - 4000
    end
    if trainee.刻印["屈从刻印"] == 1 then
        Revolt = Revolt - 500
    elseif trainee.刻印["屈从刻印"] == 2 then
        Revolt = Revolt - 1500
    elseif trainee.刻印["屈从刻印"] == 3 then
        Revolt = Revolt - 2000
    end
    if Revolt > 3000 then
        RevoltMark = 3
    elseif Revolt > 1500 then
        RevoltMark = 2
    elseif Revolt > 800 then
        RevoltMark = 1
    end

    if RevoltMark >  trainee.刻印["反抗刻印"] then
        local text = "取得了反抗刻印Lv"..RevoltMark
        trainee.刻印["反抗刻印"] = RevoltMark
        if trainee:获取能力("顺从") > 0 and  trainee:获取能力("顺从") < 3 and not trainee:检查特性("感情缺乏") then
            trainee:设置能力("顺从", math.max( trainee:获取能力("顺从") - RevoltMark, 0))
            text = text.."\n同时顺从下降到了Lv"..trainee:获取能力("顺从")
        end
        Message : AddMessage(text)
    end
end

function TrainManager:好感处理()
    
end

function TrainManager:堕落处理()
    
end

function TrainManager:服从处理()
    
end

function TrainManager:其他处理()
    
end

function TrainManager:重置变量()
    TrainManager.体力减少 = 0
    self.上次行为 = self.行为
    self.上次选择 = self.选择

    ---@type ActiveMsg
    for i = #self.行为栈, 1, -1 do
        self.行为栈[i].次数 = self.行为栈[i].次数 - 1
        if self.行为栈[i].次数 == 0 then
            table.remove(self.行为栈, i)
        end
    end

    for index, chara in ipairs(self.参与人员) do
        for key, state in pairs(chara.状态) do
            local s = require("Data/状态/"..key)
            if s.更新 then
                s:更新(chara)
            end
        end
    end
    self.经验栈 = {}
    self.回合数 = self.回合数 + 1

    上次记录 = 本次记录
    for key, value in pairs(本次记录) do
        本次记录[key] = {}
    end
end

---@param active ActiveMsg
function TrainManager:输出口上(active)
    active.sex:TrainMessage(active);
    local kj = require(("Chara/%s/KouJiu"):format(self.被调教者.口上))
    if type(kj[active.行为]) == "function" then
        kj[active.行为](active)
    end
end

function TrainManager:输出(charas)
    local text = SB:New()
    for index, value in ipairs(self.经验栈) do
        text:AppendLine(value)
    end
    Message:AddMessage(text:ToStr())
    for id, feel in pairs(charas) do
        local chara = self.参与人员[id]
        text = SB:New()

        Message:AddMessage(chara.名字.."感觉变化")
        for index, value in ipairs(self.FeelList) do
            text:AppendLine(("%s:%d + %d = %d"):format(value, self.FeelPack[id][value] - feel[value], feel[value], self.FeelPack[id][value]))
        end
        Message:AddMessage(text:ToStr())
    end




    Message:StartPop()
end

function TrainManager:最终处理()
end

---@param pack ActionPack
---@param value number
function TrainManager:性癖增益(pack, value)
    local d = require("Data/参数")
    pack.充足 = pack.充足 + d:DownPalamLv(value, 1) + 100
    pack.不洁 = pack.不洁 + math.max(d:DownPalamLv(pack.不洁, 1) - 500, 0)
    pack.逃脱 = pack.逃脱 + math.max(d:DownPalamLv(pack.逃脱, 1) - 500, 0)
    pack.恐惧 = pack.恐惧 + math.max(d:DownPalamLv(pack.恐惧, 1) - 500, 0)
    pack.反感追加 = pack.反感追加 + math.max(d:DownPalamLv(pack.反感追加, 1) - 500, 0)
end

function TrainManager:获得经验(exp, n, chara)
    chara = chara or self.被调教者

    if chara.经验 ~= nil then
        if chara.经验[exp] == nil then
            chara.经验[exp] = n
        else
            chara.经验[exp] = chara.经验[exp] + n
        end
        table.insert(self.经验栈, ("%s获得了%d点%s"):format(chara.名字, n, exp))
    else
        error("角色经验表为 nil")
    end
end

function TrainManager:添加记录(id, mess, n)
    if 本次记录[id][mess] == nil then
        本次记录[id][mess] = n
    else
        本次记录[id][mess] = 本次记录[id][mess] + n
    end
    if self.总记录[id][mess] == nil then
        self.总记录[id][mess] = n
    else
        self.总记录[id][mess] = self.总记录[id][mess] + n
    end
end

function TrainManager:获取当前信息(id, mess)
    if type(id) == "table" then
        id = self:查找ID(id)
    end
    if 本次记录[id] ~= nil and type(本次记录[id][mess]) == "number" then
        return 本次记录[id][mess]
    end
    return 0
end

function TrainManager:获取上次信息(id, mess)
    if type(id) == "table" then
        id = self:查找ID(id)
    end

    if 上次记录[id] ~= nil and type(上次记录[id][mess]) == "number" then
        return 上次记录[id][mess]
    end
    return 0
end

function TrainManager.六感同加(data, num)
    data.阴部快感 = data.阴部快感 + num
    data.菊穴快感 = data.菊穴快感 + num
    data.小穴快感 = data.小穴快感 + num
    data.嘴部快感 = data.嘴部快感 + num
    data.胸部快感 = data.胸部快感 + num
    data.尿道快感 = data.尿道快感 + num
end

function TrainManager:查找ID(chara)
    for index, value in ipairs(self.参与人员) do
        if value == chara then
            return index
        end
    end
    print("未找到"..chara.Name)
    return -1
end

function TrainManager:转化宝珠(chara, feel)
    local orb = require("Data/宝珠"):New()

    for key, value in pairs(orb) do
        local n = feel[key]
        local var = 0
        if n < 100 then
            var = 0
        elseif n < 500 then
            var = 1 + (n - 100) * 9 / 399
        elseif n < 3000 then
            var = 10 + (n - 500) * 90 / 2499
        elseif n < 10000 then
            var = 100 + (n - 3000) * 900 / 6999
        elseif n < 30000 then
            var = 1000 + (n - 10000) * 1000 / 29999
        elseif n < 60000 then
            var = 2000 + (n - 30000) * 1000 / 29999
        elseif n < 100000 then
            var = 3000 + (n - 60000) * 2000 / 39999
        elseif n < 150000 then
            var = 5000 + (n - 100000) * 3000 / 49999
        elseif n < 250000 then
            var = 8000 + (n - 150000) * 4000 / 99999
        elseif n < 500000 then
            var = 12000 + (n - 250000) * 4000 / 249999
        elseif n < 1000000 then
            var = 16000 + (n - 500000) * 4000 / 499999
        else
            var = 20000 + (n - 1000000) * 5000 / 3999999
        end

        if TrainManager.总记录 ~= nil then
            if key == "嘴部快感" and TrainManager.总记录["嘴部绝顶"] ~= nil then
                var = TrainManager.总记录["嘴部绝顶"] * 500 + var
                if 检查特性(chara.嘴, "嘴部性向") then
                    var = var * 1.5
                end
            end
            if key == "胸部快感" and TrainManager.总记录["胸部绝顶"] ~= nil then
                var = TrainManager.总记录["胸部绝顶"] * 500 + var
                if 检查特性(chara.胸部, "胸部性向") then
                    var = var * 1.5
                end
            end
            if key == "阴部快感" and TrainManager.总记录["阴部绝顶"] ~= nil then
                var = TrainManager.总记录["阴部绝顶"] * 500 + var
                if 检查特性(chara.阴部, "阴部性向") then
                    var = var * 1.5
                end
            end
            if key == "小穴快感" and TrainManager.总记录["小穴绝顶"] ~= nil then
                var = TrainManager.总记录["小穴绝顶"] * 500 + var
                if 检查特性(chara.小穴, "小穴性向") then
                    var = var * 1.5
                end
            end
            if key == "菊穴快感" and TrainManager.总记录["菊穴绝顶"] ~= nil then
                var = TrainManager.总记录["菊穴绝顶"] * 500 + var
                if 检查特性(chara.菊穴, "菊穴性向") then
                    var = var * 1.5
                end
            end
            if key == "尿道快感" and TrainManager.总记录["尿道绝顶"] ~= nil then
                var = TrainManager.总记录["尿道绝顶"] * 500 + var
                if 检查特性(chara.尿道, "尿道性向") then
                    var = var * 1.5
                end
            end
        end
        var = math.floor(var)

        orb[key] = var
    end

    return orb
end

function TrainManager:AllowAction(Trainer ,Female)
    local value = 0
    local text = SB:New()

    local temp = math.min(Female:获取能力("顺从"), 10)
    value = self:OrderRequire(Female, value, text, "abl", "顺从", temp * 2)

    temp = math.min(Female:获取能力("欲望"), 10)
    value = self:OrderRequire(Female, value, text, "abl", "欲望", temp * 2)

    temp = Female.刻印["痛苦刻印"] * 5--痛苦刻印
    value = self:OrderRequire(Female, value, text, "abl", "痛苦刻印", temp)

    temp = Female.刻印["屈从刻印"] * 3
    value = self:OrderRequire(Female, value, text, "abl", "屈从刻印", temp)

    temp = Female.刻印["快乐刻印"] * 2
    value = self:OrderRequire(Female, value, text, "abl", "快乐刻印", temp)

    temp = Female.刻印["反抗刻印"] * -5
    value = self:OrderRequire(Female, value, text, "abl", "反抗刻印", temp)

    local id = self:查找ID(Female)
    local data = require("Data/参数")

    temp = data:获取等级(self.FeelPack[id].欲情)
    value = self:OrderRequire(Female, value, text, "abl", "欲情", temp )
    temp = data:获取等级(self.FeelPack[id].恐怖)
    value = self:OrderRequire(Female, value, text, "abl", "恐怖", temp)
    temp = data:获取等级(self.FeelPack[id].屈从)
    value = self:OrderRequire(Female, value, text, "abl", "恐怖", temp)

    value = TrainManager:OrderRequire(Female, value, text, "talent", "叛逆", -10)
    value = TrainManager:OrderRequire(Female, value, text, "talent", "坚强", -5)
    value = TrainManager:OrderRequire(Female, value, text, "talent", "坦率", 5)
    value = TrainManager:OrderRequire(Female, value, text, "talent", "高傲", -15)
    value = TrainManager:OrderRequire(Female, value, text, "talent", "谦虚", 5)
    value = TrainManager:OrderRequire(Female, value, text, "talent", "喜欢引人注目", 2)
    value = TrainManager:OrderRequire(Female, value, text, "talent", "好色", 2)
    value = TrainManager:OrderRequire(Female, value, text, "talent", "淫乱", 2)


    if Female.性别 ~= "中性" and Trainer.性别 ~= "中性" and Female.性别 == Trainer.性别 then
        if Female: 检查特性("接受同性") then
            value = value + 5
            SB.append(text,"接受同性：(5)")
        elseif Female: 检查特性("拒绝同性") then
            value = value - 5
            SB.append(text,"拒绝同性：(-5)")
        end
    end

    if table.Exist(TrainManager.调教地点特性, "摄像机") then
        value = value - 10
        text.append(text,"摄像机：(-10)")
    end
    if table.Exist(TrainManager.调教地点特性, "野外PLAY") then
        value = value - 10
        text.append(text,"野外PLAY：(-10)")
    end
    return value, text
end

function TrainManager:OrderRequire(Female, value, text, type, name, num)
    if type == "talent" then
        if Female:检查特性(name) then
            value = value + num
        else
            return value
        end
    elseif type == "abl" then
        if num ~= 0 then
            value = value + num
        else
            return value
        end
    elseif type == "feel" then
        num = Female[name].感觉
        if num ~= 0 then
            num = num * num
            value = value + num
        else
            return value
        end
    elseif type == "equip" then
        if Female:检查性玩具(name) then
            value = value + num
        else
            return value
        end
    elseif type == "state" then
        if Female:检查状态(name) then
            value = value + num
        else
            return value
        end
    elseif type == "prev" then
        if self:获取上次信息(name) ~= 0 then
            value = value + num
        else
            return value
        end
    elseif type == "sex" then
        if Female.性别== name then
            value = value + num
        else
            return value
        end
    elseif type == "place" then
        if self.调教地点特性[name] then
            value = value + num
        else
            return value
        end
    else
        return value
    end
    text:Append(("%s：(%s)"):format(name, num))
    return value
end

function TrainManager:SMPlay(active, type)
    local base = require("Data/ActionPack"):New()
    local m = active.被调教者:获取能力("受虐属性")
    local s = active.调教者:获取能力("施虐属性")


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

function TrainManager:精液处理(trainer, female, samen, type)
    samen = samen * (female:获取能力("精液中毒") + 10) / 10
    if type == "乳" then
        if female:检查特性("淫乳", "胸部") then
            samen = samen * 1.5
        end
        samen = self:EXABL(female:获取经验等级("乳交经验"), samen)
        samen = samen * ((female:获取能力("侍奉技术") / 2) + 10) / 10
        local b = female.胸部.大小
        if b >= 5 then
            samen = samen * 2
        elseif b == 4 then
            samen = samen * 1.5
        elseif b == 3 then
            samen = samen * 1.2
        elseif b < 2 then
            samen = samen * 0.7
        end
    elseif type == "小穴" or type == "菊穴" then
        if trainer : 获取经验(type.."插入经验") + trainer : 获取经验(type.."插入经验") == 0 then
            samen = samen * 3
        end
        if female.检查特性("处女", "小穴") then
            samen = samen * 1.5
        else
            samen = (samen * (female : 获取经验等级(type.."性交经验") + 100) / 100)
        end
        local n = female[type].扩张度 - trainer.阴部.大小
        if n <= 0 then
            samen = samen * 1.2
        elseif n <= female.小穴.感觉 then
            local t = UnityEngine.Mathf.Clamp(150 * female.当前体力 / female.体力, 25 , 100)
            samen = samen * t / 100
        else
            local t = UnityEngine.Mathf.Clamp(120 * female.当前体力 / female.体力, 10 , 100)
            samen = samen * t / 100
        end
    elseif type == "口" then
        samen = TrainManager:EXABL(female : 获取经验等级("口交经验"), samen)
        samen = samen * ((female:获取能力("侍奉技术") / 2) + 10) / 10
        local c = female.嘴部.扩张度 - trainer.阴部.大小
        if c >= 1 then
            samen = samen * 0.8
        elseif c < 0 then
            samen = samen * 1.2
        end
        if Female:检查特性("荡唇", "嘴部") then
            samen = samen * 1.5
        end

    elseif type == "手" then
        samen = TrainManager:EXABL(female : 获取经验等级("手淫经验"), samen)
        samen = samen * ((female:获取能力("侍奉技术") / 2) + 10) / 10
    elseif type == "足" then
        samen = TrainManager:EXABL(female : 获取经验等级("足交经验"), samen)
        samen = samen * ((female:获取能力("侍奉技术") / 2) + 10) / 10
    end
    return samen
end

---@param active ActiveMsg
---@return ActionPack
function TrainManager:ServicePlay(active)
    local Active = active.行为
    local Female = active.被调教者
    local data = require("Data/参数")

    local base = require("Data/ActionPack"):New()
    local sf = Female:获取能力("侍奉精神")
    if sf == 0 then
        base.性行动 = 100
        base.成就感 = 50
        base.逃脱 = 400
    elseif sf == 1 then
        base.性行动 = 500
        base.成就感 = 200
        base.逃脱 = 200
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
    local temp = 0
    if active.目标.技巧 then
     temp = active.目标.技巧
    end
    if Active == "侍奉舔阴" then
        base.性行动 = base.性行动 * 1.8
        base.成就感 = base.成就感 * 1.8
        temp = temp + data:获取经验等级(Female : 获取经验("口交经验"))
    elseif Active == "手淫" then
        temp = temp + data:获取经验等级(Female : 获取经验("手淫经验"))
    elseif Active == "口交" then
        base.性行动 = base.性行动 * 1.5
        base.成就感 = base.成就感 * 1.5
        temp = temp + data:获取经验等级(Female : 获取经验("口交经验"))
    elseif Active == "乳交" then
        temp = temp + data:获取经验等级(Female : 获取经验("乳交经验"))
    elseif Active == "素股" then
        temp = temp + Female:获取能力("性交成瘾")
    elseif Active == "强制口交" or Active == "肛门侍奉" then
        base.性行动 = base.性行动 * 2
        base.成就感 = base.成就感 * 2
        temp = temp + Female:获取能力("口交经验")
    elseif Active == "足交" then
        temp = temp + Female:获取能力("施虐属性") * 0.5 + data:获取经验等级(Female : 获取经验("足交经验")) * 0.5
    elseif Active == "舔足" then
        temp = temp + Female:获取能力("受虐属性")
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

function TrainManager:获取人物状态(name, chara)
    chara = chara or self.被调教者
    local id = self:查找ID(chara)
    if id == nil then
        Message : AddTopMessage("获取人物状态失败")
        return 0
    end
    if self.FeelPack[id][name] ~= nil then
        return self.FeelPack[id][name]
    end
    Message : AddTopMessage("获取状态失败,属性名称:"..name)
    return 0
end


---@param active ActiveMsg
function TrainManager:AddLust(active)
    if active.sex.SexType("侍奉快乐") and active.sex.SexType("嗜虐快乐") then
        return 150 * math.max(active.被调教者.获取能力("侍奉技术"), active.被调教者.获取能力("施虐属性"))
    elseif active.sex.SexType("侍奉快乐") then
        return 150 * active.被调教者.获取能力("侍奉技术")
    else
        return 150 * active.被调教者.获取能力("施虐属性")
    end
end


---@param value number
---@param text string
---@param need number
---@return boolean
function TrainManager:ShowOrder(value, text, need)
    local output = SB:New()

    for index, v in ipairs(text) do
        output:Append(v)
        output:Append("+")
    end
    output[#output] = nil
    SB.Append(output," = "..value)
    if value > need then
        SB.Append(output," > "..need)
    elseif value == need then
        SB.Append(output," = "..need)
    else
        SB.Append(output," < "..need)
    end
    Message : AddMessage(output:ToStr())
    if value >= need then
        return true
    else
        return false
    end

end

---@param type string
---@param Female Character
---@return integer
function TrainManager:扩张(type, 阴部, Female)
    local Add = 0
    local exp = 0
    local hard = 阴部.硬度 or 0
    local size = 阴部.大小 or 0
    local Data = require("Data/参数")

    if hard > 2 then
        Add = Add + 1
    end
    if Female:检查特性("扩张适应") then
        Add = Add + 1
    end

    Add = Add + size - Female[type].扩张度 - 2
    if Female:检查特性("处女", type) then
        Add = Add - 1
    end

    self.当前行为.体力减少 = self.当前行为.体力减少 + 5 * Add

    if size < 2 then
        return 0
    end

    exp = size - Female[type].扩张
    local level = Data:获取经验等级(Female : 获取经验(type.."扩张经验")) + 1
    local temp = Data.经验等级[level]

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
        Add = UnityEngine.Mathf.Round((temp + 5) / 10)
        if hard == 1 then
            Add = 1
        elseif hard == 2 then
            Add = math.min(Add, 2)
        end
    elseif exp == 2 then
        Add = UnityEngine.Mathf.Round((temp + 1) / 3)
    elseif exp >= 3 then
        Add = temp
    end
    if hard >= 3 then
        Add = math.max(Add, size)
    end

    Add = UnityEngine.Mathf.Clamp(Add, 1, 20)

    TrainManager:获得经验(type.."扩张经验", Add)
end

return TrainManager