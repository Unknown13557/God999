local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")
local main = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local up = Instance.new("TextButton")
local down = Instance.new("TextButton")
local onof = Instance.new("TextButton")
local TextLabel = Instance.new("TextLabel")
local plus = Instance.new("TextButton")
local speed = Instance.new("TextLabel")
local mine = Instance.new("TextButton")
local closebutton = Instance.new("TextButton")
local mini = Instance.new("TextButton")
local mini2 = Instance.new("TextButton")

main.Name = "main"
main.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
main.IgnoreGuiInset = true
main.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
main.ResetOnSpawn = false

Frame.Parent = main
Frame.BackgroundColor3 = Color3.fromRGB(163, 255, 137)
Frame.BorderColor3 = Color3.fromRGB(103, 221, 213)
Frame.Position = UDim2.new(0.100320168, 0, 0.379746825, 0)
Frame.Size = UDim2.new(0, 190, 0, 57)

up.Name = "up"
up.Parent = Frame
up.BackgroundColor3 = Color3.fromRGB(79, 255, 152)
up.Size = UDim2.new(0, 44, 0, 28)
up.Font = Enum.Font.SourceSans
up.Text = "UP"
up.TextColor3 = Color3.fromRGB(0, 0, 0)
up.TextSize = 14.000

down.Name = "down"
down.Parent = Frame
down.BackgroundColor3 = Color3.fromRGB(215, 255, 121)
down.Position = UDim2.new(0, 0, 0.491228074, 0)
down.Size = UDim2.new(0, 44, 0, 28)
down.Font = Enum.Font.SourceSans
down.Text = "DOWN"
down.TextColor3 = Color3.fromRGB(0, 0, 0)
down.TextSize = 14.000

onof.Name = "onof"
onof.Parent = Frame
onof.BackgroundColor3 = Color3.fromRGB(255, 249, 74)
onof.Position = UDim2.new(0.702823281, 0, 0.491228074, 0)
onof.Size = UDim2.new(0, 56, 0, 28)
onof.Font = Enum.Font.SourceSans
onof.Text = "fly"
onof.TextColor3 = Color3.fromRGB(0, 0, 0)
onof.TextSize = 14.000

TextLabel.Parent = Frame
TextLabel.BackgroundColor3 = Color3.fromRGB(242, 60, 255)
TextLabel.Position = UDim2.new(0.469327301, 0, 0, 0)
TextLabel.Size = UDim2.new(0, 100, 0, 28)
TextLabel.Font = Enum.Font.SourceSans
TextLabel.Text = "Fly Gui master v999"
TextLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
TextLabel.TextScaled = true
TextLabel.TextSize = 14.000
TextLabel.TextWrapped = true

plus.Name = "plus"
plus.Parent = Frame
plus.BackgroundColor3 = Color3.fromRGB(133, 145, 255)
plus.Position = UDim2.new(0.231578946, 0, 0, 0)
plus.Size = UDim2.new(0, 45, 0, 28)
plus.Font = Enum.Font.SourceSans
plus.Text = "+"
plus.TextColor3 = Color3.fromRGB(0, 0, 0)
plus.TextScaled = true
plus.TextSize = 14.000
plus.TextWrapped = true

speed.Name = "speed"
speed.Parent = Frame
speed.BackgroundColor3 = Color3.fromRGB(255, 85, 0)
speed.Position = UDim2.new(0.468421042, 0, 0.491228074, 0)
speed.Size = UDim2.new(0, 44, 0, 28)
speed.Font = Enum.Font.SourceSans
speed.Text = "16"
speed.TextColor3 = Color3.fromRGB(0, 0, 0)
speed.TextScaled = true
speed.TextSize = 14.000
speed.TextWrapped = true

mine.Name = "mine"
mine.Parent = Frame
mine.BackgroundColor3 = Color3.fromRGB(123, 255, 247)
mine.Position = UDim2.new(0.231578946, 0, 0.491228074, 0)
mine.Size = UDim2.new(0, 45, 0, 29)
mine.Font = Enum.Font.SourceSans
mine.Text = "-"
mine.TextColor3 = Color3.fromRGB(0, 0, 0)
mine.TextScaled = true
mine.TextSize = 14.000
mine.TextWrapped = true

closebutton.Name = "Close"
closebutton.Parent = main.Frame
closebutton.BackgroundColor3 = Color3.fromRGB(225, 25, 0)
closebutton.Font = "SourceSans"
closebutton.Size = UDim2.new(0, 45, 0, 28)
closebutton.Text = "X"
closebutton.TextSize = 30
closebutton.Position =  UDim2.new(0, 0, -1, 27)

mini.Name = "minimize"
mini.Parent = main.Frame
mini.BackgroundColor3 = Color3.fromRGB(192, 150, 230)
mini.Font = "SourceSans"
mini.Size = UDim2.new(0, 45, 0, 28)
mini.Text = "-"
mini.TextSize = 40
mini.Position = UDim2.new(0, 44, -1, 27)

mini2.Name = "minimize2"
mini2.Parent = main.Frame
mini2.BackgroundColor3 = Color3.fromRGB(192, 150, 230)
mini2.Font = "SourceSans"
mini2.Size = UDim2.new(0, 45, 0, 28)
mini2.Text = "+"
mini2.TextSize = 40
mini2.Position = UDim2.new(0, 44, -1, 57)
mini2.Visible = false

speeds = 16

local speaker = game:GetService("Players").LocalPlayer

local chr = game.Players.LocalPlayer.Character
local hum = chr and chr:FindFirstChildWhichIsA("Humanoid")

nowe = false

local RESPECT_COREGUI = false
local TOP_MARGIN = 0

local function pointerPos(input)
	return (input.UserInputType == Enum.UserInputType.Touch)
		and Vector2.new(input.Position.X, input.Position.Y)
		or UserInputService:GetMouseLocation()
end

local function over(inst, pos)
	local p, s = inst.AbsolutePosition, inst.AbsoluteSize
	return pos.X >= p.X and pos.X <= p.X + s.X and pos.Y >= p.Y and pos.Y <= p.Y + s.Y
end

local dragging = false
local dragStart, startPos

Frame.Active = true
Frame.Draggable = false

Frame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then
		local pos = pointerPos(input)
		if over(onof, pos) then return end
		dragging = true
		dragStart = input.Position
		startPos = Frame.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

Frame.InputChanged:Connect(function(input)
	if not dragging then return end
	if input.UserInputType == Enum.UserInputType.MouseMovement
		or input.UserInputType == Enum.UserInputType.Touch then

		local delta = input.Position - dragStart
		local newX = startPos.X.Offset + delta.X
		local newY = startPos.Y.Offset + delta.Y

		local cam = workspace.CurrentCamera
		if cam then
			local vp = cam.ViewportSize
			local topInset = GuiService:GetGuiInset().Y
			local minY = (RESPECT_COREGUI and (topInset + TOP_MARGIN) or TOP_MARGIN)

			newX = math.clamp(newX, 0, math.max(0, vp.X - Frame.AbsoluteSize.X))
			newY = math.clamp(newY, minY, math.max(minY, vp.Y - Frame.AbsoluteSize.Y))
		end

		Frame.Position = UDim2.fromOffset(newX, newY)
	end
end)

task.defer(function()
	local abs = Frame.AbsolutePosition
	Frame.Position = UDim2.fromOffset(abs.X, abs.Y)
	
	local cam = workspace.CurrentCamera
	if cam then
		local vp = cam.ViewportSize
		local topInset = GuiService:GetGuiInset().Y
		local minY = (RESPECT_COREGUI and (topInset + TOP_MARGIN) or TOP_MARGIN)

		local x = math.clamp(abs.X, 0, math.max(0, vp.X - Frame.AbsoluteSize.X))
		local y = math.clamp(abs.Y, minY, math.max(minY, vp.Y - Frame.AbsoluteSize.Y))
		Frame.Position = UDim2.fromOffset(x, y)
	end
end)

local function hookViewportChanged()
	local cam = workspace.CurrentCamera
	if not cam then return end
	cam:GetPropertyChangedSignal("ViewportSize"):Connect(function()
		if not dragging then
			local abs = Frame.AbsolutePosition
			local vp = cam.ViewportSize
			local topInset = GuiService:GetGuiInset().Y
			local minY = (RESPECT_COREGUI and (topInset + TOP_MARGIN) or TOP_MARGIN)

			local x = math.clamp(abs.X, 0, math.max(0, vp.X - Frame.AbsoluteSize.X))
			local y = math.clamp(abs.Y, minY, math.max(minY, vp.Y - Frame.AbsoluteSize.Y))
			Frame.Position = UDim2.fromOffset(x, y)
		end
	end)
end
if workspace.CurrentCamera then hookViewportChanged() end
workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(hookViewportChanged)

------------
-- === HELPERS & STATE ===
local Players, RunService = game:GetService("Players"), game:GetService("RunService")
local localPlayer = Players.LocalPlayer

-- Khởi tạo speeds từ label nếu có
speeds = tonumber(speed.Text) or speeds or 16
speed.Text = tostring(speeds)

-- Dùng lại cờ 'nowe' làm trạng thái đang bay
nowe = false

-- Conns tạm
local tpConn, flyConn
local upHoldStop, downHoldStop

local function getHumanoid(plr)
	local c = plr and plr.Character
	return c and c:FindFirstChildOfClass("Humanoid")
end

local function setAllStates(hum, enabled)
	for _, s in ipairs(Enum.HumanoidStateType:GetEnumItems()) do
		hum:SetStateEnabled(s, enabled)
	end
end
-- === TP-WALKING (scale theo 'speeds') ===
local function startTPWalking()
	if tpConn then return end
	tpConn = RunService.Heartbeat:Connect(function(dt)
		local chr = localPlayer.Character
		local hum = getHumanoid(localPlayer)
		if not (nowe and chr and hum and hum.Parent) then return end
		local md = hum.MoveDirection
		if md.Magnitude > 0 then
			chr:TranslateBy(md * math.max(1, speeds) * dt)
		end
	end)
end

local function stopTPWalking()
	if tpConn then tpConn:Disconnect(); tpConn = nil end
end
-- === FLY CORE & TOGGLE ===
local function attachBodyControllers(root)
	local bg = Instance.new("BodyGyro")
	bg.P = 9e4
	bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
	bg.CFrame = root.CFrame
	bg.Parent = root

	local bv = Instance.new("BodyVelocity")
	bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
	bv.Velocity = Vector3.new(0, 0.1, 0)
	bv.Parent = root
	return bg, bv
end

local function startFly()
	if nowe then return end
	nowe = true

	local hum = getHumanoid(localPlayer)
	if not hum then return end

	setAllStates(hum, false)
	hum:ChangeState(Enum.HumanoidStateType.Swimming)

	local char = localPlayer.Character
	if char and char:FindFirstChild("Animate") then
		char.Animate.Disabled = true
		for _, tr in ipairs(hum:GetPlayingAnimationTracks()) do tr:AdjustSpeed(0) end
	end

	startTPWalking()

	local torso = char and (char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso"))
	if not torso then return end

	local bg, bv = attachBodyControllers(torso)
	hum.PlatformStand = true

	local flySpeed, maxSpeed = 0, 50
	flyConn = RunService.RenderStepped:Connect(function()
		if not (nowe and hum.Health > 0) then return end
		local md = hum.MoveDirection
		local moving = md.Magnitude > 0
		flySpeed = math.clamp(flySpeed + (moving and (0.5 + flySpeed/maxSpeed) or -1), 0, maxSpeed)

		local cam = workspace.CurrentCamera
		bv.Velocity = (cam and md or Vector3.zero) * flySpeed
		if cam then
			bg.CFrame = cam.CFrame * CFrame.Angles(-math.rad(50 * flySpeed / maxSpeed * (moving and 1 or 0)), 0, 0)
		end
	end)
end

local function stopFly()
	if not nowe then return end
	nowe = false

	stopTPWalking()
	if flyConn then flyConn:Disconnect(); flyConn = nil end

	local hum = getHumanoid(localPlayer)
	if hum then
		setAllStates(hum, true)
		hum:ChangeState(Enum.HumanoidStateType.RunningNoPhysics)
		local char = localPlayer.Character
		if char and char:FindFirstChild("Animate") then
			char.Animate.Disabled = false
		end
		hum.PlatformStand = false
	end
end

-- Thay old: onof.MouseButton1Down:connect(function() ... end)
onof.MouseButton1Click:Connect(function()
	if nowe then stopFly() else startFly() end
end)

-- === HOLD MOVE UP/DOWN ===
local function holdY(dir) -- dir = 1 hoặc -1
	local alive = true
	task.spawn(function()
		while alive do
			task.wait()
			local c = localPlayer.Character
			local hrp = c and c:FindFirstChild("HumanoidRootPart")
			if hrp then hrp.CFrame *= CFrame.new(0, dir, 0) end
		end
	end)
	return function() alive = false end
end

up.MouseButton1Down:Connect(function()
	if upHoldStop then upHoldStop() end
	upHoldStop = holdY(1)
end)
up.MouseLeave:Connect(function()
	if upHoldStop then upHoldStop(); upHoldStop = nil end
end)

down.MouseButton1Down:Connect(function()
	if downHoldStop then downHoldStop() end
	downHoldStop = holdY(-1)
end)
down.MouseLeave:Connect(function()
	if downHoldStop then downHoldStop(); downHoldStop = nil end
end)

-- === RESPAWN SAFE ===
Players.LocalPlayer.CharacterAdded:Connect(function()
	task.wait(0.7)
	-- tắt bay nếu đang bật, tự khôi phục state/animate
	if nowe then
		local ok = pcall(stopFly)
	end
end)
-- === SPEED + / - ===
plus.MouseButton1Down:Connect(function()
	speeds += 1
	speed.Text = tostring(speeds)
end)

mine.MouseButton1Down:Connect(function()
	if speeds <= 1 then
		speed.Text = "cannot be less than 1"
		task.wait(1)
	else
		speeds -= 1
	end
	speed.Text = tostring(speeds)
end)

-- === WINDOW CONTROLS ===
closebutton.MouseButton1Click:Connect(function()
	main:Destroy()
end)

mini.MouseButton1Click:Connect(function()
	up.Visible, down.Visible, onof.Visible = false, false, false
	plus.Visible, speed.Visible, mine.Visible = false, false, false
	mini.Visible, mini2.Visible = false, true
	main.Frame.BackgroundTransparency = 1
	closebutton.Position = UDim2.new(0, 0, -1, 57)
end)

mini2.MouseButton1Click:Connect(function()
	up.Visible, down.Visible, onof.Visible = true, true, true
	plus.Visible, speed.Visible, mine.Visible = true, true, true
	mini.Visible, mini2.Visible = true, false
	main.Frame.BackgroundTransparency = 0
	closebutton.Position = UDim2.new(0, 0, -1, 27)
end)
