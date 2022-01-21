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

function meta:获取经验(name)
    if self.经验 ~= nil and self.经验[name] ~= nil then
        return self.经验[name]
    end
    return 0
end

function meta:设置能力(name, num)
    if self.能力 ~= nil then
        self.能力[name] = num
    end
end

function meta:能力提升(name, num)
    if self.能力 ~= nil then
        if self.能力[name] ~= nil then
            self.能力[name] = self.能力[name] + num
        else
            self.能力[name] = num
        end
    end
end

function meta:获取能力(name)
    if self.能力 ~= nil and self.能力[name] ~= nil then
        return self.能力[name]
    end
    return 0
end

function meta:计算刺激度(t, n)
    local v = 0
    if self[t] ~= nil and self[t].感觉 ~= nil then
        if self[t].感觉 <= 0 then
            v = 100
        elseif self[t].感觉 >= 1 and self[t].感觉 <= 4 then
            v = 200 * self[t].感觉
        elseif self[t].感觉 >= 5 and self[t].感觉 <= 10 then
            v = 100 * (self[t].感觉 - 4) + 800
        else
            v = 10 * (self[t].感觉 - 10) + 1400
        end
    end
    if v == 0 then
        print("刺激度："..t)
        return 0
    end

    if n == 1 then
        v = v * (0.4 + self[t].感觉 * 0.05)
    elseif n == 2 then
        v = v * (0.05 + self[t].感觉 * 0.15)
    elseif n == 3 then
        v = v * math.max(self[t].感觉 * 0.3 - 1, (self[t].感觉 + 1) * 0.05)
    end
    return v
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

function meta:获取状态(tal)
    if self.状态 ~= nil and self.状态[tal] ~= nil then
        return self.状态[tal]
    end
    return false
end

function meta:检查特性(tal)
    if self.特性 ~= nil and self.特性[tal] then
        return true
    end
    return false
end

function meta:调用口上(name, ...)
    local KouJiu = require(("Chara/%s/KouJiu"):format(self.口上))
    if KouJiu[name] ~= nil then
        KouJiu[name](...)
    end
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