--UI名称建议与文件名相同，Page则为所使用的页面名称，具体可到wiki查看
local ui = { Type = "UI", Name = "TrainView", Page = "TrainPage"}
local tm = TrainManager

ui.正在调教 = false

---@return boolean
function ui:Init(...)
    if self.正在调教 then
        print("请先结束之前的调教")
        return false
    end
    if {...} == nil then
        return false
    end

    self.正在调教 = true
    if TrainManager:StartTrain(...) then
        self.selectCharaShow = 2
        self:Open()
    end
    return false
end


--必须的 打开ui时所调用的
function ui:Open()
    UIManager:UIOnOpen(self)
    self:Update()
end

--必须的 页面更新所使用的方法
function ui:Update()
    local prop = SB:New()
    for int, value in ipairs(tm.参与人员) do
        ---@type Character
        prop:Append(AddButton(value.名字, "UI,TrainView,SelectCharaShow,"..int))
        if int % 4 == 0 then
            prop:Append("\n")
        else
            prop:Append("   ")
        end
    end
    prop:Append("\n")
    local fp = tm.FeelPack[ui.selectCharaShow]
    for i, value in ipairs(tm.FeelList) do
        prop:Append(string.format("%s:%s",value, fp[value]))
        if i % 4 == 0 then
            prop:Append("\n")
        else
            prop:Append("   ")
        end
    end


    UIManager.page[self.Page].Property.text = prop:ToStr()

    
    UIManager.page[self.Page].Options.text = TrainManager:GetOptions()
end

function ui:Append(text)
    UIManager.page[self.Page].Koujiu.text = UIManager.page[self.Page].Koujiu.text + text
end


function ui:SelectCharaShow(id)
    ui.selectCharaShow = id
end



--返回ui
return ui