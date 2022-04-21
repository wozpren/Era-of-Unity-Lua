local pack = {}

function pack:New()
---@class ActionPack
    local o = 
    {
        嘴部快感 = 0,
        胸部快感 = 0,
        阴部快感 = 0,
        小穴快感 = 0,
        菊穴快感 = 0,
        尿道快感 = 0,
        情爱 = 0,
        性行为 = 0,
        成就感 = 0,
        疼痛 = 0,
        充足 = 0,
        露出 = 0,
        不洁 = 0,
        屈从 = 0,
        逃脱 = 0,
        恐惧 = 0,
        反感追加 = 0,
        欲情追加 = 0,
        恭顺追加 = 0,
        小穴液体追加 = 0,
        菊穴液体追加 = 0,
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
    return r
end

function pack.__unm(r, l)
    if getmetatable(r) == getmetatable(l) then
        for key, value in pairs(r) do
            r[key] = r[key] - l[key]
        end
    end
    return r
end

function pack.__mul(r, f)
    if type(f) == "number" then
        for key, value in pairs(r) do
            r[key] = r[key] * f
        end
    end
    if type(f) == "table" then
        for key, value in pairs(r) do
            r[key] = r[key] * f[key]
        end
    end
    return r
end

function pack.__div(r, f)
    if type(f) == "number" then
        for key, value in pairs(r) do
            r[key] = r[key] / f
        end
    end
    if type(f) == "table" then
        for key, value in pairs(r) do
            r[key] = r[key] / f[key]
        end
    end
    return r
end

return pack