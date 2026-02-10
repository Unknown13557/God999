local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer

--// GUI
local gui = Instance.new("ScreenGui")
gui.Name = "PositionTestGui"
gui.ResetOnSpawn = false
gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local label = Instance.new("TextLabel")
label.Parent = gui
label.Size = UDim2.fromOffset(200, 70)
label.Position = UDim2.fromOffset(20, 20)
label.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
label.BackgroundTransparency = 0.15
label.BorderSizePixel = 0
label.TextColor3 = Color3.fromRGB(0, 255, 120)
label.Font = Enum.Font.SourceSansBold
label.TextSize = 18
label.TextWrapped = true
label.TextXAlignment = Enum.TextXAlignment.Left
label.TextYAlignment = Enum.TextYAlignment.Top
label.Text = "X: ---\nY: ---\nZ: ---"

--// Update realtime
RunService.RenderStepped:Connect(function()
	local char = LocalPlayer.Character
	local hrp = char and char:FindFirstChild("HumanoidRootPart")

	if hrp then
		local pos = hrp.Position
		label.Text = string.format(
			"X: %.2f\nY: %.2f\nZ: %.2f",
			pos.X,
			pos.Y,
			pos.Z
		)
	else
		label.Text = "X: ---\nY: ---\nZ: ---"
	end
end)
