--[[
author: minishakk and tommyfart
fe bypass omg
]]--
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = game.CoreGui

local gui = Instance.new("ScreenGui")
gui.Name = "DominantFE_GUI"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Enabled = true
gui.Parent = PlayerGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 180)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -90)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Visible = true
mainFrame.Parent = gui

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 8)
uiCorner.Parent = mainFrame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundTransparency = 1
title.Text = "DominantFE"
title.Font = Enum.Font.GothamBold
title.TextSize = 24
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Visible = true
title.Parent = mainFrame

local subtitle = Instance.new("TextLabel")
subtitle.Size = UDim2.new(1, 0, 0, 20)
subtitle.Position = UDim2.new(0, 0, 0, 35)
subtitle.BackgroundTransparency = 1
subtitle.Text = ".gg/9NsJFQcWNt | by minishakk & tommyfart"
subtitle.Font = Enum.Font.Gotham
subtitle.TextSize = 12
subtitle.TextColor3 = Color3.fromRGB(170, 170, 170)
subtitle.Visible = true
subtitle.Parent = mainFrame

local button = Instance.new("TextButton")
button.Size = UDim2.new(0, 240, 0, 40)
button.Position = UDim2.new(0.5, -120, 0.5, -20)
button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
button.Text = "FE Guns"
button.Font = Enum.Font.GothamBold
button.TextSize = 18
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.Visible = true
button.Parent = mainFrame

local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 6)
buttonCorner.Parent = button

local tooltip = Instance.new("TextLabel")
tooltip.Size = UDim2.new(0, 200, 0, 20)
tooltip.Position = UDim2.new(0.5, -100, 1, 5)
tooltip.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
tooltip.TextColor3 = Color3.fromRGB(255, 255, 255)
tooltip.Text = "only works on npcs | equip gun 2 times"
tooltip.Font = Enum.Font.Gotham
tooltip.TextSize = 12
tooltip.Visible = false
tooltip.Parent = mainFrame

local tooltipCorner = Instance.new("UICorner")
tooltipCorner.CornerRadius = UDim.new(0, 4)
tooltipCorner.Parent = tooltip

button.MouseEnter:Connect(function()
	tooltip.Visible = true
end)

button.MouseLeave:Connect(function()
	tooltip.Visible = false
end)

button.MouseButton1Click:Connect(function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/tommyfart/minifart/refs/heads/main/scripts/feguns.lua"))()
end)
