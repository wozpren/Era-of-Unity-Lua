local pack = {}

function pack:New()
---@class FeelPack
    local o = 
    {
        嘴部快感 = 0,
        胸部快感 = 0,
        阴蒂快感 = 0,
        小穴快感 = 0,
        菊穴快感 = 0,
        尿道快感 = 0,
        小穴润滑 = 0,
        菊穴润滑 = 0,
        欲情 = 0,
        恭顺 = 0,
        屈从 = 0,
        习得 = 0,
        羞耻 = 0,
        痛苦 = 0,
        恐怖 = 0,
        反感 = 0,
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