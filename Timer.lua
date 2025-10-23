local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

local TOP_DISPLAY_ORDER, TOP_Z = 999999, 50
local elapsed = 0
local ui = {}

local THEME = {
	FrameBgTransparency = 0.55,
	FrameBgColor = Color3.fromRGB(25,25,25),

	BoxBgTransparency = 0.2,
	BoxBgColor = Color3.fromRGB(35,35,35),
	BoxStrokeColor = Color3.fromRGB(150,150,150),
	BoxStrokeThickness = 1.2,
	BoxCorner = 8,

	TextColor = Color3.fromRGB(240,240,240),
	UnitColor = Color3.fromRGB(200,200,200),
	Font = Enum.Font.GothamBold,
}

local BOX_W, BOX_H = 52, 30
local UNIT_W = 16
local OUTER_GAP, INNER_GAP = 4, 3

local function createUI()
	local pg = player:WaitForChild("PlayerGui")
	local old = pg:FindFirstChild("TimerUI")
	if old then old:Destroy() end

	local gui = Instance.new("ScreenGui")
	gui.Name = "TimerUI"
	gui.ResetOnSpawn = false
	gui.IgnoreGuiInset = true
	gui.DisplayOrder = TOP_DISPLAY_ORDER
	gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	gui.Parent = pg

	local frame = Instance.new("Frame")
	frame.Size = UDim2.fromOffset(10, BOX_H + 8)
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
	local layout = Instance.new("UIListLayout", frame)
	layout.FillDirection = Enum.FillDirection.Horizontal
	layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	layout.VerticalAlignment = Enum.VerticalAlignment.Center
	layout.Padding = UDim.new(0, OUTER_GAP)

	local function numberBox(parent)
		local box = Instance.new("Frame")
		box.Size = UDim2.fromOffset(BOX_W, BOX_H)
		box.AutomaticSize = Enum.AutomaticSize.X
		box.BackgroundColor3 = THEME.BoxBgColor
		box.BackgroundTransparency = THEME.BoxBgTransparency
		box.BorderSizePixel = 0
		box.ZIndex = TOP_Z
		box.Parent = parent

		Instance.new("UICorner", box).CornerRadius = UDim.new(0, THEME.BoxCorner)
		local stroke = Instance.new("UIStroke", box)
		stroke.Color = THEME.BoxStrokeColor
		stroke.Thickness = THEME.BoxStrokeThickness
		stroke.Transparency = 0.3

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
		limit.MaxTextSize = 20
		return lbl
	end

	local function makePair(ch)
		local pair = Instance.new("Frame")
		pair.BackgroundTransparency = 1
		pair.AutomaticSize = Enum.AutomaticSize.X
		pair.Size = UDim2.fromOffset(BOX_W + UNIT_W + INNER_GAP, BOX_H)
		pair.ZIndex = TOP_Z
		pair.Parent = frame

		local lay = Instance.new("UIListLayout", pair)
		lay.FillDirection = Enum.FillDirection.Horizontal
		lay.HorizontalAlignment = Enum.HorizontalAlignment.Center
		lay.VerticalAlignment = Enum.VerticalAlignment.Center
		lay.Padding = UDim.new(0, INNER_GAP)

		local num = numberBox(pair)

		local tag = Instance.new("TextLabel")
		tag.BackgroundTransparency = 1
		tag.Size = UDim2.fromOffset(UNIT_W, BOX_H)
		tag.Text = ch
		tag.TextColor3 = THEME.UnitColor
		tag.Font = THEME.Font
		tag.TextScaled = true
		tag.ZIndex = TOP_Z + 1
		tag.Parent = pair
		local limit = Instance.new("UITextSizeConstraint", tag)
		limit.MaxTextSize = 18

		return num
	end

	local tH = makePair("H")
	local tM = makePair("M")
	local tS = makePair("S")

	local dragging, dragStart, startPos
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
			local delta = input.Position - dragStart
			frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)

	UserInputService.InputBegan:Connect(function(input, gp)
		if gp then return end
		if input.KeyCode == Enum.KeyCode.RightShift then
			frame.Visible = not frame.Visible
		end
	end)

	ui.gui, ui.frame, ui.tH, ui.tM, ui.tS = gui, frame, tH, tM, tS
end

local function pad2(n)
	n = math.max(0, math.floor(n or 0))
	return (n < 10 and ("0"..n) or tostring(n))
end

local function show(h, m, s)
	ui.tH.Text = pad2(h)
	ui.tM.Text = pad2(m)
	ui.tS.Text = pad2(s)
end

local function runTimer()
	while true do
		local h = math.floor(elapsed / 3600)
		local m = math.floor((elapsed % 3600) / 60)
		local s = elapsed % 60
		show(h, m, s)
		task.wait(1)
		elapsed += 1
	end
end

createUI()
show(0,0,0)

RunService.Heartbeat:Connect(function()
	if ui.gui and ui.gui.DisplayOrder ~= TOP_DISPLAY_ORDER then
		ui.gui.DisplayOrder = TOP_DISPLAY_ORDER
	end
end)
RunService.Stepped:Connect(function()
	if not ui.gui or not ui.gui.Parent then createUI() end
end)

task.defer(runTimer)
