--UI名称建议与文件名相同，Page则为所使用的页面名称，具体可到wiki查看
local ui = { Type = "UI", Name = "UI名称", Page = "FullPage"}

--必须的 打开ui时所调用的
function ui:Open()
    UIManager:PageSort(self.Page)
    self:Update()
end

--必须的 页面更新所使用的方法
function ui:Update()
--声明 stringbuilder 类型表
    local text = SB:New()


--将文本输出到对于页面上，不用页面有不同属性，具体可到wiki查看
UIManager.page[self.Page].text = text:ToStr()
end


--返回ui
return ui