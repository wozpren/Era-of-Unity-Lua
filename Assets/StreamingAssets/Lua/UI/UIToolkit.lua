

function AddBack()
	local count = GM : PageCount()
	if count > 0 then
		local text = AddButton("返回", "back")
		return text
	end
end

function AddConfirm(method)
	EventManager.SetListener("Confirm", method)
	return AddButton("确认", "Confirm")
end

function NaviButton(String, method, bool)
	if bool then
		return string.format("<link=\"GO,%s\"><color=yellow>%s</color></link>", method, String)
	else
		return string.format("<link=\"NG,%s\"><color=yellow>%s</color></link>", method, String)
	end
end

-- String[string] method[string]
function AddButton(String, method)
	return string.format("<link=\"%s\"><color=yellow>%s</color></link>", method, String)
end

function AddButtonSpe(String, method)
	return string.format("<link=\"%s\"><color=yellow>%s</color></link>    ", method, String)
end

function AddButtonL(String, method)
	return string.format("<link=\"%s\"><color=yellow>%s</color></link>\n", method, String)
end

function AddButtonColor(String, color, method)
	return string.format("<link=\"%s\"><color=%s>%s</color></link>", method, color, String)
end

function AddColor(string, color)
	string = "<color="..color..">" .. string .. "</color>"
	return string
end

function AddGroup(select, func, ...)
	local text = SB:New()
	for i, v in ipairs{...} do
		local t = ""
		if select == v then
			t = AddColor(v, "yellow")
		else
			t = AddButtonColor(v, "grey", func..","..v)
		end
		text:Append(t.."  ")
	end  


	return text:ToStr()
end

function AddNumberFloat(value, func, min, max)
	local text = SB:New()
	if min == nil or value > min then
		text:Append(AddButton("--", func..","..(value - 1)).." ")
	else
		text:Append(AddColor("--", "grey").." ")
	end
	if min == nil or value > min then
		text:Append(AddButton("-", func..","..(value - 0.1)))
	else
		text:Append(AddColor("-", "grey"))
	end
	text:Append(string.format(" %0.1f ", value))
	if min == nil or value < max then
		text:Append(AddButton("+", func..","..(value + 0.1)))
	else
		text:Append(AddColor("+", "grey"))
	end
	if min == nil or value > min then
		text:Append(" "..AddButton("++", func..","..(value + 1)))
	else
		text:Append(" "..AddColor("++", "grey"))
	end
	return text:ToStr()
end

function AddNumber(value, func, min, max)
	local text = SB:New()
	if min == nil or value > min then
		text:Append(AddButton("-", func..","..(value - 1)))
	else
		text:Append(AddColor("-", "grey"))
	end
	text:Append(" "..value.." ")
	if min == nil or value < max then
		text:Append(AddButton("+", func..","..(value + 1)))
	else
		text:Append(AddColor("+", "grey"))
	end
	return text:ToStr()
end

print("UI工具读取完成")