

function AddBack()
	local count = GM : PageCount()
	if count > 0 then
		local text = AddButton("返回", "back")
		return text
	end
end

function AddConfirm(method)
	EventSystem.SetListener("Confirm", method)
	return AddButton("确认", "Confirm")
end

function NaviButton(String, method, bool)
	if bool then
		return string.format("<link=\"GO,%s\"><color=yellow>%s</color></link>", method, String)
	else
		return string.format("<link=\"NG,%s\"><color=yellow>%s</color></link>", method, String)
	end
end

function AddButton(String, method)
	return string.format("<link=\"%s\"><color=yellow>%s</color></link>", method, String)
end

function AddButtonSpe(String, method)
	return string.format("<link=\"%s\"><color=yellow>%s</color></link>	", method, String)
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
	local text = SB.new()
	for i, v in ipairs{...} do
		local t = ""
		if select == v then
			t = AddColor(v, "yellow")
		else
			t = AddButtonColor(v, "grey", func..","..v)
		end
		SB.append(text, t.."  ")
	end  


	return SB.tostr(text)
end

function AddNumberFloat(value, func, min, max)
	local text = SB.new()
	if min == nil or value > min then
		SB.append(text, AddButton("--", func..","..(value - 1)).." ")
	else
		SB.append(text, AddColor("--", "grey").." ")
	end
	if min == nil or value > min then
		SB.append(text, AddButton("-", func..","..(value - 0.1)))
	else
		SB.append(text, AddColor("-", "grey"))
	end
	SB.append(text, string.format(" %0.1f ", value))
	if min == nil or value < max then
		SB.append(text, AddButton("+", func..","..(value + 0.1)))
	else
		SB.append(text, AddColor("+", "grey"))
	end
	if min == nil or value > min then
		SB.append(text, " "..AddButton("++", func..","..(value + 1)))
	else
		SB.append(text, " "..AddColor("++", "grey"))
	end
	return SB.tostr(text)
end


function AddNumber(value, func, min, max)
	local text = SB.new()
	if min == nil or value > min then
		SB.append(text, AddButton("-", func..","..(value - 1)))
	else
		SB.append(text, AddColor("-", "grey"))
	end
	SB.append(text, " "..value.." ")
	if min == nil or value < max then
		SB.append(text, AddButton("+", func..","..(value + 1)))
	else
		SB.append(text, AddColor("+", "grey"))
	end
	return SB.tostr(text)
end

print("UI工具读取完成")