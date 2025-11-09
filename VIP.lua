-- VIP BYPASS - MOUNT KUMAHA EDITION
-- Free VIP + Bonus Exploits
-- BAHASA INDONESIA

task.wait(2)

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui", 10)

if not playerGui then return end

if playerGui:FindFirstChild("VIPBypassGUI") then
    playerGui.VIPBypassGUI:Destroy()
    task.wait(0.5)
end

-- ============================================
-- FIND REMOTES
-- ============================================
local Remotes = {
    GiveVIPCoil = ReplicatedStorage:FindFirstChild("GiveVIPCoilEvent"),
    GiveVIPTitle = ReplicatedStorage:FindFirstChild("GiveVIPTitleEvent"),
    Donated = ReplicatedStorage:FindFirstChild("Server") and ReplicatedStorage.Server:FindFirstChild("MainModule") and ReplicatedStorage.Server.MainModule.Events:FindFirstChild("Donated"),
    ChangeAura = ReplicatedStorage:FindFirstChild("ChangeAura"),
    AdminRemote = ReplicatedStorage:FindFirstChild("AdminRemote"),
}

-- ============================================
-- NOTIFICATION
-- ============================================
local function notif(msg, durasi)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "VIP Bypass";
            Text = msg;
            Duration = durasi or 3;
        })
    end)
    print("[VIP Bypass]", msg)
end

-- Check remotes
local vipFound = Remotes.GiveVIPCoil or Remotes.GiveVIPTitle
if not vipFound then
    notif("❌ VIP remotes tidak ditemukan!", 5)
    return
end

notif("✅ VIP remotes ditemukan!", 3)

-- ============================================
-- VIP BYPASS FUNCTIONS
-- ============================================

local function giveVIPCoil()
    if not Remotes.GiveVIPCoil then
        notif("❌ GiveVIPCoil tidak ada!", 3)
        return
    end
    
    notif("💎 Mencoba dapat VIP Coil...")
    
    local patterns = {
        function() Remotes.GiveVIPCoil:FireServer() end,
        function() Remotes.GiveVIPCoil:FireServer(true) end,
        function() Remotes.GiveVIPCoil:FireServer("VIP") end,
        function() Remotes.GiveVIPCoil:FireServer(player) end,
        function() Remotes.GiveVIPCoil:FireServer({player = player}) end,
        function() Remotes.GiveVIPCoil:FireServer({action = "give"}) end,
        function() Remotes.GiveVIPCoil:FireServer({type = "vip", amount = 999999}) end,
        function() Remotes.GiveVIPCoil:FireServer(999999) end,
        function() Remotes.GiveVIPCoil:FireServer("Grant", player) end,
        function() Remotes.GiveVIPCoil:FireServer("Activate") end,
    }
    
    for i, pattern in ipairs(patterns) do
        pcall(pattern)
        task.wait(0.1)
    end
    
    notif("✅ VIP Coil requests sent!", 3)
    notif("Cek inventory/stats kamu!", 3)
end

local function giveVIPTitle()
    if not Remotes.GiveVIPTitle then
        notif("❌ GiveVIPTitle tidak ada!", 3)
        return
    end
    
    notif("👑 Mencoba dapat VIP Title...")
    
    local patterns = {
        function() Remotes.GiveVIPTitle:FireServer() end,
        function() Remotes.GiveVIPTitle:FireServer(true) end,
        function() Remotes.GiveVIPTitle:FireServer("VIP") end,
        function() Remotes.GiveVIPTitle:FireServer(player) end,
        function() Remotes.GiveVIPTitle:FireServer({player = player}) end,
        function() Remotes.GiveVIPTitle:FireServer({action = "give"}) end,
        function() Remotes.GiveVIPTitle:FireServer({title = "VIP"}) end,
        function() Remotes.GiveVIPTitle:FireServer("Grant", player) end,
        function() Remotes.GiveVIPTitle:FireServer("Activate") end,
        function() Remotes.GiveVIPTitle:FireServer({type = "vip", grant = true}) end,
    }
    
    for i, pattern in ipairs(patterns) do
        pcall(pattern)
        task.wait(0.1)
    end
    
    notif("✅ VIP Title requests sent!", 3)
    notif("Cek title/nametag kamu!", 3)
end

local function giveFullVIP()
    notif("🔥 FULL VIP BYPASS START!", 3)
    
    -- Try both
    giveVIPCoil()
    task.wait(1)
    giveVIPTitle()
    
    notif("💥 Full VIP bypass complete!", 3)
    notif("Restart atau rejoin kalau perlu!", 4)
end

-- ============================================
-- BONUS EXPLOITS
-- ============================================

local function unlockAllAuras()
    if not Remotes.ChangeAura then
        notif("❌ ChangeAura tidak ada!", 3)
        return
    end
    
    notif("✨ Mencoba unlock auras...")
    
    -- Try different aura IDs/names
    local auras = {
        "Rainbow", "Galaxy", "Fire", "Ice", "Lightning", "Shadow", "Gold", "Diamond",
        "VIP", "Premium", "Legendary", "Epic", "Rare", "All",
        1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 99, 999
    }
    
    for _, aura in ipairs(auras) do
        pcall(function()
            Remotes.ChangeAura:FireServer(aura)
            Remotes.ChangeAura:FireServer({aura = aura})
            Remotes.ChangeAura:FireServer({id = aura, unlock = true})
            Remotes.ChangeAura:FireServer("Equip", aura)
            Remotes.ChangeAura:FireServer("Unlock", aura)
        end)
        task.wait(0.05)
    end
    
    notif("✅ Aura unlock attempts sent!", 3)
end

local function donationSpam(amount)
    if not Remotes.Donated then
        notif("❌ Donated remote tidak ada!", 3)
        return
    end
    
    amount = tonumber(amount) or 999999
    notif("💰 Donation spam: " .. amount)
    
    for i = 1, 20 do
        pcall(function()
            Remotes.Donated:FireServer(amount)
            Remotes.Donated:FireServer({amount = amount})
            Remotes.Donated:FireServer({value = amount, player = player})
            Remotes.Donated:FireServer("Donate", amount)
        end)
        task.wait(0.1)
    end
    
    notif("✅ Donation spam complete!", 3)
end

local function tryAdminCommands(command)
    if not Remotes.AdminRemote then
        notif("❌ AdminRemote tidak ada!", 3)
        return
    end
    
    if command == "" then
        notif("❌ Masukkan command!", 3)
        return
    end
    
    notif("⚡ Mencoba admin command...")
    
    local patterns = {
        function() Remotes.AdminRemote:FireServer(command) end,
        function() Remotes.AdminRemote:FireServer({command = command}) end,
        function() Remotes.AdminRemote:FireServer({action = command}) end,
        function() Remotes.AdminRemote:FireServer("Execute", command) end,
        function() Remotes.AdminRemote:FireServer(command, player) end,
    }
    
    for _, pattern in ipairs(patterns) do
        pcall(pattern)
        task.wait(0.1)
    end
    
    notif("✅ Command sent!", 3)
end

-- ============================================
-- CREATE GUI
-- ============================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "VIPBypassGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = playerGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 380, 0, 600)
MainFrame.Position = UDim2.new(0.5, -190, 0.5, -300)
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
Header.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
Header.BorderSizePixel = 0
Header.Parent = MainFrame

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 15)
HeaderCorner.Parent = Header

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -70, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "👑 VIP BYPASS"
Title.TextColor3 = Color3.fromRGB(0, 0, 0)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 22
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 50, 0, 50)
CloseBtn.Position = UDim2.new(1, -53, 0, 2.5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 150, 0)
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 24
CloseBtn.Parent = Header

local CloseBtnCorner = Instance.new("UICorner")
CloseBtnCorner.CornerRadius = UDim.new(0, 10)
CloseBtnCorner.Parent = CloseBtn

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Content
local Content = Instance.new("ScrollingFrame")
Content.Size = UDim2.new(1, -24, 1, -70)
Content.Position = UDim2.new(0, 12, 0, 60)
Content.BackgroundTransparency = 1
Content.ScrollBarThickness = 8
Content.CanvasSize = UDim2.new(0, 0, 0, 900)
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
    btn.Size = UDim2.new(1, -10, 0, 55)
    btn.Position = UDim2.new(0, 5, 0, yPos)
    btn.BackgroundColor3 = color
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 16
    btn.TextWrapped = true
    btn.Parent = Content
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = btn
    
    btn.MouseButton1Click:Connect(function()
        pcall(callback)
    end)
    
    yPos = yPos + 61
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
makeLabel("👑 VIP BYPASS", Color3.fromRGB(255, 215, 0))

makeButton("💎 Get VIP Coil", Color3.fromRGB(0, 150, 255), function()
    giveVIPCoil()
end)

makeButton("👑 Get VIP Title", Color3.fromRGB(150, 0, 255), function()
    giveVIPTitle()
end)

makeButton("🔥 FULL VIP BYPASS (ALL)", Color3.fromRGB(255, 100, 0), function()
    giveFullVIP()
end)

makeLabel("✨ BONUS EXPLOITS", Color3.fromRGB(100, 200, 255))

makeButton("✨ Unlock All Auras", Color3.fromRGB(150, 100, 255), function()
    unlockAllAuras()
end)

makeLabel("💰 DONATION EXPLOIT", Color3.fromRGB(0, 200, 100))

local donateBox = makeTextBox("Amount (default: 999999)")

makeButton("💰 Spam Donation", Color3.fromRGB(0, 180, 100), function()
    local amount = tonumber(donateBox.Text) or 999999
    donationSpam(amount)
end)

makeLabel("⚡ ADMIN COMMANDS (Coba)", Color3.fromRGB(200, 50, 50))

local commandBox = makeTextBox("Command (e.g: god, fly, speed 100)")

makeButton("⚡ Try Admin Command", Color3.fromRGB(200, 0, 0), function()
    tryAdminCommands(commandBox.Text)
end)

-- Info
yPos = yPos + 10
local info = Instance.new("TextLabel")
info.Size = UDim2.new(1, -10, 0, 180)
info.Position = UDim2.new(0, 5, 0, yPos)
info.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
info.TextColor3 = Color3.fromRGB(220, 220, 220)
info.Font = Enum.Font.Gotham
info.TextSize = 12
info.TextWrapped = true
info.TextYAlignment = Enum.TextYAlignment.Top
info.Text = [[👑 VIP BYPASS - MOUNT KUMAHA

🎯 CARA PAKAI:
1. Klik "FULL VIP BYPASS" untuk dapat semua
2. Atau klik satu-satu:
   • VIP Coil = Currency/coins VIP
   • VIP Title = Title/nametag VIP

✨ BONUS:
• Unlock Auras = Coba unlock semua aura
• Donation = Spam donation (coba dupe?)
• Admin = Coba admin commands

⚠️ CATATAN:
• Kalau tidak work = server aman
• Coba restart/rejoin setelah bypass
• Check inventory/stats untuk verify
• Script ini coba berbagai patterns!

Game: Mount Kumaha
Remotes: GiveVIPCoil, GiveVIPTitle]]
info.Parent = Content

local infoPadding = Instance.new("UIPadding")
infoPadding.PaddingTop = UDim.new(0, 10)
infoPadding.PaddingLeft = UDim.new(0, 10)
infoPadding.PaddingRight = UDim.new(0, 10)
infoPadding.Parent = info

local infoCorner = Instance.new("UICorner")
infoCorner.CornerRadius = UDim.new(0, 10)
infoCorner.Parent = info

Content.CanvasSize = UDim2.new(0, 0, 0, yPos + 190)

notif("👑 VIP Bypass loaded!", 3)
notif("Game: Mount Kumaha", 3)
print("================================")
print("VIP BYPASS - MOUNT KUMAHA")
print("Remotes found:")
print("- GiveVIPCoil:", Remotes.GiveVIPCoil and "✓" or "✗")
print("- GiveVIPTitle:", Remotes.GiveVIPTitle and "✓" or "✗")
print("- Donated:", Remotes.Donated and "✓" or "✗")
print("- ChangeAura:", Remotes.ChangeAura and "✓" or "✗")
print("- AdminRemote:", Remotes.AdminRemote and "✓" or "✗")
print("================================")
print("Klik 'FULL VIP BYPASS' untuk start!")
print("================================")
