CharaManager = {}

local meta = {}
meta.__index = meta

function CharaManager:LoadChara(id)
    local chara = dofile("Chara/TestDoll/"..id..".lua")
    setmetatable(chara, meta)
    return chara
end

function CharaManager:SetMetatable(chara)
    setmetatable(chara, meta)
end

return CharaManager