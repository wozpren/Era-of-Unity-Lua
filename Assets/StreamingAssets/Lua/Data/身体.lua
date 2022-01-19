local 身体 = {}

function 身体.头(...)
    local o =
    {
        特性 = {...},
        装备 = {}
    }
    return o
end

function 身体.身体(...)
    local o =
    {
        特性 = {...},
        装备 = {}
    }
    return o
end

function 身体.胯部(...)
    local o =
    {
        特性 = {...},
        装备 = {}
    }
    return o
end

function 身体.腿(...)
    local o =
    {
        特性 = {...},
        装备 = {}
    }
    return o
end

function 身体.脚(_技巧, ...)
    if not _技巧 then
        _技巧 = 0
    end
    local o = 
    {
        技巧 = _技巧,
        特性 = {...},
        装备 = {}
    }
    return o
end

function 身体.嘴(_感觉,_技巧, ...)
    if not _技巧 then
        _技巧 = 0
    end
    if not _感觉 then
        _感觉 = 0
    end

    local o = 
    {
        感觉 = _感觉,
        技巧 = _技巧,
        特性 = {...},
        装备 = {}
    }
    return o
end

function 身体.手(_技巧, ...)
    if not _技巧 then
        _技巧 = 0
    end

    local o =
    {
        技巧 = _技巧,
        特性 = {...},
        装备 = {}
    }
    return o
end

function 身体.胸(_感觉, _大小, ...)
    if not _感觉 then
        _感觉 = 0
    end
    if not _大小 then
        _大小 = 0
    end

    local o = 
    {
        感觉 = _感觉,
        大小 = _大小,
        特性 = {...},
        装备 = {}
    }
    return o
end

function 身体.子宫(_感觉, _扩张度, ...)
    if not _感觉 then
        _感觉 = 0
    end
    if not _扩张度 then
        _扩张度 = 0
    end
    local o = 
    {
        精子数 = 0,
        感觉 = _感觉,
        子宫口扩张度 = _扩张度,
        特性 = {...},
        装备 = {}
    }
    return o
end

function 身体.小穴(_感觉, _技巧, _扩张度, ...)
    if not _感觉 then
        _感觉 = 0
    end
    if not _技巧 then
        _技巧 = 0
    end
    if not _扩张度 then
        _扩张度 = 0
    end
    local o = 
    {
        感觉 = _感觉,
        技巧 = _技巧,
        扩张度 = _扩张度,
        特性 = {...},
        装备 = {}
    }
    return o
end

function 身体.阴蒂(_感觉, ...)
    if not _感觉 then
        _感觉 = 0
    end

    local o = 
    {
        感觉 = _感觉,
        特性 = {...},
        装备 = {}
    }
    return o
end

function 身体.阴茎(_感觉, _技巧, ...)
    if not _感觉 then
        _感觉 = 0
    end
    if not _技巧 then
        _技巧 = 0
    end

    local o = 
    {
        技巧 = _技巧,
        感觉 = _感觉,
        精液 = 0,
        特性 = {...},
        装备 = {}
    }
    return o
end

function 身体.菊穴(_感觉, _技巧, _扩张度,...)
    if not _感觉 then
        _感觉 = 0
    end
    if not _技巧 then
        _技巧 = 0
    end
    if not _扩张度 then
        _扩张度 = 0
    end
    local o = 
    {
        感觉 = _感觉,
        技巧 = _技巧,
        扩张度 = _扩张度,
        特性 = {...},
        装备 = {}
    }
    return o
end

function 身体.尿道(_感觉, _技巧, _扩张度,...)
    if not _感觉 then
        _感觉 = 0
    end
    if not _技巧 then
        _技巧 = 0
    end
    if not _扩张度 then
        _扩张度 = 0
    end
    local o = 
    {
        感觉 = _感觉,
        技巧 = _技巧,
        扩张度 = _扩张度,
        特性 = {...},
        装备 = {}
    }
    return o
end

return 身体