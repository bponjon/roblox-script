-- ALL-IN-ONE EXPLOIT - MOUNT YAYAKIN
-- VIP + Admin + Checkpoint + Aura + More!
-- BAHASA INDONESIA

task.wait(2)

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui", 10)

if not playerGui then return end

if playerGui:FindFirstChild("AllInOneGUI") then
    playerGui.AllInOneGUI:Destroy()
    task.wait(0.5)
end

-- ============================================
-- FIND REMOTES
-- ============================================
local KohlsAdmin = ReplicatedStorage:FindFirstChild("Kohl's Admin Source") and ReplicatedStorage["Kohl's Admin Source"].Remote

local Remotes = {
    -- VIP
    VIPUGCMethod = KohlsAdmin and KohlsAdmin:FindFirstChild("VIPUGCMethod"),
    
    -- Admin Commands
    Command = KohlsAdmin and KohlsAdmin:FindFirstChild("Command"),
    ControlCommand = KohlsAdmin and KohlsAdmin:FindFirstChild("ControlCommand"),
    TeleportAdmin = ReplicatedStorage:FindFirstChild("TeleportAdmin"),
    AdminSummit_Exec = ReplicatedStorage:FindFirstChild("AdminSummit_Exec"),
    
    -- Checkpoint
    CP_DropToStart = ReplicatedStorage:FindFirstChild("CP_DropToStart"),
    CP_SkipDenied = ReplicatedStorage:FindFirstChild("CP_SkipDenied"),
    CP_MarkVisited = ReplicatedStorage:FindFirstChild("CP_MarkVisited"),
    CP_ResetVisited = ReplicatedStorage:FindFirstChild("CP_ResetVisited"),
    
    -- Aura
    AuraUpdate = ReplicatedStorage:FindFirstChild("AuraUpdate"),
    AuraUpdateAll = ReplicatedStorage:FindFirstChild("AuraUpdateAll"),
    AuraToggleRequest = ReplicatedStorage:FindFirstChild("AuraToggleRequest"),
    AuraToggle = ReplicatedStorage:FindFirstChild("AuraToggle"),
    
    -- Avatar
    ChangeAvatarEvent = ReplicatedStorage:FindFirstChild("ChangeAvatarEvent"),
    ResetAvatarEvent = ReplicatedStorage:FindFirstChild("ResetAvatarEvent"),
    AddAccessoryEvent = ReplicatedStorage:FindFirstChild("AddAccessoryEvent"),
    
    -- Title
    TitleRemote = ReplicatedStorage:FindFirstChild("TitleRemote"),
    Title = KohlsAdmin and KohlsAdmin:FindFirstChild("Title"),
    
    -- Other
    CarryRemote = ReplicatedStorage:FindFirstChild("CarryRemote"),
    Cloning = ReplicatedStorage:FindFirstChild("Cloning"),
}

-- ============================================
-- NOTIFICATION
-- ============================================
local function notif(msg, durasi)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "All-in-One";
            Text = msg;
            Duration = durasi or 3;
        })
    end)
    print("[All-in-One]", msg)
end

notif("🔥 All-in-One Exploit loaded!", 3)

-- ============================================
-- VIP FUNCTIONS
-- ============================================

local function getVIP()
    notif("👑 Mencoba VIP bypass...")
    
    if Remotes.VIPUGCMethod then
        pcall(function()
            for i = 1, 10 do
                Remotes.VIPUGCMethod:FireServer()
                Remotes.VIPUGCMethod:FireServer(true)
                Remotes.VIPUGCMethod:FireServer("Grant")
                Remotes.VIPUGCMethod:FireServer({action = "grant"})
                Remotes.VIPUGCMethod:FireServer(player)
                task.wait(0.1)
            end
        end)
        notif("✅ VIP requests sent!", 3)
    else
        notif("❌ VIP remote not found!", 3)
    end
end

-- ============================================
-- ADMIN FUNCTIONS
-- ============================================

local function tryAdminCommand(cmd)
    if cmd == "" then
        notif("❌ Masukkan command!", 3)
        return
    end
    
    notif("⚡ Trying admin: " .. cmd)
    
    -- Kohl's Admin Commands
    if Remotes.Command then
        pcall(function()
            Remotes.Command:FireServer(cmd)
            Remotes.Command:FireServer(":" .. cmd)
            Remotes.Command:FireServer({command = cmd})
        end)
    end
    
    if Remotes.ControlCommand then
        pcall(function()
            Remotes.ControlCommand:FireServer(cmd)
            Remotes.ControlCommand:FireServer(":" .. cmd)
        end)
    end
    
    if Remotes.AdminSummit_Exec then
        pcall(function()
            Remotes.AdminSummit_Exec:FireServer(cmd)
            Remotes.AdminSummit_Exec:FireServer({cmd = cmd})
        end)
    end
    
    notif("✅ Command sent!", 3)
end

local function getAdminAccess()
    notif("🔑 Trying admin access...")
    
    local adminCommands = {
        "god", "fly", "speed 100", "givetools", "admin", "owner",
        "mod", "vip", "grant", "promote", "access"
    }
    
    for _, cmd in ipairs(adminCommands) do
        tryAdminCommand(cmd)
        task.wait(0.2)
    end
    
    notif("✅ Admin attempts complete!", 3)
end

-- ============================================
-- CHECKPOINT FUNCTIONS
-- ============================================

local function skipCheckpoint()
    notif("🏁 Skipping checkpoint...")
    
    if Remotes.CP_MarkVisited then
        pcall(function()
            for i = 1, 100 do
                Remotes.CP_MarkVisited:FireServer(i)
                Remotes.CP_MarkVisited:FireServer({checkpoint = i})
            end
        end)
    end
    
    if Remotes.CP_SkipDenied then
        pcall(function()
            Remotes.CP_SkipDenied:FireServer(false)
            Remotes.CP_SkipDenied:FireServer({denied = false})
        end)
    end
    
    notif("✅ Checkpoint skip sent!", 3)
end

local function teleportToEnd()
    notif("🚀 Teleporting to summit...")
    
    if Remotes.TeleportAdmin then
        pcall(function()
            Remotes.TeleportAdmin:FireServer("Summit")
            Remotes.TeleportAdmin:FireServer("End")
            Remotes.TeleportAdmin:FireServer("Finish")
            Remotes.TeleportAdmin:FireServer({location = "Summit"})
        end)
    end
    
    if Remotes.CP_DropToStart then
        pcall(function()
            -- Try to teleport to last checkpoint
            Remotes.CP_DropToStart:FireServer(999)
            Remotes.CP_DropToStart:FireServer({checkpoint = 999})
        end)
    end
    
    notif("✅ Teleport attempts sent!", 3)
end

local function resetCheckpoints()
    notif("🔄 Resetting checkpoints...")
    
    if Remotes.CP_ResetVisited then
        pcall(function()
            Remotes.CP_ResetVisited:FireServer()
            Remotes.CP_ResetVisited:FireServer(true)
        end)
    end
    
    if Remotes.CP_DropToStart then
        pcall(function()
            Remotes.CP_DropToStart:FireServer(1)
            Remotes.CP_DropToStart:FireServer({checkpoint = 1})
        end)
    end
    
    notif("✅ Reset sent!", 3)
end

-- ============================================
-- AURA FUNCTIONS
-- ============================================

local function unlockAllAuras()
    notif("✨ Unlocking auras...")
    
    local auras = {
        "Rainbow", "Galaxy", "Fire", "Ice", "Lightning", "Shadow", 
        "Gold", "Diamond", "VIP", "Premium", "Legendary", "All",
        1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 99, 999
    }
    
    for _, aura in ipairs(auras) do
        pcall(function()
            if Remotes.AuraUpdate then
                Remotes.AuraUpdate:FireServer(aura)
                Remotes.AuraUpdate:FireServer({aura = aura, unlock = true})
            end
            if Remotes.AuraUpdateAll then
                Remotes.AuraUpdateAll:FireServer(aura)
            end
            if Remotes.AuraToggleRequest then
                Remotes.AuraToggleRequest:FireServer(aura, true)
            end
        end)
        task.wait(0.05)
    end
    
    notif("✅ Aura unlock sent!", 3)
end

local function toggleAura(state)
    notif("✨ Toggle aura: " .. (state and "ON" or "OFF"))
    
    if Remotes.AuraToggle then
        pcall(function()
            Remotes.AuraToggle:FireServer(state)
            Remotes.AuraToggle:FireServer({state = state})
        end)
    end
    
    if Remotes.AuraToggleRequest then
        pcall(function()
            Remotes.AuraToggleRequest:FireServer(state)
        end)
    end
    
    notif("✅ Toggle sent!", 3)
end

-- ============================================
-- TITLE FUNCTIONS
-- ============================================

local function unlockTitles()
    notif("👑 Unlocking titles...")
    
    local titles = {
        "VIP", "Premium", "Legend", "Pro", "Master", "Champion",
        "God", "Admin", "Owner", "Developer", "Staff", "All"
    }
    
    for _, title in ipairs(titles) do
        pcall(function()
            if Remotes.TitleRemote then
                Remotes.TitleRemote:FireServer(title)
                Remotes.TitleRemote:FireServer({title = title, unlock = true})
            end
            if Remotes.Title then
                Remotes.Title:FireServer(title)
                Remotes.Title:FireServer(player, title)
            end
        end)
        task.wait(0.1)
    end
    
    notif("✅ Title unlock sent!", 3)
end

-- ============================================
-- AVATAR FUNCTIONS
-- ============================================

local function unlockAccessories()
    notif("🎨 Unlocking accessories...")
    
    if Remotes.AddAccessoryEvent then
        pcall(function()
            for i = 1, 50 do
                Remotes.AddAccessoryEvent:FireServer(i)
                Remotes.AddAccessoryEvent:FireServer({id = i, unlock = true})
            end
        end)
    end
    
    notif("✅ Accessory unlock sent!", 3)
end

-- ============================================
-- PLAYER TROLLING
-- ============================================

local function trollPlayer(targetName, action)
    if targetName == "" then
        notif("❌ Masukkan nama player!", 3)
        return
    end
    
    notif("😈 Trolling: " .. targetName)
    
    local target = Players:FindFirstChild(targetName)
    if not target then
        for _, plr in pairs(Players:GetPlayers()) do
            if plr.Name:lower():find(targetName:lower()) then
                target = plr
                break
            end
        end
    end
    
    if not target then
        notif("❌ Player not found!", 3)
        return
    end
    
    -- Kohl's Admin trolling
    if KohlsAdmin then
        local trollCommands = {
            crash = "crash " .. target.Name,
            blind = "blind " .. target.Name,
            confuse = "confuse " .. target.Name,
            trip = "trip " .. target.Name,
            glitch = "glitch " .. target.Name,
            jail = "jail " .. target.Name,
            kick = "kick " .. target.Name,
        }
        
        local cmd = trollCommands[action] or action .. " " .. target.Name
        tryAdminCommand(cmd)
    end
    
    notif("✅ Troll sent!", 3)
end

-- ============================================
-- CREATE GUI
-- ============================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AllInOneGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = playerGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 400, 0, 650)
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -325)
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
Header.BackgroundColor3 = Color3.fromRGB(255, 50, 100)
Header.BorderSizePixel = 0
Header.Parent = MainFrame

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 15)
HeaderCorner.Parent = Header

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -70, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "🔥 ALL-IN-ONE"
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
    ScreenGui:Destroy()
end)

-- Content
local Content = Instance.new("ScrollingFrame")
Content.Size = UDim2.new(1, -24, 1, -70)
Content.Position = UDim2.new(0, 12, 0, 60)
Content.BackgroundTransparency = 1
Content.ScrollBarThickness = 8
Content.CanvasSize = UDim2.new(0, 0, 0, 1400)
Content.Parent = MainFrame

local yPos = 10

local function makeLabel(text, color)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -10, 0, 38)
    label.Position = UDim2.new(0, 5, 0, yPos)
    label.BackgroundColor3 = color
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 15
    label.Parent = Content
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = label
    
    yPos = yPos + 43
end

local function makeButton(text, color, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 50)
    btn.Position = UDim2.new(0, 5, 0, yPos)
    btn.BackgroundColor3 = color
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.TextWrapped = true
    btn.Parent = Content
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn
    
    btn.MouseButton1Click:Connect(function()
        pcall(callback)
    end)
    
    yPos = yPos + 55
end

local function makeTextBox(placeholder)
    local box = Instance.new("TextBox")
    box.Size = UDim2.new(1, -10, 0, 45)
    box.Position = UDim2.new(0, 5, 0, yPos)
    box.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    box.Text = ""
    box.PlaceholderText = placeholder
    box.TextColor3 = Color3.fromRGB(255, 255, 255)
    box.PlaceholderColor3 = Color3.fromRGB(140, 140, 140)
    box.Font = Enum.Font.Gotham
    box.TextSize = 14
    box.Parent = Content
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = box
    
    yPos = yPos + 50
    return box
end

-- Build GUI
makeLabel("👑 VIP BYPASS", Color3.fromRGB(255, 215, 0))

makeButton("👑 Get VIP Access", Color3.fromRGB(255, 180, 0), function()
    getVIP()
end)

makeLabel("⚡ ADMIN COMMANDS", Color3.fromRGB(200, 0, 0))

local adminCmdBox = makeTextBox("Command (god, fly, speed 100, etc)")

makeButton("⚡ Execute Admin Command", Color3.fromRGB(200, 50, 0), function()
    tryAdminCommand(adminCmdBox.Text)
end)

makeButton("🔑 Try Get Admin Access", Color3.fromRGB(180, 0, 0), function()
    getAdminAccess()
end)

makeLabel("🏁 CHECKPOINT CONTROL", Color3.fromRGB(0, 150, 255))

makeButton("🏁 Skip All Checkpoints", Color3.fromRGB(0, 180, 255), function()
    skipCheckpoint()
end)

makeButton("🚀 Teleport to Summit", Color3.fromRGB(0, 150, 200), function()
    teleportToEnd()
end)

makeButton("🔄 Reset Checkpoints", Color3.fromRGB(100, 150, 200), function()
    resetCheckpoints()
end)

makeLabel("✨ AURA & COSMETICS", Color3.fromRGB(150, 0, 255))

makeButton("✨ Unlock All Auras", Color3.fromRGB(150, 100, 255), function()
    unlockAllAuras()
end)

makeButton("💫 Toggle Aura ON", Color3.fromRGB(100, 150, 255), function()
    toggleAura(true)
end)

makeButton("🎨 Unlock Accessories", Color3.fromRGB(200, 100, 255), function()
    unlockAccessories()
end)

makeLabel("👑 TITLES", Color3.fromRGB(255, 100, 0))

makeButton("👑 Unlock All Titles", Color3.fromRGB(255, 150, 0), function()
    unlockTitles()
end)

makeLabel("😈 PLAYER TROLLING", Color3.fromRGB(150, 0, 0))

local targetBox = makeTextBox("Nama player target")

makeButton("💥 Crash Player", Color3.fromRGB(200, 0, 0), function()
    trollPlayer(targetBox.Text, "crash")
end)

makeButton("👻 Blind Player", Color3.fromRGB(150, 0, 100), function()
    trollPlayer(targetBox.Text, "blind")
end)

makeButton("😵 Confuse Player", Color3.fromRGB(150, 100, 0), function()
    trollPlayer(targetBox.Text, "confuse")
end)

-- Info
yPos = yPos + 10
local info = Instance.new("TextLabel")
info.Size = UDim2.new(1, -10, 0, 160)
info.Position = UDim2.new(0, 5, 0, yPos)
info.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
info.TextColor3 = Color3.fromRGB(220, 220, 220)
info.Font = Enum.Font.Gotham
info.TextSize = 11
info.TextWrapped = true
info.TextYAlignment = Enum.TextYAlignment.Top
info.Text = [[🔥 ALL-IN-ONE EXPLOIT

FITUR:
• VIP Bypass (Kohl's Admin)
• Admin Commands (god, fly, speed, etc)
• Checkpoint Skip/TP Summit
• Unlock Auras & Accessories
• Unlock Titles
• Player Trolling (crash, blind, confuse)

GAME: Mount Yayakin
ADMIN: Kohl's Admin Infinite
REMOTES: 73 found

⚠️ Note: Success tergantung server security!
Cek inventory/stats untuk verify hasil.

Game PlaceId: 80945057902511]]
info.Parent = Content

local infoPadding = Instance.new("UIPadding")
infoPadding.PaddingTop = UDim.new(0, 8)
infoPadding.PaddingLeft = UDim.new(0, 8)
infoPadding.PaddingRight = UDim.new(0, 8)
infoPadding.Parent = info

local infoCorner = Instance.new("UICorner")
infoCorner.CornerRadius = UDim.new(0, 8)
infoCorner.Parent = info

Content.CanvasSize = UDim2.new(0, 0, 0, yPos + 170)

print("================================")
print("ALL-IN-ONE EXPLOIT")
print("Game: Mount Yayakin")
print("Admin System: Kohl's Admin")
print("Total Remotes: 73")
print("================================")
print("FEATURES:")
print("✓ VIP Bypass")
print("✓ Admin Commands")
print("✓ Checkpoint Control")
print("✓ Aura Unlock")
print("✓ Title Unlock")
print("✓ Player Trolling")
print("================================")
