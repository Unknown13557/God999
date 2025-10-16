-----Tool-Rejoin-----
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

-- ===== Cấu hình =====
local TOTAL_MINUTES = 30
local TOTAL_SECONDS = TOTAL_MINUTES * 60

local REJOIN_RETRY_LIMIT = 10
local REJOIN_RETRY_DELAY = 2

-- ===== UI luôn trên cùng =====
local TOP_DISPLAY_ORDER = 999999
local TOP_Z = 50

-- ===== Chủ đề (màu & style) =====
local THEME = {
	FrameBgTransparency = 0.7,             -- > 60% trong suốt
	FrameBgColor = Color3.fromRGB(20, 20, 20),

	BoxBgTransparency = 0.85,              -- khung trong hơn nền
	BoxBgColor = Color3.fromRGB(30, 30, 30),
	BoxStrokeColor = Color3.fromRGB(140, 140, 140),
	BoxStrokeThickness = 1.6,
	BoxCorner = 8,

	TextColor = Color3.fromRGB(235, 235, 235),
	Font = Enum.Font.GothamBold
}

-- ===== UI =====
local function createUI()
	local gui = Instance.new("ScreenGui")
	gui.Name = "AutoRejoinUI"
	gui.ResetOnSpawn = false
	gui.IgnoreGuiInset = true
	gui.DisplayOrder = TOP_DISPLAY_ORDER
	gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	gui.Enabled = true
	gui.Parent = player:WaitForChild("PlayerGui")

	local frame = Instance.new("Frame")
	frame.Name = "TimerFrame"
	frame.Size = UDim2.fromOffset(140, 40) -- nhỏ hơn
	frame.AnchorPoint = Vector2.new(0.5, 0)
	frame.Position = UDim2.fromScale(0.5, 0.1)
	frame.BackgroundColor3 = THEME.FrameBgColor
	frame.BackgroundTransparency = THEME.FrameBgTransparency
	frame.BorderSizePixel = 0
	frame.Active = true
	frame.ZIndex = TOP_Z
	frame.Parent = gui

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 10)
	corner.Parent = frame

	local layout = Instance.new("UIListLayout")
	layout.FillDirection = Enum.FillDirection.Horizontal
	layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	layout.VerticalAlignment = Enum.VerticalAlignment.Center
	layout.Padding = UDim.new(0, 6)
	layout.Parent = frame

	-- Một khung kẻ hiện đại (thay cho [NN])
	local function createModernBox()
		local box = Instance.new("Frame")
		box.BackgroundColor3 = THEME.BoxBgColor
		box.BackgroundTransparency = THEME.BoxBgTransparency
		box.BorderSizePixel = 0
		box.Size = UDim2.fromOffset(56, 32) -- nhỏ hơn
		box.ZIndex = TOP_Z

		local bCorner = Instance.new("UICorner")
		bCorner.CornerRadius = UDim.new(0, THEME.BoxCorner)
		bCorner.Parent = box

		local stroke = Instance.new("UIStroke")
		stroke.Color = THEME.BoxStrokeColor
		stroke.Thickness = THEME.BoxStrokeThickness
		stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		stroke.Transparency = 0.25
		stroke.Parent = box

		local lbl = Instance.new("TextLabel")
		lbl.BackgroundTransparency = 1
		lbl.Size = UDim2.fromScale(1, 1)
		lbl.Text = "00" -- KHÔNG còn dấu ngoặc
		lbl.TextColor3 = THEME.TextColor
		lbl.Font = THEME.Font
		lbl.TextScaled = true
		lbl.ZIndex = TOP_Z + 1
		lbl.Parent = box

		local limit = Instance.new("UITextSizeConstraint")
		limit.MaxTextSize = 24
		limit.Parent = lbl

		return box, lbl
	end

	local boxM, textM = createModernBox()
	local boxS, textS = createModernBox()
	boxM.Parent = frame
	boxS.Parent = frame

	-- Kéo thả
	do
		local dragging, dragStart, startPos
		local function update(input)
			local delta = input.Position - dragStart
			frame.Position = UDim2.new(
				startPos.X.Scale, startPos.X.Offset + delta.X,
				startPos.Y.Scale, startPos.Y.Offset + delta.Y
			)
		end

		frame.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
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
				update(input)
			end
		end)
	end

	-- Hotkey ẩn/hiện (RightShift)
	UserInputService.InputBegan:Connect(function(input, gp)
		if gp then return end
		if input.KeyCode == Enum.KeyCode.RightShift then
			frame.Visible = not frame.Visible
		end
	end)

	return gui, frame, textM, textS
end

local gui, frame, textM, textS = createUI()

-- ===== Helper =====
local function pad2(n) return (n < 10 and ("0"..n) or tostring(n)) end
local function show(m, s)
	if textM and textS then
		textM.Text = pad2(m) -- KHÔNG còn ngoặc
		textS.Text = pad2(s)
	end
end

-- Watchdog giữ GUI trên cùng & sống
RunService.Heartbeat:Connect(function()
	if gui and gui.DisplayOrder ~= TOP_DISPLAY_ORDER then gui.DisplayOrder = TOP_DISPLAY_ORDER end
	if frame and frame.ZIndex ~= TOP_Z then frame.ZIndex = TOP_Z end
end)
RunService.Stepped:Connect(function()
	if not gui or not gui.Parent then
		gui, frame, textM, textS = createUI()
	elseif gui.Parent ~= player:FindFirstChild("PlayerGui") then
		gui.Parent = player:WaitForChild("PlayerGui")
	end
	if gui and gui.Enabled == false then gui.Enabled = true end
end)

-- ========== Rejoin Logic ==========
local function rejoinSameInstanceWithRetry()
	-- Chỉ gọi khi còn người khác trong server
	local attempts = 0
	while attempts < REJOIN_RETRY_LIMIT do
		attempts += 1
		local ok, err = pcall(function()
			TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, player)
		end)
		if ok then
			return true
		else
			warn(("[AutoRejoin] Lần %d/%d thất bại: %s")
				:format(attempts, REJOIN_RETRY_LIMIT, tostring(err)))
			task.wait(REJOIN_RETRY_DELAY)
		end
	end
	-- Sau 10 lần vẫn thất bại -> hop server public khác (để Roblox tự chọn)
	warn("[AutoRejoin] Quá 10 lần rejoin instance cũ. Đang hop sang server public khác...")
	local ok2, err2 = pcall(function()
		TeleportService:Teleport(game.PlaceId, player)
	end)
	if not ok2 then
		warn("[AutoRejoin] Hop server cũng thất bại: ", err2)
	end
	return ok2
end

local function safeRejoinSmart()
	local playerCount = #Players:GetPlayers()

	if playerCount > 1 and game.JobId ~= "" then
		-- Còn người khác -> cố rejoin đúng JobId, hết quota thì hop
		return rejoinSameInstanceWithRetry()
	else
		-- Chỉ có mình -> server sẽ đóng -> hop luôn
		local ok, err = pcall(function()
			TeleportService:Teleport(game.PlaceId, player)
		end)
		if not ok then
			warn("[AutoRejoin] Teleport(place) thất bại: ", err)
		end
		return ok
	end
end

-- ========== Đếm ngược ==========
local function countdown(seconds)
	local t = seconds
	while t > 0 do
		show(math.floor(t/60), t % 60)
		task.wait(1)
		t -= 1
	end
	safeRejoinSmart()
end

-- Start
show(TOTAL_MINUTES, 0)
task.defer(function()
	countdown(TOTAL_SECONDS)
end)
