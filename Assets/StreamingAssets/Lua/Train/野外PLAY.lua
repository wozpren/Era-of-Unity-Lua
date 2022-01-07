function SexActive(Active, Select)
    local base = ActiveData.new()
    
    return base
end

function SexType(type)
    return false
end

function TrainMessage()
end


local text = SB.new()
SB.append(text, "要去哪里呢？")
SB.append(text, AddButton("小树林   ","CoroutineResume,树林"))
SB.append(text, AddButton("公园   ","CoroutineResume,公园"))
SB.append(text, AddButton("城市   ","CoroutineResume,城市"))
SB.append(text, AddButton("海边   ","CoroutineResume,海边"))

Message : AddMessage(SB.tostr(text))
select = coroutine.yield()
Message : Continue()
return true