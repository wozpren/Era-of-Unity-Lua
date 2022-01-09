EventManager={}
--添加事件 eventType-->事件类型  func-->方法
function EventManager.AddListener(eventType,func)
    if(eventType==nil or func==nil)then
        print("在EventSystem.AddListener中eventType或func为空")
        print(eventType)
        print(func)
        return
    end
    if(EventManager[eventType]==nil)then
        local a={}
        table.insert(a,func)
        EventManager[eventType]=a
    else
        table.insert(EventManager[eventType],func)

    end
end
--移除事件
function EventManager.RemoveListener(eventType,func)
    if(eventType==nil or func==nil)then
        print('在EventSystem.RemoveListener中eventType或func为空')
        print(eventType)
        print(func)
        return
    end
    local a=EventManager[eventType]
    if(a~=nil)then
        for k,v in pairs(a) do
            if(v==func)then
                a[k]=nil
            end
        end
    end
end

function EventManager.ResetSystem()
    local a=EventManager[eventType]
    if(a~=nil)then
        for k,v in pairs(a) do
                a[k]=nil
        end
    end
end


function EventManager.Clear(eventType)
    if(eventType == nil)then
        print('在EventSystem.RemoveListener中eventType或func为空')
        return
    end
    local a=EventManager[eventType]
    if(a~=nil)then
        for k,v in pairs(a) do
                a[k]=nil            
        end
    end
end

function EventManager.SetListener(eventType,func)
    if(eventType==nil)then
        print("在EventSystem.AddListener中eventType或func为空")
        print(eventType)
        return
    end
    if func ~= nil then
    if(EventManager[eventType]==nil)then
        local a={}
        table.insert(a,func)
        EventManager[eventType] = a
    else
        table.remove(EventManager[eventType])
        table.insert(EventManager[eventType],func)
    end
    else
        EventManager[eventType] = nil
    end
end

--派发事件
function EventManager.SendEvent(eventType,...)
    if(eventType~=nil)then
        local a=EventManager[eventType]
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
EventManager.AddListener("coroutine",CorCtrl)




return EventManager