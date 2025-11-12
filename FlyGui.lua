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
autoBg.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
autoBg.Position = UDim2.new(0, 0, 0.50500074, 0)
autoBg.Size = UDim2.new(0, 44, 0, 28)
autoBg.BorderSizePixel = 0

aeToggle.Name = "AutoEscapeToggle"
aeToggle.Parent = autoBg
aeToggle.Size = UDim2.new(0, 38, 0, 16)
aeToggle.Position = UDim2.new(0.5, -19, 0.5, -8)
aeToggle.BackgroundColor3 = Color3.fromRGB(88, 200, 120)
aeToggle.AutoButtonColor = false
aeToggle.Text = ""
aeToggle.BorderSizePixel = 0

local aeCorner = Instance.new("UICorner")
aeCorner.CornerRadius = UDim.new(1, 0)
aeCorner.Parent = aeToggle

local knob = Instance.new("Frame")
knob.Name = "Knob"
knob.Parent = aeToggle
knob.Size = UDim2.new(0, 12, 0, 12)
knob.Position = UDim2.new(0, 2, 0.5, -6)
knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
knob.BorderSizePixel = 0

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
local ascendConn

local function stopAscending()
	if not isAscending then return end
	isAscending = false
	if ascendConn then ascendConn:Disconnect(); ascendConn = nil end
	stopUpTextVisual()
	if not nowe then
		local chr = LocalPlayer.Character
		local hum = chr and chr:FindFirstChildOfClass("Humanoid")
		if hum then hum.PlatformStand = false end
		pcall(function() stopNoclip() end)
	end
end
_G.__FlyGui_StopVertical = function()
	stopAscending()
end

up.MouseButton1Click:Connect(function()
	if isAscending then
	stopAscending()
	return
end

	local chr = LocalPlayer.Character
	local hrp = chr and chr:FindFirstChild("HumanoidRootPart")
	local hum = chr and chr:FindFirstChildOfClass("Humanoid")
	if not hrp or not hum then return end
	if not nowe then
		pcall(function() startNoclip() end)
	end
	hum.PlatformStand = true
	hrp.AssemblyLinearVelocity = Vector3.new(0,0,0)
	startUpTextVisual()

	local startPos = hrp.Position
	local targetPos = Vector3.new(startPos.X, TARGET_Y, startPos.Z)
	local distance = TARGET_Y - startPos.Y
	if distance <= 0 then
		stopAscending()
		return
	end
	local travelTime = distance / ASCEND_SPEED
	local elapsed = 0

	isAscending = true
	ascendConn = RS.RenderStepped:Connect(function(dt)
		if not isAscending then return end
		elapsed += dt
		hrp.AssemblyLinearVelocity = Vector3.new(0,0,0)

		local alpha = math.clamp(elapsed / travelTime, 0, 1)
		local newPos = startPos:Lerp(targetPos, alpha)
		hrp:PivotTo(CFrame.new(newPos))

		if alpha >= 1 then
			stopAscending()
		end
	end)
end)

local flySpeed = 16

local speaker = LocalPlayer
local nowe = false
local noclipConn = nil
local noclipCache = {}

--===== AUTO ESCAPE CONFIG =====
local AE_LOW_HP  = 0.40
local AE_SAFE_HP = 0.90
local AE_TARGET_Y = 1000000
local AE_SPEED   = 450

local aeEnabled = true
local aeIsOn    = true 
local aeFlying  = false
local aeConn    = nil
local aeHum     = nil
local aeRoot    = nil

local function ae_stopFlight()
    if aeConn then
        aeConn:Disconnect()
        aeConn = nil
    end
    aeFlying = false
end

local aeHealthConn

local function ae_onHealthChanged(h)
    if not aeHum or not aeEnabled then return end
    local mh = aeHum.MaxHealth
    if mh <= 0 then return end

    local p = h / mh

    if (not aeFlying) and p < AE_LOW_HP then
        aeRoot = aeRoot or (aeHum.Parent and aeHum.Parent:FindFirstChild("HumanoidRootPart"))
        if aeRoot then
            ae_startFlight()
        end
    elseif aeFlying and p >= AE_SAFE_HP then
        ae_stopFlight()
    end
end

local function ae_bindCharacter(char)
    aeHum = char:FindFirstChildOfClass("Humanoid")
    aeRoot = char:FindFirstChild("HumanoidRootPart")

    if aeHealthConn then
        aeHealthConn:Disconnect()
        aeHealthConn = nil
    end

    if aeHum and aeEnabled then
        aeHealthConn = aeHum.HealthChanged:Connect(ae_onHealthChanged)
        ae_onHealthChanged(aeHum.Health)
    end
end

-- bind khi mới join / respawn
if LocalPlayer.Character then
    ae_bindCharacter(LocalPlayer.Character)
end

LocalPlayer.CharacterAdded:Connect(function(char)
    ae_stopFlight()
    ae_bindCharacter(char)
end)

local aeOnColor  = Color3.fromRGB(88, 200, 120)
local aeOffColor = Color3.fromRGB(220, 50, 50)

local function ae_setToggle(state)
    aeIsOn = state
    aeEnabled = state

    if aeToggle then
        aeToggle.BackgroundColor3 = state and aeOnColor or aeOffColor
    end

    if knob then
        if state then
            knob.Position = UDim2.new(0, 2, 0.5, -6)      -- nút lệch trái (ON)
        else
            knob.Position = UDim2.new(1, -14, 0.5, -6)    -- nút lệch phải (OFF)
        end
    end

    if not state then
        ae_stopFlight()
        if aeHealthConn then
            aeHealthConn:Disconnect()
            aeHealthConn = nil
        end
    else
        if LocalPlayer.Character then
            ae_bindCharacter(LocalPlayer.Character)
        end
    end
end

-- mặc định bật
ae_setToggle(true)

if aeToggle then
    aeToggle.MouseButton1Click:Connect(function()
        ae_setToggle(not aeIsOn)
    end)
end


local function ae_startFlight()
    if not aeEnabled or aeFlying or not aeRoot then return end

    local yNow = aeRoot.Position.Y
    if yNow >= AE_TARGET_Y - 1 then return end

    local startPos = aeRoot.Position
    local targetPos = Vector3.new(startPos.X, AE_TARGET_Y, startPos.Z)
    local distance = AE_TARGET_Y - startPos.Y
    if distance <= 0 then return end

    local travelTime = distance / AE_SPEED
    local elapsed = 0

    aeFlying = true

    aeConn = RS.RenderStepped:Connect(function(dt)
        if not aeFlying or not aeRoot or not aeRoot.Parent then
            ae_stopFlight()
            return
        end

        elapsed += dt
        local alpha = math.clamp(elapsed / travelTime, 0, 1)
        local newPos = startPos:Lerp(targetPos, alpha)
        aeRoot:PivotTo(CFrame.new(newPos))

        if alpha >= 1 then
            ae_stopFlight()
        end
    end)
end

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

local tpwalking = false
local tpGen = 0
onof.MouseButton1Down:Connect(function()

	if nowe == true then
		nowe = false
	stopFlyVisuals()
      tpwalking = false
       tpGen += 1
				
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
          tpGen += 1
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
    local ctrl = {f = 0, b = 0, l = 0, r = 0}
    local lastctrl = {f = 0, b = 0, l = 0, r = 0}
    local maxspeed = flySpeed
    local speed = 0

    local bg = Instance.new("BodyGyro", torso)
    bg.P = 9e4
    bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    bg.CFrame = torso.CFrame

    local bv = Instance.new("BodyVelocity", torso)
    bv.Velocity = Vector3.new(0, 0.1, 0)
    bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)

    if nowe == true then
        plr.Character.Humanoid.PlatformStand = true
    end

    while nowe == true do
        RS.RenderStepped:Wait()

        local cam = WS.CurrentCamera
        if not cam then
            bv.Velocity = Vector3.new(0,0,0)
            bg.CFrame = torso.CFrame
        else
            local camCF = cam.CFrame

            if ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0 then
                speed = speed + 0.5 + (speed / maxspeed)
                if speed > maxspeed then speed = maxspeed end
            elseif speed ~= 0 then
                speed -= 1
                if speed < 0 then speed = 0 end
            end

            if (ctrl.l + ctrl.r) ~= 0 or (ctrl.f + ctrl.b) ~= 0 then
                bv.Velocity =
                    (camCF.LookVector * (ctrl.f + ctrl.b))
                    + ((camCF * CFrame.new(ctrl.l + ctrl.r, (ctrl.f + ctrl.b) * .2, 0)).Position - camCF.Position)
                bv.Velocity *= speed
                lastctrl = {f = ctrl.f, b = ctrl.b, l = ctrl.l, r = ctrl.r}
            elseif speed ~= 0 then
                bv.Velocity =
                    (camCF.LookVector * (lastctrl.f + lastctrl.b))
                    + ((camCF * CFrame.new(lastctrl.l + lastctrl.r, (lastctrl.f + lastctrl.b) * .2, 0)).Position - camCF.Position)
                bv.Velocity *= speed
            else
                bv.Velocity = Vector3.new(0, 0, 0)
            end

            bg.CFrame = camCF * CFrame.Angles(-math.rad((ctrl.f + ctrl.b) * 50 * speed / maxspeed), 0, 0)
        end
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
		
else
    local plr = LocalPlayer
    local char = plr.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local root = char and char:FindFirstChild("UpperTorso")

    if hum and root then
        local ctrl = {f = 0, b = 0, l = 0, r = 0}
        local lastctrl = {f = 0, b = 0, l = 0, r = 0}
        local maxspeed = flySpeed
        local speed = 0

        local bg = Instance.new("BodyGyro", root)
        bg.P = 9e4
        bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
        bg.CFrame = root.CFrame
			
        local bv = Instance.new("BodyVelocity", root)
        bv.Velocity = Vector3.new(0, 0.1, 0)
        bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)

        if nowe == true then
            hum.PlatformStand = true
        end

        while nowe == true do
            RS.RenderStepped:Wait()

            local cam = WS.CurrentCamera
            if not cam then
                bv.Velocity = Vector3.new(0,0,0)
                bg.CFrame = root.CFrame
            else
                local camCF = cam.CFrame
                if ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0 then
                    speed = speed + 0.5 + (speed / maxspeed)
                    if speed > maxspeed then speed = maxspeed end
                elseif speed ~= 0 then
                    speed -= 1
                    if speed < 0 then speed = 0 end
                end
					
                if (ctrl.l + ctrl.r) ~= 0 or (ctrl.f + ctrl.b) ~= 0 then
                    bv.Velocity =
                        (camCF.LookVector * (ctrl.f + ctrl.b))
                        + ((camCF * CFrame.new(ctrl.l + ctrl.r,
                            (ctrl.f + ctrl.b)*0.2, 0)).Position - camCF.Position)
                    bv.Velocity *= speed

                    lastctrl = {f = ctrl.f, b = ctrl.b, l = ctrl.l, r = ctrl.r}
                elseif speed ~= 0 then
                    bv.Velocity =
                        (camCF.LookVector * (lastctrl.f + lastctrl.b))
                        + ((camCF * CFrame.new(lastctrl.l + lastctrl.r,
                            (lastctrl.f + lastctrl.b)*0.2, 0)).Position - camCF.Position)
                    bv.Velocity *= speed
                else
                    bv.Velocity = Vector3.new(0,0,0)
                end
                bg.CFrame = camCF * CFrame.Angles(
                    -math.rad((ctrl.f+ctrl.b)*50*speed/maxspeed),
                    0,
                    0
                )
            end
        end

        ctrl = {f = 0, b = 0, l = 0, r = 0}
        lastctrl = {f = 0, b = 0, l = 0, r = 0}
        speed = 0
        bg:Destroy()
        bv:Destroy()
        hum.PlatformStand = false
        char.Animate.Disabled = false
        tpwalking = false
    end
end
end)

Players.LocalPlayer.CharacterAdded:Connect(function(char)
	if _G.__FlyGui_StopVertical then
		_G.__FlyGui_StopVertical()
	end
	task.wait(0.7)
	pcall(function() stopNoclip() end)
	local c = LocalPlayer.Character
if c and c:FindFirstChildOfClass("Humanoid") then
	c.Humanoid.PlatformStand = false
end
if c and c:FindFirstChild("Animate") then
	c.Animate.Disabled = false
end
stopUpTextVisual()
stopFlyVisuals()
end)

plus.MouseButton1Down:Connect(function()
    if flySpeed >= 50 then
    speed.Text = "Max speed reached"
    task.wait(1)
    speed.Text = flySpeed
    return
end
	flySpeed += 1
    speed.Text = flySpeed
    if not nowe then return end
    tpwalking = false
    tpGen += 1
    tpwalking = true
    local gen = tpGen
    for i = 1, flySpeed do
        task.spawn(function()
            local myGen = gen
            local hb = RS.Heartbeat
            local chr = LocalPlayer.Character
            local hum = chr and chr:FindFirstChildWhichIsA("Humanoid")
            while tpwalking and (myGen == tpGen)
            and hb:Wait() and chr and hum and hum.Parent do
                if hum.MoveDirection.Magnitude > 0 then
                    chr:TranslateBy(hum.MoveDirection)
                end
            end
        end)
    end
end)
	
mine.MouseButton1Down:Connect(function()
	if flySpeed == 1 then
		speed.Text = 'cannot be less than 1'
		task.wait(1)
		speed.Text = flySpeed
		return
	end
	flySpeed -= 1
	speed.Text = flySpeed
	if not nowe then return end
	tpwalking = false
	tpGen += 1
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
