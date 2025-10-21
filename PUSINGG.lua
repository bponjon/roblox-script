-- MountBingung — WalkSpeed & Force Jump Controller (client-only)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local pg = player:WaitForChild("PlayerGui")

-- Config limits
local MIN_WS, MAX_WS = 4, 300
local MIN_JP, MAX_JP = 0, 500

-- State
local wsEnabled = false
local wsForce = false
local jumpEnabled = false
local targetWS = 16
local targetJP = 50
local origWS, origJP = nil, nil
local humanoid, hrp

-- Refresh character reference
local function refreshChar()
    local char = player.Character
    if not char then humanoid = nil; hrp = nil; return end
    humanoid = char:FindFirstChildOfClass("Humanoid")
    hrp = char:FindFirstChild("HumanoidRootPart")
    if humanoid and not origWS then origWS = humanoid.WalkSpeed end
    if humanoid and not origJP then origJP = humanoid.JumpPower or humanoid.JumpHeight or 50 end
end

-- Apply WalkSpeed
local function applyWS()
    if not humanoid then return end
    local ws = math.clamp(tonumber(targetWS) or 16, MIN_WS, MAX_WS)
    pcall(function() humanoid.WalkSpeed = ws end)
end

-- Restore WalkSpeed
local function restoreWS()
    if humanoid and origWS then
        pcall(function() humanoid.WalkSpeed = origWS end)
    end
end

-- Force jump function
local function forceJump()
    if humanoid and hrp and jumpEnabled then
        -- check if on ground
        if humanoid.FloorMaterial ~= Enum.Material.Air then
            hrp.Velocity = Vector3.new(hrp.Velocity.X, targetJP, hrp.Velocity.Z)
        end
    end
end

-- GUI
local screen = Instance.new("ScreenGui")
screen.Name = "MB_WS_ForceJump_Controller"
screen.ResetOnSpawn = false
screen.Parent = pg

local frame = Instance.new("Frame", screen)
frame.Size = UDim2.new(0,320,0,220)
frame.Position = UDim2.new(0.04,0,0.18,0)
frame.BackgroundColor3 = Color3.fromRGB(35,0,45)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,-80,0,32)
title.Position = UDim2.new(0,10,0,6)
title.Text = "MountBingung — Movement Tweaks"
title.Font = Enum.Font.GothamBold
title.TextSize = 15
title.TextXAlignment = Enum.TextXAlignment.Left
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(245,245,245)

-- Info
local info = Instance.new("TextLabel", frame)
info.Size = UDim2.new(1,-20,0,18)
info.Position = UDim2.new(0,10,0,44)
info.BackgroundTransparency = 1
info.Text = "WS: OFF | Force: OFF | Jump: OFF"
info.Font = Enum.Font.SourceSans
info.TextSize = 12
info.TextColor3 = Color3.fromRGB(210,210,210)
info.TextXAlignment = Enum.TextXAlignment.Left

-- WalkSpeed controls
local wsLabel = Instance.new("TextLabel", frame)
wsLabel.Size = UDim2.new(0,140,0,20)
wsLabel.Position = UDim2.new(0,10,0,70)
wsLabel.BackgroundTransparency = 1
wsLabel.Text = "WalkSpeed:"
wsLabel.Font = Enum.Font.SourceSans
wsLabel.TextColor3 = Color3.fromRGB(220,220,220)
wsLabel.TextXAlignment = Enum.TextXAlignment.Left

local wsBox = Instance.new("TextBox", frame)
wsBox.Size = UDim2.new(0,80,0,20)
wsBox.Position = UDim2.new(0,110,0,70)
wsBox.PlaceholderText = "16"
wsBox.ClearTextOnFocus = false
wsBox.Text = tostring(targetWS)

local wsInc = Instance.new("TextButton", frame)
wsInc.Size = UDim2.new(0,36,0,20)
wsInc.Position = UDim2.new(0,200,0,70)
wsInc.Text = "+"
wsInc.Font = Enum.Font.Gotham
wsInc.BackgroundColor3 = Color3.fromRGB(100,0,100)
wsInc.TextColor3 = Color3.fromRGB(255,255,255)

local wsDec = Instance.new("TextButton", frame)
wsDec.Size = UDim2.new(0,36,0,20)
wsDec.Position = UDim2.new(0,240,0,70)
wsDec.Text = "-"
wsDec.Font = Enum.Font.Gotham
wsDec.BackgroundColor3 = Color3.fromRGB(100,0,100)
wsDec.TextColor3 = Color3.fromRGB(255,255,255)

-- Jump toggle
local jumpBtn = Instance.new("TextButton", frame)
jumpBtn.Size = UDim2.new(0,140,0,36)
jumpBtn.Position = UDim2.new(0,10,0,110)
jumpBtn.Text = "Jump: OFF"
jumpBtn.Font = Enum.Font.GothamBold
jumpBtn.BackgroundColor3 = Color3.fromRGB(70,0,70)
jumpBtn.TextColor3 = Color3.fromRGB(255,255,255)

-- WalkSpeed toggle
local wsBtn = Instance.new("TextButton", frame)
wsBtn.Size = UDim2.new(0,140,0,36)
wsBtn.Position = UDim2.new(0,170,0,110)
wsBtn.Text = "WS: OFF"
wsBtn.Font = Enum.Font.GothamBold
wsBtn.BackgroundColor3 = Color3.fromRGB(0,120,40)
wsBtn.TextColor3 = Color3.fromRGB(255,255,255)

-- Hide icon
local icon = Instance.new("TextButton", screen)
icon.Size = UDim2.new(0,48,0,48)
icon.Position = UDim2.new(0,12,0,120)
icon.BackgroundColor3 = Color3.fromRGB(35,0,45)
icon.Visible = false
icon.Active = true
icon.Draggable = true
icon.Text = "⚙️"
icon.Font = Enum.Font.SourceSans

-- Info update
local function updateInfo()
    info.Text = ("WS: %s | Force: %s | Jump: %s"):format(
        wsEnabled and "ON" or "OFF",
        wsForce and "ON" or "OFF",
        jumpEnabled and "ON" or "OFF"
    )
end

-- UI bindings
wsInc.MouseButton1Click:Connect(function() 
    targetWS = math.clamp(tonumber(wsBox.Text) or targetWS + 5, MIN_WS, MAX_WS)
    wsBox.Text = tostring(targetWS)
    if wsEnabled then applyWS() end
    updateInfo()
end)
wsDec.MouseButton1Click:Connect(function() 
    targetWS = math.clamp(tonumber(wsBox.Text) or targetWS - 5, MIN_WS, MAX_WS)
    wsBox.Text = tostring(targetWS)
    if wsEnabled then applyWS() end
    updateInfo()
end)
wsBox.FocusLost:Connect(function(enter)
    if enter then
        targetWS = math.clamp(tonumber(wsBox.Text) or targetWS, MIN_WS, MAX_WS)
        wsBox.Text = tostring(targetWS)
        if wsEnabled then applyWS() end
        updateInfo()
    end
end)

wsBtn.MouseButton1Click:Connect(function()
    refreshChar()
    if not humanoid then return end
    wsEnabled = not wsEnabled
    if wsEnabled then
        applyWS()
        wsBtn.Text = "WS: ON"
        wsBtn.BackgroundColor3 = Color3.fromRGB(140,20,20)
    else
        restoreWS()
        wsBtn.Text = "WS: OFF"
        wsBtn.BackgroundColor3 = Color3.fromRGB(0,120,40)
    end
    updateInfo()
end)

jumpBtn.MouseButton1Click:Connect(function()
    jumpEnabled = not jumpEnabled
    jumpBtn.Text = "Jump: "..(jumpEnabled and "ON" or "OFF")
    jumpBtn.BackgroundColor3 = jumpEnabled and Color3.fromRGB(170,0,170) or Color3.fromRGB(70,0,70)
    updateInfo()
end)

hideBtn.MouseButton1Click:Connect(function() frame.Visible = false; icon.Visible = true end)
icon.MouseButton1Click:Connect(function() frame.Visible = true; icon.Visible = false end)

-- Heartbeat for force jump & WS
RunService.Heartbeat:Connect(function()
    refreshChar()
    if wsEnabled and wsForce then applyWS() end
    if jumpEnabled then forceJump() end
end)

-- Restore on respawn
player.CharacterAdded:Connect(function()
    wait(0.4)
    refreshChar()
    if wsEnabled then applyWS() end
end)

print("MountBingung Movement Tweaks loaded. GUI ready. WalkSpeed normal, Jump force ON/OFF.")
