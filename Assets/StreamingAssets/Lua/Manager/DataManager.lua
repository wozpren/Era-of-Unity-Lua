local io = require("cjson/util")
local json = require "cjson"
DataManager = 
{
    DataPath = UnityEngine.Application.dataPath .. "/Save/"
}



function DataManager:LoadSystemData()
    local text = io.file_load(self.DataPath.."system.data")
    if text ~= nil then
        self.SystemData = json.decode(text)
    else
        --这个地方初始化系统设定！！！！
        self.SystemData = 
        {
            GameName = "Era of Unity",
            Version = 0.1
        }
    end
end

function DataManager:SaveSystemData()
    local json = json.encode(self.SystemData)
    io.file_save(self.DataPath.."system.data", json)
end


--生成玩家数据
function DataManager:GenratePlayerData()
    self.PlayerData = require("Data/PlayerData"):New()

    self.PlayerData:AddChara(CharaManager:LoadChara("TestDoll"))
    self.PlayerData:AddChara(CharaManager:LoadChara("TestDoll"))
end

function DataManager:LoadPlayerData(index)
    local text, err = io.file_load(self.DataPath..index..".data")
    if text ~= nil then
        self.PlayerIndex = index
        local data = json.decode(text)
        self.PlayerData = require("Data/PlayerData"):SetMeta(data)
    else
        error(err);
    end
end

function DataManager:SavePlayerData(index)
    local data = setmetatable(self.PlayerData, nil)

    for i, value in ipairs(self.PlayerData.CharaList) do
        setmetatable(value, nil)
    end


    local text = json.encode(data)
    self.PlayerIndex = index
    io.file_save(self.DataPath..index..".data", text)

    require("Data/PlayerData"):SetMeta(self.PlayerData)
    
    for i, value in ipairs(self.PlayerData.CharaList) do
        CharaManager:SetMetatable(value)
    end
end

function DataManager:HaveSexItem(name)
    return true
end

--生产玩家数据


return DataManager
