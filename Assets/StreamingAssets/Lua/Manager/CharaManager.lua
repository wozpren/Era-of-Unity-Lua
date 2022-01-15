CharaManager = {}

local meta = {}
meta.__index = meta

function meta:获取装备厚度(位置)
    if self[位置] ~= nil and self[位置].装备 ~= nil then
        if #self[位置].装备 > 0 then
            local n = 0
            for index, value in ipairs(self[位置].装备) do
                n = n + value.厚度
            end
            return n
        end
        return 0
    end
    error(("%s 或 装备 不存在"):format("位置"))
    return 0
end

function meta:获取外层装备(位置)
    if self[位置] ~= nil and self[位置].装备 ~= nil then
        if #self[位置].装备 > 0 then
            local n = #self[位置].装备
            return self[位置].装备[n]
        end
        return nil
    end
    error(("%s 或 装备 不存在"):format("位置"))
    return nil
end

function meta:检查能力(name, num)
    if self.能力 ~= nil and self.能力[name] ~= nil then
        local n = self.能力[name]
        return n >= num
    end
    return false
end

function meta:检查占用(pos, n)
    if self[pos] ~= nil then
        if self[pos].持有 ~= nil then
            if self[pos].持有[n] then
                return true
            end
        elseif #self[pos].持有[n] == 0 then
            return true
        end
    end
    return false
end

function meta:检查特性(abl)
    if self.特性 ~= nil and self.特性[abl] then
        return true
    end
    return false
end


function CharaManager:LoadChara(id)
    local chara = dofile("Chara/TestDoll/"..id..".lua")
    setmetatable(chara, meta)
    return chara
end

function CharaManager:SetMetatable(chara)
    setmetatable(chara, meta)
end

return CharaManager