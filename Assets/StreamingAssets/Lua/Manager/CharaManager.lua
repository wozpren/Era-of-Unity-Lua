CharaManager = {}

local meta = {}
meta.__index = meta

function CharaManager:LoadChara(id)
    local io = require("cjson/util")
    if io.file_exist((UnityEngine.Application.streamingAssetsPath.."/Lua/Chara/%s/%s.lua"):format(id, id)) then
        return dofile(("Chara/%s/%s"):format(id, id))
    end
    return nil
end


function CharaManager:SetMetatable(chara)
    setmetatable(chara, meta)
end

return CharaManager