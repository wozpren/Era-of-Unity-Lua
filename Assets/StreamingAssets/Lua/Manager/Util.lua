SB = {}

function SB:New()
    local o = {}
    self.__index = self
    setmetatable(o, self)
    return o
end

function SB:Append(str)
    if self and str then
        table.insert(self, str)
        end
end

function SB:AppendLine(str)
    if self and str then
        table.insert(self, str.."\n")
    end
end

function SB:Remove()
    table.remove(self)
end

function SB:Random(...)
    local index = math.random(1, select('#',...))
    local s = {...}
    table.insert(self, s[index])
end

function SB:ToStr()
    return table.concat(self)
end

function 调用口上(name, file)
    file = file or "KouJiu"
    local io = require("cjson/util")
    if io.file_exist(("Chara/%s/%s"):format(DataManager.PlayerData.MainChara.名字, file)) then
        local t = require(("Chara/%s/%s"):format(DataManager.PlayerData.MainChara.名字, file))
        if t[name] then
            t[name]()
        end
    else
        local t = require(("Chara/%s/%s"):format("Default", file))
        if t[name] then
            t[name]()
        end
    end

end

function 检查特性(t, abl)
    if t ~= nil and t.特性 ~= nil then
        for index, value in ipairs(t) do
            if abl == value then
                return true
            end
        end
    end
    return false
end