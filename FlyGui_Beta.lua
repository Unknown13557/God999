local UserInputService = game:GetService("UserInputService")
local Players          = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
if not LocalPlayer then
	Players.PlayerAdded:Wait()
	LocalPlayer = Players.LocalPlayer
end

local PlayerGui        = LocalPlayer:WaitForChild("PlayerGui")
local RunService       = game:GetService("RunService")
local Workspace        = game:GetService("Workspace")
local TweenService     = game:GetService("TweenService")

local RS               = RunService
local WS               = Workspace
local UIS              = UserInputService

local MAX_INPUT_VALUE = 2000000000

local nowe = false
local escapeEnabled = false
local escapeDebounce = false

local upEnabled = false
local upConn
local upTween
local lockedXZ

local function updatePlatformStand()
	local char = Players.LocalPlayer.Character
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	if not hum then return end

	if nowe or escapeTween then
	hum.PlatformStand = true
else
	hum.PlatformStand = false
	end
end


local escapeTween = nil


local ESCAPE_HP_LOW = 40
local ESCAPE_HP_HIGH = 80

local function getHRP()
	local char = Players.LocalPlayer.Character
	if not char then return nil end
	return char:FindFirstChild("HumanoidRootPart")
end


local Settings = {
	BypassTween       = true
}

local function pointerPos(input)
	if input.UserInputType == Enum.UserInputType.Touch then
		return Vector2.new(input.Position.X, input.Position.Y)
	end

	if UIS.GetMouseLocation then
		return UIS:GetMouseLocation()
	end
	return Vector2.new(0, 0)
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

	

local main = Instance.new("ScreenGui")
if syn and syn.protect_gui then
	syn.protect_gui(main)
end
main.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
main.DisplayOrder = 198282823
main.Name = "main"
main.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
main.ResetOnSpawn = false
main.IgnoreGuiInset = true


local Frame           = Instance.new("Frame")
Frame.Parent          = main
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
SettingsFrame.Position = UDim2.fromScale(0.5, 0.5)
attachDrag(SettingsFrame, nil)

local GridHolder = Instance.new("Frame")
GridHolder.Parent = SettingsFrame
GridHolder.Size = UDim2.fromScale(1, 1)
GridHolder.BackgroundTransparency = 1
GridHolder.Name = "GridHolder"

task.defer(function()
	local cam = WS.CurrentCamera
	if cam then
		local vp = cam.ViewportSize
		SettingsFrame.Position = UDim2.fromOffset(vp.X * 0.5, vp.Y * 0.5)
	end
end)


local Slots = {}


for i = 1, 6 do
	local slot = Instance.new("Frame")
	slot.Name = "Slot"..i
	slot.Parent = GridHolder
	slot.BackgroundColor3 = Color3.fromRGB(60,60,60)
	slot.BorderSizePixel = 0
	slot.ZIndex = 10
	slot.ClipsDescendants = true
	slot.AutomaticSize = Enum.AutomaticSize.None


	local col = (i - 1) % 2
	local row = math.floor((i - 1) / 2)

	slot.Size = UDim2.fromScale(0.48, 0.27)
	slot.Position = UDim2.fromScale(
		0.02 + col * 0.5,
		0.05 + row * 0.31
	)

	if i == 1 then

		Slots[1] = {
			Frame = slot,
			Type = "Console"
		}

	else

		local content = Instance.new("Frame")
		content.Parent = slot
		content.BackgroundTransparency = 1
		content.Size = UDim2.new(1, -20, 1, 0)
		content.Position = UDim2.fromOffset(10, 0)
		content.ZIndex = 11

		local label = Instance.new("TextLabel")
		label.Parent = content
		label.BackgroundTransparency = 1
		label.Size = UDim2.fromScale(0.65, 1)
		label.Position = UDim2.fromScale(0, 0)
		label.Font = Enum.Font.SourceSansBold
		label.TextSize = 18
		label.TextXAlignment = Enum.TextXAlignment.Left
		label.TextColor3 = Color3.fromRGB(220,220,220)
		label.Text = "Slot "..i
		label.ZIndex = 12

		local pill = Instance.new("TextButton")
		pill.Parent = content
		pill.Size = UDim2.fromOffset(36, 18)
		pill.AnchorPoint = Vector2.new(1, 0.5)
		pill.Position = UDim2.fromScale(1, 0.5)
		pill.BackgroundColor3 = Color3.fromRGB(80,80,80)
		pill.Text = ""
		pill.AutoButtonColor = false
		pill.ZIndex = 12
		Instance.new("UICorner", pill).CornerRadius = UDim.new(1, 0)

		local knob = Instance.new("Frame")
		knob.Parent = pill
		knob.Size = UDim2.fromOffset(14, 14)
		knob.Position = UDim2.fromOffset(2, 2)
		knob.BackgroundColor3 = Color3.fromRGB(220,220,220)
		knob.ZIndex = 13
		Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

		Slots[i] = {
			Frame = slot,
			Label = label,
			Pill = pill,
			SlotKnob = knob,
			State = false
		}
	end
end



local slot1 = Slots[1]
local frame = slot1.Frame
slot1.Frame.ZIndex = 20

frame.ClipsDescendants = false
frame.AutomaticSize = Enum.AutomaticSize.None

local row = Instance.new("Frame")
row.Parent = frame
row.BackgroundTransparency = 1
row.Size = UDim2.new(1, -12, 1, -8)
row.Position = UDim2.fromOffset(6, 4)
row.ZIndex = 21
row.ClipsDescendants = false

local layout = Instance.new("UIListLayout")
layout.Parent = row
layout.FillDirection = Enum.FillDirection.Horizontal
layout.VerticalAlignment = Enum.VerticalAlignment.Center
layout.HorizontalAlignment = Enum.HorizontalAlignment.Left
layout.Padding = UDim.new(0, 1)



local yBox = Instance.new("TextBox")
yBox.Parent = row
yBox.Text = "5000000"
yBox.Size = UDim2.fromOffset(80, 28)
yBox.ClearTextOnFocus = false
yBox.Font = Enum.Font.SourceSansBold
yBox.TextSize = 16
yBox.TextXAlignment = Enum.TextXAlignment.Center
yBox.TextYAlignment = Enum.TextYAlignment.Center
yBox.TextColor3 = Color3.fromRGB(230,230,230)
yBox.BackgroundColor3 = Color3.fromRGB(40,40,40)
yBox.BorderSizePixel = 0
yBox.LayoutOrder = 1
yBox.ZIndex = 22

local yCorner = Instance.new("UICorner")
yCorner.CornerRadius = UDim.new(0,6)
yCorner.Parent = yBox

yBox:GetPropertyChangedSignal("Text"):Connect(function()
	local text = yBox.Text

	text = text:gsub("%D", "")

	if text == "" then
		yBox.Text = ""
		return
	end

	local num = tonumber(text)
	if not num then
		yBox.Text = ""
		return
	end

	if num > MAX_INPUT_VALUE then
		num = MAX_INPUT_VALUE
	end

	local fixed = tostring(math.floor(num))
	if yBox.Text ~= fixed then
		yBox.Text = fixed
	end
end)




local spBox = Instance.new("TextBox")
spBox.Parent = row
spBox.Text = "2000"
spBox.Size = UDim2.fromOffset(75, 28)
spBox.ClearTextOnFocus = false
spBox.Font = Enum.Font.SourceSansBold
spBox.TextSize = 16
spBox.TextXAlignment = Enum.TextXAlignment.Center
spBox.TextYAlignment = Enum.TextYAlignment.Center
spBox.TextColor3 = Color3.fromRGB(230,230,230)
spBox.BackgroundColor3 = Color3.fromRGB(40,40,40)
spBox.BorderSizePixel = 0
spBox.LayoutOrder = 2
spBox.ZIndex = 22

local spCorner = Instance.new("UICorner")
spCorner.CornerRadius = UDim.new(0,6)
spCorner.Parent = spBox

spBox:GetPropertyChangedSignal("Text"):Connect(function()
	local text = spBox.Text

	text = text:gsub("%D", "")

	if text == "" then
		spBox.Text = ""
		return
	end

	local num = tonumber(text)
	if not num then
		spBox.Text = ""
		return
	end

	if num > MAX_INPUT_VALUE then
		num = MAX_INPUT_VALUE
	end

	local fixed = tostring(math.floor(num))
	if spBox.Text ~= fixed then
		spBox.Text = fixed
	end
end)



local function readSlot1Config()
	local y = tonumber(yBox.Text)
	local sp = tonumber(spBox.Text)

	if not y then return nil, nil end
	if not sp or sp <= 0 then sp = 1 end

	return y, sp
end

local function startEscape()
	local char = Players.LocalPlayer.Character
	if not char then return end

	local hrp = char:FindFirstChild("HumanoidRootPart")
	if not hrp then return end

	local targetY, speed = readSlot1Config()
	if not targetY then return end


if Settings.BypassTween then
		if escapeTween then
			escapeTween:Cancel()
			escapeTween = nil
		end

		local cf = hrp.CFrame
		hrp.CFrame = CFrame.new(
			cf.Position.X,
			targetY,
			cf.Position.Z
		) * CFrame.Angles(cf:ToEulerAnglesXYZ())

		updatePlatformStand()
		return
	end
    

	if escapeTween then
		escapeTween:Cancel()
	end

	local startCF = hrp.CFrame
	local targetCF = CFrame.new(
		startCF.Position.X,
		targetY,
		startCF.Position.Z
	) * CFrame.Angles(startCF:ToEulerAnglesXYZ())

	local duration = math.abs(targetY - startCF.Position.Y) / speed

	escapeTween = TweenService:Create(
		hrp,
		TweenInfo.new(duration, Enum.EasingStyle.Linear),
		{ CFrame = targetCF }
	)

	escapeTween:Play()
	escapeTween.Completed:Connect(function()
		escapeTween = nil
		updatePlatformStand()
	end)
end



local function stopEscape()
	if escapeTween then
		escapeTween:Cancel()
		escapeTween = nil
	end
end


local function startUp()
	if upConn then return end

	upEnabled = true
	startUpTextVisual()

	local char = Players.LocalPlayer.Character
	if not char then return end

	local hrp = char:FindFirstChild("HumanoidRootPart")
	if not hrp then return end

	lockedXZ = Vector3.new(hrp.Position.X, 0, hrp.Position.Z)

	upConn = RunService.Heartbeat:Connect(function()
		if not upEnabled then return end

		local targetY, speed = readSlot1Config()
		if not targetY or not speed then return end

		if upTween then
			upTween:Cancel()
			upTween = nil
		end

		local pos = hrp.Position

		local targetCF = CFrame.new(
			lockedXZ.X,
			targetY,
			lockedXZ.Z
		) * hrp.CFrame.Rotation

		local dist = math.abs(pos.Y - targetY)
		local duration = math.max(dist / speed, 0.03)

		upTween = TweenService:Create(
			hrp,
			TweenInfo.new(duration, Enum.EasingStyle.Linear),
			{ CFrame = targetCF }
		)

		upTween:Play()
	end)
end

local function syncEscapeUI(state)
	if state then
		toggle.BackgroundColor3 = Color3.fromRGB(88,200,120)
		flyKnob:TweenPosition(
			UDim2.fromOffset(22, 2),
			Enum.EasingDirection.Out,
			Enum.EasingStyle.Quad,
			0.15,
			true
		)
	else
		toggle.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
		flyKnob:TweenPosition(
			UDim2.fromOffset(2, 2),
			Enum.EasingDirection.Out,
			Enum.EasingStyle.Quad,
			0.15,
			true
		)
	end
end


local function toggleEscape()
	if escapeDebounce then return end
	escapeDebounce = true
	task.delay(0.15, function()
		escapeDebounce = false
	end)

	escapeEnabled = not escapeEnabled
	syncEscapeUI(escapeEnabled)

	if not escapeEnabled then
		stopEscape()
	end

	updatePlatformStand()
end


toggle.Activated:Connect(toggleEscape)
flyKnob.Activated:Connect(toggleEscape)


local function getHealthPercent()
	local char = Players.LocalPlayer.Character
	if not char then return 100 end

	local hum = char:FindFirstChildOfClass("Humanoid")
	if not hum or hum.MaxHealth <= 0 then
		return 100
	end

	return (hum.Health / hum.MaxHealth) * 100
end


RunService.Heartbeat:Connect(function()
	if not escapeEnabled then return end

	local hp = getHealthPercent()

	if hp < ESCAPE_HP_LOW then
		if not escapeTween then
			startEscape()
			updatePlatformStand()
		end
	elseif hp > ESCAPE_HP_HIGH then
		if escapeTween then
			stopEscape()
			updatePlatformStand()
		end
	end
end)




local function stopUp()
	upEnabled = false
	stopUpTextVisual()

	if upConn then
		upConn:Disconnect()
		upConn = nil
	end

	if upTween then
		upTween:Cancel()
		upTween = nil
	end

	lockedXZ = nil

	local char = Players.LocalPlayer.Character
	if char then
		local hrp = char:FindFirstChild("HumanoidRootPart")
		if hrp then
			hrp.AssemblyLinearVelocity = Vector3.zero
			hrp.AssemblyAngularVelocity = Vector3.zero
		end
	end
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

up.MouseButton1Click:Connect(function()
	if not upEnabled then
		startUp()
	else
		stopUp()
	end

	updatePlatformStand()
end)


local slot2 = Slots[2]
slot2.Label.Text = "Bypass Tween"
slot2.State = true
slot2.Pill.BackgroundColor3 = Color3.fromRGB(120,200,120)
slot2.SlotKnob.Position = UDim2.fromOffset(20,2)

slot2.Pill.MouseButton1Click:Connect(function()
	slot2.State = not slot2.State
	Settings.BypassTween = slot2.State

	if slot2.State then
		slot2.Pill.BackgroundColor3 = Color3.fromRGB(120,200,120)
		slot2.SlotKnob:TweenPosition(
			UDim2.fromOffset(20,2),
			Enum.EasingDirection.Out,
			Enum.EasingStyle.Quad,
			0.15,
			true
		)
	else
		slot2.Pill.BackgroundColor3 = Color3.fromRGB(80,80,80)
		slot2.SlotKnob:TweenPosition(
			UDim2.fromOffset(2,2),
			Enum.EasingDirection.Out,
			Enum.EasingStyle.Quad,
			0.15,
			true
		)
	end
end)



repeat task.wait() until SettingsFrame and SettingsFrame.Parent

local slot3Data = Slots[3]
local slot3Frame = slot3Data.Frame

slot3Frame.AutomaticSize = Enum.AutomaticSize.None
slot3Frame.ClipsDescendants = true

slot3Data.Pill.Visible = false
slot3Data.State = nil
slot3Data.Label.Visible = false

local row3 = Instance.new("Frame")
row3.Parent = slot3Frame
row3.Size = UDim2.new(1, -12, 1, -8)
row3.Position = UDim2.fromOffset(6, 4)
row3.BackgroundTransparency = 1
row3.ZIndex = 20

local rowLayout = Instance.new("UIListLayout")
rowLayout.Parent = row3
rowLayout.FillDirection = Enum.FillDirection.Horizontal
rowLayout.VerticalAlignment = Enum.VerticalAlignment.Center
rowLayout.Padding = UDim.new(0, 1)

local SLOT3MIN_TWEEN_Y = 30
local SLOT3MAX_TWEEN_Y = 2000000000

local slot3Input = Instance.new("TextBox")
slot3Input.Parent = row3

slot3Input.Size = UDim2.fromOffset(80, 28)

slot3Input.Text = "500000"
slot3Input.PlaceholderText = "Input"
slot3Input.TextColor3 = Color3.fromRGB(230,230,230)
slot3Input.PlaceholderColor3 = Color3.fromRGB(160,160,160)
slot3Input.BackgroundColor3 = Color3.fromRGB(40,40,40)
slot3Input.ClearTextOnFocus = false
slot3Input.Font = Enum.Font.SourceSansBold
slot3Input.TextSize = 16
slot3Input.TextXAlignment = Enum.TextXAlignment.Center
slot3Input.TextYAlignment = Enum.TextYAlignment.Center
slot3Input.ZIndex = 15

local slot3InputCorner = Instance.new("UICorner")
slot3InputCorner.CornerRadius = UDim.new(0,6)
slot3InputCorner.Parent = slot3Input

slot3Input:GetPropertyChangedSignal("Text"):Connect(function()
	local text = slot3Input.Text
	text = text:gsub("%D", "")
	if text == "" then
		slot3Input.Text = ""
		return
	end

	local num = tonumber(text)
	if not num then
		slot3Input.Text = ""
		return
	end

	if num < 0 then
		num = 0
	end

	if num > SLOT3MAX_TWEEN_Y then
		num = SLOT3MAX_TWEEN_Y
	end

	local fixed = tostring(math.floor(num))
	if slot3Input.Text ~= fixed then
		slot3Input.Text = fixed
	end
end)

local slot3UpBtn = Instance.new("TextButton")
slot3UpBtn.Parent = row3
slot3UpBtn.Size = UDim2.fromOffset(37, 28)
slot3UpBtn.Text = ""
slot3UpBtn.BackgroundColor3 = Color3.fromRGB(80,180,120)
slot3UpBtn.ZIndex = 15

local slot3UpIcon = Instance.new("ImageLabel")
slot3UpIcon.Parent = slot3UpBtn
slot3UpIcon.BackgroundTransparency = 1
slot3UpIcon.Size = UDim2.fromScale(0.85, 0.85)
slot3UpIcon.Position = UDim2.fromScale(0.075, 0.075)
slot3UpIcon.Image = "rbxassetid://6031090990"
slot3UpIcon.ZIndex = slot3UpBtn.ZIndex + 1

local slot3UpCorner = Instance.new("UICorner")
slot3UpCorner.CornerRadius = UDim.new(0,6)
slot3UpCorner.Parent = slot3UpBtn

local slot3DownBtn = Instance.new("TextButton")
slot3DownBtn.Parent = row3
slot3DownBtn.Size = UDim2.fromOffset(37, 28)
slot3DownBtn.Text = ""
slot3DownBtn.BackgroundColor3 = Color3.fromRGB(180,80,80)
slot3DownBtn.ZIndex = 15

local slot3DownIcon = Instance.new("ImageLabel")
slot3DownIcon.Parent = slot3DownBtn
slot3DownIcon.BackgroundTransparency = 1
slot3DownIcon.Size = UDim2.fromScale(0.85, 0.85)
slot3DownIcon.Position = UDim2.fromScale(0.075, 0.075)
slot3DownIcon.Image = "rbxassetid://6031090990"
slot3DownIcon.Rotation = 180
slot3DownIcon.ZIndex = slot3DownBtn.ZIndex + 1

local slot3DownCorner = Instance.new("UICorner")
slot3DownCorner.CornerRadius = UDim.new(0,6)
slot3DownCorner.Parent = slot3DownBtn

local function applyOffset(dir)
	local value = tonumber(slot3Input.Text)
	if not value or value <= 0 then return end

	local char = LocalPlayer.Character
	if not char then return end

	local hrp = char:FindFirstChild("HumanoidRootPart")
	if not hrp then return end

	local currentY = hrp.Position.Y
	local targetY = currentY + (value * dir)

	if targetY < SLOT3MIN_TWEEN_Y then
		targetY = SLOT3MIN_TWEEN_Y
end

	if targetY > SLOT3MAX_TWEEN_Y then
		targetY = SLOT3MAX_TWEEN_Y
end

	hrp.AssemblyLinearVelocity = Vector3.zero
	hrp.AssemblyAngularVelocity = Vector3.zero

	hrp.CFrame = CFrame.new(
		hrp.Position.X,
		targetY,
		hrp.Position.Z
	)
end

slot3UpBtn.MouseButton1Click:Connect(function()
    applyOffset(1)
end)

slot3DownBtn.MouseButton1Click:Connect(function()
    applyOffset(-1)
end)






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
flyKnob.ZIndex = 3

local flyKnobCorner = Instance.new("UICorner")
flyKnobCorner.CornerRadius = UDim.new(1, 0)
flyKnobCorner.Parent = flyKnob

local flyKnobStroke = Instance.new("UIStroke")
flyKnobStroke.Color = Color3.fromRGB(235, 235, 235)
flyKnobStroke.Thickness = 1
flyKnobStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
flyKnobStroke.Parent = flyKnob

flyKnob.Position = UDim2.fromOffset(2, 2)
toggle.BackgroundColor3 = Color3.fromRGB(88,200,120)

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

task.defer(function()
	if Frame and Frame.Parent and onof then
		attachDrag(Frame, onof)
	end
end)	

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
closebutton.Parent = Frame
closebutton.BackgroundColor3 = Color3.fromRGB(225, 25, 0)
closebutton.Font = Enum.Font.SourceSans
closebutton.Size = UDim2.new(0, 44, 0, 28)
closebutton.Text = "X"
closebutton.TextSize = 30
closebutton.Position =  UDim2.new(0, 0, -0.99000, 27)

SettingsButton.Name = "SettingButton"
SettingsButton.Parent = Frame
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
	local now = tick()

	if now - lastClick <= doubleClickWindow then
		if SettingsGui and SettingsGui.Parent then
			SettingsGui:Destroy()
	end

		if main and main.Parent then
			main:Destroy()
	end
		return
	end

	lastClick = now
	closebutton.TextColor3 = Color3.fromRGB(255, 255, 255)

	task.delay(doubleClickWindow, function()
		if tick() - lastClick >= doubleClickWindow then
			closebutton.TextColor3 = originalTextColor
		end
	end)
end)






	

		
	









local magiskk = {}
local flySpeed = 18
local speaker = LocalPlayer

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




function magiskk.StopVertical()
	
	upEnabled = false

	if upTween then
		pcall(function()
			upTween:Cancel()
		end)
		upTween = nil
	end

	stopUpTextVisual()

	if escapeTween then
		pcall(function()
			escapeTween:Cancel()
		end)
		escapeTween = nil
	end

	updatePlatformStand()
end


toggle.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
flyKnob.Position = UDim2.fromOffset(2, 2)


local tpwalking = false
local tpGen = 0
onof.MouseButton1Down:Connect(function()

	if nowe == true then
		nowe = false

    updatePlatformStand()
			
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

        updatePlatformStand()
				
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
		
			while nowe == true and LocalPlayer.Character
	and LocalPlayer.Character:FindFirstChild("Humanoid")
	and LocalPlayer.Character.Humanoid.Health > 0 do
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
		
		while nowe == true and LocalPlayer.Character
	and LocalPlayer.Character:FindFirstChild("Humanoid")
	and LocalPlayer.Character.Humanoid.Health > 0 do
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

SettingsButton.MouseButton1Click:Connect(function()
	if not SettingsGui or not SettingsGui.Parent then
		return
	end
	SettingsGui.Enabled = not SettingsGui.Enabled
end)


Players.LocalPlayer.CharacterAdded:Connect(function(char)
	
	

	nowe = false
	tpwalking = false
    stopNoclip()
	
    upEnabled = false
	stopUp()
    escapeEnabled = false
    stopEscape()
	syncEscapeUI(false)
    updatePlatformStand()
		
	
	stopUpTextVisual()
	stopFlyVisuals()    
	
	
	lastClick = 0

	task.wait(0.1)

	
	local hum = char:FindFirstChildOfClass("Humanoid")
	if hum then
		hum.AutoRotate = true
	end

	
	local anim = char:FindFirstChild("Animate")
	if anim then
		anim.Disabled = false
	end
end)


