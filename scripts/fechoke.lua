local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local HumanoidStates = Enum.HumanoidStateType:GetEnumItems()

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "HumanoidStateGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 400)
frame.Position = UDim2.new(0.5, -150, 0.5, -200)
frame.BackgroundColor3 = Color3.new(0, 0, 0)
frame.BorderSizePixel = 0
frame.Active = true
frame.Parent = screenGui

local dragPanel = Instance.new("Frame")
dragPanel.Size = UDim2.new(1, 0, 0, 30)
dragPanel.Position = UDim2.new(0, 0, 0, 0)
dragPanel.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
dragPanel.ZIndex = 1
dragPanel.Name = "DragPanel"
dragPanel.Parent = frame

local label = Instance.new("TextBox")
label.Size = UDim2.new(0.8, 0, 1, 0)
label.Position = UDim2.new(0.1, 0, 0, 0)
label.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
label.TextColor3 = Color3.new(1, 1, 1)
label.ClearTextOnFocus = false
label.TextEditable = false
label.TextWrapped = true
label.Font = Enum.Font.SourceSans
label.TextSize = 18
label.Text = "Select an NPC"
label.ZIndex = 2
label.Parent = dragPanel

local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 30, 1, 0)
closeButton.Position = UDim2.new(1, -30, 0, 0)
closeButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
closeButton.TextColor3 = Color3.new(1, 1, 1)
closeButton.Text = "X"
closeButton.Font = Enum.Font.SourceSansBold
closeButton.TextSize = 20
closeButton.ZIndex = 2
closeButton.Parent = dragPanel

closeButton.MouseButton1Click:Connect(function()
	screenGui:Destroy()
end)

local dragging = false
local dragStart, startPos

dragPanel.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = frame.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
		local delta = input.Position - dragStart
		frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)

local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, 0, 1, -30)
scrollFrame.Position = UDim2.new(0, 0, 0, 30)
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollFrame.ScrollBarThickness = 6
scrollFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
scrollFrame.BorderSizePixel = 0
scrollFrame.Parent = frame

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 4)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = scrollFrame

layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	scrollFrame.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
end)

local function createButton(text, callback)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, -8, 0, 30)
	btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.Text = text
	btn.Font = Enum.Font.SourceSans
	btn.TextSize = 18
	btn.Parent = scrollFrame
	btn.MouseButton1Click:Connect(callback)
end

local function getFullPath(obj)
	local path = obj.Name
	local current = obj
	while current.Parent and current.Parent ~= game do
		current = current.Parent
		path = current.Name .. "." .. path
	end
	return path
end

local selectedHumanoid = nil

Mouse.Button1Down:Connect(function()
	local target = Mouse.Target
	if not target then return end
	local model = target:FindFirstAncestorOfClass("Model")
	if model then
		local humanoid = model:FindFirstChildOfClass("Humanoid")
		if humanoid then
			selectedHumanoid = humanoid
			label.Text = getFullPath(model)
			for _, child in ipairs(scrollFrame:GetChildren()) do
				if child:IsA("TextButton") then
					child:Destroy()
				end
			end
			for _, state in ipairs(HumanoidStates) do
				createButton(state.Name, function()
					if selectedHumanoid then
						selectedHumanoid:ChangeState(state)
					end
				end)
			end
		end
	end
end)
