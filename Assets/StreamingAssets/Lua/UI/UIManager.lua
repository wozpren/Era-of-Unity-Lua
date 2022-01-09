UIManager = {}

UIManager.uistack = require("list"):new()
UIManager.page = {
    Title = GM.Title,
    TrainPage = GM.TrainPage,
    GeneralPage = GM.GeneralPage,
    MessageStack = GM.MessageStack,
    FullPage = GM.FullPage
}

function UIManager:Navigation(name, ...)
    local ui = require("UI/" .. name)
    if ui ~= true and ui.Type == "UI" then
        self.uistack:push(ui)
        ui.Open(...)
    end
end

function UIManager:Back()
    self.uistack:pop()
    if self.uistack.length > 0 then
        self.uistack:head().Open()
    end
end

function UIManager:GetUI(name)
    local ui = require("UI/" .. name)
    if ui ~= true and ui.Type == "UI" then
        return ui
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