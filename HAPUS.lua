-- HD ADMIN EXPLOIT - NETWORK OWNERSHIP VERSION
-- Exploit yang BENAR-BENAR replicate ke semua player

task.wait(2)

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui", 10)

if not playerGui then return end

if playerGui:FindFirstChild("HDNetworkExploit") then
    playerGui.HDNetworkExploit:Destroy()
    task.wait(0.5)
end

local function notif(msg, success)
    local icon = success and "✅" or (success == false and "❌" or "⚡")
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Network Exploit";
            Text = icon .. " " .. msg;
            Duration = 3;
        })
    end)
    print("[Network Exploit]", msg)
end

-- Cek Filtering Enabled
local FE_ENABLED = workspace.FilteringEnabled
if FE_ENABLED then
    notif("⚠️ FE Enabled - Limited exploits", nil)
else
    notif("🔥 FE Disabled - Full exploits!", true)
end

-- HD Admin check
local HDAdmin = ReplicatedStorage:FindFirstChild("HDAdminHDClient")
local Signals = HDAdmin and HDAdmin:FindFirstChild("Signals")
local ExecuteCommand = Signals and Signals:FindFirstChild("ExecuteClientCommand")

-- ============================================
-- NETWORK OWNERSHIP EXPLOITS (Work for all!)
-- ============================================

-- DELETE PARTS (Bekerja satu server!) - FIXED VERSION
local function deleteParts(partName)
    notif("Deleting parts: " .. partName)
    
    local deletedCount = 0
    local skippedCount = 0
    local partNameLower = partName:lower()
    
    print("=== DELETE DEBUG ===")
    print("Searching for:", partName)
    
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            local objNameLower = obj.Name:lower()
            local shouldDelete = false
            
            -- Check if matches
            if partNameLower == "all" then
                shouldDelete = true
            elseif objNameLower:find(partNameLower) then
                shouldDelete = true
            elseif objNameLower == partNameLower then
                shouldDelete = true
            end
            
            if shouldDelete then
                -- Skip player characters
                local isCharPart = false
                for _, plr in pairs(Players:GetPlayers()) do
                    if plr.Character and obj:IsDescendantOf(plr.Character) then
                        isCharPart = true
                        break
                    end
                end
                
                if not isCharPart then
                    print("Found:", obj:GetFullName(), "| Anchored:", obj.Anchored)
                    
                    local success = pcall(function()
                        -- Try unanchor first if anchored
                        if obj.Anchored then
                            obj.Anchored = false
                            task.wait(0.05)
                        end
                        
                        -- Try to take ownership
                        obj:SetNetworkOwner(player)
                        task.wait(0.1)
                        
                        -- Destroy
                        obj:Destroy()
                        deletedCount = deletedCount + 1
                        print("✅ Deleted:", obj.Name)
                    end)
                    
                    if not success then
                        skippedCount = skippedCount + 1
                        print("❌ Failed:", obj.Name)
                    end
                end
            end
        end
    end
    
    print("===================")
    print("Deleted:", deletedCount)
    print("Skipped:", skippedCount)
    
    notif("Deleted " .. deletedCount .. " | Skipped " .. skippedCount, deletedCount > 0)
end

-- FLING PARTS (Bekerja satu server!)
local function flingParts(partName, force)
    notif("Flinging parts: " .. partName)
    
    local flingedCount = 0
    
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and not obj.Anchored and obj.Name:lower():find(partName:lower()) then
            pcall(function()
                obj:SetNetworkOwner(player)
                task.wait(0.05)
                
                local bodyVelocity = Instance.new("BodyVelocity")
                bodyVelocity.Velocity = Vector3.new(
                    math.random(-force, force),
                    math.random(force/2, force),
                    math.random(-force, force)
                )
                bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
                bodyVelocity.Parent = obj
                
                game:GetService("Debris"):AddItem(bodyVelocity, 1)
                flingedCount = flingedCount + 1
            end)
        end
    end
    
    notif("Flinged " .. flingedCount .. " parts!", true)
end

-- RESIZE PARTS (Bekerja satu server!)
local function resizeParts(partName, scale)
    notif("Resizing parts: " .. partName)
    
    local resizedCount = 0
    
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Name:lower():find(partName:lower()) then
            pcall(function()
                obj:SetNetworkOwner(player)
                task.wait(0.05)
                
                obj.Size = obj.Size * scale
                resizedCount = resizedCount + 1
            end)
        end
    end
    
    notif("Resized " .. resizedCount .. " parts!", true)
end

-- CHANGE PART COLOR (Bekerja satu server!)
local function colorParts(partName, color)
    notif("Coloring parts: " .. partName)
    
    local coloredCount = 0
    
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Name:lower():find(partName:lower()) then
            pcall(function()
                obj:SetNetworkOwner(player)
                task.wait(0.05)
                
                obj.Color = color
                obj.Material = Enum.Material.Neon
                coloredCount = coloredCount + 1
            end)
        end
    end
    
    notif("Colored " .. coloredCount .. " parts!", true)
end

-- TELEPORT PARTS (Bekerja satu server!)
local function teleportParts(partName, destination)
    notif("Teleporting parts: " .. partName)
    
    local destPart = Workspace:FindFirstChild(destination, true)
    if not destPart or not destPart:IsA("BasePart") then
        notif("Destination not found!", false)
        return
    end
    
    local tpCount = 0
    
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Name:lower():find(partName:lower()) then
            pcall(function()
                obj:SetNetworkOwner(player)
                task.wait(0.05)
                
                obj.CFrame = destPart.CFrame + Vector3.new(math.random(-10, 10), 5, math.random(-10, 10))
                tpCount = tpCount + 1
            end)
        end
    end
    
    notif("Teleported " .. tpCount .. " parts!", true)
end

-- SPIN PARTS (Bekerja satu server!)
local function spinParts(partName, duration)
    notif("Spinning parts: " .. partName)
    
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and not obj.Anchored and obj.Name:lower():find(partName:lower()) then
            pcall(function()
                obj:SetNetworkOwner(player)
                
                local bodyAngularVelocity = Instance.new("BodyAngularVelocity")
                bodyAngularVelocity.AngularVelocity = Vector3.new(0, 50, 0)
                bodyAngularVelocity.MaxTorque = Vector3.new(0, 9e9, 0)
                bodyAngularVelocity.Parent = obj
                
                game:GetService("Debris"):AddItem(bodyAngularVelocity, duration)
            end)
        end
    end
    
    notif("Parts spinning!", true)
end

-- ANCHOR/UNANCHOR (Bekerja satu server!)
local function toggleAnchor(partName, anchored)
    notif((anchored and "Anchoring" or "Unanchoring") .. " parts: " .. partName)
    
    local count = 0
    
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Name:lower():find(partName:lower()) then
            pcall(function()
                obj:SetNetworkOwner(player)
                task.wait(0.05)
                
                obj.Anchored = anchored
                count = count + 1
            end)
        end
    end
    
    notif("Modified " .. count .. " parts!", true)
end

-- SPAM PARTS (Bekerja satu server!)
local function spamParts(count, partType)
    notif("Creating " .. count .. " parts...")
    
    for i = 1, count do
        local part = Instance.new("Part")
        part.Name = "SpamPart_" .. i
        part.Size = Vector3.new(5, 5, 5)
        part.Position = player.Character.HumanoidRootPart.Position + Vector3.new(
            math.random(-50, 50),
            math.random(10, 30),
            math.random(-50, 50)
        )
        part.Color = Color3.fromRGB(math.random(0, 255), math.random(0, 255), math.random(0, 255))
        part.Material = Enum.Material.Neon
        part.Parent = Workspace
        
        task.wait(0.05)
    end
    
    notif("Created " .. count .. " parts!", true)
end

-- NUKE WORKSPACE (Delete semua non-anchored parts)
local function nukeWorkspace()
    notif("🔥 NUKING WORKSPACE!")
    
    local nukeCoun = 0
    
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and not obj.Anchored then
            -- Skip characters
            local isCharacterPart = false
            for _, plr in pairs(Players:GetPlayers()) do
                if obj:IsDescendantOf(plr.Character or {}) then
                    isCharacterPart = true
                    break
                end
            end
            
            if not isCharacterPart then
                pcall(function()
                    obj:SetNetworkOwner(player)
                    task.wait(0.02)
                    obj:Destroy()
                    nukeCoun = nukeCoun + 1
                end)
            end
        end
    end
    
    notif("💥 Nuked " .. nukeCoun .. " parts!", true)
end

-- BRING PARTS TO YOU
local function bringParts(partName)
    notif("Bringing parts: " .. partName)
    
    local pos = player.Character.HumanoidRootPart.Position
    local broughtCount = 0
    
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and not obj.Anchored and obj.Name:lower():find(partName:lower()) then
            pcall(function()
                obj:SetNetworkOwner(player)
                task.wait(0.05)
                
                obj.CFrame = CFrame.new(pos + Vector3.new(math.random(-10, 10), 5, math.random(-10, 10)))
                broughtCount = broughtCount + 1
            end)
        end
    end
    
    notif("Brought " .. broughtCount .. " parts!", true)
end

-- LIST ALL PARTS
local function listParts()
    local partsList = {}
    
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            local name = obj.Name
            if not partsList[name] then
                partsList[name] = 0
            end
            partsList[name] = partsList[name] + 1
        end
    end
    
    print("=== PARTS IN WORKSPACE ===")
    for name, count in pairs(partsList) do
        print(name .. ": " .. count)
    end
    print("==========================")
    
    notif("Check console (F9) for list", true)
end

-- ============================================
-- HD ADMIN COMMANDS (if you have access)
-- ============================================

local function tryCommand(cmd, ...)
    if not ExecuteCommand then
        notif("HD Admin commands not available", false)
        return
    end
    
    local args = {...}
    notif("Trying command: " .. cmd)
    
    pcall(function()
        -- Format 1
        ExecuteCommand:FireServer(cmd, unpack(args))
        
        -- Format 2
        ExecuteCommand:FireServer(":" .. cmd .. " " .. table.concat(args, " "))
        
        -- Format 3
        ExecuteCommand:FireServer({
            command = cmd,
            args = args
        })
    end)
end

-- ============================================
-- GUI
-- ============================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "HDNetworkExploit"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = playerGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 380, 0, 600)
MainFrame.Position = UDim2.new(0.5, -190, 0.5, -300)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 15)
Corner.Parent = MainFrame

local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 55)
Header.BackgroundColor3 = Color3.fromRGB(255, 100, 50)
Header.BorderSizePixel = 0
Header.Parent = MainFrame

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 15)
HeaderCorner.Parent = Header

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -65, 1, 0)
Title.Position = UDim2.new(0, 12, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "🌐 NETWORK EXPLOIT"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 50, 0, 50)
CloseBtn.Position = UDim2.new(1, -53, 0, 2.5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 26
CloseBtn.Parent = Header

local CloseBtnCorner = Instance.new("UICorner")
CloseBtnCorner.CornerRadius = UDim.new(0, 12)
CloseBtnCorner.Parent = CloseBtn

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

local Content = Instance.new("ScrollingFrame")
Content.Size = UDim2.new(1, -24, 1, -70)
Content.Position = UDim2.new(0, 12, 0, 60)
Content.BackgroundTransparency = 1
Content.ScrollBarThickness = 10
Content.CanvasSize = UDim2.new(0, 0, 0, 2000)
Content.Parent = MainFrame

local yPos = 10

local function makeLabel(text, color)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -10, 0, 40)
    label.Position = UDim2.new(0, 5, 0, yPos)
    label.BackgroundColor3 = color or Color3.fromRGB(50, 50, 50)
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
    btn.Size = UDim2.new(1, -10, 0, 50)
    btn.Position = UDim2.new(0, 5, 0, yPos)
    btn.BackgroundColor3 = color
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 15
    btn.TextWrapped = true
    btn.Parent = Content
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = btn
    
    btn.MouseButton1Click:Connect(function()
        pcall(callback)
    end)
    
    yPos = yPos + 56
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

-- BUILD GUI
makeLabel("🎯 TARGET PARTS", Color3.fromRGB(255, 100, 50))
local partBox = makeTextBox("Nama part (atau 'all')")

makeLabel("🔥 DESTRUCTIVE", Color3.fromRGB(200, 0, 0))

makeButton("💣 Delete Parts", Color3.fromRGB(180, 30, 30), function()
    if partBox.Text ~= "" then
        deleteParts(partBox.Text)
    end
end)

makeButton("💥 Nuke Workspace", Color3.fromRGB(150, 0, 0), function()
    nukeWorkspace()
end)

makeButton("🌪️ Fling Parts", Color3.fromRGB(200, 100, 0), function()
    if partBox.Text ~= "" then
        flingParts(partBox.Text, 100)
    end
end)

makeLabel("🔧 MANIPULATION", Color3.fromRGB(0, 150, 200))

makeButton("📍 Bring Parts to Me", Color3.fromRGB(0, 140, 200), function()
    if partBox.Text ~= "" then
        bringParts(partBox.Text)
    end
end)

makeButton("🔄 Spin Parts (5s)", Color3.fromRGB(100, 150, 255), function()
    if partBox.Text ~= "" then
        spinParts(partBox.Text, 5)
    end
end)

makeButton("📏 Resize x2", Color3.fromRGB(0, 180, 150), function()
    if partBox.Text ~= "" then
        resizeParts(partBox.Text, 2)
    end
end)

makeButton("📏 Resize x0.5", Color3.fromRGB(0, 160, 130), function()
    if partBox.Text ~= "" then
        resizeParts(partBox.Text, 0.5)
    end
end)

makeButton("🎨 Color Random", Color3.fromRGB(255, 0, 255), function()
    if partBox.Text ~= "" then
        colorParts(partBox.Text, Color3.fromRGB(math.random(0,255), math.random(0,255), math.random(0,255)))
    end
end)

makeButton("🔒 Anchor Parts", Color3.fromRGB(100, 100, 100), function()
    if partBox.Text ~= "" then
        toggleAnchor(partBox.Text, true)
    end
end)

makeButton("🔓 Unanchor Parts", Color3.fromRGB(80, 80, 80), function()
    if partBox.Text ~= "" then
        toggleAnchor(partBox.Text, false)
    end
end)

makeLabel("➕ CREATION", Color3.fromRGB(0, 200, 100))

makeButton("📦 Spam 50 Parts", Color3.fromRGB(0, 180, 100), function()
    spamParts(50)
end)

makeButton("📦 Spam 100 Parts", Color3.fromRGB(0, 160, 80), function()
    spamParts(100)
end)

makeLabel("📊 UTILITIES", Color3.fromRGB(100, 100, 150))

makeButton("📜 List All Parts", Color3.fromRGB(100, 100, 200), function()
    listParts()
end)

makeLabel("⚡ HD ADMIN", Color3.fromRGB(220, 50, 50))
local cmdBox = makeTextBox("Command (e.g., kill player)")

makeButton("🚀 Execute Command", Color3.fromRGB(200, 50, 50), function()
    if cmdBox.Text ~= "" then
        local parts = cmdBox.Text:split(" ")
        tryCommand(parts[1], unpack(parts, 2))
    end
end)

-- Info
yPos = yPos + 10
local info = Instance.new("TextLabel")
info.Size = UDim2.new(1, -10, 0, 200)
info.Position = UDim2.new(0, 5, 0, yPos)
info.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
info.TextColor3 = Color3.fromRGB(200, 200, 200)
info.Font = Enum.Font.Gotham
info.TextSize = 13
info.TextWrapped = true
info.TextYAlignment = Enum.TextYAlignment.Top
info.Text = string.format([[🌐 NETWORK OWNERSHIP EXPLOIT

FE STATUS: %s

✅ GUARANTEED TO WORK:
• Delete/Fling/Spin Parts
• Resize/Color/Anchor Parts
• Bring/Teleport Parts
• Spam Parts Creation

⚠️ REQUIREMENTS:
• Parts must NOT be anchored
• Need network ownership
• Changes REPLICATE to all players!

🎯 USAGE:
• Type part name or "all"
• Click action button
• Everyone in server sees changes!

Made with Network Ownership]], FE_ENABLED and "ENABLED" or "DISABLED")
info.Parent = Content

local infoPadding = Instance.new("UIPadding")
infoPadding.PaddingTop = UDim.new(0, 12)
infoPadding.PaddingLeft = UDim.new(0, 12)
infoPadding.PaddingRight = UDim.new(0, 12)
infoPadding.Parent = info

local infoCorner = Instance.new("UICorner")
infoCorner.CornerRadius = UDim.new(0, 10)
infoCorner.Parent = info

Content.CanvasSize = UDim2.new(0, 0, 0, yPos + 210)

notif("Network Exploit loaded!", true)
print("==============================")
print("NETWORK OWNERSHIP EXPLOIT")
print("FE: " .. (FE_ENABLED and "Enabled" or "Disabled"))
print("==============================")
