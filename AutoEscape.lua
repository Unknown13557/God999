do
	local Players          = game:GetService("Players")
	local TweenService     = game:GetService("TweenService")
	local UserInputService = game:GetService("UserInputService")
	local GuiService       = game:GetService("GuiService")

	local LP = Players.LocalPlayer

	local SPEED, TARGET_Y       = 450, 100000
	local LOW_HP, SAFE_HP       = 0.40, 0.90
	local RESPECT_COREGUI       = false
	local TOP_MARGIN            = 2

	local Enabled, Flying, TweenObj = true, false, nil
	local Humanoid, RootPart
	local healthConn
	local magictis_cancelFlight, magictis_startFlight, magictis_onHealthChanged, magictis_bindCharacter
	local UNIQUE_PREFIX = "magictis"
	local UNIQUE_ID     = UNIQUE_PREFIX .. "_" .. tostring(math.random(1000,9999)) .. "_" .. tostring(os.time() % 10000)
	local function M(name) return UNIQUE_PREFIX .. "_" .. name end

	-- ========= GUI =========
	local gui = Instance.new("ScreenGui")
	gui.Name = M("AutoEscapeUI")
	gui.IgnoreGuiInset = true
	gui.DisplayOrder = 165468
	gui.ResetOnSpawn = false
	gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	gui:SetAttribute("UniqueId", UNIQUE_ID)
	gui.Parent = LP:WaitForChild("PlayerGui")
if syn and syn.protect_gui then
	syn.protect_gui(gui)
	end
	
	local frame = Instance.new("Frame")
	frame.Name = M("Frame")
	frame.AnchorPoint = Vector2.new(0, 0)
	frame.Position = UDim2.fromOffset(0, 0)
	frame.Size = UDim2.fromOffset(140, 46)
	frame.AutomaticSize = Enum.AutomaticSize.XY
	frame.BackgroundColor3 = Color3.fromRGB(70, 0, 110)
	frame.BackgroundTransparency = 0.25
	frame.BorderSizePixel = 0
	frame.Active = true
	frame.Parent = gui
	Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

	local stroke = Instance.new("UIStroke")
	stroke.Color = Color3.fromRGB(180, 80, 255)
	stroke.Thickness = 2
	stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	stroke.Parent = frame

	local padding = Instance.new("UIPadding", frame)
	padding.PaddingTop, padding.PaddingBottom = UDim.new(0,3), UDim.new(0,3)
	padding.PaddingLeft, padding.PaddingRight = UDim.new(0,8), UDim.new(0,8)

	local layout = Instance.new("UIListLayout", frame)
    layout.FillDirection = Enum.FillDirection.Horizontal
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Left
    layout.VerticalAlignment   = Enum.VerticalAlignment.Center
    layout.Padding             = UDim.new(0, 6)
    layout.SortOrder           = Enum.SortOrder.LayoutOrder

	local toggleWrap = Instance.new("TextButton", frame)
	toggleWrap.Name = M("ToggleWrap")
	toggleWrap.AutoButtonColor = false
	toggleWrap.Text = ""
	toggleWrap.BackgroundColor3 = Color3.fromRGB(50, 200, 100)
	toggleWrap.Size = UDim2.fromOffset(40, 20)
	toggleWrap.ClipsDescendants = true
	toggleWrap.ZIndex = 1
	Instance.new("UICorner", toggleWrap).CornerRadius = UDim.new(1, 0)

	local toggleStroke = Instance.new("UIStroke", toggleWrap)
	toggleStroke.Color = Color3.fromRGB(255, 255, 255)
	toggleStroke.Thickness = 1
	toggleStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

	local knob = Instance.new("TextButton", toggleWrap)
	knob.Name = M("Knob")
	knob.Size = UDim2.fromOffset(16, 16)
	knob.Position = UDim2.fromOffset(22, 2)
	knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	knob.Text = ""
	knob.AutoButtonColor = false
	knob.ZIndex = 2
	Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)
	local knobStroke = Instance.new("UIStroke", knob)
	knobStroke.Color = Color3.fromRGB(230, 230, 230)
	knobStroke.Thickness = 1

	local label = Instance.new("TextLabel", frame)
	label.Name = M("Label")
	label.AutomaticSize = Enum.AutomaticSize.XY
	label.BackgroundTransparency = 1
	label.Text = "Auto Escape"
	label.Font = Enum.Font.GothamBold
	label.TextSize = 16
	label.TextColor3 = Color3.fromRGB(235,235,235)

	toggleWrap.LayoutOrder = 1
	label.LayoutOrder      = 2

	task.defer(function()
		local cam = workspace.CurrentCamera
		local vp = cam and cam.ViewportSize or Vector2.new(1920,1080)
		local topInset = GuiService:GetGuiInset().Y
		local minY = (RESPECT_COREGUI and (topInset + TOP_MARGIN) or TOP_MARGIN)
		local x = math.max(0, (vp.X - frame.AbsoluteSize.X) * 0.5)
		frame.Position = UDim2.fromOffset(x, minY)
	end)

	-- ========= TOGGLE LOGIC (UI) =========
	local tweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
	local isOn = true

	local function setToggle(state)
		isOn = state
		local bgOn  = Color3.fromRGB(50, 200, 100)
		local bgOff = Color3.fromRGB(255, 50, 50)
		if isOn then
			TweenService:Create(toggleWrap, tweenInfo, {BackgroundColor3 = bgOn}):Play()
			TweenService:Create(knob, tweenInfo, {Position = UDim2.fromOffset(22, 2)}):Play()
		else
			TweenService:Create(toggleWrap, tweenInfo, {BackgroundColor3 = bgOff}):Play()
			TweenService:Create(knob, tweenInfo, {Position = UDim2.fromOffset(2, 2)}):Play()
		end
	end

	-- ========= FLIGHT LOGIC =========
	magictis_cancelFlight = function()
		if TweenObj then TweenObj:Cancel() TweenObj=nil end
		Flying=false
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
		TweenObj.Completed:Connect(function() TweenObj=nil Flying=false end)
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
		if healthConn then healthConn:Disconnect() healthConn=nil end
		if Enabled then
			healthConn = Humanoid.HealthChanged:Connect(magictis_onHealthChanged)
		end
	end

	-- ========= APPLY ENABLED ========
	local function magictis_applyEnabled(state)
		Enabled = state
		setToggle(Enabled)

		if not Enabled then
			magictis_cancelFlight()
			Flying = false
			if healthConn then healthConn:Disconnect() healthConn=nil end
		else
			if LP.Character and LP.Character:FindFirstChild("Humanoid") then
				Humanoid = LP.Character:FindFirstChild("Humanoid")
				if healthConn then healthConn:Disconnect() end
				healthConn = Humanoid.HealthChanged:Connect(magictis_onHealthChanged)
				magictis_onHealthChanged(Humanoid.Health)
			end
		end
	end

	-- ========= TOGGLE INPUT =========
	local toggling = false
	local function magictis_onToggleClick()
		if toggling then return end
		toggling = true
		local nextState = not isOn
		setToggle(nextState)
		magictis_applyEnabled(nextState)
		isOn = nextState
		task.delay(0.05, function() toggling = false end)
	end

	toggleWrap.Activated:Connect(magictis_onToggleClick)
	knob.Activated:Connect(magictis_onToggleClick)

	-- ========= DRAG ========
	do
		local function pointerPos(input)
			return (input.UserInputType == Enum.UserInputType.Touch)
				and Vector2.new(input.Position.X, input.Position.Y)
				or UserInputService:GetMouseLocation()
		end
		local function over(inst, pos)
			if not (inst and inst.Parent) then return false end
			local p, s = inst.AbsolutePosition, inst.AbsoluteSize
			return pos.X >= p.X and pos.X <= p.X+s.X and pos.Y >= p.Y and pos.Y <= p.Y+s.Y
		end
		local function overAny(list, pos)
			for _, inst in ipairs(list) do
				if over(inst, pos) then return true end
			end
			return false
		end

		local dragging = false
		local dragStart, startPos

		frame.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				local pos = pointerPos(input)
				if overAny({toggleWrap, knob}, pos) then return end
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

	-- ========= BIND CHARACTER & INIT =========
	if LP.Character then magictis_bindCharacter(LP.Character) end
	LP.CharacterAdded:Connect(magictis_bindCharacter)

	task.defer(function()
		setToggle(Enabled)
		magictis_applyEnabled(Enabled)
	end)
end
