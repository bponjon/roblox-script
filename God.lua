-- SERVER-SIDE EXPLOIT CONTROLLER - MOBILE FIXED v2
-- Compatible dengan Delta, Arceus X, dan executor mobile lainnya
-- Fixed mouse issues dan error handling

-- Wait untuk game ready
task.wait(2)

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui", 10)

if not playerGui then
    warn("PlayerGui not found!")
    return
end

-- Check if GUI already exists
if playerGui:FindFirstChild("ServerExploitGUI") then
    playerGui.ServerExploitGUI:Destroy()
    task.wait(0.5)
end

-- Safe notification function
local function notify(msg)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Server Exploit";
            Text = msg;
            Duration = 2.5;
        })
    end)
    print("[Server Exploit]", msg)
end

-- Safe mouse getter with fallback
local mouse = nil
local selectedPart = nil

local function getMouse()
    local success, result = pcall(function()
        return player:GetMouse()
    end)
    if success and result then
        return result
    end
    return nil
end

-- Try to get mouse
task.spawn(function()
    task.wait(1)
    mouse = getMouse()
    if mouse then
        notify("Mouse detected!")
        -- Update selected part on mouse move
        mouse.Move:Connect(function()
            if mouse.Target and mouse.Target:IsA("BasePart") then
                selectedPart = mouse.Target
            end
        end)
    else
        notify("Mouse not available - use touch select")
    end
end)

-- Touch/Click selection fallback
local UserInputService = game:GetService("UserInputService")
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.UserInputType == Enum.UserInputType.Touch or 
       input.UserInputType == Enum.UserInputType.MouseButton1 then
        
        local camera = workspace.CurrentCamera
        local ray = camera:ViewportPointToRay(input.Position.X, input.Position.Y)
        local raycastParams = RaycastParams.new()
        raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
        raycastParams.FilterDescendantsInstances = {player.Character}
        
        local result = workspace:Raycast(ray.Origin, ray.Direction * 500, raycastParams)
        
        if result and result.Instance then
            selectedPart = result.Instance
            notify("Selected: " .. selectedPart.Name)
        end
    end
end)

-- ============================================
-- REMOTE SCANNER
-- ============================================
local remoteEvents = {}
local remoteFunctions = {}

local function scanRemotes()
    remoteEvents = {}
    remoteFunctions = {}
    
    notify("Scanning remotes...")
    
    -- Scan ReplicatedStorage
    for _, obj in pairs(ReplicatedStorage:GetDescendants()) do
        if obj:IsA("RemoteEvent") then
            table.insert(remoteEvents, obj)
        elseif obj:IsA("RemoteFunction") then
            table.insert(remoteFunctions, obj)
        end
    end
    
    -- Scan Workspace
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("RemoteEvent") then
            table.insert(remoteEvents, obj)
        elseif obj:IsA("RemoteFunction") then
            table.insert(remoteFunctions, obj)
        end
    end
    
    notify("Found " .. #remoteEvents .. " RemoteEvents!")
    
    print("=== REMOTE EVENTS ===")
    for i, remote in pairs(remoteEvents) do
        print(i .. ".", remote:GetFullName())
    end
end

-- ============================================
-- EXPLOIT FUNCTIONS
-- ============================================

local function tryDeletePart(part)
    if not part then 
        notify("No part selected!")
        return 
    end
    
    notify("Trying to delete: " .. part.Name)
    
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
        end)
    end
    
    notify("Delete attempts sent!")
end

local function tryEditPart(part, property, value)
    if not part then 
        notify("No part selected!")
        return 
    end
    
    notify("Trying to edit: " .. part.Name)
    
    for _, remote in pairs(remoteEvents) do
        pcall(function()
            remote:FireServer("Edit", part, property, value)
            remote:FireServer("Change", part, property, value)
            remote:FireServer({Action = "Edit", Target = part, Property = property, Value = value})
            remote:FireServer("SetProperty", part, property, value)
            remote:FireServer("UpdatePart", part, {[property] = value})
        end)
    end
    
    notify("Edit attempts sent!")
end

local function trySetTime(time)
    notify("Trying to change time to " .. time)
    
    for _, remote in pairs(remoteEvents) do
        pcall(function()
            remote:FireServer("SetTime", time)
            remote:FireServer("ChangeTime", time)
            remote:FireServer({Action = "Time", Value = time})
            remote:FireServer("Lighting", "ClockTime", time)
            remote:FireServer("UpdateLighting", {ClockTime = time})
        end)
    end
    
    notify("Time change sent!")
end

local function tryExplode(position)
    if not position then
        position = player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character.HumanoidRootPart.Position
    end
    
    if not position then
        notify("No valid position!")
        return
    end
    
    notify("Trying explosion...")
    
    for _, remote in pairs(remoteEvents) do
        pcall(function()
            remote:FireServer("Explode", position, 50)
            remote:FireServer("CreateExplosion", position, 50)
            remote:FireServer({Action = "Explode", Position = position, Radius = 50})
            remote:FireServer("Explosion", {Position = position, BlastRadius = 50})
        end)
    end
    
    notify("Explosion sent!")
end

-- ============================================
-- CREATE GUI (MOBILE OPTIMIZED)
-- ============================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ServerExploitGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 350, 0, 500)
MainFrame.Position = UDim2.new(0.5, -175, 0.5, -250)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 12)
Corner.Parent = MainFrame

-- Header
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 45)
Header.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
Header.BorderSizePixel = 0
Header.Parent = MainFrame

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 12)
HeaderCorner.Parent = Header

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -60, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "⚠️ SERVER EXPLOIT"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

-- Close Button
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 40, 0, 40)
CloseBtn.Position = UDim2.new(1, -45, 0, 2.5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(150, 30, 30)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 20
CloseBtn.Parent = Header

local CloseBtnCorner = Instance.new("UICorner")
CloseBtnCorner.CornerRadius = UDim.new(0, 8)
CloseBtnCorner.Parent = CloseBtn

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
    notify("GUI Closed")
end)

-- Content ScrollingFrame
local Content = Instance.new("ScrollingFrame")
Content.Size = UDim2.new(1, -20, 1, -55)
Content.Position = UDim2.new(0, 10, 0, 50)
Content.BackgroundTransparency = 1
Content.BorderSizePixel = 0
Content.ScrollBarThickness = 8
Content.CanvasSize = UDim2.new(0, 0, 0, 900)
Content.Parent = MainFrame

-- ============================================
-- BUTTON HELPER (MOBILE OPTIMIZED)
-- ============================================
local yPos = 10

local function createButton(text, color, callback)
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
        local success, err = pcall(callback)
        if not success then
            notify("Error: " .. tostring(err))
        end
    end)
    
    yPos = yPos + 55
    return btn
end

local function createLabel(text)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -10, 0, 35)
    label.Position = UDim2.new(0, 5, 0, yPos)
    label.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 14
    label.Parent = Content
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = label
    
    yPos = yPos + 40
end

-- ============================================
-- BUILD GUI
-- ============================================

createLabel("🔍 SCANNER")

createButton("Scan RemoteEvents", Color3.fromRGB(0, 120, 215), function()
    scanRemotes()
end)

createButton("Show Selected Part", Color3.fromRGB(0, 150, 200), function()
    if selectedPart then
        notify("Selected: " .. selectedPart.Name)
    else
        notify("No part selected! Tap on a part first")
    end
end)

createLabel("🗑️ DELETE")

createButton("Delete Selected Part", Color3.fromRGB(200, 50, 50), function()
    if selectedPart then
        tryDeletePart(selectedPart)
    else
        notify("Tap on a part first!")
    end
end)

createLabel("✏️ EDIT SELECTED")

createButton("Make Transparent", Color3.fromRGB(0, 180, 120), function()
    if selectedPart and selectedPart:IsA("BasePart") then
        tryEditPart(selectedPart, "Transparency", 1)
    else
        notify("Select a valid part first!")
    end
end)

createButton("Change to Red", Color3.fromRGB(200, 0, 0), function()
    if selectedPart and selectedPart:IsA("BasePart") then
        tryEditPart(selectedPart, "Color", Color3.fromRGB(255, 0, 0))
    else
        notify("Select a valid part first!")
    end
end)

createButton("Change to Blue", Color3.fromRGB(0, 100, 200), function()
    if selectedPart and selectedPart:IsA("BasePart") then
        tryEditPart(selectedPart, "Color", Color3.fromRGB(0, 100, 255))
    else
        notify("Select a valid part first!")
    end
end)

createButton("Make Anchored", Color3.fromRGB(100, 100, 100), function()
    if selectedPart and selectedPart:IsA("BasePart") then
        tryEditPart(selectedPart, "Anchored", true)
    else
        notify("Select a valid part first!")
    end
end)

createLabel("🌅 LIGHTING")

createButton("Set Day", Color3.fromRGB(255, 200, 0), function()
    trySetTime(14)
end)

createButton("Set Night", Color3.fromRGB(20, 20, 80), function()
    trySetTime(0)
end)

createButton("Set Sunset", Color3.fromRGB(255, 120, 50), function()
    trySetTime(18)
end)

createLabel("💥 DESTRUCTIVE")

createButton("Explode at Player", Color3.fromRGB(255, 100, 0), function()
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        tryExplode(player.Character.HumanoidRootPart.Position)
    else
        notify("Character not found!")
    end
end)

createButton("Explode at Selected", Color3.fromRGB(255, 50, 0), function()
    if selectedPart then
        tryExplode(selectedPart.Position)
    else
        notify("Select a part first!")
    end
end)

-- Info at bottom
yPos = yPos + 10
local info = Instance.new("TextLabel")
info.Size = UDim2.new(1, -10, 0, 100)
info.Position = UDim2.new(0, 5, 0, yPos)
info.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
info.TextColor3 = Color3.fromRGB(200, 200, 200)
info.Font = Enum.Font.Gotham
info.TextSize = 11
info.TextWrapped = true
info.TextYAlignment = Enum.TextYAlignment.Top
info.Text = "⚠️ Only works on vulnerable games!\n\nHOW TO USE:\n1. Scan RemoteEvents first\n2. TAP on any part to select it\n3. Use buttons to try exploits\n4. Check if others see changes"
info.Parent = Content

local infoPadding = Instance.new("UIPadding")
infoPadding.PaddingTop = UDim.new(0, 8)
infoPadding.PaddingLeft = UDim.new(0, 8)
infoPadding.PaddingRight = UDim.new(0, 8)
infoPadding.Parent = info

local infoCorner = Instance.new("UICorner")
infoCorner.CornerRadius = UDim.new(0, 8)
infoCorner.Parent = info

-- Update canvas size
Content.CanvasSize = UDim2.new(0, 0, 0, yPos + 110)

-- ============================================
-- PARENT GUI
-- ============================================
ScreenGui.Parent = playerGui

-- Auto scan on start
task.spawn(function()
    task.wait(2)
    scanRemotes()
    notify("GUI Ready! Tap parts to select")
end)

notify("GUI Loaded! 🚀")
print("=================================")
print("SERVER EXPLOIT - MOBILE VERSION V2")
print("GUI should now be visible!")
print("Touch/tap on parts to select them")
print("=================================")
