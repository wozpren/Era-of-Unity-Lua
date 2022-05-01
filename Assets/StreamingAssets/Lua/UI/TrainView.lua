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
        ui:Update()
        return true
    end
    return false
end


--必须的 打开ui时所调用的
function ui:Open()
    UIManager:UIOnOpen(self)
    self:Update()
end

function ui:Close()
    self.正在调教 = false
    UIManager:UIOnClose(self)
end

--必须的 页面更新所使用的方法
function ui:Update()
    if not self.正在调教 then
        UIManager.page[self.Page].Property.text = ""
        UIManager.page[self.Page].Options.text = ""
        UIManager.page[self.Page].Koujiu.text = ""
        return
    end
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
    prop:Append("精液：")
    for int, chara in ipairs(tm.参与人员) do
        if chara.阴部.Name == "阴茎" then
            prop:Append(string.format("%s[%s/10000] ", chara.名字, chara:精液()))
        end
    end

    UIManager.page[self.Page].Property.text = prop:ToStr()


    local o = TrainManager:GetOptions()
    local p = SB:New()

    p:Append(AddButton("人物状态 ", "UI,TrainView,Message"))
    p:Append(AddButton("结束", "UI,TrainView,EndTrain"))

    UIManager.page[self.Page].Options.text = o:ToStr().."\n"..p:ToStr()
end


function ui:Message()
    UIManager:Navigation("CharaMessage", tm.参与人员)
end

function ui:EndTrain()
    TrainManager.EndTrain()
    self.正在调教 = false
end

function ui:Append(text, active)
    text = string.gsub(text, "@player@", active.调教者.名字)
    text = string.gsub(text, "@target@", active.被调教者.名字)
    UIManager.page[self.Page].Koujiu.text = UIManager.page[self.Page].Koujiu.text..text.."\n"
end


function ui:SelectCharaShow(id)
    ui.selectCharaShow = id
end




--返回ui
return ui