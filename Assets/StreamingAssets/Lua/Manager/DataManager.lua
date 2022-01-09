local io = require("cjson/util")
local json = require "cjson"
DataManager = 
{
    DataPath = UnityEngine.Application.dataPath .. "/Save"
}



function DataManager.LoadSystemData()
    local text = io.file_load(DataManager.DataPath)
    if text ~= nil then
        DataManager.SystemData = json.decode(text)
    else
        --这个地方初始化系统设定！！！！
        DataManager.SystemData = 
        {
            GameName = "Era of Unity",
            Version = 0.1
        }
    end
end

function DataManager.SaveSystemData()
    local json = json.encode(DataManager.SystemData)
    io.file_save(DataManager.DataPath, json)
end

function DataManager.LoadPlayerData()
    
end

function DataManager.SavePlayerData()
    
end

return DataManager
