TrainManager = 
{  
    FeelPack = {},
    FeelList =
    {
        "嘴部快感",
        "胸部快感",
        "阴蒂快感",
        "小穴快感",
        "直肠快感",
        "尿道快感",
        "小穴润滑",
        "直肠润滑",
        "欲情",
        "恭顺",
        "屈服",
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

    --初始化
    self.FeelPack = {}
    self.Train = {}

    for i, value in ipairs(t) do
        if value.Type == nil or value.Type ~= "Character" then
            Message:AddTopMessage("调教管理器：传入参数类型不符")
            return false
        end
        self.FeelPack[i] = pack:New()
    end

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
    if t ~= nil and t.特性 ~= nil and t.特性[abl] then
        return true
    end
    return false
end

function TrainManager:GetOptions()
    local opt = SB:New()
    ---@type Character
    local 调教者 = self.调教者
    ---@type Character
    local 目标 = self.被调教者

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
        if 胯部装备 == nil and not 检查占用(目标.直肠) then
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
    if 胯部装备 == nil and not 检查占用(目标.直肠) and not 检查占用(调教者.手) then
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
            if 目标.检查能力("") then
                
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

end

function TrainManager.Button(arg1, arg2, arg3)
    local s
    if arg2 == nil then
        s = string.format("<link=\"TrainManager.Option,%s,%s\"><color=yellow>%s</color></link>",  arg1, arg1, arg1)
    elseif arg3 == nil then
        s = string.format("<link=\"TrainManager.Option,%s,%s\"><color=yellow>%s</color></link>",  arg1, arg2, arg1..arg2)
    else
        s = string.format("<link=\"TrainManager.Option,%s,%s\"><color=yellow>%s</color></link>",  arg1, arg2, arg3)
    end
    TrainManager.Line = TrainManager.Line + 33
    if TrainManager.Line > 90 then
        TrainManager.Line = 0
        s = s.."\n"
    else
        s = s.." "
    end
    return s
end


return TrainManager