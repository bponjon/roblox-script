-- SMART BACKDOOR FINDER & EXPLOITER
-- Auto-detect working backdoor methods

task.wait(1)

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- Clean old GUI
pcall(function()
    if player.PlayerGui:FindFirstChild("SmartBackdoor") then
        player.PlayerGui.SmartBackdoor:Destroy()
        task.wait(0.3)
    end
end)

-- ============================================
-- VARIABLES
-- ============================================

local remotes = {}
local workingRemotes = {}
local hoveredPart = nil
local testMode = false

-- ============================================
-- NOTIFICATION
-- ============================================

local function notify(text)
    pcall(function()
        game.StarterGui:SetCore("SendNotification", {
            Title = "🔥 Smart Backdoor";
            Text = text;
            Duration = 3;
        })
    end)
    print("[Backdoor]", text)
end

-- ============================================
-- REMOTE SCANNING
-- ============================================

local function scanRemotes()
    remotes = {}
    
    -- Scan all services
    local services = {
        ReplicatedStorage,
        Workspace,
        game:GetService("Lighting"),
        game:GetService("SoundService")
    }
    
    for _, service in pairs(services) do
        pcall(function()
            for _, obj in pairs(service:GetDescendants()) do
                if obj:IsA("RemoteEvent") then
                    table.insert(remotes, obj)
                end
            end
        end)
    end
    
    notify("Found " .. #remotes .. " RemoteEvents!")
    
    -- Print suspicious remotes
    print("=== SUSPICIOUS REMOTES ===")
    for i, remote in pairs(remotes) do
        local name = remote.Name:lower()
        -- Look for common backdoor names
        if name:find("event") or name:find("remote") or name:find("server") or 
           name:find("handler") or name:find("command") or name:find("manage") then
            print("🔥", remote.Name, "in", remote.Parent.Name)
        end
    end
    
    return #remotes
end

-- ============================================
-- BACKDOOR TESTING
-- ============================================

-- Test if a remote can teleport parts
local function testRemoteForPartTP(remote, testPart)
    if not testPart then return false end
    
    local originalPos = testPart.Position
    local testPos = originalPos + Vector3.new(0, 5, 0)
    
    -- Common backdoor patterns for part teleportation
    local patterns = {
        -- Pattern 1: Direct arguments
        function() remote:FireServer(testPart, testPos) end,
        function() remote:FireServer(testPart, testPos.X, testPos.Y, testPos.Z) end,
        function() remote:FireServer(testPart, CFrame.new(testPos)) end,
        
        -- Pattern 2: With command string
        function() remote:FireServer("Position", testPart, testPos) end,
        function() remote:FireServer("SetPosition", testPart, testPos) end,
        function() remote:FireServer("Teleport", testPart, testPos) end,
        function() remote:FireServer("MoveTo", testPart, testPos) end,
        function() remote:FireServer("Move", testPart, testPos) end,
        function() remote:FireServer("TP", testPart, testPos) end,
        
        -- Pattern 3: Table format
        function() remote:FireServer({Part = testPart, Position = testPos}) end,
        function() remote:FireServer({Object = testPart, Pos = testPos}) end,
        function() remote:FireServer({Target = testPart, NewPosition = testPos}) end,
        function() remote:FireServer({Action = "Teleport", Part = testPart, Pos = testPos}) end,
        function() remote:FireServer({Command = "Move", Object = testPart, Position = testPos}) end,
        
        -- Pattern 4: CFrame methods
        function() remote:FireServer("CFrame", testPart, CFrame.new(testPos)) end,
        function() remote:FireServer("SetCFrame", testPart, CFrame.new(testPos)) end,
        
        -- Pattern 5: Property change
        function() remote:FireServer("ChangeProperty", testPart, "Position", testPos) end,
        function() remote:FireServer("SetProperty", testPart, "Position", testPos) end,
    }
    
    for _, pattern in pairs(patterns) do
        pcall(pattern)
    end
    
    -- Check if position changed
    task.wait(0.1)
    local moved = (testPart.Position - originalPos).Magnitude > 1
    
    if moved then
        return true
    end
    
    return false
end

-- Test if remote can teleport players
local function testRemoteForPlayerTP(remote)
    local char = player.Character
    if not char then return false end
    
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return false end
    
    local originalPos = root.Position
    local testPos = originalPos + Vector3.new(0, 5, 0)
    
    local patterns = {
        -- Player-based
        function() remote:FireServer(player, testPos) end,
        function() remote:FireServer("TeleportPlayer", player, testPos) end,
        function() remote:FireServer({Player = player, Position = testPos}) end,
        
        -- Character-based
        function() remote:FireServer(root, testPos) end,
        function() remote:FireServer("Teleport", root, testPos) end,
        function() remote:FireServer({Part = root, Position = testPos}) end,
    }
    
    for _, pattern in pairs(patterns) do
        pcall(pattern)
    end
    
    task.wait(0.1)
    local moved = (root.Position - originalPos).Magnitude > 1
    
    return moved
end

-- Smart test all remotes
local function findWorkingBackdoors()
    if #remotes == 0 then
        notify("Scan remotes first!")
        return
    end
    
    notify("🔍 Testing " .. #remotes .. " remotes...")
    workingRemotes = {}
    
    -- Find a small test part
    local testPart = nil
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Size.Magnitude < 20 and obj.Name ~= "Baseplate" then
            testPart = obj
            break
        end
    end
    
    if not testPart then
        notify("❌ No test part found!")
        return
    end
    
    print("Testing with part:", testPart.Name)
    
    -- Test each remote
    for i, remote in pairs(remotes) do
        pcall(function()
            if testRemoteForPartTP(remote, testPart) then
                table.insert(workingRemotes, {
                    remote = remote,
                    type = "part"
                })
                print("✅ WORKING:", remote.Name, "- Part TP")
            end
        end)
        
        if i % 10 == 0 then
            task.wait(0.1) -- Prevent lag
        end
    end
    
    notify("✅ Found " .. #workingRemotes .. " working backdoors!")
    
    if #workingRemotes > 0 then
        print("=== WORKING BACKDOORS ===")
        for i, data in pairs(workingRemotes) do
            print(i .. ".", data.remote.Name, "(" .. data.type .. ")")
        end
    else
        notify("⚠️ No backdoors found - game might be secure")
    end
end

-- ============================================
-- EXPLOIT FUNCTIONS
-- ============================================

local function exploitTPPart(part, height)
    if not part then
        notify("❌ No part selected!")
        return
    end
    
    if #workingRemotes == 0 then
        notify("⚠️ No working backdoors! Test first")
        -- Try anyway with all remotes
        if #remotes == 0 then scanRemotes() end
    end
    
    local targetPos = Vector3.new(part.Position.X, height, part.Position.Z)
    
    -- Use working remotes first
    for _, data in pairs(workingRemotes) do
        pcall(function()
            data.remote:FireServer(part, targetPos)
            data.remote:FireServer("Teleport", part, targetPos)
            data.remote:FireServer({Part = part, Position = targetPos})
        end)
    end
    
    -- Fallback: try all remotes
    for _, remote in pairs(remotes) do
        pcall(function()
            remote:FireServer(part, targetPos)
            remote:FireServer("Teleport", part, targetPos)
            remote:FireServer("SetPosition", part, targetPos)
            remote:FireServer({Action = "Teleport", Target = part, Pos = targetPos})
        end)
    end
    
    notify("✅ Sent TP for: " .. part.Name)
end

local function exploitTPPartsByName(name, height)
    if name == "" then
        notify("❌ Enter part name!")
        return
    end
    
    local count = 0
    for _, obj in pairs(Workspace:GetDescendants()) do
        pcall(function()
            if obj:IsA("BasePart") and obj.Name:lower():find(name:lower()) then
                exploitTPPart(obj, height)
                count = count + 1
            end
        end)
        
        if count >= 100 then break end
    end
    
    notify("✅ Teleported " .. count .. " parts")
end

local function exploitTPPlayer(name, height)
    if name == "" then
        notify("❌ Enter player name!")
        return
    end
    
    local target = nil
    for _, plr in pairs(Players:GetPlayers()) do
        if plr.Name:lower():find(name:lower()) then
            target = plr
            break
        end
    end
    
    if not target or not target.Character then
        notify("❌ Player not found!")
        return
    end
    
    local root = target.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    
    local pos = Vector3.new(root.Position.X, height, root.Position.Z)
    
    -- Try all methods
    for _, remote in pairs(remotes) do
        pcall(function()
            remote:FireServer(target, pos)
            remote:FireServer(root, pos)
            remote:FireServer("TeleportPlayer", target, pos)
            remote:FireServer("Teleport", root, pos)
            remote:FireServer({Player = target, Position = pos})
            remote:FireServer({Part = root, Position = pos})
        end)
    end
    
    notify("✅ Sent TP for: " .. target.Name)
end

local function exploitBring(name)
    local myRoot = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not myRoot then
        notify("❌ Your character not found!")
        return
    end
    
    exploitTPPlayer(name, myRoot.Position.Y)
end

-- ============================================
-- GUI CREATION
-- ============================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SmartBackdoor"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = player.PlayerGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 500, 0, 650)
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -325)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

-- Header
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 50)
Header.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
Header.BorderSizePixel = 0
Header.Parent = MainFrame

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 12)
HeaderCorner.Parent = Header

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -110, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "🔥 SMART BACKDOOR"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 19
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local HideBtn = Instance.new("TextButton")
HideBtn.Size = UDim2.new(0, 50, 0, 45)
HideBtn.Position = UDim2.new(1, -105, 0, 2.5)
HideBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
HideBtn.Text = "−"
HideBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
HideBtn.Font = Enum.Font.GothamBold
HideBtn.TextSize = 28
HideBtn.Parent = Header

local HideBtnCorner = Instance.new("UICorner")
HideBtnCorner.CornerRadius = UDim.new(0, 10)
HideBtnCorner.Parent = HideBtn

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 50, 0, 45)
CloseBtn.Position = UDim2.new(1, -52, 0, 2.5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 20
CloseBtn.Parent = Header

local CloseBtnCorner = Instance.new("UICorner")
CloseBtnCorner.CornerRadius = UDim.new(0, 10)
CloseBtnCorner.Parent = CloseBtn

-- Hide functionality
local isHidden = false
HideBtn.MouseButton1Click:Connect(function()
    isHidden = not isHidden
    TweenService:Create(MainFrame, TweenInfo.new(0.3), {
        Size = isHidden and UDim2.new(0, 500, 0, 50) or UDim2.new(0, 500, 0, 650)
    }):Play()
    HideBtn.Text = isHidden and "+" or "−"
end)

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Content
local Content = Instance.new("ScrollingFrame")
Content.Size = UDim2.new(1, -20, 1, -60)
Content.Position = UDim2.new(0, 10, 0, 55)
Content.BackgroundTransparency = 1
Content.ScrollBarThickness = 6
Content.ScrollBarImageColor3 = Color3.fromRGB(255, 50, 50)
Content.BorderSizePixel = 0
Content.CanvasSize = UDim2.new(0, 0, 0, 0)
Content.Parent = MainFrame

local Layout = Instance.new("UIListLayout")
Layout.Padding = UDim.new(0, 8)
Layout.Parent = Content

Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    Content.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y + 10)
end)

-- UI Builders
local function section(text, color)
    local s = Instance.new("TextLabel")
    s.Size = UDim2.new(1, -10, 0, 35)
    s.BackgroundColor3 = color
    s.Text = text
    s.TextColor3 = Color3.fromRGB(255, 255, 255)
    s.Font = Enum.Font.GothamBold
    s.TextSize = 15
    s.Parent = Content
    
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 8)
    c.Parent = s
end

local function button(text, color, callback)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -10, 0, 42)
    b.BackgroundColor3 = color
    b.Text = text
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 13
    b.TextWrapped = true
    b.Parent = Content
    
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 8)
    c.Parent = b
    
    b.MouseButton1Click:Connect(function()
        pcall(callback)
    end)
    
    return b
end

local function textbox(placeholder)
    local t = Instance.new("TextBox")
    t.Size = UDim2.new(1, -10, 0, 38)
    t.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    t.Text = ""
    t.PlaceholderText = placeholder
    t.TextColor3 = Color3.fromRGB(255, 255, 255)
    t.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
    t.Font = Enum.Font.Gotham
    t.TextSize = 13
    t.ClearTextOnFocus = false
    t.Parent = Content
    
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 8)
    c.Parent = t
    
    return t
end

-- ============================================
-- BUILD INTERFACE
-- ============================================

section("🔍 STEP 1: SCAN & TEST", Color3.fromRGB(0, 120, 200))

button("📡 Scan All Remotes", Color3.fromRGB(0, 140, 220), scanRemotes)

button("🧪 Test & Find Working Backdoors", Color3.fromRGB(200, 100, 0), findWorkingBackdoors)

section("📦 STEP 2: TELEPORT PARTS", Color3.fromRGB(200, 50, 50))

local hoverLabel = Instance.new("TextLabel")
hoverLabel.Size = UDim2.new(1, -10, 0, 32)
hoverLabel.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
hoverLabel.Text = "Hover: None"
hoverLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
hoverLabel.Font = Enum.Font.Gotham
hoverLabel.TextSize = 12
hoverLabel.Parent = Content

local hc = Instance.new("UICorner")
hc.CornerRadius = UDim.new(0, 6)
hc.Parent = hoverLabel

local heightBox = textbox("Height (Y), default: -1000")

button("⚡ TP Hovered Part", Color3.fromRGB(220, 60, 60), function()
    local h = tonumber(heightBox.Text) or -1000
    exploitTPPart(hoveredPart, h)
end)

local partBox = textbox("Part name (checkpoint, stage, etc)")

button("📦 TP All Parts by Name", Color3.fromRGB(200, 40, 40), function()
    local h = tonumber(heightBox.Text) or -1000
    exploitTPPartsByName(partBox.Text, h)
end)

section("👤 STEP 3: TELEPORT PLAYERS", Color3.fromRGB(150, 0, 200))

local playerBox = textbox("Player name...")

button("🚀 TP Player to Height", Color3.fromRGB(180, 0, 180), function()
    local h = tonumber(heightBox.Text) or -1000
    exploitTPPlayer(playerBox.Text, h)
end)

button("💀 Kill Player (void)", Color3.fromRGB(150, 0, 0), function()
    exploitTPPlayer(playerBox.Text, -999999)
end)

button("🎯 Bring Player", Color3.fromRGB(100, 0, 200), function()
    exploitBring(playerBox.Text)
end)

-- ============================================
-- HOVER DETECTION
-- ============================================

RunService.RenderStepped:Connect(function()
    hoveredPart = mouse.Target
    if hoveredPart and hoveredPart:IsA("BasePart") then
        hoverLabel.Text = "Hover: " .. hoveredPart.Name .. " (Y:" .. math.floor(hoveredPart.Position.Y) .. ")"
        hoverLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
    else
        hoverLabel.Text = "Hover: None (point at part)"
        hoverLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
    end
end)

-- ============================================
-- AUTO START
-- ============================================

task.spawn(function()
    task.wait(1)
    scanRemotes()
    notify("✅ Ready! Press 'Test & Find' to auto-detect backdoors")
end)

print("================================")
print("SMART BACKDOOR EXPLOITER")
print("Auto-detects working methods!")
print("================================")
