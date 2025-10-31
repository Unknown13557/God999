-- AutoEscapeUp v2 (drag theo yêu cầu + fix xung đột toggle)
-- HP<40% -> bay lên; đang bay nếu HP>=90% -> tự dừng; OFF -> dừng ngay & tắt core (chỉ còn kéo)

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local LP = Players.LocalPlayer

-- config
local SPEED       = 450       -- studs/s
local TARGET_Y    = 200000
local LOW_HP      = 0.40      -- 40%
local SAFE_HP     = 0.90      -- 90%

-- state
local Enabled     = true
local Flying      = false
local TweenObj    = nil
local Humanoid, RootPart

--================ GUI ==================
local gui = Instance.new("ScreenGui")
gui.Name = "AutoEscapeUI"
gui.IgnoreGuiInset = true
gui.DisplayOrder = 927262
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = LP:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.fromOffset(140, 46)
frame.AutomaticSize = Enum.AutomaticSize.XY
frame.AnchorPoint = Vector2.new(0.5, 0)
frame.Position = UDim2.fromScale(0.5, 0.1)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.BackgroundTransparency = 0.1
frame.BorderSizePixel = 0
frame.Active = true
frame.Parent = gui
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,10)
local stroke = Instance.new("UIStroke", frame)
stroke.Color = Color3.fromRGB(60,60,60)
stroke.Thickness = 1.2

local layout = Instance.new("UIListLayout")
layout.FillDirection = Enum.FillDirection.Horizontal
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.VerticalAlignment = Enum.VerticalAlignment.Center
layout.Padding = UDim.new(0,8)
layout.Parent = frame

local label = Instance.new("TextLabel")
label.AutomaticSize = Enum.AutomaticSize.XY
label.BackgroundTransparency = 1
label.Text = "Auto Escape"
label.Font = Enum.Font.GothamBold
label.TextSize = 16
label.TextColor3 = Color3.fromRGB(235,235,235)
label.Parent = frame

local toggle = Instance.new("TextButton")
toggle.AutomaticSize = Enum.AutomaticSize.XY
toggle.Text = "🟢 ON"
toggle.Font = Enum.Font.GothamBold
toggle.TextSize = 16
toggle.TextColor3 = Color3.fromRGB(255,255,255)
toggle.BackgroundColor3 = Color3.fromRGB(50,200,100)
toggle.AutoButtonColor = false
Instance.new("UICorner", toggle).CornerRadius = UDim.new(0,8)
toggle.Parent = frame

--================ drag (block bạn yêu cầu + tránh kéo khi bấm vào toggle) ==================
do
	-- helper: kiểm tra con trỏ có nằm trên toggle không
	local function isPointerOver(instance, pos)
		local p, s = instance.AbsolutePosition, instance.AbsoluteSize
		return pos.X >= p.X and pos.X <= p.X + s.X and pos.Y >= p.Y and pos.Y <= p.Y + s.Y
	end

	local dragging, dragStart, startPos
	frame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			local pos = (input.UserInputType == Enum.UserInputType.Touch)
				and Vector2.new(input.Position.X, input.Position.Y)
				and UserInputService:GetMouseLocation()

			-- nếu đang bấm ngay trên toggle thì không bật drag
			if pos and isPointerOver(toggle, pos) then return end

			dragging = true
			dragStart = input.Position
			startPos = frame.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then dragging = false end
			end)
		end
	end)

	frame.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local delta = input.Position - dragStart
			frame.Position = UDim2.new(
				startPos.X.Scale, startPos.X.Offset + delta.X,
				startPos.Y.Scale, startPos.Y.Offset + delta.Y
			)
		end
	end)
end

--================ logic bay ==================
local function cancelFlight()
	if TweenObj then
		TweenObj:Cancel()
		TweenObj = nil
	end
	Flying = false
end

local function startFlight()
	if not Enabled or Flying or not RootPart then return end
	local yNow = RootPart.Position.Y
	if yNow >= TARGET_Y - 1 then return end

	local dist = TARGET_Y - yNow
	local duration = dist / SPEED
	Flying = true
	local cf = RootPart.CFrame
	local tween = TweenService:Create(
		RootPart,
		TweenInfo.new(duration, Enum.EasingStyle.Linear, Enum.EasingDirection.Out),
		{ CFrame = CFrame.new(cf.X, TARGET_Y, cf.Z) }
	)
	TweenObj = tween
	tween.Completed:Connect(function()
		TweenObj = nil
		Flying = false
	end)
	tween:Play()
end

local healthConn
local function onHealthChanged(h)
	if not Humanoid or not Enabled then return end
	local mh = Humanoid.MaxHealth
	if mh <= 0 then return end

	local percent = h / mh
	if not Flying and percent < LOW_HP then
		startFlight()
	elseif Flying and percent >= SAFE_HP then
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

--================ toggle ==================
local function setEnabled(state)
	Enabled = state
	if not Enabled then
		cancelFlight()
	end
	if Enabled then
		toggle.Text = "🟢 ON"
		toggle.BackgroundColor3 = Color3.fromRGB(50,200,100)
	else
		toggle.Text = "🔴 OFF"
		toggle.BackgroundColor3 = Color3.fromRGB(200,70,70)
	end
end

toggle.MouseButton1Click:Connect(function()
	setEnabled(not Enabled)
end)

--================ hide/show ==================
UserInputService.InputBegan:Connect(function(input, gpe)
	if gpe then return end
	if input.KeyCode == Enum.KeyCode.RightShift then
		frame.Visible = not frame.Visible
	end
end)
