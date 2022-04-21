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

function meta:精液(n)
    if n == nil then
        if self.阴部.Name == "阴茎" then
            return self.阴部.精液
        end
    elseif self.阴部.Name == "阴茎" then
        self.阴部.精液 = self.阴部.精液 + n
    end
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
    if self.特性 ~= nil and table.Exist(self.特性, tal) then
        return true
    end
    return false
end

function meta:检查状态(state)
    if self.特性 ~= nil and table.Exist(self.状态, state)then
        return true
    end
    return false
end

function meta:设置状态(state, ...)
    require("Data/状态/"..state):设置(self, ...)
end

function meta:调用口上(name, ...)
    local KouJiu = require(("Chara/%s/KouJiu"):format(self.口上))
    if KouJiu[name] ~= nil then
        KouJiu[name](...)
    end
end

function meta:检查性玩具(name)
    local t = {"嘴", "胸", "小穴", "子宫", "阴部", "尿道", "菊穴", "头"}

    for i, value in ipairs(t) do
        if meta[value].装备[name] then
            return true
        end
    end
    return false

end

function meta:特性修正(func)
    for index, value in ipairs(meta.特性) do
        local tex = require(("Data/特性/%s"):format(value))
        if tex then
            func(tex)
        end
    end

    for index, value in ipairs(meta.状态) do
        local tex = require(("Data/状态/%s"):format(value))
        if tex then
            func(tex)
        end
    end
end


function meta:恢复体力(n)
    self.当前体力 =  UnityEngine.Mathf.Clamp(self.当前体力 + n, 0, self.体力)
    self.当前体力 = math.ceil(self.当前体力)
end

function meta:恢复精力(n)
    self.当前精力 =  UnityEngine.Mathf.Clamp(self.当前精力 + n, 0, self.精力)
    self.当前精力 = math.ceil(self.当前精力)
end

function meta:获取淫纹等级()
    return 0
end

function CharaManager:LoadChara(id)
    local chara = dofile("Chara/"..id.."/"..id..".lua")
    chara.当前体力 = chara.体力
    chara.当前精力 = chara.精力
    for index, value in ipairs(chara.衣服) do
        ClotheManager:装备(chara, value)
    end
    return chara
end


function CharaManager:SetMetatable(chara)
    setmetatable(chara, meta)
end

return CharaManager