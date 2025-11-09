-- BACKDOOR EXPLOIT HUB - ADVANCED
-- Teleport Parts & Players via Backdoor Remotes

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- Clean old GUI
pcall(function()
    if player.PlayerGui:FindFirstChild("BackdoorHub") then
        player.PlayerGui.BackdoorHub:Destroy()
        task.wait(0.3)
    end
end)

-- ============================================
-- STRONG ANTI-CHEAT BYPASS
-- ============================================

-- Hook namecall untuk block AC
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    
    if method == "FireServer" or method == "InvokeServer" then
        local name = self.Name:lower()
        -- Block common anti-cheat remotes
        if name:find("ac") or name:find("anticheat") or name:find("kick") or 
           name:find("ban") or name:find("detect") or name:find("log") then
            return
        end
    end
    
    return oldNamecall(self, ...)
end))

-- Spoof __index untuk hide modifications
local oldIndex
oldIndex = hookmetamethod(game, "__index", newcclosure(function(self, key)
    if self:IsA("Humanoid") then
        if key == "WalkSpeed" and self.WalkSpeed > 16 then
            return 16
        end
        if key == "JumpPower" and self.JumpPower > 50 then
            return 50
        end
    end
    return oldIndex(self, key)
end))

-- ============================================
-- VARIABLES
-- ============================================

local remotes = {}
local hoveredPart = nil
local targetHeight = -1000

-- ============================================
-- CORE FUNCTIONS
-- ============================================

local function notify(text)
    game.StarterGui:SetCore("SendNotification", {
        Title = "🔥 Backdoor Hub";
        Text = text;
        Duration = 3;
    })
end

-- Scan all remotes
local function scanRemotes()
    remotes = {}
    for _, service in pairs(game:GetChildren()) do
        for _, obj in pairs(service:GetDescendants()) do
            if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
                table.insert(remotes, obj)
            end
        end
    end
    notify("Found " .. #remotes .. " remotes!")
    return #remotes
end

-- Teleport hovered part
local function teleportHoveredPart(height)
    if not hoveredPart then 
        notify("❌ No part selected! Hover mouse over a part")
        return 
    end
    
    if #remotes == 0 then scanRemotes() end
    
    local targetPos = Vector3.new(hoveredPart.Position.X, height, hoveredPart.Position.Z)
    local success = false
    
    -- Try multiple backdoor methods
    for _, remote in pairs(remotes) do
        pcall(function()
            if remote:IsA("RemoteEvent") then
                -- Method 1: Direct teleport command
                remote:FireServer("Teleport", hoveredPart, targetPos)
                remote:FireServer("SetPosition", hoveredPart, targetPos)
                remote:FireServer("MoveTo", hoveredPart, targetPos)
                
                -- Method 2: CFrame
                remote:FireServer("SetCFrame", hoveredPart, CFrame.new(targetPos))
                remote:FireServer({Action = "Teleport", Object = hoveredPart, Position = targetPos})
                
                -- Method 3: Property change
                remote:FireServer("ChangeProperty", hoveredPart, "Position", targetPos)
                remote:FireServer("ChangeProperty", hoveredPart, "CFrame", CFrame.new(targetPos))
                
                success = true
            end
        end)
    end
    
    if success then
        notify("✅ Teleported: " .. hoveredPart.Name .. " to Y=" .. height)
    else
        notify("⚠️ Commands sent, check if it worked")
    end
end

-- Teleport part by name
local function teleportPartByName(partName, height)
    if partName == "" then 
        notify("❌ Enter part name!")
        return 
    end
    
    if #remotes == 0 then scanRemotes() end
    
    local count = 0
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Name:lower():find(partName:lower()) then
            local targetPos = Vector3.new(obj.Position.X, height, obj.Position.Z)
            
            for _, remote in pairs(remotes) do
                pcall(function()
                    if remote:IsA("RemoteEvent") then
                        remote:FireServer("Teleport", obj, targetPos)
                        remote:FireServer("SetPosition", obj, targetPos)
                        remote:FireServer({Action = "Teleport", Object = obj, Position = targetPos})
                    end
                end)
            end
            
            count = count + 1
            if count >= 50 then break end
        end
    end
    
    notify("✅ Teleported " .. count .. " parts named '" .. partName .. "'")
end

-- Teleport player
local function teleportPlayer(playerName, height)
    if playerName == "" then 
        notify("❌ Enter player name!")
        return 
    end
    
    local targetPlayer = nil
    for _, plr in pairs(Players:GetPlayers()) do
        if plr.Name:lower():find(playerName:lower()) then
            targetPlayer = plr
            break
        end
    end
    
    if not targetPlayer then
        notify("❌ Player not found!")
        return
    end
    
    if not targetPlayer.Character or not targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
        notify("❌ Player has no character!")
        return
    end
    
    if #remotes == 0 then scanRemotes() end
    
    local root = targetPlayer.Character.HumanoidRootPart
    local targetPos = Vector3.new(root.Position.X, height, root.Position.Z)
    
    for _, remote in pairs(remotes) do
        pcall(function()
            if remote:IsA("RemoteEvent") then
                -- Try player-specific teleport
                remote:FireServer("TeleportPlayer", targetPlayer, targetPos)
                remote:FireServer("MovePlayer", targetPlayer, targetPos)
                remote:FireServer({Action = "TeleportPlayer", Player = targetPlayer, Position = targetPos})
                
                -- Try character teleport
                remote:FireServer("Teleport", root, targetPos)
                remote:FireServer("SetPosition", root, targetPos)
                remote:FireServer({Action = "Teleport", Object = root, Position = targetPos})
            end
        end)
    end
    
    notify("✅ Teleported " .. targetPlayer.Name .. " to Y=" .. height)
end

-- Kill player (teleport to void)
local function killPlayer(playerName)
    teleportPlayer(playerName, -999999)
end

-- Bring player to you
local function bringPlayer(playerName)
    if playerName == "" then 
        notify("❌ Enter player name!")
        return 
    end
    
    local targetPlayer = nil
    for _, plr in pairs(Players:GetPlayers()) do
        if plr.Name:lower():find(playerName:lower()) then
            targetPlayer = plr
            break
        end
    end
    
    if not targetPlayer or not targetPlayer.Character then
        notify("❌ Player not found!")
        return
    end
    
    local myRoot = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not myRoot then
        notify("❌ Your character not found!")
        return
    end
    
    if #remotes == 0 then scanRemotes() end
    
    local targetRoot = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
    local myPos = myRoot.Position + Vector3.new(0, 0, 5)
    
    for _, remote in pairs(remotes) do
        pcall(function()
            if remote:IsA("RemoteEvent") then
                remote:FireServer("TeleportPlayer", targetPlayer, myPos)
                remote:FireServer("Teleport", targetRoot, myPos)
                remote:FireServer({Action = "Teleport", Object = targetRoot, Position = myPos})
            end
        end)
    end
    
    notify("✅ Brought " .. targetPlayer.Name .. " to you!")
end

-- List all players
local function listPlayers()
    print("=== PLAYERS IN SERVER ===")
    for i, plr in pairs(Players:GetPlayers()) do
        print(i .. ".", plr.Name, "-", plr.DisplayName)
    end
    notify("📋 Check F9 console")
end

-- ============================================
-- GUI CREATION
-- ============================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BackdoorHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = player.PlayerGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 480, 0, 650)
MainFrame.Position = UDim2.new(0.5, -240, 0.5, -325)
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
Header.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
Header.BorderSizePixel = 0
Header.Parent = MainFrame

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 12)
HeaderCorner.Parent = Header

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -60, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "🔥 BACKDOOR EXPLOIT HUB"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 45, 0, 45)
CloseBtn.Position = UDim2.new(1, -50, 0, 2.5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 20
CloseBtn.Parent = Header

local CloseBtnCorner = Instance.new("UICorner")
CloseBtnCorner.CornerRadius = UDim.new(0, 10)
CloseBtnCorner.Parent = CloseBtn

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
    notify("👋 Hub closed")
end)

-- Content
local Content = Instance.new("ScrollingFrame")
Content.Size = UDim2.new(1, -20, 1, -60)
Content.Position = UDim2.new(0, 10, 0, 55)
Content.BackgroundTransparency = 1
Content.ScrollBarThickness = 6
Content.CanvasSize = UDim2.new(0, 0, 0, 0)
Content.Parent = MainFrame

local Layout = Instance.new("UIListLayout")
Layout.Padding = UDim.new(0, 8)
Layout.Parent = Content

-- UI Builders
local function createSection(text, color)
    local section = Instance.new("TextLabel")
    section.Size = UDim2.new(1, -10, 0, 35)
    section.BackgroundColor3 = color
    section.Text = text
    section.TextColor3 = Color3.fromRGB(255, 255, 255)
    section.Font = Enum.Font.GothamBold
    section.TextSize = 15
    section.Parent = Content
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = section
end

local function createButton(text, color, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 42)
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
    
    return btn
end

local function createTextBox(placeholder)
    local box = Instance.new("TextBox")
    box.Size = UDim2.new(1, -10, 0, 38)
    box.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    box.Text = ""
    box.PlaceholderText = placeholder
    box.TextColor3 = Color3.fromRGB(255, 255, 255)
    box.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
    box.Font = Enum.Font.Gotham
    box.TextSize = 13
    box.Parent = Content
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = box
    
    return box
end

-- ============================================
-- BUILD INTERFACE
-- ============================================

createSection("🔍 SCAN", Color3.fromRGB(0, 120, 200))

createButton("📡 Scan All Remotes", Color3.fromRGB(0, 140, 220), scanRemotes)

createButton("📋 List Players", Color3.fromRGB(100, 100, 200), listPlayers)

createSection("📦 TELEPORT PARTS", Color3.fromRGB(200, 50, 50))

local hoverLabel = Instance.new("TextLabel")
hoverLabel.Size = UDim2.new(1, -10, 0, 30)
hoverLabel.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
hoverLabel.Text = "Hovered: None"
hoverLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
hoverLabel.Font = Enum.Font.Gotham
hoverLabel.TextSize = 12
hoverLabel.Parent = Content

local hoverCorner = Instance.new("UICorner")
hoverCorner.CornerRadius = UDim.new(0, 6)
hoverCorner.Parent = hoverLabel

local heightBox = createTextBox("Height (Y position, default: -1000)")

createButton("⚡ TP Hovered Part", Color3.fromRGB(220, 60, 60), function()
    local height = tonumber(heightBox.Text) or -1000
    teleportHoveredPart(height)
end)

local partNameBox = createTextBox("Part name to teleport...")

createButton("📦 TP Parts by Name", Color3.fromRGB(200, 40, 40), function()
    local height = tonumber(heightBox.Text) or -1000
    teleportPartByName(partNameBox.Text, height)
end)

createSection("👤 TELEPORT PLAYERS", Color3.fromRGB(150, 0, 200))

local playerNameBox = createTextBox("Player name...")

createButton("🚀 TP Player to Height", Color3.fromRGB(180, 0, 180), function()
    local height = tonumber(heightBox.Text) or -1000
    teleportPlayer(playerNameBox.Text, height)
end)

createButton("💀 Kill Player (TP to void)", Color3.fromRGB(150, 0, 0), function()
    killPlayer(playerNameBox.Text)
end)

createButton("🎯 Bring Player to You", Color3.fromRGB(100, 0, 200), function()
    bringPlayer(playerNameBox.Text)
end)

-- Update canvas
Content.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y + 10)

-- ============================================
-- HOVER DETECTION
-- ============================================

RunService.RenderStepped:Connect(function()
    hoveredPart = mouse.Target
    if hoveredPart and hoveredPart:IsA("BasePart") then
        hoverLabel.Text = "Hovered: " .. hoveredPart.Name .. " (Y: " .. math.floor(hoveredPart.Position.Y) .. ")"
        hoverLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
    else
        hoverLabel.Text = "Hovered: None (Point at a part)"
        hoverLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
    end
end)

-- ============================================
-- AUTO SCAN
-- ============================================

task.spawn(function()
    task.wait(1)
    scanRemotes()
    notify("✅ Hub loaded! Hover mouse over parts to select them")
end)

print("================================")
print("BACKDOOR EXPLOIT HUB")
print("✅ Strong AC Bypass Active")
print("PlaceId:", game.PlaceId)
print("================================")
