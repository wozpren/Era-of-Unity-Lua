local meta = {}
meta.__index = meta

function meta:New()
    local o = 
    {
        CharaList = {}

    }
    setmetatable(o, meta)
    return o
end

function meta:SetMeta(chara)
    return setmetatable(chara,self)
end


---@param chara Character
function meta:AddChara(chara)
    local id = 0
    repeat
        id = math.random(0, 5000000)
    until(self.CharaList[id] == nil)
    chara.ID = id
    table.insert(self.CharaList, chara)
end


return meta