local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- ===== CONFIG =====
local TOTAL_MINUTES = 30
local TOTAL_SECONDS_EXTRA = 1   -- ví dụ 0p20s; đổi tùy ý

-- tổng thời gian (cho phép < 60s). Nếu bằng 0 hoàn toàn, đặt về 60s
local TOTAL_SECONDS = (TOTAL_MINUTES * 60) + (TOTAL_SECONDS_EXTRA or 0)
if TOTAL_SECONDS <= 0 then TOTAL_SECONDS = 60 end

local REJOIN_RETRY_LIMIT, REJOIN_RETRY_DELAY = 10, 2
local TOP_DISPLAY_ORDER, TOP_Z = 817622, 50

-- ===== THEME =====
local THEME = {
	FrameBgTransparency = 0.7,
	FrameBgColor = Color3.fromRGB(20, 20, 20),

	BoxBgTransparency = 0.85,
	BoxBgColor = Color3.fromRGB(30, 30, 30),
	BoxStrokeColor = Color3.fromRGB(140, 140, 140),
	BoxStrokeThickness = 1.6,
	BoxCorner = 8,

	TextColor = Color3.fromRGB(235, 235, 235),
	Font = Enum.Font.GothamBold,

	BtnOnColor  = Color3.fromRGB(88, 198, 120),
	BtnOffColor = Color3.fromRGB(210, 88, 88),
	BtnTextColor= Color3.fromRGB(25,25,25),
}

-- ===== STATE =====
local enabled = true                 -- ON mặc định
local remaining = TOTAL_SECONDS
local ticking = false
local teleporting = false            -- ⚠️ trạng thái đang teleport: khóa vẽ UI
local ui = {}

-- ===== UI =====
local function createUI()
	local pg = player:WaitForChild("PlayerGui")
	local old = pg:FindFirstChild("AutoRejoinUI")
	if old then old:Destroy() end

	local gui = Instance.new("ScreenGui")
	gui.Name = "AutoRejoinUI"
	gui.ResetOnSpawn = false
	gui.IgnoreGuiInset = true
	gui.DisplayOrder = TOP_DISPLAY_ORDER
	gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	gui.Parent = pg

	local frame = Instance.new("Frame")
	frame.Size = UDim2.fromOffset(10, 40)
	frame.AutomaticSize = Enum.AutomaticSize.X
	frame.AnchorPoint = Vector2.new(0.5, 0)
	frame.Position = UDim2.fromScale(0.5, 0.1)
	frame.BackgroundColor3 = THEME.FrameBgColor
	frame.BackgroundTransparency = THEME.FrameBgTransparency
	frame.BorderSizePixel = 0
	frame.Active = true
	frame.ZIndex = TOP_Z
	frame.Parent = gui

	Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)
	local pad = Instance.new("UIPadding", frame)
	pad.PaddingLeft  = UDim.new(0, 6)
	pad.PaddingRight = UDim.new(0, 6)

	local layout = Instance.new("UIListLayout", frame)
	layout.FillDirection = Enum.FillDirection.Horizontal
	layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	layout.VerticalAlignment = Enum.VerticalAlignment.Center
	layout.Padding = UDim.new(0, 4)

	local function createBox()
		local box = Instance.new("Frame")
		box.Size = UDim2.fromOffset(56, 32)
		box.BackgroundColor3 = THEME.BoxBgColor
		box.BackgroundTransparency = THEME.BoxBgTransparency
		box.BorderSizePixel = 0
		box.ZIndex = TOP_Z
		box.Parent = frame

		Instance.new("UICorner", box).CornerRadius = UDim.new(0, THEME.BoxCorner)
		local stroke = Instance.new("UIStroke", box)
		stroke.Color = THEME.BoxStrokeColor
		stroke.Thickness = THEME.BoxStrokeThickness
		stroke.Transparency = 0.25

		local lbl = Instance.new("TextLabel")
		lbl.BackgroundTransparency = 1
		lbl.Size = UDim2.fromScale(1,1)
		lbl.Text = "00"
		lbl.TextColor3 = THEME.TextColor
		lbl.Font = THEME.Font
		lbl.TextScaled = true
		lbl.ZIndex = TOP_Z + 1
		lbl.Parent = box
		local limit = Instance.new("UITextSizeConstraint", lbl)
		limit.MaxTextSize = 24
		return lbl
	end

	local textM = createBox()
	local textS = createBox()

	local btn = Instance.new("TextButton")
	btn.Size = UDim2.fromOffset(54, 28)
	btn.BackgroundColor3 = enabled and THEME.BtnOnColor or THEME.BtnOffColor
	btn.Text = enabled and "ON" or "OFF"
	btn.TextColor3 = THEME.BtnTextColor
	btn.Font = THEME.Font
	btn.TextScaled = true
	btn.BorderSizePixel = 0
	btn.ZIndex = TOP_Z + 2
	btn.Parent = frame
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0,6)

	-- Toggle ON/OFF (debounce + không rejoin ngay khi bật lại)
	local btnDb = false
	btn.MouseButton1Click:Connect(function()
		if btnDb or teleporting then return end
		btnDb = true
		enabled = not enabled
		btn.BackgroundColor3 = enabled and THEME.BtnOnColor or THEME.BtnOffColor
		btn.Text = enabled and "ON" or "OFF"
		if enabled and remaining <= 0 then
			remaining = TOTAL_SECONDS -- resume không rejoin ngay
		end
		task.delay(0.15, function() btnDb = false end)
	end)

	-- Drag GUI (stable, clamp 4 cạnh, không giật, có toggle exception)

	do
	local UserInputService = game:GetService("UserInputService")
	local GuiService = game:GetService("GuiService")

	local RESPECT_COREGUI = false
	local TOP_MARGIN = 0

	local function pointerPos(input)
		return (input.UserInputType == Enum.UserInputType.Touch)
			and Vector2.new(input.Position.X, input.Position.Y)
			or UserInputService:GetMouseLocation()
	end

	local function over(inst, pos)
		if not inst or not inst:IsDescendantOf(game) then return false end
		local p, s = inst.AbsolutePosition, inst.AbsoluteSize
		return pos.X >= p.X and pos.X <= p.X + s.X and pos.Y >= p.Y and pos.Y <= p.Y + s.Y
	end

	local dragging = false
	local dragStart, startPos

	frame.Active = true
	frame.Draggable = false

	frame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			local pos = pointerPos(input)
			if over(btn, pos) then return end
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
				local pad = frame:FindFirstChildOfClass("UIPadding")
				local leftPad = (pad and pad.PaddingLeft.Offset) or 0
				local rightPad = (pad and pad.PaddingRight.Offset) or 0
				local minX = -leftPad
				local maxX = vp.X - (frame.AbsoluteSize.X - rightPad)
				newX = math.clamp(newX, minX, math.max(minX, maxX))
				newY = math.clamp(newY, minY, math.max(minY, vp.Y - frame.AbsoluteSize.Y))
			end
			frame.Position = UDim2.fromOffset(newX, newY)
		end
	end)

	local function placeTopCentered()
		local cam = workspace.CurrentCamera
		if not cam then return end
		local vp = cam.ViewportSize
		local pad = frame:FindFirstChildOfClass("UIPadding")
		local leftPad = (pad and pad.PaddingLeft.Offset) or 0
		local rightPad = (pad and pad.PaddingRight.Offset) or 0
		local topInset = GuiService:GetGuiInset().Y
		local minY = (RESPECT_COREGUI and (topInset + TOP_MARGIN) or TOP_MARGIN)
		local minX = -leftPad
		local maxX = vp.X - (frame.AbsoluteSize.X - rightPad)
		local centerX = math.floor((minX + maxX) / 2 + 0.5)
		frame.Position = UDim2.fromOffset(centerX, minY)
	end

	task.defer(function()
		repeat task.wait() until frame.AbsoluteSize.X > 0
		local abs = frame.AbsolutePosition
		frame.Position = UDim2.fromOffset(abs.X, abs.Y)
		placeTopCentered()
	end)

	frame:GetPropertyChangedSignal("AbsoluteSize"):Once(placeTopCentered)

	local function hookViewportChanged()
		local cam = workspace.CurrentCamera
		if not cam then return end
		cam:GetPropertyChangedSignal("ViewportSize"):Connect(function()
			if not dragging then placeTopCentered() end
		end)
	end
	if workspace.CurrentCamera then hookViewportChanged() end
	workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(hookViewportChanged)
	end
	-- Ẩn/hiện nhanh
	UserInputService.InputBegan:Connect(function(input, gp)
		if gp then return end
		if input.KeyCode == Enum.KeyCode.RightShift then
			frame.Visible = not frame.Visible
		end
	end)

	ui.gui, ui.frame, ui.textM, ui.textS, ui.btn = gui, frame, textM, textS, btn
end

-- ===== Helper =====
local function pad2(n) n = math.max(0, math.floor(n or 0)) return (n < 10 and ("0"..n) or tostring(n)) end
local function show(m, s)
	-- KHÔNG vẽ lại khi đang teleport để tránh "flash" 00:20
	if teleporting then return end
	if ui.textM then ui.textM.Text = pad2(m) end
	if ui.textS then ui.textS.Text = pad2(s) end
end

-- ===== Rejoin Logic =====
local function rejoinSameInstanceWithRetry()
	for attempt = 1, REJOIN_RETRY_LIMIT do
		local ok, err = pcall(function()
			TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, player)
		end)
		if ok then return true end
		warn(("[AutoRejoin] Lần %d/%d thất bại: %s"):format(attempt, REJOIN_RETRY_LIMIT, tostring(err)))
		task.wait(REJOIN_RETRY_DELAY)
	end
	warn("[AutoRejoin] Quá 10 lần rejoin instance cũ. Hop sang public...")
	local ok2, err2 = pcall(function()
		TeleportService:Teleport(game.PlaceId, player)
	end)
	if not ok2 then warn("[AutoRejoin] Hop thất bại: ", err2) end
	return ok2
end

local function safeRejoinSmart()
	local playerCount = #Players:GetPlayers()
	if playerCount > 1 and game.JobId ~= "" then
		return rejoinSameInstanceWithRetry()
	else
		local ok, err = pcall(function()
			TeleportService:Teleport(game.PlaceId, player)
		end)
		if not ok then warn("[AutoRejoin] Teleport(place) thất bại: ", err) end
		return ok
	end
end

-- ===== Timer (no 00:20 flash) =====
local function runTimer()
	if ticking then return end
	ticking = true
	while true do
		if enabled and not teleporting then
			if remaining > 0 then
				show(math.floor(remaining/60), remaining % 60)
				task.wait(1)
				remaining -= 1
			else
				-- Vừa chạm 00:00: vẽ 00:00 một lần rồi chuyển sang teleporting
				show(0, 0)
				teleporting = true

				-- Thử rejoin/hop
				local ok = safeRejoinSmart()

				-- Nếu teleport thất bại (Studio / lỗi), quay lại đếm vòng mới
				if not ok then
					remaining = TOTAL_SECONDS
					teleporting = false
					-- không vẽ lại ngay TOTAL_SECONDS ở đây để tránh flash;
					-- vòng lặp tick tiếp theo sẽ vẽ đúng giá trị mới.
				else
					-- nếu teleport thành công thì client sẽ rời game; đoạn dưới hầu như không chạy
					return
				end
			end
		else
			-- OFF hoặc đang teleport: đừng trừ thời gian, đừng vẽ lại
			task.wait(0.05)
		end
	end
end

-- ===== Start =====
createUI()
show(math.floor(remaining/60), remaining % 60)

-- Giữ GUI trên cùng & tự phục hồi
RunService.Heartbeat:Connect(function()
	if ui.gui and ui.gui.DisplayOrder ~= TOP_DISPLAY_ORDER then ui.gui.DisplayOrder = TOP_DISPLAY_ORDER end
	if ui.frame and ui.frame.ZIndex ~= TOP_Z then ui.frame.ZIndex = TOP_Z end
end)
RunService.Stepped:Connect(function()
	if not ui.gui or not ui.gui.Parent then
		createUI()
		show(math.floor(remaining/60), remaining % 60)
	end
end)

task.defer(runTimer)
