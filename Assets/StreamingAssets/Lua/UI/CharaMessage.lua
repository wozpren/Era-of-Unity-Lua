local ui = { Type = "UI", Name = "CharaMessage", Page = "GeneralPage"}

--必须的 打开ui时所调用的
function ui:Open(charaList)
    UIManager:UIOnOpen(self)
    self.CharaList = charaList
    self.index = 1
    self:Update()
end

--必须的 页面更新所使用的方法
function ui:Update()
    local text = SB:New()
    if type(self.CharaList) ~= "table" then
        text:Append("所选参数不为表")
    else
        if self.index > #self.CharaList or self.index < 1 then
            self.index = 1
        end
    
        local chara = self.CharaList[self.index]
        if chara == nil then
            text:Append("选择的角色为null")
        else
            text:Append(chara:角色信息())
        end
    end


    --将文本输出到对于页面上，不用页面有不同属性，具体可到wiki查看
    UIManager.page[self.Page].Page.text = text:ToStr()

    local menu = SB:New()
    menu:Append(AddButtonSpe("返回", "UIManager.Back,"))
    if self.index > 1 then
        menu:Append(AddButtonSpe("上一个", "UI,CharaMessage,Up"))
    else
        menu:Append("上一个    ")
    end
    if self.index < #self.CharaList then
        menu:Append(AddButtonSpe("下一个", "UI,CharaMessage,Down"))
    else
        menu:Append("下一个")
    end

    UIManager.page[self.Page].Menu.text = menu:ToStr()
end

function ui:Up()
    self.index = self.index - 1
    self:Update()
end

function ui:Down()
    self.index = self.index + 1
    self:Update()
end

return ui