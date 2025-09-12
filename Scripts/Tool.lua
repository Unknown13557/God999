-- ====== CLEANUP PATCH ======
if _G.__MAGIC_CLEANUP then _G.__MAGIC_CLEANUP() end
_G.__MAGIC_CLEANUP = function()
    for _,id in ipairs({
        "__MAGIC_HB_APPLY",
        "__MAGIC_INFJUMP",
        "__MAGIC_ESP_WATCH",
        "__MAGIC_SPEED_SAFE",
        "__MAGIC_ESCAPE_LOOP",
        "__MAGIC_ZOOM_LOOP",
	    "__MAGIC_CAM_FIX_LOOP",
		"__MAGIC_NOCLIP_LOOP"	
    }) do
        if _G[id] and typeof(_G[id])=="RBXScriptConnection" then
            _G[id]:Disconnect()
        end
        _G[id] = nil
    end
end
-- ============================

local Players = game:GetService("Players")
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

-- ICON TRÒN 48x48: luôn hiện, kẹp trong màn hình, kéo mượt, không "nhảy
-- ICON 48x48 (tròn) + KÉO MƯỢT + CLICK/DRAG PHÂN BIỆT
local function waitForCamera()
    local cam = workspace.CurrentCamera
    while not cam do
        task.wait()
        cam = workspace.CurrentCamera
    end
    return cam
end

-- clamp theo màn hình (dựa trên AnchorPoint hiện tại)
local function clampToScreen(x, y)
    local cam = waitForCamera()
    local v = cam.ViewportSize
    local sz = icon and icon.AbsoluteSize or Vector2.new(48,48)
    return math.clamp(x, 0, v.X - sz.X), math.clamp(y, 0, v.Y - sz.Y)
end

-- tạo icon
local icon = Instance.new("ImageButton")
icon.Name = "FloatingIcon"
icon.Size = UDim2.fromOffset(48,48)
icon.AnchorPoint = Vector2.new(0, 0.5)
icon.BackgroundColor3 = THEME.Accent
icon.BackgroundTransparency = 0.2
icon.AutoButtonColor = false
icon.Active = true
icon.Selectable = false
icon.Modal = false
icon.ZIndex = 10000
icon.Parent = gui

-- visual
Instance.new("UICorner", icon).CornerRadius = UDim.new(1,0)
local stroke = Instance.new("UIStroke")
stroke.Thickness = 1.5
stroke.Color = Color3.fromRGB(255,255,255)
stroke.Transparency = 0.15
stroke.Parent = icon

icon.Image = "rbxassetid://3926305904"
icon.ImageRectOffset = Vector2.new(4,204)
icon.ImageRectSize   = Vector2.new(36,36)

-- đặt vị trí an toàn (mé trái, giữa)
do
    waitForCamera()
    local v = workspace.CurrentCamera.ViewportSize
    local x = 16
    local y = v.Y/2 - (icon.AbsoluteSize.Y/2)
    x, y = clampToScreen(x,y)
    icon.Position = UDim2.fromOffset(x,y)
    -- đặt 2 lần sau 1 frame để tránh AbsoluteSize chưa cập nhật kịp
    task.defer(function()
        local x2, y2 = clampToScreen(icon.Position.X.Offset, icon.Position.Y.Offset)
        icon.Position = UDim2.fromOffset(x2,y2)
    end)
end

-- ===== KÉO/THẢ MƯỢT (bám sát ngón tay) =====
do
    local dragging = false
    local activeInput = nil
    local grabOffset = Vector2.new(0,0)
    local startPos = Vector2.new(0,0)
    local moved = 0
    local DRAG_THRESHOLD = 6

    local function getMouse()
        local m = UIS:GetMouseLocation()
        return Vector2.new(m.X, m.Y)
    end

    local function beginDrag(input)
        dragging = true
        activeInput = input
        icon.Modal = true
        local m = getMouse()
        local abs = icon.AbsolutePosition
        grabOffset = Vector2.new(m.X - abs.X, m.Y - abs.Y)
        startPos = Vector2.new(icon.Position.X.Offset, icon.Position.Y.Offset)
        moved = 0
    end

    local function updateDrag()
        if not dragging then return end
        local m = getMouse()
        local x = m.X - grabOffset.X
        local y = m.Y - grabOffset.Y
        local cx, cy = clampToScreen(x, y)
        moved = math.max(moved, math.abs(cx - startPos.X) + math.abs(cy - startPos.Y))
        icon.Position = UDim2.fromOffset(cx, cy)
    end

    icon.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch
        or input.UserInputType == Enum.UserInputType.MouseButton1 then
            beginDrag(input)
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if dragging and input == activeInput then
            updateDrag()
        end
    end)

    UIS.InputEnded:Connect(function(input)
        if input == activeInput then
            local wasDrag = moved >= DRAG_THRESHOLD
            dragging = false
            activeInput = nil
            icon.Modal = false
            if not wasDrag then
                -- tap: toggle cửa sổ
                pcall(function() window.Visible = not window.Visible end)
            end
        end
    end)
end

-- toggle menu
icon.MouseButton1Click:Connect(function()
    window.Visible = not window.Visible
end)

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
closeBtn.Size = UDim2.fromOffset(32, TITLE_H)
closeBtn.AnchorPoint = Vector2.new(1,0)
closeBtn.Position = UDim2.new(1,0,0,0)
closeBtn.Text = "X"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 20
closeBtn.TextColor3 = THEME.Subtle
closeBtn.BackgroundTransparency = 1
closeBtn.Parent = titleBar
closeBtn.MouseButton1Click:Connect(function()
    -- overlay full màn hình
    local overlay = Instance.new("Frame")
    overlay.Size = UDim2.fromScale(1,1)
    overlay.Position = UDim2.fromOffset(0,0)
    overlay.BackgroundColor3 = Color3.new(0,0,0)
    overlay.BackgroundTransparency = 1
    overlay.BorderSizePixel = 0
    overlay.ZIndex = 1999
    overlay.Active = true -- chặn click xuyên
    overlay.Parent = gui

    -- fade in overlay
    TweenService:Create(overlay, TweenInfo.new(0.15), {BackgroundTransparency = 0.35}):Play()

    -- khung confirm
    local confirm = Instance.new("Frame")
    confirm.Size = UDim2.new(0, 300, 0, 120)
    confirm.Position = UDim2.new(0.5, -150, 0.5, -60)
    confirm.BackgroundColor3 = THEME.Background
    confirm.BorderSizePixel = 0
    confirm.ZIndex = 2000
    confirm.Parent = gui
    Instance.new("UICorner", confirm).CornerRadius = UDim.new(0, 10)

    local msg = Instance.new("TextLabel")
    msg.Size = UDim2.new(1, -20, 0, 60)
    msg.Position = UDim2.fromOffset(10, 10)
    msg.BackgroundTransparency = 1
    msg.TextColor3 = THEME.Text
    msg.Text = "Are you sure you want to close?"
    msg.Font = Enum.Font.GothamBold
    msg.TextSize = 16
    msg.TextWrapped = true
    msg.ZIndex = 2001
    msg.Parent = confirm

    local yesBtn = Instance.new("TextButton")
    yesBtn.Size = UDim2.new(0.5, -15, 0, 32)
    yesBtn.Position = UDim2.new(0, 10, 1, -42)
    yesBtn.BackgroundColor3 = THEME.Accent
    yesBtn.Text = "Yes"
    yesBtn.Font = Enum.Font.GothamBold
    yesBtn.TextColor3 = THEME.Text
    yesBtn.TextSize = 14
    yesBtn.ZIndex = 2001
    yesBtn.Parent = confirm
    Instance.new("UICorner", yesBtn).CornerRadius = UDim.new(0, 6)

    local noBtn = Instance.new("TextButton")
    noBtn.Size = UDim2.new(0.5, -15, 0, 32)
    noBtn.Position = UDim2.new(0.5, 5, 1, -42)
    noBtn.BackgroundColor3 = THEME.Hover
    noBtn.Text = "No"
    noBtn.Font = Enum.Font.GothamBold
    noBtn.TextColor3 = THEME.Text
    noBtn.TextSize = 14
    noBtn.ZIndex = 2001
    noBtn.Parent = confirm
    Instance.new("UICorner", noBtn).CornerRadius = UDim.new(0, 6)

    local function cleanup()
        TweenService:Create(overlay, TweenInfo.new(0.12), {BackgroundTransparency = 1}):Play()
        task.delay(0.12, function()
            overlay:Destroy()
            confirm:Destroy()
        end)
    end

    yesBtn.MouseButton1Click:Connect(function()
        cleanup()
        gui:Destroy()
    end)
    noBtn.MouseButton1Click:Connect(function()
        cleanup()
    end)
end)

local credit = Instance.new("TextLabel")
credit.Name = "Credit"
credit.BackgroundTransparency = 1
credit.Parent = titleBar
credit.Text = "by Magic"
credit.Font = Enum.Font.Gotham
credit.TextSize = 12
credit.TextColor3 = THEME.Subtle
credit.TextXAlignment = Enum.TextXAlignment.Left
credit.Position = UDim2.fromOffset(8 + title.TextBounds.X + 18, 0) -- ngay sau tiêu đề
credit.Size = UDim2.new(0, 120, 1, 0)

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
local escSwitch  = mkSwitchRow("Fast Escape")
-- === MAGIC BLOCK: PlayerList + Clear Target + Teleport Player (under Fast Escape) ===
-- helpers: tạo nút local không dùng mkClickBtn/mkSwitchRow để không đổi parent
local function MagicLocalClick(parent, text)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -PAD, 0, 26)
    b.Position = UDim2.fromOffset(PAD, 0)
    b.BackgroundColor3 = THEME.Hover
    b.Text = text
    b.Font = Enum.Font.GothamBold
    b.TextSize = 12
    b.TextColor3 = THEME.Text
    b.AutoButtonColor = false
    b.Parent = parent
    Instance.new("UICorner", b).CornerRadius = UDim.new(0,5)
    b.MouseEnter:Connect(function() TweenService:Create(b, TweenInfo.new(0.12), {BackgroundColor3 = THEME.Accent}):Play() end)
    b.MouseLeave:Connect(function() TweenService:Create(b, TweenInfo.new(0.12), {BackgroundColor3 = THEME.Hover}):Play() end)
    b.MouseButton1Down:Connect(function() TweenService:Create(b, TweenInfo.new(0.08), {BackgroundColor3 = THEME.Titlebar}):Play() end)
    b.MouseButton1Up:Connect(function() TweenService:Create(b, TweenInfo.new(0.08), {BackgroundColor3 = THEME.Accent}):Play() end)
    return b
end
local function MagicLocalSwitch(parent, labelText)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 24)
    row.BackgroundTransparency = 1
    row.Parent = parent

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
    sw.MouseEnter:Connect(function() TweenService:Create(sw, TweenInfo.new(0.12), {BackgroundColor3 = THEME.Accent}):Play() end)
    sw.MouseLeave:Connect(function() TweenService:Create(sw, TweenInfo.new(0.12), {BackgroundColor3 = THEME.Hover}):Play() end)
    sw.MouseButton1Down:Connect(function() TweenService:Create(sw, TweenInfo.new(0.08), {BackgroundColor3 = THEME.Titlebar}):Play() end)
    sw.MouseButton1Up:Connect(function() TweenService:Create(sw, TweenInfo.new(0.08), {BackgroundColor3 = THEME.Accent}):Play() end)

    local state=false
    local api = {
        Row=row, Switch=sw, Label=lbl,
        Get=function() return state end,
        Set=function(v) state = v and true or false; sw.Text = state and "ON" or "OFF" end
    }
    sw.MouseButton1Click:Connect(function() api.Set(not state) end)
    return api
end

-- group container (nằm ngay trong scroll)
local magicGroup = Instance.new("Frame")
magicGroup.Name = "MagicTargetGroup"
magicGroup.Size = UDim2.new(1, 0, 0, 0)
magicGroup.AutomaticSize = Enum.AutomaticSize.Y
magicGroup.BackgroundTransparency = 1
magicGroup.Parent = scroll

local groupList = Instance.new("UIListLayout", magicGroup)
groupList.FillDirection = Enum.FillDirection.Vertical
groupList.SortOrder = Enum.SortOrder.LayoutOrder
groupList.Padding = UDim.new(0, 3)

-- header: nút toggle PlayerList
local plToggleBtn = MagicLocalClick(magicGroup, "PlayerList ⬇️")

-- vùng danh sách (tự giãn)
local listHolder = Instance.new("Frame")
listHolder.Name = "MagicPlayerList"
listHolder.Size = UDim2.new(1, -PAD, 0, 0)
listHolder.AutomaticSize = Enum.AutomaticSize.Y
listHolder.BackgroundTransparency = 1
listHolder.Active = false
listHolder.ClipsDescendants = true
listHolder.ZIndex = 1
listHolder.Parent = magicGroup

local lhPad = Instance.new("UIPadding", listHolder)
lhPad.PaddingLeft  = UDim.new(0, PAD)
lhPad.PaddingRight = UDim.new(0, PAD)

local lhLayout = Instance.new("UIListLayout", listHolder)
lhLayout.FillDirection = Enum.FillDirection.Vertical
lhLayout.SortOrder = Enum.SortOrder.LayoutOrder
lhLayout.Padding = UDim.new(0, 3)

-- nút Clear Target
local clearTargetBtn = MagicLocalClick(magicGroup, "Clear Target [Click]")

-- switch Teleport Player
local tpSwitch = MagicLocalSwitch(magicGroup, "Teleport Player")

-- state chọn target
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

local SELECTED_COLOR = Color3.fromRGB(0,0,0) -- highlight đen
local function mkListItem(text, plr)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, 0, 0, 24)
    b.BackgroundColor3 = THEME.Hover
    b.AutoButtonColor = false
    b.Text = text
    b.Font = Enum.Font.Gotham
    b.TextSize = 12
    b.TextColor3 = THEME.Text
    b.Parent = listHolder
    Instance.new("UICorner", b).CornerRadius = UDim.new(0,5)

    local function isSelected() return _G.Magic_SelectedTarget == plr end
    local function applyNormal()
        if isSelected() then b.BackgroundColor3 = SELECTED_COLOR else b.BackgroundColor3 = THEME.Hover end
    end
    applyNormal()

    b.MouseEnter:Connect(function()
        if not isSelected() then TweenService:Create(b, TweenInfo.new(0.12), {BackgroundColor3 = THEME.Accent}):Play() end
    end)
    b.MouseLeave:Connect(function()
        if not isSelected() then TweenService:Create(b, TweenInfo.new(0.12), {BackgroundColor3 = THEME.Hover}):Play() end
    end)

    b.MouseButton1Click:Connect(function()
        _G.Magic_SelectedTarget = plr
        MagicUpdateListHeader()
        for _,c in ipairs(listHolder:GetChildren()) do
            if c:IsA("TextButton") then c.BackgroundColor3 = THEME.Hover end
        end
        b.BackgroundColor3 = SELECTED_COLOR
    end)
    return b
end

local function MagicRenderPlayerList()
    for _,c in ipairs(listHolder:GetChildren()) do
        if c:IsA("TextButton") then c:Destroy() end
    end
    for _,p in ipairs(Players:GetPlayers()) do
        if p ~= player then mkListItem(p.Name, p) end
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
        if c:IsA("TextButton") then c.BackgroundColor3 = THEME.Hover end
    end
end)

Players.PlayerAdded:Connect(function()
    if listVisible then MagicRenderPlayerList() end
    MagicUpdateListHeader()
end)
Players.PlayerRemoving:Connect(function(rem)
    if _G.Magic_SelectedTarget == rem then _G.Magic_SelectedTarget = nil end
    if listVisible then MagicRenderPlayerList() end
    MagicUpdateListHeader()
end)

-- PATCH: hợp nhất API, không ghi đè
_G.MagicMenuStates          = _G.MagicMenuStates or {}
_G.MagicMenuStates.Buttons  = _G.MagicMenuStates.Buttons or {}
-- === MAGIC API (HỢP NHẤT, KHÔNG ĐÈ LÊN NHAU) ===
local api = _G.MagicMenuStates or {}

api.FastEscape      = escSwitch.Get
api.TeleportPlayer  = tpSwitch.Get
api.ESP             = espSwitch.Get
api.NoClip          = noclipSwitch.Get
api.InfinityJump    = infSwitch.Get
api.WalkSpeedHack   = wsSwitch.Get
api.JumpPowerHack   = jpSwitch.Get
api.WalkSpeedFactor = function() return tonumber(wsInput.Text) or 1 end
api.JumpPowerFactor = function() return tonumber(jpInput.Text) or 1 end

-- expose target đang chọn từ PlayerList
api.SelectedTarget  = function() return _G.Magic_SelectedTarget end

-- gói tất cả button vào một nơi
api.Buttons = {
    Hop             = hopBtn,
    Rejoin          = rejoinBtn,
    Suicide         = suiBtn,
    Leave           = leaveBtn,
    Zoom            = zoomBtn,
    FixCamera       = camFixBtn,
    PlayerListToggle= plToggleBtn,
    ClearTarget     = clearTargetBtn,
}

_G.MagicMenuStates = api
-- === END MAGIC API ===

-- PHẦN 2 (SẠCH): Speed đơn giản (không xuyên tường) + JumpPower ổn định + Infinity Jump chuẩn
-- + ESP luôn bám người chơi mới/reset + các nút click (Hop/Rejoin/Suicide/Leave)
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")

local lp = Players.LocalPlayer

while not _G.MagicMenuStates do task.wait() end
local S = _G.MagicMenuStates

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

-- PATCH SPEED + RAYCAST (không hạ WalkSpeed gốc của game khi chưa bật)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

while not _G.MagicMenuStates do task.wait() end
local S = _G.MagicMenuStates

local lp = Players.LocalPlayer
local char, hum, hrp
local BASE_WS = 16

local function bindChar(c)
	char = c
	hum  = c:WaitForChild("Humanoid", 8)
	hrp  = c:WaitForChild("HumanoidRootPart", 8)
	if hum then
		BASE_WS = (hum.WalkSpeed and hum.WalkSpeed > 0) and hum.WalkSpeed or 16
		hum.AutoRotate = true
	end
end

if lp.Character then bindChar(lp.Character) end
lp.CharacterAdded:Connect(bindChar)

if _G.__MAGIC_SPEED_RUN then _G.__MAGIC_SPEED_RUN:Disconnect() end

local rayParams = RaycastParams.new()
rayParams.FilterType = Enum.RaycastFilterType.Exclude

_G.__MAGIC_SPEED_RUN = RunService.RenderStepped:Connect(function(dt)
	if not hum or not hrp or not char or not char.Parent then return end
	rayParams.FilterDescendantsInstances = {char}

	-- Nếu chưa bật hack: KHÔNG đụng vào WalkSpeed, đồng thời cập nhật BASE_WS theo game
	if not (S.WalkSpeedHack and S.WalkSpeedHack()) then
		if hum.WalkSpeed and hum.WalkSpeed > 0 then
			BASE_WS = hum.WalkSpeed
		end
		return
	end

	local f = tonumber(S.WalkSpeedFactor and S.WalkSpeedFactor() or 1) or 1
	if f <= 1 then return end

	local dir = hum.MoveDirection
	if dir.Magnitude < 0.05 then return end
	dir = dir.Unit

	local target = math.clamp(BASE_WS * f, 0, 200)
	local curVel = hrp.AssemblyLinearVelocity
	local desired = dir * target

	-- Raycast chống đâm tường -> chuyển sang trượt theo tường
	local predictDist = math.max((target * dt) + 1.0, 2.0)
	local hit = workspace:Raycast(hrp.Position, dir * predictDist, rayParams)
	if hit then
		local n = hit.Normal
		if n:Dot(dir) < -0.2 then
			local tangential = desired - n * desired:Dot(n)
			if tangential.Magnitude > 0.05 then
				desired = tangential.Unit * math.min(tangential.Magnitude, target * 0.85)
			else
				desired = Vector3.zero
			end
		end
	end

	-- Nội suy mượt vận tốc ngang, giữ Y hiện tại để không bay
	local accel = math.clamp(25 * f * dt, 0, 1)
	local newHoriz = Vector3.new(curVel.X, 0, curVel.Z):Lerp(Vector3.new(desired.X, 0, desired.Z), accel)
	hrp.AssemblyLinearVelocity = Vector3.new(newHoriz.X, curVel.Y, newHoriz.Z)

	-- Anti-lean
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

-- ==================== NOCLIP TOGGLE ====================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local lp = Players.LocalPlayer
local char, hum

local function bindChar(c)
    char = c
    hum = c:WaitForChild("Humanoid", 8)
end
if lp.Character then bindChar(lp.Character) end
lp.CharacterAdded:Connect(bindChar)

-- clear loop cũ nếu có
if _G.__MAGIC_NOCLIP then _G.__MAGIC_NOCLIP:Disconnect() end

_G.__MAGIC_NOCLIP = RunService.Stepped:Connect(function()
    if not char or not _G.MagicMenuStates then return end
    if _G.MagicMenuStates.NoClip and _G.MagicMenuStates.NoClip() then
        for _, v in ipairs(char:GetDescendants()) do
            if v:IsA("BasePart") and v.CanCollide then
                v.CanCollide = false
            end
        end
    else
        for _, v in ipairs(char:GetDescendants()) do
            if v:IsA("BasePart") and not v.CanCollide then
                v.CanCollide = true
            end
        end
    end
end)
-- =======================================================

-- JUMPPOWER: cưỡng bức ổn định (không để game ghi đè), luôn UseJumpPower
_G.__MAGIC_JP_ENFORCE = RunService.Heartbeat:Connect(function()
    if not hum or not hum.Parent then return end
    hum.UseJumpPower = true

    local enabled = S.JumpPowerHack and S.JumpPowerHack() or false
    if enabled then
        local jf = tonumber(S.JumpPowerFactor and S.JumpPowerFactor() or 1) or 1
        local targetJP = math.clamp(BASE_JP * jf, 10, 1000)
        if hum.JumpPower ~= targetJP then hum.JumpPower = targetJP end
    else
        if hum.JumpPower ~= BASE_JP then hum.JumpPower = BASE_JP end
    end
end)

_G.__MAGIC_JP_PROP = (function()
    if not hum then return nil end
    return hum:GetPropertyChangedSignal("JumpPower"):Connect(function()
        if not hum or not hum.Parent then return end
        if S.JumpPowerHack and S.JumpPowerHack() then
            local jf = tonumber(S.JumpPowerFactor and S.JumpPowerFactor() or 1) or 1
            local targetJP = math.clamp(BASE_JP * jf, 10, 1000)
            if hum.JumpPower ~= targetJP then
                hum.UseJumpPower = true
                hum.JumpPower = targetJP
            end
        end
    end)
end)()

-- === REPLACE THIS WHOLE INFINITY JUMP BLOCK IN PHẦN 2 ===

-- Clean old binds
if _G.__MAGIC_INFJUMP then _G.__MAGIC_INFJUMP:Disconnect() end
if _G.__MAGIC_INFJUMP2 then _G.__MAGIC_INFJUMP2:Disconnect() end
if _G.__MAGIC_INFJUMP_CHAR then _G.__MAGIC_INFJUMP_CHAR:Disconnect() end

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

_G.__MAGIC_INFJUMP = UIS.JumpRequest:Connect(doInfJump)

_G.__MAGIC_INFJUMP2 = UIS.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.Space then
        doInfJump()
    end
end)

_G.__MAGIC_INFJUMP_CHAR = Players.LocalPlayer.CharacterAdded:Connect(function(c)
    task.wait(0.2)
    char = c
    hum = c:FindFirstChildOfClass("Humanoid")
end)

-- ===== ESCAPE LOGIC (ON = bay lên trời, OFF = rơi xuống an toàn) =====
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

while not _G.MagicMenuStates do task.wait() end
local S  = _G.MagicMenuStates
local lp = Players.LocalPlayer

local char, hum, hrp
local function bindChar(c)
    char = c
    hum  = c:WaitForChild("Humanoid", 8)
    hrp  = c:WaitForChild("HumanoidRootPart", 8)
end
if lp.Character then bindChar(lp.Character) end
lp.CharacterAdded:Connect(bindChar)

-- hàm đọc trạng thái toggle bất kể bạn đặt key là gì
local function EscapeOn()
    local f = S.FastEscape or S.ESC or S.Escape
    if typeof(f) == "function" then
        local ok, val = pcall(f)
        return ok and (val == true)
    end
    return false
end

-- cleanup cũ
if _G.__MAGIC_ESCAPE_LOOP then _G.__MAGIC_ESCAPE_LOOP:Disconnect() end

local activeTween
local rayParams = RaycastParams.new()
rayParams.FilterType = Enum.RaycastFilterType.Exclude

_G.__MAGIC_ESCAPE_LOOP = RunService.RenderStepped:Connect(function(dt)
    if not hrp then return end

    if EscapeOn() then
        if not activeTween then
            local pos = hrp.Position
            local target = Vector3.new(pos.X, pos.Y + 50000, pos.Z)
            local dist = (target - pos).Magnitude
            local time = dist / 300
            local tw = TweenService:Create(hrp, TweenInfo.new(time, Enum.EasingStyle.Linear), {CFrame = CFrame.new(target)})
            activeTween = tw
            tw:Play()
            tw.Completed:Connect(function()
                activeTween = nil
            end)
        end
    else
        if activeTween then
            activeTween:Cancel()
            activeTween = nil
        end
        -- hạ tốc rơi khi gần đất để tránh xuyên
        if char then
            rayParams.FilterDescendantsInstances = {char}
            local origin = hrp.Position
            local r = workspace:Raycast(origin, Vector3.new(0, -1000, 0), rayParams)
            if r then
                local dist = origin.Y - r.Position.Y
                if dist <= 100 then
                    local vel = hrp.AssemblyLinearVelocity
                    if vel.Y < -200 then
                        hrp.AssemblyLinearVelocity = Vector3.new(vel.X, -200, vel.Z)
                    end
                end
            end
        end
    end
end)

---FixCamera (1-click), KHÔNG đụng HumanoidRootPart
local Players = game:GetService("Players")
local UIS     = game:GetService("UserInputService")
local RS      = game:GetService("RunService")

local lp = Players.LocalPlayer

-- chờ GUI state
while not _G.MagicMenuStates do task.wait() end
local S = _G.MagicMenuStates
local camBtn = S.Buttons and S.Buttons.FixCamera

-- dọn loop cũ (nếu có)
if _G.__MAGIC_CAM_FIX_LOOP then
    _G.__MAGIC_CAM_FIX_LOOP:Disconnect()
    _G.__MAGIC_CAM_FIX_LOOP = nil
end

-- hàm fix mềm, không phá script khác: chỉ ép CameraType/Subject trong thời gian ngắn, rồi thôi
local function magicSoftFixCamera()
    local cam = workspace.CurrentCamera
    if not cam then return end

    local char = lp.Character
    local hum  = char and char:FindFirstChildOfClass("Humanoid")

    -- switch nhanh Scriptable -> Custom để “đập” mấy state kẹt
    cam.CameraType = Enum.CameraType.Scriptable
    task.wait(0.02)

    -- đặt Subject về Humanoid nếu có, nếu không thì để nguyên
    if hum and hum.Parent then
        cam.CameraSubject = hum
    end

    -- reset kiểu camera về Custom
    cam.CameraType = Enum.CameraType.Custom

    -- trả chuột về mặc định (hữu ích trên mobile khi camera lock)
    pcall(function()
        UIS.MouseBehavior = Enum.MouseBehavior.Default
        UIS.MouseIconEnabled = true
    end)

    -- làm “neo” nhẹ trong 1.2s để camera không bị script khác set lại ngay lập tức
    local t0 = os.clock()
    if _G.__MAGIC_CAM_FIX_LOOP then
        _G.__MAGIC_CAM_FIX_LOOP:Disconnect()
        _G.__MAGIC_CAM_FIX_LOOP = nil
    end
    _G.__MAGIC_CAM_FIX_LOOP = RS.RenderStepped:Connect(function()
        -- giữ kiểu Custom trong 1.2 giây
        if (os.clock() - t0) > 1.2 then
            _G.__MAGIC_CAM_FIX_LOOP:Disconnect()
            _G.__MAGIC_CAM_FIX_LOOP = nil
            return
        end
        if cam.CameraType ~= Enum.CameraType.Custom then
            cam.CameraType = Enum.CameraType.Custom
        end
        if hum and hum.Parent and cam.CameraSubject ~= hum then
            cam.CameraSubject = hum
        end
    end)
end

-- gán click vào nút
if camBtn and not _G.__MAGIC_CAM_BTN_ONCE then
    _G.__MAGIC_CAM_BTN_ONCE = camBtn.MouseButton1Click:Connect(magicSoftFixCamera)
end

-- auto rebind khi respawn, phòng khi camera lại bị lock sau khi chết/spawn
local function bindChar(c)
    local hum = c:WaitForChild("Humanoid", 8)
    task.defer(function()
        magicSoftFixCamera()
    end)
end
if lp.Character then bindChar(lp.Character) end
lp.CharacterAdded:Connect(bindChar)

-- ===== Infinity Zoom =====
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

while not _G.MagicMenuStates do task.wait() end
local S  = _G.MagicMenuStates
local lp = Players.LocalPlayer

local zoomBtn = S.Buttons and S.Buttons.Zoom

-- Cờ toàn cục: đã kích hoạt vĩnh viễn trong phiên chơi hay chưa
_G.__MAGIC_ZOOM_FOREVER = (_G.__MAGIC_ZOOM_FOREVER == true)

-- cập nhật chữ & trạng thái nút (nếu có)
local function refreshZoomButton()
    if not zoomBtn then return end
    if _G.__MAGIC_ZOOM_FOREVER then
        zoomBtn.Text = "Infinity Zoom: ON"
        zoomBtn.AutoButtonColor = false
        zoomBtn.Active = false
        zoomBtn.Selectable = false
        zoomBtn.BackgroundTransparency = 0  -- vẫn hiện nút nhưng vô hiệu
    else
        zoomBtn.Text = "Infinity Zoom [Click]"
        zoomBtn.Active = true
        zoomBtn.AutoButtonColor = true
        zoomBtn.Selectable = true
    end
end
refreshZoomButton()

-- click 1 lần -> bật vĩnh viễn (trong phiên chơi)
if zoomBtn and not _G.__MAGIC_ZOOM_BTN_ONE then
    _G.__MAGIC_ZOOM_BTN_ONE = zoomBtn.MouseButton1Click:Connect(function()
        if _G.__MAGIC_ZOOM_FOREVER then return end
        _G.__MAGIC_ZOOM_FOREVER = true
        refreshZoomButton()
    end)
end

-- loop áp dụng zoom
if _G.__MAGIC_ZOOM_LOOP then _G.__MAGIC_ZOOM_LOOP:Disconnect() end
_G.__MAGIC_ZOOM_LOOP = RunService.RenderStepped:Connect(function()
    local cam = workspace.CurrentCamera
    if not cam then return end

    if _G.__MAGIC_ZOOM_FOREVER then
        if lp.CameraMinZoomDistance ~= 0.5 then
            lp.CameraMinZoomDistance = 0.5
        end
        if lp.CameraMaxZoomDistance < 1e6 then
            lp.CameraMaxZoomDistance = 1e6
        end
    end
end)

-- ESP (BillboardGui: tên đỏ + khoảng cách trắng + HP xanh).
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

if _G.__MAGIC_ESP_WATCH then _G.__MAGIC_ESP_WATCH:Disconnect() end
_G.__MAGIC_ESP_WATCH = RunService.RenderStepped:Connect(function()
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
    pcall(function() lp:Kick("Leave") end)
end)
