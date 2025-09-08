-- PHẦN 1: GUI RỖNG (Icon 48x48 + thêm Leave)
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local old = playerGui:FindFirstChild("FloatingMenuGUI")
if old then old:Destroy() end

local THEME = {
    Background = Color3.fromRGB(35,38,50),
    Titlebar   = Color3.fromRGB(65,50,90),
    Stroke     = Color3.fromRGB(180,140,255),
    Text       = Color3.fromRGB(255,255,255),
    Subtle     = Color3.fromRGB(210,180,255),
    Hover      = Color3.fromRGB(90,60,130),
    Accent     = Color3.fromRGB(150,90,200),
}

local WINDOW_W, WINDOW_H = 300, 250
local TITLE_H = 28
local PAD = 6

local gui = Instance.new("ScreenGui")
gui.Name = "FloatingMenuGUI"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = playerGui

-- 🔘 ICON 48x48
local icon = Instance.new("ImageButton")
icon.Name = "FloatingIcon"
icon.BackgroundColor3 = THEME.Accent
icon.BackgroundTransparency = 0.2
icon.Size = UDim2.fromOffset(48,48) -- chỉnh to 48x48
icon.Position = UDim2.new(0, 16, 0.5, -24)
icon.ZIndex = 1000
icon.Parent = gui
Instance.new("UICorner", icon).CornerRadius = UDim.new(1,0) -- tròn hoàn toàn
icon.Image = "rbxassetid://3926305904"
icon.ImageRectOffset = Vector2.new(4,204)  -- vẫn giữ icon mặc định
icon.ImageRectSize = Vector2.new(36,36)

do -- kéo thả icon
    local dragging, start, orig
    icon.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
            dragging=true; start=i.Position; orig=icon.Position
        end
    end)
    UIS.InputChanged:Connect(function(i)
        if not dragging then return end
        if i.UserInputType~=Enum.UserInputType.MouseMovement and i.UserInputType~=Enum.UserInputType.Touch then return end
        local d=i.Position-start
        local v=workspace.CurrentCamera.ViewportSize
        icon.Position = UDim2.fromOffset(
            math.clamp(orig.X.Offset+d.X, 0, v.X-icon.AbsoluteSize.X),
            math.clamp(orig.Y.Offset+d.Y, 0, v.Y-icon.AbsoluteSize.Y)
        )
    end)
    UIS.InputEnded:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then dragging=false end
    end)
end

local window = Instance.new("Frame")
do
    local v=(workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize) or Vector2.new(800,600)
    window.Position = UDim2.fromOffset((v.X-WINDOW_W)/2, math.max(12,(v.Y-WINDOW_H)/2))
end
window.Size = UDim2.fromOffset(WINDOW_W, WINDOW_H)
window.BackgroundColor3 = THEME.Background
window.BackgroundTransparency = 0.12
window.BorderSizePixel = 0
window.Parent = gui
Instance.new("UICorner", window).CornerRadius = UDim.new(0,8)
local wsStroke = Instance.new("UIStroke", window) wsStroke.Color = THEME.Stroke wsStroke.Transparency = 0.2

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

do -- kéo thả cửa sổ
    local dragging, start, orig
    titleBar.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
            dragging=true; start=i.Position; orig=window.Position
        end
    end)
    UIS.InputChanged:Connect(function(i)
        if not dragging then return end
        if i.UserInputType~=Enum.UserInputType.MouseMovement and i.UserInputType~=Enum.UserInputType.Touch then return end
        local d=i.Position-start
        local v=workspace.CurrentCamera.ViewportSize
        window.Position = UDim2.fromOffset(
            math.clamp(orig.X.Offset+d.X, 0, v.X-window.AbsoluteSize.X),
            math.clamp(orig.Y.Offset+d.Y, 0, v.Y-TITLE_H)
        )
    end)
    UIS.InputEnded:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then dragging=false end
    end)
end

icon.MouseButton1Click:Connect(function() window.Visible = not window.Visible end)

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

local function tweenColor(btn, c, t)
    TweenService:Create(btn, TweenInfo.new(t or 0.12), {BackgroundColor3 = c}):Play()
end

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
        Row = row, Switch = sw, Label = lbl,
        Get = function() return state end,
        Set = function(v)
            state = v and true or false
            sw.Text = state and "ON" or "OFF"
        end
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

-- Các mục
local espSwitch  = mkSwitchRow("ESP")
local wsInput    = mkInput("Input WalkSpeed")
local jpInput    = mkInput("Input JumpPower")
local wsSwitch   = mkSwitchRow("Changer WalkSpeed")
local jpSwitch   = mkSwitchRow("Changer JumpPower")
local infSwitch  = mkSwitchRow("Infinity Jump")

-- Nút click
local hopBtn     = mkClickBtn("Server Hop [Click]")
local rejoinBtn  = mkClickBtn("Server Rejoin [Click]")
local suiBtn     = mkClickBtn("Suicide [Click]")
local leaveBtn   = mkClickBtn("Leave [Click]") -- 🆕 thêm nút Leave

-- API state cho phần 2/3 dùng
_G.SlimMenuStates = {
    ESP = espSwitch.Get,
    WalkSpeedHack = wsSwitch.Get,
    JumpPowerHack = jpSwitch.Get,
    InfinityJump = infSwitch.Get,
    WalkSpeedFactor = function() return tonumber(wsInput.Text) or 1 end,
    JumpPowerFactor = function() return tonumber(jpInput.Text) or 1 end,
    Buttons = { Hop = hopBtn, Rejoin = rejoinBtn, Suicide = suiBtn, Leave = leaveBtn }
}
-- PHẦN 2 (SẠCH): Speed đơn giản (không xuyên tường) + JumpPower ổn định + Infinity Jump chuẩn
-- + ESP luôn bám người chơi mới/reset + các nút click (Hop/Rejoin/Suicide/Leave)
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")

local lp = Players.LocalPlayer

while not _G.SlimMenuStates do task.wait() end
local S = _G.SlimMenuStates

local char, hum, hrp
local BASE_WS, BASE_JP = 16, 50

local function bindCharacter(c)
    char = c
    hum = c:WaitForChild("Humanoid", 8)
    hrp = c:WaitForChild("HumanoidRootPart", 8)
    if hum then
        hum.UseJumpPower = true
        BASE_WS = hum.WalkSpeed > 0 and hum.WalkSpeed or 16
        BASE_JP = hum.JumpPower and hum.JumpPower > 0 and hum.JumpPower or 50
    end
end

if lp.Character then bindCharacter(lp.Character) end
lp.CharacterAdded:Connect(function(c)
    bindCharacter(c)
end)

-- === SPEED LV CHỐNG XUYÊN TƯỜNG (luôn boost, kể cả trên không) ===
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local attName = "__SLIM_LV_ATT"
local lvName  = "__SLIM_LV_CON"

local rayParams = RaycastParams.new()
rayParams.FilterType = Enum.RaycastFilterType.Exclude
rayParams.IgnoreWater = true

local function ensureLV()
    if not hrp then return end
    local att = hrp:FindFirstChild(attName)
    if not att then
        att = Instance.new("Attachment")
        att.Name = attName
        att.Parent = hrp
    end
    local lv = hrp:FindFirstChild(lvName)
    if not lv then
        lv = Instance.new("LinearVelocity")
        lv.Name = lvName
        lv.Attachment0 = att
        lv.RelativeTo = Enum.ActuatorRelativeTo.World
        lv.MaxForce = math.huge
        lv.Enabled = true
        lv.Parent = hrp
    end
    return att, lv
end

local function clearLV()
    if not hrp then return end
    local lv = hrp:FindFirstChild(lvName)
    if lv then lv:Destroy() end
    local att = hrp:FindFirstChild(attName)
    if att then att:Destroy() end
end

if _G.__SLIM_SPEED_LV then _G.__SLIM_SPEED_LV:Disconnect() _G.__SLIM_SPEED_LV=nil end
_G.__SLIM_SPEED_LV = RunService.RenderStepped:Connect(function(dt)
    if not hum or not hrp or not char or not char.Parent then return end

    if hum.WalkSpeed ~= BASE_WS then hum.WalkSpeed = BASE_WS end

    local enabled = _G.SlimMenuStates and _G.SlimMenuStates.WalkSpeedHack() or false
    if not enabled then
        clearLV()
        return
    end

    local f = tonumber(_G.SlimMenuStates.WalkSpeedFactor()) or 1
    if f <= 1 then
        clearLV()
        return
    end

    local dir = hum.MoveDirection
    if dir.Magnitude < 0.05 then
        local _, lv = ensureLV()
        if lv then
            local cur = hrp.AssemblyLinearVelocity
            lv.VectorVelocity = Vector3.new(cur.X, cur.Y, cur.Z)
        end
        return
    end
    dir = dir.Unit

    local target = math.clamp(BASE_WS * f, 0, 240)

    -- Raycast chống đâm tường
    rayParams.FilterDescendantsInstances = {char}
    local lookAhead = math.max(6, target * 0.2)
    local origin = hrp.Position + Vector3.new(0, 1.5, 0)
    local result = Workspace:Raycast(origin, dir * lookAhead, rayParams)

    local desiredDir = dir
    local speedScale = 1

    if result then
        local n = result.Normal
        local slide = (dir - n * math.max(0, dir:Dot(n)))
        if slide.Magnitude > 0.05 then
            desiredDir = slide.Unit
        else
            desiredDir = Vector3.zero
        end

        local dist = (result.Position - origin).Magnitude
        local buffer = 2
        speedScale = math.clamp((dist - buffer) / math.max(1, (lookAhead - buffer)), 0, 1)
    end

    local cur = hrp.AssemblyLinearVelocity
    local desiredHoriz = desiredDir * (target * speedScale)
    local smooth = math.clamp(14 * f * dt, 0, 1)
    local newHoriz = Vector3.new(cur.X, 0, cur.Z):Lerp(desiredHoriz, smooth)

    local _, lv = ensureLV()
    if lv then
        lv.VectorVelocity = Vector3.new(newHoriz.X, cur.Y, newHoriz.Z)
        lv.Enabled = true
    end
end)

lp.CharacterAdded:Connect(function()
    task.defer(clearLV)
end)

-- === REPLACE THIS WHOLE INFINITY JUMP BLOCK IN PHẦN 2 ===

-- Clean old binds
if _G.__SLIM_INFJUMP then _G.__SLIM_INFJUMP:Disconnect() end
if _G.__SLIM_INFJUMP2 then _G.__SLIM_INFJUMP2:Disconnect() end
if _G.__SLIM_INFJUMP_CHAR then _G.__SLIM_INFJUMP_CHAR:Disconnect() end

local function canJump()
    return S.InfinityJump and S.InfinityJump() and hum and hum.Parent and hum.Health > 0
end

local function doInfJump()
    if not canJump() then return end
    pcall(function()
        hum:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
        hum:SetStateEnabled(Enum.HumanoidStateType.Freefall, true)
        if hum.Sit then hum.Sit = false end
        hum:ChangeState(Enum.HumanoidStateType.Jumping)
        hum:ChangeState(Enum.HumanoidStateType.Freefall)
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if root then
            root.Velocity = Vector3.new(root.Velocity.X, math.max(root.Velocity.Y, 50), root.Velocity.Z)
        end
    end)
end

_G.__SLIM_INFJUMP = UIS.JumpRequest:Connect(doInfJump)

_G.__SLIM_INFJUMP2 = UIS.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.Space then
        doInfJump()
    end
end)

_G.__SLIM_INFJUMP_CHAR = Players.LocalPlayer.CharacterAdded:Connect(function(c)
    task.wait(0.2)
    char = c
    hum = c:FindFirstChildOfClass("Humanoid")
end)

-- ESP (BillboardGui: tên đỏ + khoảng cách trắng + HP xanh).
-- Bám người chơi mới vào và khi họ reset.
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
    for p,it in pairs(espItems) do if it.bb then it.bb:Destroy() end end
    table.clear(espItems)
end

local function createBB()
    local bb = Instance.new("BillboardGui")
    bb.Size = UDim2.new(0, 220, 0, 32)
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
    hpLabel.TextColor3 = Color3.fromRGB(0,200,0)
    hpLabel.TextStrokeTransparency = 0
    hpLabel.TextStrokeColor3 = Color3.new(0,0,0)
    hpLabel.Parent = bb

    return bb, nameLabel, hpLabel
end

local function ensureESP(plr)
    if plr == lp then return end
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
    for _,cn in ipairs(espSignalConns) do pcall(function() cn:Disconnect() end) end
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

    espLoopConn = RunService.Heartbeat:Connect(function()
        if not espEnabled then return end
        local cam = workspace.CurrentCamera
        if not cam then return end

        for _,p in ipairs(Players:GetPlayers()) do
            if p ~= lp then ensureESP(p) end
        end

        for p,it in pairs(espItems) do
            local c = p.Character
            if not c or not c.Parent then
                destroyESPFor(p)
            else
                local head = c:FindFirstChild("Head") or c:FindFirstChildWhichIsA("BasePart")
                local hrp2 = c:FindFirstChild("HumanoidRootPart")
                local h2 = c:FindFirstChildOfClass("Humanoid")
                if not head then
                    destroyESPFor(p)
                else
                    if it.bb.Parent ~= head then it.bb.Parent = head end
                    if hrp2 then
                        local dist = (cam.CFrame.Position - hrp2.Position).Magnitude
                        local m = math.floor(dist + 0.5)
                        if it.name then
                            it.name.Text = string.format(
                                '<font color="rgb(255,60,60)">%s</font> <font color="rgb(255,255,255)">[ %dm ]</font>',
                                p.DisplayName or p.Name, m
                            )
                        end
                        if it.hp and h2 then
                            it.hp.Text = string.format("[ %d/%d ]",
                                math.max(0, math.floor(h2.Health + 0.5)),
                                math.max(0, math.floor(h2.MaxHealth + 0.5))
                            )
                        end
                    end
                end
            end
        end
    end)
end

local function stopESP()
    if not espEnabled then return end
    espEnabled = false
    if espLoopConn then espLoopConn:Disconnect() espLoopConn=nil end
    for _,cn in ipairs(espSignalConns) do pcall(function() cn:Disconnect() end) end
    table.clear(espSignalConns)
    clearESPAll()
end

if _G.__SLIM_ESP_WATCH then _G.__SLIM_ESP_WATCH:Disconnect() end
_G.__SLIM_ESP_WATCH = RunService.RenderStepped:Connect(function()
    if S.ESP() then
        if not espEnabled then startESP() end
    else
        if espEnabled then stopESP() end
    end
end)

-- Nút click
local btns = S.Buttons
btns.Hop.MouseButton1Click:Connect(function()
    TeleportService:Teleport(game.PlaceId, lp)
end)
btns.Rejoin.MouseButton1Click:Connect(function()
    TeleportService:Teleport(game.PlaceId, lp)
end)
btns.Suicide.MouseButton1Click:Connect(function()
    if hum then hum.Health = 0 end
end)
btns.Leave.MouseButton1Click:Connect(function()
    pcall(function() lp:Kick("Leaving...") end)
end)
