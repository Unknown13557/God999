local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer

-- GUI hiển thị
local gui = Instance.new("ScreenGui")
gui.Name = "AltitudeTestGui"
gui.ResetOnSpawn = false
gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local label = Instance.new("TextLabel")
label.Parent = gui
label.Size = UDim2.fromOffset(220, 40)
label.Position = UDim2.fromOffset(20, 20)
label.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
label.BackgroundTransparency = 0.2
label.BorderSizePixel = 0
label.TextColor3 = Color3.fromRGB(0, 255, 120)
label.Font = Enum.Font.SourceSansBold
label.TextSize = 20
label.TextXAlignment = Enum.TextXAlignment.Left
label.TextYAlignment = Enum.TextYAlignment.Center
label.Text = "Y: ---"

-- cập nhật real-time
RunService.RenderStepped:Connect(function()
	local char = LocalPlayer.Character
	local hrp = char and char:FindFirstChild("HumanoidRootPart")
	if hrp then
		label.Text = string.format("Y: %.2f", hrp.Position.Y)
	else
		label.Text = "Y: ---"
	end
end)
