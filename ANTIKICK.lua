-- ULTIMATE HUB - LAYOUT FIXED
-- Button tidak ketumpuk!
-- Clean layout, easy to use

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
local loopDeleteRunning = false

local flyBV, flyBG
local noclipConnection
local loopDeleteConnection

-- ============================================
-- FUNCTIONS
-- ============================================

local function notif(msg)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Ultimate Hub";
            Text = msg;
            Duration = 2.5;
        })
    end)
    print("[Hub]", msg)
end

local function scanRemotes()
    remotes = {}
    for _, service in pairs(game:GetChildren()) do
        pcall(function()
            for _, obj in pairs(service:GetDescendants()) do
                if obj:IsA("RemoteEvent") then
                    table.insert(remotes, obj)
                end
            end
        end)
    end
    notif("Ditemukan " .. #remotes .. " remotes!")
    return #remotes
end

local function deleteHover()
    if not mouse.Target then notif("❌ Tidak ada target!") return end
    local target = mouse.Target
    if #remotes == 0 then scanRemotes() end
    for _, remote in pairs(remotes) do
        pcall(function()
            remote:FireServer("Delete", target)
            remote:FireServer({Action = "Delete", Target = target})
        end)
    end
    notif("✅ Commands sent!")
end

local function deleteByName(name)
    if name == "" then notif("❌ Masukkan nama!") return end
    if #remotes == 0 then scanRemotes() end
    local count = 0
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Name:lower():find(name:lower()) then
            for _, remote in pairs(remotes) do
                pcall(function()
                    remote:FireServer("Delete", obj)
                end)
            end
            count = count + 1
            if count >= 50 then break end
        end
    end
    notif("✅ Sent " .. count .. " commands!")
end

local function massChaos(name)
    if name == "" then notif("❌ Masukkan nama!") return end
    if #remotes == 0 then scanRemotes() end
    local targets = {}
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Name:lower():find(name:lower()) then
            table.insert(targets, obj)
            if #targets >= 200 then break end
        end
    end
    for _, target in ipairs(targets) do
        for _, remote in pairs(remotes) do
            pcall(function()
                remote:FireServer("Delete", target)
            end)
        end
    end
    notif("✅ CHAOS! " .. #targets .. " parts!")
end

local function toggleLoopDelete(name)
    loopDeleteRunning = not loopDeleteRunning
    if loopDeleteRunning then
        loopDeleteConnection = RunService.Heartbeat:Connect(function()
            if not loopDeleteRunning then return end
            for _, obj in pairs(Workspace:GetDescendants()) do
                if obj:IsA("BasePart") and obj.Name:lower():find(name:lower()) then
                    pcall(function()
                        for i = 1, math.min(3, #remotes) do
                            remotes[i]:FireServer("Delete", obj)
                        end
                    end)
                end
            end
        end)
        notif("🔁 Loop ON")
    else
        if loopDeleteConnection then loopDeleteConnection:Disconnect() end
        notif("⏸️ Loop OFF")
    end
end

local function targetPlayer(name)
    if name == "" then notif("❌ Masukkan nama!") return end
    local target = Players:FindFirstChild(name)
    if not target then
        for _, plr in pairs(Players:GetPlayers()) do
            if plr.Name:lower():find(name:lower()) then target = plr break end
        end
    end
    if not target or not target.Character then notif("❌ Player tidak ditemukan!") return end
    if #remotes == 0 then scanRemotes() end
    for _, remote in pairs(remotes) do
        pcall(function()
            remote:FireServer("Teleport", target, Vector3.new(0, -999999, 0))
            remote:FireServer("Kill", target)
        end)
    end
    notif("✅ Player targeted!")
end

local function toggleFly()
    flying = not flying
    if flying then
        local char = player.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if not root then flying = false notif("❌ No character!") return end
        
        flyBV = Instance.new("BodyVelocity")
        flyBV.Velocity = Vector3.new(0, 0, 0)
        flyBV.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        flyBV.Parent = root
        
        flyBG = Instance.new("BodyGyro")
        flyBG.P = 9e4
        flyBG.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
        flyBG.CFrame = root.CFrame
        flyBG.Parent = root
        
        RunService.Heartbeat:Connect(function()
            if not flying then return end
            local cam = Workspace.CurrentCamera
            local moveDir = Vector3.new(0, 0, 0)
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + cam.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - cam.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - cam.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + cam.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0, 1, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveDir = moveDir - Vector3.new(0, 1, 0) end
            if flyBV and flyBV.Parent then flyBV.Velocity = moveDir * 50 end
            if flyBG and flyBG.Parent then flyBG.CFrame = cam.CFrame end
        end)
        notif("✈️ Fly ON")
    else
        if flyBV then flyBV:Destroy() end
        if flyBG then flyBG:Destroy() end
        notif("⏸️ Fly OFF")
    end
end

local function toggleNoclip()
    noclipping = not noclipping
    if noclipping then
        noclipConnection = RunService.Stepped:Connect(function()
            if not noclipping then return end
            local char = player.Character
            if char then
                for _, part in pairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then part.CanCollide = false end
                end
            end
        end)
        notif("👻 Noclip ON")
    else
        if noclipConnection then noclipConnection:Disconnect() end
        notif("⏸️ Noclip OFF")
    end
end

local function setSpeed(speed)
    local hum = player.Character and player.Character:FindFirstChild("Humanoid")
    if hum then hum.WalkSpeed = speed notif("🚀 Speed: " .. speed) end
end

local function setJump(power)
    local hum = player.Character and player.Character:FindFirstChild("Humanoid")
    if hum then hum.JumpPower = power notif("🦘 Jump: " .. power) end
end

local function godMode()
    local hum = player.Character and player.Character:FindFirstChild("Humanoid")
    if hum then hum.Health = math.huge hum.MaxHealth = math.huge notif("🛡️ God Mode!") end
end

local function listPlayers()
    print("=== PLAYERS ===")
    for i, plr in pairs(Players:GetPlayers()) do print(i .. ".", plr.Name) end
    notif("📋 Check F9")
end

local function findCP()
    print("=== CHECKPOINTS ===")
    local f = 0
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and (obj.Name:lower():find("checkpoint") or obj.Name:lower():find("cp")) then
            print(obj.Name) f = f + 1 if f >= 20 then break end
        end
    end
    notif("🔍 Found " .. f)
end

local function listParts()
    print("=== TOP PARTS ===")
    local parts = {}
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") then parts[obj.Name] = (parts[obj.Name] or 0) + 1 end
    end
    local sorted = {}
    for name, count in pairs(parts) do table.insert(sorted, {name = name, count = count}) end
    table.sort(sorted, function(a, b) return a.count > b.count end)
    for i = 1, math.min(20, #sorted) do print(i .. ".", sorted[i].name, "(" .. sorted[i].count .. "x)") end
    notif("📊 Check F9")
end

local function setTime(time)
    Lighting.ClockTime = time
    notif("🕐 Time: " .. time)
end

local function fullBright()
    Lighting.Brightness = 3
    Lighting.GlobalShadows = false
    Lighting.OutdoorAmbient = Color3.fromRGB(150, 150, 150)
    Lighting.FogEnd = 100000
    notif("☀️ Full Bright!")
end

-- ============================================
-- CREATE GUI (FIXED LAYOUT!)
-- ============================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "UltimateHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = playerGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 520, 0, 680)
MainFrame.Position = UDim2.new(0.5, -260, 0.5, -340)
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

local isHidden = false
HideBtn.MouseButton1Click:Connect(function()
    isHidden = not isHidden
    if isHidden then
        TweenService:Create(MainFrame, TweenInfo.new(0.3), {Size = UDim2.new(0, 520, 0, 50)}):Play()
        HideBtn.Text = "+"
    else
        TweenService:Create(MainFrame, TweenInfo.new(0.3), {Size = UDim2.new(0, 520, 0, 680)}):Play()
        HideBtn.Text = "−"
    end
end)

CloseBtn.MouseButton1Click:Connect(function()
    flying = false
    noclipping = false
    loopDeleteRunning = false
    ScreenGui:Destroy()
    notif("👋 Closed")
end)

-- Content
local Content = Instance.new("ScrollingFrame")
Content.Size = UDim2.new(1, -20, 1, -60)
Content.Position = UDim2.new(0, 10, 0, 55)
Content.BackgroundTransparency = 1
Content.ScrollBarThickness = 8
Content.CanvasSize = UDim2.new(0, 0, 0, 1600)
Content.Parent = MainFrame

-- GUI Builders (FIXED!)
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
    
    yPos = yPos + 42
end

local buttonRow = 0
local function makeButton(text, color, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.48, -5, 0, 45)
    btn.Position = UDim2.new((buttonRow % 2 == 0) and 0.02 or 0.52, 0, 0, yPos)
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
    
    buttonRow = buttonRow + 1
    if buttonRow % 2 == 0 then
        yPos = yPos + 52
    end
    
    return btn
end

local function makeTextBox(placeholder)
    -- Reset row for next section
    if buttonRow % 2 == 1 then
        yPos = yPos + 52
        buttonRow = buttonRow + 1
    end
    
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
    
    yPos = yPos + 48
    buttonRow = 0
    
    return box
end

-- Build GUI
makeLabel("🔍 SCAN & INFO", Color3.fromRGB(0, 120, 200))

makeButton("📡 Scan Remotes", Color3.fromRGB(0, 140, 220), scanRemotes)
makeButton("📋 List Players", Color3.fromRGB(100, 100, 200), listPlayers)
makeButton("🔍 Find CP", Color3.fromRGB(0, 160, 180), findCP)
makeButton("📊 List Parts", Color3.fromRGB(80, 140, 200), listParts)

makeLabel("🗑️ DELETE", Color3.fromRGB(200, 50, 50))

makeButton("⚡ Delete Hover", Color3.fromRGB(220, 60, 60), deleteHover)

local deleteInput = makeTextBox("Nama part...")

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

makeLabel("😈 TARGET PLAYER", Color3.fromRGB(150, 0, 200))

local playerInput = makeTextBox("Nama player...")

makeButton("😈 Target Player", Color3.fromRGB(180, 0, 180), function()
    targetPlayer(playerInput.Text)
end)

makeLabel("✈️ MOVEMENT", Color3.fromRGB(0, 150, 255))

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

makeLabel("🌅 LIGHTING", Color3.fromRGB(255, 180, 0))

makeButton("☀️ Day", Color3.fromRGB(255, 200, 0), function() setTime(14) end)
makeButton("🌙 Night", Color3.fromRGB(20, 20, 80), function() setTime(0) end)
makeButton("💡 Full Bright", Color3.fromRGB(255, 255, 0), fullBright)

-- Update canvas
Content.CanvasSize = UDim2.new(0, 0, 0, yPos + 50)

-- Auto scan
task.spawn(function()
    task.wait(1)
    local count = scanRemotes()
    notif("🔥 Loaded! " .. count .. " remotes!")
end)

print("================================")
print("ULTIMATE HUB - FIXED")
print("Layout: Clean, no overlap!")
print("PlaceId:", game.PlaceId)
print("================================")
