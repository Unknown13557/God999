-- ========== LOGIC (GỌN HƠN, GIỮ HÀNH VI) ==========
local P   = game:GetService("Players")
local LP  = P.LocalPlayer
local RS  = game:GetService("RunService")
local WS  = workspace
local UIS = game:GetService("UserInputService")
local GS  = game:GetService("GuiService")

local RESPECT_COREGUI, TOP_MARGIN = false, 0
local nowe, tpwalking = false, false

-- helpers
local function char() return LP and LP.Character end
local function hum()
	local c = char()
	return c and (c:FindFirstChildWhichIsA("Humanoid") or c:FindFirstChildOfClass("Humanoid"))
end
local function root()
	local c = char()
	return c and (c:FindFirstChild("HumanoidRootPart"))
end

-- toggle humanoid states (DRY)
local states = {
	Enum.HumanoidStateType.Climbing, Enum.HumanoidStateType.FallingDown, Enum.HumanoidStateType.Flying,
	Enum.HumanoidStateType.Freefall, Enum.HumanoidStateType.GettingUp, Enum.HumanoidStateType.Jumping,
	Enum.HumanoidStateType.Landed, Enum.HumanoidStateType.Physics, Enum.HumanoidStateType.PlatformStanding,
	Enum.HumanoidStateType.Ragdoll, Enum.HumanoidStateType.Running, Enum.HumanoidStateType.RunningNoPhysics,
	Enum.HumanoidStateType.Seated, Enum.HumanoidStateType.StrafingNoPhysics, Enum.HumanoidStateType.Swimming
}
local function setStatesEnabled(h, v)
	for _, s in ipairs(states) do h:SetStateEnabled(s, v) end
end

-- noclip (gọn)
local noclipConn, noclipCache = nil, {}
local function cachePart(p)
	if p and p:IsA("BasePart") then
		if noclipCache[p] == nil then noclipCache[p] = p.CanCollide end
		p.CanCollide = false
	end
end
local function startNoclip()
	if noclipConn or not char() then return end
	for _, p in ipairs(char():GetDescendants()) do cachePart(p) end
	noclipConn = RS.Stepped:Connect(function()
		local c = char(); if not c then return end
		for p in pairs(noclipCache) do if p and p.Parent then p.CanCollide = false end end
		for _, p in ipairs(c:GetDescendants()) do if p:IsA("BasePart") and noclipCache[p] == nil then cachePart(p) end end
	end)
end
local function stopNoclip()
	if noclipConn then noclipConn:Disconnect() noclipConn = nil end
	for p, prev in pairs(noclipCache) do if p and p.Parent then p.CanCollide = (prev == nil) and true or prev end end
	table.clear(noclipCache)
end

-- drag UI (gọn)
local dragging, dragStart, startPos = false, nil, nil
local function pointerPos(input)
	return (input.UserInputType == Enum.UserInputType.Touch) and Vector2.new(input.Position.X, input.Position.Y) or UIS:GetMouseLocation()
end
local function over(inst, pos)
	local p, s = inst.AbsolutePosition, inst.AbsoluteSize
	return pos.X >= p.X and pos.X <= p.X + s.X and pos.Y >= p.Y and pos.Y <= p.Y + s.Y
end
local function clampToViewport()
	local cam = WS.CurrentCamera; if not cam then return end
	local vp = cam.ViewportSize
	local topInset = GS:GetGuiInset().Y
	local minY = (RESPECT_COREGUI and (topInset + TOP_MARGIN) or TOP_MARGIN)
	local abs = Frame.AbsolutePosition
	local x = math.clamp(abs.X, 0, math.max(0, vp.X - Frame.AbsoluteSize.X))
	local y = math.clamp(abs.Y, minY, math.max(minY, vp.Y - Frame.AbsoluteSize.Y))
	Frame.Position = UDim2.fromOffset(x, y)
end

Frame.Active, Frame.Draggable = true, false
Frame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		if over(onof, pointerPos(input)) then return end
		dragging, dragStart, startPos = true, input.Position, Frame.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then dragging = false end
		end)
	end
end)
Frame.InputChanged:Connect(function(input)
	if not dragging then return end
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		local d = input.Position - dragStart
		local nx, ny = startPos.X.Offset + d.X, startPos.Y.Offset + d.Y
		local cam = WS.CurrentCamera
		if cam then
			local vp = cam.ViewportSize
			local topInset = GS:GetGuiInset().Y
			local minY = (RESPECT_COREGUI and (topInset + TOP_MARGIN) or TOP_MARGIN)
			nx = math.clamp(nx, 0, math.max(0, vp.X - Frame.AbsoluteSize.X))
			ny = math.clamp(ny, minY, math.max(minY, vp.Y - Frame.AbsoluteSize.Y))
		end
		Frame.Position = UDim2.fromOffset(nx, ny)
	end
end)
task.defer(clampToViewport)
local function hookViewportChanged()
	local cam = WS.CurrentCamera; if not cam then return end
	cam:GetPropertyChangedSignal("ViewportSize"):Connect(function() if not dragging then clampToViewport() end end)
end
if WS.CurrentCamera then hookViewportChanged() end
WS:GetPropertyChangedSignal("CurrentCamera"):Connect(hookViewportChanged)

-- TP-walk spawner (gọn)
local function stopTPWalk() tpwalking = false end
local function startTPWalk(n)
	stopTPWalk(); tpwalking = true
	for _ = 1, n do
		task.spawn(function()
			local hb = RS.Heartbeat
			while tpwalking do
				hb:Wait()
				local c, h = char(), hum()
				if not (c and h and h.Parent) then break end
				if h.MoveDirection.Magnitude > 0 then c:TranslateBy(h.MoveDirection) end
			end
		end)
	end
end

-- Fly core (giữ nhánh R6/R15 như cũ, nhưng gọn)
local function flyLoop()
	local c, h = char(), hum(); if not (c and h) then return end
	local isR6 = (h.RigType == Enum.HumanoidRigType.R6)
	local attach = isR6 and c:FindFirstChild("Torso") or c:FindFirstChild("UpperTorso"); if not attach then return end

	local ctrl, last = {f=0,b=0,l=0,r=0}, {f=0,b=0,l=0,r=0}
	local maxspeed, speed = 50, 0

	local bg = Instance.new("BodyGyro", attach)
	bg.P, bg.maxTorque, bg.cframe = 9e4, Vector3.new(9e9,9e9,9e9), attach.CFrame
	local bv = Instance.new("BodyVelocity", attach)
	bv.velocity, bv.maxForce = Vector3.new(0,0.1,0), Vector3.new(9e9,9e9,9e9)

	if nowe then h.PlatformStand = true end

	local stepWait = isR6 and function() RS.RenderStepped:Wait() end or task.wait
	while (nowe == true) or h.Health == 0 do
		stepWait()

		if (ctrl.l + ctrl.r ~= 0) or (ctrl.f + ctrl.b ~= 0) then
			speed = math.min(maxspeed, speed + .5 + (speed/maxspeed))
		elseif speed ~= 0 then
			speed = math.max(0, speed - 1)
		end

		local cam = WS.CurrentCamera
		if cam then
			local look = cam.CFrame.LookVector
			local offset = (cam.CFrame * CFrame.new(ctrl.l+ctrl.r, (ctrl.f+ctrl.b)*.2, 0)).p - cam.CFrame.p
			if (ctrl.l + ctrl.r ~= 0) or (ctrl.f + ctrl.b ~= 0) then
				bv.velocity = ((look * (ctrl.f+ctrl.b)) + offset) * speed
				last = {f=ctrl.f, b=ctrl.b, l=ctrl.l, r=ctrl.r}
			elseif speed ~= 0 then
				local llook = cam.CFrame.LookVector
				local loff  = (cam.CFrame * CFrame.new(last.l+last.r,(last.f+last.b)*.2,0)).p - cam.CFrame.p
				bv.velocity = ((llook * (last.f+last.b)) + loff) * speed
			else
				bv.velocity = Vector3.new()
			end
			bg.cframe = cam.CFrame * CFrame.Angles(-math.rad((ctrl.f+ctrl.b)*50*speed/maxspeed),0,0)
		end
	end

	ctrl, last, speed = {f=0,b=0,l=0,r=0}, {f=0,b=0,l=0,r=0}, 0
	bg:Destroy(); bv:Destroy()
	h.PlatformStand = false
	char().Animate.Disabled = false
	stopTPWalk()
end

-- Toggle nút fly
onof.MouseButton1Down:Connect(function()
	local h = hum(); if not h then return end

	if nowe then
		nowe = false
		pcall(stopNoclip)
		setStatesEnabled(h, true)
		h:ChangeState(Enum.HumanoidStateType.RunningNoPhysics)
	else
		nowe = true
		startTPWalk(speeds)
		char().Animate.Disabled = true
		for _, tr in ipairs((h:GetPlayingAnimationTracks())) do tr:AdjustSpeed(0) end
		pcall(startNoclip)
		setStatesEnabled(h, false)
		h:ChangeState(Enum.HumanoidStateType.Swimming)
	end

	-- giữ nguyên nhánh r6/r15 & cách chờ
	if h.RigType == Enum.HumanoidRigType.R6 or h.RigType == Enum.HumanoidRigType.R15 then
		flyLoop()
	end
end)

-- Giữ behavior nhấn & giữ để bay lên/xuống (gọn)
local function bindHold(btn, dy)
	local conn
	btn.MouseButton1Down:Connect(function()
		conn = btn.MouseEnter:Connect(function()
			while conn do
				task.wait()
				local r = root()
				if r then r.CFrame = r.CFrame * CFrame.new(0, dy, 0) end
			end
		end)
	end)
	btn.MouseLeave:Connect(function() if conn then conn:Disconnect() conn = nil end end)
end
bindHold(up,   1)
bindHold(down,-1)

-- Character reset
P.LocalPlayer.CharacterAdded:Connect(function()
	task.wait(0.7)
	pcall(stopNoclip)
	local c, h = char(), hum()
	if c and h then
		h.PlatformStand = false
		c.Animate.Disabled = false
	end
end)

-- +/- speed (gọn, giữ behavior cũ)
plus.MouseButton1Down:Connect(function()
	speeds += 1
	speed.Text = speeds
	if nowe then startTPWalk(speeds) end
end)
mine.MouseButton1Down:Connect(function()
	if speeds == 1 then
		speed.Text = 'cannot be less than 1'
		task.wait(1)
	else
		speeds -= 1
	end
	speed.Text = speeds
	if nowe then startTPWalk(speeds) end
end)

-- Close double-click (gọn)
do
	local lastClick, win, orig = 0, 1, closebutton.TextColor3
	closebutton.MouseButton1Click:Connect(function()
		local now = tick()
		if now - lastClick <= win then
			main:Destroy()
		else
			lastClick = now
			closebutton.TextColor3 = Color3.fromRGB(255,255,255)
			task.delay(win, function()
				if tick() - lastClick >= win then closebutton.TextColor3 = orig end
			end)
		end
	end)
end

-- Minimize/restore (gọn)
local function setVisible(v)
	up.Visible = v; down.Visible = v; onof.Visible = v; plus.Visible = v; speed.Visible = v; mine.Visible = v
	mini.Visible = v; mini2.Visible = not v
	main.Frame.BackgroundTransparency = v and 0 or 1
	closebutton.Position = v and UDim2.new(0,0,-1,27) or UDim2.new(0,0,-1,57)
end
mini.MouseButton1Click:Connect(function() setVisible(false) end)
mini2.MouseButton1Click:Connect(function() setVisible(true) end)
-- ========== END ==========
