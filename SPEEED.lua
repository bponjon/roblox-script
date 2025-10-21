-- ===== MountBingung Movement Tweaks (Client-only, GUI dijamin muncul) =====
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

-- tunggu PlayerGui siap
local pg = player:WaitForChild("PlayerGui")
wait(0.5) -- tambahan delay agar GUI pasti muncul

-- Config
local MIN_WS, MAX_WS = 4, 300
local MIN_JP, MAX_JP = 0, 500

local enabled = false
local forceApply = false
local targetWS = 16
local targetJP = 50
local origWS, origJP = nil, nil
local humanoid, hrp

local function refreshChar()
    local char = player.Character
    if not char then humanoid = nil; hrp = nil; return end
    humanoid = char:FindFirstChildOfClass("Humanoid")
    hrp = char:FindFirstChild("HumanoidRootPart")
    if humanoid and not origWS then origWS = humanoid.WalkSpeed end
    if humanoid and not origJP then
        if humanoid.JumpPower then origJP = humanoid.JumpPower else origJP = humanoid.JumpHeight or 50 end
    end
end

local function applyValues()
    if not humanoid then return end
    local ws = math.clamp(tonumber(targetWS) or 16, MIN_WS, MAX_WS)
    local jp = math.clamp(tonumber(targetJP) or 50, MIN_JP, MAX_JP)
    pcall(function() humanoid.WalkSpeed = ws end)
    pcall(function()
        if humanoid.JumpPower ~= nil then humanoid.JumpPower = jp
        else humanoid.JumpHeight = jp end
    end)
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

-- ===== GUI =====
local screen = Instance.new("ScreenGui")
screen.Name = "MB_WS_JP_Controller"
screen.ResetOnSpawn = false
screen.Parent = pg
screen.Enabled = true

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

-- Close & Hide Buttons
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
info.Text = "Status: OFF | Force: OFF"
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

-- JumpPower controls
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

local jpInc = Instance.new("TextButton", frame)
jpInc.Size = UDim2.new(0,36,0,20)
jpInc.Position = UDim2.new(0,200,0,100)
jpInc.Text = "+"
jpInc.Font = Enum.Font.Gotham
jpInc.BackgroundColor3 = Color3.fromRGB(100,0,100)
jpInc.TextColor3 = Color3.fromRGB(255,255,255)

local jpDec = Instance.new("TextButton", frame)
jpDec.Size = UDim2.new(0,36,0,20)
jpDec.Position = UDim2.new(0,240,0,100)
jpDec.Text = "-"
jpDec.Font = Enum.Font.Gotham
jpDec.BackgroundColor3 = Color3.fromRGB(100,0,100)
jpDec.TextColor3 = Color3.fromRGB(255,255,255)

-- Toggle buttons
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

-- small helper
local function updateInfo()
    info.Text = ("Status: %s | Force: %s | WS:%s JP:%s"):format(enabled and "ON" or "OFF", forceApply and "ON" or "OFF", tostring(targetWS), tostring(targetJP))
end

-- UI bindings
wsInc.MouseButton1Click:Connect(function() targetWS = math.clamp((tonumber(wsBox.Text) or targetWS) + 5, MIN_WS, MAX_WS); wsBox.Text = tostring(targetWS); updateInfo() end)
wsDec.MouseButton1Click:Connect(function() targetWS = math.clamp((tonumber(wsBox.Text) or targetWS) - 5, MIN_WS, MAX_WS); wsBox.Text = tostring(targetWS); updateInfo() end)
jpInc.MouseButton1Click:Connect(function() targetJP = math.clamp((tonumber(jpBox.Text) or targetJP) + 5, MIN_JP, MAX_JP); jpBox.Text = tostring(targetJP); updateInfo() end)
jpDec.MouseButton1Click:Connect(function() targetJP = math.clamp((tonumber(jpBox.Text) or targetJP) - 5, MIN_JP, MAX_JP); jpBox.Text = tostring(targetJP); updateInfo() end)

wsBox.FocusLost:Connect(function(enter) if enter then targetWS = math.clamp(tonumber(wsBox.Text) or targetWS, MIN_WS, MAX_WS); wsBox.Text = tostring(targetWS); updateInfo() end end)
jpBox.FocusLost:Connect(function(enter
