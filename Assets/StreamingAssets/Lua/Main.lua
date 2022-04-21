local dbg = require('emmy_core')
dbg.tcpConnect('localhost', 9966)


--主入口函数。从这里开始lua逻辑
function Main()
	GameObject = UnityEngine.GameObject
	math.randomseed(tostring(os.time()):reverse():sub(1, 7))
	print("logic start")
end

function Init()
	GM = EraHF.GameManager.Instance
    Message = GM.MessageStack
	Mathf = UnityEngine.Mahtf
--读取文件
	dofile("UI/UIToolkit")
	dofile("Manager/Util")
	dofile("Manager/DataManager")
	dofile("Manager/CharaManager")
	dofile("Manager/EventManager")
	dofile("Manager/TrainManager")
	dofile("Manager/UIManager")
	dofile("System/coroutine")
--声明全局变量
	UIManager:Init()

--读取数据
	DataManager:LoadSystemData()
--启动游戏
	UIManager:GetUI("MianTitle"):Open()

	
end





--场景切换通知
function OnLevelWasLoaded(level)
	collectgarbage("collect")
	Time.timeSinceLevelLoad = 0
end

function OnApplicationQuit()
end

function EnumtoNumber(enum)
	local feel = tostring(enum)
	if feel == "正常" then
		return 0
	elseif feel == "正常" then
		return 1
	elseif feel == "陷落" then
		return 2
	elseif feel == "堕落" then
		return 3
	elseif feel == "狂堕" then
		return 4
	end
end


function table.Exist(list, par)
	if type(list) == "table" then
		for index, value in ipairs(list) do
			if value == par then
				return true
			end
		end
	end
	return false
end

function table.Find(list, par)
	if not list then
	  return nil
	end 
	if type(list) == "table" then
		for key, value in pairs(list) do
			if key == par then
				return value
			end
		end
	end
	return 0
end 

function TableAdd(data, value)
	if type(data) ~= "table" then
		data = {}
	end
	table.insert(data, value)
end


function EventInvoke(eventName, ...)
	EventManager:SendEvent(eventName,...)
end


function CoroutineResume(...)
	if 协程 == nil then
		print("线程不存在，无法运行")
	end
	if coroutine.status(协程) ~= "suspended" then
		print(coroutine.status(协程))
		print("线程不在挂起状态，无法运行")
	end
	local flag, msg = coroutine.resume(协程, ...)
	if not flag then
		error(msg)
	end
end

function UpPalamLv(value, up)
	up = up or 1

	local palamlv = GetPalamLV(value)
	local dif = PalamLV(palamlv + 1) - PalamLV(palamlv)
	local dif1 = value - PalamLV(palamlv)
	local per = dif1 / dif
	local v = PalamLV(palamlv + up) + (PalamLV(palamlv + 1 + up) - PalamLV(palamlv + up)) * per
	return math.floor(v)
end

function DownPalamLv(value, down)
	down = down or 1

	local palamlv = GetPalamLV(value)
	local dif = PalamLV(palamlv + 1) - PalamLV(palamlv)
	local dif1 = value - PalamLV(palamlv)
	local per = dif1 / dif
	local v = PalamLV(palamlv - down) + (PalamLV(palamlv + 1 - down) - PalamLV(palamlv - down)) * per
	return math.floor(v)
end

function PalamLV(value)
	if value <= 0 then
		return 0
	elseif value <= 1 then
		return 100
	elseif value <= 2 then
		return 500
	elseif value <= 3 then
		return 3000
	elseif value <= 4 then
		return 10000
	elseif value <= 5 then
		return 30000
	elseif value <= 6 then
		return 60000
	elseif value <= 7 then
		return 100000
	elseif value <= 8 then
		return 150000
	elseif value <= 9 then
		return 250000
	elseif value <= 10 then
		return 500000
	elseif value <= 11 then
		return 1000000
	elseif value <= 12 then
		return 2500000
	elseif value <= 13 then
		return 5000000
	elseif value <= 14 then
		return 10000000
	elseif value <= 15 then
		return 50000000
	else
		return 100000000
	end
end

function DownPacke(base, v)
	for key, value in pairs(base) do
		value = value * v
	end
end

function GetPalamLV(value)
 	if value <= 100 then
		return 0	
	elseif value <= 500 then
		return 1
	elseif value <= 3000 then
		return 2
	elseif value <= 10000 then
		return 3
	elseif value <= 30000 then
		return 4
	elseif value <= 60000 then
		return 5
	elseif value <= 100000 then
		return 6
	elseif value <= 150000 then
		return 7
	elseif value <= 250000 then
		return 8
	elseif value <= 500000 then
		return 9
	elseif value <= 1000000 then
		return 10
	elseif value <= 2500000 then
		return 11
	elseif value <= 5000000 then
		return 12
	elseif value <= 10000000 then
		return 13
	elseif value <= 50000000 then
		return 14
	elseif value <= 100000000 then
		return 15
	else
		return 16
	end
end



function GetExpLV(value)
	if value < 50 then
		return 0
	elseif value < 150 then
		return 1
	elseif value < 500 then
		return 2
	elseif value < 1000 then
		return 3
	elseif value < 2500 then
		return 4
	elseif value < 5000 then
		return 5
	else
		local l = math.floor((value - 5000) / 5000)
		return l + 6
   end
end

function ExpLV(level)
	if level == 0 then
		return 0
	elseif level == 1 then
		return 50
	elseif level == 2 then
		return 150
	elseif level == 3 then
		return 500
	elseif level == 4 then
		return 1000
	elseif level == 5 then
		return 2500
	else
		return (level - 6) * 5000 + 5000
	end
end