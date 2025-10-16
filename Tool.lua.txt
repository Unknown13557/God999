--=================== MAGIC TOOL (PACKED + SMOOTH) ===================
--== Services & Globals (khai một lần) ==--
local Players          = game:GetService("Players")
local UIS              = game:GetService("UserInputService")
local RS               = game:GetService("RunService")
local TweenService     = game:GetService("TweenService")
local TeleportService  = game:GetService("TeleportService")
local GuiService = game:GetService("GuiService")
local lp       = Players.LocalPlayer
local playerGui= lp:WaitForChild("PlayerGui")
--== Cleanup GUI cũ (nếu có) ==--
do
    local old = playerGui:FindFirstChild("FloatingMenuGUI")
    if old then old:Destroy() end
end

--== Theme & Layout ==--
local THEME = {
    Background = Color3.fromRGB(35,38,50),
    Titlebar   = Color3.fromRGB(65,50,90),
    Stroke     = Color3.fromRGB(180,140,255),
    Text       = Color3.fromRGB(255,255,255),
    Subtle     = Color3.fromRGB(210,180,255),
    Hover      = Color3.fromRGB(90,60,130),
    Accent     = Color3.fromRGB(150,90,200),
    ListIdle   = Color3.fromRGB(20,20,20),
}
local WINDOW_W, WINDOW_H = 300, 250
local TITLE_H, PAD = 28, 6

--== Utils ==--
local function viewport()
    local cam = workspace.CurrentCamera
    return (cam and cam.ViewportSize) or Vector2.new(1280,720)
end

local function clampToScreen(x, y, w, h)
    local v = viewport()
    return math.clamp(x, 0, v.X - (w or 0)), math.clamp(y, 0, v.Y - (h or 0))
end

local function tweenColor(inst, c, t)
    TweenService:Create(inst, TweenInfo.new(t or 0.12), {BackgroundColor3 = c}):Play()
end

--== ScreenGui ==--
local gui = Instance.new("ScreenGui")
gui.Name = "FloatingMenuGUI"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = false  -- để Roblox tự chừa safe area
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = playerGui

--== ICON (đen + viền đỏ, glyph ⚙) ==--
local icon = gui:FindFirstChild("MagicFloatingIcon") or Instance.new("ImageButton")
icon.Name = "MagicFloatingIcon"
icon.Size = UDim2.fromOffset(42,42)
icon.BackgroundColor3 = Color3.fromRGB(0,0,0)
icon.BackgroundTransparency = 0
icon.AutoButtonColor = true
icon.ImageTransparency = 1
icon.ZIndex = 1000
icon.Parent = gui

-- Bo tròn
local iconCorner = icon:FindFirstChildOfClass("UICorner") or Instance.new("UICorner")
iconCorner.CornerRadius = UDim.new(1,0)
iconCorner.Parent = icon

-- Viền đỏ
local iconStroke = icon:FindFirstChildOfClass("UIStroke") or Instance.new("UIStroke")
iconStroke.Color = Color3.fromRGB(255,50,50)
iconStroke.Thickness = 2
iconStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
iconStroke.Parent = icon

-- Giữ tỉ lệ vuông
local arc = icon:FindFirstChildOfClass("UIAspectRatioConstraint") or Instance.new("UIAspectRatioConstraint")
arc.AspectRatio = 1
arc.Parent = icon

-- Glyph ⚙ căn giữa tuyệt đối
local gear = icon:FindFirstChild("GearGlyph") or Instance.new("TextLabel")
gear.Name = "GearGlyph"
gear.BackgroundTransparency = 1
gear.AnchorPoint = Vector2.new(0.5, 0.5)
gear.Position = UDim2.fromScale(0.5, 0.5)
gear.Size = UDim2.fromScale(0.7, 0.7)
gear.Text = "⚙"
gear.Font = Enum.Font.GothamBold
gear.TextScaled = true
gear.TextColor3 = Color3.fromRGB(210,210,210)
gear.ZIndex = icon.ZIndex + 1
gear.Parent = icon

--== Window ==--
local window = Instance.new("Frame")
do
    local v = viewport()
    window.Position = UDim2.fromOffset((v.X-WINDOW_W)/2, math.max(12,(v.Y-WINDOW_H)/2))
end
window.Visible = true
window.Size = UDim2.fromOffset(WINDOW_W, WINDOW_H)
window.BackgroundColor3 = THEME.Background
window.BackgroundTransparency = 0.12
window.BorderSizePixel = 0
window.Parent = gui
Instance.new("UICorner", window).CornerRadius = UDim.new(0,8)
local wsStroke = Instance.new("UIStroke", window)
wsStroke.Color = THEME.Stroke
wsStroke.Transparency = 0.2

-- Toggle chỉ tại 1 nơi (click icon)
icon.MouseButton1Click:Connect(function()
    if window then window.Visible = not window.Visible end
end)

-- TitleBar (drag)
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1,0,0,TITLE_H)
titleBar.BackgroundColor3 = THEME.Titlebar
titleBar.BackgroundTransparency = 0.08
titleBar.BorderSizePixel = 0
titleBar.Parent = window

local title = Instance.new("TextLabel")
title.BackgroundTransparency = 1
title.Text = "⚙ Control Panel"
title.Font = Enum.Font.GothamBold
title.TextSize = 13
title.TextColor3 = THEME.Text
title.TextXAlignment = Enum.TextXAlignment.Left
title.Size = UDim2.new(1,-28,1,0)
title.Position = UDim2.fromOffset(8,0)
title.Parent = titleBar

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.fromOffset(22, TITLE_H)
closeBtn.AnchorPoint = Vector2.new(1,0)
closeBtn.Position = UDim2.new(1,0,0,0)
closeBtn.Text = "×"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 16
closeBtn.TextColor3 = THEME.Subtle
closeBtn.BackgroundTransparency = 1
closeBtn.Parent = titleBar
closeBtn.MouseButton1Click:Connect(function() gui:Destroy() end)

do
    local dragging=false
    local start=Vector2.new()
    local orig=UDim2.new()
    titleBar.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
            dragging=true; start=UIS:GetMouseLocation(); orig=window.Position
        end
    end)
    UIS.InputChanged:Connect(function(i)
        if not dragging then return end
        if i.UserInputType~=Enum.UserInputType.MouseMovement and i.UserInputType~=Enum.UserInputType.Touch then return end
        local d=UIS:GetMouseLocation()-start
        local nx = orig.X.Offset + d.X
        local ny = orig.Y.Offset + d.Y
        nx, ny = clampToScreen(nx, ny, window.AbsoluteSize.X, TITLE_H)
        window.Position = UDim2.fromOffset(nx, ny)
    end)
    UIS.InputEnded:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then dragging=false end
    end)
end

--== Scroll & UI helpers ==--
local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, -(PAD*2), 1, -(TITLE_H + PAD*2))
scroll.Position = UDim2.fromOffset(PAD, TITLE_H + PAD)
scroll.BackgroundTransparency = 1
scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
scroll.CanvasSize = UDim2.new(0,0,0,0)
scroll.ScrollBarThickness = 6
scroll.ScrollBarImageColor3 = THEME.Stroke
scroll.Parent = window

local vlist = Instance.new("UIListLayout")
vlist.FillDirection = Enum.FillDirection.Vertical
vlist.SortOrder = Enum.SortOrder.LayoutOrder
vlist.Padding = UDim.new(0,3)
vlist.Parent = scroll

local function mkClickBtn(text)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -PAD, 0, 26)
    b.Position = UDim2.fromOffset(PAD, 0)
    b.BackgroundColor3 = THEME.Hover
    b.Text = text
    b.Font = Enum.Font.GothamBold
    b.TextSize = 12
    b.TextColor3 = THEME.Text
    b.AutoButtonColor = false
    b.Parent = scroll
    Instance.new("UICorner", b).CornerRadius = UDim.new(0,5)
    b.MouseEnter:Connect(function() tweenColor(b, THEME.Accent) end)
    b.MouseLeave:Connect(function() tweenColor(b, THEME.Hover) end)
    b.MouseButton1Down:Connect(function() tweenColor(b, THEME.Titlebar) end)
    b.MouseButton1Up:Connect(function() tweenColor(b, THEME.Accent) end)
    return b
end

local function mkSwitchRow(labelText)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 24)
    row.BackgroundTransparency = 1
    row.Parent = scroll

    local lbl = Instance.new("TextLabel")
    lbl.BackgroundTransparency = 1
    lbl.Size = UDim2.new(1, -80, 1, 0)
    lbl.Position = UDim2.fromOffset(PAD, 0)
    lbl.Text = labelText
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 12
    lbl.TextColor3 = THEME.Text
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = row

    local sw = Instance.new("TextButton")
    sw.AnchorPoint = Vector2.new(1,0)
    sw.Position = UDim2.new(1, -PAD, 0, 0)
    sw.Size = UDim2.fromOffset(64, 24)
    sw.BackgroundColor3 = THEME.Hover
    sw.Text = "OFF"
    sw.Font = Enum.Font.GothamBold
    sw.TextSize = 12
    sw.TextColor3 = THEME.Text
    sw.AutoButtonColor = false
    sw.Parent = row
    Instance.new("UICorner", sw).CornerRadius = UDim.new(0,5)

    sw.MouseEnter:Connect(function() tweenColor(sw, THEME.Accent) end)
    sw.MouseLeave:Connect(function() tweenColor(sw, THEME.Hover) end)
    sw.MouseButton1Down:Connect(function() tweenColor(sw, THEME.Titlebar) end)
    sw.MouseButton1Up:Connect(function() tweenColor(sw, THEME.Accent) end)

    local state = false
    local api = {
        Row=row, Switch=sw, Label=lbl,
        Get=function() return state end,
        Set=function(v) state = v and true or false; sw.Text = state and "ON" or "OFF" end
    }
    sw.MouseButton1Click:Connect(function() api.Set(not state) end)
    return api
end

local function mkInput(ph)
    local tb = Instance.new("TextBox")
    tb.Size = UDim2.new(1, -PAD*2, 0, 24)
    tb.Position = UDim2.fromOffset(PAD, 0)
    tb.PlaceholderText = ph
    tb.Text = ""
    tb.Font = Enum.Font.Gotham
    tb.TextSize = 12
    tb.TextColor3 = THEME.Text
    tb.BackgroundColor3 = THEME.Background
    tb.Parent = scroll
    Instance.new("UICorner", tb).CornerRadius = UDim.new(0,5)
    return tb
end

--== Hàng đầu & Player List ==--
local escSwitch = mkSwitchRow("Fast Escape")
local plToggleBtn = mkClickBtn("PlayerList ⬇️")

local listHolder = Instance.new("Frame")
listHolder.Name = "MagicPlayerList"
listHolder.Size = UDim2.new(1, -PAD, 0, 0)
listHolder.AutomaticSize = Enum.AutomaticSize.Y
listHolder.BackgroundTransparency = 1
listHolder.Active = false
listHolder.ClipsDescendants = true
listHolder.ZIndex = 1
listHolder.Parent = scroll
Instance.new("UIPadding", listHolder).PaddingLeft  = UDim.new(0, PAD)
listHolder:FindFirstChildOfClass("UIPadding").PaddingRight = UDim.new(0, PAD)
local lhLayout = Instance.new("UIListLayout", listHolder)
lhLayout.FillDirection = Enum.FillDirection.Vertical
lhLayout.SortOrder = Enum.SortOrder.LayoutOrder
lhLayout.Padding = UDim.new(0, 3)

local clearTargetBtn = mkClickBtn("Clear Target [Click]")
local tpSwitch = mkSwitchRow("Teleport Player")
_G.Magic_SelectedTarget = _G.Magic_SelectedTarget

local listVisible = false
local function MagicUpdateListHeader()
    local sel = _G.Magic_SelectedTarget
    local valid = sel and sel.Parent == Players
    if listVisible then
        plToggleBtn.Text = "PlayerList ⬆️"
    else
        if valid then
            plToggleBtn.Text = ("PlayerList [%s] ⬇️"):format(sel.Name)
        else
            plToggleBtn.Text = "PlayerList ⬇️"
            if not valid then _G.Magic_SelectedTarget = nil end
        end
    end
end

local function mkListItem(text, plr)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, 0, 0, 24)
    b.BackgroundColor3 = THEME.ListIdle
    b.AutoButtonColor = false
    b.Text = text
    b.Font = Enum.Font.Gotham
    b.TextSize = 12
    b.TextColor3 = THEME.Text
    b.Parent = listHolder
    Instance.new("UICorner", b).CornerRadius = UDim.new(0,5)
    if _G.Magic_SelectedTarget and plr == _G.Magic_SelectedTarget then
        b.BackgroundColor3 = THEME.Accent
    end
    b.MouseEnter:Connect(function()
        if not (_G.Magic_SelectedTarget and plr == _G.Magic_SelectedTarget) then
            tweenColor(b, THEME.Hover)
        end
    end)
    b.MouseLeave:Connect(function()
        if not (_G.Magic_SelectedTarget and plr == _G.Magic_SelectedTarget) then
            tweenColor(b, THEME.ListIdle)
        end
    end)
    if plr then
        b.MouseButton1Click:Connect(function()
            _G.Magic_SelectedTarget = plr
            MagicUpdateListHeader()
            for _,c in ipairs(listHolder:GetChildren()) do
                if c:IsA("TextButton") then c.BackgroundColor3 = THEME.ListIdle end
            end
            b.BackgroundColor3 = THEME.Accent
        end)
    end
    return b
end

local function MagicRenderPlayerList()
    for _,c in ipairs(listHolder:GetChildren()) do
        if c:IsA("TextButton") then c:Destroy() end
    end
    for _,p in ipairs(Players:GetPlayers()) do
        if p ~= lp then mkListItem(p.Name, p) end
    end
    MagicUpdateListHeader()
end

plToggleBtn.MouseButton1Click:Connect(function()
    listVisible = not listVisible
    if listVisible then
        MagicRenderPlayerList()
        listHolder.Size = UDim2.new(1, -PAD, 0, 0)
    else
        for _,c in ipairs(listHolder:GetChildren()) do
            if c:IsA("TextButton") then c:Destroy() end
        end
        listHolder.Size = UDim2.new(1, -PAD, 0, 0)
    end
    MagicUpdateListHeader()
end)

clearTargetBtn.MouseButton1Click:Connect(function()
    _G.Magic_SelectedTarget = nil
    MagicUpdateListHeader()
    for _,c in ipairs(listHolder:GetChildren()) do
        if c:IsA("TextButton") then c.BackgroundColor3 = THEME.ListIdle end
    end
end)

Players.PlayerAdded:Connect(function()
    if listVisible then MagicRenderPlayerList() end
    MagicUpdateListHeader()
end)
Players.PlayerRemoving:Connect(function(p)
    if _G.Magic_SelectedTarget == p then _G.Magic_SelectedTarget = nil end
    if listVisible then MagicRenderPlayerList() end
    MagicUpdateListHeader()
end)

--== Mục khác ==--
local espSwitch    = mkSwitchRow("ESP")
local hlSwitch     = mkSwitchRow("Highlight")
local infSwitch    = mkSwitchRow("Infinity Jump")
local noclipSwitch = mkSwitchRow("NoClip")
local wsInput      = mkInput("Input WalkSpeed")
local jpInput      = mkInput("Input JumpPower")
local wsSwitch     = mkSwitchRow("Changer WalkSpeed")
local jpSwitch     = mkSwitchRow("Changer JumpPower")

local suiBtn    = mkClickBtn("Suicide [Click]")
local rejoinBtn = mkClickBtn("Server Rejoin [Click]")
local hopBtn    = mkClickBtn("Server Hop [Click]")
local leaveBtn  = mkClickBtn("Leave [Click]")

--== API hợp nhất (giữ form cũ) ==--
_G.MagicMenuStates                  = _G.MagicMenuStates or {}
_G.MagicMenuStates.Buttons          = _G.MagicMenuStates.Buttons or {}
_G.MagicMenuStates.FastEscape       = escSwitch.Get
_G.MagicMenuStates.TeleportPlayer   = tpSwitch.Get
_G.MagicMenuStates.ESP              = espSwitch.Get
_G.MagicMenuStates.Highlight        = hlSwitch.Get
_G.MagicMenuStates.NoClip           = noclipSwitch.Get
_G.MagicMenuStates.WalkSpeedHack    = wsSwitch.Get
_G.MagicMenuStates.JumpPowerHack    = jpSwitch.Get
_G.MagicMenuStates.InfinityJump     = infSwitch.Get
_G.MagicMenuStates.WalkSpeedFactor = function()
    local val = tonumber(wsInput.Text)
    if val and val > 0 then
        return val
    else
        wsInput.Text = "10" -- fallback mặc định
        return 10
    end
end

_G.MagicMenuStates.JumpPowerFactor = function()
    local val = tonumber(jpInput.Text)
    if val and val > 0 then
        return val
    else
        jpInput.Text = "5" -- fallback mặc định
        return 5
    end
end
_G.MagicMenuStates.Buttons.Hop      = hopBtn
_G.MagicMenuStates.Buttons.Rejoin   = rejoinBtn
_G.MagicMenuStates.Buttons.Suicide  = suiBtn
_G.MagicMenuStates.Buttons.Leave    = leaveBtn
_G.MagicMenuStates.Buttons.PlayerListToggle = plToggleBtn
_G.MagicMenuStates.Buttons.ClearTarget      = clearTargetBtn
_G.MagicMenuStates.SelectedTarget   = function() return _G.Magic_SelectedTarget end

--== Character binding & base stats ==--
local char, hum, hrp
local BASE_WS, BASE_JP = 16, 50
local function bindCharacter(c)
    char = c
    hum  = c:WaitForChild("Humanoid", 8)
    hrp  = c:WaitForChild("HumanoidRootPart", 8)
    if hum then
        hum.UseJumpPower = true
        BASE_WS = hum.WalkSpeed > 0 and hum.WalkSpeed or 16
        BASE_JP = hum.JumpPower and hum.JumpPower > 0 and hum.JumpPower or 50
    end
end
if lp.Character then bindCharacter(lp.Character) end
lp.CharacterAdded:Connect(bindCharacter)

--== Speed (raycast trượt tường, không đụng WalkSpeed khi OFF) ==--   
if _G.__MAGIC_SPEED_RUN then _G.__MAGIC_SPEED_RUN:Disconnect() end
local rayParams = RaycastParams.new()
rayParams.FilterType = Enum.RaycastFilterType.Exclude

_G.__MAGIC_SPEED_RUN = RS.RenderStepped:Connect(function(dt)
    if not (hum and hrp and char and char.Parent) then return end
    rayParams.FilterDescendantsInstances = {char}

    if not (_G.MagicMenuStates.WalkSpeedHack and _G.MagicMenuStates.WalkSpeedHack()) then
        if hum.WalkSpeed and hum.WalkSpeed > 0 then BASE_WS = hum.WalkSpeed end
        return
    end

    local f = tonumber(_G.MagicMenuStates.WalkSpeedFactor and _G.MagicMenuStates.WalkSpeedFactor() or 1) or 1
    if f <= 1 then return end

    local dir = hum.MoveDirection
    if dir.Magnitude < 0.05 then return end
    dir = dir.Unit

    local target = math.clamp(BASE_WS * f, 0, 200)
    local curVel = hrp.AssemblyLinearVelocity
    local desired = dir * target

    -- ƯU TIÊN NOCLIP: nếu NoClip bật thì bỏ qua raycast chống tường (guard an toàn)
local noClipOn = false
if _G.MagicMenuStates and typeof(_G.MagicMenuStates.NoClip) == "function" then
    local ok, res = pcall(_G.MagicMenuStates.NoClip)
    if ok and res == true then
        noClipOn = true
    end
end

if not noClipOn then
    -- chống đâm tường -> trượt theo tường (giữ logic cũ)
    local predictDist = math.max((target * dt) + 1.0, 2.0)
    local hit = workspace:Raycast(hrp.Position, dir * predictDist, rayParams)
    if hit then
        local n = hit.Normal
        if n:Dot(dir) < -0.2 then
            local tangential = desired - n * desired:Dot(n)
            desired = (tangential.Magnitude > 0.05)
                and tangential.Unit * math.min(tangential.Magnitude, target * 0.85)
                or Vector3.zero
        end
    end
end

-- nội suy mượt, giữ Y (giữ nguyên)
local accel = math.clamp(25 * f * dt, 0, 1)
local newHoriz = Vector3.new(curVel.X, 0, curVel.Z)
    :Lerp(Vector3.new(desired.X, 0, desired.Z), accel)
hrp.AssemblyLinearVelocity = Vector3.new(newHoriz.X, curVel.Y, newHoriz.Z)

-- anti-lean (giữ tư thế thẳng)
hrp.AssemblyAngularVelocity = Vector3.new(0, hrp.AssemblyAngularVelocity.Y, 0)
local look = hrp.CFrame.LookVector
if math.abs(look.Y) > 1e-3 then
    local pos = hrp.Position
    local flat = Vector3.new(look.X, 0, look.Z)
    if flat.Magnitude > 1e-3 then
        hrp.CFrame = CFrame.lookAt(pos, pos + flat.Unit, Vector3.yAxis)
    end
end
end)      
    
--== NoClip (khôi phục đúng parts đã chỉnh, không ép true tất cả) ==--  
if _G.__MAGIC_NOCLIP then _G.__MAGIC_NOCLIP:Disconnect() end
local touchedParts = {}  -- [part] = originalCanCollide(true)

local function setNoClipEnabled(on)
    if not char then return end
    if on then
        for _, v in ipairs(char:GetDescendants()) do
            if v:IsA("BasePart") and v.CanCollide then
                if touchedParts[v] == nil then
                    touchedParts[v] = true
                end
                v.CanCollide = false
            end
        end
    else
        for p, wasTrue in pairs(touchedParts) do
            if p and p.Parent and wasTrue == true then p.CanCollide = true end
        end
        table.clear(touchedParts)
    end
end

_G.__MAGIC_NOCLIP = RS.Stepped:Connect(function()
    local on = _G.MagicMenuStates.NoClip and _G.MagicMenuStates.NoClip()
    setNoClipEnabled(on == true)
end)

--== JumpPower Enforce ==--
if _G.__MAGIC_JP_ENFORCE then _G.__MAGIC_JP_ENFORCE:Disconnect() end
_G.__MAGIC_JP_ENFORCE = RS.Heartbeat:Connect(function()
    if not (hum and hum.Parent) then return end
    hum.UseJumpPower = true
    local enabled = _G.MagicMenuStates.JumpPowerHack and _G.MagicMenuStates.JumpPowerHack()
    if enabled then
        local jf = tonumber(_G.MagicMenuStates.JumpPowerFactor and _G.MagicMenuStates.JumpPowerFactor() or 1) or 1
        local targetJP = math.clamp(BASE_JP * jf, 10, 1000)
        if hum.JumpPower ~= targetJP then hum.JumpPower = targetJP end
    else
        if hum.JumpPower ~= BASE_JP then hum.JumpPower = BASE_JP end
    end
end)

--== Infinity Jump (tôn trọng JumpPower, guard an toàn) ==--
do
    if _G.__MAGIC_INFJUMP      then _G.__MAGIC_INFJUMP:Disconnect() end
    if _G.__MAGIC_INFJUMP_KEY  then _G.__MAGIC_INFJUMP_KEY:Disconnect() end
    if _G.__MAGIC_INFJUMP_CHAR then _G.__MAGIC_INFJUMP_CHAR:Disconnect() end

    local function isInfOn()
        return _G.MagicMenuStates
           and typeof(_G.MagicMenuStates.InfinityJump) == "function"
           and (_G.MagicMenuStates.InfinityJump() == true)
    end

    local function recentHumanoid()
        local c = lp.Character
        if not c or not c.Parent then return nil,nil,nil end
        local h = c:FindFirstChildOfClass("Humanoid")
        local r = c:FindFirstChild("HumanoidRootPart")
        if not h or not r or h.Health <= 0 then return nil,nil,nil end
        return c,h,r
    end

    local function doInfJump()
        if not isInfOn() then return end
        local c, h, r = recentHumanoid()
        if not (c and h and r) then return end
        -- an toàn tuyệt đối trong pcall để không die loop
        local ok = pcall(function()
            h:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
            h:SetStateEnabled(Enum.HumanoidStateType.Freefall, true)
            if h.Sit then h.Sit = false end
            h:ChangeState(Enum.HumanoidStateType.Jumping)
            h:ChangeState(Enum.HumanoidStateType.Freefall)

            -- dùng JumpPower hiện tại (có enforce ở block JumpPower)
            h.UseJumpPower = true
            local jp = tonumber(h.JumpPower) or 50
            local v  = r.Velocity
            r.Velocity = Vector3.new(v.X, math.max(v.Y, jp), v.Z)
        end)
        -- nếu có lỗi lẻ, ok=false nhưng không hề “die” script
    end

    _G.__MAGIC_INFJUMP     = UIS.JumpRequest:Connect(doInfJump)
    _G.__MAGIC_INFJUMP_KEY = UIS.InputBegan:Connect(function(input, gpe)
        if gpe then return end
        if input.KeyCode == Enum.KeyCode.Space then
            doInfJump()
        end
    end)

    -- cập nhật tham chiếu khi respawn (không phụ thuộc biến toàn cục cũ)
    _G.__MAGIC_INFJUMP_CHAR = lp.CharacterAdded:Connect(function()
        -- không làm gì ở đây, chỉ để giữ kết nối; doInfJump() luôn tự lấy char/hum/root mới
    end)
end

--== Fast Escape (LinearVelocity-based, clean teardown) ==--
do
    -- Hủy loop cũ nếu có
    if _G.__MAGIC_ESCAPE_LOOP then _G.__MAGIC_ESCAPE_LOOP:Disconnect() end

    local activeTween -- đề phòng còn sót tween cũ (khi chuyển từ phiên bản cũ sang)
    local escLV      -- LinearVelocity khi ON
    local escAtt     -- Attachment gắn vào HRP
    local Y_SPEED    = 350    -- tốc độ bay thẳng đứng
    local MAX_ACC    = math.huge

    local function EscapeOn()
        local f = _G.MagicMenuStates.FastEscape or _G.MagicMenuStates.ESC or _G.MagicMenuStates.Escape
        if typeof(f) == "function" then
            local ok, val = pcall(f)
            return ok and val == true
        end
        return false
    end

    local function ensurePhysicsUp()
        if not hum then return end
        hum.PlatformStand = false
        pcall(function() hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true) end)
        pcall(function() hum:SetStateEnabled(Enum.HumanoidStateType.Freefall, true) end)
        pcall(function() hum:ChangeState(Enum.HumanoidStateType.Freefall) end)
    end

    local function stopAllTween()
        if activeTween then activeTween:Cancel() activeTween=nil end
    end

    local function startFastEscape()
        if not (hrp and hum) then return end
        stopAllTween()      -- dọn tween kiểu cũ nếu có
        ensurePhysicsUp()   -- đảm bảo không bị khoá state

        if not escAtt then
            escAtt = Instance.new("Attachment")
            escAtt.Name = "FastEscape_Att"
            escAtt.Parent = hrp
        end
        if not escLV then
            escLV = Instance.new("LinearVelocity")
            escLV.Name = "FastEscape_LV"
            escLV.Attachment0 = escAtt
            escLV.RelativeTo = Enum.ActuatorRelativeTo.World
            escLV.VectorVelocity = Vector3.new(0, Y_SPEED, 0)
            escLV.MaxForce = MAX_ACC
            escLV.Parent = hrp
        else
            escLV.Enabled = true
            escLV.VectorVelocity = Vector3.new(0, Y_SPEED, 0)
        end
    end

    local function stopFastEscape()
        -- Tắt lực và trả về rơi bình thường NGAY
        if escLV then
            escLV.Enabled = false
            escLV:Destroy(); escLV = nil
        end
        if escAtt then
            escAtt:Destroy(); escAtt = nil
        end
        -- Trả trạng thái rơi + “đập” lại velocity Y để đảm bảo rơi
        if hrp then
            local v = hrp.AssemblyLinearVelocity
            -- Nếu đang bay lên (Y > 0) thì cắt xuống 0 để gravity nắm quyền
            if v.Y > 0 then
                hrp.AssemblyLinearVelocity = Vector3.new(v.X, 0, v.Z)
            end
        end
        ensurePhysicsUp()
    end

    -- Vòng lặp giám sát toggle
    _G.__MAGIC_ESCAPE_LOOP = RS.RenderStepped:Connect(function()
        if not hrp then return end
        if EscapeOn() then
            if not escLV then startFastEscape() end
        else
            if escLV or escAtt then stopFastEscape() end
        end
    end)
end

--== ESP (username màu trắng, khoảng cách, HP) cải tiến ==--
do
    local espEnabled = false
    local espLoopConn
    local espSignalConns = {}
    local espItems = {} -- [plr] = {bb,name,hp,char}

    local function destroyESPFor(plr)
        local it = espItems[plr]
        if it and it.bb then it.bb:Destroy() end
        espItems[plr] = nil
    end

    local function clearESPAll()
        for _,it in pairs(espItems) do
            if it.bb then it.bb:Destroy() end
        end
        table.clear(espItems)
    end

    local function createBB()
        local bb = Instance.new("BillboardGui")
        bb.Size = UDim2.new(0, 260, 0, 36)
        bb.StudsOffset = Vector3.new(0, 3.2, 0)
        bb.AlwaysOnTop = true
        bb.LightInfluence = 0

        local nameLabel = Instance.new("TextLabel")
        nameLabel.BackgroundTransparency = 1
        nameLabel.Size = UDim2.new(1, 0, 0.55, 0)
        nameLabel.Position = UDim2.new(0,0,0,0)
        nameLabel.Font = Enum.Font.GothamBold
        nameLabel.TextSize = 16
        nameLabel.RichText = true
        nameLabel.Text = ""
        nameLabel.TextStrokeTransparency = 0
        nameLabel.TextStrokeColor3 = Color3.new(0,0,0)
        nameLabel.Parent = bb

        local hpLabel = Instance.new("TextLabel")
        hpLabel.BackgroundTransparency = 1
        hpLabel.Size = UDim2.new(1, 0, 0.45, 0)
        hpLabel.Position = UDim2.new(0,0,0.55,-2)
        hpLabel.Font = Enum.Font.GothamBold
        hpLabel.TextSize = 14
        hpLabel.Text = ""
        hpLabel.TextStrokeTransparency = 0
        hpLabel.TextStrokeColor3 = Color3.new(0,0,0)
        hpLabel.Parent = bb

        return bb, nameLabel, hpLabel
    end

    local function ensureESP(plr)
        if plr == lp then return end
        if typeof(plr.UserId) ~= "number" or plr.UserId <= 0 then return end
        local c = plr.Character
        if not c or not c.Parent then return end
        local head = c:FindFirstChild("Head") or c:FindFirstChildWhichIsA("BasePart")
        if not head then return end
        local rec = espItems[plr]
        if rec and rec.char == c and rec.bb and rec.bb.Parent == head then return end
        if rec and rec.bb then rec.bb:Destroy() end
        local bb,nl,hl = createBB()
        bb.Parent = head
        espItems[plr] = {bb=bb, name=nl, hp=hl, char=c}
    end

    local function hookESPSignals()
        for _,cn in ipairs(espSignalConns) do
            pcall(function() cn:Disconnect() end)
        end
        table.clear(espSignalConns)

        table.insert(espSignalConns, Players.PlayerAdded:Connect(function(p)
            if not espEnabled then return end
            table.insert(espSignalConns, p.CharacterAdded:Connect(function()
                if not espEnabled then return end
                task.defer(function()
                    if not espEnabled then return end
                    p.Character:WaitForChild("Head", 5)
                    ensureESP(p)
                end)
            end))
            if p.Character then task.defer(function() ensureESP(p) end) end
        end))

        table.insert(espSignalConns, Players.PlayerRemoving:Connect(function(p)
            destroyESPFor(p)
        end))

        for _,p in ipairs(Players:GetPlayers()) do
            if p ~= lp then
                table.insert(espSignalConns, p.CharacterAdded:Connect(function()
                    if not espEnabled then return end
                    task.defer(function()
                        if not espEnabled then return end
                        p.Character:WaitForChild("Head", 5)
                        ensureESP(p)
                    end)
                end))
            end
        end
    end

    local function startESP()
        if espEnabled then return end
        espEnabled = true
        for _,p in ipairs(Players:GetPlayers()) do ensureESP(p) end
        hookESPSignals()

        espLoopConn = task.spawn(function()
            while espEnabled do
                local cam = workspace.CurrentCamera
                if cam then
                    for p,it in pairs(espItems) do
                        local c = p.Character
                        if not c or not c.Parent then
                            destroyESPFor(p)
                        else
                            local head = c:FindFirstChild("Head") or c:FindFirstChildWhichIsA("BasePart")
                            local hrp2 = c:FindFirstChild("HumanoidRootPart")
                            local h2   = c:FindFirstChildOfClass("Humanoid")
                            if not head then
                                destroyESPFor(p)
                            else
                                if it.bb.Parent ~= head then it.bb.Parent = head end
                                if hrp2 then
                                    local dist = (cam.CFrame.Position - hrp2.Position).Magnitude
                                    local m = math.floor(dist + 0.5)
                                    if it.name then
                                        local uname = p.Name
                                        it.name.Text = string.format(
                                            '<font color="rgb(255,255,255)">%s [ %dm ]</font>',
                                            uname, m
                                        )
                                    end
                                    if it.hp and h2 then
                                        local cur,max = h2.Health, h2.MaxHealth
                                        local ratio = (max > 0) and (cur/max) or 0
                                        if ratio > 0.5 then
                                            it.hp.TextColor3 = Color3.fromRGB(0,200,0)
                                        elseif ratio > 0.2 then
                                            it.hp.TextColor3 = Color3.fromRGB(255,200,0)
                                        else
                                            it.hp.TextColor3 = Color3.fromRGB(255,0,0)
                                        end
                                        it.hp.Text = string.format("[ %d/%d ]", math.floor(cur+0.5), math.floor(max+0.5))
                                    end
                                end
                            end
                        end
                    end
                end
                task.wait(0.2) -- update 10 lần/giây
            end
        end)
    end

    local function stopESP()
        if not espEnabled then return end
        espEnabled = false
        if espLoopConn then espLoopConn = nil end
        for _,cn in ipairs(espSignalConns) do pcall(function() cn:Disconnect() end) end
        table.clear(espSignalConns)
        clearESPAll()
    end

    if _G.__MAGIC_ESP_WATCH then _G.__MAGIC_ESP_WATCH:Disconnect() end
    _G.__MAGIC_ESP_WATCH = RS.RenderStepped:Connect(function()
        if _G.MagicMenuStates.ESP() then
            if not espEnabled then startESP() end
        else
            if espEnabled then stopESP() end
        end
    end)
end

--== Highlight (viền đỏ sáng, auto update, dày hơn) ==--
do
    if _G.__HIGHLIGHT_LOOP then _G.__HIGHLIGHT_LOOP:Disconnect() end
    if _G.__HIGHLIGHT_CLEAN then
        for _,fn in ipairs(_G.__HIGHLIGHT_CLEAN) do pcall(fn) end
    end
    _G.__HIGHLIGHT_CLEAN = {}

    local items = {} -- [plr] = Highlight

    local function ensureHL(plr)
        if items[plr] then return items[plr] end
        local hl = Instance.new("Highlight")
        hl.Name = "HL_"..plr.UserId
        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        hl.FillTransparency = 1
        hl.OutlineColor = Color3.fromRGB(255,0,0)
        hl.OutlineTransparency = 0
        hl.Enabled = true
        hl.Parent = game:GetService("CoreGui") -- để tránh mất khi reset
        items[plr] = hl

        -- tạo thêm bản highlight thứ hai để viền trông dày hơn
        local hl2 = Instance.new("Highlight")
        hl2.Name = "HL2_"..plr.UserId
        hl2.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        hl2.FillTransparency = 1
        hl2.OutlineColor = Color3.fromRGB(255,0,0)
        hl2.OutlineTransparency = 0.2 -- hơi trong → tạo hiệu ứng viền rộng
        hl2.Enabled = true
        hl2.Parent = game:GetService("CoreGui")
        -- lưu cả hai để xoá gọn
        items[plr.."2"] = hl2

        table.insert(_G.__HIGHLIGHT_CLEAN, function()
            if hl then hl:Destroy() end
            if hl2 then hl2:Destroy() end
        end)
        return hl, hl2
    end

    local function destroyHL(plr)
        local hl = items[plr]
        local hl2 = items[plr.."2"]
        if hl then hl:Destroy() end
        if hl2 then hl2:Destroy() end
        items[plr] = nil
        items[plr.."2"] = nil
    end

    local function updateHL(plr)
        local c = plr.Character
        local hum = c and c:FindFirstChildOfClass("Humanoid")
        if hum and hum.Health > 0 then
            local hl,hl2 = ensureHL(plr)
            hl.Adornee = c
            hl2.Adornee = c
            hl.Enabled = true
            hl2.Enabled = true
        else
            destroyHL(plr)
        end
    end

    -- loop quét liên tục
    _G.__HIGHLIGHT_LOOP = RS.RenderStepped:Connect(function()
        if not (_G.MagicMenuStates.Highlight and _G.MagicMenuStates.Highlight()) then
            for p,_ in pairs(items) do destroyHL(p) end
            return
        end
        for _,p in ipairs(Players:GetPlayers()) do
            if p ~= lp then
                updateHL(p)
            end
        end
    end)

    -- gắn lại khi player spawn hoặc mới vào
    table.insert(_G.__HIGHLIGHT_CLEAN, Players.PlayerAdded:Connect(function(p)
        p.CharacterAdded:Connect(function()
            task.wait(0.2)
            if _G.MagicMenuStates.Highlight and _G.MagicMenuStates.Highlight() then
                updateHL(p)
            end
        end)
    end).Disconnect)

    table.insert(_G.__HIGHLIGHT_CLEAN, Players.PlayerRemoving:Connect(function(p)
        destroyHL(p)
    end).Disconnect)
end
    
--== Teleport Follow (bám sau 3 studs, retarget mượt) ==--
do
    if _G.__MAGIC_TP_FOLLOW then _G.__MAGIC_TP_FOLLOW:Disconnect() end
    if _G.__MAGIC_TP_PR     then _G.__MAGIC_TP_PR:Disconnect() end

    local activeTp
    local currentTarget
    local retimer = 0
    local RETARGET_DT = 0.03
    local OFFSET = CFrame.new(0,0,-3)
    local MIN_TIME = 1/240

    local function cancelTp() if activeTp then activeTp:Cancel(); activeTp=nil end end
    local function goalPosFrom(thrp) return (thrp.CFrame * OFFSET).Position end
    local function startTween(goal)
        if not hrp then return end
        local dist = (goal - hrp.Position).Magnitude
        local t    = math.max(dist / 350, MIN_TIME)
        cancelTp()
        local tw = TweenService:Create(hrp, TweenInfo.new(t, Enum.EasingStyle.Linear), {CFrame = CFrame.new(goal)})
        activeTp = tw
        tw:Play()
        tw.Completed:Connect(function() if activeTp == tw then activeTp=nil end end)
    end

    _G.__MAGIC_TP_FOLLOW = RS.RenderStepped:Connect(function(dt)
        if not (_G.MagicMenuStates and _G.MagicMenuStates.TeleportPlayer and _G.MagicMenuStates.TeleportPlayer()) then
            cancelTp(); currentTarget=nil; retimer=0; return
        end
        if not hrp then return end
        local tgt  = _G.MagicMenuStates.SelectedTarget and _G.MagicMenuStates.SelectedTarget()
        local thrp = tgt and tgt.Character and tgt.Character:FindFirstChild("HumanoidRootPart")
        if not (tgt and tgt.Parent == Players and thrp) then
            cancelTp(); currentTarget=nil; retimer=0; return
        end
        if currentTarget ~= tgt then cancelTp(); currentTarget = tgt end
        retimer += dt
        if retimer < RETARGET_DT then return end
        retimer = 0
        startTween(goalPosFrom(thrp))
    end)

    _G.__MAGIC_TP_PR = Players.PlayerRemoving:Connect(function(p)
        if currentTarget == p then cancelTp(); currentTarget=nil end
    end)
end

--== Buttons ==--
hopBtn.MouseButton1Click:Connect(function()
    TeleportService:Teleport(game.PlaceId, lp)
end)
rejoinBtn.MouseButton1Click:Connect(function()
    TeleportService:Teleport(game.PlaceId, lp)
end)
suiBtn.MouseButton1Click:Connect(function()
    if hum then hum.Health = 0 end
end)
leaveBtn.MouseButton1Click:Connect(function()
    pcall(function() lp:Kick("Leave") end)
end)
--=================== END ===================
