--// AUTO EXECUTOR (RUN ON FOCUS LOST)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

pcall(function()
	if LocalPlayer.PlayerGui:FindFirstChild("AutoExeGui") then
		LocalPlayer.PlayerGui.AutoExeGui:Destroy()
	end
end)

local gui = Instance.new("ScreenGui")
gui.Name = "AutoExeGui"
gui.ResetOnSpawn = false
gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local main = Instance.new("Frame")
main.Parent = gui
main.Size = UDim2.fromOffset(500, 260)
main.Position = UDim2.fromOffset(100, 100)
main.BackgroundColor3 = Color3.fromRGB(25,25,25)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0,8)

local stroke = Instance.new("UIStroke", main)
stroke.Color = Color3.new(1,1,1)

-- CODE BOX
local codeBox = Instance.new("TextBox")
codeBox.Parent = main
codeBox.Size = UDim2.new(1,-20,0,140)
codeBox.Position = UDim2.fromOffset(10,10)
codeBox.MultiLine = true
codeBox.ClearTextOnFocus = false
codeBox.TextXAlignment = Enum.TextXAlignment.Left
codeBox.TextYAlignment = Enum.TextYAlignment.Top
codeBox.Font = Enum.Font.Code
codeBox.TextSize = 14
codeBox.TextColor3 = Color3.fromRGB(0,255,180)
codeBox.BackgroundColor3 = Color3.fromRGB(15,15,15)
codeBox.Text = "-- type code and click outside to auto run"
Instance.new("UICorner", codeBox).CornerRadius = UDim.new(0,6)

-- CONSOLE
local console = Instance.new("TextLabel")
console.Parent = main
console.Size = UDim2.new(1,-20,0,70)
console.Position = UDim2.fromOffset(10,160)
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
destroyBtn.Size = UDim2.fromOffset(90,30)
destroyBtn.Position = UDim2.new(1,-100,0,10)
destroyBtn.Text = "X"
destroyBtn.Font = Enum.Font.SourceSansBold
destroyBtn.TextSize = 18
destroyBtn.TextColor3 = Color3.new(1,1,1)
destroyBtn.BackgroundColor3 = Color3.fromRGB(200,60,60)
Instance.new("UICorner", destroyBtn).CornerRadius = UDim.new(0,6)

destroyBtn.MouseButton1Click:Connect(function()
	gui:Destroy()
end)

-- AUTO EXECUTE LOGIC
codeBox.FocusLost:Connect(function(enterPressed)

	console.Text = "Running...\n"

	local source = codeBox.Text
	local func, compileErr = loadstring(source)

	if not func then
		console.Text ..= "Compile Error:\n" .. compileErr
		return
	end

	local success, runtimeErr = pcall(func)

	if not success then
		console.Text ..= "Runtime Error:\n" .. runtimeErr
	else
		console.Text ..= "Executed Successfully."
	end

end)
