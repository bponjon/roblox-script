-- MountBingung SC Magnet (client-only)
-- Execute via loadstring on client / HP. Client-side only: only visible to local player.
-- Features: GUI, radius, speed, whitelist mode, start/stop, hide/close.

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local pg = player:WaitForChild("PlayerGui")

-- ===== CONFIG =====
local DEFAULT_RADIUS = 25
local DEFAULT_SPEED  = 8        -- lerp factor per tick (higher = faster)
local MAX_PARTS_PER_TICK = 250  -- safety cap
local SCAN_INTERVAL = 0.06      -- heartbeat aggregation

-- Protected name patterns (won't touch)
local PROTECTED_PATTERNS = {
    "terrain", "spawnlocation", "spawn", "water", "baseplate", "checkpoint", "goal"
}

-- Whitelist example (only used if whitelistMode == true)
local WHITELIST_NAMES = { "Prize", "Loot", "Gem", "Collectible" }
local whitelistMode = false

local function isProtected(part)
    if not part or not part:IsA("BasePart") then return true end
    if part:IsDescendantOf(player.Character or workspace) and part:IsDescendantOf(player.Character) then return true end
    -- don't touch other players' characters/tools
    if part:FindFirstAncestorOfClass("Tool") then return true end
    if part:IsDescendantOf(workspace.Terrain) then return true end
    local name = (part.Name or ""):lower()
    for _, pat in ipairs(PROTECTED_PATTERNS) do
        if string.find(name, pat) then return true end
    end
    -- don't move spawn or seats
    if part:IsA("SpawnLocation") or part:IsA("Seat") then return true end
    return false
end

local function isWhitelisted(part)
    if not whitelistMode then return true end
    for _,n in ipairs(WHITELIST_NAMES) do
        if string.lower(part.Name) == string.lower(n) then return true end
    end
    return false
end

-- ===== GUI =====
local screen = Instance.new("ScreenGui")
screen.Name = "MB_MagnetGui"
screen.ResetOnSpawn = false
screen.Parent = pg

local frame = Instance.new("Frame", screen)
frame.Size = UDim2.new(0,300,0,200)
frame.Position = UDim2.new(0,20,0,140)
frame.BackgroundColor3 = Color3.fromRGB(35,0,45)
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, -90, 0, 30)
title.Position = UDim2.new(0,10,0,6)
title.BackgroundTransparency = 1
title.Text = "MountBingung — Magnet"
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.TextColor3 = Color3.fromRGB(245,245,245)
title.TextXAlignment = Enum.TextXAlignment.Left

local closeBtn = Instance.new("TextButton", frame)
closeBtn.Size = UDim2.new(0,44,0,28)
closeBtn.Position = UDim2.new(1,-52,0,6)
closeBtn.Text = "X"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.BackgroundColor3 = Color3.fromRGB(150,20,20)
closeBtn.TextColor3 = Color3.fromRGB(255,255,255)

local hideBtn = Instance.new("TextButton", frame)
hideBtn.Size = UDim2.new(0,36,0,28)
hideBtn.Position = UDim2.new(1,-94,0,6)
hideBtn.Text = "_"
hideBtn.Font = Enum.Font.GothamBold
hideBtn.BackgroundColor3 = Color3.fromRGB(70,0,70)
hideBtn.TextColor3 = Color3.fromRGB(255,255,255)

local infoLabel = Instance.new("TextLabel", frame)
infoLabel.Size = UDim2.new(1,-20,0,18)
infoLabel.Position = UDim2.new(0,10,0,44)
infoLabel.BackgroundTransparency = 1
infoLabel.Text = "Status: Idle"
infoLabel.Font = Enum.Font.SourceSans
infoLabel.TextSize = 12
infoLabel.TextColor3 = Color3.fromRGB(210,210,210)
infoLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Radius & Speed controls
local radiusLabel = Instance.new("TextLabel", frame)
radiusLabel.Size = UDim2.new(0,120,0,18)
radiusLabel.Position = UDim2.new(0,10,0,70)
radiusLabel.BackgroundTransparency = 1
radiusLabel.Text = "Radius: "..tostring(DEFAULT_RADIUS)
radiusLabel.Font = Enum.Font.SourceSans
radiusLabel.TextSize = 12
radiusLabel.TextColor3 = Color3.fromRGB(220,220,220)

local radiusBox = Instance.new("TextBox", frame)
radiusBox.Size = UDim2.new(0,80,0,20)
radiusBox.Position = UDim2.new(0,130,0,68)
radiusBox.PlaceholderText = tostring(DEFAULT_RADIUS)
radiusBox.Text = ""

local speedLabel = Instance.new("TextLabel", frame)
speedLabel.Size = UDim2.new(0,120,0,18)
speedLabel.Position = UDim2.new(0,10,0,96)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "Speed: "..tostring(DEFAULT_SPEED)
speedLabel.Font = Enum.Font.SourceSans
speedLabel.TextSize = 12
speedLabel.TextColor3 = Color3.fromRGB(220,220,220)

local speedBox = Instance.new("TextBox", frame)
speedBox.Size = UDim2.new(0,80,0,20)
speedBox.Position = UDim2.new(0,130,0,94)
speedBox.PlaceholderText = tostring(DEFAULT_SPEED)
speedBox.Text = ""

local whitelistToggle = Instance.new("TextButton", frame)
whitelistToggle.Size = UDim2.new(0,150,0,30)
whitelistToggle.Position = UDim2.new(0,10,0,124)
whitelistToggle.Text = "Whitelist: OFF"
whitelistToggle.Font = Enum.Font.Gotham
whitelistToggle.TextSize = 14
whitelistToggle.BackgroundColor3 = Color3.fromRGB(80,30,120)
whitelistToggle.TextColor3 = Color3.fromRGB(255,255,255)

local startBtn = Instance.new("TextButton", frame)
startBtn.Size = UDim2.new(0,140,0,36)
startBtn.Position = UDim2.new(0,10,0,164)
startBtn.Text = "Start Magnet"
startBtn.Font = Enum.Font.Gotham
startBtn.TextSize = 14
startBtn.BackgroundColor3 = Color3.fromRGB(0,120,40)
startBtn.TextColor3 = Color3.fromRGB(255,255,255)

local stopBtn = Instance.new("TextButton", frame)
stopBtn.Size = UDim2.new(0,140,0,36)
stopBtn.Position = UDim2.new(0,150,0,164)
stopBtn.Text = "Stop"
stopBtn.Font = Enum.Font.Gotham
stopBtn.TextSize = 14
stopBtn.BackgroundColor3 = Color3.fromRGB(120,40,40)
stopBtn.TextColor3 = Color3.fromRGB(255,255,255)

-- hide icon
local icon = Instance.new("TextButton", screen)
icon.Size = UDim2.new(0,48,0,48)
icon.Position = UDim2.new(0,12,0,120)
icon.BackgroundColor3 = Color3.fromRGB(35,0,45)
icon.Text = "🔮"
icon.Visible = false
icon.Active = true
icon.Draggable = true

-- styling
for _,b in pairs({startBtn, stopBtn, whitelistToggle}) do
    b.Font = Enum.Font.Gotham
    b.TextColor3 = Color3.fromRGB(255,255,255)
end

-- ===== MAGNET LOGIC =====
local active = false
local radius = DEFAULT_RADIUS
local speed = DEFAULT_SPEED

local tracked = {} -- set of parts being lerped { [part]=true }

local lastScan = 0
local scanAcc = 0

local function safeIsDescendantOfPlayers(part)
    if part == nil then return false end
    local pl = Players:GetPlayers()
    for _,p in ipairs(pl) do
        if p.Character and part:IsDescendantOf(p.Character) then return true end
    end
    return false
end

local function scanAndTrack()
    refreshRefs = function() end
    if not hrp then return end
    local hrpPos = hrp.Position
    local found = 0
    for _,obj in ipairs(workspace:GetDescendants()) do
        if found >= MAX_PARTS_PER_TICK then break end
        if obj:IsA("BasePart") and obj.Parent ~= nil then
            if isProtected(obj) then goto cont end
            if not isWhitelisted(obj) then goto cont end
            if safeIsDescendantOfPlayers(obj) then goto cont end
            local d = (obj.Position - hrpPos).Magnitude
            if d <= radius then
                tracked[obj] = true
                found = found + 1
            end
        end
        ::cont::
    end
end

-- move tracked parts toward HRP each tick
local function tickMove(dt)
    if not hrp then return end
    local hrpPos = hrp.Position
    local toRemove = {}
    local moved = 0
    for part,_ in pairs(tracked) do
        if moved >= MAX_PARTS_PER_TICK then break end
        if not part or not part.Parent then
            tracked[part] = nil
        else
            -- compute target slightly above root so parts don't clip
            local target = hrpPos + Vector3.new(0, 2, 0)
            local current = part.Position
            -- lerp towards target using speed and dt
            local alpha = math.clamp(speed * dt, 0, 1)
            local newPos = current:Lerp(target, alpha)
            -- preserve orientation
            local rot = part.CFrame - part.CFrame.Position
            pcall(function() part.CFrame = CFrame.new(newPos) * rot end)
            moved = moved + 1
            -- if very close to HRP, mark remove (simulate "picked up")
            if (part.Position - target).Magnitude < 1.2 then
                -- optionally hide or mark for removal from tracked set
                tracked[part] = nil
                -- optional: make part invisible locally to simulate pickup
                pcall(function() part.LocalTransparencyModifier = 1 end)
            end
        end
    end
end

-- heartbeat loop
local heartbeatConn
local function startMagnet()
    if active then return end
    refreshRefs = function() end
    if not player.Character then infoLabel.Text = "No character"; return end
    hrp = player.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then infoLabel.Text = "No HRP"; return end
    active = true
    infoLabel.Text = "Magnet: Active"
    tracked = {}
    lastScan = 0
    scanAcc = 0
    heartbeatConn = RunService.Heartbeat:Connect(function(dt)
        if not active then return end
        scanAcc = scanAcc + dt
        if scanAcc >= SCAN_INTERVAL then
            scanAcc = 0
            scanAndTrack()
        end
        tickMove(dt)
    end)
end

local function stopMagnet()
    if not active then return end
    active = false
    if heartbeatConn then
        heartbeatConn:Disconnect()
        heartbeatConn = nil
    end
    -- restore any transparency changes
    for part,_ in pairs(tracked) do
        if part and part.Parent then
            pcall(function() part.LocalTransparencyModifier = 0 end)
        end
    end
    tracked = {}
    infoLabel.Text = "Magnet: Stopped"
end

-- ===== UI events =====
startBtn.MouseButton1Click:Connect(function()
    local r = tonumber(radiusBox.Text)
    if r and r > 0 then radius = math.clamp(r, 1, 1000); radiusLabel.Text = "Radius: "..tostring(radius) end
    local s = tonumber(speedBox.Text)
    if s and s > 0 then speed = math.clamp(s, 0.5, 60); speedLabel.Text = "Speed: "..tostring(speed) end
    startMagnet()
end)

stopBtn.MouseButton1Click:Connect(function()
    stopMagnet()
end)

whitelistToggle.MouseButton1Click:Connect(function()
    whitelistMode = not whitelistMode
    whitelistToggle.Text = whitelistMode and "Whitelist: ON" or "Whitelist: OFF"
end)

hideBtn.MouseButton1Click:Connect(function()
    frame.Visible = false
    icon.Visible = true
end)
icon.MouseButton1Click:Connect(function()
    frame.Visible = true
    icon.Visible = false
end)
closeBtn.MouseButton1Click:Connect(function()
    stopMagnet()
    screen:Destroy()
end)

-- safety: stop on respawn
player.CharacterAdded:Connect(function()
    stopMagnet()
    wait(0.4)
end)

-- stop on manual input (optional)
UserInputService.InputBegan:Connect(function(inp, processed)
    if processed then return end
    -- optional: if player moves manually, keep magnet running (up to you). We won't stop.
end)

-- initial
infoLabel.Text = "Idle — Points: 0 | Radius: "..tostring(DEFAULT_RADIUS)
radiusLabel.Text = "Radius: "..tostring(DEFAULT_RADIUS)
speedLabel.Text = "Speed: "..tostring(DEFAULT_SPEED)

print("MountBingung Magnet loaded (client-only). Note: visible only on your client.")
