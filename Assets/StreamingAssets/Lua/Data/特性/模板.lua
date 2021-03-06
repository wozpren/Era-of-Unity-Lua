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
local 特性 = { Type = "特性", Name = "", 适用 = "人物"}

--!!!补正结尾的包为乘加，
--传入的包是乘数，以100为基础单位
--如：包.A = 10 等于 目标包.A * 1.1


--调教时行动包补正
---@param 执行信息 ActiveMsg
---@param 行为包 ActionPack
---@param 类型 string
function 特性:调教行为补正(执行信息, 行为包, 类型)


end

--调教时感觉包补正
function 特性:调教感觉补正(执行信息, 行为包, 类型)


end

--调教时
function 特性:行为包转感觉包修正(执行信息, 对象, 类型,...)

end

--调教时
function 特性:高潮修正(人物, 行为包, 类型)

end

function 特性:调教体力修正(执行信息, 值, 类型)
    return 值
end


return 特性