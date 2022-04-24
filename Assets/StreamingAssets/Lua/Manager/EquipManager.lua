EquipManager =
{
    
}

---@return Equip
function  EquipManager:获取装备(Name)
    if Name ~= nil then
        local equip = require("Equip/Equip")
        if equip[Name] ~= nil then
            return equip[Name]
        end
    end
    return nil
end