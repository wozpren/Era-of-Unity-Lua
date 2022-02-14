EventManager = {}
local metaevent = {}

metaevent.__index = metaevent




--添加事件 eventType-->事件类型  func-->方法
function metaevent:AddListener(eventType,func)
    if(eventType==nil or func==nil)then
        print("在EventSystem.AddListener中eventType或func为空")
        print(eventType)
        print(func)
        return
    end
    if(self[eventType]==nil)then
        local a={}
        table.insert(a,func)
        self[eventType]=a
    else
        table.insert(self[eventType],func)

    end
end
--移除事件
function metaevent:RemoveListener(eventType,func)
    if(eventType==nil or func==nil)then
        print('在EventSystem.RemoveListener中eventType或func为空')
        print(eventType)
        print(func)
        return
    end
    local a = self[eventType]
    if(a~=nil)then
        for k,v in pairs(a) do
            if(v==func)then
                a[k]=nil
            end
        end
    end
end

function metaevent:ResetSystem()
    for key, value in pairs(self) do
        self[key] = nil
    end
end


function metaevent:Clear(eventType)
    if(eventType == nil)then
        print('eventType为空')
        return
    end
    self[eventType] = {}
end

function metaevent:SetListener(eventType,func)
    if(eventType==nil)then
        print("在EventSystem.AddListener中eventType或func为空")
        print(eventType)
        return
    end
    if func ~= nil then
    if(self[eventType]==nil)then
        local a={}
        table.insert(a,func)
        self[eventType] = a
    else
        table.remove(self[eventType])
        table.insert(self[eventType],func)
    end
    else
        self[eventType] = nil
    end
end

--派发事件
function metaevent:SendEvent(eventType,...)
    if(eventType~=nil)then
        local a= self[eventType]
        if(a~=nil)then
            for k,v in pairs(a) do
                v(...)
            end
        end
    end
end

setmetatable(EventManager, metaevent)

return EventManager