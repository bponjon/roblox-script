-- ILoveU.lua
-- Rebuild fling GUI script (stabil versi)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local plr = Players.LocalPlayer

-- Helpers
local function safeWait(parent, name)
    local ok, obj = pcall(function() return parent:WaitForChild(name, 5) end)
    if ok then return obj end
end

local playerGui = safeWait(plr, "PlayerGui") or Instance.new("ScreenGui", plr)

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "ILoveUFlingGUI"
gui.ResetOnSpawn = false
gui.Parent = playerGui

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 300, 0, 180)
frame.Position = UDim2.new(0.3, 0, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.Active, frame.Draggable = true, true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.Font, title.TextSize = Enum.Font.GothamBold, 18
title.Text = "❤️ ILoveU Fling ❤️"
title.TextColor3 = Color3.new(1,1,1)

-- Input target
local box = Instance.new("TextBox", frame)
box.Size = UDim2.new(0.9, 0, 0, 28)
box.Position = UDim2.new(0.05, 0, 0, 40)
box.PlaceholderText = "Type player name..."
box.Font, box.TextSize = Enum.Font.Gotham, 14
box.TextColor3 = Color3.new(1,1,1)
box.BackgroundColor3 = Color3.fromRGB(40,40,40)
Instance.new("UICorner", box).CornerRadius = UDim.new(0, 8)

-- Buttons
local flingBtn = Instance.new("TextButton", frame)
flingBtn.Size = UDim2.new(0.9, 0, 0, 30)
flingBtn.Position = UDim2.new(0.05, 0, 0, 80)
flingBtn.Text = "▶️ Fling Once"
flingBtn.Font, flingBtn.TextSize = Enum.Font.GothamBold, 14
flingBtn.TextColor3 = Color3.new(1,1,1)
flingBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
Instance.new("UICorner", flingBtn).CornerRadius = UDim.new(0, 8)

local loopBtn = Instance.new("TextButton", frame)
loopBtn.Size = UDim2.new(0.43, 0, 0, 30)
loopBtn.Position = UDim2.new(0.05, 0, 0, 120)
loopBtn.Text = "Loop: OFF"
loopBtn.Font, loopBtn.TextSize = Enum.Font.GothamBold, 14
loopBtn.TextColor3 = Color3.new(1,1,1)
loopBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
Instance.new("UICorner", loopBtn).CornerRadius = UDim.new(0, 8)

local destroyBtn = Instance.new("TextButton", frame)
destroyBtn.Size = UDim2.new(0.43, 0, 0, 30)
destroyBtn.Position = UDim2.new(0.52, 0, 0, 120)
destroyBtn.Text = "❌ Close"
destroyBtn.Font, destroyBtn.TextSize = Enum.Font.GothamBold, 14
destroyBtn.TextColor3 = Color3.new(1,1,1)
destroyBtn.BackgroundColor3 = Color3.fromRGB(120,40,40)
Instance.new("UICorner", destroyBtn).CornerRadius = UDim.new(0, 8)

-- Fling logic
local flingSpin, looping = nil, false
local function startFling()
    if flingSpin and flingSpin.Parent then return end
    local hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    flingSpin = Instance.new("BodyAngularVelocity")
    flingSpin.AngularVelocity = Vector3.new(0, 9999, 0)
    flingSpin.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
    flingSpin.Parent = hrp
end

local function stopFling()
    if flingSpin then flingSpin:Destroy() flingSpin=nil end
end

local function findTarget(name)
    if not name or name=="" then return end
    for _,p in ipairs(Players:GetPlayers()) do
        if p~=plr and p.Name:lower():sub(1,#name:lower())==name:lower() then
            return p
        end
    end
end

local function flingOnce(target)
    local t = target and target.Character and target.Character:FindFirstChild("HumanoidRootPart")
    local my = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
    if not t or not my then return end
    my.CFrame = t.CFrame + Vector3.new(2,0,0)
    startFling()
end

-- Button binds
flingBtn.MouseButton1Click:Connect(function()
    local t = findTarget(box.Text)
    if t then flingOnce(t) else warn("No target") end
end)

loopBtn.MouseButton1Click:Connect(function()
    looping = not looping
    loopBtn.Text = looping and "Loop: ON" or "Loop: OFF"
    if not looping then stopFling() end
end)

destroyBtn.MouseButton1Click:Connect(function()
    stopFling()
    gui:Destroy()
end)

RunService.Heartbeat:Connect(function()
    if looping then
        local t = findTarget(box.Text)
        if t then flingOnce(t) else stopFling() end
    end
end)

-- Noclip (E toggle)
local noclip = false
UIS.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode==Enum.KeyCode.E then
        noclip = not noclip
    end
end)

RunService.Stepped:Connect(function()
    if noclip and plr.Character then
        for _,part in ipairs(plr.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide=false end
        end
    end
end)
