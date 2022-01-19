function t:SexActive(Active, Select)
    local base = ActiveData.new()
    
    return base
end

function t:SexType(type)
    return false
end

function t:TrainMessage()
end


local text = SB.New()
text:Append("要去哪里呢？")
text:Append(AddButton("小树林   ","CoroutineResume,树林"))
text:Append(AddButton("公园   ","CoroutineResume,公园"))
text:Append(AddButton("城市   ","CoroutineResume,城市"))
text:Append(AddButton("海边   ","CoroutineResume,海边"))

Message : AddMessage(text:ToStr())
select = coroutine.yield()
Message : Continue()
return true