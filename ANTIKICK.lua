-- ULTIMATE EXPLOIT - STEALTH MODE (ANTI-KICK)
-- Low profile, slow scan, anti-detection
-- Bahasa Indonesia

task.wait(3) -- Delay lebih lama untuk avoid detection

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui", 10)

if not playerGui then return end

-- Hapus GUI lama
pcall(function()
    if playerGui:FindFirstChild("StealthExploit") then
        playerGui.StealthExploit:Destroy()
        task.wait(1)
    end
end)

-- ============================================
-- STEALTH NOTIFICATION (Silent mode)
-- ============================================
local silentMode = false -- Set true untuk hide notif

local function notif(msg, warna)
    if silentMode then return end
    
    local icon = warna == "hijau" and "✅" or (warna == "merah" and "❌" or "⚡")
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Stealth";
            Text = icon .. " " .. msg;
            Duration = 2;
        })
    end)
    print("[Stealth]", msg)
end

local mouse = player:GetMouse()

-- ============================================
-- STEALTH REMOTE SCAN (Slow & Safe)
-- ============================================
local remotes = {}

local function stealthScan()
    remotes = {}
    notif("Scan pelan-pelan...", nil)
    
    -- Only scan safe locations
    local safePlaces = {
        ReplicatedStorage,
        Workspace
    }
    
    for _, place in pairs(safePlaces) do
        pcall(function()
            for _, obj in pairs(place:GetDescendants()) do
                if obj:IsA("RemoteEvent") then
                    table.insert(remotes, obj)
                    task.wait(0.01) -- Slow down to avoid detection
                end
            end
        end)
    end
    
    print("=== SCAN SELESAI ===")
    print("Total remotes:", #remotes)
    print("====================")
    
    notif("Ditemukan " .. #remotes .. " remotes", "hijau")
    return #remotes
end

-- ============================================
-- STEALTH EXPLOIT (Rate Limited)
-- ============================================

-- Rate limiter
local lastExploit = 0
local RATE_LIMIT = 0.5 -- 0.5 detik antara exploit

local function canExploit()
    local now = tick()
    if now - lastExploit < RATE_LIMIT then
        return false
    end
    lastExploit = now
    return true
end

-- Method 1: Target Hover (Stealth)
local function stealthHover()
    if not canExploit() then
        notif("Tunggu cooldown...", "merah")
        return
    end
    
    if not mouse.Target then
        notif("Tidak ada target!", "merah")
        return
    end
    
    local target = mouse.Target
    notif("Target: " .. target.Name, nil)
    
    if #remotes == 0 then
        stealthScan()
        task.wait(1)
    end
    
    -- Only use top 5 remotes (most likely to work)
    local count = 0
    for i = 1, math.min(5, #remotes) do
        local remote = remotes[i]
        pcall(function()
            remote:FireServer("Delete", target)
            remote:FireServer({Action = "Delete", Target = target})
            task.wait(0.1) -- Delay between attempts
        end)
        count = count + 1
    end
    
    notif("Sent " .. count .. " commands (stealth)", "hijau")
end

-- Method 2: Manual Input (Safe)
local function stealthDelete(partName)
    if not canExploit() then
        notif("Tunggu cooldown...", "merah")
        return
    end
    
    if partName == "" then
        notif("Masukkan nama!", "merah")
        return
    end
    
    notif("Mencari: " .. partName, nil)
    
    if #remotes == 0 then
        stealthScan()
        task.wait(1)
    end
    
    -- Find only first 3 matches
    local targets = {}
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Name:lower():find(partName:lower()) then
            table.insert(targets, obj)
            if #targets >= 3 then break end
        end
    end
    
    if #targets == 0 then
        notif("Part tidak ditemukan!", "merah")
        return
    end
    
    notif("Ditemukan " .. #targets .. " targets", nil)
    
    -- Slow exploit
    for _, target in ipairs(targets) do
        for i = 1, math.min(3, #remotes) do
            pcall(function()
                remotes[i]:FireServer("Delete", target)
                remotes[i]:FireServer({Action = "Delete", Target = target})
            end)
            task.wait(0.2) -- Slow down
        end
    end
    
    notif("Selesai! Cek hasil", "hijau")
end

-- Method 3: Find Checkpoints (Safe scan)
local function findCheckpoints()
    notif("Mencari checkpoint...", nil)
    
    local found = {}
    local count = 0
    
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            local name = obj.Name:lower()
            if name:find("checkpoint") or name:find("cp") then
                table.insert(found, obj.Name)
                count = count + 1
                if count >= 10 then break end -- Limit scan
            end
        end
        
        -- Slow scan to avoid detection
        if count % 100 == 0 then
            task.wait(0.01)
        end
    end
    
    print("=== CHECKPOINT ===")
    if #found > 0 then
        for i, name in ipairs(found) do
            print(i .. ".", name)
        end
    else
        print("Tidak ada checkpoint!")
    end
    print("==================")
    
    notif("Ditemukan " .. #found .. " CP (F9)", "hijau")
end

-- Method 4: List Players (Safe)
local function listPlayers()
    print("=== PLAYERS ===")
    for i, plr in pairs(Players:GetPlayers()) do
        print(i .. ".", plr.Name)
    end
    print("Total:", #Players:GetPlayers())
    print("===============")
    
    notif("List player (F9)", "hijau")
end

-- ============================================
-- CREATE STEALTH GUI (Smaller, less obvious)
-- ============================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "StealthExploit"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = playerGui

-- Smaller frame
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 360, 0, 500)
MainFrame.Position = UDim2.new(0.5, -180, 0.5, -250)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.BackgroundTransparency = 0.1 -- Slightly transparent
MainFrame.Parent = ScreenGui

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 12)
Corner.Parent = MainFrame

-- Simple header
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 45)
Header.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Header.BorderSizePixel = 0
Header.Parent = MainFrame

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 12)
HeaderCorner.Parent = Header

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -60, 1, 0)
Title.Position = UDim2.new(0, 12, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "🔇 Stealth Mode"
Title.TextColor3 = Color3.fromRGB(200, 200, 200)
Title.Font = Enum.Font.Gotham
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 40, 0, 40)
CloseBtn.Position = UDim2.new(1, -43, 0, 2.5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 18
CloseBtn.Parent = Header

local CloseBtnCorner = Instance.new("UICorner")
CloseBtnCorner.CornerRadius = UDim.new(0, 8)
CloseBtnCorner.Parent = CloseBtn

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Content
local Content = Instance.new("ScrollingFrame")
Content.Size = UDim2.new(1, -20, 1, -55)
Content.Position = UDim2.new(0, 10, 0, 50)
Content.BackgroundTransparency = 1
Content.ScrollBarThickness = 6
Content.CanvasSize = UDim2.new(0, 0, 0, 800)
Content.Parent = MainFrame

-- GUI Builders (Simpler)
local yPos = 10

local function makeLabel(text)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -10, 0, 32)
    label.Position = UDim2.new(0, 5, 0, yPos)
    label.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    label.Text = text
    label.TextColor3 = Color3.fromRGB(220, 220, 220)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 14
    label.Parent = Content
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = label
    
    yPos = yPos + 38
end

local function makeButton(text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 44)
    btn.Position = UDim2.new(0, 5, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(220, 220, 220)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 13
    btn.TextWrapped = true
    btn.Parent = Content
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn
    
    btn.MouseButton1Click:Connect(function()
        pcall(callback)
    end)
    
    yPos = yPos + 50
    return btn
end

local function makeTextBox(placeholder)
    local box = Instance.new("TextBox")
    box.Size = UDim2.new(1, -10, 0, 40)
    box.Position = UDim2.new(0, 5, 0, yPos)
    box.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    box.Text = ""
    box.PlaceholderText = placeholder
    box.TextColor3 = Color3.fromRGB(220, 220, 220)
    box.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
    box.Font = Enum.Font.Gotham
    box.TextSize = 13
    box.Parent = Content
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = box
    
    yPos = yPos + 46
    return box
end

-- Build Simple GUI
makeLabel("📡 Info")

makeButton("Scan Remotes (Pelan)", function()
    stealthScan()
end)

makeButton("List Players (F9)", function()
    listPlayers()
end)

makeLabel("🎯 Hover Target")

makeButton("Delete Part (Hover Mouse)", function()
    stealthHover()
end)

makeLabel("🔎 Manual Delete")

makeButton("Cari Checkpoint (F9)", function()
    findCheckpoints()
end)

local inputBox = makeTextBox("Nama part...")

makeButton("Delete by Name", function()
    stealthDelete(inputBox.Text)
end)

-- Toggle Silent Mode
yPos = yPos + 10
local silentBtn = makeButton("Silent Mode: OFF", function()
    silentMode = not silentMode
    silentBtn.Text = silentMode and "Silent Mode: ON" or "Silent Mode: OFF"
    notif("Silent mode " .. (silentMode and "ON" or "OFF"), "hijau")
end)

-- Info
yPos = yPos + 10
local info = Instance.new("TextLabel")
info.Size = UDim2.new(1, -10, 0, 180)
info.Position = UDim2.new(0, 5, 0, yPos)
info.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
info.TextColor3 = Color3.fromRGB(200, 200, 200)
info.Font = Enum.Font.Gotham
info.TextSize = 11
info.TextWrapped = true
info.TextYAlignment = Enum.TextYAlignment.Top
info.Text = [[🔇 STEALTH MODE - ANTI-KICK

FITUR:
• Slow scan (avoid detection)
• Rate limited (cooldown 0.5s)
• Only top remotes (safe)
• Limited targets (max 3)
• Silent mode (hide notif)

CARA PAKAI:
1. Scan remotes dulu
2. Hover part → Delete
3. Atau manual input nama
4. Tunggu cooldown!

⚠️ TIPS:
• Jangan spam!
• Tunggu cooldown!
• Pakai silent mode kalau perlu

PlaceId: ]] .. game.PlaceId
info.Parent = Content

local infoPadding = Instance.new("UIPadding")
infoPadding.PaddingTop = UDim.new(0, 10)
infoPadding.PaddingLeft = UDim.new(0, 10)
infoPadding.PaddingRight = UDim.new(0, 10)
infoPadding.Parent = info

local infoCorner = Instance.new("UICorner")
infoCorner.CornerRadius = UDim.new(0, 8)
infoCorner.Parent = info

Content.CanvasSize = UDim2.new(0, 0, 0, yPos + 200)

-- Slow start (avoid instant detection)
task.spawn(function()
    task.wait(2)
    notif("Stealth mode ready", "hijau")
    task.wait(1)
    stealthScan()
end)

print("================================")
print("STEALTH MODE ACTIVE")
print("Low profile, anti-detection")
print("PlaceId:", game.PlaceId)
print("================================")
