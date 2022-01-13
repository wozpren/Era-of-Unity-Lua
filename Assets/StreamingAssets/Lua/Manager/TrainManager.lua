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
----注册的事件：
----
-----------




---开始调试所用方法
---第一个作为调教者，第二个作为被调教者，第三个为助手，后续为其他被调教者
---@param ... Character[]
function TrainManager:StartTrain(...)
    local t = {...}
    local pack = require("Data/FeelPack")
    if #t < 2 then
        return false
    end
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

function TrainManager:GetOptions()
    local opt = SB:New()
    ---@class Character
    local 调教者 = self.调教者
    ---@class Character
    local 目标 = self.被调教者

    self.Button("爱抚")
    self.Button("舔舐")

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