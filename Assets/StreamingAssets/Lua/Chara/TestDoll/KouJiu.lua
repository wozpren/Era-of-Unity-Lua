--这里将教你如何制作一个口上

--下面这个是声明一个叫Koujiu的表，这个表在下面存放着一堆口上的调用方法
--不需要管他
local KouJiu = {}
local ui = UIManager:GetUI("TrainView")

--这是第一个调教方法，更多的方法可以查看\Lua\Train文件夹下
function KouJiu.爱抚(active)
    --text就是储存文本的变量，然后用SB声明 SB = StringBuilder。主要是为了节省性能
    --可以使用 text:Append("内容，注意要用小写双引号") 。就能把 内容，注意要用小写双引号 这个添加到 text中
    --同时还有 text:AppendLine("这个在结尾会添加换行符")
    -- SB.random(text, "这个可以", "随机添加", "这些引号里", "其中一个到text里")
    local text = SB:New()
    --active是储存调教时的变量
    -- if 条件 then 但满足条件时 就会执行if里的语句，不行就到下一个elseif继续判断，或者else
    if active.选择 == "头部" then

    elseif active.选择 == "胸部" then

    elseif active.选择 == "小穴" then

    elseif active.选择 == "肛门" then

    end
    --最后要用text:ToStr() 转换为 string 在用TrainPage : Write()就能输出到游戏里了
    ui:Append(text:ToStr(), active)
end

function KouJiu.舔舐(active)
    local text = SB:New()
    if active.Select == "胸部" then

    elseif active.Select == "小穴" then

    elseif active.Select == "肛门" then

    elseif active.Select == "脚部" then

    elseif active.Select == "肉棒" then

    elseif active.Select == "阴蒂" then

    end

    ui:Append(text:ToStr(), active)
end

function KouJiu.接吻(active)
    local text = SB:New()

    ui:Append(text:ToStr(), active)
end

function KouJiu.口交(active)
    local text = SB:New()

    ui:Append(text:ToStr(), active)
end

function KouJiu.自慰(active)
    local text = SB:New()

    ui:Append(text:ToStr(), active)
end

function KouJiu.张开(active)
    local text = SB:New()
    if active.Select == "小穴" then

    elseif active.Select == "肛门" then

    end

    ui:Append(text:ToStr(), active)
end


function KouJiu.插入小穴(active)
    local text = SB:New()

    ui:Append(text:ToStr(), active)
end

function KouJiu.插入菊穴(active)
    local text = SB:New()

    ui:Append(text:ToStr(), active)
end

function KouJiu.指插入(active)
    local text = SB:New()

    ui:Append(text:ToStr(), active)
end


function KouJiu.高潮(pack, type ,number,active)
    local text = SB:New()
    ui:Append(text:ToStr(), active)
end

return KouJiu