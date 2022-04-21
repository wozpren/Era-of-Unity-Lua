ClotheManager = {}

function ClotheManager:New(name, pos)
    name = name or ""
    if pos == nil then
        error("错误，pos不能为nil")
    end
    ---@class Clothe
    local o = 
    {
        Type = "衣服",
        Name = name,
        厚度 = 1,--0时表示镂空
        覆盖 = pos,
    }
    return o
end

---@return Clothe
function ClotheManager:获取(name)
    local n = require("Data/服装")
    if type(n[name]) == "table" then
        return n[name]
    end
end


---@param chara Character
---@param clothe string
function ClotheManager:装备(chara, clothe)
    local equip = require("Data/服装")[clothe]
    if type(equip) == "table" then
        if type(equip.覆盖) == "string" then
            table.insert(chara[equip.覆盖].装备, equip.Name)
            return true
        elseif type(equip.覆盖) == "table" then
            for index, value in ipairs(equip.覆盖) do
                table.insert(chara[value].装备, equip.Name)
            end
            return true
        end
    end
    return false
end


function ClotheManager:脱下(chara, pos)
    local equip = chara[pos].装备[#chara[pos].装备]
    if type(equip) == "string" then
        local clothe = require("Data/服装")[equip]
        if type(clothe.覆盖) == "string" then
            table.remove(chara[clothe.覆盖].装备, #chara[clothe.覆盖].装备)
        elseif type(clothe.覆盖) == "table" then
            for index, value in ipairs(clothe.覆盖) do
                for i = #chara[value].装备[pos], 1, -1 do
                    if chara[value].装备[pos][i] == equip then
                        table.remove(chara[value].装备[pos], i)
                    end
                end
            end
        end
        return equip
    end



end