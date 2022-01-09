local ui = { Type = "UI", Name = "MainTitle", Page = "FullPage"}

function ui:Open()
    UIManager:PageSort(self.Page)
    self:Update()
end

--更新画面所用的方法
function ui:Update()
    local text = SB:New()
    text:AppendLine(string.format("<align=center><size=100>\n\n%s\n\n\n</size></align>", SystemData.GameName))
    text:AppendLine(string.format("<align=center><size=50>%s</size></align>", AddButton("开始", "UI,MianTitle,Test,你好")))
    text:AppendLine(string.format("<align=center><size=50>%s</size></align>", AddButton("继续", "")))
    text:AppendLine(string.format("<align=center><size=50>%s</size></align>", AddButton("设置", "")))
    text:AppendLine(string.format("<align=center><size=50>%s</size></align>", AddButton("退出", "")))

    UIManager.page[self.Page].text = text:ToStr()
end


function ui:Test(...)
    print(...)
end

return ui