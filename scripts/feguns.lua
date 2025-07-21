local Players = game:GetService("Players")
local Debris = game:GetService("Debris")
local RunService = game:GetService("RunService")
local localPlayer = Players.LocalPlayer
local Mouse = localPlayer:GetMouse()

local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "FEGunsGui"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 240, 0, 270)
frame.Position = UDim2.new(0, 30, 0.5, -135)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderColor3 = Color3.fromRGB(255, 85, 85)
frame.BorderSizePixel = 2
frame.Active = true
frame.Draggable = true
frame.Visible = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundTransparency = 1
title.Text = "FE Guns GUI"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBlack
title.TextScaled = true

local subtitle = Instance.new("TextLabel", frame)
subtitle.Size = UDim2.new(1, 0, 0, 18)
subtitle.Position = UDim2.new(0, 0, 0, 30)
subtitle.BackgroundTransparency = 1
subtitle.Text = ".gg/9NsJFQcWNt"
subtitle.TextColor3 = Color3.fromRGB(180, 180, 180)
subtitle.Font = Enum.Font.Gotham
subtitle.TextScaled = true

local function makeButton(name, position, callback)
	local btn = Instance.new("TextButton", frame)
	btn.Size = UDim2.new(1, -20, 0, 30)
	btn.Position = position
	btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	btn.Text = name
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.Font = Enum.Font.GothamSemibold
	btn.TextScaled = true
	btn.BorderSizePixel = 0
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
	btn.MouseButton1Click:Connect(callback)
	return btn
end

local equippedTool -- Currently equipped gun tool reference
local flamethrowerFlames -- ParticleEmitter instance for flamethrower
local canShoot = false

local shootSound = Instance.new("Sound")
shootSound.SoundId = "rbxassetid://801217802"
shootSound.Volume = 1
shootSound.Parent = workspace

local reloadSound = Instance.new("Sound")
reloadSound.SoundId = "rbxassetid://8145744063"
reloadSound.Volume = 0.8
reloadSound.Parent = workspace

local fireSoundId = "rbxassetid://9068935533"

local function killNPCs()
	local char = localPlayer.Character
	if not char then return end
	for _, humanoid in ipairs(workspace:GetDescendants()) do
		if humanoid:IsA("Humanoid") then
			local character = humanoid.Parent
			if character ~= char and not Players:GetPlayerFromCharacter(character) then
				humanoid:ChangeState(Enum.HumanoidStateType.Dead)
			end
		end
	end
end

local function fireBullet(targetPosition)
	local char = localPlayer.Character
	if not char then return end
	local head = char:FindFirstChild("Head")
	if not head then return end
	local origin = head.Position
	local direction = (targetPosition - origin).Unit * 500
	local rayParams = RaycastParams.new()
	rayParams.FilterDescendantsInstances = {char}
	rayParams.FilterType = Enum.RaycastFilterType.Blacklist
	local result = workspace:Raycast(origin, direction, rayParams)

	local tracer = Instance.new("Part")
	tracer.Anchored = true
	tracer.CanCollide = false
	tracer.Size = Vector3.new(0.1, 0.1, (result and (result.Position - origin).Magnitude) or 500)
	tracer.Material = Enum.Material.Neon
	tracer.BrickColor = BrickColor.Red()
	tracer.CFrame = CFrame.new(origin, targetPosition) * CFrame.new(0, 0, -tracer.Size.Z / 2)
	tracer.Parent = workspace
	Debris:AddItem(tracer, 0.15)

	if result and result.Instance then
		local character = result.Instance:FindFirstAncestorOfClass("Model")
		if character and not Players:GetPlayerFromCharacter(character) then
			local hum = character:FindFirstChildOfClass("Humanoid")
			local rootPart = character:FindFirstChild("HumanoidRootPart")
			if hum and rootPart then
				if equippedTool and equippedTool.Name == "Flamethrower" then
					local flameParticle = Instance.new("ParticleEmitter")
					flameParticle.Texture = "rbxassetid://341300089"
					flameParticle.Lifetime = NumberRange.new(1)
					flameParticle.Rate = 100
					flameParticle.Speed = NumberRange.new(1, 3)
					flameParticle.Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 2), NumberSequenceKeypoint.new(1, 0)})
					flameParticle.Color = ColorSequence.new(Color3.fromRGB(255, 180, 0), Color3.fromRGB(255, 0, 0))
					flameParticle.LightEmission = 1
					flameParticle.Parent = rootPart
					Debris:AddItem(flameParticle, 5)

					local fireSound = Instance.new("Sound")
					fireSound.SoundId = fireSoundId
					fireSound.Volume = 1
					fireSound.PlayOnRemove = true
					fireSound.Parent = rootPart
					fireSound:Destroy()
				end
				hum:ChangeState(Enum.HumanoidStateType.Dead)
			end
		end
	end
end

local function clearCurrentTool()
	if flamethrowerFlames then
		flamethrowerFlames.Enabled = false
		flamethrowerFlames:Destroy()
		flamethrowerFlames = nil
	end
	if equippedTool then
		equippedTool:Destroy()
		equippedTool = nil
	end
	canShoot = false
end

local function equipGear(id, withFlames)
	clearCurrentTool()
	local asset = game:GetObjects("rbxassetid://" .. id)[1]
	if asset and asset:IsA("Tool") then
		asset.Parent = localPlayer.Backpack
		equippedTool = asset
		canShoot = true

		if withFlames then
			local handle = asset:FindFirstChild("Handle")
			if handle then
				local flame = Instance.new("ParticleEmitter")
				flame.Texture = "rbxassetid://341300089"
				flame.Lifetime = NumberRange.new(0.2)
				flame.Rate = 150
				flame.Speed = NumberRange.new(10, 15)
				flame.Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(1, 0)})
				flame.Color = ColorSequence.new(Color3.fromRGB(255, 180, 0), Color3.fromRGB(255, 0, 0))
				flame.LightEmission = 1
				flame.Enabled = true
				flame.Parent = handle
				flamethrowerFlames = flame
			end
		end

		reloadSound:Play()
	end
end

Mouse.Button1Down:Connect(function()
	if not canShoot then return end
	local char = localPlayer.Character
	if not char then return end
	local tool = char:FindFirstChildOfClass("Tool")
	if tool == equippedTool then
		shootSound:Play()
		fireBullet(Mouse.Hit.Position)
	end
end)

makeButton("Equip Pistol", UDim2.new(0, 10, 0, 60), function()
	equipGear(95354288)
end)

makeButton("Equip Timmy Gun", UDim2.new(0, 10, 0, 95), function()
	equipGear(116693764)
end)

makeButton("Equip Hyperlaser", UDim2.new(0, 10, 0, 130), function()
	equipGear(212296936)
end)

makeButton("Equip Flamethrower", UDim2.new(0, 10, 0, 165), function()
	equipGear(33879504, true)
end)

makeButton("Unequip Gun", UDim2.new(0, 10, 0, 200), function()
	clearCurrentTool()
end)
