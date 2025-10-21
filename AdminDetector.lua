local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- ========== CONFIG ==========
local HP_THRESHOLD = 17000
local BLOCKED_USERNAMES = {
    ["uzoth"] = true,
    ["zioles"] = true,
    ["mygame43"] = true,
    ["rip_indra"] = true,
    ["isekai_isekai"] = true,
}

-- ========== STATE ==========
local kicked = false
local function triggerKick(reason)
    if kicked then return end
    kicked = true
    LocalPlayer:Kick("[Admin Detected] " .. tostring(reason))
end

-- ========== CHECKS ==========
local function checkUsername(p)
    local uname = (p.Name or ""):lower()
    if BLOCKED_USERNAMES[uname] then
        triggerKick("Username @" .. uname)
        return true
    end
    return false
end

local function connectHumanoidForHP(p, hum)
    if not hum or kicked then return end
    local function checkHP()
        if kicked then return end
        local h  = tonumber(hum.Health) or 0
        local mh = tonumber(hum.MaxHealth) or 0
        if h >= HP_THRESHOLD or mh >= HP_THRESHOLD then
            triggerKick(("HP >= %d with %s (H=%s, MaxH=%s)"):format(HP_THRESHOLD, p.Name, h, mh))
        end
    end
    checkHP()
    hum.HealthChanged:Connect(checkHP)
    if hum.GetPropertyChangedSignal then
        hum:GetPropertyChangedSignal("MaxHealth"):Connect(checkHP)
    end
end

local function attachCharacterForHP(p, char)
    if kicked then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then hum = char:WaitForChild("Humanoid", 10) end
    if not hum then
        for _ = 1, 50 do
            if kicked then return end
            hum = char:FindFirstChildOfClass("Humanoid")
            if hum then break end
            task.wait(0.1)
        end
    end
    if hum then connectHumanoidForHP(p, hum) end
end

local function watchHP(p)
    if p == LocalPlayer then return end
    if p.Character then task.defer(attachCharacterForHP, p, p.Character) end
    p.CharacterAdded:Connect(function(char)
        task.defer(attachCharacterForHP, p, char)
    end)
end

local function checkPlayerFull(p)
    if kicked or p == LocalPlayer then return end
    checkUsername(p)
    if p.Character then
        local hum = p.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            local h  = tonumber(hum.Health) or 0
            local mh = tonumber(hum.MaxHealth) or 0
            if h >= HP_THRESHOLD or mh >= HP_THRESHOLD then
                triggerKick(("HP (startup) >= %d ở %s (H=%s, MaxH=%s)"):format(HP_THRESHOLD, p.Name, h, mh))
            end
        end
    end
    watchHP(p)
end

-- ========== ÁP DỤNG ==========
for _, p in ipairs(Players:GetPlayers()) do
    checkPlayerFull(p)
end

Players.PlayerAdded:Connect(checkPlayerFull)

task.defer(function()
    task.wait(1)
    for _, p in ipairs(Players:GetPlayers()) do
        if kicked then break end
        checkPlayerFull(p)
    end
end)
