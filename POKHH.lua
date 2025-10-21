-- MountBingung — WalkSpeed & JumpPower Controller (client-only)
-- Execute via loadstring on client / LocalScript. Changes affect local player only.

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local pg = player:WaitForChild("PlayerGui")

-- Config limits
local MIN_WS, MAX_WS = 4, 300
local MIN_JP, MAX_JP = 0, 500

-- State
local enabled = false
local jpEnabled = false
local forceApply = false
local targetWS = 16
local targetJP = 50
local origWS, origJP = nil, nil
local humanoid

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
    if not humanoid then return end
    -- WalkSpeed
    local ws = math.clamp(tonumber(targetWS) or 16, MIN_WS, MAX_WS)
    pcall(function() humanoid.WalkSpeed = ws end)
    -- JumpPower if enabled
    if jpEnabled then
        local jp = math.clamp(tonumber(targetJP) or 50, MIN_JP, MAX_JP)
        pcall(function()
            if humanoid.JumpPower ~= nil then humanoid.JumpPower = jp
            else humanoid.JumpHeight = jp
            end
        end)
    end
end

local function restoreOriginal()
    if not humanoid then return end
    if origWS then pcall(function() humanoid.WalkSpeed = origWS end) end
    if origJP then
        pcall(function()
            if humanoid.JumpPower ~= nil then humanoid.JumpPower = origJP
            else humanoid.JumpHeight = origJP end
        end)
    end
end

-- GUI
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

-- Close and hide
local closeBtn = Instance.new("TextButton", frame)
closeBtn.Size = UDim2.new(0,46,0,28)
closeBtn.Position = UDim2.new(1,-52,0,6)
closeBtn.Text = "X"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.BackgroundColor3 = Color3.fromRGB(150,20,20)
closeBtn.TextColor3 = Color3.fromRGB(255,255,255)

local hideBtn = Instance.new("TextButton", frame)
hideBtn.Size = UDim2.new(0,36,0,28)
hideBtn.Position = UDim2.new(1,-100,0,6)
hideBtn.Text = "_"
hideBtn.Font = Enum.Font.GothamBold
hideBtn.BackgroundColor3 = Color3.fromRGB(70,0,70)
hideBtn.TextColor3 = Color3.fromRGB(255,255,255)

local info = Instance.new("TextLabel", frame)
info.Size = UDim2.new(1,-20,0,18)
info.Position = UDim2.new(0,10,0,44)
info.BackgroundTransparency = 1
info.Text = "Status: OFF | JP: OFF"
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

-- JumpPower toggle
local jpBtn = Instance.new("TextButton", frame)
jpBtn.Size = UDim2.new(0,140,0,36)
jpBtn.Position = UDim2.new(0,10,0,140)
jpBtn.Text = "Jump: OFF"
jpBtn.Font = Enum.Font.GothamBold
jpBtn.BackgroundColor3 = Color3.fromRGB(90,0,90)
jpBtn.TextColor3 = Color3.fromRGB(255,255,255)

-- Hide icon 🚀
local icon = Instance.new("TextButton", screen)
icon.Size = UDim2.new(0,48,0,48)
icon.Position = UDim2.new(0,12,0,120)
icon.BackgroundColor3 = Color3.fromRGB(35,0,45)
icon.Visible = false
icon.Active = true
icon.Draggable = true
icon.Text = "🚀"
icon.Font = Enum.Font.SourceSans

-- Helper
local function updateInfo()
    info.Text = ("Status: %s | JP: %s | WS:%s"):format(enabled and "ON" or "OFF", jpEnabled and "ON" or "OFF", tostring(targetWS))
end

-- Bindings
wsBox.FocusLost:Connect(function(enter)
    if enter then targetWS = math.clamp(tonumber(wsBox.Text) or targetWS, MIN_WS, MAX_WS); wsBox.Text = tostring(targetWS); applyValues(); updateInfo() end
end)

jpBtn.MouseButton1Click:Connect(function()
    jpEnabled = not jpEnabled
    jpBtn.Text = "Jump: "..(jpEnabled and "ON" or "OFF")
    jpBtn.BackgroundColor3 = jpEnabled and Color3.fromRGB(170,0,170) or Color3.fromRGB(90,0,90)
    applyValues()
    updateInfo()
end)

hideBtn.MouseButton1Click:Connect(function() frame.Visible = false; icon.Visible = true end)
icon.MouseButton1Click:Connect(function() frame.Visible = true; icon.Visible = false end)
closeBtn.MouseButton1Click:Connect(function() restoreOriginal(); screen:Destroy() end)

-- Heartbeat reapply
RunService.Heartbeat:Connect(function()
    if not humanoid or not humanoid.Parent then refreshChar() end
    if enabled or jpEnabled then applyValues() end
end)

-- Respawn
player.CharacterAdded:Connect(function()
    wait(0.4)
    refreshChar()
    applyValues()
    updateInfo()
end)

refreshChar()
updateInfo()

print("MountBingung Movement Tweaks loaded. GUI ready. WalkSpeed normal, Jump toggle available. 🚀 icon hide/show implemented.")
