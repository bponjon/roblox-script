-- PAKET LENGKAP ULTIMATE EXPLOIT
-- All features, Hide GUI, Bahasa Indonesia
-- Map vulnerable = HIGH SUCCESS RATE!

task.wait(2)

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui", 10)
local mouse = player:GetMouse()

-- Hapus GUI lama
pcall(function()
    if playerGui:FindFirstChild("UltimateHub") then
        playerGui.UltimateHub:Destroy()
        task.wait(0.5)
    end
end)

-- ============================================
-- VARIABLES
-- ============================================
local remotes = {}
local flying = false
local noclipping = false
local espEnabled = false
local autoFarmRunning = false
local loopDeleteRunning = false

local flySpeed = 50
local walkSpeed = 16
local jumpPower = 50

local flyBV, flyBG
local noclipConnection
local autoFarmConnection
local loopDeleteConnection

-- ============================================
-- NOTIFICATION
-- ============================================
local function notif(msg, durasi)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Ultimate Hub";
            Text = msg;
            Duration = durasi or 2.5;
        })
    end)
    print("[Ultimate]", msg)
end

-- ============================================
-- REMOTE SCANNER
-- ============================================
local function scanRemotes()
    remotes = {}
    notif("Memindai remotes...")
    
    for _, service in pairs(game:GetChildren()) do
        pcall(function()
            for _, obj in pairs(service:GetDescendants()) do
                if obj:IsA("RemoteEvent") then
                    table.insert(remotes, obj)
                end
            end
        end)
    end
    
    print("=== REMOTE SCAN ===")
    print("Total:", #remotes)
    for i = 1, math.min(10, #remotes) do
        print(i .. ".", remotes[i]:GetFullName())
    end
    print("===================")
    
    notif("Ditemukan " .. #remotes .. " remotes!", 3)
    return #remotes
end

-- ============================================
-- EXPLOIT FUNCTIONS
-- ============================================

-- Delete dengan hover
local function deleteHover()
    if not mouse.Target then
        notif("❌ Tidak ada target!")
        return
    end
    
    local target = mouse.Target
    notif("🎯 Target: " .. target.Name)
    
    if #remotes == 0 then scanRemotes() end
    
    for _, remote in pairs(remotes) do
        pcall(function()
            remote:FireServer("Delete", target)
            remote:FireServer("Remove", target)
            remote:FireServer("Destroy", target)
            remote:FireServer({Action = "Delete", Target = target})
            remote:FireServer({action = "delete", part = target})
            remote:FireServer("DeletePart", target)
            remote:FireServer({type = "destroy", object = target})
            remote:FireServer("Teleport", target, Vector3.new(0, -999999, 0))
        end)
    end
    
    notif("✅ Commands sent!")
end

-- Delete by name
local function deleteByName(name)
    if name == "" then
        notif("❌ Masukkan nama!")
        return
    end
    
    notif("🗑️ Menghapus: " .. name)
    
    if #remotes == 0 then scanRemotes() end
    
    local count = 0
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Name:lower():find(name:lower()) then
            for _, remote in pairs(remotes) do
                pcall(function()
                    remote:FireServer("Delete", obj)
                    remote:FireServer({Action = "Delete", Target = obj})
                    remote:FireServer("Destroy", obj)
                    remote:FireServer("Teleport", obj, Vector3.new(0, -999999, 0))
                end)
            end
            count = count + 1
            if count >= 50 then break end
        end
    end
    
    notif("✅ Sent " .. count .. " delete commands!")
end

-- Mass chaos
local function massChaos(name)
    if name == "" then
        notif("❌ Masukkan nama!")
        return
    end
    
    notif("💥 CHAOS MODE: " .. name, 4)
    
    if #remotes == 0 then scanRemotes() end
    
    local targets = {}
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Name:lower():find(name:lower()) then
            table.insert(targets, obj)
            if #targets >= 200 then break end
        end
    end
    
    notif("💣 Targeting " .. #targets .. " parts...")
    
    for _, target in ipairs(targets) do
        for _, remote in pairs(remotes) do
            pcall(function()
                remote:FireServer("Delete", target)
                remote:FireServer({Action = "Delete", Target = target})
                remote:FireServer("Teleport", target, Vector3.new(0, -999999, 0))
            end)
        end
    end
    
    notif("✅ CHAOS COMPLETE! Check results!", 5)
end

-- Loop delete
local function toggleLoopDelete(name)
    loopDeleteRunning = not loopDeleteRunning
    
    if loopDeleteRunning then
        notif("🔁 Loop Delete ON: " .. name, 3)
        
        loopDeleteConnection = RunService.Heartbeat:Connect(function()
            if not loopDeleteRunning then return end
            
            for _, obj in pairs(Workspace:GetDescendants()) do
                if obj:IsA("BasePart") and obj.Name:lower():find(name:lower()) then
                    pcall(function()
                        for i = 1, math.min(3, #remotes) do
                            remotes[i]:FireServer("Delete", obj)
                            remotes[i]:FireServer({Action = "Delete", Target = obj})
                        end
                    end)
                end
            end
        end)
    else
        notif("⏸️ Loop Delete OFF")
        if loopDeleteConnection then
            loopDeleteConnection:Disconnect()
        end
    end
end

-- Target player
local function targetPlayer(playerName)
    if playerName == "" then
        notif("❌ Masukkan nama player!")
        return
    end
    
    local target = Players:FindFirstChild(playerName)
    
    if not target then
        for _, plr in pairs(Players:GetPlayers()) do
            if plr.Name:lower():find(playerName:lower()) then
                target = plr
                break
            end
        end
    end
    
    if not target then
        notif("❌ Player tidak ditemukan!")
        return
    end
    
    if not target.Character then
        notif("❌ Character tidak ada!")
        return
    end
    
    notif("😈 Targeting: " .. target.Name, 3)
    
    if #remotes == 0 then scanRemotes() end
    
    for _, remote in pairs(remotes) do
        pcall(function()
            remote:FireServer("Teleport", target, Vector3.new(0, -999999, 0))
            remote:FireServer("TP", target, Vector3.new(0, -999999, 0))
            remote:FireServer({Action = "Teleport", Player = target, Position = Vector3.new(0, -999999, 0)})
            remote:FireServer("Kill", target)
            remote:FireServer({Action = "Kill", Player = target})
            remote:FireServer("Damage", target, 999999)
        end)
    end
    
    notif("✅ Player targeted!")
end

-- ============================================
-- MOVEMENT FUNCTIONS
-- ============================================

local function toggleFly()
    flying = not flying
    
    if flying then
        local char = player.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        
        if not root then
            flying = false
            notif("❌ Character not found!")
            return
        end
        
        flyBV = Instance.new("BodyVelocity")
        flyBV.Velocity = Vector3.new(0, 0, 0)
        flyBV.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        flyBV.Parent = root
        
        flyBG = Instance.new("BodyGyro")
        flyBG.P = 9e4
        flyBG.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
        flyBG.CFrame = root.CFrame
        flyBG.Parent = root
        
        notif("✈️ Fly ON (WASD + Space/Shift)", 3)
        
        RunService.Heartbeat:Connect(function()
            if not flying then return end
            
            local cam = Workspace.CurrentCamera
            local moveDir = Vector3.new(0, 0, 0)
            
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                moveDir = moveDir + cam.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                moveDir = moveDir - cam.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                moveDir = moveDir - cam.CFrame.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                moveDir = moveDir + cam.CFrame.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                moveDir = moveDir + Vector3.new(0, 1, 0)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                moveDir = moveDir - Vector3.new(0, 1, 0)
            end
            
            if flyBV and flyBV.Parent then
                flyBV.Velocity = moveDir * flySpeed
            end
            if flyBG and flyBG.Parent then
                flyBG.CFrame = cam.CFrame
            end
        end)
    else
        notif("⏸️ Fly OFF")
        if flyBV then flyBV:Destroy() end
        if flyBG then flyBG:Destroy() end
    end
end

local function toggleNoclip()
    noclipping = not noclipping
    
    if noclipping then
        notif("👻 Noclip ON", 3)
        
        noclipConnection = RunService.Stepped:Connect(function()
            if not noclipping then return end
            
            local char = player.Character
            if char then
                for _, part in pairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    else
        notif("⏸️ Noclip OFF")
        if noclipConnection then
            noclipConnection:Disconnect()
        end
    end
end

local function setSpeed(speed)
    walkSpeed = speed
    local hum = player.Character and player.Character:FindFirstChild("Humanoid")
    if hum then
        hum.WalkSpeed = speed
        notif("🚀 Speed: " .. speed)
    end
end

local function setJump(power)
    jumpPower = power
    local hum = player.Character and player.Character:FindFirstChild("Humanoid")
    if hum then
        hum.JumpPower = power
        notif("🦘 Jump: " .. power)
    end
end

local function godMode()
    local hum = player.Character and player.Character:FindFirstChild("Humanoid")
    if hum then
        hum.Health = math.huge
        hum.MaxHealth = math.huge
        notif("🛡️ God Mode ON", 3)
    end
end

-- ============================================
-- UTILITY FUNCTIONS
-- ============================================

local function listPlayers()
    print("=== PLAYERS ONLINE ===")
    for i, plr in pairs(Players:GetPlayers()) do
        print(i .. ".", plr.Name)
    end
    print("Total:", #Players:GetPlayers())
    print("======================")
    notif("📋 Check console (F9)")
end

local function findCheckpoints()
    print("=== CHECKPOINTS ===")
    local found = 0
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            local name = obj.Name:lower()
            if name:find("checkpoint") or name:find("cp") or name:find("base") then
                print(obj.Name, "|", obj:GetFullName())
                found = found + 1
                if found >= 20 then break end
            end
        end
    end
    print("Total:", found)
    print("===================")
    notif("🔍 Found " .. found .. " (F9)")
end

local function listParts()
    print("=== TOP PARTS ===")
    local parts = {}
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            parts[obj.Name] = (parts[obj.Name] or 0) + 1
        end
    end
    
    local sorted = {}
    for name, count in pairs(parts) do
        table.insert(sorted, {name = name, count = count})
    end
    table.sort(sorted, function(a, b) return a.count > b.count end)
    
    for i = 1, math.min(20, #sorted) do
        print(i .. ".", sorted[i].name, "(" .. sorted[i].count .. "x)")
    end
    print("=================")
    notif("📊 Check console (F9)")
end

-- ============================================
-- LIGHTING
-- ============================================

local function setTime(time)
    Lighting.ClockTime = time
    notif("🕐 Time: " .. time)
end

local function fullBright()
    Lighting.Brightness = 3
    Lighting.GlobalShadows = false
    Lighting.OutdoorAmbient = Color3.fromRGB(150, 150, 150)
    Lighting.FogEnd = 100000
    notif("☀️ Full Bright ON")
end

-- ============================================
-- CREATE GUI
-- ============================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "UltimateHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = playerGui

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 480, 0, 650)
MainFrame.Position = UDim2.new(0.5, -240, 0.5, -325)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 15)
MainCorner.Parent = MainFrame

-- Header
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 50)
Header.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
Header.BorderSizePixel = 0
Header.Parent = MainFrame

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 15)
HeaderCorner.Parent = Header

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -120, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "🔥 ULTIMATE HUB"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 22
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

-- Hide Button
local HideBtn = Instance.new("TextButton")
HideBtn.Size = UDim2.new(0, 50, 0, 45)
HideBtn.Position = UDim2.new(1, -110, 0, 2.5)
HideBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
HideBtn.Text = "−"
HideBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
HideBtn.Font = Enum.Font.GothamBold
HideBtn.TextSize = 30
HideBtn.Parent = Header

local HideBtnCorner = Instance.new("UICorner")
HideBtnCorner.CornerRadius = UDim.new(0, 10)
HideBtnCorner.Parent = HideBtn

-- Close Button
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 50, 0, 45)
CloseBtn.Position = UDim2.new(1, -55, 0, 2.5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 24
CloseBtn.Parent = Header

local CloseBtnCorner = Instance.new("UICorner")
CloseBtnCorner.CornerRadius = UDim.new(0, 10)
CloseBtnCorner.Parent = CloseBtn

-- Hide/Show functionality
local isHidden = false
HideBtn.MouseButton1Click:Connect(function()
    isHidden = not isHidden
    
    if isHidden then
        TweenService:Create(MainFrame, TweenInfo.new(0.3), {
            Size = UDim2.new(0, 480, 0, 50)
        }):Play()
        HideBtn.Text = "+"
    else
        TweenService:Create(MainFrame, TweenInfo.new(0.3), {
            Size = UDim2.new(0, 480, 0, 650)
        }):Play()
        HideBtn.Text = "−"
    end
end)

CloseBtn.MouseButton1Click:Connect(function()
    flying = false
    noclipping = false
    loopDeleteRunning = false
    ScreenGui:Destroy()
    notif("👋 GUI Closed")
end)

-- Content
local Content = Instance.new("ScrollingFrame")
Content.Size = UDim2.new(1, -20, 1, -60)
Content.Position = UDim2.new(0, 10, 0, 55)
Content.BackgroundTransparency = 1
Content.ScrollBarThickness = 8
Content.CanvasSize = UDim2.new(0, 0, 0, 1400)
Content.Parent = MainFrame

-- GUI Builders
local yPos = 10

local function makeLabel(text, color)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -10, 0, 35)
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
    
    yPos = yPos + 40
end

local function makeButton(text, color, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.48, -5, 0, 45)
    btn.Position = UDim2.new((yPos % 2 == 0) and 0.02 or 0.52, 0, 0, math.floor(yPos / 2) * 25 + yPos * 5)
    btn.BackgroundColor3 = color
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 13
    btn.TextWrapped = true
    btn.Parent = Content
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn
    
    btn.MouseButton1Click:Connect(function()
        pcall(callback)
    end)
    
    yPos = yPos + 1
    
    return btn
end

local function makeTextBox(placeholder)
    local box = Instance.new("TextBox")
    box.Size = UDim2.new(1, -10, 0, 40)
    box.Position = UDim2.new(0, 5, 0, yPos)
    box.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    box.Text = ""
    box.PlaceholderText = placeholder
    box.TextColor3 = Color3.fromRGB(255, 255, 255)
    box.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
    box.Font = Enum.Font.Gotham
    box.TextSize = 14
    box.Parent = Content
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = box
    
    yPos = yPos + 45
    return box
end

-- Build GUI
yPos = 10

makeLabel("🔍 SCAN & INFO", Color3.fromRGB(0, 120, 200))
yPos = yPos + 5

makeButton("📡 Scan Remotes", Color3.fromRGB(0, 140, 220), scanRemotes)
makeButton("📋 List Players", Color3.fromRGB(100, 100, 200), listPlayers)
makeButton("🔍 Find CP", Color3.fromRGB(0, 160, 180), findCheckpoints)
makeButton("📊 List Parts", Color3.fromRGB(80, 140, 200), listParts)

yPos = yPos + 50

makeLabel("🗑️ DELETE FUNCTIONS", Color3.fromRGB(200, 50, 50))
yPos = yPos + 5

makeButton("⚡ Delete Hover", Color3.fromRGB(220, 60, 60), deleteHover)

local deleteInput = makeTextBox("Nama part untuk delete...")

makeButton("🗑️ Delete by Name", Color3.fromRGB(200, 40, 40), function()
    deleteByName(deleteInput.Text)
end)

makeButton("💥 Mass Chaos", Color3.fromRGB(180, 0, 0), function()
    massChaos(deleteInput.Text)
end)

local loopBtn = makeButton("🔁 Loop Delete", Color3.fromRGB(150, 0, 50), function()
    toggleLoopDelete(deleteInput.Text)
    loopBtn.Text = loopDeleteRunning and "⏸️ Stop Loop" or "🔁 Loop Delete"
end)

yPos = yPos + 50

makeLabel("😈 TARGET PLAYER", Color3.fromRGB(150, 0, 200))
yPos = yPos + 5

local playerInput = makeTextBox("Nama player...")

makeButton("😈 Target Player", Color3.fromRGB(180, 0, 180), function()
    targetPlayer(playerInput.Text)
end)

yPos = yPos + 50

makeLabel("✈️ MOVEMENT", Color3.fromRGB(0, 150, 255))
yPos = yPos + 5

local flyBtn = makeButton("✈️ Fly", Color3.fromRGB(0, 160, 255), function()
    toggleFly()
    flyBtn.Text = flying and "⏸️ Stop Fly" or "✈️ Fly"
end)

local noclipBtn = makeButton("👻 Noclip", Color3.fromRGB(150, 0, 255), function()
    toggleNoclip()
    noclipBtn.Text = noclipping and "⏸️ Stop Noclip" or "👻 Noclip"
end)

makeButton("🚀 Speed 100", Color3.fromRGB(255, 140, 0), function() setSpeed(100) end)
makeButton("🚀 Speed 200", Color3.fromRGB(255, 100, 0), function() setSpeed(200) end)
makeButton("🦘 Jump 150", Color3.fromRGB(0, 255, 100), function() setJump(150) end)
makeButton("🛡️ God Mode", Color3.fromRGB(255, 215, 0), godMode)

yPos = yPos + 50

makeLabel("🌅 LIGHTING", Color3.fromRGB(255, 180, 0))
yPos = yPos + 5

makeButton("☀️ Day", Color3.fromRGB(255, 200, 0), function() setTime(14) end)
makeButton("🌙 Night", Color3.fromRGB(20, 20, 80), function() setTime(0) end)
makeButton("💡 Full Bright", Color3.fromRGB(255, 255, 0), fullBright)

-- Info
yPos = Content.CanvasSize.Y.Offset

local info = Instance.new("TextLabel")
info.Size = UDim2.new(1, -10, 0, 200)
info.Position = UDim2.new(0, 5, 0, yPos - 200)
info.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
info.TextColor3 = Color3.fromRGB(230, 230, 230)
info.Font = Enum.Font.Gotham
info.TextSize = 12
info.TextWrapped = true
info.TextYAlignment = Enum.TextYAlignment.Top
info.Text = [[🔥 ULTIMATE HUB - PAKET LENGKAP

✅ FITUR:
• Scan remotes & info
• Delete hover/name/mass
• Loop delete (anti-respawn)
• Target player
• Fly, noclip, speed, jump
• God mode
• Lighting control
• Hide GUI (tombol −)

🎯 CARA PAKAI:
1. Scan remotes dulu!
2. Hover & delete atau input nama
3. Mass chaos = rusak banyak
4. Loop delete = permanent
5. Target player = evil mode

⚠️ TIPS:
Map vulnerable = work 90%!
Test satu-satu dulu!
Hide GUI dengan tombol −

PlaceId: ]] .. game.PlaceId .. [[

🚀 Status: READY!]]
info.Parent = Content

local infoPadding = Instance.new("UIPadding")
infoPadding.PaddingTop = UDim.new(0, 10)
infoPadding.PaddingLeft = UDim.new(0, 10)
infoPadding.PaddingRight = UDim.new(0, 10)
infoPadding.Parent = info

local infoCorner = Instance.new("UICorner")
infoCorner.CornerRadius = UDim.new(0, 8)
infoCorner.Parent = info

-- Auto scan on load
task.spawn(function()
    task.wait(1)
    local count = scanRemotes()
    notif("🔥 Hub loaded! " .. count .. " remotes found!", 4)
end)

print("================================")
print("ULTIMATE HUB - PAKET LENGKAP")
print("PlaceId:", game.PlaceId)
print("Auto-scanning remotes...")
print("================================")
