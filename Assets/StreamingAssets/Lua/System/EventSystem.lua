EventSystem={}
--添加事件 eventType-->事件类型  func-->方法
function EventSystem.AddListener(eventType,func)
    if(eventType==nil or func==nil)then
        print("在EventSystem.AddListener中eventType或func为空")
        print(eventType)
        print(func)
        return
    end
    if(EventSystem[eventType]==nil)then
        local a={}
        table.insert(a,func)
        EventSystem[eventType]=a
    else
        table.insert(EventSystem[eventType],func)

    end
end
--移除事件
function EventSystem.RemoveListener(eventType,func)
    if(eventType==nil or func==nil)then
        print('在EventSystem.RemoveListener中eventType或func为空')
        print(eventType)
        print(func)
        return
    end
    local a=EventSystem[eventType]
    if(a~=nil)then
        for k,v in pairs(a) do
            if(v==func)then
                a[k]=nil
            end
        end
    end
end

function EventSystem.ResetSystem()
    local a=EventSystem[eventType]
    if(a~=nil)then
        for k,v in pairs(a) do
                a[k]=nil
        end
    end
end


function EventSystem.Clear(eventType)
    if(eventType == nil)then
        print('在EventSystem.RemoveListener中eventType或func为空')
        return
    end
    local a=EventSystem[eventType]
    if(a~=nil)then
        for k,v in pairs(a) do
                a[k]=nil            
        end
    end
end

function EventSystem.SetListener(eventType,func)
    if(eventType==nil)then
        print("在EventSystem.AddListener中eventType或func为空")
        print(eventType)
        return
    end
    if func ~= nil then
    if(EventSystem[eventType]==nil)then
        local a={}
        table.insert(a,func)
        EventSystem[eventType] = a
    else
        table.remove(EventSystem[eventType])
        table.insert(EventSystem[eventType],func)
    end
    else
        EventSystem[eventType] = nil
    end
end

--派发事件
function EventSystem.SendEvent(eventType,...)
    if(eventType~=nil)then
        local a=EventSystem[eventType]
        if(a~=nil)then
            for k,v in pairs(a) do
                v(...)
            end
        end
    end
end

function CorCtrl(arg1, arg2, arg3)
	if(coroutineEvent ~= nil) then
		coroutine.resume(coroutineEvent,arg1, arg2, arg3)
	end
end
EventSystem.AddListener("coroutine",CorCtrl)




return EventSystem