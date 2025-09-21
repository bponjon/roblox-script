-- Mobile Self-Protect (improved)
-- LocalScript -> StarterPlayer > StarterPlayerScripts

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local CHARACTER = nil

-- CONFIG
local CHECK_INTERVAL = 0.14            -- deteksi ringan untuk HP
local SAFE_DISTANCE_THRESHOLD = 10     -- teleport > 10 studs dicurigai
local VELOCITY_THRESHOLD = 160         -- threshold kecepatan (studs/s)
local REPAIR_COOLDOWN = 0.7            -- jeda minimal antar repair
local MAX_REPAIRS_PER_MIN = 30

-- STATE
local lastSafeCFrame = nil
local lastSafeTime = 0
local lastCheck = 0
local repairsThisMinute = 0
local lastMinuteReset = tick()
local lastRepair = 0
local protectionEnabled = false

-- GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SelfProtectGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame", screenGui)
frame.AnchorPoint = Vector2.new(0, 1)
frame.Position = UDim2.new(0.02, 0, 0.98, 0)
frame.Size = UDim2.new(0, 170, 0, 90)
frame.BackgroundTransparency = 0.35
frame.BackgroundColor3 = Color3.fromRGB(18,18,18)
frame.BorderSizePixel = 0

local toggleBtn = Instance.new("TextButton", frame)
toggleBtn.Size = UDim2.new(1, -14, 0, 40)
toggleBtn.Position = UDim2.new(0, 7, 0, 8)
toggleBtn.Text = "Protect: OFF"
toggleBtn.Font = Enum.Font.SourceSansBold
toggleBtn.TextSize = 16
toggleBtn.TextColor3 = Color3.new(1,1,1)
toggleBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)

local repairBtn = Instance.new("TextButton", frame)
repairBtn.Size = UDim2.new(1, -14, 0, 30)
repairBtn.Position = UDim2.new(0, 7, 0, 50)
repairBtn.Text = "Repair Now"
repairBtn.Font = Enum.Font.SourceSans
repairBtn.TextSize = 14
repairBtn.TextColor3 = Color3.new(1,1,1)
repairBtn.BackgroundColor3 = Color3.fromRGB(70,70,180)

-- small toast helper
local function toast(msg, dur)
    dur = dur or 2
    local t = Instance.new("TextLabel", screenGui)
    t.Size = UDim2.new(0,220,0,30)
    t.Position = UDim2.new(0.02, 0, 0.85, -40)
    t.BackgroundTransparency = 0.3
    t.TextColor3 = Color3.new(1,1,1)
    t.Text = msg
    t.Font = Enum.Font.SourceSansBold
    t.TextSize = 16
    task.delay(dur, function() pcall(function() t:Destroy() end) end)
end

-- utility: remove known force objects
local function removeExternalForces(character)
    if not character then return end
    for _, part in ipairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            for _, child in ipairs(part:GetChildren()) do
                local cname = child.ClassName
                if cname == "BodyVelocity" or cname == "BodyForce" or cname == "BodyPosition"
                or cname == "BodyGyro" or cname == "BodyThrust" or cname == "VectorForce"
                or cname == "AlignPosition" or cname == "AlignOrientation" then
                    pcall(function() child:Destroy() end)
                end
            end
            pcall(function() part.Velocity = Vector3.new(0,0,0); part.RotVelocity = Vector3.new(0,0,0) end)
        end
    end
end

local function restoreHumanoid(humanoid)
    if not humanoid then return end
    pcall(function()
        humanoid.PlatformStand = false
        humanoid.AutoRotate = true
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall, true)
    end)
end

local function safeTeleportToRoot(rootPart, targetCFrame)
    if not rootPart or not targetCFrame then return end
    local ok = pcall(function()
        rootPart.CFrame = targetCFrame + Vector3.new(0,2,0)
    end)
    if not ok then
        pcall(function() rootPart.CFrame = rootPart.CFrame + Vector3.new(0,1,0) end)
    end
end

local function doRepair()
    if tick() - lastRepair < REPAIR_COOLDOWN then return end
    if tick() - lastMinuteReset >= 60 then repairsThisMinute = 0; lastMinuteReset = tick() end
    if repairsThisMinute >= MAX_REPAIRS_PER_MIN then return end
    repairsThisMinute = repairsThisMinute + 1
    lastRepair = tick()

    local char = player.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not root or not humanoid then return end

    removeExternalForces(char)
    pcall(function() root.Anchored = false end)
    pcall(function() root.Velocity = Vector3.new(0,0,0); root.RotVelocity = Vector3.new(0,0,0) end)
    restoreHumanoid(humanoid)

    -- teleport back to safe pos if exists AND not absurdly far
    if lastSafeCFrame then
        local dist = (root.Position - lastSafeCFrame.Position).Magnitude
        if dist > 120 then
            -- if safe pos is too far, just nudge up instead
            safeTeleportToRoot(root, CFrame.new(root.Position + Vector3.new(0,2,0)))
        else
            safeTeleportToRoot(root, lastSafeCFrame)
        end
        toast("Repaired ✓", 1.6)
    else
        -- no safe pos known: minor nudge to try to free
        safeTeleportToRoot(root, root.CFrame)
        toast("Repaired (no safe pos)", 1.6)
    end
end

-- update safe frame only when player intentionally moves or stands on ground
local function updateSafeFrame()
    local char = player.Character
    if not char then return end
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    if not humanoid or not root then return end

    if humanoid.MoveDirection.Magnitude > 0.12 then
        lastSafeCFrame = root.CFrame
        lastSafeTime = tick()
    else
        if humanoid.FloorMaterial ~= Enum.Material.Air then
            lastSafeCFrame = root.CFrame
            lastSafeTime = tick()
        end
    end
end

-- Lightweight monitor (Heartbeat)
local function startMonitor()
    RunService.Heartbeat:Connect(function(dt)
        if not protectionEnabled then return end
        if not player.Character or not player.Character.Parent then return end
        if tick() - lastCheck < CHECK_INTERVAL then return end
        lastCheck = tick()
        if tick() - lastMinuteReset >= 60 then repairsThisMinute = 0; lastMinuteReset = tick() end

        local char = player.Character
        local root = char:FindFirstChild("HumanoidRootPart")
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if not root or not humanoid then return end

        updateSafeFrame()

        -- anchored / platformstand
        if root.Anchored or humanoid.PlatformStand == true then
            doRepair(); return
        end

        -- detect force objects quickly
        for _, d in ipairs(char:GetDescendants()) do
            if d:IsA("BodyVelocity") or d:IsA("BodyForce") or d:IsA("VectorForce")
            or d:IsA("AlignPosition") or d:IsA("AlignOrientation") then
                doRepair(); return
            end
        end

        -- abnormal velocity
        if root.Velocity.Magnitude > VELOCITY_THRESHOLD then
            doRepair(); return
        end

        -- sudden teleport w.r.t last safe pos
        if lastSafeCFrame then
            local dist = (root.Position - lastSafeCFrame.Position).Magnitude
            if dist > SAFE_DISTANCE_THRESHOLD then
                doRepair(); return
            end
        end
    end)
end

-- GUI events
toggleBtn.MouseButton1Click:Connect(function()
    protectionEnabled = not protectionEnabled
    if protectionEnabled then
        toggleBtn.Text = "Protect: ON"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 190, 0)
        -- set safe pos if possible
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            lastSafeCFrame = player.Character.HumanoidRootPart.CFrame
            lastSafeTime = tick()
        end
        toast("Protection enabled",1.3)
    else
        toggleBtn.Text = "Protect: OFF"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(200, 20, 20)
        toast("Protection disabled",1.3)
    end
end)

repairBtn.MouseButton1Click:Connect(function()
    doRepair()
end)

player.CharacterAdded:Connect(function(char)
    lastSafeCFrame = nil
    lastSafeTime = tick()
    task.wait(0.18)
    local r = char:FindFirstChild("HumanoidRootPart")
    if r then lastSafeCFrame = r.CFrame end
end)

-- init
startMonitor()
print("[MobileSelfProtect] improved running.")
