-- SERVER-SIDE EXPLOIT CONTROLLER
-- Scans and exploits vulnerable RemoteEvents/RemoteFunctions
-- Works ONLY on poorly secured games

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- ============================================
-- NOTIFICATION
-- ============================================
local function notify(msg, color)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Server Exploit";
        Text = msg;
        Duration = 3;
    })
end

-- ============================================
-- REMOTE EVENT SCANNER
-- ============================================
local remoteEvents = {}
local remoteFunctions = {}

local function scanRemotes()
    notify("Scanning RemoteEvents...", Color3.new(0,1,1))
    
    local function scanContainer(container, path)
        for _, obj in pairs(container:GetDescendants()) do
            if obj:IsA("RemoteEvent") then
                table.insert(remoteEvents, {object = obj, path = path .. "/" .. obj.Name})
            elseif obj:IsA("RemoteFunction") then
                table.insert(remoteFunctions, {object = obj, path = path .. "/" .. obj.Name})
            end
        end
    end
    
    scanContainer(ReplicatedStorage, "ReplicatedStorage")
    scanContainer(Workspace, "Workspace")
    
    notify("Found " .. #remoteEvents .. " RemoteEvents", Color3.new(0,1,0))
    notify("Found " .. #remoteFunctions .. " RemoteFunctions", Color3.new(0,1,0))
    
    print("=== REMOTE EVENTS FOUND ===")
    for i, remote in pairs(remoteEvents) do
        print(i .. ". " .. remote.path)
    end
    
    print("=== REMOTE FUNCTIONS FOUND ===")
    for i, remote in pairs(remoteFunctions) do
        print(i .. ". " .. remote.path)
    end
end

-- ============================================
-- EXPLOIT FUNCTIONS
-- ============================================

-- Try to fire RemoteEvent with common exploit patterns
local function exploitRemote(remote, action, ...)
    local args = {...}
    pcall(function()
        if action == "delete" then
            -- Common delete patterns
            remote:FireServer("Delete", args[1])
            remote:FireServer("Remove", args[1])
            remote:FireServer("Destroy", args[1])
            remote:FireServer({Action = "Delete", Target = args[1]})
            remote:FireServer({action = "delete", object = args[1]})
        elseif action == "edit" then
            -- Common edit patterns
            remote:FireServer("Edit", args[1], args[2], args[3])
            remote:FireServer("Change", args[1], args[2], args[3])
            remote:FireServer("Update", args[1], args[2], args[3])
            remote:FireServer({Action = "Edit", Target = args[1], Property = args[2], Value = args[3]})
        elseif action == "create" then
            -- Common create patterns
            remote:FireServer("Create", args[1], args[2])
            remote:FireServer("Spawn", args[1], args[2])
            remote:FireServer({Action = "Create", Type = args[1], Position = args[2]})
        elseif action == "lighting" then
            -- Lighting control
            remote:FireServer("SetTime", args[1])
            remote:FireServer("ChangeLighting", args[1], args[2])
            remote:FireServer({Action = "Lighting", Property = args[1], Value = args[2]})
        end
    end)
end

-- Brute force all remotes with common patterns
local function bruteForceRemotes(action, ...)
    local count = 0
    for _, remote in pairs(remoteEvents) do
        pcall(function()
            exploitRemote(remote.object, action, ...)
            count = count + 1
        end)
    end
    notify("Sent " .. count .. " exploit attempts", Color3.new(1,0.5,0))
end

-- ============================================
-- CREATE GUI
-- ============================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ServerExploitGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

if player.PlayerGui:FindFirstChild("ServerExploitGUI") then
    player.PlayerGui.ServerExploitGUI:Destroy()
end

ScreenGui.Parent = player.PlayerGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 600, 0, 500)
MainFrame.Position = UDim2.new(0.5, -300, 0.5, -250)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 10)
Corner.Parent = MainFrame

-- Header
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 40)
Header.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Header.BorderSizePixel = 0
Header.Parent = MainFrame

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 10)
HeaderCorner.Parent = Header

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -80, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "⚠️ SERVER-SIDE EXPLOIT CONTROLLER"
Title.TextColor3 = Color3.fromRGB(255, 50, 50)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 35, 0, 35)
CloseBtn.Position = UDim2.new(1, -40, 0, 2.5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 18
CloseBtn.Parent = Header

local CloseBtnCorner = Instance.new("UICorner")
CloseBtnCorner.CornerRadius = UDim.new(0, 6)
CloseBtnCorner.Parent = CloseBtn

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Content
local Content = Instance.new("ScrollingFrame")
Content.Size = UDim2.new(1, -20, 1, -50)
Content.Position = UDim2.new(0, 10, 0, 45)
Content.BackgroundTransparency = 1
Content.BorderSizePixel = 0
Content.ScrollBarThickness = 6
Content.CanvasSize = UDim2.new(0, 0, 0, 1200)
Content.Parent = MainFrame

-- ============================================
-- GUI HELPER FUNCTIONS
-- ============================================
local yPos = 10

local function createSection(name, color)
    local section = Instance.new("TextLabel")
    section.Size = UDim2.new(1, -10, 0, 30)
    section.Position = UDim2.new(0, 5, 0, yPos)
    section.BackgroundColor3 = color or Color3.fromRGB(40, 40, 40)
    section.Text = "  " .. name
    section.TextColor3 = Color3.fromRGB(255, 255, 255)
    section.Font = Enum.Font.GothamBold
    section.TextSize = 14
    section.TextXAlignment = Enum.TextXAlignment.Left
    section.Parent = Content
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = section
    
    yPos = yPos + 35
end

local function createButton(text, color, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 35)
    btn.Position = UDim2.new(0, 5, 0, yPos)
    btn.BackgroundColor3 = color
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 13
    btn.Parent = Content
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn
    
    btn.MouseButton1Click:Connect(callback)
    
    yPos = yPos + 40
    return btn
end

local function createInput(placeholder)
    local input = Instance.new("TextBox")
    input.Size = UDim2.new(1, -10, 0, 35)
    input.Position = UDim2.new(0, 5, 0, yPos)
    input.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    input.PlaceholderText = placeholder
    input.Text = ""
    input.TextColor3 = Color3.fromRGB(255, 255, 255)
    input.Font = Enum.Font.Gotham
    input.TextSize = 13
    input.Parent = Content
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = input
    
    yPos = yPos + 40
    return input
end

-- ============================================
-- BUILD GUI
-- ============================================

createSection("🔍 SCANNER", Color3.fromRGB(0, 100, 200))

createButton("🔎 Scan RemoteEvents", Color3.fromRGB(0, 120, 215), function()
    scanRemotes()
end)

createButton("📋 Print All Remotes (F9 Console)", Color3.fromRGB(100, 100, 200), function()
    print("=== ALL REMOTE EVENTS ===")
    for i, remote in pairs(remoteEvents) do
        print(i .. ". " .. remote.path)
        print("   Object:", remote.object)
    end
    notify("Check console (F9)", Color3.new(0,1,1))
end)

createSection("🗑️ DELETE EXPLOITS", Color3.fromRGB(200, 0, 0))

createButton("Delete Part (Hover Mouse)", Color3.fromRGB(200, 50, 50), function()
    if mouse.Target then
        local target = mouse.Target
        notify("Attempting to delete: " .. target.Name, Color3.new(1,0.5,0))
        
        -- Try all remotes
        for _, remote in pairs(remoteEvents) do
            pcall(function()
                -- Multiple delete patterns
                remote.object:FireServer("Delete", target)
                remote.object:FireServer("Remove", target)
                remote.object:FireServer("Destroy", target)
                remote.object:FireServer({Action = "Delete", Target = target})
                remote.object:FireServer({action = "delete", part = target})
                remote.object:FireServer("DeletePart", target)
                remote.object:FireServer(target, "Delete")
            end)
        end
        
        notify("Sent delete requests", Color3.new(0,1,0))
    else
        notify("No target!", Color3.new(1,0,0))
    end
end)

createButton("Delete All Parts in Workspace", Color3.fromRGB(150, 0, 0), function()
    notify("Mass delete attempt...", Color3.new(1,0.5,0))
    
    for _, obj in pairs(Workspace:GetChildren()) do
        if obj:IsA("Part") or obj:IsA("Model") then
            for _, remote in pairs(remoteEvents) do
                pcall(function()
                    remote.object:FireServer("Delete", obj)
                    remote.object:FireServer("Remove", obj)
                    remote.object:FireServer({Action = "Delete", Target = obj})
                end)
            end
        end
    end
    
    notify("Mass delete sent", Color3.new(0,1,0))
end)

createSection("✏️ EDIT EXPLOITS", Color3.fromRGB(0, 150, 100))

createButton("Make Part Transparent (Mouse)", Color3.fromRGB(0, 180, 120), function()
    if mouse.Target and mouse.Target:IsA("BasePart") then
        local target = mouse.Target
        notify("Trying to make transparent...", Color3.new(1,0.5,0))
        
        for _, remote in pairs(remoteEvents) do
            pcall(function()
                remote.object:FireServer("Edit", target, "Transparency", 1)
                remote.object:FireServer("Change", target, "Transparency", 1)
                remote.object:FireServer({Action = "Edit", Target = target, Property = "Transparency", Value = 1})
                remote.object:FireServer("SetProperty", target, "Transparency", 1)
            end)
        end
        
        notify("Edit requests sent", Color3.new(0,1,0))
    end
end)

createButton("Change Part Color (Mouse - Red)", Color3.fromRGB(200, 0, 0), function()
    if mouse.Target and mouse.Target:IsA("BasePart") then
        local target = mouse.Target
        local red = Color3.fromRGB(255, 0, 0)
        
        for _, remote in pairs(remoteEvents) do
            pcall(function()
                remote.object:FireServer("Edit", target, "Color", red)
                remote.object:FireServer("Change", target, "Color", red)
                remote.object:FireServer({Action = "Edit", Target = target, Property = "Color", Value = red})
                remote.object:FireServer("ChangeColor", target, red)
            end)
        end
        
        notify("Color change sent", Color3.new(0,1,0))
    end
end)

createSection("🌅 LIGHTING EXPLOITS", Color3.fromRGB(255, 200, 0))

createButton("Set Time to Day", Color3.fromRGB(255, 200, 0), function()
    for _, remote in pairs(remoteEvents) do
        pcall(function()
            remote.object:FireServer("SetTime", 14)
            remote.object:FireServer("ChangeTime", 14)
            remote.object:FireServer({Action = "Time", Value = 14})
            remote.object:FireServer("Lighting", "ClockTime", 14)
        end)
    end
    notify("Day time request sent", Color3.new(0,1,0))
end)

createButton("Set Time to Night", Color3.fromRGB(20, 20, 80), function()
    for _, remote in pairs(remoteEvents) do
        pcall(function()
            remote.object:FireServer("SetTime", 0)
            remote.object:FireServer("ChangeTime", 0)
            remote.object:FireServer({Action = "Time", Value = 0})
            remote.object:FireServer("Lighting", "ClockTime", 0)
        end)
    end
    notify("Night time request sent", Color3.new(0,1,0))
end)

createButton("Full Bright Attempt", Color3.fromRGB(255, 255, 0), function()
    for _, remote in pairs(remoteEvents) do
        pcall(function()
            remote.object:FireServer("Lighting", "Brightness", 5)
            remote.object:FireServer("SetBrightness", 5)
            remote.object:FireServer({Action = "Lighting", Property = "Brightness", Value = 5})
        end)
    end
    notify("Brightness request sent", Color3.new(0,1,0))
end)

createSection("💥 DESTRUCTIVE EXPLOITS", Color3.fromRGB(255, 0, 0))

createButton("Explode at Mouse Position", Color3.fromRGB(255, 100, 0), function()
    local pos = mouse.Hit.Position
    
    for _, remote in pairs(remoteEvents) do
        pcall(function()
            remote.object:FireServer("Explode", pos, 50)
            remote.object:FireServer("CreateExplosion", pos, 50)
            remote.object:FireServer({Action = "Explode", Position = pos, Radius = 50})
        end)
    end
    
    notify("Explosion request sent", Color3.new(0,1,0))
end)

createButton("Clear Workspace Attempt", Color3.fromRGB(150, 0, 0), function()
    for _, remote in pairs(remoteEvents) do
        pcall(function()
            remote.object:FireServer("ClearWorkspace")
            remote.object:FireServer("DeleteAll")
            remote.object:FireServer({Action = "Clear"})
            remote.object:FireServer("RemoveAll")
        end)
    end
    notify("Clear request sent", Color3.new(0,1,0))
end)

createSection("🎯 CUSTOM EXPLOIT", Color3.fromRGB(150, 0, 200))

local customInput = createInput("Enter custom command...")

createButton("Fire Custom Command to All Remotes", Color3.fromRGB(150, 0, 200), function()
    local cmd = customInput.Text
    if cmd ~= "" then
        for _, remote in pairs(remoteEvents) do
            pcall(function()
                remote.object:FireServer(cmd)
            end)
        end
        notify("Custom command sent: " .. cmd, Color3.new(0,1,0))
    end
end)

createSection("ℹ️ INFO", Color3.fromRGB(50, 50, 50))

local infoLabel = Instance.new("TextLabel")
infoLabel.Size = UDim2.new(1, -10, 0, 100)
infoLabel.Position = UDim2.new(0, 5, 0, yPos)
infoLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
infoLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
infoLabel.Font = Enum.Font.Gotham
infoLabel.TextSize = 12
infoLabel.TextWrapped = true
infoLabel.TextYAlignment = Enum.TextYAlignment.Top
infoLabel.Text = [[
⚠️ WARNING:
This script attempts to exploit vulnerable RemoteEvents.
It will ONLY work if the game has poor security.

Most modern games have proper validation and this will NOT work.

Use at your own risk. May result in kicks/bans.

Always scan first, then try exploits one by one.
]]
infoLabel.Parent = Content

local infoCorner = Instance.new("UICorner")
infoCorner.CornerRadius = UDim.new(0, 6)
infoCorner.Parent = infoLabel

-- ============================================
-- AUTO SCAN ON START
-- ============================================
task.wait(1)
scanRemotes()

notify("Server Exploit GUI loaded! ⚠️", Color3.new(1,0,0))
print("=================================")
print("SERVER-SIDE EXPLOIT CONTROLLER")
print("Check GUI for options")
print("Press F9 to see console logs")
print("=================================")
