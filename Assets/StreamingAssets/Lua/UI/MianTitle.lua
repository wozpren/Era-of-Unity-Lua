local ui = { Type = "UI", Name = "MainTitle", Page = "FullPage"}

function ui:Open()
    UIManager:UIOnOpen(self)
    self:Update()
end

--更新画面所用的方法
function ui:Update()
    local text = SB:New()
    text:AppendLine(string.format("<align=center><size=100>\n\n%s\n\n\n</size></align>", DataManager.SystemData.GameName))
    text:AppendLine(string.format("<align=center><size=50>%s</size></align>", AddButton("开始", "UI,MianTitle,Start")))
    text:AppendLine(string.format("<align=center><size=50>%s</size></align>", AddButton("继续", "UI,MianTitle,Continue")))
    text:AppendLine(string.format("<align=center><size=50>%s</size></align>", AddButton("设置", "UI,MianTitle,Setting")))
    text:AppendLine(string.format("<align=center><size=50>%s</size></align>", AddButton("退出", "UI,MianTitle,Exit")))

    UIManager.page[self.Page].text = text:ToStr()
end

function ui:Close()
    UIManager.page[self.Page].text = ""
end

function ui:Start()
    DataManager:GenratePlayerData()


    UIManager:GetUI("TestView"):Open()
end

function ui:Continue()
    UIManager:Navigation("LoadAndSave")
end

function ui:Setting()
    UIManager:Navigation("Setting")
end

function ui:Exit()
    UnityEngine.Application.Exit()
end



function ui:Test(...)
    print(...)
end

return ui