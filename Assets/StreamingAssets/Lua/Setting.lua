Setting = {}

local width = {1920, 1600, 1280}
local height = {1080, 900, 720}
local index = 0;

local FullMode = { Windowed = "窗口", ExclusiveFullScreen = "独占全屏", FullScreenWindow = "全屏模式"}

function Setting.Init()
    GM : ChangeState("Setting")
    Setting.Update()

    for i = 1, 3 do
        if height[i] == Config.height then
            index = i;
        end
    end
end

function Setting.Update()
    local text = SB.new()
    SB.append(text, "分辨率:")
    SB.appendLine(text, AddButton(Config.width.." X "..Config.height, "Setting.ChangeRes"))

    SB.append(text, "屏幕模式:")
    local type = Config.mode;
    SB.append(text, AddButton(FullMode[type], "Setting.ChangeMode,"..type))
    GeneralPage.page.text = SB.tostr(text)

    GeneralPage.menu.text = AddBack().."    "..AddButton("应用", "Setting.Apply")
end

function Setting.Apply()
    Config : ApplyWindows()
end

function Setting.ChangeRes()
    index = index - 1
    if index < 1 then
        index = 3
    end
    Config.width = width[index]
    Config.height = height[index]
    Setting.Update()
end

function Setting.ChangeMode(type)
    if type == "Windowed" then
        Config.mode = "ExclusiveFullScreen"
    elseif type == "ExclusiveFullScreen" then
        Config.mode = "FullScreenWindow"
    elseif type == "FullScreenWindow" then
        Config.mode = "Windowed"
    end
    Setting.Update()
end