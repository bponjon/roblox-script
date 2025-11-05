-- SERVER-SIDE EXPLOIT CONTROLLER - MOBILE FIXED v2
-- Kompatibel dengan Delta, Arceus X, dan executor mobile lainnya
-- BAHASA INDONESIA

-- Tunggu game siap
task.wait(2)

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui", 10)

if not playerGui then
    warn("PlayerGui tidak ditemukan!")
    return
end

-- Cek apakah GUI sudah ada
if playerGui:FindFirstChild("ServerExploitGUI") then
    playerGui.ServerExploitGUI:Destroy()
    task.wait(0.5)
end

-- Fungsi notifikasi aman
local function notif(msg)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Server Exploit";
            Text = msg;
            Duration = 3;
        })
    end)
    print("[Server Exploit]", msg)
end

-- Mouse dan part yang dipilih
local mouse = nil
local partDipilih = nil

local function dapatkanMouse()
    local success, result = pcall(function()
        return player:GetMouse()
    end)
    if success and result then
        return result
    end
    return nil
end

-- Coba dapatkan mouse
task.spawn(function()
    task.wait(1)
    mouse = dapatkanMouse()
    if mouse then
        notif("Mouse terdeteksi!")
        -- Update part yang dipilih saat mouse bergerak
        mouse.Move:Connect(function()
            if mouse.Target and mouse.Target:IsA("BasePart") then
                partDipilih = mouse.Target
            end
        end)
    else
        notif("Gunakan sentuh/tap untuk pilih part")
    end
end)

-- Sistem pilih dengan sentuhan/tap
local UserInputService = game:GetService("UserInputService")
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.UserInputType == Enum.UserInputType.Touch or 
       input.UserInputType == Enum.UserInputType.MouseButton1 then
        
        local camera = workspace.CurrentCamera
        local ray = camera:ViewportPointToRay(input.Position.X, input.Position.Y)
        local raycastParams = RaycastParams.new()
        raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
        raycastParams.FilterDescendantsInstances = {player.Character}
        
        local result = workspace:Raycast(ray.Origin, ray.Direction * 500, raycastParams)
        
        if result and result.Instance then
            partDipilih = result.Instance
            notif("Dipilih: " .. partDipilih.Name)
        end
    end
end)

-- ============================================
-- SCANNER REMOTE
-- ============================================
local remoteEvents = {}
local remoteFunctions = {}

local function scanRemote()
    remoteEvents = {}
    remoteFunctions = {}
    
    notif("Memindai remote...")
    
    -- Scan ReplicatedStorage
    for _, obj in pairs(ReplicatedStorage:GetDescendants()) do
        if obj:IsA("RemoteEvent") then
            table.insert(remoteEvents, obj)
        elseif obj:IsA("RemoteFunction") then
            table.insert(remoteFunctions, obj)
        end
    end
    
    -- Scan Workspace
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("RemoteEvent") then
            table.insert(remoteEvents, obj)
        elseif obj:IsA("RemoteFunction") then
            table.insert(remoteFunctions, obj)
        end
    end
    
    notif("Ditemukan " .. #remoteEvents .. " RemoteEvent!")
    
    print("=== DAFTAR REMOTE EVENTS ===")
    for i, remote in pairs(remoteEvents) do
        print(i .. ".", remote:GetFullName())
    end
    print("============================")
end

-- ============================================
-- FUNGSI EXPLOIT
-- ============================================

local function cobaHapusPart(part)
    if not part then 
        notif("Belum ada part yang dipilih!")
        return 
    end
    
    notif("Mencoba hapus: " .. part.Name)
    
    local berhasil = 0
    for _, remote in pairs(remoteEvents) do
        pcall(function()
            -- Coba berbagai pola hapus
            remote:FireServer("Delete", part)
            remote:FireServer("Remove", part)
            remote:FireServer("Destroy", part)
            remote:FireServer({Action = "Delete", Target = part})
            remote:FireServer({action = "delete", part = part})
            remote:FireServer("DeletePart", part)
            remote:FireServer(part, "Delete")
            berhasil = berhasil + 1
        end)
    end
    
    notif("Dikirim ke " .. berhasil .. " remote!")
end

local function cobaEditPart(part, properti, nilai)
    if not part then 
        notif("Belum ada part yang dipilih!")
        return 
    end
    
    notif("Mencoba edit: " .. part.Name)
    
    local berhasil = 0
    for _, remote in pairs(remoteEvents) do
        pcall(function()
            remote:FireServer("Edit", part, properti, nilai)
            remote:FireServer("Change", part, properti, nilai)
            remote:FireServer({Action = "Edit", Target = part, Property = properti, Value = nilai})
            remote:FireServer("SetProperty", part, properti, nilai)
            remote:FireServer("UpdatePart", part, {[properti] = nilai})
            berhasil = berhasil + 1
        end)
    end
    
    notif("Dikirim ke " .. berhasil .. " remote!")
end

local function cobaUbahWaktu(waktu)
    notif("Mencoba ubah waktu ke " .. waktu)
    
    local berhasil = 0
    for _, remote in pairs(remoteEvents) do
        pcall(function()
            remote:FireServer("SetTime", waktu)
            remote:FireServer("ChangeTime", waktu)
            remote:FireServer({Action = "Time", Value = waktu})
            remote:FireServer("Lighting", "ClockTime", waktu)
            remote:FireServer("UpdateLighting", {ClockTime = waktu})
            berhasil = berhasil + 1
        end)
    end
    
    notif("Dikirim ke " .. berhasil .. " remote!")
end

local function cobaLedakan(posisi)
    if not posisi then
        posisi = player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character.HumanoidRootPart.Position
    end
    
    if not posisi then
        notif("Posisi tidak valid!")
        return
    end
    
    notif("Mencoba buat ledakan...")
    
    local berhasil = 0
    for _, remote in pairs(remoteEvents) do
        pcall(function()
            remote:FireServer("Explode", posisi, 50)
            remote:FireServer("CreateExplosion", posisi, 50)
            remote:FireServer({Action = "Explode", Position = posisi, Radius = 50})
            remote:FireServer("Explosion", {Position = posisi, BlastRadius = 50})
            berhasil = berhasil + 1
        end)
    end
    
    notif("Dikirim ke " .. berhasil .. " remote!")
end

-- ============================================
-- BUAT GUI (OPTIMASI MOBILE)
-- ============================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ServerExploitGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 350, 0, 500)
MainFrame.Position = UDim2.new(0.5, -175, 0.5, -250)
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
Header.Size = UDim2.new(1, 0, 0, 45)
Header.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
Header.BorderSizePixel = 0
Header.Parent = MainFrame

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 12)
HeaderCorner.Parent = Header

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -60, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "⚠️ EXPLOIT SERVER"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

-- Tombol Tutup
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 40, 0, 40)
CloseBtn.Position = UDim2.new(1, -45, 0, 2.5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(150, 30, 30)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 20
CloseBtn.Parent = Header

local CloseBtnCorner = Instance.new("UICorner")
CloseBtnCorner.CornerRadius = UDim.new(0, 8)
CloseBtnCorner.Parent = CloseBtn

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
    notif("GUI Ditutup")
end)

-- Content ScrollingFrame
local Content = Instance.new("ScrollingFrame")
Content.Size = UDim2.new(1, -20, 1, -55)
Content.Position = UDim2.new(0, 10, 0, 50)
Content.BackgroundTransparency = 1
Content.BorderSizePixel = 0
Content.ScrollBarThickness = 8
Content.CanvasSize = UDim2.new(0, 0, 0, 900)
Content.Parent = MainFrame

-- ============================================
-- HELPER TOMBOL (OPTIMASI MOBILE)
-- ============================================
local yPos = 10

local function buatTombol(teks, warna, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 50)
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
    
    yPos = yPos + 55
    return btn
end

local function buatLabel(teks)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -10, 0, 35)
    label.Position = UDim2.new(0, 5, 0, yPos)
    label.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    label.Text = teks
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 14
    label.Parent = Content
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = label
    
    yPos = yPos + 40
end

-- ============================================
-- BUAT GUI
-- ============================================

buatLabel("🔍 PEMINDAI")

buatTombol("Pindai RemoteEvent", Color3.fromRGB(0, 120, 215), function()
    scanRemote()
end)

buatTombol("Lihat Part Dipilih", Color3.fromRGB(0, 150, 200), function()
    if partDipilih then
        notif("Dipilih: " .. partDipilih.Name)
    else
        notif("Belum ada part dipilih! Tap part dulu")
    end
end)

buatLabel("🗑️ HAPUS")

buatTombol("Hapus Part Dipilih", Color3.fromRGB(200, 50, 50), function()
    if partDipilih then
        cobaHapusPart(partDipilih)
    else
        notif("Tap part dulu sebelum menghapus!")
    end
end)

buatLabel("✏️ EDIT PART DIPILIH")

buatTombol("Buat Transparan", Color3.fromRGB(0, 180, 120), function()
    if partDipilih and partDipilih:IsA("BasePart") then
        cobaEditPart(partDipilih, "Transparency", 1)
    else
        notif("Pilih part yang valid dulu!")
    end
end)

buatTombol("Ubah Jadi Merah", Color3.fromRGB(200, 0, 0), function()
    if partDipilih and partDipilih:IsA("BasePart") then
        cobaEditPart(partDipilih, "Color", Color3.fromRGB(255, 0, 0))
    else
        notif("Pilih part yang valid dulu!")
    end
end)

buatTombol("Ubah Jadi Biru", Color3.fromRGB(0, 100, 200), function()
    if partDipilih and partDipilih:IsA("BasePart") then
        cobaEditPart(partDipilih, "Color", Color3.fromRGB(0, 100, 255))
    else
        notif("Pilih part yang valid dulu!")
    end
end)

buatTombol("Buat Anchored", Color3.fromRGB(100, 100, 100), function()
    if partDipilih and partDipilih:IsA("BasePart") then
        cobaEditPart(partDipilih, "Anchored", true)
    else
        notif("Pilih part yang valid dulu!")
    end
end)

buatLabel("🌅 PENCAHAYAAN")

buatTombol("Ubah Jadi Siang", Color3.fromRGB(255, 200, 0), function()
    cobaUbahWaktu(14)
end)

buatTombol("Ubah Jadi Malam", Color3.fromRGB(20, 20, 80), function()
    cobaUbahWaktu(0)
end)

buatTombol("Ubah Jadi Sore", Color3.fromRGB(255, 120, 50), function()
    cobaUbahWaktu(18)
end)

buatLabel("💥 DESTRUKTIF")

buatTombol("Ledakan di Player", Color3.fromRGB(255, 100, 0), function()
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        cobaLedakan(player.Character.HumanoidRootPart.Position)
    else
        notif("Karakter tidak ditemukan!")
    end
end)

buatTombol("Ledakan di Part Dipilih", Color3.fromRGB(255, 50, 0), function()
    if partDipilih then
        cobaLedakan(partDipilih.Position)
    else
        notif("Pilih part dulu!")
    end
end)

-- Info di bawah
yPos = yPos + 10
local info = Instance.new("TextLabel")
info.Size = UDim2.new(1, -10, 0, 120)
info.Position = UDim2.new(0, 5, 0, yPos)
info.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
info.TextColor3 = Color3.fromRGB(200, 200, 200)
info.Font = Enum.Font.Gotham
info.TextSize = 11
info.TextWrapped = true
info.TextYAlignment = Enum.TextYAlignment.Top
info.Text = [[⚠️ CARA PAKAI:

1. PINDAI dulu - Klik "Pindai RemoteEvent"
2. PILIH PART - TAP/sentuh part yang mau diubah
3. COBA EXPLOIT - Klik tombol exploit
4. CEK HASIL - Lihat apakah berhasil

Hanya berfungsi di game yang vulnerable!]]
info.Parent = Content

local infoPadding = Instance.new("UIPadding")
infoPadding.PaddingTop = UDim.new(0, 8)
infoPadding.PaddingLeft = UDim.new(0, 8)
infoPadding.PaddingRight = UDim.new(0, 8)
infoPadding.Parent = info

local infoCorner = Instance.new("UICorner")
infoCorner.CornerRadius = UDim.new(0, 8)
infoCorner.Parent = info

-- Update ukuran canvas
Content.CanvasSize = UDim2.new(0, 0, 0, yPos + 130)

-- ============================================
-- PARENT GUI
-- ============================================
ScreenGui.Parent = playerGui

-- Auto scan saat start
task.spawn(function()
    task.wait(2)
    scanRemote()
    notif("GUI Siap! Tap part untuk memilih")
end)

notif("GUI Berhasil Dimuat! 🚀")
print("=================================")
print("SERVER EXPLOIT - VERSI MOBILE")
print("GUI sudah muncul!")
print("Tap/sentuh part untuk memilihnya")
print("=================================")
