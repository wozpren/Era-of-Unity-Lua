local 参数 = {}

参数.等级 =
{
    100,        --1
    500,        --2
    3000,       --3
    10000,      --4
    30000,      --5
    60000,      --6
    100000,     --7
    150000,     --8
    250000,     --9
    500000,     --10
    700000,     --11
    1000000,    --12
    3000000,    --13
    7000000,    --14
    10000000,   --15
    20000000,   --16
    30000000,   --17
    40000000,   --18
    50000000,   --19
    100000000,  --20
}

参数.经验等级 =
{
    30,
    60,
    100,
    250,
    500,
    1000,
    2500,
    5000,
    10000
}

function 参数:获取经验等级(n)
    if n == nil then
        return 0
    end

    if n < 30 then
        return 0
    end
    for i = 9, 1, -1 do
        if self.经验等级[i] <= n then
            return i
        end
    end
end

function 参数:获取等级(n)
    if n == nil then
        return 0
    end
    if n < 100 then
        return 0
    end
    for i = 20, 1, -1 do
        if self.等级[i] <= n then
            return i
        end
    end
end

function 参数:获取等级数值(n)
    n = math.floor(n)
    if n <= 0 then
        return 0
    end
    if n >= 20 then
        return 100000000
    end
    return self.等级[n]
end

function 参数:UpPalamLv(value, up)
	up = up or 1

	local palamlv = self:获取等级(value)
	local dif = self:获取等级数值(palamlv + 1) - self:获取等级数值(palamlv)
	local dif1 = value - self:获取等级数值(palamlv)
	local per = dif1 / dif
	local v = self:获取等级数值(palamlv + up) + (self:获取等级数值(palamlv + 1 + up) - self:获取等级数值(palamlv + up)) * per
	return math.floor(v)
end

function 参数:DownPalamLv(value, down)
	down = down or 1

	local palamlv = self:获取等级(value)
	local dif = self:获取等级数值(palamlv + 1) - self:获取等级数值(palamlv)
	local dif1 = value - self:获取等级数值(palamlv)
	local per = dif1 / dif
	local v = self:获取等级数值(palamlv - down) + (self:获取等级数值(palamlv + 1 - down) - self:获取等级数值(palamlv - down)) * per
	return math.floor(v)
end

return 参数