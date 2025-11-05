-- BRUTAL EXPLOIT - FIXED & ENHANCED VERSION
-- Compatible: PC & Mobile (Delta, Arceus X, KRNL, Fluxus)
-- Works: All mountain games + universal

task.wait(2)

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui", 10)

if not playerGui then
    warn("PlayerGui not found!")
    return
end

-- Remove old GUI
if playerGui:FindFirstChild("BrutalExploit") then
    playerGui.BrutalExploit:Destroy()
    task.wait(0.5)
end

-- ============================================
-- NOTIFICATION SYSTEM
-- ============================================
local function notif(msg, success)
    local icon = success and "✅" or (success == false and "❌" or "⚡")
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Brutal Exploit";
            Text = icon .. " " .. msg;
            Duration = 2.5;
        })
    end)
    print("[Brutal]", msg)
end

-- Get mouse safely
local mouse
pcall(function()
    mouse = player:GetMouse()
end)

-- ============================================
-- REMOTE SCANNER (SERVER-SIDE ATTEMPTS)
-- ============================================
local remoteEvents = {}

local function scanRemotes()
    remoteEvents = {}
    notif("Scanning RemoteEvents...", nil)
    
    -- Scan ReplicatedStorage
    for _, obj in pairs(ReplicatedStorage:GetDescendants()) do
        if obj:IsA("RemoteEvent") then
            table.insert(remoteEvents, obj)
        end
    end
    
    -- Scan Workspace
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("RemoteEvent") then
            table.insert(remoteEvents, obj)
        end
    end
    
    notif("Found " .. #remoteEvents .. " RemoteEvents!", #remoteEvents > 0)
    
    print("=== REMOTE EVENTS FOUND ===")
    for i, remote in pairs(remoteEvents) do
        print(i .. ".", remote:GetFullName())
    end
    print("===========================")
end

-- ============================================
-- SERVER-SIDE EXPLOIT ATTEMPTS
-- ============================================

local function tryServerDelete(part)
    if not part then return end
    
    notif("SERVER: Trying to delete " .. part.Name, nil)
    
    local success = false
    for _, remote in pairs(remoteEvents) do
        pcall(function()
            -- Try various delete patterns
            remote:FireServer("Delete", part)
            remote:FireServer("Remove", part)
            remote:FireServer("Destroy", part)
            remote:FireServer({Action = "Delete", Target = part})
            remote:FireServer({action = "delete", part = part})
            remote:FireServer("DeletePart", part)
            remote:FireServer(part, "Delete")
            remote:FireServer("RemovePart", part)
            success = true
        end)
    end
    
    if success then
        notif("Delete commands sent to server!", true)
    else
        notif("No remotes to exploit", false)
    end
end

local function tryServerEdit(part, property, value)
    if not part then return end
    
    notif("SERVER: Trying to edit " .. part.Name, nil)
    
    for _, remote in pairs(remoteEvents) do
        pcall(function()
            remote:FireServer("Edit", part, property, value)
            remote:FireServer("Change", part, property, value)
            remote:FireServer("SetProperty", part, property, value)
            remote:FireServer({Action = "Edit", Target = part, Property = property, Value = value})
        end)
    end
    
    notif("Edit commands sent!", true)
end

local function tryServerLighting(property, value)
    notif("SERVER: Trying to change lighting...", nil)
    
    for _, remote in pairs(remoteEvents) do
        pcall(function()
            remote:FireServer("SetTime", value)
            remote:FireServer("ChangeTime", value)
            remote:FireServer("Lighting", property, value)
            remote:FireServer({Action = "Lighting", Property = property, Value = value})
        end)
    end
    
    notif("Lighting commands sent!", true)
end

-- ============================================
-- CLIENT-SIDE METHODS (100% WORK)
-- ============================================

local function clientDelete(partName)
    notif("CLIENT: Deleting " .. partName, nil)
    
    local count = 0
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            local match = partName == "all" or obj.Name:lower():find(partName:lower())
            
            if match then
                -- Skip characters
                local isChar = false
                for _, p in pairs(Players:GetPlayers()) do
                    if p.Character and obj:IsDescendantOf(p.Character) then
                        isChar = true
                        break
                    end
                end
                
                if not isChar then
                    pcall(function()
                        obj:Destroy()
                        count = count + 1
                    end)
                end
            end
        end
    end
    
    notif("CLIENT: Deleted " .. count .. " parts", count > 0)
end

local function makeInvisible(partName)
    local count = 0
    
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and (partName == "all" or obj.Name:lower():find(partName:lower())) then
            pcall(function()
                obj.Transparency = 1
                obj.CanCollide = false
                count = count + 1
            end)
        end
    end
    
    notif("Made " .. count .. " invisible (CLIENT)", true)
end

local function moveToVoid(partName)
    local count = 0
    
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and (partName == "all" or obj.Name:lower():find(partName:lower())) then
            pcall(function()
                obj.CFrame = CFrame.new(0, -999999, 0)
                count = count + 1
            end)
        end
    end
    
    notif("Moved " .. count .. " to void (CLIENT)", true)
end

local function sizeToZero(partName)
    local count = 0
    
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and (partName == "all" or obj.Name:lower():find(partName:lower())) then
            pcall(function()
                obj.Size = Vector3.new(0.01, 0.01, 0.01)
                obj.Transparency = 1
                obj.CanCollide = false
                count = count + 1
            end)
        end
    end
    
    notif("Shrunk " .. count .. " parts (CLIENT)", true)
end

-- ============================================
-- PLAYER POWERS (100% WORK)
-- ============================================

local flying = false
local flyConnection
local flyBV, flyBG
local flySpeed = 50

local function toggleFly()
    flying = not flying
    
    if flying then
        local char = player.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        
        if not root then
            notif("Character not found!", false)
            flying = false
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
        
        notif("Fly enabled! (WASD + Space/Shift)", true)
        
        flyConnection = RunService.Heartbeat:Connect(function()
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
        notif("Fly disabled", nil)
        
        if flyConnection then
            flyConnection:Disconnect()
        end
        
        if flyBV then flyBV:Destroy() end
        if flyBG then flyBG:Destroy() end
    end
end

local noclipping = false
local noclipConnection

local function toggleNoclip()
    noclipping = not noclipping
    
    if noclipping then
        notif("Noclip enabled!", true)
        
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
        notif("Noclip disabled", nil)
        
        if noclipConnection then
            noclipConnection:Disconnect()
        end
        
        local char = player.Character
        if char then
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                    part.CanCollide = true
                end
            end
        end
    end
end

local function setSpeed(speed)
    local char = player.Character
    local humanoid = char and char:FindFirstChild("Humanoid")
    
    if humanoid then
        humanoid.WalkSpeed = speed
        notif("Speed set to " .. speed, true)
    else
        notif("Character not found!", false)
    end
end

local function setJump(power)
    local char = player.Character
    local humanoid = char and char:FindFirstChild("Humanoid")
    
    if humanoid then
        humanoid.JumpPower = power
        notif("Jump power set to " .. power, true)
    else
        notif("Character not found!", false)
    end
end

local function godMode()
    local char = player.Character
    local humanoid = char and char:FindFirstChild("Humanoid")
    
    if humanoid then
        humanoid.Health = math.huge
        humanoid.MaxHealth = math.huge
        notif("God mode enabled!", true)
    else
        notif("Character not found!", false)
    end
end

-- ============================================
-- UTILITIES
-- ============================================

local function listAllParts()
    local parts = {}
    
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            local name = obj.Name
            parts[name] = (parts[name] or 0) + 1
        end
    end
    
    print("=== ALL PARTS IN WORKSPACE ===")
    local sorted = {}
    for name, count in pairs(parts) do
        table.insert(sorted, {name = name, count = count})
    end
    
    table.sort(sorted, function(a, b) return a.count > b.count end)
    
    for i, data in ipairs(sorted) do
        if i <= 50 then
            print(string.format("%d. %s (%dx)", i, data.name, data.count))
        end
    end
    print("==============================")
    
    notif("Check console (F9) for list!", true)
end

local function getPlaceInfo()
    local placeId = game.PlaceId
    local gameName = game:GetService("MarketplaceService"):GetProductInfo(placeId).Name
    
    print("=== GAME INFO ===")
    print("PlaceId:", placeId)
    print("Game Name:", gameName)
    print("Players:", #Players:GetPlayers())
    print("=================")
    
    notif("Check console (F9) for game info!", true)
end

-- ============================================
-- CREATE GUI
-- ============================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BrutalExploit"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = playerGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 380, 0, 680)
MainFrame.Position = UDim2.new(0.5, -190, 0.5, -340)
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
Header.Size = UDim2.new(1, 0, 0, 50)
Header.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
Header.BorderSizePixel = 0
Header.Parent = MainFrame

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 15)
HeaderCorner.Parent = Header

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -60, 1, 0)
Title.Position = UDim2.new(0, 12, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "💀 BRUTAL EXPLOIT V2"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 45, 0, 45)
CloseBtn.Position = UDim2.new(1, -48, 0, 2.5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 22
CloseBtn.Parent = Header

local CloseBtnCorner = Instance.new("UICorner")
CloseBtnCorner.CornerRadius = UDim.new(0, 10)
CloseBtnCorner.Parent = CloseBtn

CloseBtn.MouseButton1Click:Connect(function()
    flying = false
    noclipping = false
    ScreenGui:Destroy()
    notif("GUI Closed", nil)
end)

-- Content
local Content = Instance.new("ScrollingFrame")
Content.Size = UDim2.new(1, -20, 1, -60)
Content.Position = UDim2.new(0, 10, 0, 55)
Content.BackgroundTransparency = 1
Content.ScrollBarThickness = 8
Content.CanvasSize = UDim2.new(0, 0, 0, 2000)
Content.Parent = MainFrame

-- ============================================
-- GUI BUILDERS
-- ============================================

local yPos = 10

local function makeLabel(text, color)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -10, 0, 38)
    label.Position = UDim2.new(0, 5, 0, yPos)
    label.BackgroundColor3 = color or Color3.fromRGB(40, 40, 40)
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 15
    label.Parent = Content
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = label
    
    yPos = yPos + 44
end

local function makeButton(text, color, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 48)
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
    
    yPos = yPos + 54
    return btn
end

local function makeTextBox(placeholder)
    local box = Instance.new("TextBox")
    box.Size = UDim2.new(1, -10, 0, 45)
    box.Position = UDim2.new(0, 5, 0, yPos)
    box.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    box.Text = ""
    box.PlaceholderText = placeholder
    box.TextColor3 = Color3.fromRGB(255, 255, 255)
    box.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
    box.Font = Enum.Font.Gotham
    box.TextSize = 14
    box.Parent = Content
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = box
    
    yPos = yPos + 51
    return box
end

-- ============================================
-- BUILD GUI
-- ============================================

makeLabel("🔍 SCAN & INFO", Color3.fromRGB(0, 120, 200))

makeButton("🔎 Scan RemoteEvents", Color3.fromRGB(0, 140, 220), function()
    scanRemotes()
end)

makeButton("📋 List All Parts (F9)", Color3.fromRGB(100, 100, 200), function()
    listAllParts()
end)

makeButton("ℹ️ Get Game Info", Color3.fromRGB(80, 160, 200), function()
    getPlaceInfo()
end)

makeLabel("🎯 TARGET", Color3.fromRGB(200, 0, 0))
local partBox = makeTextBox("Part name or 'all'")

makeLabel("💀 DELETE (CLIENT + SERVER)", Color3.fromRGB(150, 0, 0))

makeButton("🔥 DELETE (Try Server First)", Color3.fromRGB(200, 40, 40), function()
    local name = partBox.Text
    if name == "" then notif("Enter part name!", false) return end
    
    if mouse and mouse.Target then
        tryServerDelete(mouse.Target)
        task.wait(0.5)
    end
    clientDelete(name)
end)

makeButton("👻 Make Invisible", Color3.fromRGB(100, 0, 100), function()
    local name = partBox.Text
    if name == "" then notif("Enter part name!", false) return end
    makeInvisible(name)
end)

makeButton("🕳️ Move to Void", Color3.fromRGB(50, 0, 50), function()
    local name = partBox.Text
    if name == "" then notif("Enter part name!", false) return end
    moveToVoid(name)
end)

makeButton("📏 Size to Zero", Color3.fromRGB(100, 50, 0), function()
    local name = partBox.Text
    if name == "" then notif("Enter part name!", false) return end
    sizeToZero(name)
end)

makeLabel("⚡ PLAYER POWERS", Color3.fromRGB(255, 200, 0))

local flyBtn = makeButton("✈️ Fly (WASD + Space/Shift)", Color3.fromRGB(0, 150, 255), function()
    toggleFly()
    flyBtn.Text = flying and "⏸️ Stop Fly" or "✈️ Fly (WASD + Space/Shift)"
end)

local noclipBtn = makeButton("👻 Noclip", Color3.fromRGB(150, 0, 255), function()
    toggleNoclip()
    noclipBtn.Text = noclipping and "⏸️ Stop Noclip" or "👻 Noclip"
end)

makeButton("🚀 Speed 100", Color3.fromRGB(255, 150, 0), function()
    setSpeed(100)
end)

makeButton("🚀 Speed 200", Color3.fromRGB(255, 100, 0), function()
    setSpeed(200)
end)

makeButton("🦘 Jump 150", Color3.fromRGB(0, 255, 100), function()
    setJump(150)
end)

makeButton("🛡️ God Mode", Color3.fromRGB(255, 215, 0), function()
    godMode()
end)

makeLabel("🌅 LIGHTING (Try Server)", Color3.fromRGB(255, 180, 0))

makeButton("☀️ Set Day", Color3.fromRGB(255, 200, 0), function()
    tryServerLighting("ClockTime", 14)
    Lighting.ClockTime = 14
end)

makeButton("🌙 Set Night", Color3.fromRGB(20, 20, 80), function()
    tryServerLighting("ClockTime", 0)
    Lighting.ClockTime = 0
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
info.Text = [[💀 BRUTAL EXPLOIT V2 - FIXED

✅ IMPROVEMENTS:
• Auto scan RemoteEvents
• Try server-side first, fallback to client
• Better error handling
• Mobile compatible

🎮 HOW TO USE:
1. Scan RemoteEvents first
2. Enter part name in textbox
3. Try DELETE (tries server first)
4. Use Fly/Noclip for easy movement

⚠️ NOTE:
Delete = Tries server, then client
Other features = 100% work (client-side)

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

-- Auto scan on load
task.spawn(function()
    task.wait(1)
    scanRemotes()
end)

notif("Brutal Exploit V2 loaded!", true)
print("================================")
print("BRUTAL EXPLOIT V2 - FIXED")
print("PlaceId:", game.PlaceId)
print("Remotes will auto-scan in 1s...")
print("================================")
