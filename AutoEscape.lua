local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")

local LP = Players.LocalPlayer

-- ========= CONFIG =========
local SPEED, TARGET_Y = 450, 100000
local LOW_HP, SAFE_HP = 0.40, 0.90
local RESPECT_COREGUI = false
local TOP_MARGIN = 2

-- ========= STATE =========
local Enabled, Flying, TweenObj = true, false, nil
local Humanoid, RootPart
local healthConn

-- ========= GUI =========
local gui = Instance.new("ScreenGui")
gui.Name, gui.IgnoreGuiInset, gui.DisplayOrder, gui.ResetOnSpawn, gui.ZIndexBehavior =
	"AutoEscapeUI", true, 999999, false, Enum.ZIndexBehavior.Sibling
gui.Parent = LP:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.AnchorPoint = Vector2.new(0,0)
frame.Position = UDim2.fromOffset(0,0)
frame.Size = UDim2.fromOffset(140, 46)
frame.AutomaticSize = Enum.AutomaticSize.XY
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.BackgroundTransparency = 0.1
frame.BorderSizePixel = 0
frame.Active = true
frame.Parent = gui
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,10)
local stroke = Instance.new("UIStroke", frame)
stroke.Color, stroke.Thickness = Color3.fromRGB(60,60,60), 1.2

local padding = Instance.new("UIPadding", frame)
padding.PaddingTop, padding.PaddingBottom = UDim.new(0,3), UDim.new(0,3)
padding.PaddingLeft, padding.PaddingRight = UDim.new(0,8), UDim.new(0,8)

local layout = Instance.new("UIListLayout", frame)
layout.FillDirection = Enum.FillDirection.Horizontal
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.VerticalAlignment = Enum.VerticalAlignment.Center
layout.Padding = UDim.new(0,6)

local toggle = Instance.new("TextButton", frame)
toggle.AutomaticSize = Enum.AutomaticSize.XY
toggle.Text = "🟢 ON"
toggle.Font = Enum.Font.GothamBold
toggle.TextSize = 16
toggle.TextColor3 = Color3.fromRGB(255,255,255)
toggle.BackgroundColor3 = Color3.fromRGB(50,200,100)
toggle.AutoButtonColor = false
Instance.new("UICorner", toggle).CornerRadius = UDim.new(0,8)

local label = Instance.new("TextLabel", frame)
label.AutomaticSize = Enum.AutomaticSize.XY
label.BackgroundTransparency = 1
label.Text = "Auto Escape"
label.Font = Enum.Font.GothamBold
label.TextSize = 16
label.TextColor3 = Color3.fromRGB(235,235,235)
task.defer(function()
	local cam = workspace.CurrentCamera
	local vp = cam and cam.ViewportSize or Vector2.new(1920,1080)
	local topInset = GuiService:GetGuiInset().Y
	local minY = (RESPECT_COREGUI and (topInset + TOP_MARGIN) or TOP_MARGIN)
	local x = math.max(0, (vp.X - frame.AbsoluteSize.X) * 0.5)
	frame.Position = UDim2.fromOffset(x, minY)
end)

-- ========= DRAG =========
do
	local function pointerPos(input)
		return (input.UserInputType == Enum.UserInputType.Touch)
			and Vector2.new(input.Position.X, input.Position.Y)
			or UserInputService:GetMouseLocation()
	end
	local function over(inst, pos)
		local p, s = inst.AbsolutePosition, inst.AbsoluteSize
		return pos.X >= p.X and pos.X <= p.X+s.X and pos.Y >= p.Y and pos.Y <= p.Y+s.Y
	end

	local dragging = false
	local dragStart, startPos

	frame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			local pos = pointerPos(input)
			if over(toggle, pos) then return end                       -- bấm vào toggle thì không kéo
			dragging, dragStart, startPos = true, input.Position, frame.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then dragging = false end
			end)
		end
	end)

	frame.InputChanged:Connect(function(input)
		if not dragging then return end
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			local delta = input.Position - dragStart
			local newX = startPos.X.Offset + delta.X
			local newY = startPos.Y.Offset + delta.Y

			local cam = workspace.CurrentCamera
			if cam then
				local vp = cam.ViewportSize
				local topInset = GuiService:GetGuiInset().Y
				local minY = (RESPECT_COREGUI and (topInset + TOP_MARGIN) or TOP_MARGIN)
				newX = math.clamp(newX, 0, vp.X - frame.AbsoluteSize.X)
				newY = math.clamp(newY, minY, vp.Y - frame.AbsoluteSize.Y)
			end

			frame.Position = UDim2.fromOffset(newX, newY)
		end
	end)
end

-- ========= FLIGHT LOGIC =========
local function cancelFlight()
	if TweenObj then TweenObj:Cancel() TweenObj=nil end
	Flying=false
end

local function startFlight()
	if not Enabled or Flying or not RootPart then return end
	local yNow = RootPart.Position.Y
	if yNow >= TARGET_Y - 1 then return end
	local dist = TARGET_Y - yNow
	local duration = dist / SPEED
	Flying = true
	local cf = RootPart.CFrame
	TweenObj = TweenService:Create(RootPart, TweenInfo.new(duration, Enum.EasingStyle.Linear), {CFrame = CFrame.new(cf.X, TARGET_Y, cf.Z)})
	TweenObj.Completed:Connect(function() TweenObj=nil Flying=false end)
	TweenObj:Play()
end

local function onHealthChanged(h)
	if not Humanoid or not Enabled then return end
	local mh = Humanoid.MaxHealth
	if mh <= 0 then return end
	local p = h / mh
	if (not Flying) and p < LOW_HP then
		startFlight()
	elseif Flying and p >= SAFE_HP then
		cancelFlight()
	end
end

local function bindCharacter(char)
	Humanoid = char:WaitForChild("Humanoid")
	RootPart = char:WaitForChild("HumanoidRootPart")
	if healthConn then healthConn:Disconnect() end
	healthConn = Humanoid.HealthChanged:Connect(onHealthChanged)
end

if LP.Character then bindCharacter(LP.Character) end
LP.CharacterAdded:Connect(bindCharacter)

-- ========= TOGGLE =========
local function setEnabled(state)
	Enabled = state
	if not Enabled then cancelFlight() end
	if Enabled then
		toggle.Text = "🟢 ON"
		toggle.BackgroundColor3 = Color3.fromRGB(50,200,100)
	else
		toggle.Text = "🔴 OFF"
		toggle.BackgroundColor3 = Color3.fromRGB(200,70,70)
	end
end
toggle.MouseButton1Click:Connect(function() setEnabled(not Enabled) end)
