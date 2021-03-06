--依据特性特征编写脚本
--!!名字请与文件名相同!!
--适用表示 该特性能被附加到那些身体部位上
--适用情况
--全部 全部位置
--任意 可以附加到包括人物的任意位置
--人物 仅能附加到人物的特性上
--器官 仅能附加到器官（包括性器官）的特性上
--性器官 仅能附加到性器官的特性上
--非性器官 仅能附加到非性器官的特性上
--场景 仅用于场景
local 模板特性 = { Type = "特性", Name = "", 适用 = "人物"}

--!!!补正结尾的包为乘加，
--传入的包是乘数，以100为基础单位
--如：包.A = 10 等于 目标包.A * 1.1

---@param 执行信息 ActiveMsg
---@param 值 number 扣血值
function 模板特性:调教体力修正(执行信息, 值, 类型)
    --主动则是执行者调用的特性，否则是目标调用的特性
    if 类型 == "被调教者" then
        return 值 - 5
    end
    return 值
end

return 模板特性