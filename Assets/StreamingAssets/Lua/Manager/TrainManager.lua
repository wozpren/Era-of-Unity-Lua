TrainManager = 
{
    FeelPack = {},
    FeelList =
    {
        "嘴快感",
        "胸快感",
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
    for i, value in ipairs(t) do
        if value.Type == nil or value.Type ~= "Character" then
            Message:AddTopMessage("调教管理器：传入参数类型不符")
            return false
        end
        self.FeelPack[i] = pack:New()
    end

    TrainManager.参与人员 = t
    TrainManager.调教者 = 1
    TrainManager.被调教者 = 2
    if #t >= 3 then
        TrainManager.助手 = 3
    else
        TrainManager.助手 = 0
    end

    return true
end

function TrainManager:EndTrain()
    
end



return TrainManager