local 特性 = { Type = "特性", Name = "接受快感", 适用 = "人物"}

--!!!补正结尾的包为乘加，
--传入的包是乘数，以100为基础单位
--如：包.A = 10 等于 目标包.A * 1.1


function 特性:调教体力修正(执行信息, 值, 类型)
    --主动则是执行者调用的特性，否则是目标调用的特性
    if 类型 == "被调教者" then
        return 值 * 2
    end
    return 值
end


return 特性