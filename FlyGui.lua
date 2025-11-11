do
local UserInputService = game:GetService("UserInputService")
local GuiService       = game:GetService("GuiService")
local Players          = game:GetService("Players")
local RunService       = game:GetService("RunService")
local Workspace        = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local RS          = RunService
local WS          = Workspace
local UIS         = UserInputService
local GS          = GuiService

local main = Instance.new("ScreenGui")
if syn and syn.protect_gui then
	syn.protect_gui(main)
end
main.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
main.DisplayOrder = 198282823
main.Name = "main"
main.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
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
down.Position = UDim2.new(0, 0, 0.50500074, 0)
down.Size = UDim2.new(0, 44, 0, 28)
down.Font = Enum.Font.SourceSans
down.Text = "DOWN"
down.TextColor3 = Color3.fromRGB(0, 0, 0)
down.TextSize = 14.000

onof.Name = "onof"
onof.Parent = Frame
onof.BackgroundColor3 = Color3.fromRGB(255, 249, 74)
onof.Position = UDim2.new(0.701, 0, 0.50500074, 0)
onof.Size = UDim2.new(0, 57, 0, 28)
onof.Font = Enum.Font.SourceSans
onof.Text = "FLY"
onof.TextColor3 = Color3.fromRGB(0, 0, 0)
onof.TextSize = 17.000
onof.ZIndex = 50

local onofDefaultTextColor = onof.TextColor3
local onofDefaultBG        = onof.BackgroundColor3
local onofDefaultText      = onof.Text

local onofStroke = onof:FindFirstChild("FlyStroke") or Instance.new("UIStroke")
onofStroke.Name = "FlyStroke"
onofStroke.Parent = onof
onofStroke.Thickness = 2
onofStroke.Transparency = 0
onofStroke.Color = Color3.fromRGB(255,255,255)
onofStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
onofStroke.Enabled = false

onof.BorderSizePixel = 1

local flyRainbowConn = nil
local flyHueTime     = 0

local function startFlyVisuals()
	onof.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
	onof.Text = "FLY"
	onof.TextStrokeTransparency = 0
	onof.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
	onofStroke.Enabled = true

	if flyRainbowConn then flyRainbowConn:Disconnect() end
	flyRainbowConn = RS.RenderStepped:Connect(function(dt)
		flyHueTime += dt
		local hue = (flyHueTime * 0.25) % 1
		local rainbow = Color3.fromHSV(hue, 1, 1)
		onof.TextColor3  = rainbow
		onofStroke.Color = rainbow
	end)
end

local function stopFlyVisuals()
	if flyRainbowConn then
		flyRainbowConn:Disconnect()
		flyRainbowConn = nil
	end

	onof.BackgroundColor3 = onofDefaultBG
	onof.TextColor3       = onofDefaultTextColor
	onof.Text             = onofDefaultText
	onof.TextStrokeTransparency = 1
	onofStroke.Enabled = false
	onofStroke.Color = Color3.fromRGB(255,255,255)
end

--=== UP/DOWN: AUTO ASCEND/DESCEND (450 stud/s, visuals như FLY, đồng bộ noclip) ===

-- Lưu màu gốc để restore
local upBG0, upText0 = up.BackgroundColor3, up.TextColor3
local downBG0, downText0 = down.BackgroundColor3, down.TextColor3

-- UIStroke cho UP/DOWN giống FLY
local upStroke = up:FindFirstChild("FlyStroke") or Instance.new("UIStroke")
upStroke.Name = "FlyStroke"
upStroke.Parent = up
upStroke.Thickness = 2
upStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
upStroke.Enabled = false

local downStroke = down:FindFirstChild("FlyStroke") or Instance.new("UIStroke")
downStroke.Name = "FlyStroke"
downStroke.Parent = down
downStroke.Thickness = 2
downStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
downStroke.Enabled = false

-- Rainbow visuals (đồng bộ với flyHueTime)
local upRainbowConn, downRainbowConn
local function startBtnVisuals(btn, stroke)
	btn.BackgroundColor3 = Color3.fromRGB(45,45,45)
	btn.TextStrokeTransparency = 0
	stroke.Enabled = true
	return RS.RenderStepped:Connect(function(dt)
		flyHueTime += dt
		local hue = (flyHueTime * 0.25) % 1
		local col = Color3.fromHSV(hue, 1, 1)
		btn.TextColor3 = col
		stroke.Color = col
	end)
end

local function stopBtnVisuals(btn, stroke, connVar, bg0, text0)
	if connVar then connVar:Disconnect() end
	btn.BackgroundColor3 = bg0
	btn.TextColor3 = text0
	btn.TextStrokeTransparency = 1
	stroke.Enabled = false
end

-- Tham số chuyển động
local ASCEND_SPEED = 450
local MAX_Y = 1000000
local STOP_BEFORE_GROUND = 5

-- State & loop
local isAscending, isDescending = false, false
local ascendConn, descendConn

local function stopAscending()
	if not isAscending then return end
	isAscending = false
	if ascendConn then ascendConn:Disconnect(); ascendConn = nil end
	stopBtnVisuals(up, upStroke, upRainbowConn, upBG0, upText0)
	upRainbowConn = nil
	-- Nếu FLY không bật, tắt noclip
	if not nowe then
		pcall(function() stopNoclip() end)
	end
end

local function stopDescending()
	if not isDescending then return end
	isDescending = false
	if descendConn then descendConn:Disconnect(); descendConn = nil end
	stopBtnVisuals(down, downStroke, downRainbowConn, downBG0, downText0)
	downRainbowConn = nil
	-- Nếu FLY không bật, tắt noclip
	if not nowe then
		pcall(function() stopNoclip() end)
	end
end

-- Cho nơi khác (respawn) gọi dừng nhanh
local function stopVertical()
	stopAscending()
	stopDescending()
end
_G.__FlyGui_StopVertical = stopVertical

-- Dò mặt đất bằng Raycast mạnh (bỏ qua character, bỏ part không đứng được)
local function groundY(hrp)
	local params = RaycastParams.new()
	params.FilterType = Enum.RaycastFilterType.Exclude
	params.FilterDescendantsInstances = { hrp.Parent }

	local function castFrom(pos)
		return workspace:Raycast(pos, Vector3.new(0, -12000, 0), params)
	end

	local result = castFrom(hrp.Position)
	if result then
		local inst = result.Instance
		if inst.CanCollide ~= false and (inst.Transparency or 0) < 0.5 then
			return result.Position.Y
		else
			-- nếu trúng vật thể không phù hợp, bắn tiếp từ dưới
			local from = result.Position - Vector3.new(0, 0.01, 0)
			local result2 = castFrom(from)
			return result2 and result2.Position.Y or nil
		end
	end
	return nil
end

-- NÚT UP: leo thẳng trục Y, 450 stud/s, không tự tắt khi tới MAX_Y (dừng ở MAX_Y)
up.MouseButton1Click:Connect(function()
	if isAscending then
		stopAscending()
		return
	end
	-- Chặn nút kia
	stopDescending()

	local chr = LocalPlayer.Character
	local hrp = chr and chr:FindFirstChild("HumanoidRootPart")
	if not hrp then return end

	-- Bật noclip nếu FLY chưa bật
	if not nowe then
		pcall(function() startNoclip() end)
	end

	isAscending = true
	upRainbowConn = startBtnVisuals(up, upStroke)

	ascendConn = RS.RenderStepped:Connect(function(dt)
		if not isAscending then return end
		local p = hrp.Position
		local newY = p.Y + ASCEND_SPEED * dt
		if newY >= MAX_Y then newY = MAX_Y end
		hrp:PivotTo(CFrame.new(p.X, newY, p.Z))
		-- muốn auto-tắt khi chạm MAX_Y: if newY >= MAX_Y then stopAscending() end
	end)
end)

-- NÚT DOWN: hạ thẳng, dừng cách đất 5 stud, 450 stud/s
down.MouseButton1Click:Connect(function()
	if isDescending then
		stopDescending()
		return
	end
	-- Chặn nút kia
	stopAscending()

	local chr = LocalPlayer.Character
	local hrp = chr and chr:FindFirstChild("HumanoidRootPart")
	if not hrp then return end

	-- Bật noclip nếu FLY chưa bật
	if not nowe then
		pcall(function() startNoclip() end)
	end

	isDescending = true
	downRainbowConn = startBtnVisuals(down, downStroke)

	descendConn = RS.RenderStepped:Connect(function(dt)
		if not isDescending then return end
		local p = hrp.Position
		local gy = groundY(hrp) or -1e9
		local stopY = gy + STOP_BEFORE_GROUND

		if p.Y <= stopY then
			stopDescending()
			return
		end

		local newY = p.Y - ASCEND_SPEED * dt
		if newY <= stopY then newY = stopY end
		hrp:PivotTo(CFrame.new(p.X, newY, p.Z))
	end)
end)
	
TextLabel.Parent = Frame
TextLabel.BackgroundColor3 = Color3.fromRGB(242, 60, 255)
TextLabel.Position = UDim2.new(0.469327301, 0, 0, 0)
TextLabel.Size = UDim2.new(0, 101, 0, 28)
TextLabel.Font = Enum.Font.SourceSans
TextLabel.Text = "︻デ═一"
TextLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
TextLabel.TextScaled = true
TextLabel.TextSize = 14.000
TextLabel.TextWrapped = true
	
plus.Name = "plus"
plus.Parent = Frame
plus.BackgroundColor3 = Color3.fromRGB(133, 145, 255)
plus.Position = UDim2.new(0.237, 0, 0, 0)
plus.Size = UDim2.new(0, 44, 0, 28)
plus.Font = Enum.Font.SourceSans
plus.Text = "+"
plus.TextColor3 = Color3.fromRGB(0, 0, 0)
plus.TextScaled = true
plus.TextSize = 14.000
plus.TextWrapped = true

speed.Name = "speed"
speed.Parent = Frame
speed.BackgroundColor3 = Color3.fromRGB(255, 85, 0)
speed.Position = UDim2.new(0.474, 0, 0.50500074, 0)
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
mine.Position = UDim2.new(0.237, 0, 0.50500074, 0)
mine.Size = UDim2.new(0, 44, 0, 28)
mine.Font = Enum.Font.SourceSans
mine.Text = "-"
mine.TextColor3 = Color3.fromRGB(0, 0, 0)
mine.TextScaled = true
mine.TextSize = 15.000
mine.TextWrapped = true

closebutton.Name = "Close"
closebutton.Parent = main.Frame
closebutton.BackgroundColor3 = Color3.fromRGB(225, 25, 0)
closebutton.Font = Enum.Font.SourceSans
closebutton.Size = UDim2.new(0, 44, 0, 28)
closebutton.Text = "X"
closebutton.TextSize = 30
closebutton.Position =  UDim2.new(0, 0, -0.99000, 27)

mini.Name = "minimize"
mini.Parent = main.Frame
mini.BackgroundColor3 = Color3.fromRGB(192, 150, 230)
mini.Font = Enum.Font.SourceSans
mini.Size = UDim2.new(0, 44, 0, 28)
mini.Text = "-"
mini.TextSize = 40
mini.Position = UDim2.new(0, 45, -0.99000, 27)

mini2.Name = "minimize2"
mini2.Parent = main.Frame
mini2.BackgroundColor3 = Color3.fromRGB(192, 150, 230)
mini2.Font = Enum.Font.SourceSans
mini2.Size = UDim2.new(0, 45, 0, 28)
mini2.Text = "+"
mini2.TextSize = 40
mini2.Position = UDim2.new(0, 44, -1, 57)
mini2.Visible = false

local lastClick = 0
local doubleClickWindow = 1

local originalTextColor = closebutton.TextColor3
closebutton.MouseButton1Click:Connect(function()
	local now = tick()
	if now - lastClick <= doubleClickWindow then
		main:Destroy()
	else
		lastClick = now
		closebutton.TextColor3 = Color3.fromRGB(255, 255, 255)

		task.delay(doubleClickWindow, function()
			if tick() - lastClick >= doubleClickWindow then
				closebutton.TextColor3 = originalTextColor
			end
		end)
	end
end)

mini.MouseButton1Click:Connect(function()
	up.Visible = false
	down.Visible = false
	onof.Visible = false
	plus.Visible = false
	speed.Visible = false
	mine.Visible = false
	mini.Visible = false
	mini2.Visible = true
	main.Frame.BackgroundTransparency = 1
	closebutton.Position =  UDim2.new(0, 0, -1, 57)
end)

mini2.MouseButton1Click:Connect(function()
	up.Visible = true
	down.Visible = true
	onof.Visible = true
	plus.Visible = true
	speed.Visible = true
	mine.Visible = true
	mini.Visible = true
	mini2.Visible = false
	main.Frame.BackgroundTransparency = 0 
	closebutton.Position =  UDim2.new(0, 0, -1, 27)
end)

speeds = 16

local speaker = LocalPlayer

local chr = LocalPlayer.Character
local hum = chr and chr:FindFirstChildWhichIsA("Humanoid")

nowe = false

local noclipConn = nil
local noclipCache = {}

local function cacheAndDisablePart(part)
	if not part or not part:IsA("BasePart") then return end
	if noclipCache[part] == nil then
		noclipCache[part] = part.CanCollide
	end
	part.CanCollide = false
end

local function startNoclip()
	if noclipConn then return end
	local char = LocalPlayer and LocalPlayer.Character
	if not char then return end

	for _, p in ipairs(char:GetDescendants()) do
		if p:IsA("BasePart") then cacheAndDisablePart(p) end
	end

	noclipConn = RS.Stepped:Connect(function()
		local c = LocalPlayer and LocalPlayer.Character
		if not c then return end
		for part, _ in pairs(noclipCache) do
			if part and part.Parent then part.CanCollide = false end
		end
		for _, p in ipairs(c:GetDescendants()) do
			if p:IsA("BasePart") and noclipCache[p] == nil then cacheAndDisablePart(p) end
		end
	end)
end

local function stopNoclip()
	if noclipConn then noclipConn:Disconnect(); noclipConn = nil end
	for part, prev in pairs(noclipCache) do
		if part and part.Parent then
			if prev == nil then part.CanCollide = true else part.CanCollide = prev end
		end
	end
	noclipCache = {}
end

local RESPECT_COREGUI = false
local TOP_MARGIN = 0

local function pointerPos(input)
	return (input.UserInputType == Enum.UserInputType.Touch)
		and Vector2.new(input.Position.X, input.Position.Y)
		or UIS:GetMouseLocation()
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

		local cam = WS.CurrentCamera
		if cam then
			local vp = cam.ViewportSize
			local topInset = GS:GetGuiInset().Y
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
	
	local cam = WS.CurrentCamera
	if cam then
		local vp = cam.ViewportSize
		local topInset = GS:GetGuiInset().Y
		local minY = (RESPECT_COREGUI and (topInset + TOP_MARGIN) or TOP_MARGIN)

		local x = math.clamp(abs.X, 0, math.max(0, vp.X - Frame.AbsoluteSize.X))
		local y = math.clamp(abs.Y, minY, math.max(minY, vp.Y - Frame.AbsoluteSize.Y))
		Frame.Position = UDim2.fromOffset(x, y)
	end
end)

local function hookViewportChanged()
	local cam = WS.CurrentCamera
	if not cam then return end
	cam:GetPropertyChangedSignal("ViewportSize"):Connect(function()
		if not dragging then
			local abs = Frame.AbsolutePosition
			local vp = cam.ViewportSize
			local topInset = GS:GetGuiInset().Y
			local minY = (RESPECT_COREGUI and (topInset + TOP_MARGIN) or TOP_MARGIN)

			local x = math.clamp(abs.X, 0, math.max(0, vp.X - Frame.AbsoluteSize.X))
			local y = math.clamp(abs.Y, minY, math.max(minY, vp.Y - Frame.AbsoluteSize.Y))
			Frame.Position = UDim2.fromOffset(x, y)
		end
	end)
end
	
if WS.CurrentCamera then hookViewportChanged() end
WS:GetPropertyChangedSignal("CurrentCamera"):Connect(hookViewportChanged)

onof.MouseButton1Down:connect(function()

	if nowe == true then
		nowe = false
	stopFlyVisuals()
				
		pcall(function() stopNoclip() end)

		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Flying,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.GettingUp,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Landed,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Physics,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Running,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.RunningNoPhysics,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.StrafingNoPhysics,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Swimming,true)
		speaker.Character.Humanoid:ChangeState(Enum.HumanoidStateType.RunningNoPhysics)
	else 
		nowe = true
				
		startFlyVisuals()
		for i = 1, speeds do
			spawn(function()
				local hb = RS.Heartbeat	
				tpwalking = true
				local chr = LocalPlayer.Character
				local hum = chr and chr:FindFirstChildWhichIsA("Humanoid")
				while tpwalking and hb:Wait() and chr and hum and hum.Parent do
					if hum.MoveDirection.Magnitude > 0 then
						chr:TranslateBy(hum.MoveDirection)
					end
				end
			end)
		end
		LocalPlayer.Character.Animate.Disabled = true
		local Char = LocalPlayer.Character
		local Hum = Char:FindFirstChildOfClass("Humanoid") or Char:FindFirstChildOfClass("AnimationController")

		for i,v in next, Hum:GetPlayingAnimationTracks() do
			v:AdjustSpeed(0)
		end
		
		pcall(function() startNoclip() end)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Flying,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.GettingUp,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Landed,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Physics,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Running,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.RunningNoPhysics,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.StrafingNoPhysics,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Swimming,false)
		speaker.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Swimming)
	end

	if LocalPlayer.Character:FindFirstChildOfClass("Humanoid").RigType == Enum.HumanoidRigType.R6 then

		local plr = LocalPlayer
		local torso = plr.Character.Torso
		local flying = true
		local deb = true
		local ctrl = {f = 0, b = 0, l = 0, r = 0}
		local lastctrl = {f = 0, b = 0, l = 0, r = 0}
		local maxspeed = 50
		local speed = 0

		local bg = Instance.new("BodyGyro", torso)
		bg.P = 9e4
		bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
		bg.cframe = torso.CFrame
		local bv = Instance.new("BodyVelocity", torso)
		bv.velocity = Vector3.new(0,0.1,0)
		bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
		if nowe == true then
			plr.Character.Humanoid.PlatformStand = true
		end
		while nowe == true or LocalPlayer.Character.Humanoid.Health == 0 do
			RS.RenderStepped:Wait()

			if ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0 then
				speed = speed+.5+(speed/maxspeed)
				if speed > maxspeed then
					speed = maxspeed
				end
			elseif not (ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0) and speed ~= 0 then
				speed = speed-1
				if speed < 0 then
					speed = 0
				end
			end
			if (ctrl.l + ctrl.r) ~= 0 or (ctrl.f + ctrl.b) ~= 0 then
				bv.velocity = ((WS.CurrentCamera.CoordinateFrame.lookVector * (ctrl.f+ctrl.b)) + ((WS.CurrentCamera.CoordinateFrame * CFrame.new(ctrl.l+ctrl.r,(ctrl.f+ctrl.b)*.2,0).p) - WS.CurrentCamera.CoordinateFrame.p))*speed
				lastctrl = {f = ctrl.f, b = ctrl.b, l = ctrl.l, r = ctrl.r}
			elseif (ctrl.l + ctrl.r) == 0 and (ctrl.f + ctrl.b) == 0 and speed ~= 0 then
				bv.velocity = ((WS.CurrentCamera.CoordinateFrame.lookVector * (lastctrl.f+lastctrl.b)) + ((WS.CurrentCamera.CoordinateFrame * CFrame.new(lastctrl.l+lastctrl.r,(lastctrl.f+lastctrl.b)*.2,0).p) - WS.CurrentCamera.CoordinateFrame.p))*speed
			else
				bv.velocity = Vector3.new(0,0,0)
			end

			bg.cframe = WS.CurrentCamera.CoordinateFrame * CFrame.Angles(-math.rad((ctrl.f+ctrl.b)*50*speed/maxspeed),0,0)
		end
		ctrl = {f = 0, b = 0, l = 0, r = 0}
		lastctrl = {f = 0, b = 0, l = 0, r = 0}
		speed = 0
		bg:Destroy()
		bv:Destroy()
		plr.Character.Humanoid.PlatformStand = false
		LocalPlayer.Character.Animate.Disabled = false
		tpwalking = false

	else
		local plr = LocalPlayer
		local UpperTorso = plr.Character.UpperTorso
		local flying = true
		local deb = true
		local ctrl = {f = 0, b = 0, l = 0, r = 0}
		local lastctrl = {f = 0, b = 0, l = 0, r = 0}
		local maxspeed = 50
		local speed = 0

		local bg = Instance.new("BodyGyro", UpperTorso)
		bg.P = 9e4
		bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
		bg.cframe = UpperTorso.CFrame
		local bv = Instance.new("BodyVelocity", UpperTorso)
		bv.velocity = Vector3.new(0,0.1,0)
		bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
		if nowe == true then
			plr.Character.Humanoid.PlatformStand = true
		end
		while nowe == true or LocalPlayer.Character.Humanoid.Health == 0 do
			wait()

			if ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0 then
				speed = speed+.5+(speed/maxspeed)
				if speed > maxspeed then
					speed = maxspeed
				end
			elseif not (ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0) and speed ~= 0 then
				speed = speed-1
				if speed < 0 then
					speed = 0
				end
			end
			if (ctrl.l + ctrl.r) ~= 0 or (ctrl.f + ctrl.b) ~= 0 then
				bv.velocity = ((WS.CurrentCamera.CoordinateFrame.lookVector * (ctrl.f+ctrl.b)) + ((WS.CurrentCamera.CoordinateFrame * CFrame.new(ctrl.l+ctrl.r,(ctrl.f+ctrl.b)*.2,0).p) - WS.CurrentCamera.CoordinateFrame.p))*speed
				lastctrl = {f = ctrl.f, b = ctrl.b, l = ctrl.l, r = ctrl.r}
			elseif (ctrl.l + ctrl.r) == 0 and (ctrl.f + ctrl.b) == 0 and speed ~= 0 then
				bv.velocity = ((WS.CurrentCamera.CoordinateFrame.lookVector * (lastctrl.f+lastctrl.b)) + ((WS.CurrentCamera.CoordinateFrame * CFrame.new(lastctrl.l+lastctrl.r,(lastctrl.f+lastctrl.b)*.2,0).p) - WS.CurrentCamera.CoordinateFrame.p))*speed
			else
				bv.velocity = Vector3.new(0,0,0)
			end

			bg.cframe = WS.CurrentCamera.CoordinateFrame * CFrame.Angles(-math.rad((ctrl.f+ctrl.b)*50*speed/maxspeed),0,0)
		end
		ctrl = {f = 0, b = 0, l = 0, r = 0}
		lastctrl = {f = 0, b = 0, l = 0, r = 0}
		speed = 0
		bg:Destroy()
		bv:Destroy()
		plr.Character.Humanoid.PlatformStand = false
		LocalPlayer.Character.Animate.Disabled = false
		tpwalking = false
	end
end)

--=== CharacterAdded: reset đầy đủ khi respawn ===
Players.LocalPlayer.CharacterAdded:Connect(function(char)
	-- Tắt mọi chuyển động dọc và visuals UP/DOWN
	if _G.__FlyGui_StopVertical then
		_G.__FlyGui_StopVertical()
	end

	-- Cho nhân vật/map kịp khởi tạo
	wait(0.7)

	-- Dừng noclip (dù bật từ FLY hay UP/DOWN), an toàn khi respawn
	pcall(function() stopNoclip() end)

	-- Phục hồi Humanoid/Animation
	local c = LocalPlayer.Character
	if c and c:FindFirstChildOfClass("Humanoid") then
		c.Humanoid.PlatformStand = false
	end
	if c and c:FindFirstChild("Animate") then
		c.Animate.Disabled = false
	end

	-- Tắt luôn visuals của FLY (nút onof)
	stopFlyVisuals()
end)

plus.MouseButton1Down:connect(function()
	speeds = speeds + 1
	speed.Text = speeds
	if nowe == true then

		tpwalking = false
		for i = 1, speeds do
			spawn(function()
				local hb = RS.Heartbeat	
				tpwalking = true
				local chr = LocalPlayer.Character
				local hum = chr and chr:FindFirstChildWhichIsA("Humanoid")
				while tpwalking and hb:Wait() and chr and hum and hum.Parent do
					if hum.MoveDirection.Magnitude > 0 then
						chr:TranslateBy(hum.MoveDirection)
					end
				end
			end)
		end
	end
end)
	
mine.MouseButton1Down:connect(function()
	if speeds == 1 then
		speed.Text = 'cannot be less than 1'
		wait(1)
		speed.Text = speeds
	else
		speeds = speeds - 1
		speed.Text = speeds
		if nowe == true then
			tpwalking = false
			for i = 1, speeds do
				spawn(function()
					local hb = RS.Heartbeat	
					tpwalking = true
					local chr = LocalPlayer.Character
					local hum = chr and chr:FindFirstChildWhichIsA("Humanoid")
					while tpwalking and hb:Wait() and chr and hum and hum.Parent do
						if hum.MoveDirection.Magnitude > 0 then
							chr:TranslateBy(hum.MoveDirection)
						end
					end
				end)
			end
		end
	end
end)
end
