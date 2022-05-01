local orbs = {}
local orb = {
        "欲情" ,
        "恭顺" ,
        "屈从" ,
        "习得" ,
        "羞耻" ,
        "痛苦" ,
        "恐怖" ,
        "反感" ,
        "嘴部快感" ,
        "胸部快感" ,
        "阴部快感" ,
        "小穴快感" ,
        "菊穴快感" ,
        "尿道快感"
}


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
        阴部快感 = 0,
        小穴快感 = 0,
        菊穴快感 = 0,
        尿道快感 = 0,
    }
    return o
end

function orbs:Add(r,l)
    for key, value in pairs(r) do
        r[key] = r[key] + l[key]
    end
end

function orbs:Message(o)
    local t = SB:New()
    for index, value in ipairs(orb) do
        t:Append(("%s:%d\n"):format(value, o[value]))
    end
    return t:ToStr()
end


return orbs