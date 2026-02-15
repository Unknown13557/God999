--// AUTO EXECUTOR (RUN ON FOCUS LOST)
--// AUTO EXECUTOR PRO (TRACEBACK VERSION)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

pcall(function()
	if LocalPlayer.PlayerGui:FindFirstChild("AutoExePro") then
		LocalPlayer.PlayerGui.AutoExePro:Destroy()
	end
end)

local gui = Instance.new("ScreenGui")
gui.Name = "AutoExePro"
gui.ResetOnSpawn = false
gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local main = Instance.new("Frame")
main.Parent = gui
main.Size = UDim2.fromOffset(550, 300)
main.Position = UDim2.fromOffset(120, 120)
main.BackgroundColor3 = Color3.fromRGB(25,25,25)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0,8)

local stroke = Instance.new("UIStroke", main)
stroke.Color = Color3.new(1,1,1)
stroke.Thickness = 1

-- TITLE
local title = Instance.new("TextLabel")
title.Parent = main
title.Size = UDim2.new(1,0,0,30)
title.BackgroundTransparency = 1
title.Text = "Auto Executor (FocusLost)"
title.Font = Enum.Font.SourceSansBold
title.TextSize = 18
title.TextColor3 = Color3.new(1,1,1)

-- CODE BOX
local codeBox = Instance.new("TextBox")
codeBox.Parent = main
codeBox.Size = UDim2.new(1,-20,0,150)
codeBox.Position = UDim2.fromOffset(10,35)
codeBox.MultiLine = true
codeBox.ClearTextOnFocus = false
codeBox.TextXAlignment = Enum.TextXAlignment.Left
codeBox.TextYAlignment = Enum.TextYAlignment.Top
codeBox.Font = Enum.Font.Code
codeBox.TextSize = 15
codeBox.TextColor3 = Color3.fromRGB(0,255,180)
codeBox.BackgroundColor3 = Color3.fromRGB(15,15,15)
codeBox.Text = "-- type code and click outside to auto run"
Instance.new("UICorner", codeBox).CornerRadius = UDim.new(0,6)

-- CONSOLE
local console = Instance.new("TextLabel")
console.Parent = main
console.Size = UDim2.new(1,-20,0,80)
console.Position = UDim2.fromOffset(10,195)
console.BackgroundColor3 = Color3.fromRGB(15,15,15)
console.TextXAlignment = Enum.TextXAlignment.Left
console.TextYAlignment = Enum.TextYAlignment.Top
console.Font = Enum.Font.Code
console.TextSize = 14
console.TextColor3 = Color3.new(1,1,1)
console.TextWrapped = true
console.Text = "Console ready..."
Instance.new("UICorner", console).CornerRadius = UDim.new(0,6)

-- DESTROY BUTTON
local destroyBtn = Instance.new("TextButton")
destroyBtn.Parent = main
destroyBtn.Size = UDim2.fromOffset(40,25)
destroyBtn.Position = UDim2.new(1,-50,0,3)
destroyBtn.Text = "X"
destroyBtn.Font = Enum.Font.SourceSansBold
destroyBtn.TextSize = 16
destroyBtn.TextColor3 = Color3.new(1,1,1)
destroyBtn.BackgroundColor3 = Color3.fromRGB(200,60,60)
Instance.new("UICorner", destroyBtn).CornerRadius = UDim.new(0,6)

destroyBtn.MouseButton1Click:Connect(function()
	gui:Destroy()
end)

--==============================
-- EXECUTION LOGIC (TRACEBACK)
--==============================

codeBox.FocusLost:Connect(function()

	console.Text = "Running...\n"

	local source = codeBox.Text

	-- đặt tên chunk để lỗi đẹp hơn
	local func, compileErr = loadstring(source, "UserScript")

	if not func then
		console.Text ..= "Compile Error:\n" .. compileErr
		return
	end

	local function errorHandler(err)
		return debug.traceback(err, 2)
	end

	local success, runtimeErr = xpcall(func, errorHandler)

	if not success then
		console.Text ..= "Runtime Error:\n" .. runtimeErr
	else
		console.Text ..= "Executed Successfully."
	end

end)
