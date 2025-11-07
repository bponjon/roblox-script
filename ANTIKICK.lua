-- ULTIMATE EXPLOIT - STEALTH MODE (FIXED)
-- All bugs fixed

task.wait(2)

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui", 10)

if not playerGui then return end

if playerGui:FindFirstChild("StealthExploit") then
    playerGui.StealthExploit:Destroy()
    task.wait(0.5)
end

-- Settings
local Settings = {
    DelayPerRemote = 0.05,
    MaxRemotesPerBatch = 5,
    SafeMode = true,
}

-- Notifikasi
local function notif(msg, warna)
    local icon = warna == "hijau" and "✅" or (warna == "merah" and "❌" or "⚡")
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Stealth Exploit";
            Text = icon .. " " .. msg;
            Duration = 3;
        })
    end)
    print("[Stealth]", msg)
end

local mouse = player:GetMouse()
local selectedPart = nil

mouse.Button1Down:Connect(function()
    if mouse.Target and mouse.Target:IsA("BasePart") then
        selectedPart = mouse.Target
        notif("Dipilih: " .. selectedPart.Name, "hijau")
    end
end)

-- Smart Remote Scanner
local importantRemotes = {}
local allRemotes = {}

local function scanSmartRemotes()
    importantRemotes = {}
    allRemotes = {}
    
    notif("Scanning remotes...", nil)
    
    for _, obj in pairs(ReplicatedStorage:GetDescendants()) do
        if obj:IsA("RemoteEvent") then
            table.insert(allRemotes, obj)
            
            local name = obj.Name:lower()
            if name:find("delete") or name:find("remove") or name:find("destroy")
                or name:find("teleport") or name:find("tp") or name:find("move")
                or name:find("kill") or name:find("damage") or name:find("health")
                or name:find("checkpoint") or name:find("cp") 
                or name:find("equip") or name:find("donate") or name:find("shop") then
                table.insert(importantRemotes, obj)
            end
        end
    end
    
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("RemoteEvent") then
            table.insert(allRemotes, obj)
        end
    end
    
    print("=== SCAN RESULT ===")
    print("Total remotes:", #allRemotes)
    print("Important remotes:", #importantRemotes)
    print("===================")
    
    notif("Found " .. #allRemotes .. " remotes", "hijau")
    return #importantRemotes
end

-- Safe Fire Server
local lastFireTime = 0

local function safeFireServer(remote, ...)
    local now = tick()
    local timeSinceLastFire = now - lastFireTime
    
    if Settings.SafeMode and timeSinceLastFire < Settings.DelayPerRemote then
        task.wait(Settings.DelayPerRemote - timeSinceLastFire)
    end
    
    pcall(function()
        remote:FireServer(...)
    end)
    
    lastFireTime = tick()
end

-- Delete Selected Part
local function deleteSelectedPart()
    if not selectedPart then
        notif("Belum pilih part!", "merah")
        return
    end
    
    notif("Menghapus: " .. selectedPart.Name, nil)
    
    if #importantRemotes == 0 then
        scanSmartRemotes()
        task.wait(0.5)
    end
    
    local remotesToUse = #importantRemotes > 0 and importantRemotes or allRemotes
    local count = 0
    
    for i, remote in ipairs(remotesToUse) do
        if i > Settings.MaxRemotesPerBatch then break end
        
        safeFireServer(remote, "Delete", selectedPart)
        safeFireServer(remote, "Remove", selectedPart)
        safeFireServer(remote, {Action = "Delete", Target = selectedPart})
        count = count + 3
        
        task.wait(0.1)
    end
    
    notif("Sent " .. count .. " commands", "hijau")
end

-- Delete By Name
local function deleteByName(partName)
    if partName == "" then
        notif("Masukkan nama part!", "merah")
        return
    end
    
    notif("Mencari: " .. partName, nil)
    
    local targets = {}
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Name:lower():find(partName:lower()) then
            table.insert(targets, obj)
            if #targets >= 10 then break end
        end
    end
    
    if #targets == 0 then
        notif("Part tidak ditemukan!", "merah")
        return
    end
    
    notif("Ditemukan " .. #targets .. " parts", nil)
    
    if #importantRemotes == 0 then
        scanSmartRemotes()
        task.wait(0.5)
    end
    
    local remotesToUse = #importantRemotes > 0 and importantRemotes or allRemotes
    local count = 0
    
    for _, target in ipairs(targets) do
        for i, remote in ipairs(remotesToUse) do
            if i > Settings.MaxRemotesPerBatch then break end
            
            safeFireServer(remote, "Delete", target)
            safeFireServer(remote, {Action = "Delete", Target = target})
            count = count + 2
        end
        task.wait(0.2)
    end
    
    notif("Sent " .. count .. " commands!", "hijau")
end

-- Teleport To Void
local function teleportToVoid(target)
    if not target then
        notif("Tidak ada target!", "merah")
        return
    end
    
    notif("TP to void: " .. target.Name, nil)
    
    if #importantRemotes == 0 then
        scanSmartRemotes()
        task.wait(0.5)
    end
    
    local remotesToUse = #importantRemotes > 0 and importantRemotes or allRemotes
    local voidPos = Vector3.new(0, -999999, 0)
    local count = 0
    
    for i, remote in ipairs(remotesToUse) do
        if i > Settings.MaxRemotesPerBatch then break end
        
        safeFireServer(remote, "Teleport", target, voidPos)
        safeFireServer(remote, "MoveTo", target, voidPos)
        safeFireServer(remote, {Action = "TP", Target = target, Position = voidPos})
        count = count + 3
        
        task.wait(0.1)
    end
    
    notif("Sent " .. count .. " TP commands!", "hijau")
end

-- Target Player
local function targetPlayer(playerName)
    if playerName == "" then
        notif("Masukkan nama player!", "merah")
        return
    end
    
    local targetPlayer = Players:FindFirstChild(playerName)
    
    if not targetPlayer then
        for _, plr in pairs(Players:GetPlayers()) do
            if plr.Name:lower():find(playerName:lower()) then
                targetPlayer = plr
                break
            end
        end
    end
    
    if not targetPlayer then
        notif("Player tidak ditemukan!", "merah")
        return
    end
    
    if not targetPlayer.Character or not targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
        notif("Player belum spawn!", "merah")
        return
    end
    
    notif("Target: " .. targetPlayer.Name, nil)
    
    if #importantRemotes == 0 then
        scanSmartRemotes()
        task.wait(0.5)
    end
    
    local remotesToUse = #importantRemotes > 0 and importantRemotes or allRemotes
    local voidPos = Vector3.new(0, -999999, 0)
    local count = 0
    
    for i, remote in ipairs(remotesToUse) do
        if i > Settings.MaxRemotesPerBatch then break end
        
        safeFireServer(remote, "Teleport", targetPlayer, voidPos)
        safeFireServer(remote, "Kill", targetPlayer)
        safeFireServer(remote, {Action = "Kill", Player = targetPlayer})
        count = count + 3
        
        task.wait(0.15)
    end
    
    notif("Sent " .. count .. " commands", "hijau")
end

-- Search Checkpoints
local function searchCheckpoints()
    notif("Mencari checkpoints...", nil)
    
    local found = {}
    
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            local name = obj.Name:lower()
            if name:find("checkpoint") or name:find("cp") or name:find("check") 
                or name:find("stage") or name:find("level") then
                table.insert(found, obj.Name)
            end
        end
    end
    
    print("=== CHECKPOINTS ===")
    if #found > 0 then
        for i, name in ipairs(found) do
            if i <= 30 then
                print(i .. ".", name)
            end
        end
        notif("Found " .. #found .. " checkpoints", "hijau")
    else
        notif("No checkpoints found!", "merah")
    end
    print("===================")
end

-- List Players
local function listPlayers()
    print("=== PLAYERS ===")
    for i, plr in pairs(Players:GetPlayers()) do
        print(i .. ".", plr.Name)
    end
    print("Total:", #Players:GetPlayers())
    print("===============")
    notif("Player list in console (F9)", "hijau")
end

-- Toggle Safe Mode
local safeModeBtn

local function toggleSafeMode()
    Settings.SafeMode = not Settings.SafeMode
    local status = Settings.SafeMode and "ON" or "OFF"
    notif("Safe Mode: " .. status, "hijau")
    if safeModeBtn then
        safeModeBtn.Text = "🛡️ Safe Mode: " .. status
    end
end

-- Create GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "StealthExploit"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = playerGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 400, 0, 700)
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -350)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 15)
Corner.Parent = MainFrame

local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 55)
Header.BackgroundColor3 = Color3.fromRGB(0, 150, 100)
Header.BorderSizePixel = 0
Header.Parent = MainFrame

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 15)
HeaderCorner.Parent = Header

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -70, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "🥷 STEALTH EXPLOIT"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 50, 0, 50)
CloseBtn.Position = UDim2.new(1, -53, 0, 2.5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 24
CloseBtn.Parent = Header

local CloseBtnCorner = Instance.new("UICorner")
CloseBtnCorner.CornerRadius = UDim.new(0, 12)
CloseBtnCorner.Parent = CloseBtn

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

local Content = Instance.new("ScrollingFrame")
Content.Size = UDim2.new(1, -24, 1, -70)
Content.Position = UDim2.new(0, 12, 0, 60)
Content.BackgroundTransparency = 1
Content.ScrollBarThickness = 10
Content.CanvasSize = UDim2.new(0, 0, 0, 1600)
Content.Parent = MainFrame

local yPos = 10

local function makeLabel(text, color)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -10, 0, 40)
    label.Position = UDim2.new(0, 5, 0, yPos)
    label.BackgroundColor3 = color
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 16
    label.Parent = Content
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = label
    
    yPos = yPos + 46
end

local function makeButton(text, color, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 52)
    btn.Position = UDim2.new(0, 5, 0, yPos)
    btn.BackgroundColor3 = color
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 15
    btn.TextWrapped = true
    btn.Parent = Content
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = btn
    
    btn.MouseButton1Click:Connect(function()
        pcall(callback)
    end)
    
    yPos = yPos + 58
    return btn
end

local function makeTextBox(placeholder)
    local box = Instance.new("TextBox")
    box.Size = UDim2.new(1, -10, 0, 48)
    box.Position = UDim2.new(0, 5, 0, yPos)
    box.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    box.Text = ""
    box.PlaceholderText = placeholder
    box.TextColor3 = Color3.fromRGB(255, 255, 255)
    box.PlaceholderColor3 = Color3.fromRGB(140, 140, 140)
    box.Font = Enum.Font.Gotham
    box.TextSize = 15
    box.Parent = Content
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = box
    
    yPos = yPos + 54
    return box
end

-- Build GUI
makeLabel("⚙️ SETTINGS", Color3.fromRGB(100, 100, 100))

safeModeBtn = makeButton("🛡️ Safe Mode: ON", Color3.fromRGB(120, 120, 120), function()
    toggleSafeMode()
end)

makeLabel("🔍 SCAN", Color3.fromRGB(0, 120, 200))

makeButton("📡 Scan Remotes", Color3.fromRGB(0, 140, 220), function()
    scanSmartRemotes()
end)

makeButton("🔎 Search Checkpoints", Color3.fromRGB(0, 160, 200), function()
    searchCheckpoints()
end)

makeButton("📋 List Players", Color3.fromRGB(100, 100, 200), function()
    listPlayers()
end)

makeLabel("🎯 CLICK & DELETE", Color3.fromRGB(255, 140, 0))

makeButton("🖱️ Delete Clicked Part", Color3.fromRGB(255, 120, 0), function()
    deleteSelectedPart()
end)

makeButton("📍 TP to Void", Color3.fromRGB(255, 100, 50), function()
    if selectedPart then
        teleportToVoid(selectedPart)
    else
        notif("Klik part dulu!", "merah")
    end
end)

makeLabel("🔎 DELETE BY NAME", Color3.fromRGB(0, 180, 120))

local partBox = makeTextBox("Part name (Checkpoint, CP1)")

makeButton("🗑️ Delete by Name", Color3.fromRGB(200, 80, 80), function()
    deleteByName(partBox.Text)
end)

makeLabel("😈 TARGET PLAYER", Color3.fromRGB(150, 0, 200))

local playerBox = makeTextBox("Player name")

makeButton("🎯 TP Player to Void", Color3.fromRGB(180, 0, 180), function()
    targetPlayer(playerBox.Text)
end)

-- Info
yPos = yPos + 10
local info = Instance.new("TextLabel")
info.Size = UDim2.new(1, -10, 0, 260)
info.Position = UDim2.new(0, 5, 0, yPos)
info.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
info.TextColor3 = Color3.fromRGB(230, 230, 230)
info.Font = Enum.Font.Gotham
info.TextSize = 13
info.TextWrapped = true
info.TextYAlignment = Enum.TextYAlignment.Top
info.Text = [[🥷 STEALTH MODE

✅ FEATURES:
• Delete parts (click/name)
• TP to void
• Target players
• Safe mode

⚡ STEALTH:
• Delay 0.05s per remote
• Max 5 remotes/batch
• Smart filtering

📋 HOW TO USE:
1. Scan Remotes
2. Click part OR type name
3. Choose action
4. Wait completion

🎯 TARGET:
• Type player name
• TP/Kill player

⚠️ TIPS:
• Don't spam!
• Use safe mode
• Wait for finish

Status: Ready 🛡️]]
info.Parent = Content

local infoPadding = Instance.new("UIPadding")
infoPadding.PaddingTop = UDim.new(0, 12)
infoPadding.PaddingLeft = UDim.new(0, 12)
infoPadding.PaddingRight = UDim.new(0, 12)
infoPadding.PaddingBottom = UDim.new(0, 12)
infoPadding.Parent = info

local infoCorner = Instance.new("UICorner")
infoCorner.CornerRadius = UDim.new(0, 10)
infoCorner.Parent = info

Content.CanvasSize = UDim2.new(0, 0, 0, yPos + 280)

-- Auto scan
task.spawn(function()
    task.wait(1.5)
    scanSmartRemotes()
    notif("Stealth mode ready!", "hijau")
end)

notif("Loading complete! 🥷", "hijau")
print("=== STEALTH EXPLOIT ===")
print("Safe Mode: ON")
print("Ready to use!")
print("=======================")
