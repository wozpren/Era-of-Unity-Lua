--UI名称建议与文件名相同，Page则为所使用的页面名称，具体可到wiki查看
local ui = { Type = "UI", Name = "TestView", Page = "FullPage"}

--必须的 打开ui时所调用的
function ui:Open()
    UIManager:UIOnOpen(self)
    self:Update()
end

--必须的 页面更新所使用的方法
function ui:Update()
    --声明 stringbuilder 类型表
    local text = SB:New()
    text:AppendLine(AddButton("测试", "UI,TestView,StartTrain"))

    --将文本输出到对于页面上，不用页面有不同属性，具体可到wiki查看
    UIManager.page[self.Page].text = text:ToStr()
end

function ui:StartTrain()
    local t = DataManager.PlayerData.CharaList[1]
    local tee = DataManager.PlayerData.CharaList[2]

   
    if UIManager:GetUI("TrainView"):Init(t , tee) then
        UIManager:Navigation("TrainView")
    end
end


--返回ui
return ui