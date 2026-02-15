local UserInputService = game:GetService("UserInputService")
local Players                    = game:GetService("Players")
local Camera                    = workspace.CurrentCamera
local LocalPlayer            = Players.LocalPlayer
local Lighting                  = game:GetService("Lighting")

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

local MAX_INPUT_VALUE = 200000000

local lastApplyTime = 0
local APPLY_INTERVAL = 1/30

local noclipUsers = 0
local sharedNoclipConn = nil

local flyNoclipConn = nil
local flyHasNoclipPriority = false



local nowe = false



local waypointCF = nil
local waypointMoveConn = nil
local waypointActive = false

local playerButtons = {}
local selectedButton = nil
local selectedPlayer = nil

local teleportMoveConn = nil
local teleportActive = false


local speedConn = nil
local accel = 1


local infJumpConn = nil
local escapeEnabled = false
local escapeActive = false
local upEnabled = false

local jumpConn = nil
local landConn = nil

local escapeMoveConn = nil
local escapeDebounce = false

local magiskk = {}
local flySpeed = 18
local speaker = LocalPlayer


local ESCAPE_HP_LOW = 40
local ESCAPE_HP_HIGH = 80

local virtualFloor = nil
local lockYConn = nil
local lockedY = nil

local Slots = {}

local Settings = {
	BypassTween       = true
}



local main = Instance.new("ScreenGui")

main.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
main.DisplayOrder = 19000
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

attachDrag(Frame, onof)

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


local SettingsGui = Instance.new("ScreenGui")
SettingsGui.Name = "SettingsGui"
SettingsGui.Parent = LocalPlayer.PlayerGui
SettingsGui.IgnoreGuiInset = true
SettingsGui.DisplayOrder = main.DisplayOrder + 5
SettingsGui.Enabled = false
SettingsGui.ResetOnSpawn = false



local DragFrame = Instance.new("Frame")
DragFrame.Parent = SettingsGui
DragFrame.Name = "DragFrame"



DragFrame.BackgroundColor3 = Color3.fromRGB(255,255,255)
DragFrame.BackgroundTransparency = 0.8
DragFrame.BorderSizePixel = 0
DragFrame.Active = true

local dragCorner = Instance.new("UICorner")
dragCorner.CornerRadius = UDim.new(0, 8)
dragCorner.Parent = DragFrame

local dragStroke = Instance.new("UIStroke")
dragStroke.Parent = DragFrame
dragStroke.Color = Color3.fromRGB(255, 255, 255)
dragStroke.Thickness = 1.5
dragStroke.Transparency = 0
dragStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

DragFrame:GetPropertyChangedSignal("Position"):Connect(function()
end)


local PAD = {
	L = 10,
	R = 10,
	T = 10,
	B = 10
}

local padding = Instance.new("UIPadding")
padding.Parent = DragFrame
padding.PaddingLeft   = UDim.new(0, PAD.L)
padding.PaddingRight  = UDim.new(0, PAD.R)
padding.PaddingTop    = UDim.new(0, PAD.T)
padding.PaddingBottom = UDim.new(0, PAD.B)

local SettingsFrame = Instance.new("Frame")
SettingsFrame.Parent = DragFrame
SettingsFrame.Size = UDim2.fromOffset(220, 160)
SettingsFrame.AnchorPoint = Vector2.new(0, 0)

SettingsFrame.BackgroundColor3 = Color3.fromRGB(30,30,30)
SettingsFrame.BorderSizePixel = 0
SettingsFrame.AutomaticSize = Enum.AutomaticSize.None

Instance.new("UICorner", SettingsFrame).CornerRadius = UDim.new(0,8)


DragFrame.Size = UDim2.fromOffset(
	SettingsFrame.Size.X.Offset + PAD.L + PAD.R,
	SettingsFrame.Size.Y.Offset + PAD.T + PAD.B
)


DragFrame.ZIndex = SettingsFrame.ZIndex - 1
attachDrag(DragFrame, nil)


local Scroll = Instance.new("ScrollingFrame")
Scroll.Name = "Scroll"
Scroll.Parent = SettingsFrame
Scroll.Position = UDim2.new(0, 4, 0, 4)
Scroll.Size     = UDim2.new(1, -8, 1, -8)

Scroll.CanvasSize = UDim2.new(0,0,0,0)
Scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
Scroll.ScrollBarThickness = 3
Scroll.VerticalScrollBarInset = Enum.ScrollBarInset.Always
Scroll.BackgroundTransparency = 1
Scroll.BorderSizePixel = 0
Scroll.ZIndex = 1
Scroll.ScrollingDirection = Enum.ScrollingDirection.Y


local listLayout = Instance.new("UIListLayout")
listLayout.Parent = Scroll
listLayout.FillDirection = Enum.FillDirection.Vertical
listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
listLayout.Padding = UDim.new(0, 4)




local function applyNoclipOnce()

	local now = tick()
	if now - lastApplyTime < APPLY_INTERVAL then
		return
	end
	lastApplyTime = now

	local Char = LocalPlayer.Character
	if not Char then return end

	for _, part in ipairs(Char:GetDescendants()) do
		if part:IsA("BasePart") and part.CanCollide ~= false then
			part.CanCollide = false
		end
	end
end

local function restoreCollision()

	local Char = LocalPlayer.Character
	if not Char then return end

	for _, part in ipairs(Char:GetDescendants()) do
		if part:IsA("BasePart") and part.CanCollide ~= true then
			part.CanCollide = true
		end
	end
end


local function updateSharedNoclip()

	-- Nếu Fly đang giữ quyền thì shared không làm gì
	if flyHasNoclipPriority then
		return
	end

	if noclipUsers > 0 then

		if sharedNoclipConn then return end

		applyNoclipOnce()

		sharedNoclipConn = RunService.Heartbeat:Connect(function()
			applyNoclipOnce()
		end)

	else

		if sharedNoclipConn then
			sharedNoclipConn:Disconnect()
			sharedNoclipConn = nil
		end

		restoreCollision()

	end
end

local function updateFlyNoclip(state)

	if state then

		if flyNoclipConn then return end

		-- Fly chiếm quyền
		flyHasNoclipPriority = true

		applyNoclipOnce()

		flyNoclipConn = RunService.Heartbeat:Connect(function()
			applyNoclipOnce()
		end)

	else

		if flyNoclipConn then
			flyNoclipConn:Disconnect()
			flyNoclipConn = nil
		end

		-- Trả quyền cho shared
		flyHasNoclipPriority = false

		updateSharedNoclip()

	end
end

local function addNoclipUser()
	noclipUsers += 1
	if noclipUsers == 1 then
		updateSharedNoclip()
	end
end

local function removeNoclipUser()
	local old = noclipUsers
	noclipUsers = math.max(0, noclipUsers - 1)

	if old > 0 and noclipUsers == 0 then
		updateSharedNoclip()
	end
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


local tpwalking = false
local tpGen = 0
onof.MouseButton1Down:Connect(function()
	local char = LocalPlayer.Character
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	if not hum then return end

	if nowe == true then
		nowe = false

    hum.PlatformStand = nowe
			
	stopFlyVisuals() 
	  tpwalking = false
        tpGen = tpGen + 1
				
	
    updateFlyNoclip(false)


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

        hum.PlatformStand = nowe
				
		startFlyVisuals()

      
       updateFlyNoclip(true)


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
				bv.velocity = ((WS.CurrentCamera.CFrame.lookVector * (ctrl.f+ctrl.b)) + ((WS.CurrentCamera.CFrame * CFrame.new(ctrl.l+ctrl.r,(ctrl.f+ctrl.b)*.2,0).p) - WS.CurrentCamera.CFrame.p))*speed
				lastctrl = {f = ctrl.f, b = ctrl.b, l = ctrl.l, r = ctrl.r}
			elseif (ctrl.l + ctrl.r) == 0 and (ctrl.f + ctrl.b) == 0 and speed ~= 0 then
				bv.velocity = ((WS.CurrentCamera.CFrame.lookVector * (lastctrl.f+lastctrl.b)) + ((WS.CurrentCamera.CFrame * CFrame.new(lastctrl.l+lastctrl.r,(lastctrl.f+lastctrl.b)*.2,0).p) - WS.CurrentCamera.CFrame.p))*speed
			else
				bv.velocity = Vector3.new(0,0,0)
			end

			bg.cframe = WS.CurrentCamera.CFrame * CFrame.Angles(-math.rad((ctrl.f+ctrl.b)*50*speed/maxspeed),0,0)
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
				bv.velocity = ((WS.CurrentCamera.CFrame.lookVector * (ctrl.f+ctrl.b)) + ((WS.CurrentCamera.CFrame * CFrame.new(ctrl.l+ctrl.r,(ctrl.f+ctrl.b)*.2,0).p) - WS.CurrentCamera.CFrame.p))*speed
				lastctrl = {f = ctrl.f, b = ctrl.b, l = ctrl.l, r = ctrl.r}
			elseif (ctrl.l + ctrl.r) == 0 and (ctrl.f + ctrl.b) == 0 and speed ~= 0 then
				bv.velocity = ((WS.CurrentCamera.CFrame.lookVector * (lastctrl.f+lastctrl.b)) + ((WS.CurrentCamera.CFrame * CFrame.new(lastctrl.l+lastctrl.r,(lastctrl.f+lastctrl.b)*.2,0).p) - WS.CurrentCamera.CFrame.p))*speed
			else
				bv.velocity = Vector3.new(0,0,0)
			end

			bg.cframe = WS.CurrentCamera.CFrame * CFrame.Angles(-math.rad((ctrl.f+ctrl.b)*50*speed/maxspeed),0,0)
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




for i = 1, 20 do
	local slot = Instance.new("Frame")
	slot.Name = "Slot"..i
	slot.Parent = Scroll
	slot.BackgroundColor3 = Color3.fromRGB(60,60,60)
	slot.BorderSizePixel = 0
	slot.Size = UDim2.new(1, -2, 0, 35)
	slot.LayoutOrder = i
	slot.ClipsDescendants = true
	slot.AutomaticSize = Enum.AutomaticSize.None
	slot.ZIndex = 2

	Instance.new("UICorner", slot).CornerRadius = UDim.new(0,8)

	
	if i == 1 then
		Slots[1] = {
			Frame = slot,
			Type = "Console"
		}
	else
		local content = Instance.new("Frame")
		content.Parent = slot
		content.BackgroundTransparency = 1
		content.Size = UDim2.new(1, -12, 1, 0)
		content.Position = UDim2.fromOffset(6, 0)
		content.ZIndex = 3

		local label = Instance.new("TextLabel")
		label.Parent = content
		label.BackgroundTransparency = 1
		label.Size = UDim2.fromScale(0.7, 1)
		label.Font = Enum.Font.SourceSansBold
		label.TextSize = 18
		label.TextXAlignment = Enum.TextXAlignment.Left
		label.TextColor3 = Color3.fromRGB(220,220,220)
		label.Text = "Slot "..i
		label.ZIndex = 4

		local pill = Instance.new("TextButton")
		pill.Parent = content
		pill.Size = UDim2.fromOffset(36, 18)
		pill.AnchorPoint = Vector2.new(1, 0.5)
		pill.Position = UDim2.fromScale(1, 0.5)
		pill.BackgroundColor3 = Color3.fromRGB(80,80,80)
		pill.Text = ""
		pill.AutoButtonColor = false
		pill.ZIndex = 4
		Instance.new("UICorner", pill).CornerRadius = UDim.new(1, 0)

		local knob = Instance.new("Frame")
		knob.Parent = pill
		knob.Size = UDim2.fromOffset(14, 14)
		knob.Position = UDim2.fromOffset(2, 2)
		knob.BackgroundColor3 = Color3.fromRGB(220,220,220)
		knob.ZIndex = 5
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


local TeleportSlots = {} -- đăng ký slot teleport
local teleportLockedByEscape = false

local function registerTeleportSlot(slot, stopFunction)
	TeleportSlots[slot] = stopFunction
end

local function forceDisableTeleport(slot)
	if not slot.State then return end

	slot.State = false

	slot.Pill.BackgroundColor3 = Color3.fromRGB(80,80,80)
	slot.SlotKnob:TweenPosition(
		UDim2.fromOffset(2,2),
		Enum.EasingDirection.Out,
		Enum.EasingStyle.Quad,
		0.15,
		true
	)

	if TeleportSlots[slot] then
		TeleportSlots[slot]() -- stop logic
	end
end

local function disableAllTeleport(exceptSlot)
	for slot, stopFunc in pairs(TeleportSlots) do
		if slot ~= exceptSlot then
			forceDisableTeleport(slot)
		end
	end
end

local function disableAllTeleportImmediate()
	for slot, _ in pairs(TeleportSlots) do
		forceDisableTeleport(slot)
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
row.Position = UDim2.fromOffset(4, 4)
row.ZIndex = 21
row.ClipsDescendants = false

local layout = Instance.new("UIListLayout")
layout.Parent = row
layout.FillDirection = Enum.FillDirection.Horizontal
layout.VerticalAlignment = Enum.VerticalAlignment.Center
layout.HorizontalAlignment = Enum.HorizontalAlignment.Left
layout.Padding = UDim.new(0, 2)



local yBox = Instance.new("TextBox")
yBox.Parent = row
yBox.Text = "5000000"
yBox.PlaceholderText = "Input Y"
yBox.Size = UDim2.fromOffset(65, 28)
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
spBox.PlaceholderText = "Speed"
spBox.Size = UDim2.fromOffset(65, 28)
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



local waypointspbox = Instance.new("TextBox")
waypointspbox.Parent = row
waypointspbox.Text = "340"
waypointspbox.PlaceholderText = "WP Speed"
waypointspbox.Size = UDim2.fromOffset(65, 28)
waypointspbox.ClearTextOnFocus = false
waypointspbox.Font = Enum.Font.SourceSansBold
waypointspbox.TextSize = 16
waypointspbox.TextXAlignment = Enum.TextXAlignment.Center
waypointspbox.TextYAlignment = Enum.TextYAlignment.Center
waypointspbox.TextColor3 = Color3.fromRGB(230,230,230)
waypointspbox.BackgroundColor3 = Color3.fromRGB(40,40,40)
waypointspbox.BorderSizePixel = 0
waypointspbox.LayoutOrder = 3
waypointspbox.ZIndex = 22

local waypointspCorner = Instance.new("UICorner")
waypointspCorner.CornerRadius = UDim.new(0,6)
waypointspCorner.Parent = waypointspbox



waypointspbox:GetPropertyChangedSignal("Text"):Connect(function()
	local text = waypointspbox.Text

	text = text:gsub("%D", "")

	if text == "" then
		waypointspbox.Text = ""
		return
	end

	local num = tonumber(text)
	if not num then
		waypointspbox.Text = ""
		return
	end

	if num > MAX_INPUT_VALUE then
		num = MAX_INPUT_VALUE
	end

	local fixed = tostring(math.floor(num))
	if waypointspbox.Text ~= fixed then
		waypointspbox.Text = fixed
	end
end)



local function readWaypointSpeed()
	local sp = tonumber(waypointspbox.Text)
	if not sp or sp <= 0 then
		sp = 1
	end
	return sp
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





local slot4 = Slots[4]
slot4.Label.Text = "Bypass Tween"
slot4.State = true
slot4.Pill.BackgroundColor3 = Color3.fromRGB(120,200,120)
slot4.SlotKnob.Position = UDim2.fromOffset(20,2)

slot4.Pill.MouseButton1Click:Connect(function()
	slot4.State = not slot4.State
	Settings.BypassTween = slot4.State

	if slot4.State then
		slot4.Pill.BackgroundColor3 = Color3.fromRGB(120,200,120)
		slot4.SlotKnob:TweenPosition(
			UDim2.fromOffset(20,2),
			Enum.EasingDirection.Out,
			Enum.EasingStyle.Quad,
			0.15,
			true
		)
	else
		slot4.Pill.BackgroundColor3 = Color3.fromRGB(80,80,80)
		slot4.SlotKnob:TweenPosition(
			UDim2.fromOffset(2,2),
			Enum.EasingDirection.Out,
			Enum.EasingStyle.Quad,
			0.15,
			true
		)
	end
end)


local function forceMoveY(hrp, targetY, speed, dt)
	hrp.AssemblyLinearVelocity =
		Vector3.new(
			hrp.AssemblyLinearVelocity.X,
			0,
			hrp.AssemblyLinearVelocity.Z
		)

	local pos = hrp.Position
	local diff = targetY - pos.Y

	local maxStep = speed * dt
	if diff > maxStep then
		diff = maxStep
	elseif diff < -maxStep then
		diff = -maxStep
	end

	hrp.CFrame =
		CFrame.new(pos.X, pos.Y + diff, pos.Z)
		* hrp.CFrame.Rotation
end


local function startEscape()
	local char = Players.LocalPlayer.Character
	if not char then return end

	local hrp = char:FindFirstChild("HumanoidRootPart")
	if not hrp then return end

	local targetY, speed = readSlot1Config()
	if not targetY or not speed then return end

	
	if Settings.BypassTween then
		if escapeMoveConn then
			escapeMoveConn:Disconnect()
			escapeMoveConn = nil
		end

		local cf = hrp.CFrame
		hrp.CFrame = CFrame.new(
			cf.Position.X,
			targetY,
			cf.Position.Z
		) * cf.Rotation
		return
	end

	if escapeMoveConn then return end

	escapeMoveConn = RunService.Heartbeat:Connect(function(dt)
		if not escapeEnabled or not escapeActive or Settings.BypassTween then
			return
		end

		if not hrp.Parent then
			return
		end

		local ty, sp = readSlot1Config()
		if not ty or not sp then return end

		forceMoveY(hrp, ty, sp, dt)
	end)
end

local function stopEscape()
	if escapeMoveConn then
		escapeMoveConn:Disconnect()
		escapeMoveConn = nil
	end
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
end


local function StopVertical()
	upEnabled = false
	stopUpTextVisual()
end

magiskk.StopVertical = StopVertical


toggle.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
flyKnob.Position = UDim2.fromOffset(2, 2)

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
	if not escapeEnabled then
		escapeActive = false
		stopEscape()
		return
	end

	local hp = getHealthPercent()

-- HP THẤP → kích hoạt escape + lock teleport
if hp < ESCAPE_HP_LOW then
	
	if not escapeActive then
		escapeActive = true
	end

	if not teleportLockedByEscape then
		teleportLockedByEscape = true
		disableAllTeleportImmediate()
	end

-- HP CAO → tắt escape + mở lock
elseif hp > ESCAPE_HP_HIGH then
	
	if escapeActive then
		stopEscape()
	end

	escapeActive = false
	teleportLockedByEscape = false
end

-- Nếu escape đang active thì chạy
if escapeActive then
	startEscape()
end

local upMoveConn = nil

local function startUp()
	if upEnabled then return end
	upEnabled = true
	startUpTextVisual()

	if upMoveConn then
		upMoveConn:Disconnect()
	end

	upMoveConn = RunService.Heartbeat:Connect(function(dt)
		if not upEnabled then return end

		local char = Players.LocalPlayer.Character
		if not char then return end
		local hrp = char:FindFirstChild("HumanoidRootPart")
		if not hrp then return end

		local targetY = tonumber(yBox.Text)
		local speed   = tonumber(spBox.Text)
		if not targetY or not speed then return end

		forceMoveY(hrp, targetY, speed, dt)
	end)
end


local function stopUp()
	upEnabled = false
	stopUpTextVisual()

	if upMoveConn then
		upMoveConn:Disconnect()
		upMoveConn = nil
	end
end



up.MouseButton1Click:Connect(function()
	if upEnabled then
		stopUp()
	else
		startUp()
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
row3.Position = UDim2.fromOffset(4, 4)
row3.BackgroundTransparency = 1
row3.ZIndex = 20

local rowLayout = Instance.new("UIListLayout")
rowLayout.Parent = row3
rowLayout.FillDirection = Enum.FillDirection.Horizontal
rowLayout.VerticalAlignment = Enum.VerticalAlignment.Center
rowLayout.Padding = UDim.new(0, 2)

local SLOT3MIN_TWEEN_Y = 30
local SLOT3MAX_TWEEN_Y = 2000000000

local slot3Input = Instance.new("TextBox")
slot3Input.Parent = row3

slot3Input.Size = UDim2.fromOffset(110, 28)

slot3Input.Text = "500000"
slot3Input.PlaceholderText = "Input Y"
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
slot3UpBtn.Size = UDim2.fromOffset(42, 28)
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
slot3DownBtn.Size = UDim2.fromOffset(42, 28)
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




local slot5 = Slots[5]
slot5.Label.Text = "Waypoint"
slot5.State = false
slot5.Frame.ClipsDescendants = true


local row5 = Instance.new("Frame")
row5.Parent = slot5.Frame
row5.Size = UDim2.new(1, -12, 1, -8)
row5.Position = UDim2.fromOffset(4, 4)
row5.BackgroundTransparency = 1
row5.ZIndex = 20

local layout5 = Instance.new("UIListLayout")
layout5.Parent = row5
layout5.FillDirection = Enum.FillDirection.Horizontal
layout5.VerticalAlignment = Enum.VerticalAlignment.Center
layout5.Padding = UDim.new(0, 2)


local wpBox = Instance.new("TextBox")
wpBox.Parent = row5
wpBox.Size = UDim2.fromOffset(110, 28)
wpBox.Text = ""
wpBox.PlaceholderText = "X, Y, Z"

wpBox.ClearTextOnFocus = false
wpBox.TextWrapped = false
wpBox.TextTruncate = Enum.TextTruncate.AtEnd
wpBox.TextEditable = true
wpBox.Active = true
wpBox.Selectable = true

wpBox.Font = Enum.Font.SourceSansBold
wpBox.TextSize = 14
wpBox.TextXAlignment = Enum.TextXAlignment.Center
wpBox.TextYAlignment = Enum.TextYAlignment.Center
wpBox.TextColor3 = Color3.fromRGB(230,230,230)
wpBox.BackgroundColor3 = Color3.fromRGB(40,40,40)
wpBox.BorderSizePixel = 0
wpBox.ZIndex = 21

Instance.new("UICorner", wpBox).CornerRadius = UDim.new(0,6)

local saveBtn = Instance.new("TextButton")
saveBtn.Parent = row5
saveBtn.Size = UDim2.fromOffset(42, 28)
saveBtn.Text = "Save"
saveBtn.Font = Enum.Font.SourceSansBold
saveBtn.TextSize = 14
saveBtn.TextColor3 = Color3.fromRGB(0,0,0)
saveBtn.BackgroundColor3 = Color3.fromRGB(120,200,120)
saveBtn.BorderSizePixel = 0
saveBtn.ZIndex = 21

Instance.new("UICorner", saveBtn).CornerRadius = UDim.new(0,6)


local function formatPos(v)
	return string.format(
		"%d , %d , %d",
		math.floor(v.X),
		math.floor(v.Y),
		math.floor(v.Z)
	)
end


local function parseWPBoxText(text)
	if not text then return end

	text = text:gsub("%s+", "")

	local x, y, z = text:match("^(-?%d+%.?%d*),(-?%d+%.?%d*),(-?%d+%.?%d*)$")
	if not x then return end

	return CFrame.new(
		tonumber(x),
		tonumber(y),
		tonumber(z)
	)
end

local WPBOX_OK_COLOR = Color3.fromRGB(40,40,40)
local WPBOX_ERR_COLOR = Color3.fromRGB(120,40,40)

wpBox:GetPropertyChangedSignal("Text"):Connect(function()
	if wpBox.Text == "" then
		wpBox.BackgroundColor3 = WPBOX_OK_COLOR
		return
	end

	local cf = parseWPBoxText(wpBox.Text)
	if not cf then
		wpBox.BackgroundColor3 = WPBOX_ERR_COLOR
		return
	end

	wpBox.BackgroundColor3 = WPBOX_OK_COLOR
	waypointCF = cf
end)

saveBtn.MouseButton1Click:Connect(function()
	local char = LocalPlayer.Character
	local hrp = char and char:FindFirstChild("HumanoidRootPart")
	if not hrp then return end

	waypointCF = hrp.CFrame
	wpBox.Text = formatPos(hrp.Position)
end)



local function lockWPBox(state)
	wpBox.TextEditable = not state
	wpBox.Active = not state
	wpBox.Selectable = not state
	wpBox.AutoLocalize = false

	if state then
		wpBox.TextColor3 = Color3.fromRGB(150,150,150)
	else
		wpBox.TextColor3 = Color3.fromRGB(230,230,230)
	end
end




local function forceMoveToWaypoint(hrp, targetCF, speed, dt)
	
	hrp.AssemblyLinearVelocity = Vector3.zero
	hrp.AssemblyAngularVelocity = Vector3.zero

	local pos = hrp.Position
	local targetPos = targetCF.Position

	local delta = targetPos - pos
	local dist = delta.Magnitude

	if dist < 0.05 then
		hrp.CFrame = CFrame.new(targetPos) * hrp.CFrame.Rotation
		return
	end

	local step = math.min(dist, speed * dt)
	local newPos = pos + delta.Unit * step

	hrp.CFrame = CFrame.new(newPos) * hrp.CFrame.Rotation
end

local function startWaypoint()
	if waypointMoveConn then return end
	if not waypointCF then return end

	waypointActive = true

	waypointMoveConn = RunService.Stepped:Connect(function(_, dt)
		if not waypointActive or not waypointCF then return end

		local char = LocalPlayer.Character
		local hrp = char and char:FindFirstChild("HumanoidRootPart")
		if not hrp then return end

		local speed = readWaypointSpeed()
		forceMoveToWaypoint(hrp, waypointCF, speed, dt)
	end)
end

local function stopWaypoint()
	waypointActive = false

	if waypointMoveConn then
		waypointMoveConn:Disconnect()
		waypointMoveConn = nil
	end
end





slot5.Pill.MouseButton1Click:Connect(function()
	slot5.State = not slot5.State

	if slot5.State then
		slot5.Pill.BackgroundColor3 = Color3.fromRGB(120,200,120)
		slot5.SlotKnob:TweenPosition(
			UDim2.fromOffset(20,2),
			Enum.EasingDirection.Out,
			Enum.EasingStyle.Quad,
			0.15,
			true
		)
      lockWPBox(true)
		addNoclipUser()
startWaypoint()
      

	else
		slot5.Pill.BackgroundColor3 = Color3.fromRGB(80,80,80)
		slot5.SlotKnob:TweenPosition(
			UDim2.fromOffset(2,2),
			Enum.EasingDirection.Out,
			Enum.EasingStyle.Quad,
			0.15,
			true
		)
      lockWPBox(false)
		removeNoclipUser()
stopWaypoint()
	end
end)



local slot6 = Slots[6]
slot6.Label.Text = "System"
slot6.State = false
slot6.Frame.ClipsDescendants = true
slot6.Pill.Visible = false


local row6 = Instance.new("Frame")
row6.Parent = slot6.Frame
row6.Size = UDim2.new(1, -12, 1, -8)
row6.Position = UDim2.fromOffset(4, 4)
row6.BackgroundTransparency = 1
row6.ZIndex = 20

local layout6 = Instance.new("UIListLayout")
layout6.Parent = row6
layout6.FillDirection = Enum.FillDirection.Horizontal
layout6.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout6.VerticalAlignment = Enum.VerticalAlignment.Center
layout6.Padding = UDim.new(0, 2)


local function attachConfirmLogic(btn, normal, hover, down, action)
	local CONFIRM_BG = Color3.fromRGB(0,0,0)
	local CONFIRM_TXT = Color3.fromRGB(255,255,255)

	local lastClick = 0
	local confirming = false

	local function resetVisual()
		btn.BackgroundColor3 = normal
		btn.TextColor3 = Color3.fromRGB(240,240,240)
		confirming = false
	end

	btn.BackgroundColor3 = normal
	btn.TextColor3 = Color3.fromRGB(240,240,240)

	btn.MouseEnter:Connect(function()
		if not confirming then
			btn.BackgroundColor3 = hover
		end
	end)

	btn.MouseLeave:Connect(function()
		if not confirming then
			btn.BackgroundColor3 = normal
		end
	end)

	btn.MouseButton1Down:Connect(function()
		if not confirming then
			btn.BackgroundColor3 = down
		end
	end)

	btn.MouseButton1Click:Connect(function()
		local now = tick()

		
		if now - lastClick <= 1 then
			lastClick = 0
			resetVisual()
			action()
			return
		end

		
		lastClick = now
		confirming = true
		btn.BackgroundColor3 = CONFIRM_BG
		btn.TextColor3 = CONFIRM_TXT

		task.delay(1, function()
			if tick() - lastClick >= 1 then
				resetVisual()
			end
		end)
	end)
end


local resetBtn = Instance.new("TextButton")
resetBtn.Parent = row6
resetBtn.Size = UDim2.fromOffset(65, 28)
resetBtn.Text = "Reset"
resetBtn.AutoButtonColor = false
resetBtn.Font = Enum.Font.SourceSansBold
resetBtn.TextSize = 14
resetBtn.BorderSizePixel = 0
resetBtn.ZIndex = 21
Instance.new("UICorner", resetBtn).CornerRadius = UDim.new(0,6)

attachConfirmLogic(
	resetBtn,
	Color3.fromRGB(70,180,120),
	Color3.fromRGB(90,200,140),
	Color3.fromRGB(50,150,100),
	function()
		local char = LocalPlayer.Character
		local hum = char and char:FindFirstChildOfClass("Humanoid")
		if hum then
			hum.Health = 0
		end
	end
)


local rejoinBtn = Instance.new("TextButton")
rejoinBtn.Parent = row6
rejoinBtn.Size = UDim2.fromOffset(65, 28)
rejoinBtn.Text = "Rejoin"
rejoinBtn.AutoButtonColor = false
rejoinBtn.Font = Enum.Font.SourceSansBold
rejoinBtn.TextSize = 14
rejoinBtn.BorderSizePixel = 0
rejoinBtn.ZIndex = 21
Instance.new("UICorner", rejoinBtn).CornerRadius = UDim.new(0,6)

attachConfirmLogic(
	rejoinBtn,
	Color3.fromRGB(80,140,200),
	Color3.fromRGB(100,160,220),
	Color3.fromRGB(60,120,180),
	function()
		game:GetService("TeleportService")
			:Teleport(game.PlaceId, LocalPlayer)
	end
)


local leaveBtn = Instance.new("TextButton")
leaveBtn.Parent = row6
leaveBtn.Size = UDim2.fromOffset(65, 28)
leaveBtn.Text = "Leave"
leaveBtn.AutoButtonColor = false
leaveBtn.Font = Enum.Font.SourceSansBold
leaveBtn.TextSize = 14
leaveBtn.BorderSizePixel = 0
leaveBtn.ZIndex = 21
Instance.new("UICorner", leaveBtn).CornerRadius = UDim.new(0,6)

attachConfirmLogic(
	leaveBtn,
	Color3.fromRGB(200,80,80),
	Color3.fromRGB(220,100,100),
	Color3.fromRGB(170,60,60),
	function()
		game:Shutdown()
	end
)

pcall(function()
 

local slot7 = Slots[7]
slot7.Label.Text = "Virtual Foundation"
slot7.State = false
slot7.Frame.ClipsDescendants = true






local function startLockY()
	if lockYConn then return end

	local char = LocalPlayer.Character
	local hrp = char and char:FindFirstChild("HumanoidRootPart")
	if not hrp then return end

	lockedY = hrp.Position.Y - 3

	virtualFloor = Instance.new("Part")
	virtualFloor.Size = Vector3.new(30, 6, 30)
	virtualFloor.Anchored = true
	virtualFloor.CanCollide = true
	virtualFloor.Transparency = 1
	virtualFloor.Name = "VirtualFloor"
	virtualFloor.Parent = workspace

	lockYConn = RunService.Stepped:Connect(function()
	if not slot7.State then return end

	local char = LocalPlayer.Character
	local hrp = char and char:FindFirstChild("HumanoidRootPart")
	if not hrp then return end
	if not virtualFloor then return end

	virtualFloor.CFrame = CFrame.new(
		hrp.Position.X,
		lockedY - (virtualFloor.Size.Y / 2),
		hrp.Position.Z
	)

	local pos = hrp.Position

	
	if pos.Y < lockedY - 0.1 then
		local vel = hrp.AssemblyLinearVelocity
		
		
		hrp.AssemblyLinearVelocity = Vector3.new(vel.X, 0, vel.Z)

		hrp.CFrame =
			CFrame.new(pos.X, lockedY, pos.Z)
			* hrp.CFrame.Rotation
	end
end)
end

local function stopLockY()
	if lockYConn then
		lockYConn:Disconnect()
		lockYConn = nil
	end

	if virtualFloor then
		virtualFloor:Destroy()
		virtualFloor = nil
	end
end

slot7.Pill.MouseButton1Click:Connect(function()
	slot7.State = not slot7.State

	if slot7.State then
		slot7.Pill.BackgroundColor3 = Color3.fromRGB(120,200,120)
		slot7.SlotKnob:TweenPosition(

			UDim2.fromOffset(20,2),
			Enum.EasingDirection.Out,
			Enum.EasingStyle.Quad,
			0.15,
			true
		)
		startLockY()
	else
		slot7.Pill.BackgroundColor3 = Color3.fromRGB(80,80,80)
		slot7.SlotKnob:TweenPosition(
			UDim2.fromOffset(2,2),
			Enum.EasingDirection.Out,
			Enum.EasingStyle.Quad,
			0.15,
			true
		)
		stopLockY()
	end
end)
end)


local slot8 = Slots[8]
slot8.Label.Text = "Infinity Jump"
slot8.State = false
slot8.Frame.ClipsDescendants = true


local function startInfinityJump()
	if infJumpConn then return end

	infJumpConn = UserInputService.JumpRequest:Connect(function()
		if not slot8.State then return end

		local char = LocalPlayer.Character
		local hum = char and char:FindFirstChildOfClass("Humanoid")
		if not hum then return end

		hum:ChangeState(Enum.HumanoidStateType.Jumping)
	end)
end


local function stopInfinityJump()
	if infJumpConn then
		infJumpConn:Disconnect()
		infJumpConn = nil
	end
end


slot8.Pill.MouseButton1Click:Connect(function()
	slot8.State = not slot8.State

	if slot8.State then
		slot8.Pill.BackgroundColor3 = Color3.fromRGB(120,200,120)
		slot8.SlotKnob:TweenPosition(
			UDim2.fromOffset(20,2),
			Enum.EasingDirection.Out,
			Enum.EasingStyle.Quad,
			0.15,
			true
		)

		startInfinityJump()
	else
		slot8.Pill.BackgroundColor3 = Color3.fromRGB(80,80,80)
		slot8.SlotKnob:TweenPosition(
			UDim2.fromOffset(2,2),
			Enum.EasingDirection.Out,
			Enum.EasingStyle.Quad,
			0.15,
			true
		)

		stopInfinityJump()
	end
end)






local slot9 = Slots[9]
slot9.Label.Text = "Speed Force"
slot9.State = false
slot9.Frame.ClipsDescendants = true


local row9 = Instance.new("Frame")
row9.Parent = slot9.Frame
row9.Size = UDim2.new(1, -12, 1, -8)
row9.Position = UDim2.fromOffset(110, 4)
row9.BackgroundTransparency = 1
row9.ZIndex = 20

local layout9 = Instance.new("UIListLayout")
layout9.Parent = row9
layout9.FillDirection = Enum.FillDirection.Horizontal
layout9.VerticalAlignment = Enum.VerticalAlignment.Center
layout9.Padding = UDim.new(0, 1)



local speedBox = Instance.new("TextBox")
speedBox.Parent = row9
speedBox.Size = UDim2.fromOffset(50, 28)
speedBox.Text = "300"
speedBox.PlaceholderText = "Speed"
speedBox.ClearTextOnFocus = false
speedBox.TextEditable = true
speedBox.Active = true
speedBox.Selectable = true
speedBox.Font = Enum.Font.SourceSansBold
speedBox.TextSize = 14
speedBox.TextXAlignment = Enum.TextXAlignment.Center
speedBox.TextColor3 = Color3.fromRGB(200,200,200)
speedBox.BackgroundColor3 = Color3.fromRGB(40,40,40)
speedBox.BorderSizePixel = 0
speedBox.ZIndex = 21
speedBox.LayoutOrder = 1
Instance.new("UICorner", speedBox).CornerRadius = UDim.new(0,6)



local MIN_SPEED = 1
local MAX_SPEED = 1000

local function readSpeed()
	local num = tonumber(speedBox.Text)
	if not num then return MIN_SPEED end

	num = math.clamp(math.floor(num), MIN_SPEED, MAX_SPEED)
	return num
end

speedBox:GetPropertyChangedSignal("Text"):Connect(function()
	local filtered = speedBox.Text:gsub("%D","")
	if filtered == "" then
		speedBox.Text = ""
		return
	end

	local num = math.clamp(tonumber(filtered), MIN_SPEED, MAX_SPEED)
	speedBox.Text = tostring(num)
end)


local function startSpeed()
	if speedConn then return end

	speedConn = RunService.Heartbeat:Connect(function()
		if not slot9.State then return end

		local char = LocalPlayer.Character
		local hum = char and char:FindFirstChildOfClass("Humanoid")
		local hrp = char and char:FindFirstChild("HumanoidRootPart")
		if not hum or not hrp then return end

		local moveDir = hum.MoveDirection
		local vel = hrp.AssemblyLinearVelocity

		if moveDir.Magnitude > 0 then
			local speed = readSpeed()

			local targetX = moveDir.X * speed
			local targetZ = moveDir.Z * speed

			hrp.AssemblyLinearVelocity = Vector3.new(
				vel.X + (targetX - vel.X) * accel,
				vel.Y, -- giữ gravity
				vel.Z + (targetZ - vel.Z) * accel
			)
		else
			-- giảm dần khi thả phím (không trượt)
			hrp.AssemblyLinearVelocity = Vector3.new(
				vel.X * 0.8,
				vel.Y,
				vel.Z * 0.8
			)
		end
	end)
end


local function stopSpeed()
	if speedConn then
		speedConn:Disconnect()
		speedConn = nil
	end
end




slot9.Pill.MouseButton1Click:Connect(function()
	slot9.State = not slot9.State

	if slot9.State then
		slot9.Pill.BackgroundColor3 = Color3.fromRGB(120,200,120)
		slot9.SlotKnob:TweenPosition(
			UDim2.fromOffset(20,2),
			Enum.EasingDirection.Out,
			Enum.EasingStyle.Quad,
			0.15,
			true
		)

		startSpeed()
	else
		slot9.Pill.BackgroundColor3 = Color3.fromRGB(80,80,80)
		slot9.SlotKnob:TweenPosition(
			UDim2.fromOffset(2,2),
			Enum.EasingDirection.Out,
			Enum.EasingStyle.Quad,
			0.15,
			true
		)

		stopSpeed()
	end
end)



local slot10 = Slots[10]
slot10.Label.Text = "Jump Force"
slot10.State = false
slot10.Frame.ClipsDescendants = true


local row10 = Instance.new("Frame")
row10.Parent = slot10.Frame
row10.Size = UDim2.new(1, -12, 1, -8)
row10.Position = UDim2.fromOffset(110, 4)
row10.BackgroundTransparency = 1
row10.ZIndex = 20

local layout10 = Instance.new("UIListLayout")
layout10.Parent = row10
layout10.FillDirection = Enum.FillDirection.Horizontal
layout10.VerticalAlignment = Enum.VerticalAlignment.Center
layout10.Padding = UDim.new(0, 1)

local jumpBox = Instance.new("TextBox")
jumpBox.Parent = row10
jumpBox.Size = UDim2.fromOffset(50, 28)
jumpBox.Text = "120"
jumpBox.PlaceholderText = "Jump"
jumpBox.ClearTextOnFocus = false
jumpBox.TextEditable = true
jumpBox.Active = true
jumpBox.Selectable = true
jumpBox.Font = Enum.Font.SourceSansBold
jumpBox.TextSize = 14
jumpBox.TextXAlignment = Enum.TextXAlignment.Center
jumpBox.TextColor3 = Color3.fromRGB(200,200,200)
jumpBox.BackgroundColor3 = Color3.fromRGB(40,40,40)
jumpBox.BorderSizePixel = 0
jumpBox.ZIndex = 21

Instance.new("UICorner", jumpBox).CornerRadius = UDim.new(0,6)



local MIN_JUMP = 1
local MAX_JUMP = 1000

local function readJump()
	local num = tonumber(jumpBox.Text)
	if not num then return MIN_JUMP end
	num = math.clamp(math.floor(num), MIN_JUMP, MAX_JUMP)
	return num
end

jumpBox:GetPropertyChangedSignal("Text"):Connect(function()
	local filtered = jumpBox.Text:gsub("%D","")
	if filtered == "" then
		jumpBox.Text = ""
		return
	end

	local num = math.clamp(tonumber(filtered), MIN_JUMP, MAX_JUMP)
	jumpBox.Text = tostring(num)
end)





local function startJumpBoost()
	if jumpConn then return end

	local char = LocalPlayer.Character
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	local hrp = char and char:FindFirstChild("HumanoidRootPart")
	if not hum or not hrp then return end

	hum.UseJumpPower = false

	
	jumpConn = hum.Jumping:Connect(function(active)
		if not slot10.State then return end
		if not active then return end

		local power = readJump()

		local vel = hrp.AssemblyLinearVelocity
		hrp.AssemblyLinearVelocity = Vector3.new(
			vel.X,
			power,
			vel.Z
		)
	end)

	
	landConn = hum.StateChanged:Connect(function(_, newState)
		if not slot10.State then return end

		if newState == Enum.HumanoidStateType.Landed then
			local vel = hrp.AssemblyLinearVelocity

			
			if vel.Y > 0 then
				hrp.AssemblyLinearVelocity = Vector3.new(
					vel.X,
					0,
					vel.Z
				)
			end
		end
	end)
end


local function stopJumpBoost()
	if jumpConn then
		jumpConn:Disconnect()
		jumpConn = nil
	end

	if landConn then
		landConn:Disconnect()
		landConn = nil
	end
end


slot10.Pill.MouseButton1Click:Connect(function()
	slot10.State = not slot10.State

	if slot10.State then
		slot10.Pill.BackgroundColor3 = Color3.fromRGB(120,200,120)
		slot10.SlotKnob:TweenPosition(
			UDim2.fromOffset(20,2),
			Enum.EasingDirection.Out,
			Enum.EasingStyle.Quad,
			0.15,
			true
		)

		startJumpBoost()
	else
		slot10.Pill.BackgroundColor3 = Color3.fromRGB(80,80,80)
		slot10.SlotKnob:TweenPosition(
			UDim2.fromOffset(2,2),
			Enum.EasingDirection.Out,
			Enum.EasingStyle.Quad,
			0.15,
			true
		)

		stopJumpBoost()
	end
end)









local slot11 = Slots[11]
slot11.Label.Text = "Player List"
slot11.State = false
slot11.Frame.ClipsDescendants = false
slot11.Pill.Visible = false
slot11.SlotKnob.Visible = false

slot11.Label.Size = UDim2.new(1, -30, 1, 0)
slot11.Label.TextXAlignment = Enum.TextXAlignment.Left

local arrowIcon = Instance.new("ImageLabel")
arrowIcon.Parent = slot11.Frame
arrowIcon.Size = UDim2.fromOffset(18,18)
arrowIcon.AnchorPoint = Vector2.new(1,0.5)
arrowIcon.Position = UDim2.new(1,-8,0.5,0)
arrowIcon.BackgroundTransparency = 1
arrowIcon.Image = "rbxassetid://6034818372"
arrowIcon.Rotation = -90 -- ▶
arrowIcon.ScaleType = Enum.ScaleType.Fit
arrowIcon.ZIndex = 50

local clickArea = Instance.new("TextButton")
clickArea.Parent = slot11.Frame
clickArea.Size = UDim2.new(1,0,1,0)
clickArea.BackgroundTransparency = 1
clickArea.Text = ""
clickArea.AutoButtonColor = false
clickArea.ZIndex = 40



local PlayerListFrame = Instance.new("Frame")
PlayerListFrame.Parent = SettingsGui
PlayerListFrame.Size = UDim2.fromOffset(180,184)
PlayerListFrame.BackgroundColor3 = Color3.fromRGB(35,35,35)
PlayerListFrame.BorderSizePixel = 0
PlayerListFrame.Visible = false
PlayerListFrame.ZIndex = 200
Instance.new("UICorner", PlayerListFrame).CornerRadius = UDim.new(0,8)

local PlayerScroll = Instance.new("ScrollingFrame")
PlayerScroll.Parent = PlayerListFrame
PlayerScroll.Position = UDim2.new(0,6,0,6)
PlayerScroll.Size = UDim2.new(1,-12,1,-12)
PlayerScroll.CanvasSize = UDim2.new(0,0,0,0)
PlayerScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
PlayerScroll.ScrollBarThickness = 4
PlayerScroll.BackgroundTransparency = 1
PlayerScroll.BorderSizePixel = 0
PlayerScroll.ZIndex = 201

local layout = Instance.new("UIListLayout")
layout.Parent = PlayerScroll
layout.Padding = UDim.new(0,4)

layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	PlayerScroll.CanvasSize = UDim2.new(
		0,0,
		0,layout.AbsoluteContentSize.Y + 4
	)
end)




local function selectPlayer(plr, btn)

	if selectedButton then
		selectedButton.BackgroundColor3 = Color3.fromRGB(60,60,60)
	end

	selectedButton = btn
	selectedPlayer = plr

	btn.BackgroundColor3 = Color3.fromRGB(90,120,255) -- màu highlight
end


local function addPlayer(plr)

    if plr == LocalPlayer then
        return
    end


	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1,-4,0,28)
   btn.Text = plr.DisplayName .. " (@" .. plr.Name .. ")"
	btn.Font = Enum.Font.SourceSansBold
	btn.TextSize = 14
	btn.BackgroundColor3 = Color3.fromRGB(60,60,60)
	btn.TextColor3 = Color3.fromRGB(230,230,230)
	btn.BorderSizePixel = 0
	btn.Parent = PlayerScroll
   btn.ZIndex = 202

	Instance.new("UICorner", btn).CornerRadius = UDim.new(0,6)

	btn.MouseButton1Click:Connect(function()
		selectPlayer(plr, btn)
		print("Selected:", plr.Name)
	end)

	playerButtons[plr] = btn
end



local function removePlayer(plr)

	if playerButtons[plr] then
		
		
		if selectedPlayer == plr then
			selectedPlayer = nil
			selectedButton = nil
		end

		playerButtons[plr]:Destroy()
		playerButtons[plr] = nil
	end
end


for _, plr in ipairs(game.Players:GetPlayers()) do
	addPlayer(plr)
end

game.Players.PlayerAdded:Connect(addPlayer)
game.Players.PlayerRemoving:Connect(removePlayer)


local function updatePlayerListPosition()

    local abs = DragFrame.AbsolutePosition
    local Y_OFFSET = 56

    local x = abs.X - PlayerListFrame.Size.X.Offset - 1
    local y = abs.Y + Y_OFFSET

    if x < 0 then
        x = abs.X + DragFrame.AbsoluteSize.X + 1
    end

    PlayerListFrame.Position = UDim2.fromOffset(x, y)
end


DragFrame:GetPropertyChangedSignal("AbsolutePosition"):Connect(updatePlayerListPosition)

clickArea.MouseButton1Click:Connect(function()

	slot11.State = not slot11.State

	if slot11.State then
		updatePlayerListPosition()
		PlayerListFrame.Visible = true
		arrowIcon.Rotation = 90 -- ◀
	else
		PlayerListFrame.Visible = false
		arrowIcon.Rotation = -90 -- ▶
	end

end)




local slot12 = Slots[12]
slot12.Label.Text = "Teleport Player"
slot12.State = false
slot12.Frame.ClipsDescendants = true


local row12 = Instance.new("Frame")
row12.Parent = slot12.Frame
row12.Size = UDim2.new(1, -12, 1, -8)
row12.Position = UDim2.fromOffset(110, 4)
row12.BackgroundTransparency = 1
row12.ZIndex = 20

local layout12 = Instance.new("UIListLayout")
layout12.Parent = row12
layout12.FillDirection = Enum.FillDirection.Horizontal
layout12.VerticalAlignment = Enum.VerticalAlignment.Center
layout12.Padding = UDim.new(0, 1)



local teleportSpeedBox = Instance.new("TextBox")
teleportSpeedBox.Parent = row12
teleportSpeedBox.Size = UDim2.fromOffset(50, 28)
teleportSpeedBox.Text = "350"
teleportSpeedBox.PlaceholderText = "Speed TP"
teleportSpeedBox.ClearTextOnFocus = false
teleportSpeedBox.TextEditable = true
teleportSpeedBox.Active = true
teleportSpeedBox.Selectable = true
teleportSpeedBox.Font = Enum.Font.SourceSansBold
teleportSpeedBox.TextSize = 14
teleportSpeedBox.TextXAlignment = Enum.TextXAlignment.Center
teleportSpeedBox.TextColor3 = Color3.fromRGB(200,200,200)
teleportSpeedBox.BackgroundColor3 = Color3.fromRGB(40,40,40)
teleportSpeedBox.BorderSizePixel = 0
teleportSpeedBox.ZIndex = 21
teleportSpeedBox.LayoutOrder = 1
Instance.new("UICorner", teleportSpeedBox).CornerRadius = UDim.new(0,6)


local MIN_TELEPORT_PLAYER_SPEED = 1
local MAX_TELEPORT_PLAYER_SPEED = 10000


local function readTeleportSpeed()
	local num = tonumber(teleportSpeedBox.Text)
	if not num then 
		return MIN_TELEPORT_PLAYER_SPEED 
	end

	num = math.clamp(math.floor(num),
		MIN_TELEPORT_PLAYER_SPEED,
		MAX_TELEPORT_PLAYER_SPEED
	)

	return num
end


teleportSpeedBox:GetPropertyChangedSignal("Text"):Connect(function()

	local filtered = teleportSpeedBox.Text:gsub("%D","")

	if filtered == "" then
		teleportSpeedBox.Text = ""
		return
	end

	local num = math.clamp(
		tonumber(filtered),
		MIN_TELEPORT_PLAYER_SPEED,
		MAX_TELEPORT_PLAYER_SPEED
	)

	teleportSpeedBox.Text = tostring(num)
end)



local function forceMoveToPlayer(hrp, targetCF, speed, dt)

	hrp.AssemblyLinearVelocity = Vector3.zero
	hrp.AssemblyAngularVelocity = Vector3.zero

	local pos = hrp.Position
	local targetPos = targetCF.Position

	local delta = targetPos - pos
	local dist = delta.Magnitude

	if dist < 0.05 then
		hrp.CFrame = CFrame.new(targetPos) * hrp.CFrame.Rotation
		return
	end

	local step = math.min(dist, speed * dt)
	local newPos = pos + delta.Unit * step

	hrp.CFrame = CFrame.new(newPos) * hrp.CFrame.Rotation
end

local function startTeleportToPlayer()

	if teleportMoveConn then return end
	if not selectedPlayer then return end

	teleportActive = true

	teleportMoveConn = RunService.Stepped:Connect(function(_, dt)

		if not teleportActive then return end
		if not selectedPlayer then return end

		local char = LocalPlayer.Character
		local targetChar = selectedPlayer.Character

		if not char or not targetChar then return end

		local hrp = char:FindFirstChild("HumanoidRootPart")
		local targetHRP = targetChar:FindFirstChild("HumanoidRootPart")

		if not hrp or not targetHRP then return end

		local speed = readTeleportSpeed()

		forceMoveToPlayer(hrp, targetHRP.CFrame, speed, dt)

	end)
end


local function stopTeleportToPlayer()

	teleportActive = false

	if teleportMoveConn then
		teleportMoveConn:Disconnect()
		teleportMoveConn = nil
	end

end


slot12.Pill.MouseButton1Click:Connect(function()

	slot12.State = not slot12.State

	if slot12.State then
		
		slot12.Pill.BackgroundColor3 = Color3.fromRGB(120,200,120)
		slot12.SlotKnob:TweenPosition(
			UDim2.fromOffset(20,2),
			Enum.EasingDirection.Out,
			Enum.EasingStyle.Quad,
			0.15,
			true
		)

		addNoclipUser()
startTeleportToPlayer()

	else
		
		slot12.Pill.BackgroundColor3 = Color3.fromRGB(80,80,80)
		slot12.SlotKnob:TweenPosition(
			UDim2.fromOffset(2,2),
			Enum.EasingDirection.Out,
			Enum.EasingStyle.Quad,
			0.15,
			true
		)

		removeNoclipUser()
stopTeleportToPlayer()

	end

end)



local slot15 = Slots[15]
slot15.Label.Text = "Player ESP"
slot15.State = false
slot15.Frame.ClipsDescendants = true


local espConnections = {}
local espObjects = {}

local function getHealthColor(percent)

	if percent < 30 then
		return Color3.fromRGB(255,0,0)
	elseif percent < 70 then
		return Color3.fromRGB(255,200,0)
	else
		return Color3.fromRGB(0,255,0)
	end

end

local function createESP(player)

	if player == LocalPlayer then return end
	if espObjects[player] then return end

	local function attachCharacter(char)

		local head = char:WaitForChild("Head", 5)
		local humanoid = char:WaitForChild("Humanoid", 5)
		if not head or not humanoid then return end

		local billboard = Instance.new("BillboardGui")
		billboard.Name = "PlayerESP"
		billboard.Size = UDim2.new(0,360,0,70)
		billboard.StudsOffset = Vector3.new(0,2.6,0)
		billboard.AlwaysOnTop = true
		billboard.Parent = head

		local textLabel = Instance.new("TextLabel")
		textLabel.Parent = billboard
		textLabel.Size = UDim2.new(1,0,1,0)
		textLabel.BackgroundTransparency = 1
		textLabel.TextWrapped = false
		textLabel.TextScaled = false
		textLabel.RichText = true
		textLabel.Font = Enum.Font.SourceSansBold
		textLabel.TextSize = 20
		textLabel.TextStrokeTransparency = 0
		textLabel.TextColor3 = Color3.new(0,1,0)

		espObjects[player] = billboard


		local conn
		conn = RunService.RenderStepped:Connect(function()

			if not slot15.State then return end
			if not player.Character then return end
			

			local myChar = LocalPlayer.Character
			if not myChar then return end

			local myHRP = myChar:FindFirstChild("HumanoidRootPart")
			local targetHRP = player.Character:FindFirstChild("HumanoidRootPart")
			if not myHRP or not targetHRP then return end

			local distance = (myHRP.Position - targetHRP.Position).Magnitude
			local health = humanoid.Health
			local maxHealth = humanoid.MaxHealth
			local percent = (health / maxHealth) * 100
         local healthText

			local displayName = player.DisplayName
			local username = player.Name
         

			if health >= maxHealth or math.abs(health - maxHealth) < 0.01 then
	healthText = string.format("[ %.0f/%.0f ]", maxHealth, maxHealth)

else
	
	    healthText = string.format("[ %.2f/%.0f ]", health, maxHealth)
   end

			textLabel.Text = string.format(
	       "<b>%s ( @%s ) [ %.0fm ]</b>\n%s",
	      displayName,
      	username,
	      distance,
	      healthText
    )

			textLabel.TextColor3 = getHealthColor(percent)

		end)

		espConnections[player] = conn
	end

	if player.Character then
		attachCharacter(player.Character)
	end

	player.CharacterAdded:Connect(function(char)
		task.wait(0.2)
		if slot15.State then
			attachCharacter(char)
		end
	end)

end

local function removeESP(player)

	if espConnections[player] then
		espConnections[player]:Disconnect()
		espConnections[player] = nil
	end

	if espObjects[player] then
		espObjects[player]:Destroy()
		espObjects[player] = nil
	end

end

local function enableESP()
	for _, player in ipairs(Players:GetPlayers()) do
		createESP(player)
	end
end

local function disableESP()
	for player, _ in pairs(espObjects) do
		removeESP(player)
	end
end


Players.PlayerAdded:Connect(function(player)
	if slot15.State then
		createESP(player)
	end
end)

Players.PlayerRemoving:Connect(function(player)
	removeESP(player)
end)


slot15.Pill.MouseButton1Click:Connect(function()

	slot15.State = not slot15.State

	if slot15.State then

		slot15.Pill.BackgroundColor3 = Color3.fromRGB(120,200,120)
		slot15.SlotKnob:TweenPosition(
			UDim2.fromOffset(20,2),
			Enum.EasingDirection.Out,
			Enum.EasingStyle.Quad,
			0.15,
			true
		)

		enableESP()

	else

		slot15.Pill.BackgroundColor3 = Color3.fromRGB(80,80,80)
		slot15.SlotKnob:TweenPosition(
			UDim2.fromOffset(2,2),
			Enum.EasingDirection.Out,
			Enum.EasingStyle.Quad,
			0.15,
			true
		)

		disableESP()

	end
end)




local slot2 = Slots[2]
slot2.Label.Text = "Target Strafe"
slot2.State = false
slot2.Frame.ClipsDescendants = true

local row2 = Instance.new("Frame")
row2.Parent = slot2.Frame
row2.Size = UDim2.new(1, -12, 1, -8)
row2.Position = UDim2.fromOffset(110, 4)
row2.BackgroundTransparency = 1
row2.ZIndex = 20

local layout2 = Instance.new("UIListLayout")
layout2.Parent = row2
layout2.FillDirection = Enum.FillDirection.Horizontal
layout2.VerticalAlignment = Enum.VerticalAlignment.Center
layout2.Padding = UDim.new(0, 1)

local radiusStrafeBox = Instance.new("TextBox")
radiusStrafeBox.Parent = row2
radiusStrafeBox.Size = UDim2.fromOffset(50, 28)
radiusStrafeBox.Text = "20"
radiusStrafeBox.PlaceholderText = "Radius"
radiusStrafeBox.ClearTextOnFocus = false
radiusStrafeBox.Font = Enum.Font.SourceSansBold
radiusStrafeBox.TextSize = 14
radiusStrafeBox.TextColor3 = Color3.fromRGB(200,200,200)
radiusStrafeBox.BackgroundColor3 = Color3.fromRGB(40,40,40)
radiusStrafeBox.BorderSizePixel = 0
radiusStrafeBox.ZIndex = 21
Instance.new("UICorner", radiusStrafeBox).CornerRadius = UDim.new(0,6)

local MIN_RADIUS = 1
local MAX_RADIUS = 10000    
      
local function readStrafeRadius()      
	local num = tonumber(radiusStrafeBox.Text)      
	if not num then return MIN_RADIUS end      
	return math.clamp(math.floor(num), MIN_RADIUS, MAX_RADIUS)      
end      
      
radiusStrafeBox:GetPropertyChangedSignal("Text"):Connect(function()      
	local filtered = radiusStrafeBox.Text:gsub("%D","")      
	if filtered == "" then      
		radiusStrafeBox.Text = ""      
		return      
	end      
      
	local num = math.clamp(      
		tonumber(filtered),      
		MIN_RADIUS,      
		MAX_RADIUS      
	)      
      
	radiusStrafeBox.Text = tostring(num)      
end)      
      
      
local strafeConnection = nil      
local strafeAngle = 0      
      
local function startTargetStrafe()      
      
	if strafeConnection then return end      
      
	strafeConnection = RunService.Stepped:Connect(function(_, dt)      
      
		-- Guard cơ bản trước
		if not selectedPlayer then return end      
		if not selectedPlayer.Character then return end      
		if not LocalPlayer.Character then return end      
      
		local success, err = pcall(function()
      
			local targetHRP = selectedPlayer.Character:FindFirstChild("HumanoidRootPart")      
			local myHRP = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")      
      
			if not targetHRP or not myHRP then return end      
      
			local speed = readTeleportSpeed()      
			local radius = readStrafeRadius()      
      
			local targetPos = targetHRP.Position      
			local myPos = myHRP.Position      
      
			local delta = targetPos - myPos      
			local distance = delta.Magnitude      
      
			if distance > radius then      
      
				myHRP.AssemblyLinearVelocity = Vector3.zero      
				myHRP.AssemblyAngularVelocity = Vector3.zero      
      
				local step = math.min(distance, speed * dt)      
				local newPos = myPos + delta.Unit * step      
      
				myHRP.CFrame = CFrame.new(newPos) * myHRP.CFrame.Rotation      
      
			else      
      
				strafeAngle += speed * dt      
      
				local offset = Vector3.new(      
					math.cos(strafeAngle) * radius,      
					0,      
					math.sin(strafeAngle) * radius      
				)      
      
				local circlePos = targetPos + offset      
      
				myHRP.AssemblyLinearVelocity = Vector3.zero      
				myHRP.AssemblyAngularVelocity = Vector3.zero      
      
				myHRP.CFrame = CFrame.new(circlePos) * myHRP.CFrame.Rotation      
			end      

		end)

		-- Nếu có lỗi thì chỉ warn, không làm chết script
		if not success then
			warn("TargetStrafe error:", err)
		end
      
	end)      
      
end


local function stopTargetStrafe()

	if strafeConnection then
		strafeConnection:Disconnect()
		strafeConnection = nil
	end

end

registerTeleportSlot(slot2, function()
	stopTargetStrafe()
	removeNoclipUser()
end)

slot2.Pill.MouseButton1Click:Connect(function()

	-- Nếu Escape đang lock teleport → không cho bật
	if teleportLockedByEscape then
		return
	end

	slot2.State = not slot2.State

	if slot2.State then

		-- Disable tất cả teleport khác
		disableAllTeleport(slot2)

		slot2.Pill.BackgroundColor3 = Color3.fromRGB(120,200,120)
		slot2.SlotKnob:TweenPosition(
			UDim2.fromOffset(20,2),
			Enum.EasingDirection.Out,
			Enum.EasingStyle.Quad,
			0.15,
			true
		)

		addNoclipUser()
		startTargetStrafe()

	else

		slot2.Pill.BackgroundColor3 = Color3.fromRGB(80,80,80)
		slot2.SlotKnob:TweenPosition(
			UDim2.fromOffset(2,2),
			Enum.EasingDirection.Out,
			Enum.EasingStyle.Quad,
			0.15,
			true
		)

		removeNoclipUser()
		stopTargetStrafe()

	end
end)




local slot13 = Slots[13]
slot13.Label.Text = "Teleport Player ( Y )"
slot13.State = false
slot13.Frame.ClipsDescendants = true

local teleportYConnection = nil

local function startTeleportY()

	if teleportYConnection then return end

	teleportYConnection = RunService.Stepped:Connect(function()

		-- Guard cơ bản
		if not selectedPlayer then return end
		if not selectedPlayer.Character then return end
		if not LocalPlayer.Character then return end

		local success, err = pcall(function()

			local targetHRP = selectedPlayer.Character:FindFirstChild("HumanoidRootPart")
			local myHRP = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

			if not targetHRP or not myHRP then return end

			local myPos = myHRP.Position
			local targetY = targetHRP.Position.Y

			myHRP.AssemblyLinearVelocity = Vector3.zero
			myHRP.AssemblyAngularVelocity = Vector3.zero

			myHRP.CFrame = CFrame.new(
				myPos.X,
				targetY,
				myPos.Z
			) * myHRP.CFrame.Rotation

		end)

		if not success then
			warn("TeleportY error:", err)
		end

	end)

end


local function stopTeleportY()

	if teleportYConnection then
		teleportYConnection:Disconnect()
		teleportYConnection = nil
	end

end

-- Đăng ký vào Teleport Manager
registerTeleportSlot(slot13, stopTeleportY)

slot13.Pill.MouseButton1Click:Connect(function()

	if teleportLockedByEscape then
		return
	end

	slot13.State = not slot13.State

	if slot13.State then

		disableAllTeleport(slot13)

		slot13.Pill.BackgroundColor3 = Color3.fromRGB(120,200,120)
		slot13.SlotKnob:TweenPosition(
			UDim2.fromOffset(20,2),
			Enum.EasingDirection.Out,
			Enum.EasingStyle.Quad,
			0.15,
			true
		)

		startTeleportY()

	else

		slot13.Pill.BackgroundColor3 = Color3.fromRGB(80,80,80)
		slot13.SlotKnob:TweenPosition(
			UDim2.fromOffset(2,2),
			Enum.EasingDirection.Out,
			Enum.EasingStyle.Quad,
			0.15,
			true
		)

		stopTeleportY()

	end
end)



--// SLOT 14 - TP Backstab

local slot14 = Slots[14]
slot14.Label.Text = "TP Backstab"
slot14.State = false
slot14.Frame.ClipsDescendants = true

local row14 = Instance.new("Frame")
row14.Parent = slot14.Frame
row14.Size = UDim2.new(1, -12, 1, -8)
row14.Position = UDim2.fromOffset(110, 4)
row14.BackgroundTransparency = 1

local layout14 = Instance.new("UIListLayout")
layout14.Parent = row14
layout14.FillDirection = Enum.FillDirection.Horizontal
layout14.VerticalAlignment = Enum.VerticalAlignment.Center
layout14.Padding = UDim.new(0, 1)

local radiusBackstabBox = Instance.new("TextBox")
radiusBackstabBox.Parent = row14
radiusBackstabBox.Size = UDim2.fromOffset(50, 28)
radiusBackstabBox.Text = "100"
radiusBackstabBox.PlaceholderText = "Radius"
radiusBackstabBox.ClearTextOnFocus = false
radiusBackstabBox.Font = Enum.Font.SourceSansBold
radiusBackstabBox.TextSize = 14
radiusBackstabBox.TextColor3 = Color3.fromRGB(200,200,200)
radiusBackstabBox.BackgroundColor3 = Color3.fromRGB(40,40,40)
radiusBackstabBox.BorderSizePixel = 0
radiusBackstabBox.ZIndex = 21
Instance.new("UICorner", radiusBackstabBox).CornerRadius = UDim.new(0,6)

local MIN_BACKSTAB_RADIUS = 1
local MAX_BACKSTAB_RADIUS = 10000

local function readBackstabRadius()
	local num = tonumber(radiusBackstabBox.Text)
	if not num then return MIN_BACKSTAB_RADIUS end
	return math.clamp(math.floor(num), MIN_BACKSTAB_RADIUS, MAX_BACKSTAB_RADIUS)
end

radiusBackstabBox:GetPropertyChangedSignal("Text"):Connect(function()
	local filtered = radiusBackstabBox.Text:gsub("%D","")
	if filtered == "" then
		radiusBackstabBox.Text = ""
		return
	end

	local num = math.clamp(
		tonumber(filtered),
		MIN_BACKSTAB_RADIUS,
		MAX_BACKSTAB_RADIUS
	)

	radiusBackstabBox.Text = tostring(num)
end)

--========================--
-- BACKSTAB LOGIC
--========================--

local backstabConn = nil

local function startBackstab()

	if backstabConn then return end

	backstabConn = RunService.Stepped:Connect(function(_, dt)

		if not selectedPlayer then return end
		if not selectedPlayer.Character then return end
		if not LocalPlayer.Character then return end

		local success, err = pcall(function()

			local targetHRP = selectedPlayer.Character:FindFirstChild("HumanoidRootPart")
			local myHRP = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

			if not targetHRP or not myHRP then return end

			local speed = readTeleportSpeed()
			local radius = readBackstabRadius()

			local targetPos = targetHRP.Position
			local myPos = myHRP.Position

			local delta = targetPos - myPos
			local distance = delta.Magnitude

			local behindCF = targetHRP.CFrame * CFrame.new(0, 0, radius)
			local behindPos = behindCF.Position

			if distance > radius + 1 then

				myHRP.AssemblyLinearVelocity = Vector3.zero
				myHRP.AssemblyAngularVelocity = Vector3.zero

				if distance > 0 then
					local step = math.min(distance, speed * dt)
					local newPos = myPos + delta.Unit * step
					myHRP.CFrame = CFrame.new(newPos) * myHRP.CFrame.Rotation
				end

			else

				local toBehind = behindPos - myPos
				local behindDistance = toBehind.Magnitude

				if behindDistance > 0.5 then
					myHRP.CFrame = CFrame.new(behindPos) * myHRP.CFrame.Rotation
				end
			end

		end)

		if not success then
			warn("Backstab error:", err)
		end

	end)

end

local function stopBackstab()

	if backstabConn then
		backstabConn:Disconnect()
		backstabConn = nil
	end

end

--========================--
-- REGISTER TO TELEPORT SYSTEM
--========================--

registerTeleportSlot(slot14, function()
	stopBackstab()
	removeNoclipUser()
end)

--========================--
-- TOGGLE
--========================--

slot14.Pill.MouseButton1Click:Connect(function()

	if teleportLockedByEscape then
		return
	end

	slot14.State = not slot14.State

	if slot14.State then

		disableAllTeleport(slot14)

		slot14.Pill.BackgroundColor3 = Color3.fromRGB(120,200,120)
		slot14.SlotKnob:TweenPosition(
			UDim2.fromOffset(20,2),
			Enum.EasingDirection.Out,
			Enum.EasingStyle.Quad,
			0.15,
			true
		)

		addNoclipUser()
		startBackstab()

	else

		slot14.Pill.BackgroundColor3 = Color3.fromRGB(80,80,80)
		slot14.SlotKnob:TweenPosition(
			UDim2.fromOffset(2,2),
			Enum.EasingDirection.Out,
			Enum.EasingStyle.Quad,
			0.15,
			true
		)

		removeNoclipUser()
		stopBackstab()

	end
end)




--// SLOT 16 - Cam Lock ( Nearest )

local slot16 = Slots[16]
slot16.Label.Text = "Cam Lock ( Nearest )"
slot16.State = false
slot16.Frame.ClipsDescendants = true

local silentLockConn = nil
local camera = workspace.CurrentCamera
local LOCK_STRENGTH = 1

--========================--
-- GET NEAREST PLAYER
--========================--

local function getNearestPlayer()

	local myChar = LocalPlayer.Character
	if not myChar then return nil end

	local myHRP = myChar:FindFirstChild("HumanoidRootPart")
	if not myHRP then return nil end

	local nearestPlayer = nil
	local shortestDistance = math.huge

	for _, player in ipairs(Players:GetPlayers()) do

		if player ~= LocalPlayer and player.Character then

			local humanoid = player.Character:FindFirstChild("Humanoid")
			local targetHRP = player.Character:FindFirstChild("HumanoidRootPart")

			if humanoid and targetHRP and humanoid.Health > 0 then

				local distance = (myHRP.Position - targetHRP.Position).Magnitude

				if distance < shortestDistance then
					shortestDistance = distance
					nearestPlayer = player
				end

			end
		end
	end

	return nearestPlayer
end

--========================--
-- START LOCK
--========================--

local function startSilentLock()

	if silentLockConn then return end

	silentLockConn = RunService.RenderStepped:Connect(function()

		-- Guard cơ bản
		if not slot16.State then return end
		if not camera then return end

		local success, err = pcall(function()

			local targetPlayer = getNearestPlayer()
			if not targetPlayer then return end
			if not targetPlayer.Character then return end

			local targetHRP = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
			if not targetHRP then return end

			local camPos = camera.CFrame.Position
			local targetCF = CFrame.new(camPos, targetHRP.Position)

			camera.CFrame = camera.CFrame:Lerp(targetCF, LOCK_STRENGTH)

		end)

		if not success then
			warn("CamLock error:", err)
		end

	end)

end

--========================--
-- STOP LOCK
--========================--

local function stopSilentLock()

	if silentLockConn then
		silentLockConn:Disconnect()
		silentLockConn = nil
	end

end

--========================--
-- TOGGLE
--========================--

slot16.Pill.MouseButton1Click:Connect(function()

	slot16.State = not slot16.State

	if slot16.State then

		slot16.Pill.BackgroundColor3 = Color3.fromRGB(120,200,120)
		slot16.SlotKnob:TweenPosition(
			UDim2.fromOffset(20,2),
			Enum.EasingDirection.Out,
			Enum.EasingStyle.Quad,
			0.15,
			true
		)

		startSilentLock()

	else

		slot16.Pill.BackgroundColor3 = Color3.fromRGB(80,80,80)
		slot16.SlotKnob:TweenPosition(
			UDim2.fromOffset(2,2),
			Enum.EasingDirection.Out,
			Enum.EasingStyle.Quad,
			0.15,
			true
		)

		stopSilentLock()

	end

end)


--// SLOT 17 - Hitbox Expand

local slot17 = Slots[17]
slot17.Label.Text = "Hitbox Expand"
slot17.State = false
slot17.Frame.ClipsDescendants = true

local row17 = Instance.new("Frame")
row17.Parent = slot17.Frame
row17.Size = UDim2.new(1, -12, 1, -8)
row17.Position = UDim2.fromOffset(110, 4)
row17.BackgroundTransparency = 1

local layout17 = Instance.new("UIListLayout")
layout17.Parent = row17
layout17.FillDirection = Enum.FillDirection.Horizontal
layout17.VerticalAlignment = Enum.VerticalAlignment.Center
layout17.Padding = UDim.new(0, 1)

local hitboxSizeBox = Instance.new("TextBox")
hitboxSizeBox.Parent = row17
hitboxSizeBox.Size = UDim2.fromOffset(55, 28)
hitboxSizeBox.Text = "100"
hitboxSizeBox.PlaceholderText = "Size"
hitboxSizeBox.ClearTextOnFocus = false
hitboxSizeBox.Font = Enum.Font.SourceSansBold
hitboxSizeBox.TextSize = 14
hitboxSizeBox.TextColor3 = Color3.fromRGB(200,200,200)
hitboxSizeBox.BackgroundColor3 = Color3.fromRGB(40,40,40)
hitboxSizeBox.BorderSizePixel = 0
hitboxSizeBox.ZIndex = 21
Instance.new("UICorner", hitboxSizeBox).CornerRadius = UDim.new(0,6)

local MIN_HITBOX = 1
local MAX_HITBOX = 1000

local function readHitboxSize()
	local num = tonumber(hitboxSizeBox.Text)
	if not num then return 6 end
	return math.clamp(num, MIN_HITBOX, MAX_HITBOX)
end

hitboxSizeBox:GetPropertyChangedSignal("Text"):Connect(function()

	local filtered = hitboxSizeBox.Text:gsub("[^%d%.]", "")

	if filtered == "" then
		hitboxSizeBox.Text = ""
		return
	end

	local num = tonumber(filtered)
	if num then
		num = math.clamp(num, MIN_HITBOX, MAX_HITBOX)
		hitboxSizeBox.Text = tostring(num)
	end

end)

--========================================
-- HITBOX SYSTEM
--========================================

local originalStates = {}
local connections = {}
local heartbeatConn = nil

--------------------------------------------------
-- APPLY
--------------------------------------------------

local function applyHitbox(player)

	if player == LocalPlayer then return end
	if not player.Character then return end

	local success = pcall(function()

		local hrp = player.Character:FindFirstChild("HumanoidRootPart")
		if not hrp then return end

		local newSize = readHitboxSize()

		if not originalStates[player] then
			originalStates[player] = {
				size = hrp.Size,
				transparency = hrp.Transparency,
				material = hrp.Material
			}
		end

		hrp.Size = Vector3.new(newSize, newSize, newSize)
		hrp.Transparency = 0.75
		hrp.Material = Enum.Material.Neon

	end)

end

--------------------------------------------------
-- RESTORE
--------------------------------------------------

local function restoreHitbox(player)

	local state = originalStates[player]
	if not state then return end
	if not player.Character then return end

	pcall(function()

		local hrp = player.Character:FindFirstChild("HumanoidRootPart")
		if not hrp then return end

		hrp.Size = state.size
		hrp.Transparency = state.transparency
		hrp.Material = state.material

	end)

	originalStates[player] = nil

end

--------------------------------------------------
-- CHARACTER HANDLER
--------------------------------------------------

local function setupCharacter(player)

	if player == LocalPlayer then return end

	if connections[player] then
		connections[player]:Disconnect()
	end

	connections[player] = player.CharacterAdded:Connect(function()
		if slot17.State then
			task.wait(0.2)
			applyHitbox(player)
		end
	end)

end

--------------------------------------------------
-- START
--------------------------------------------------

local function startHitbox()

	-- Apply ngay cho player hiện tại
	for _, player in ipairs(Players:GetPlayers()) do
		setupCharacter(player)
		applyHitbox(player)
	end

	-- Player join
	connections["PlayerAdded"] = Players.PlayerAdded:Connect(function(player)
		setupCharacter(player)
		if slot17.State then
			task.wait(0.2)
			applyHitbox(player)
		end
	end)

	-- Player leave
	connections["PlayerRemoving"] = Players.PlayerRemoving:Connect(function(player)
		restoreHitbox(player)
		if connections[player] then
			connections[player]:Disconnect()
			connections[player] = nil
		end
	end)

	-- Realtime size update
	heartbeatConn = RunService.Heartbeat:Connect(function()
		if not slot17.State then return end
		for _, player in ipairs(Players:GetPlayers()) do
			applyHitbox(player)
		end
	end)

end

--------------------------------------------------
-- STOP
--------------------------------------------------

local function stopHitbox()

	if heartbeatConn then
		heartbeatConn:Disconnect()
		heartbeatConn = nil
	end

	for player, _ in pairs(originalStates) do
		restoreHitbox(player)
	end

	for _, conn in pairs(connections) do
		if typeof(conn) == "RBXScriptConnection" then
			conn:Disconnect()
		end
	end

	connections = {}
	originalStates = {}

end

--------------------------------------------------
-- TOGGLE
--------------------------------------------------

slot17.Pill.MouseButton1Click:Connect(function()

	slot17.State = not slot17.State

	if slot17.State then

		slot17.Pill.BackgroundColor3 = Color3.fromRGB(120,200,120)
		slot17.SlotKnob:TweenPosition(
			UDim2.fromOffset(20,2),
			Enum.EasingDirection.Out,
			Enum.EasingStyle.Quad,
			0.15,
			true
		)

		startHitbox()

	else

		slot17.Pill.BackgroundColor3 = Color3.fromRGB(80,80,80)
		slot17.SlotKnob:TweenPosition(
			UDim2.fromOffset(2,2),
			Enum.EasingDirection.Out,
			Enum.EasingStyle.Quad,
			0.15,
			true
		)

		stopHitbox()

	end

end)







local slot19 = Slots[19]
slot19.Label.Text = "Catch Target Y"
slot19.State = false
slot19.Frame.ClipsDescendants = true

local dynamicHeightConn = nil
local dynamicFloor = nil
local dynamicRemoveConn = nil

--------------------------------------------------
-- START
--------------------------------------------------

local function startDynamicHeight()

	if dynamicHeightConn then return end
	if not selectedPlayer then return end

	-- Tạo floor
	dynamicFloor = Instance.new("Part")
	dynamicFloor.Size = Vector3.new(30, 6, 30)
	dynamicFloor.Anchored = true
	dynamicFloor.CanCollide = true
	dynamicFloor.Transparency = 1
	dynamicFloor.Name = "DynamicFloor"
	dynamicFloor.Parent = workspace

	dynamicHeightConn = RunService.Stepped:Connect(function()

		if not slot19.State then return end
		if not selectedPlayer then return end
		if not LocalPlayer.Character then return end

		local success, err = pcall(function()

			local targetChar = selectedPlayer.Character
			if not targetChar then return end

			local myHRP = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
			if not myHRP then return end

			local targetHRP = targetChar:FindFirstChild("HumanoidRootPart")
			if not targetHRP then return end

			local targetY = targetHRP.Position.Y
			local pos = myHRP.Position

			-- Floor theo XZ của mình, Y của target
			if dynamicFloor then
				dynamicFloor.CFrame = CFrame.new(
					pos.X,
					targetY - (dynamicFloor.Size.Y / 2),
					pos.Z
				)
			end

			-- Anti-fall
			if pos.Y < targetY - 0.1 then

				local vel = myHRP.AssemblyLinearVelocity

				myHRP.AssemblyLinearVelocity = Vector3.new(
					vel.X,
					0,
					vel.Z
				)

				myHRP.CFrame =
					CFrame.new(pos.X, targetY, pos.Z)
					* myHRP.CFrame.Rotation
			end

		end)

		if not success then
			warn("DynamicHeight error:", err)
		end

	end)

	--------------------------------------------------
	-- Chỉ tắt khi target OUT GAME
	--------------------------------------------------

	if dynamicRemoveConn then
		dynamicRemoveConn:Disconnect()
	end

	dynamicRemoveConn = selectedPlayer.AncestryChanged:Connect(function(_, parent)

		if not parent and slot19.State then
			stopDynamicHeight()
		end

	end)

end

--------------------------------------------------
-- STOP
--------------------------------------------------

function stopDynamicHeight()

	if dynamicHeightConn then
		dynamicHeightConn:Disconnect()
		dynamicHeightConn = nil
	end

	if dynamicRemoveConn then
		dynamicRemoveConn:Disconnect()
		dynamicRemoveConn = nil
	end

	if dynamicFloor then
		dynamicFloor:Destroy()
		dynamicFloor = nil
	end

	slot19.State = false

	slot19.Pill.BackgroundColor3 = Color3.fromRGB(80,80,80)
	slot19.SlotKnob:TweenPosition(
		UDim2.fromOffset(2,2),
		Enum.EasingDirection.Out,
		Enum.EasingStyle.Quad,
		0.15,
		true
	)

end

--------------------------------------------------
-- TOGGLE
--------------------------------------------------

slot19.Pill.MouseButton1Click:Connect(function()

	slot19.State = not slot19.State

	if slot19.State then

		slot19.Pill.BackgroundColor3 = Color3.fromRGB(120,200,120)
		slot19.SlotKnob:TweenPosition(
			UDim2.fromOffset(20,2),
			Enum.EasingDirection.Out,
			Enum.EasingStyle.Quad,
			0.15,
			true
		)

		startDynamicHeight()

	else
		stopDynamicHeight()
	end

end)

--------------------------------------------------
-- Auto disable khi bản thân reset
--------------------------------------------------

LocalPlayer.CharacterAdded:Connect(function()

	if slot19.State then
		stopDynamicHeight()
	end

end)






local slot18 = Slots[18]
slot18.Label.Text = "Spectator Player"
slot18.State = false
slot18.Frame.ClipsDescendants = true

local spectatorUpdateConn = nil
local spectatorCharacterConn = nil
local spectatorRemoveConn = nil
local currentSpectatedPlayer = nil
local localRespawnConn = nil

local Camera = workspace.CurrentCamera

--------------------------------------------------
-- BIND PLAYER
--------------------------------------------------

local function bindToPlayer(player)

	if spectatorCharacterConn then
		spectatorCharacterConn:Disconnect()
		spectatorCharacterConn = nil
	end

	if spectatorRemoveConn then
		spectatorRemoveConn:Disconnect()
		spectatorRemoveConn = nil
	end

	currentSpectatedPlayer = player
	if not player then return end

	local function attachToCharacter(char)

		local success, err = pcall(function()

			local humanoid = char:WaitForChild("Humanoid", 5)
			if humanoid and slot18.State then
				Camera.CameraType = Enum.CameraType.Custom
				Camera.CameraSubject = humanoid
			end

		end)

		if not success then
			warn("Spectate attach error:", err)
		end

	end

	if player.Character then
		attachToCharacter(player.Character)
	end

	spectatorCharacterConn = player.CharacterAdded:Connect(function(char)
		if slot18.State then
			attachToCharacter(char)
		end
	end)

	spectatorRemoveConn = player.AncestryChanged:Connect(function(_, parent)

		if not parent and slot18.State then
			stopSpectate()

			slot18.State = false
			slot18.Pill.BackgroundColor3 = Color3.fromRGB(80,80,80)
			slot18.SlotKnob:TweenPosition(
				UDim2.fromOffset(2,2),
				Enum.EasingDirection.Out,
				Enum.EasingStyle.Quad,
				0.15,
				true
			)
		end

	end)

end

--------------------------------------------------
-- START
--------------------------------------------------

local spectatorWatcher = nil

local function startSpectate()

	if spectatorWatcher then return end

	spectatorWatcher = RunService.RenderStepped:Connect(function()

		if not slot18.State then return end

		local success, err = pcall(function()

			if selectedPlayer ~= currentSpectatedPlayer then
				bindToPlayer(selectedPlayer)
			end

		end)

		if not success then
			warn("Spectate runtime error:", err)
		end

	end)

end

--------------------------------------------------
-- STOP
--------------------------------------------------

function stopSpectate()

	if spectatorWatcher then
		spectatorWatcher:Disconnect()
		spectatorWatcher = nil
	end

	if spectatorCharacterConn then
		spectatorCharacterConn:Disconnect()
		spectatorCharacterConn = nil
	end

	if spectatorRemoveConn then
		spectatorRemoveConn:Disconnect()
		spectatorRemoveConn = nil
	end

	currentSpectatedPlayer = nil

	local success, err = pcall(function()

		if LocalPlayer.Character then
			local myHumanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
			if myHumanoid then
				Camera.CameraSubject = myHumanoid
			end
		end

		Camera.CameraType = Enum.CameraType.Custom

	end)

	if not success then
		warn("Spectate stop error:", err)
	end

end

--------------------------------------------------
-- TOGGLE
--------------------------------------------------

slot18.Pill.MouseButton1Click:Connect(function()

	slot18.State = not slot18.State

	if slot18.State then

		slot18.Pill.BackgroundColor3 = Color3.fromRGB(120,200,120)
		slot18.SlotKnob:TweenPosition(
			UDim2.fromOffset(20,2),
			Enum.EasingDirection.Out,
			Enum.EasingStyle.Quad,
			0.15,
			true
		)

		startSpectate()

	else

		slot18.Pill.BackgroundColor3 = Color3.fromRGB(80,80,80)
		slot18.SlotKnob:TweenPosition(
			UDim2.fromOffset(2,2),
			Enum.EasingDirection.Out,
			Enum.EasingStyle.Quad,
			0.15,
			true
		)

		stopSpectate()

	end

end)

--------------------------------------------------
-- Auto disable khi bạn respawn
--------------------------------------------------

localRespawnConn = LocalPlayer.CharacterAdded:Connect(function()

	if slot18.State then

		slot18.State = false

		slot18.Pill.BackgroundColor3 = Color3.fromRGB(80,80,80)
		slot18.SlotKnob:TweenPosition(
			UDim2.fromOffset(2,2),
			Enum.EasingDirection.Out,
			Enum.EasingStyle.Quad,
			0.15,
			true
		)

		stopSpectate()

	end

end)








local slot20 = Slots[20]
slot20.Label.Text = "Enable Position"
slot20.State = false
slot20.Frame.ClipsDescendants = true

--===== ROW LAYOUT =====--

local row20 = Instance.new("Frame")
row20.Parent = slot20.Frame
row20.Size = UDim2.new(1, -12, 1, -8)
row20.Position = UDim2.fromOffset(110, 4)
row20.BackgroundTransparency = 1
row20.ZIndex = 20

local layout20 = Instance.new("UIListLayout")
layout20.Parent = row20
layout20.FillDirection = Enum.FillDirection.Horizontal
layout20.VerticalAlignment = Enum.VerticalAlignment.Center
layout20.Padding = UDim.new(0, 6)

--===== COPY BUTTON =====--

local copyBtn = Instance.new("TextButton")
copyBtn.Parent = row20
copyBtn.Size = UDim2.fromOffset(50, 28)
copyBtn.Text = "Copy"
copyBtn.Font = Enum.Font.SourceSansBold
copyBtn.TextSize = 14
copyBtn.TextColor3 = Color3.fromRGB(0,0,0)
copyBtn.BackgroundColor3 = Color3.fromRGB(120,200,120)
copyBtn.BorderSizePixel = 0
copyBtn.ZIndex = 21
copyBtn.LayoutOrder = 1
Instance.new("UICorner", copyBtn).CornerRadius = UDim.new(0,6)

--===== POSITION GUI =====--

local positionGui = Instance.new("ScreenGui")
positionGui.Name = "PositionDisplayGui"
positionGui.ResetOnSpawn = false
positionGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local positionFrame = Instance.new("Frame")
positionFrame.Parent = positionGui
positionFrame.Size = UDim2.fromOffset(190, 35)
positionFrame.Position = UDim2.fromOffset(10, 10)
positionFrame.BackgroundColor3 = Color3.fromRGB(20,20,20)
positionFrame.BackgroundTransparency = 0.3
positionFrame.BorderSizePixel = 0
positionFrame.Visible = false
Instance.new("UICorner", positionFrame).CornerRadius = UDim.new(0,8)

local positionLabel = Instance.new("TextLabel")
positionLabel.Parent = positionFrame
positionLabel.Size = UDim2.new(1, -10, 1, 0)
positionLabel.Position = UDim2.fromOffset(5,0)
positionLabel.BackgroundTransparency = 1
positionLabel.Font = Enum.Font.SourceSansBold
positionLabel.TextSize = 18
positionLabel.TextColor3 = Color3.fromRGB(0,255,180)
positionLabel.TextXAlignment = Enum.TextXAlignment.Left
positionLabel.Text = "X: 0   Y: 0   Z: 0"

--===== LOGIC =====--

local positionConn = nil
local lastPositionString = ""
local lastRawPositionString = ""

local function startPosition()

	if positionConn then return end

	positionFrame.Visible = true

	positionConn = RunService.RenderStepped:Connect(function()

		if not slot20.State then return end
		if not LocalPlayer.Character then return end

		local success, err = pcall(function()

			local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
			if not hrp then return end

			local pos = hrp.Position

			lastPositionString = string.format(
				"X: %.0f   Y: %.0f   Z: %.0f",
				pos.X,
				pos.Y,
				pos.Z
			)

			lastRawPositionString = string.format(
				"%.0f, %.0f, %.0f",
				pos.X,
				pos.Y,
				pos.Z
			)

			if positionLabel then
				positionLabel.Text = lastPositionString
			end

		end)

		if not success then
			warn("PositionDisplay error:", err)
		end

	end)

end

local function stopPosition()

	if positionConn then
		positionConn:Disconnect()
		positionConn = nil
	end

	if positionFrame then
		positionFrame.Visible = false
	end

end

--===== COPY FUNCTION =====--

copyBtn.MouseButton1Click:Connect(function()

	if lastRawPositionString ~= "" then
		pcall(function()
			setclipboard(lastRawPositionString)
		end)
	end

end)

--===== PILL TOGGLE =====--

slot20.Pill.MouseButton1Click:Connect(function()

	slot20.State = not slot20.State

	if slot20.State then

		slot20.Pill.BackgroundColor3 = Color3.fromRGB(120,200,120)
		slot20.SlotKnob:TweenPosition(
			UDim2.fromOffset(20,2),
			Enum.EasingDirection.Out,
			Enum.EasingStyle.Quad,
			0.15,
			true
		)

		startPosition()

	else

		slot20.Pill.BackgroundColor3 = Color3.fromRGB(80,80,80)
		slot20.SlotKnob:TweenPosition(
			UDim2.fromOffset(2,2),
			Enum.EasingDirection.Out,
			Enum.EasingStyle.Quad,
			0.15,
			true
		)

		stopPosition()

	end

end)









	














SettingsButton.MouseButton1Click:Connect(function()
	if not SettingsGui or not SettingsGui.Parent then
		return
	end
	SettingsGui.Enabled = not SettingsGui.Enabled
end)

--===== CLOSE BUTTON CONFIRM LOGIC =====--

closebutton.MouseButton1Click:Connect(function()

	-- Nếu popup đã tồn tại thì không tạo thêm
	if LocalPlayer.PlayerGui:FindFirstChild("ExitConfirmGui") then
		return
	end

	--===== GUI =====--

	local confirmGui = Instance.new("ScreenGui")
	confirmGui.Name = "ExitConfirmGui"
	confirmGui.ResetOnSpawn = false
	confirmGui.Parent = LocalPlayer.PlayerGui

	local frame = Instance.new("Frame")
	frame.Parent = confirmGui
	frame.Size = UDim2.fromOffset(200, 90)
	frame.Position = UDim2.fromScale(0.5, 0.5)
	frame.AnchorPoint = Vector2.new(0.5, 0.5)
	frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
	frame.BorderSizePixel = 0
   frame.BackgroundTransparency = 0.5
   frame.ZIndex = 19990
	Instance.new("UICorner", frame).CornerRadius = UDim.new(0,5)

   local stroke = Instance.new("UIStroke")
   stroke.Parent = frame
   stroke.Color = Color3.fromRGB(230,230,230)
   stroke.Thickness = 2
   stroke.Transparency = 0
   stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

	local title = Instance.new("TextLabel")
	title.Parent = frame
	title.Size = UDim2.new(1, 0, 0, 40)
	title.BackgroundTransparency = 1
	title.Text = "Are you sure want to exit ?"
	title.Font = Enum.Font.SourceSansBold
	title.TextSize = 18
	title.TextColor3 = Color3.fromRGB(255,255,255)
   title.ZIndex = 20000

	--===== YES BUTTON =====--

	local yesBtn = Instance.new("TextButton")
	yesBtn.Parent = frame
	yesBtn.Size = UDim2.fromOffset(70, 25)
	yesBtn.Position = UDim2.fromScale(0.25, 0.70)
	yesBtn.AnchorPoint = Vector2.new(0.5, 0.5)
	yesBtn.Text = "Yes"
	yesBtn.Font = Enum.Font.SourceSansBold
	yesBtn.TextSize = 16
	yesBtn.TextColor3 = Color3.fromRGB(0,0,0)
	yesBtn.BackgroundColor3 = Color3.fromRGB(200,80,80)
	yesBtn.BorderSizePixel = 0
   yesBtn.ZIndex = 20000
	Instance.new("UICorner", yesBtn).CornerRadius = UDim.new(0,3)

	--===== NO BUTTON =====--

	local noBtn = Instance.new("TextButton")
	noBtn.Parent = frame
	noBtn.Size = UDim2.fromOffset(70, 25)
	noBtn.Position = UDim2.fromScale(0.75, 0.70)
	noBtn.AnchorPoint = Vector2.new(0.5, 0.5)
	noBtn.Text = "No"
	noBtn.Font = Enum.Font.SourceSansBold
	noBtn.TextSize = 16
	noBtn.TextColor3 = Color3.fromRGB(0,0,0)
	noBtn.BackgroundColor3 = Color3.fromRGB(120,200,120)
	noBtn.BorderSizePixel = 0
   noBtn.ZIndex = 20000
	Instance.new("UICorner", noBtn).CornerRadius = UDim.new(0,3)

	--===== BUTTON LOGIC =====--

	yesBtn.MouseButton1Click:Connect(function()

		if SettingsGui and SettingsGui.Parent then
			SettingsGui:Destroy()
		end

		if main and main.Parent then
			main:Destroy()
		end

		confirmGui:Destroy()
	end)

	noBtn.MouseButton1Click:Connect(function()
		confirmGui:Destroy()
	end)

end)





LocalPlayer.CharacterRemoving:Connect(function()


	if flyNoclipConn then
		flyNoclipConn:Disconnect()
		flyNoclipConn = nil
	end

end)



LocalPlayer.CharacterAdded:Connect(function(char)

local HRP = char:WaitForChild("HumanoidRootPart", 5)
	if not HRP then return end

	RunService.Heartbeat:Wait()
	flyHasNoclipPriority = false

	if flyNoclipConn then
		flyNoclipConn:Disconnect()
		flyNoclipConn = nil
	end

	updateSharedNoclip()
    stopFlyVisuals()

nowe = false
tpwalking = false

	upEnabled = false
	stopUp()

	escapeEnabled = false
	stopEscape()
	syncEscapeUI(false)

	stopUpTextVisual()

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



