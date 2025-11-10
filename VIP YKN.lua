-- ALL-IN-ONE EXPLOIT - FIXED VERSION
-- Mount Yayakin - Simple & Clean
-- BAHASA INDONESIA

task.wait(2)

local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local gui = player:WaitForChild("PlayerGui", 10)

if not gui then 
    warn("PlayerGui not found!")
    return 
end

-- Remove old
pcall(function()
    if gui:FindFirstChild("ExploitGUI") then
        gui.ExploitGUI:Destroy()
        task.wait(0.5)
    end
end)

-- ============================================
-- NOTIFICATION
-- ============================================
local function notif(msg)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Exploit";
            Text = msg;
            Duration = 2.5;
        })
    end)
    print("[Exploit]", msg)
end

-- ============================================
-- FIND REMOTES
-- ============================================
local function findRemote(path)
    local current = RS
    for part in string.gmatch(path, "[^.]+") do
        current = current:FindFirstChild(part)
        if not current then return nil end
    end
    return current
end

-- Kohl's Admin
local KA = findRemote("Kohl's Admin Source.Remote")

local R = {
    -- VIP
    vip = KA and KA:FindFirstChild("VIPUGCMethod"),
    
    -- Admin
    cmd = KA and KA:FindFirstChild("Command"),
    ctrl = KA and KA:FindFirstChild("ControlCommand"),
    tpAdmin = RS:FindFirstChild("TeleportAdmin"),
    adminExec = RS:FindFirstChild("AdminSummit_Exec"),
    
    -- Checkpoint
    cpMark = RS:FindFirstChild("CP_MarkVisited"),
    cpDrop = RS:FindFirstChild("CP_DropToStart"),
    cpSkip = RS:FindFirstChild("CP_SkipDenied"),
    cpReset = RS:FindFirstChild("CP_ResetVisited"),
    
    -- Aura
    aura = RS:FindFirstChild("AuraUpdate"),
    auraAll = RS:FindFirstChild("AuraUpdateAll"),
    auraReq = RS:FindFirstChild("AuraToggleRequest"),
    auraTgl = RS:FindFirstChild("AuraToggle"),
    
    -- Title
    title = RS:FindFirstChild("TitleRemote"),
    titleKA = KA and KA:FindFirstChild("Title"),
    
    -- Avatar
    addAcc = RS:FindFirstChild("AddAccessoryEvent"),
}

notif("✅ Script loaded!")

-- ============================================
-- FUNCTIONS
-- ============================================

local function vipBypass()
    notif("👑 VIP bypass...")
    if not R.vip then 
        notif("❌ VIP remote not found")
        return 
    end
    
    for i = 1, 10 do
        pcall(function()
            R.vip:FireServer()
            R.vip:FireServer(true)
            R.vip:FireServer("Grant")
            R.vip:FireServer(player)
        end)
        task.wait(0.1)
    end
    notif("✅ VIP sent!")
end

local function adminCmd(cmd)
    if cmd == "" then 
        notif("❌ Empty command")
        return 
    end
    
    notif("⚡ Running: " .. cmd)
    
    pcall(function()
        if R.cmd then R.cmd:FireServer(cmd) end
        if R.cmd then R.cmd:FireServer(":" .. cmd) end
        if R.ctrl then R.ctrl:FireServer(cmd) end
        if R.adminExec then R.adminExec:FireServer(cmd) end
    end)
    
    notif("✅ Command sent!")
end

local function autoAdmin()
    notif("🔑 Auto admin...")
    local cmds = {"god", "fly", "speed 100", "givetools", "admin"}
    for _, c in ipairs(cmds) do
        adminCmd(c)
        task.wait(0.2)
    end
    notif("✅ Done!")
end

local function skipCP()
    notif("🏁 Skip checkpoint...")
    
    pcall(function()
        if R.cpMark then
            for i = 1, 100 do
                R.cpMark:FireServer(i)
            end
        end
        if R.cpSkip then
            R.cpSkip:FireServer(false)
        end
    end)
    
    notif("✅ CP skip sent!")
end

local function tpSummit()
    notif("🚀 TP summit...")
    
    pcall(function()
        if R.tpAdmin then
            R.tpAdmin:FireServer("Summit")
            R.tpAdmin:FireServer("End")
        end
        if R.cpDrop then
            R.cpDrop:FireServer(999)
        end
    end)
    
    notif("✅ TP sent!")
end

local function unlockAura()
    notif("✨ Unlock auras...")
    
    local auras = {"Rainbow", "Galaxy", "Fire", "Ice", "VIP", "All", 1, 2, 3, 4, 5, 10, 99}
    
    pcall(function()
        for _, a in ipairs(auras) do
            if R.aura then R.aura:FireServer(a) end
            if R.auraAll then R.auraAll:FireServer(a) end
            if R.auraReq then R.auraReq:FireServer(a, true) end
            task.wait(0.05)
        end
    end)
    
    notif("✅ Aura unlock sent!")
end

local function unlockTitle()
    notif("👑 Unlock titles...")
    
    local titles = {"VIP", "Legend", "Pro", "Master", "God", "All"}
    
    pcall(function()
        for _, t in ipairs(titles) do
            if R.title then R.title:FireServer(t) end
            if R.titleKA then R.titleKA:FireServer(player, t) end
            task.wait(0.1)
        end
    end)
    
    notif("✅ Title unlock sent!")
end

local function unlockAcc()
    notif("🎨 Unlock accessories...")
    
    pcall(function()
        if R.addAcc then
            for i = 1, 50 do
                R.addAcc:FireServer(i)
            end
        end
    end)
    
    notif("✅ Accessory sent!")
end

local function crashPlayer(name)
    if name == "" then 
        notif("❌ Empty name")
        return 
    end
    
    notif("💥 Crash: " .. name)
    adminCmd("crash " .. name)
end

-- ============================================
-- GUI
-- ============================================

local sg = Instance.new("ScreenGui")
sg.Name = "ExploitGUI"
sg.ResetOnSpawn = false
sg.Parent = gui

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 360, 0, 580)
main.Position = UDim2.new(0.5, -180, 0.5, -290)
main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
main.Parent = sg

local c1 = Instance.new("UICorner")
c1.CornerRadius = UDim.new(0, 12)
c1.Parent = main

-- Header
local hdr = Instance.new("Frame")
hdr.Size = UDim2.new(1, 0, 0, 50)
hdr.BackgroundColor3 = Color3.fromRGB(255, 50, 100)
hdr.BorderSizePixel = 0
hdr.Parent = main

local c2 = Instance.new("UICorner")
c2.CornerRadius = UDim.new(0, 12)
c2.Parent = hdr

local ttl = Instance.new("TextLabel")
ttl.Size = UDim2.new(1, -60, 1, 0)
ttl.Position = UDim2.new(0, 10, 0, 0)
ttl.BackgroundTransparency = 1
ttl.Text = "🔥 ALL-IN-ONE"
ttl.TextColor3 = Color3.fromRGB(255, 255, 255)
ttl.Font = Enum.Font.GothamBold
ttl.TextSize = 20
ttl.TextXAlignment = Enum.TextXAlignment.Left
ttl.Parent = hdr

local cls = Instance.new("TextButton")
cls.Size = UDim2.new(0, 45, 0, 45)
cls.Position = UDim2.new(1, -48, 0, 2.5)
cls.BackgroundColor3 = Color3.fromRGB(200, 0, 50)
cls.Text = "X"
cls.TextColor3 = Color3.fromRGB(255, 255, 255)
cls.Font = Enum.Font.GothamBold
cls.TextSize = 22
cls.Parent = hdr

local c3 = Instance.new("UICorner")
c3.CornerRadius = UDim.new(0, 8)
c3.Parent = cls

cls.MouseButton1Click:Connect(function()
    sg:Destroy()
end)

-- Content
local cont = Instance.new("ScrollingFrame")
cont.Size = UDim2.new(1, -20, 1, -60)
cont.Position = UDim2.new(0, 10, 0, 55)
cont.BackgroundTransparency = 1
cont.ScrollBarThickness = 6
cont.CanvasSize = UDim2.new(0, 0, 0, 900)
cont.Parent = main

local y = 10

local function btn(txt, col, fn)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -10, 0, 48)
    b.Position = UDim2.new(0, 5, 0, y)
    b.BackgroundColor3 = col
    b.Text = txt
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 14
    b.TextWrapped = true
    b.Parent = cont
    
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 8)
    c.Parent = b
    
    b.MouseButton1Click:Connect(function()
        pcall(fn)
    end)
    
    y = y + 53
end

local function box(ph)
    local bx = Instance.new("TextBox")
    bx.Size = UDim2.new(1, -10, 0, 45)
    bx.Position = UDim2.new(0, 5, 0, y)
    bx.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    bx.Text = ""
    bx.PlaceholderText = ph
    bx.TextColor3 = Color3.fromRGB(255, 255, 255)
    bx.PlaceholderColor3 = Color3.fromRGB(140, 140, 140)
    bx.Font = Enum.Font.Gotham
    bx.TextSize = 14
    bx.Parent = cont
    
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 8)
    c.Parent = bx
    
    y = y + 50
    return bx
end

local function lbl(txt, col)
    local lb = Instance.new("TextLabel")
    lb.Size = UDim2.new(1, -10, 0, 35)
    lb.Position = UDim2.new(0, 5, 0, y)
    lb.BackgroundColor3 = col
    lb.Text = txt
    lb.TextColor3 = Color3.fromRGB(255, 255, 255)
    lb.Font = Enum.Font.GothamBold
    lb.TextSize = 14
    lb.Parent = cont
    
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 8)
    c.Parent = lb
    
    y = y + 40
end

-- Build
lbl("👑 VIP", Color3.fromRGB(255, 215, 0))
btn("👑 Get VIP", Color3.fromRGB(255, 180, 0), vipBypass)

lbl("⚡ ADMIN", Color3.fromRGB(200, 0, 0))
local cmdBox = box("Command (god, fly, speed 100)")
btn("⚡ Run Command", Color3.fromRGB(200, 50, 0), function()
    adminCmd(cmdBox.Text)
end)
btn("🔑 Auto Admin", Color3.fromRGB(180, 0, 0), autoAdmin)

lbl("🏁 CHECKPOINT", Color3.fromRGB(0, 150, 255))
btn("🏁 Skip CP", Color3.fromRGB(0, 180, 255), skipCP)
btn("🚀 TP Summit", Color3.fromRGB(0, 150, 200), tpSummit)

lbl("✨ COSMETICS", Color3.fromRGB(150, 0, 255))
btn("✨ Unlock Auras", Color3.fromRGB(150, 100, 255), unlockAura)
btn("👑 Unlock Titles", Color3.fromRGB(255, 150, 0), unlockTitle)
btn("🎨 Unlock Accessories", Color3.fromRGB(200, 100, 255), unlockAcc)

lbl("😈 TROLL", Color3.fromRGB(150, 0, 0))
local plrBox = box("Player name")
btn("💥 Crash Player", Color3.fromRGB(200, 0, 0), function()
    crashPlayer(plrBox.Text)
end)

cont.CanvasSize = UDim2.new(0, 0, 0, y + 20)

notif("🔥 Ready!")
print("=== EXPLOIT LOADED ===")
print("Game: Mount Yayakin")
print("======================")
