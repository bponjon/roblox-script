-- NETWORK OWNERSHIP EXPLOIT - ADVANCED
-- Mencoba ambil network ownership untuk replicate changes
-- Works pada UNANCHORED parts di game lemah

task.wait(2)

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui", 10)

if playerGui:FindFirstChild("NetworkExploit") then
    playerGui.NetworkExploit:Destroy()
    task.wait(0.5)
end

-- ============================================
-- NOTIFICATION
-- ============================================
local function notif(msg, icon)
    icon = icon or "⚡"
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Network Exploit";
            Text = icon .. " " .. msg;
            Duration = 3;
        })
    end)
    print("[Network]", msg)
end

local mouse = player:GetMouse()

-- ============================================
-- NETWORK OWNERSHIP METHODS
-- ============================================

-- Method 1: Set Network Owner
local function trySetNetworkOwner(part)
    if not part or not part:IsA("BasePart") then return false end
    
    -- Check if anchored (can't set owner for anchored)
    if part.Anchored then
        notif("Part is ANCHORED (can't take ownership)", "⚠️")
        return false
    end
    
    local success, result = pcall(function()
        part:SetNetworkOwner(player)
        return true
    end)
    
    if success and result then
        notif("Network ownership taken! ✅", "✅")
        return true
    else
        notif("Failed to take ownership", "❌")
        return false
    end
end

-- Method 2: Force Unanchor + Take Ownership
local function forceUnanchorAndOwn(part)
    if not part or not part:IsA("BasePart") then return false end
    
    notif("Trying to unanchor and own...", "🔧")
    
    local wasAnchored = part.Anchored
    
    pcall(function()
        -- Try to unanchor
        part.Anchored = false
        task.wait(0.1)
        
        -- Take ownership
        part:SetNetworkOwner(player)
        
        notif("Unanchored + Owned! ✅", "✅")
    end)
    
    task.wait(0.5)
    
    -- Check if still unanchored (server might revert)
    if part.Anchored then
        notif("Server reverted anchor state ❌", "❌")
        return false
    else
        notif("Still unanchored! May replicate! ✅", "✅")
        return true
    end
end

-- Method 3: Find Unanchored Parts (Easy targets)
local function findUnanchoredParts()
    notif("Scanning for unanchored parts...", "🔍")
    
    local unanchored = {}
    
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and not obj.Anchored then
            -- Skip character parts
            local isChar = false
            for _, p in pairs(Players:GetPlayers()) do
                if p.Character and obj:IsDescendantOf(p.Character) then
                    isChar = true
                    break
                end
            end
            
            if not isChar then
                table.insert(unanchored, obj)
            end
        end
    end
    
    print("=== UNANCHORED PARTS (VULNERABLE) ===")
    for i, part in pairs(unanchored) do
        if i <= 30 then
            print(i .. ".", part:GetFullName(), "| Owner:", part:GetNetworkOwner())
        end
    end
    print("Total:", #unanchored)
    print("=====================================")
    
    notif("Found " .. #unanchored .. " unanchored parts!", "✅")
    return unanchored
end

-- Method 4: Mass Take Ownership
local function massOwnUnanchored()
    notif("Taking ownership of all unanchored...", "🔥")
    
    local count = 0
    
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and not obj.Anchored then
            pcall(function()
                obj:SetNetworkOwner(player)
                count = count + 1
            end)
        end
    end
    
    notif("Owned " .. count .. " parts!", "✅")
end

-- Method 5: Fling Part (Physics replication)
local function flingPart(part, force)
    if not part or not part:IsA("BasePart") then return end
    
    notif("Flinging part...", "💫")
    
    pcall(function()
        -- Unanchor if possible
        part.Anchored = false
        
        -- Take ownership
        part:SetNetworkOwner(player)
        
        task.wait(0.1)
        
        -- Apply velocity
        local bv = Instance.new("BodyVelocity")
        bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        bv.Velocity = Vector3.new(0, force or 500, 0)
        bv.Parent = part
        
        task.wait(0.5)
        bv:Destroy()
        
        notif("Flung! Check if others see it!", "✅")
    end)
end

-- Method 6: Teleport Part (With ownership)
local function teleportPartWithOwnership(part, position)
    if not part or not part:IsA("BasePart") then return end
    
    notif("Teleporting with ownership...", "📍")
    
    pcall(function()
        -- Unanchor
        part.Anchored = false
        
        -- Take ownership
        part:SetNetworkOwner(player)
        
        task.wait(0.1)
        
        -- Move
        part.CFrame = CFrame.new(position)
        
        notif("Teleported! Check replication!", "✅")
    end)
end

-- Method 7: Delete with Physics (Make fall)
local function deleteWithPhysics(partName)
    notif("Physics delete: " .. partName, "🕳️")
    
    local count = 0
    
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Name:lower():find(partName:lower()) then
            pcall(function()
                -- Unanchor
                obj.Anchored = false
                
                -- Take ownership
                obj:SetNetworkOwner(player)
                
                task.wait(0.05)
                
                -- Teleport far below (fall to void)
                obj.CFrame = CFrame.new(0, -999999, 0)
                
                count = count + 1
            end)
        end
    end
    
    notif("Physics deleted " .. count .. " parts!", "✅")
end

-- Method 8: Spam Unanchor (Keep trying)
local spamUnanchor = false
local spamConnection

local function toggleSpamUnanchor(partName)
    spamUnanchor = not spamUnanchor
    
    if spamUnanchor then
        notif("Spam unanchor started: " .. partName, "🔥")
        
        spamConnection = RunService.Heartbeat:Connect(function()
            if not spamUnanchor then return end
            
            for _, obj in pairs(Workspace:GetDescendants()) do
                if obj:IsA("BasePart") and obj.Name:lower():find(partName:lower()) then
                    pcall(function()
                        obj.Anchored = false
                        obj:SetNetworkOwner(player)
                    end)
                end
            end
        end)
    else
        notif("Spam unanchor stopped", "⏸️")
        if spamConnection then
            spamConnection:Disconnect()
        end
    end
end

-- Method 9: Remote Spy (Find hidden remotes)
local function deepRemoteScan()
    notif("Deep scanning remotes...", "🔍")
    
    local remotes = {}
    
    -- Scan everywhere
    for _, service in pairs(game:GetChildren()) do
        pcall(function()
            for _, obj in pairs(service:GetDescendants()) do
                if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
                    table.insert(remotes, {
                        Type = obj.ClassName,
                        Path = obj:GetFullName()
                    })
                end
            end
        end)
    end
    
    print("=== DEEP REMOTE SCAN ===")
    for i, remote in pairs(remotes) do
        print(i .. ".", remote.Type, ":", remote.Path)
    end
    print("Total found:", #remotes)
    print("========================")
    
    notif("Found " .. #remotes .. " total remotes!", "✅")
end

-- Method 10: Brute Force All Remotes
local function bruteForceRemotes(action, target)
    notif("Brute forcing all remotes...", "💥")
    
    local count = 0
    
    for _, service in pairs(game:GetChildren()) do
        pcall(function()
            for _, obj in pairs(service:GetDescendants()) do
                if obj:IsA("RemoteEvent") then
                    pcall(function()
                        -- Try many patterns
                        obj:FireServer(action, target)
                        obj:FireServer(target, action)
                        obj:FireServer({action, target})
                        obj:FireServer({Action = action, Target = target})
                        obj:FireServer(action, target, true)
                        obj:FireServer("Execute", action, target)
                        count = count + 1
                    end)
                end
            end
        end)
    end
    
    notif("Tried " .. count .. " remote patterns!", "✅")
end

-- ============================================
-- CREATE GUI
-- ============================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NetworkExploit"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = playerGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 400, 0, 700)
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -350)
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
Header.BackgroundColor3 = Color3.fromRGB(0, 150, 200)
Header.BorderSizePixel = 0
Header.Parent = MainFrame

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 12)
HeaderCorner.Parent = Header

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -60, 1, 0)
Title.Position = UDim2.new(0, 12, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "🌐 NETWORK EXPLOIT"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 45, 0, 45)
CloseBtn.Position = UDim2.new(1, -48, 0, 2.5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 20
CloseBtn.Parent = Header

local CloseBtnCorner = Instance.new("UICorner")
CloseBtnCorner.CornerRadius = UDim.new(0, 8)
CloseBtnCorner.Parent = CloseBtn

CloseBtn.MouseButton1Click:Connect(function()
    spamUnanchor = false
    ScreenGui:Destroy()
end)

-- Content
local Content = Instance.new("ScrollingFrame")
Content.Size = UDim2.new(1, -20, 1, -60)
Content.Position = UDim2.new(0, 10, 0, 55)
Content.BackgroundTransparency = 1
Content.ScrollBarThickness = 8
Content.CanvasSize = UDim2.new(0, 0, 0, 1800)
Content.Parent = MainFrame

-- GUI Builders
local yPos = 10

local function makeLabel(text, color)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -10, 0, 38)
    label.Position = UDim2.new(0, 5, 0, yPos)
    label.BackgroundColor3 = color
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 14
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
    btn.TextSize = 13
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

-- Build GUI
makeLabel("🔍 SCAN & ANALYZE", Color3.fromRGB(0, 120, 200))

makeButton("Find Unanchored Parts (F9)", Color3.fromRGB(0, 140, 220), function()
    findUnanchoredParts()
end)

makeButton("Deep Remote Scan (F9)", Color3.fromRGB(100, 100, 200), function()
    deepRemoteScan()
end)

makeLabel("🎯 TARGET", Color3.fromRGB(200, 100, 0))
local partBox = makeTextBox("Part name to target")

makeLabel("🌐 NETWORK OWNERSHIP", Color3.fromRGB(0, 150, 200))

makeButton("Take Ownership (Hover Mouse)", Color3.fromRGB(0, 180, 220), function()
    if mouse.Target then
        trySetNetworkOwner(mouse.Target)
    else
        notif("No part under mouse!", "❌")
    end
end)

makeButton("Force Unanchor + Own (Mouse)", Color3.fromRGB(200, 100, 0), function()
    if mouse.Target then
        forceUnanchorAndOwn(mouse.Target)
    else
        notif("No part under mouse!", "❌")
    end
end)

makeButton("Mass Own All Unanchored", Color3.fromRGB(255, 100, 0), function()
    massOwnUnanchored()
end)

makeLabel("🕳️ PHYSICS EXPLOIT", Color3.fromRGB(150, 0, 150))

makeButton("Physics Delete (Void)", Color3.fromRGB(180, 0, 180), function()
    if partBox.Text ~= "" then
        deleteWithPhysics(partBox.Text)
    else
        notif("Enter part name!", "❌")
    end
end)

makeButton("Fling Part (Mouse)", Color3.fromRGB(255, 0, 150), function()
    if mouse.Target then
        flingPart(mouse.Target, 1000)
    else
        notif("No part under mouse!", "❌")
    end
end)

makeButton("TP Part to Void (Mouse)", Color3.fromRGB(100, 0, 150), function()
    if mouse.Target then
        teleportPartWithOwnership(mouse.Target, Vector3.new(0, -999999, 0))
    else
        notif("No part under mouse!", "❌")
    end
end)

local spamBtn = makeButton("Spam Unanchor (Toggle)", Color3.fromRGB(200, 50, 0), function()
    if partBox.Text ~= "" then
        toggleSpamUnanchor(partBox.Text)
        spamBtn.Text = spamUnanchor and "⏸️ Stop Spam" or "🔥 Spam Unanchor (Toggle)"
    else
        notif("Enter part name!", "❌")
    end
end)

makeLabel("💥 BRUTE FORCE", Color3.fromRGB(200, 0, 0))

makeButton("Brute Force Remotes (Delete)", Color3.fromRGB(220, 40, 40), function()
    if mouse.Target then
        bruteForceRemotes("Delete", mouse.Target)
    else
        notif("Hover mouse on part first!", "❌")
    end
end)

-- Info
yPos = yPos + 10
local info = Instance.new("TextLabel")
info.Size = UDim2.new(1, -10, 0, 260)
info.Position = UDim2.new(0, 5, 0, yPos)
info.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
info.TextColor3 = Color3.fromRGB(220, 220, 220)
info.Font = Enum.Font.Gotham
info.TextSize = 11
info.TextWrapped = true
info.TextYAlignment = Enum.TextYAlignment.Top
info.Text = [[🌐 NETWORK OWNERSHIP EXPLOIT

Metode ini mencoba ambil "network ownership" 
dari parts untuk replicate perubahan.

✅ CARA KERJA:
1. Scan unanchored parts
2. Ambil network ownership
3. Manipulate parts
4. Server MIGHT replicate changes

⚠️ SYARAT BERHASIL:
• Part harus UNANCHORED
• Game tidak protect ownership
• Network conditions baik

🎯 BEST TARGETS:
• Unanchored obstacles
• Physics-based objects
• Loose parts

📋 TESTING:
1. Find Unanchored Parts (F9)
2. Try Take Ownership on easy targets
3. Physics Delete or Fling
4. Ask other player if they see changes!

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

Content.CanvasSize = UDim2.new(0, 0, 0, yPos + 280)

-- Auto scan
task.spawn(function()
    task.wait(1)
    findUnanchoredParts()
    deepRemoteScan()
end)

notif("Network Exploit loaded!", "✅")
print("================================")
print("NETWORK OWNERSHIP EXPLOIT")
print("PlaceId:", game.PlaceId)
print("Auto-scanning in 1s...")
print("================================")
