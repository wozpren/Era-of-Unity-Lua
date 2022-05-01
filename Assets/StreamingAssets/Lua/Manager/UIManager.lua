UIManager = {}

UIManager.uistack = require("list"):new()
UIManager.page = 
{
    Title = GM.Title,
    TrainPage = GM.TrainPage,
    GeneralPage = GM.GeneralPage,
    FullPage = GM.FullPage
}

function UIManager:Init()
    EventManager:AddListener("Update", self.Update)

end


function UIManager:Navigation(name, ...)
    local ui = require("UI/" .. name)
    if ui ~= true and ui.Type == "UI" then
        self.uistack:push(self.CurrnetUI)
        return ui:Open(...)
    end
    return false
end

function UIManager.Back()
    if UIManager.CurrnetUI.Close ~= nil then
        UIManager.CurrnetUI:Close()
    end
    if UIManager.uistack.length > 0 then
        UIManager.CurrnetUI = UIManager.uistack:pop()
        UIManager.CurrnetUI:Open()
    end
end

function UIManager:GetUI(name)
    local ui = require("UI/" .. name)
    if ui ~= true and ui.Type == "UI" then
        return ui
    end
end

function UIManager:UIOnOpen(ui)
    self:PageSort(ui.Page)
    self.CurrnetUI = ui
end

function UIManager:UIOnClose(ui)
    if self.CurrnetUI == ui then
        self.CurrnetUI = nil
    end
end


function UIManager.Update()
    if UIManager.CurrnetUI ~= nil then
        UIManager.CurrnetUI:Update()
    end
end


function UIManager:PageSort(page)
    if page == "FullPage" then
        for key, value in pairs(self.page) do
            value.gameObject:SetActive(false)
        end
        self.page.FullPage.gameObject:SetActive(true)
    else
        for key, value in pairs(self.page) do
            if page ~= "Title" and page ~= "MessageStack" then
                value.gameObject:SetActive(false)
            end
            self.page[page].gameObject:SetActive(true)
        end
    end
end

function UIManager.Call(page, method, ...)
    local ui = UIManager:GetUI(page)
    if ui ~= nil then
        ui[method](ui, ...)
    end
end