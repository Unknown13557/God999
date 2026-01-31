local UserInputService = game:GetService("UserInputService")
local Players          = game:GetService("Players")
local RunService       = game:GetService("RunService")
local Workspace        = game:GetService("Workspace")
local TweenService     = game:GetService("TweenService")


local LocalPlayer      = Players.LocalPlayer
local RS               = RunService
local WS               = Workspace
local UIS              = UserInputService

local Settings = {
	BypassUp = false
}

local main = Instance.new("ScreenGui")
if syn and syn.protect_gui then
	syn.protect_gui(main)
end
main.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
main.DisplayOrder = 198282823
main.Name = "main"
main.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
main.IgnoreGuiInset = true
local Frame           = Instance.new("Frame")
local up              = Instance.new("TextButton")
local escape          = Instance.new("Frame")
local toggle          = Instance.new("TextButton")
local onof            = Instance.new("TextButton")
local TextLabel       = Instance.new("TextLabel")
local plus            = Instance.new("TextButton")
local speed           = Instance.new("TextLabel")
local mine            = Instance.new("TextButton")
local closebutton     = Instance.new("TextButton")
local SettingsButton = Instance.new("TextButton")

local SettingsGui = Instance.new("ScreenGui")
SettingsGui.Name = "SettingsGui"
SettingsGui.Parent = LocalPlayer.PlayerGui
SettingsGui.IgnoreGuiInset = true
SettingsGui.DisplayOrder = main.DisplayOrder + 1
SettingsGui.Enabled = false
SettingsGui.ResetOnSpawn = false

local SettingsFrame = Instance.new("Frame")
SettingsFrame.Parent = SettingsGui
SettingsFrame.Size = UDim2.fromScale(0.46, 0.31)
SettingsFrame.AnchorPoint = Vector2.new(0.5, 0.5)
SettingsFrame.BackgroundColor3 = Color3.fromRGB(30,30,30)
SettingsFrame.BorderSizePixel = 2
SettingsFrame.Active = true

task.defer(function()
	local cam = WS.CurrentCamera
	if cam then
		local vp = cam.ViewportSize
		SettingsFrame.Position = UDim2.fromOffset(vp.X * 0.5, vp.Y * 0.5)
	end
end)

local SettingsGrid = Instance.new("UIGridLayout")
SettingsGrid.Parent = SettingsFrame
SettingsGrid.CellSize = UDim2.fromScale(0.48, 0.27)
SettingsGrid.CellPadding = UDim2.fromOffset(4, 6)
SettingsGrid.HorizontalAlignment = Enum.HorizontalAlignment.Center
SettingsGrid.VerticalAlignment = Enum.VerticalAlignment.Center

local Slots = {}

for i = 1, 6 do
	-- slot frame
	local slot = Instance.new("Frame")
	slot.Name = "Slot"..i
	slot.Parent = SettingsFrame
	slot.BackgroundColor3 = Color3.fromRGB(60,60,60)
	slot.BorderSizePixel = 0
	slot.ZIndex = 10

	-- label
	local label = Instance.new("TextLabel")
	label.Name = "Label"
	label.Parent = slot
	label.Size = UDim2.fromScale(0.65, 1)
	label.Position = UDim2.fromScale(0, 0)
	label.BackgroundTransparency = 1
	label.Text = "Empty"
	label.TextColor3 = Color3.fromRGB(220,220,220)
	label.Font = Enum.Font.SourceSansBold
	label.TextSize = 18
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.TextYAlignment = Enum.TextYAlignment.Center
	label.ZIndex = 11

	-- pill toggle
	local pill = Instance.new("TextButton")
	pill.Name = "Pill"
	pill.Parent = slot
	pill.Text = ""
	pill.AutoButtonColor = false
	pill.Size = UDim2.fromOffset(36, 18)
	pill.Position = UDim2.fromScale(1, 0.5)
	pill.AnchorPoint = Vector2.new(1, 0.5)
	pill.BackgroundColor3 = Color3.fromRGB(80,80,80)
	pill.BorderSizePixel = 0
	pill.ZIndex = 11

	local pillCorner = Instance.new("UICorner")
	pillCorner.CornerRadius = UDim.new(1,0)
	pillCorner.Parent = pill

	-- slot knob (SETTING ONLY)
	local slotKnob = Instance.new("Frame")
	slotKnob.Name = "SlotKnob"
	slotKnob.Parent = pill
	slotKnob.Size = UDim2.fromOffset(14,14)
	slotKnob.Position = UDim2.fromOffset(2,2)
	slotKnob.BackgroundColor3 = Color3.fromRGB(220,220,220)
	slotKnob.BorderSizePixel = 0
	slotKnob.ZIndex = 12
	slotKnob.Active = false

	local knobCorner = Instance.new("UICorner")
	knobCorner.CornerRadius = UDim.new(1,0)
	knobCorner.Parent = slotKnob

	Slots[i] = {
		Frame = slot,
		Label = label,
		Pill = pill,
		SlotKnob = slotKnob,
		State = false
	}
end

local slot1 = Slots[1]
slot1.Label.Text = "Bypass UP"

slot1.Pill.MouseButton1Click:Connect(function()
	slot1.State = not slot1.State
	Settings.BypassUp = slot1.State

	if slot1.State then
		slot1.Pill.BackgroundColor3 = Color3.fromRGB(120,200,120)
		slot1.SlotKnob:TweenPosition(
			UDim2.fromOffset(20,2),
			Enum.EasingDirection.Out,
			Enum.EasingStyle.Quad,
			0.15,
			true
		)
	else
		slot1.Pill.BackgroundColor3 = Color3.fromRGB(80,80,80)
		slot1.SlotKnob:TweenPosition(
			UDim2.fromOffset(2,2),
			Enum.EasingDirection.Out,
			Enum.EasingStyle.Quad,
			0.15,
			true
		)
	end
end)

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

escape.Name = "escape"
escape.Parent = Frame
escape.BackgroundColor3 = Color3.fromRGB(242, 60, 255)
escape.Position = UDim2.new(0, 0, 0.50500074, 0)
escape.Size = UDim2.new(0, 44, 0, 28)
escape.BorderSizePixel = 1
escape.BorderColor3 = Color3.fromRGB(0, 0, 0)

toggle.Name = "toggle"
toggle.Parent = escape
toggle.AutoButtonColor = false
toggle.Text = ""
toggle.BackgroundColor3 = Color3.fromRGB(88, 200, 120)
toggle.Size = UDim2.fromOffset(40, 20)
toggle.Position = UDim2.fromOffset(2, 4)
toggle.ZIndex = 2
toggle.ClipsDescendants = true

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(1, 0)
toggleCorner.Parent = toggle

local toggleStroke = Instance.new("UIStroke")
toggleStroke.Color = Color3.fromRGB(235, 235, 235)
toggleStroke.Thickness = 1
toggleStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
toggleStroke.Parent = toggle

local flyKnob = Instance.new("TextButton")
flyKnob.Name = "flyKnob"
flyKnob.Parent = toggle
flyKnob.AutoButtonColor = false
flyKnob.Text = ""
flyKnob.BackgroundColor3 = Color3.fromRGB(235, 235, 235)
flyKnob.Size = UDim2.fromOffset(16, 16)
flyKnob.Position = UDim2.fromOffset(22, 2)
flyKnob.ZIndex = 3

local knobCorner = Instance.new("UICorner")
knobCorner.CornerRadius = UDim.new(1, 0)
knobCorner.Parent = flyKnob

local knobStroke = Instance.new("UIStroke")
knobStroke.Color = Color3.fromRGB(235, 235, 235)
knobStroke.Thickness = 1
knobStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
knobStroke.Parent = flyKnob

onof.Name = "onof"
onof.Parent = Frame
onof.BackgroundColor3 = Color3.fromRGB(255, 249, 74)
onof.Position = UDim2.new(0.701, 0, 0.50500074, 0)
onof.Size = UDim2.new(0, 57, 0, 28)
onof.Font = Enum.Font.SourceSans
onof.Text = "FLY"
onof.TextColor3 = Color3.fromRGB(0, 0, 0)
onof.BorderSizePixel = 1
onof.TextSize = 21
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
speed.Text = "18"
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

SettingsButton.Name = "SettingButton"
SettingsButton.Parent = main.Frame
SettingsButton.BackgroundColor3 = Color3.fromRGB(192, 150, 230)
SettingsButton.Font = Enum.Font.SourceSans
SettingsButton.Size = UDim2.new(0, 44, 0, 28)
SettingsButton.TextColor3 = Color3.fromRGB(20, 20, 20)
SettingsButton.Text = "⚙"
SettingsButton.TextSize = 23
SettingsButton.Position = UDim2.new(0, 45, -0.99000, 27)


local lastClick = 0
local doubleClickWindow = 1

local originalTextColor = closebutton.TextColor3

closebutton.MouseButton1Click:Connect(function()
	if not main or not main.Parent then return end

	local now = tick()

	if lastClick > 0 and (now - lastClick) <= doubleClickWindow then
		if main and main.Parent then
			main:Destroy()
		end
		if SettingsGui and SettingsGui.Parent then
			SettingsGui:Destroy()
		end
	else
		lastClick = now
		closebutton.TextColor3 = Color3.fromRGB(255, 255, 255)

		task.delay(doubleClickWindow, function()
			if lastClick == now then
				closebutton.TextColor3 = originalTextColor
			end
		end)
	end
end)

local function pointerPos(input)
	return (input.UserInputType == Enum.UserInputType.Touch)
		and Vector2.new(input.Position.X, input.Position.Y)
		or UIS:GetMouseLocation()
end

local function over(inst, pos)
	local p, s = inst.AbsolutePosition, inst.AbsoluteSize
	return pos.X >= p.X and pos.X <= p.X + s.X and pos.Y >= p.Y and pos.Y <= p.Y + s.Y
end

local function attachDrag(target, ignoreButton)
	local dragging = false
	local dragStart, startPos

	target.Active = true
	target.Draggable = false

	local function clampToViewport(x, y)
		local cam = WS.CurrentCamera
		if not cam then
			return UDim2.fromOffset(x, y)
		end

		local vp = cam.ViewportSize
		local size = target.AbsoluteSize
		local anchor = target.AnchorPoint

		local minX = size.X * anchor.X
		local maxX = vp.X - size.X * (1 - anchor.X)
		local minY = size.Y * anchor.Y
		local maxY = vp.Y - size.Y * (1 - anchor.Y)

		x = math.clamp(x, minX, math.max(minX, maxX))
		y = math.clamp(y, minY, math.max(minY, maxY))

		return UDim2.fromOffset(x, y)
	end

	target.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch then

			if ignoreButton and over(ignoreButton, pointerPos(input)) then
				return
			end

			dragging = true
			dragStart = input.Position
			startPos = target.Position

			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)

	target.InputChanged:Connect(function(input)
		if not dragging then return end
		if input.UserInputType == Enum.UserInputType.MouseMovement
			or input.UserInputType == Enum.UserInputType.Touch then

			local delta = input.Position - dragStart
			target.Position = clampToViewport(
				startPos.X.Offset + delta.X,
				startPos.Y.Offset + delta.Y
			)
		end
	end)

	task.defer(function()
		local abs = target.AbsolutePosition
		target.Position = clampToViewport(abs.X, abs.Y)
	end)

	local function hookViewportChanged()
		local cam = WS.CurrentCamera
		if not cam then return end

		cam:GetPropertyChangedSignal("ViewportSize"):Connect(function()
			if not dragging then
				local abs = target.AbsolutePosition
				target.Position = clampToViewport(abs.X, abs.Y)
			end
		end)
	end

	if WS.CurrentCamera then
		hookViewportChanged()
	end

	WS:GetPropertyChangedSignal("CurrentCamera"):Connect(hookViewportChanged)
end

attachDrag(Frame, onof)
attachDrag(SettingsFrame, nil)

local magiskk = {}
local flySpeed = 18
local speaker = LocalPlayer
local nowe = false
local noclipConn = nil
local noclipCache = {}

local SPEED, TARGET_Y = 1500, 1000000
local LOW_HP, SAFE_HP = 0.40, 0.80

local Enabled = false

local Flying, TweenObj = false, nil
local Humanoid, RootPart
local healthConn
local magictis_cancelFlight, magictis_startFlight, magictis_onHealthChanged, magictis_bindCharacter

local tweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
local isOn = Enabled

local function setToggle(state)
	isOn = state
	local bgOn = Color3.fromRGB(88, 200, 120)
	local bgOff = Color3.fromRGB(220, 50, 50)
	if isOn then
		TweenService:Create(toggle, tweenInfo, {BackgroundColor3 = bgOn}):Play()
		TweenService:Create(knob, tweenInfo, {Position = UDim2.fromOffset(22, 2)}):Play()
	else
		TweenService:Create(toggle, tweenInfo, {BackgroundColor3 = bgOff}):Play()
		TweenService:Create(knob, tweenInfo, {Position = UDim2.fromOffset(2, 2)}):Play()
	end
end

magictis_cancelFlight = function()
	if TweenObj then TweenObj:Cancel() TweenObj = nil end
	Flying = false
end

magictis_startFlight = function()
	if not Enabled or Flying or not RootPart then return end
	local yNow = RootPart.Position.Y
	if yNow >= TARGET_Y - 1 then return end
	local dist = TARGET_Y - yNow
	local duration = dist / SPEED
	Flying = true
	local cf = RootPart.CFrame
	TweenObj = TweenService:Create(
		RootPart,
		TweenInfo.new(duration, Enum.EasingStyle.Linear),
		{CFrame = CFrame.new(cf.X, TARGET_Y, cf.Z)}
	)
	TweenObj.Completed:Connect(function()
		TweenObj = nil
		Flying = false
	end)
	TweenObj:Play()
end

magictis_onHealthChanged = function(h)
	if not Humanoid or not Enabled then return end
	local mh = Humanoid.MaxHealth
	if mh <= 0 then return end
	local p = h / mh
	if (not Flying) and p < LOW_HP then
		magictis_startFlight()
	elseif Flying and p >= SAFE_HP then
		magictis_cancelFlight()
	end
end

magictis_bindCharacter = function(char)
	Humanoid = char:WaitForChild("Humanoid")
	RootPart = char:WaitForChild("HumanoidRootPart")
	if healthConn then
		healthConn:Disconnect()
		healthConn = nil
	end
	if Enabled then
		healthConn = Humanoid.HealthChanged:Connect(magictis_onHealthChanged)
	end
end

local function magictis_applyEnabled(state)
	Enabled = state
	if not Enabled then
		magictis_cancelFlight()
		Flying = false
		if healthConn then
			healthConn:Disconnect()
			healthConn = nil
		end
	else
		if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
			Humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
			if healthConn then
				healthConn:Disconnect()
			end
			healthConn = Humanoid.HealthChanged:Connect(magictis_onHealthChanged)
			magictis_onHealthChanged(Humanoid.Health)
		end
	end
end

local toggling = false
local function magictis_onToggleClick()
    if toggling then return end
    toggling = true
    local nextState = not isOn
    setToggle(nextState)
    magictis_applyEnabled(nextState)
    isOn = nextState
    task.delay(0.15, function()
        toggling = false
    end)
end

toggle.Activated:Connect(magictis_onToggleClick)
knob.Activated:Connect(magictis_onToggleClick)

if LocalPlayer.Character then
	magictis_bindCharacter(LocalPlayer.Character)
end

LocalPlayer.CharacterAdded:Connect(magictis_bindCharacter)

task.defer(function()
    setToggle(Enabled)
    magictis_applyEnabled(Enabled)
end)

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
			if prev == nil then
				part.CanCollide = true
			else
				part.CanCollide = prev
			end
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

local ASCEND_SPEED = 1500
local UP_TARGET_Y = 10000000
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
		local chr = LocalPlayer.Character
		local hum = chr and chr:FindFirstChildOfClass("Humanoid")
		if hum then hum.PlatformStand = false end
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
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	if not hrp or not hum then return end

	hum.PlatformStand = true
	hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
	startUpTextVisual()

	if Settings.BypassUp then
	if isAscending then
		stopAscending()
		return
	end

	isAscending = true
	startUpTextVisual()

	hrp.CFrame = CFrame.new(
		hrp.Position.X,
		UP_TARGET_Y,
		hrp.Position.Z
	)

	task.delay(0.05, function()
		if isAscending then
			stopAscending()
		end
	end)

	return
end

	local duration = dist / ASCEND_SPEED
	isAscending = true

	ascendTween = TweenService:Create(
		hrp,
		TweenInfo.new(duration, Enum.EasingStyle.Linear),
		{CFrame = CFrame.new(startPos.X, UP_TARGET_Y, startPos.Z)}
	)

	ascendTween.Completed:Connect(function()
		ascendTween = nil
		if isAscending then
			stopAscending()
		end
	end)

	ascendTween:Play()
end)

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
		speed.Text = "cannot be less than 1"
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

local settingsOpen = false

SettingsButton.MouseButton1Click:Connect(function()
	settingsOpen = not settingsOpen
	SettingsGui.Enabled = settingsOpen
end)

Players.LocalPlayer.CharacterAdded:Connect(function(char)
	if magiskk and magiskk.StopVertical then
		pcall(function()
			magiskk.StopVertical()
		end)
	end

	pcall(function()
		stopNoclip()
	end)

	nowe = false
	tpwalking = false
	isAscending = false

	stopFlyVisuals()
	stopUpTextVisual()
	if not Enabled then
		magictis_cancelFlight()
		Flying = false
		if healthConn then
			healthConn:Disconnect()
			healthConn = nil
		end
	end

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
end)
Players.LocalPlayer.CharacterAdded:Connect(function()
	lastClick = 0
end)
