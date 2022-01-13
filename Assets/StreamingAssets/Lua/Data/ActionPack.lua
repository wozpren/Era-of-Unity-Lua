---@class ActionPack
local pack = {}

function pack:New()
    local o = 
    {
        嘴快感 = 0,
        胸快感 = 0,
        阴蒂快感 = 0,
        小穴快感 = 0,
        直肠快感 = 0,
        尿道快感 = 0,
        情爱 = 0,
        性行为 = 0,
        成就感 = 0,
        疼痛 = 0,
        充足 = 0,
        不洁 = 0,
        屈从 = 0,
        逃脱 = 0,
        恐惧 = 0,
    }

    setmetatable(o, pack)
    return o
end

function pack.__add(r, l)
    if getmetatable(r) == getmetatable(l) then
        for key, value in pairs(r) do
            r[key] = r[key] + l[key]
        end
    end
end

function pack.__unm(r, l)
    if getmetatable(r) == getmetatable(l) then
        for key, value in pairs(r) do
            r[key] = r[key] - l[key]
        end
    end
end

function pack.__mul(r, f)
    if type(f) == "number" then
        for key, value in pairs(r) do
            r[key] = r[key] * f
        end
    end
end

function pack.__div(r, f)
    if type(f) == "number" then
        for key, value in pairs(r) do
            r[key] = r[key] / f
        end
    end
end

return pack