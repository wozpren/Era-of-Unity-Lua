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


