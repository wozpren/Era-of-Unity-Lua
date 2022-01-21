local orbs = {}

function orbs:New()
    ---@class orb
    local o = 
    {
        欲情 = 0,
        恭顺 = 0,
        屈从 = 0,
        习得 = 0,
        羞耻 = 0,
        痛苦 = 0,
        恐怖 = 0,
        反感 = 0,
        嘴部快感 = 0,
        胸部快感 = 0,
        阴蒂快感 = 0,
        小穴快感 = 0,
        菊穴快感 = 0,
        尿道快感 = 0,
    }
end

function orbs:Add(r,l)
    for key, value in pairs(r) do
        r[key] = r[key] + l[key]
    end
end


return orbs