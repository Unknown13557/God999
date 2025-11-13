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
local autoBg = Instance.new("Frame")
local aeToggle = Instance.new("TextButton")
local onof = Instance.new("TextButton")
local TextLabel = Instance.new("TextLabel")
local plus = Instance.new("TextButton")
local speed = Instance.new("TextLabel")
local mine = Instance.new("TextButton")
local closebutton = Instance.new("TextButton")
local mini = Instance.new("TextButton")
local mini2 = Instance.new("TextButton")

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
up.TextSize = 17

autoBg.Name = "AutoEscapeBG"
autoBg.Parent = Frame
autoBg.BackgroundColor3 = Color3.fromRGB(215, 255, 121)
autoBg.Position = UDim2.new(0, 0, 0.50500074, 0)
autoBg.Size = UDim2.new(0, 44, 0, 28)
autoBg.BorderSizePixel = 1
autoBg.BorderColor3 = Color3.fromRGB(0, 0, 0)

aeToggle.Name = "AutoEscapeToggle"
aeToggle.Parent = autoBg
aeToggle.Size = UDim2.new(0, 38, 0, 16)
aeToggle.Position = UDim2.new(0.5, -19, 0.5, -8)
aeToggle.BackgroundColor3 = Color3.fromRGB(88, 200, 120)
aeToggle.AutoButtonColor = false
aeToggle.Text = ""

local aeStroke = Instance.new("UIStroke")
aeStroke.Parent = aeToggle
aeStroke.Color = Color3.fromRGB(0,0,0)
aeStroke.Thickness = 0
aeStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

local aeCorner = Instance.new("UICorner")
aeCorner.CornerRadius = UDim.new(1, 0)
aeCorner.Parent = aeToggle

local knob = Instance.new("Frame")
knob.Name = "Knob"
knob.Parent = aeToggle
knob.Size = UDim2.new(0, 12, 0, 12)
knob.Position = UDim2.new(0, 2, 0.5, -6)
knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
knob.BorderSizePixel = 1
knob.BorderColor3 = Color3.fromRGB(0, 0, 0)

local knobCorner = Instance.new("UICorner")
knobCorner.CornerRadius = UDim.new(1, 0)
knobCorner.Parent = knob

onof.Name = "onof"
onof.Parent = Frame
onof.BackgroundColor3 = Color3.fromRGB(255, 249, 74)
onof.Position = UDim2.new(0.701, 0, 0.50500074, 0)
onof.Size = UDim2.new(0, 57, 0, 28)
onof.Font = Enum.Font.SourceSans
onof.Text = "FLY"
onof.TextColor3 = Color3.fromRGB(0, 0, 0)
onof.BorderSizePixel = 1
onof.TextSize = 20
onof.ZIndex = 50

TextLabel.Parent = Frame
TextLabel.BackgroundColor3 = Color3.fromRGB(242, 60, 255)
TextLabel.Position = UDim2.new(0.469327301, 0, 0, 0)
TextLabel.Size = UDim2.new(0, 101, 0, 28)
TextLabel.Font = Enum.Font.SourceSans
TextLabel.Text = "︻デ═一"
TextLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
TextLabel.TextScaled = true
TextLabel.TextSize = 14
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
plus.TextSize = 17
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
speed.TextSize = 14
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
mine.TextSize = 17
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
	autoBg.Visible = false
    aeToggle.Visible = false
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
	autoBg.Visible = true
    aeToggle.Visible = true
	onof.Visible = true
	plus.Visible = true
	speed.Visible = true
	mine.Visible = true
	mini.Visible = true
	mini2.Visible = false
	main.Frame.BackgroundTransparency = 0 
	closebutton.Position =  UDim2.new(0, 0, -1, 27)
end)

local magiskk = {}
local flySpeed = 16
local speaker = LocalPlayer
local nowe = false
local noclipConn = nil
local noclipCache = {}
local flyActive = false

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

local onofDefaultTextColor = onof.TextColor3
local onofDefaultBG        = onof.BackgroundColor3
local onofDefaultText      = onof.Text

local flyRainbowConn
local flyHueTime = 0
local function startFlyVisuals()
	onof.BackgroundColor3 = Color3.fromRGB(50,50,50)
	onof.TextStrokeTransparency = 1
	if flyRainbowConn then flyRainbowConn:Disconnect() end
	flyRainbowConn = RS.RenderStepped:Connect(function(dt)
		flyHueTime += dt
		local hue = (flyHueTime * 0.25) % 1
		onof.TextColor3 = Color3.fromHSV(hue, 1, 1)
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
end

local TweenService = game:GetService("TweenService")

local AE_SPEED    = 450
local AE_TARGET_Y = 100000
local AE_LOW_HP   = 0.40
local AE_SAFE_HP  = 0.90

local AE_Enabled    = true
local AE_Flying     = false
local AE_Tween      = nil
local AE_Humanoid   = nil
local AE_RootPart   = nil
local AE_HealthConn = nil

local AE_NoclipOwned = false
local function AE_Stop()
	if AE_Tween then
		AE_Tween:Cancel()
		AE_Tween = nil
	end

	AE_Flying = false
	
	if AE_NoclipOwned and not nowe then
		AE_NoclipOwned = false
		pcall(function() stopNoclip() end)
	end
end

local function AE_Start()
	if not AE_Enabled or AE_Flying or not AE_RootPart then return end
	if not nowe and not AE_NoclipOwned then
		AE_NoclipOwned = true
		pcall(function() startNoclip() end)
	end

	local yNow = AE_RootPart.Position.Y
	local dist = AE_TARGET_Y - yNow
	if dist <= 1 then return end

	AE_Flying = true
	local duration = dist / AE_SPEED
	local cf = AE_RootPart.CFrame

	AE_Tween = TweenService:Create(
		AE_RootPart,
		TweenInfo.new(duration, Enum.EasingStyle.Linear),
		{CFrame = CFrame.new(cf.X, AE_TARGET_Y, cf.Z)}
	)

	AE_Tween.Completed:Connect(AE_Stop)
	AE_Tween:Play()
end

local function AE_Health(hp)
	if not AE_Humanoid or not AE_Enabled then return end

	local max = AE_Humanoid.MaxHealth
	if max <= 0 then return end

	local r = hp / max

	if (not AE_Flying) and r < AE_LOW_HP then
		AE_Start()
	elseif AE_Flying and r >= AE_SAFE_HP then
		AE_Stop()
	end
end

local function AE_Bind(char)
	AE_Humanoid = char:WaitForChild("Humanoid")
	AE_RootPart = char:WaitForChild("HumanoidRootPart")

	if AE_HealthConn then
		AE_HealthConn:Disconnect()
	end

	if AE_Enabled then
		AE_HealthConn = AE_Humanoid.HealthChanged:Connect(AE_Health)
		AE_Health(AE_Humanoid.Health)
	end
end

local function AE_UI(state)
	if not aeToggle or not knob then return end

	aeToggle.BackgroundColor3 = state
		and Color3.fromRGB(88,200,120)
		or  Color3.fromRGB(200,80,80)

	knob.Position = state
		and UDim2.new(0,2, 0.5,-6)
		or  UDim2.new(1,-14,0.5,-6)
end

local function AE_Set(state)
	AE_Enabled = state
	AE_UI(state)

	if not state then
		AE_Stop()
		if AE_HealthConn then
			AE_HealthConn:Disconnect()
			AE_HealthConn = nil
		end
	else
		local char = LocalPlayer.Character
		if char and char:FindFirstChild("Humanoid") then
			AE_Bind(char)
		end
	end
end

if LocalPlayer.Character then
	task.defer(function() AE_Bind(LocalPlayer.Character) end)
end

if aeToggle then
	aeToggle.MouseButton1Click:Connect(function()
		AE_Set(not AE_Enabled)
	end)
end

task.defer(function()
	AE_Set(true)
end)

local upBG0, upText0 = up.BackgroundColor3, up.TextColor3
local upRainbowConn
local upHueTime = 0
local function startUpTextVisual()
    up.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    up.TextStrokeTransparency = 1
    local s = up:FindFirstChild("FlyStroke")
    if s then s.Enabled = false end

    if upRainbowConn then upRainbowConn:Disconnect() end
    upRainbowConn = RS.RenderStepped:Connect(function(dt)
        upHueTime += dt
        local hue = (upHueTime * 0.25) % 1
        up.TextColor3 = Color3.fromHSV(hue, 1, 1)
    end)
end

local function stopUpTextVisual()
    if upRainbowConn then upRainbowConn:Disconnect(); upRainbowConn = nil end
    up.BackgroundColor3 = upBG0
    up.TextColor3       = upText0
    up.TextStrokeTransparency = 1
    local s = up:FindFirstChild("FlyStroke")
    if s then s.Enabled = false end
end

local ASCEND_SPEED = 450
local TARGET_Y = 100000000
local isAscending = false
local ascendTween

local function stopAscending()
	if not isAscending then return end
	isAscending = false

	if ascendTween then
		ascendTween:Cancel()
		ascendTween = nil
	end

	stopUpTextVisual()

	if not nowe then
		pcall(function() stopNoclip() end)
	end
end

function magiskk.StopVertical()
    stopAscending()
end

up.MouseButton1Click:Connect(function()
	if isAscending then
		stopAscending()
		return
	end

	local char = LocalPlayer.Character
	local hrp = char and char:FindFirstChild("HumanoidRootPart")
	if not hrp then return end
	if not nowe then
		pcall(function() startNoclip() end)
	end

	hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
	startUpTextVisual()

	local startPos = hrp.Position
	local dist = TARGET_Y - startPos.Y
	if dist <= 0 then
		stopAscending()
		return
	end

	local duration = dist / ASCEND_SPEED
	isAscending = true

	ascendTween = TweenService:Create(
		hrp,
		TweenInfo.new(duration, Enum.EasingStyle.Linear),
		{CFrame = CFrame.new(startPos.X, TARGET_Y, startPos.Z)}
	)

	ascendTween.Completed:Connect(function()
		ascendTween = nil
		if isAscending then
			stopAscending()
		end
	end)

	ascendTween:Play()
end)		

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




local tpwalking = false
local tpGen = 0
onof.MouseButton1Down:Connect(function()

	if nowe == true then
		nowe = false
	stopFlyVisuals()
	  tpwalking = false
        tpGen = tpGen + 1
				
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
tpGen = tpGen + 1
tpwalking = true
local gen = tpGen
for i = 1, flySpeed do
	task.spawn(function()
		local myGen = gen
		local hb = RS.Heartbeat	
		local chr = LocalPlayer.Character
		local hum = chr and chr:FindFirstChildWhichIsA("Humanoid")
		while tpwalking and (myGen == tpGen) and hb:Wait() and chr and hum and hum.Parent do
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
			task.wait()

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


plus.MouseButton1Down:Connect(function()
	if flySpeed >= 50 then
		speed.Text = "Max speed reached"
		task.wait(1)
		speed.Text = flySpeed
		return
	end

	flySpeed = flySpeed + 1
	speed.Text = flySpeed

	if not nowe then return end

	tpwalking = false
	tpGen = tpGen + 1
	tpwalking = true
	local gen = tpGen

	for i = 1, flySpeed do
		task.spawn(function()
			local myGen = gen
			local hb = RS.Heartbeat
			local chr = LocalPlayer.Character
			local hum = chr and chr:FindFirstChildWhichIsA("Humanoid")
			while tpwalking and (myGen == tpGen) and hb:Wait() and chr and hum and hum.Parent do
				if hum.MoveDirection.Magnitude > 0 then
					chr:TranslateBy(hum.MoveDirection)
				end
			end
		end)
	end
end)

mine.MouseButton1Down:Connect(function()
	if flySpeed == 1 then
		speed.Text = "cant be less than 1"
		task.wait(1)
		speed.Text = flySpeed
		return
	end

	flySpeed = flySpeed - 1
	speed.Text = flySpeed

	if not nowe then return end

	tpwalking = false
	tpGen = tpGen + 1
	tpwalking = true
	local gen = tpGen

	for i = 1, flySpeed do
		task.spawn(function()
			local myGen = gen
			local hb = RS.Heartbeat
			local chr = LocalPlayer.Character
			local hum = chr and chr:FindFirstChildWhichIsA("Humanoid")
			while tpwalking and (myGen == tpGen) and hb:Wait() and chr and hum and hum.Parent do
				if hum.MoveDirection.Magnitude > 0 then
					chr:TranslateBy(hum.MoveDirection)
				end
			end
		end)
	end
end)

Players.LocalPlayer.CharacterAdded:Connect(function(char)
    if magiskk.StopVertical then
        pcall(function()
            magiskk.StopVertical()
        end)
    end

    pcall(function()
        AE_Stop()
    end)

    pcall(function()
        stopNoclip()
    end)

    nowe = false
    flyActive = false
    tpwalking = false
    isAscending = false
    AE_Flying = false
    stopFlyVisuals()
    stopUpTextVisual()
    task.wait(0.15)
	local hum = char:FindFirstChildOfClass("Humanoid")
	if hum then
		hum.PlatformStand = false
		hum.AutoRotate = true
	end

	local anim = char:FindFirstChild("Animate")
	if anim then
		anim.Disabled = false
	end

	if AE_Enabled then
		AE_Bind(char)
	end
end)
