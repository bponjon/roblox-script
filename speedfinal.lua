-- ===== MountBingung Movement Tweaks (Client-Side) =====
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local pg = player:WaitForChild("PlayerGui")

-- ===== Config =====
local MIN_WS, MAX_WS = 4, 300
local MIN_JP, MAX_JP = 0, 500

local targetWS = 16
local targetJP = 50
local enabled = false
local forceApply = false
local origWS, origJP
local humanoid

-- ===== Functions =====
local function refreshChar()
    local char = player.Character
    if not char then humanoid = nil; return end
    humanoid = char:FindFirstChildOfClass("Humanoid")
    if humanoid and not origWS then origWS = humanoid.WalkSpeed end
    if humanoid and not origJP then
        if humanoid.JumpPower then origJP = humanoid.JumpPower else origJP = humanoid.JumpHeight or 50 end
    end
end

local function applyValues()
    if humanoid then
        humanoid.WalkSpeed = math.clamp(targetWS, MIN_WS, MAX_WS)
        if humanoid.JumpPower ~= nil then
            humanoid.JumpPower = math.clamp(targetJP, MIN_JP, MAX_JP)
        else
            humanoid.JumpHeight = math.clamp(targetJP, MIN_JP, MAX_JP)
        end
    end
end

local function restoreOriginal()
    if humanoid then
        if origWS then humanoid.WalkSpeed = origWS end
        if origJP then
            if humanoid.JumpPower ~= nil then humanoid.JumpPower = origJP
            else humanoid.JumpHeight = origJP end
        end
    end
end

-- ===== GUI =====
local screen = Instance.new("ScreenGui")
screen.Name = "MB_WS_JP_Controller"
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

local closeBtn = Instance.new("TextButton", frame)
closeBtn.Size = UDim2.new(0,46,0,28)
closeBtn.Position = UDim2.new(1,-52,0,6)
closeBtn.Text = "X"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.BackgroundColor3 = Color3.fromRGB(150,20,20)
closeBtn.TextColor3 = Color3.fromRGB(255,255,255)
closeBtn.MouseButton1Click:Connect(function()
    enabled = false
    restoreOriginal()
    screen:Destroy()
end)

local info = Instance.new("TextLabel", frame)
info.Size = UDim2.new(1,-20,0,18)
info.Position = UDim2.new(0,10,0,44)
info.BackgroundTransparency = 1
info.Text = "Status: OFF | Force: OFF | WS:16 JP:50"
info.Font = Enum.Font.SourceSans
info.TextSize = 12
info.TextColor3 = Color3.fromRGB(210,210,210)
info.TextXAlignment = Enum.TextXAlignment.Left

-- WalkSpeed
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

-- JumpPower
local jpLabel = Instance.new("TextLabel", frame)
jpLabel.Size = UDim2.new(0,140,0,20)
jpLabel.Position = UDim2.new(0,10,0,100)
jpLabel.BackgroundTransparency = 1
jpLabel.Text = "JumpPower:"
jpLabel.Font = Enum.Font.SourceSans
jpLabel.TextColor3 = Color3.fromRGB(220,220,220)
jpLabel.TextXAlignment = Enum.TextXAlignment.Left

local jpBox = Instance.new("TextBox", frame)
jpBox.Size = UDim2.new(0,80,0,20)
jpBox.Position = UDim2.new(0,110,0,100)
jpBox.PlaceholderText = "50"
jpBox.ClearTextOnFocus = false
jpBox.Text = tostring(targetJP)

-- Buttons
local enableBtn = Instance.new("TextButton", frame)
enableBtn.Size = UDim2.new(0,140,0,36)
enableBtn.Position = UDim2.new(0,10,0,140)
enableBtn.Text = "Enable"
enableBtn.Font = Enum.Font.GothamBold
enableBtn.BackgroundColor3 = Color3.fromRGB(0,120,40)
enableBtn.TextColor3 = Color3.fromRGB(255,255,255)

local forceBtn = Instance.new("TextButton", frame)
forceBtn.Size = UDim2.new(0,140,0,36)
forceBtn.Position = UDim2.new(0,170,0,140)
forceBtn.Text = "Force: OFF"
forceBtn.Font = Enum.Font.GothamBold
forceBtn.BackgroundColor3 = Color3.fromRGB(90,0,90)
forceBtn.TextColor3 = Color3.fromRGB(255,255,255)

local function updateInfo()
    info.Text = ("Status: %s | Force: %s | WS:%s JP:%s"):format(enabled and "ON" or "OFF", forceApply and "ON" or "OFF", tostring(targetWS), tostring(targetJP))
end

-- UI interactions
enableBtn.MouseButton1Click:Connect(function()
    refreshChar()
    if not humanoid then info.Text = "No character"; return end
    targetWS = tonumber(wsBox.Text) or targetWS
    targetJP = tonumber(jpBox.Text) or targetJP
    if not enabled then
        applyValues()
        enabled = true
        enableBtn.Text = "Disable"
        enableBtn.BackgroundColor3 = Color3.fromRGB(140,20,20)
    else
        enabled = false
        enableBtn.Text = "Enable"
        enableBtn.BackgroundColor3 = Color3.fromRGB(0,120,40)
        restoreOriginal()
    end
    updateInfo()
end)

forceBtn.MouseButton1Click:Connect(function()
    forceApply = not forceApply
    forceBtn.Text = "Force: "..(forceApply and "ON" or "OFF")
    forceBtn.BackgroundColor3 = forceApply and Color3.fromRGB(170,0,170) or Color3.fromRGB(90,0,90)
    updateInfo()
end)

wsBox.FocusLost:Connect(function(enter)
    if enter then targetWS = tonumber(wsBox.Text) or targetWS; updateInfo(); if enabled then applyValues() end
end)
jpBox.FocusLost:Connect(function(enter)
    if enter then targetJP = tonumber(jpBox.Text) or targetJP; updateInfo(); if enabled then applyValues() end
end)

-- Force re-apply every frame
RunService.Heartbeat:Connect(function()
    refreshChar()
    if enabled and humanoid and forceApply then
        applyValues()
    end
end)

-- Refresh on respawn
player.CharacterAdded:Connect(function()
    wait(0.3)
    refreshChar()
    if enabled then applyValues() end
    updateInfo()
end)

-- Initial refresh
refreshChar()
updateInfo()
print("MountBingung Movement Tweaks loaded! Use GUI to enable/disable. Client-side only.")
