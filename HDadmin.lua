-- HD ADMIN EXPLOIT - MOBILE OPTIMIZED
-- Khusus untuk game dengan HD Admin system
-- BAHASA INDONESIA

task.wait(2)

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui", 10)

if not playerGui then
    warn("PlayerGui tidak ditemukan!")
    return
end

-- Hapus GUI lama jika ada
if playerGui:FindFirstChild("HDAdminExploitGUI") then
    playerGui.HDAdminExploitGUI:Destroy()
    task.wait(0.5)
end

-- Fungsi notifikasi
local function notif(msg)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "HD Admin Exploit";
            Text = msg;
            Duration = 3;
        })
    end)
    print("[HD Admin Exploit]", msg)
end

-- Cari HD Admin Remotes
local HDAdmin = ReplicatedStorage:FindFirstChild("HDAdminHDClient")
if not HDAdmin then
    notif("❌ HD Admin tidak ditemukan!")
    return
end

local Signals = HDAdmin:FindFirstChild("Signals")
if not Signals then
    notif("❌ Signals tidak ditemukan!")
    return
end

-- Remote penting
local ExecuteClientCommand = Signals:FindFirstChild("ExecuteClientCommand")
local Message = Signals:FindFirstChild("Message")
local Hint = Signals:FindFirstChild("Hint")
local GlobalAnnouncement = Signals:FindFirstChild("GlobalAnnouncement")
local ReplicateEffect = Signals:FindFirstChild("ReplicateEffect")
local ForceChat = Signals:FindFirstChild("ForceChat")
local ShowCommands = Signals:FindFirstChild("ShowCommands")

notif("✅ HD Admin ditemukan!")

-- Fungsi untuk mendapatkan player lain
local function getPlayers()
    local playerList = {}
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player then
            table.insert(playerList, p.Name)
        end
    end
    return playerList
end

-- ============================================
-- FUNGSI EXPLOIT
-- ============================================

local function cobaKickPlayer(targetName)
    if not ExecuteClientCommand then
        notif("❌ Remote tidak tersedia!")
        return
    end
    
    notif("Mencoba kick: " .. targetName)
    
    pcall(function()
        ExecuteClientCommand:FireServer("kick", targetName)
        ExecuteClientCommand:FireServer(":kick " .. targetName)
        ExecuteClientCommand:FireServer({command = "kick", target = targetName})
    end)
end

local function cobaBanPlayer(targetName)
    if not ExecuteClientCommand then
        notif("❌ Remote tidak tersedia!")
        return
    end
    
    notif("Mencoba ban: " .. targetName)
    
    pcall(function()
        ExecuteClientCommand:FireServer("ban", targetName)
        ExecuteClientCommand:FireServer(":ban " .. targetName)
        ExecuteClientCommand:FireServer({command = "ban", target = targetName})
    end)
end

local function cobaTeleportPlayer(targetName, tujuan)
    if not ExecuteClientCommand then return end
    
    notif("Mencoba TP: " .. targetName .. " ke " .. tujuan)
    
    pcall(function()
        ExecuteClientCommand:FireServer("tp", targetName, tujuan)
        ExecuteClientCommand:FireServer(":tp " .. targetName .. " " .. tujuan)
        ExecuteClientCommand:FireServer({command = "tp", target = targetName, destination = tujuan})
    end)
end

local function cobaKillPlayer(targetName)
    if not ExecuteClientCommand then return end
    
    notif("Mencoba kill: " .. targetName)
    
    pcall(function()
        ExecuteClientCommand:FireServer("kill", targetName)
        ExecuteClientCommand:FireServer(":kill " .. targetName)
        ExecuteClientCommand:FireServer({command = "kill", target = targetName})
    end)
end

local function cobaGodMode(targetName)
    if not ExecuteClientCommand then return end
    
    notif("Mencoba god mode: " .. targetName)
    
    pcall(function()
        ExecuteClientCommand:FireServer("god", targetName)
        ExecuteClientCommand:FireServer(":god " .. targetName)
        ExecuteClientCommand:FireServer({command = "god", target = targetName})
    end)
end

local function cobaExplodePlayer(targetName)
    if not ExecuteClientCommand or not ReplicateEffect then return end
    
    notif("Mencoba explode: " .. targetName)
    
    pcall(function()
        ExecuteClientCommand:FireServer("explode", targetName)
        ExecuteClientCommand:FireServer(":explode " .. targetName)
        
        local target = Players:FindFirstChild(targetName)
        if target and target.Character then
            ReplicateEffect:FireServer("Explosion", target.Character.HumanoidRootPart.Position)
        end
    end)
end

local function cobaSpeedPlayer(targetName, speed)
    if not ExecuteClientCommand then return end
    
    notif("Mencoba ubah speed: " .. targetName)
    
    pcall(function()
        ExecuteClientCommand:FireServer("speed", targetName, speed)
        ExecuteClientCommand:FireServer(":speed " .. targetName .. " " .. speed)
        ExecuteClientCommand:FireServer({command = "speed", target = targetName, value = speed})
    end)
end

local function cobaFlyPlayer(targetName)
    if not ExecuteClientCommand then return end
    
    notif("Mencoba aktifkan fly: " .. targetName)
    
    pcall(function()
        ExecuteClientCommand:FireServer("fly", targetName)
        ExecuteClientCommand:FireServer(":fly " .. targetName)
        ExecuteClientCommand:FireServer({command = "fly", target = targetName})
    end)
end

local function kirimMessage(teks)
    if not Message then return end
    
    notif("Mengirim pesan...")
    
    pcall(function()
        Message:FireServer(teks)
        Message:FireServer({text = teks})
    end)
end

local function kirimHint(teks)
    if not Hint then return end
    
    notif("Mengirim hint...")
    
    pcall(function()
        Hint:FireServer(teks)
        Hint:FireServer({text = teks})
    end)
end

local function kirimAnnouncement(teks)
    if not GlobalAnnouncement then return end
    
    notif("Mengirim announcement...")
    
    pcall(function()
        GlobalAnnouncement:FireServer(teks)
        GlobalAnnouncement:FireServer({text = teks})
    end)
end

local function bukaAdminPanel()
    if not ShowCommands then return end
    
    notif("Mencoba buka admin panel...")
    
    pcall(function()
        ShowCommands:FireServer()
        ShowCommands:FireServer(true)
        ShowCommands:FireServer("show")
    end)
end

-- ============================================
-- BUAT GUI
-- ============================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "HDAdminExploitGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 360, 0, 550)
MainFrame.Position = UDim2.new(0.5, -180, 0.5, -275)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
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
Header.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
Header.BorderSizePixel = 0
Header.Parent = MainFrame

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 12)
HeaderCorner.Parent = Header

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -60, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "⚡ HD ADMIN EXPLOIT"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

-- Close Button
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 45, 0, 45)
CloseBtn.Position = UDim2.new(1, -48, 0, 2.5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(180, 30, 30)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 22
CloseBtn.Parent = Header

local CloseBtnCorner = Instance.new("UICorner")
CloseBtnCorner.CornerRadius = UDim.new(0, 10)
CloseBtnCorner.Parent = CloseBtn

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
    notif("GUI Ditutup")
end)

-- Content
local Content = Instance.new("ScrollingFrame")
Content.Size = UDim2.new(1, -20, 1, -60)
Content.Position = UDim2.new(0, 10, 0, 55)
Content.BackgroundTransparency = 1
Content.BorderSizePixel = 0
Content.ScrollBarThickness = 8
Content.CanvasSize = UDim2.new(0, 0, 0, 1400)
Content.Parent = MainFrame

local yPos = 10

-- Helper functions
local function buatLabel(teks)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -10, 0, 38)
    label.Position = UDim2.new(0, 5, 0, yPos)
    label.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    label.Text = teks
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 15
    label.Parent = Content
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = label
    
    yPos = yPos + 43
end

local function buatTombol(teks, warna, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 48)
    btn.Position = UDim2.new(0, 5, 0, yPos)
    btn.BackgroundColor3 = warna
    btn.Text = teks
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.TextWrapped = true
    btn.Parent = Content
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn
    
    btn.MouseButton1Click:Connect(function()
        local success, err = pcall(callback)
        if not success then
            notif("Error: " .. tostring(err))
        end
    end)
    
    yPos = yPos + 53
    return btn
end

local function buatTextBox(placeholder)
    local box = Instance.new("TextBox")
    box.Size = UDim2.new(1, -10, 0, 45)
    box.Position = UDim2.new(0, 5, 0, yPos)
    box.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    box.Text = ""
    box.PlaceholderText = placeholder
    box.TextColor3 = Color3.fromRGB(255, 255, 255)
    box.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
    box.Font = Enum.Font.Gotham
    box.TextSize = 14
    box.ClearTextOnFocus = false
    box.Parent = Content
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = box
    
    yPos = yPos + 50
    return box
end

-- ============================================
-- BUILD GUI
-- ============================================

buatLabel("🎯 TARGET PLAYER")

local targetBox = buatTextBox("Nama player target (all = semua)")

buatLabel("👤 KONTROL PLAYER")

buatTombol("💀 Kill Player", Color3.fromRGB(200, 50, 50), function()
    local target = targetBox.Text
    if target ~= "" then
        cobaKillPlayer(target)
    else
        notif("Masukkan nama player!")
    end
end)

buatTombol("👢 Kick Player", Color3.fromRGB(180, 60, 60), function()
    local target = targetBox.Text
    if target ~= "" then
        cobaKickPlayer(target)
    else
        notif("Masukkan nama player!")
    end
end)

buatTombol("🚫 Ban Player", Color3.fromRGB(150, 30, 30), function()
    local target = targetBox.Text
    if target ~= "" then
        cobaBanPlayer(target)
    else
        notif("Masukkan nama player!")
    end
end)

buatTombol("📍 TP Player ke Saya", Color3.fromRGB(0, 120, 200), function()
    local target = targetBox.Text
    if target ~= "" then
        cobaTeleportPlayer(target, player.Name)
    else
        notif("Masukkan nama player!")
    end
end)

buatTombol("💥 Explode Player", Color3.fromRGB(255, 100, 0), function()
    local target = targetBox.Text
    if target ~= "" then
        cobaExplodePlayer(target)
    else
        notif("Masukkan nama player!")
    end
end)

buatLabel("⚡ BUFF PLAYER")

buatTombol("🛡️ God Mode", Color3.fromRGB(255, 215, 0), function()
    local target = targetBox.Text
    if target == "" then target = player.Name end
    cobaGodMode(target)
end)

buatTombol("🚀 Super Speed (100)", Color3.fromRGB(0, 180, 255), function()
    local target = targetBox.Text
    if target == "" then target = player.Name end
    cobaSpeedPlayer(target, 100)
end)

buatTombol("✈️ Fly Mode", Color3.fromRGB(100, 150, 255), function()
    local target = targetBox.Text
    if target == "" then target = player.Name end
    cobaFlyPlayer(target)
end)

buatLabel("💬 PESAN BROADCAST")

local messageBox = buatTextBox("Ketik pesan di sini...")

buatTombol("📢 Kirim Message", Color3.fromRGB(0, 150, 100), function()
    local msg = messageBox.Text
    if msg ~= "" then
        kirimMessage(msg)
    else
        notif("Ketik pesan dulu!")
    end
end)

buatTombol("💡 Kirim Hint", Color3.fromRGB(255, 180, 0), function()
    local msg = messageBox.Text
    if msg ~= "" then
        kirimHint(msg)
    else
        notif("Ketik pesan dulu!")
    end
end)

buatTombol("📣 Kirim Announcement", Color3.fromRGB(200, 0, 150), function()
    local msg = messageBox.Text
    if msg ~= "" then
        kirimAnnouncement(msg)
    else
        notif("Ketik pesan dulu!")
    end
end)

buatLabel("🔧 LAINNYA")

buatTombol("📋 Buka Admin Panel", Color3.fromRGB(120, 120, 120), function()
    bukaAdminPanel()
end)

buatTombol("📜 Lihat Player Online", Color3.fromRGB(0, 120, 180), function()
    local playerNames = getPlayers()
    notif("Players: " .. #playerNames)
    print("=== PLAYER ONLINE ===")
    for i, name in ipairs(playerNames) do
        print(i .. ".", name)
    end
    print("=====================")
end)

-- Info
yPos = yPos + 10
local info = Instance.new("TextLabel")
info.Size = UDim2.new(1, -10, 0, 140)
info.Position = UDim2.new(0, 5, 0, yPos)
info.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
info.TextColor3 = Color3.fromRGB(200, 200, 200)
info.Font = Enum.Font.Gotham
info.TextSize = 12
info.TextWrapped = true
info.TextYAlignment = Enum.TextYAlignment.Top
info.Text = [[⚠️ CARA PAKAI:

1. Ketik NAMA player di box Target
2. Ketik "all" untuk target semua player
3. Kosongkan target untuk buff diri sendiri
4. Klik tombol exploit yang diinginkan
5. Cek apakah berhasil atau tidak

⚡ HD Admin terdeteksi!
✅ Script siap digunakan]]
info.Parent = Content

local infoPadding = Instance.new("UIPadding")
infoPadding.PaddingTop = UDim.new(0, 10)
infoPadding.PaddingLeft = UDim.new(0, 10)
infoPadding.PaddingRight = UDim.new(0, 10)
infoPadding.Parent = info

local infoCorner = Instance.new("UICorner")
infoCorner.CornerRadius = UDim.new(0, 8)
infoCorner.Parent = info

Content.CanvasSize = UDim2.new(0, 0, 0, yPos + 150)

-- Parent GUI
ScreenGui.Parent = playerGui

notif("✅ HD Admin Exploit Ready! 🚀")
print("=================================")
print("HD ADMIN EXPLOIT LOADED")
print("Target game: HD Admin System")
print("Total features: 12+")
print("=================================")
