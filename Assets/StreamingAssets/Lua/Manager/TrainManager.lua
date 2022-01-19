TrainManager = 
{  
    FeelPack = {},
    FeelList =
    {
        "嘴部快感",
        "胸部快感",
        "阴蒂快感",
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

---开始调试所用方法
---第一个作为调教者，第二个作为被调教者，第三个为助手，后续为其他被调教者
---@param ... Character[]
function TrainManager:StartTrain(...)
    local t = {...}
    local pack = require("Data/FeelPack")
    if #t < 2 then
        return false
    end


    self.记录 = {}
    for i, value in ipairs(t) do
        if value.Type == nil or value.Type ~= "Character" then
            Message:AddTopMessage("调教管理器：传入参数类型不符")
            return false
        end
        self.FeelPack[i] = pack:New()
        self.记录[i] = {}
    end

    --初始化

    self.上次行为 = ""
    self.上次选择 = ""
    self.行为 = ""
    self.选择 = ""
    TrainManager.体力减少 = 0
    self.总记录 = {}
    self.经验栈 = {}
    self.行为栈 = {}
    self.调教地点特性 = {}
    TrainManager.参与人员 = t
    TrainManager.调教者 = t[1]
    TrainManager.被调教者 = t[2]
    if #t >= 3 then
        TrainManager.助手 = t[3]
    else
        TrainManager.助手 = nil
    end
    TrainManager.Line = 0
    return true
end

function TrainManager:EndTrain()
    
end

local function 检查占用(Table, n)
    if Table ~= nil and Table.持有 ~= nil then

        if n ~= nil then
            if Table.持有[n] then
                return true
            end
        elseif #Table.持有 == 0 then
            return true
        end
    end
    return false
end

local function 检查特性(t, abl)
    if t ~= nil and t.特性 ~= nil then
        for index, value in ipairs(t) do
            if abl == value then
                return true
            end
        end
    end
    return false
end

function TrainManager:GetOptions()
    local opt = SB:New()
    ---@type Character
    local 调教者 = self.调教者
    ---@type Character
    local 目标 = self.被调教者
    TrainManager.Line = 0


    opt:Append(self.Button("爱抚"))
    opt:Append(self.Button("舔舐"))

    if 检查占用(调教者.嘴) and 检查占用(目标.嘴) then
        opt:Append(self.Button("接吻"))
    end

    local 胯部装备 = 目标:获取外层装备("胯部")

    --张开
    if not 检查特性(目标.手, "拘束") and 目标:获取装备厚度("胯部") < 5 then
        opt:Append(self.Button("自慰"))
        if 胯部装备 == nil and not 检查占用(目标.小穴) then
            opt:Append(self.Button("张开", "小穴"))
        end
        if 胯部装备 == nil and not 检查占用(目标.菊穴) then
            opt:Append(self.Button("张开", "肛门"))
        end
    end

    --指插入系
    if 胯部装备 == nil and not 检查占用(目标.小穴) and not 检查占用(调教者.手) then
        opt:Append(self.Button("指插入", "小穴"))
    end
    if 胯部装备 == nil and self.上次行为 == "指插入小穴" then
        opt.Append(self.Button("指插入", "G点", "刺激G点"))
    end
    if 胯部装备 == nil and not 检查占用(目标.菊穴) and not 检查占用(调教者.手) then
        opt:Append(self.Button("指插入", "肛门"))
    end

    --道具系
    if 胯部装备 == nil and DataManager:HaveSexItem("阴蒂夹") then
        if not 检查占用(目标.阴蒂) then
            opt:Append(self.Button("阴蒂夹"))
        end
        if 检查占用(目标.阴蒂, "阴蒂夹") then
            opt:Append(self.Button("取下阴蒂夹"))
        end
    end
    if 胯部装备 == nil and DataManager:HaveSexItem("振动棒") then
        if not 检查占用(目标.小穴) then
            opt:Append(self.Button("振动棒"))
        end
        if 检查占用(目标.小穴, "振动棒") then
            opt:Append(self.Button("取下振动棒"))
        end
    end

    --插入
    if 胯部装备 == nil and not 检查占用(调教者.阴茎) then
        if not 检查占用(目标.小穴) then
            opt:Append(self.Button("插入小穴", "小穴", "插入小穴"))
        elseif 检查占用(目标.小穴, "阴茎") then
            opt:Append(self.Button("插入小穴", "小穴", "拔出肉棒"))
            if 调教者.阴茎.技巧 >= 2 then
                opt:Append(self.Button("插入小穴", "G点", "刺激G点"))
                if 调教者.阴茎.技巧 >= 3 then
                    opt:Append(self.Button("插入小穴", "子宫口", "刺激子宫口"))
                    if 目标.获取经验("子宫口经验") then
                        opt:Append(self.Button("插入小穴", "子宫", "插入子宫")) 
                    end
                end
            end
        end
    end


    return opt
end



function TrainManager:GetMenu()
    local opt = SB:New()

    opt:Append(AddButton("退出", "TrainManager.Back"))
    return opt
end


function TrainManager.Back()
    TrainManager.参与人员 = nil
    TrainManager.调教者 = nil
    TrainManager.被调教者 = nil
    TrainManager.助手 = nil

    UIManager:Back()
end


function TrainManager.Option(arg1, arg2)
    协程 = coroutine.start(TrainManager.Execute,TrainManager, arg1, arg2)
end


local function 特性修正(active, func)
    for index, value in ipairs(active.调教者.特性) do
        local tex = require("Data/特性/"..value)
        if tex ~= nil and tex.Type == "特性" then
            func("调教者", tex)
        end
    end
    for index, value in ipairs(active.被调教者.特性) do
        local tex = require("Data/特性/"..value)
        if tex ~= nil and tex.Type == "特性" then
            func("被调教者", tex)
        end
    end

    for index, value in ipairs(active.执行.特性) do
        local tex = require("Data/特性/"..value)
        if tex ~= nil and tex.Type == "特性" then
            func("执行", tex)
        end
    end
    for index, value in ipairs(active.目标.特性) do
        local tex = require("Data/特性/"..value)
        if tex ~= nil and tex.Type == "特性" then
            func("目标", tex)
        end
    end

    for index, value in ipairs(TrainManager.调教地点特性) do
        local tex = require("Data/特性/"..value)
        if tex ~= nil and tex.Type == "特性" then
            func("地点", tex)
        end
    end
end


local function 执行行为(self)
    local action = self.sex:SexActive(self, self.行为, self.选择)
    if self.调教者.阴茎 ~= nil and self.调教者.阴茎.精液 > 10000 then
        TrainManager:射精处理(self, action)
    end
    TrainManager:行为补正(self, action)
    TrainManager:体力处理(self)
    local feel = TrainManager:ToFeelPack(self, action)
    TrainManager:感觉补正(feel)
    TrainManager:性向加成(feel)
    TrainManager:最终补正(feel)
    self.感觉包 = feel
end




--执行调教选项
function TrainManager:Execute(action, select)
    if self.上次行为 == self.行为 and self.上次选择 == self.选择 then
        self.相同行动 = true
    end

    local sex = require("Train/"..action)

--先检查是否能执行
    local active = sex:Check()

    if active == nil then
        Message : StartPop()
        return
    end
    table.insert(self.行为栈, active)

    for i = 1, #self.行为栈 do
        执行行为(self.行为栈[i])
    end

    self:宝珠处理()
    self:刻印处理()
    self:经验处理()
    self:好感处理()
    self:堕落处理()
    self:服从处理()
    self:其他处理()

    self:重置变量()
    self:输出()

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
    if self.获取上次信息(self.被调教者, "绝顶") then
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
    local SF = active.被调教者.获取能力("侍奉技术")
    local LC = active.被调教者.获取能力("露出癖")

    local feel = require("Data/FeelPack"):New()
    feel.阴蒂快感 = pack.阴蒂快感
    feel.小穴快感 = pack.小穴快感
    feel.菊穴快感 = pack.菊穴快感
    feel.胸部快感 = pack.胸部快感
    feel.嘴部快感 = pack.嘴部快感
    feel.尿道快感 = pack.尿道快感

    local elseValue = require("Data/参数"):DownPalamLv(pack.阴蒂快感 + pack.小穴快感 + pack.菊穴快感 + pack.胸部快感 + pack.嘴部快感 + pack.尿道快感)
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
            习得, 恭顺 = tex:行为包转感觉包修正(active, type, "成就感", 习得, 恭顺)
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
            恐怖 = pack.疼痛 * ((Mathf.Max(20 - (SC - 10) * 1,1)) * 1) / 100
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
            恐怖, 反感, 欲情 = tex:行为包转感觉包修正(active, type, "疼痛", 恐怖, 反感, 欲情)
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
            恭顺, 欲情 = tex:行为包转感觉包修正(active, type, "充足",恭顺, 欲情)
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
            欲情, 反感 = tex:行为包转感觉包修正(active, type, "不洁", 欲情, 反感)
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
            羞耻, 欲情, 反感 = tex:行为包转感觉包修正(active, type, "露出", 羞耻, 欲情, 反感)
        end)

        feel.反感 = feel.反感 + 反感
        feel.欲情 = feel.欲情 + require("Data/参数"):DownPalamLv(欲情)
        feel.羞耻 = feel.羞耻 + 羞耻
    end
    if pack.屈从 ~= 0 then 
        特性修正(active, function (type, tex)
            pack.屈从 = tex:行为包转感觉包修正(active, type, "屈从", pack.屈从)
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
            欲情, 反感 = tex:行为包转感觉包修正(active, type, "逃脱", 欲情, 反感)
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
        tex:调教行为补正(active, multiPack, t)
    end)

    for key, value in pairs(multiPack) do
        if key == "不洁" or key == "恐惧" or key == "逃脱" or key == "反感追加" then
            multiPack[key] = math.max(value, -99);
        else
            multiPack[key] = math.max(value, -80);
        end
    end

    pack = pack * multiPack
end

---@param feel ActionPack
function TrainManager:感觉补正(active, feel)

    local Female = active.被调教者

    local Bfeel = Female.胸.感觉
    feel.胸部快感 = TrainManager.PleasureLimiter(feel.胸部快感, Bfeel)
    local Afeel = Female.菊穴.感觉
    feel.菊穴快感 = TrainManager.PleasureLimiter(feel.菊穴快感, Afeel)
    local Cfeel = Female.阴蒂.感觉
    feel.阴蒂快感 = TrainManager.PleasureLimiter(feel.阴蒂快感, Cfeel)
    local Mfeel = Female.嘴.感觉
    feel.嘴部快感 = TrainManager.PleasureLimiter(feel.嘴部快感, Mfeel)
    local Vfeel = Female.小穴.感觉
    feel.小穴快感 = TrainManager.PleasureLimiter(feel.小穴快感, Vfeel)


    特性修正(active, function(type, tex)
        tex:调教感觉补正(active, feel, type)
    end)
end

function TrainManager:最终补正(pack)
    
end

---@param active ActiveMsg
function TrainManager:体力处理(active)
   local hp = active.体力减少;

   特性修正(active, function(t, tex)
    if tex.调教体力修正 ~= nil then
        hp = tex:调教体力修正(active, hp, t)
    end
    end)
    TrainManager.体力减少 = TrainManager.体力减少 + hp
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
        if active.调教者.阴茎.位置 == nil or active.调教者.阴茎.位置 == "" then
            place = "外面"
        else
            place = active.调教者.阴茎.位置
        end
    end

    local jy = active.被调教者:获取能力("精液中毒")
    local s = math.floor(active.调教者.阴茎.精液 / 10000)
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
        active.调教者.阴茎.精液 = 0
        active.被调教者.子宫.精子数 = SPERM
    end
end

function TrainManager:性向加成(pack)
    
end

function TrainManager:宝珠处理()
    
end

function TrainManager:经验处理()
    
end

function TrainManager:刻印处理()
    
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
    
end

function TrainManager:输出()
    
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
    end
    table.insert(self.经验栈, ("%s获得了%d点%s"):format(chara.Name, n, exp))
    error("角色经验表为 nil")
end

function TrainManager:获取上次信息(id, mess)
    if self.记录[mess] ~= nil then
        return self.记录[id][mess]
    end
    return nil
end

function TrainManager.六感同加(data, num)
    data.阴蒂快感 = data.阴蒂快感 + num
    data.菊穴快感 = data.菊穴快感 + num
    data.小穴快感 = data.小穴快感 + num
    data.嘴部快感 = data.嘴部快感 + num
    data.胸部快感 = data.胸部快感 + num
    data.尿道快感 = data.尿道快感 + num
end

return TrainManager