-- MAIN.lua
-- Synt.t Fling (refactored, owner-use / private testing)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local plr = Players.LocalPlayer

-- Helpers
local function safeFind(parent, name, altNames)
    if not parent then return nil end
    local inst = parent:FindFirstChild(name)
    if inst then return inst end
    if altNames then
        for _, alt in ipairs(altNames) do
            inst = parent:FindFirstChild(alt)
            if inst then return inst end
        end
    end
    return nil
end

local function waitChild(parent, name, timeout)
    timeout = timeout or 5
    if not parent then return nil end
    local ok, res = pcall(function() return parent:WaitForChild(name, timeout) end)
    if ok then return res end
    warn(("waitChild %s failed: %s"):format(tostring(name), tostring(res)))
    return nil
end

-- Attach GUI to PlayerGui (stable for testing)
local playerGui = plr:WaitForChild("PlayerGui", 5)
if not playerGui then
    playerGui = Instance.new("ScreenGui")
    playerGui.Name = "PlayerGuiFallback"
    playerGui.Parent = plr
end

local gui = Instance.new("ScreenGui")
gui.Name = "SyntFlingGUI"
gui.ResetOnSpawn = false
gui.Parent = playerGui

-- Frame
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 320, 0, 230)
frame.Position = UDim2.new(0.3, 0, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

-- Title (simple color cycle)
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 35)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.Text = " Synt.t Fling Panel"
title.TextColor3 = Color3.new(1,1,1)
spawn(function()
    while title.Parent do
        title.TextColor3 = Color3.fromHSV((tick() % 5) / 5, 1, 1)
        task.wait(0.1)
    end
end)

-- Name box
local nameBox = Instance.new("TextBox", frame)
nameBox.Size = UDim2.new(0.62, 0, 0, 28)
nameBox.Position = UDim2.new(0.05, 0, 0, 50)
nameBox.PlaceholderText = "Type player name (full or partial)"
nameBox.ClearTextOnFocus = false
nameBox.Font = Enum.Font.Gotham
nameBox.TextSize = 15
nameBox.TextColor3 = Color3.new(1,1,1)
nameBox.BackgroundColor3 = Color3.fromRGB(40,40,40)
Instance.new("UICorner", nameBox).CornerRadius = UDim.new(0, 8)

-- Dropdown button
local dropdownBtn = Instance.new("TextButton", frame)
dropdownBtn.Size = UDim2.new(0.28, 0, 0, 28)
dropdownBtn.Position = UDim2.new(0.69, 0, 0, 50)
dropdownBtn.Text = "Select ▼"
dropdownBtn.Font = Enum.Font.Gotham
dropdownBtn.TextSize = 15
dropdownBtn.TextColor3 = Color3.new(1,1,1)
dropdownBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
Instance.new("UICorner", dropdownBtn).CornerRadius = UDim.new(0, 8)

-- Dropdown container
local dropdownContainer = Instance.new("ScrollingFrame", frame)
dropdownContainer.Size = UDim2.new(0.92, 0, 0, 100)
dropdownContainer.Position = UDim2.new(0.04, 0, 0, 80)
dropdownContainer.BackgroundColor3 = Color3.fromRGB(30,30,30)
dropdownContainer.BorderSizePixel = 0
dropdownContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
dropdownContainer.ScrollBarThickness = 6
dropdownContainer.Visible = false
Instance.new("UICorner", dropdownContainer).CornerRadius = UDim.new(0, 8)

local dropdownButtons = {}
local dropdownUpdating = false

local function clearDropdown()
    for _, btn in ipairs(dropdownButtons) do
        if btn and btn.Parent then btn:Destroy() end
    end
    dropdownButtons = {}
end

local function updateDropdown()
    if dropdownUpdating then return end
    dropdownUpdating = true
    clearDropdown()
    local yPos = 0
    local players = Players:GetPlayers()
    for i, p in ipairs(players) do
        local btn = Instance.new("TextButton", dropdownContainer)
        btn.Size = UDim2.new(1, -10, 0, 25)
        btn.Position = UDim2.new(0, 5, 0, yPos)
        btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 14
        btn.Text = p.Name
        btn.TextColor3 = Color3.new(1,1,1)
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
        btn.AutoButtonColor = true
        btn.MouseButton1Click:Connect(function()
            nameBox.Text = p.Name
            dropdownContainer.Visible = false
        end)
        yPos = yPos + 30
        table.insert(dropdownButtons, btn)
    end
    dropdownContainer.CanvasSize = UDim2.new(0, 0, 0, yPos)
    dropdownUpdating = false
end

task.spawn(function()
    while gui.Parent do
        updateDropdown()
        task.wait(3)
    end
end)

dropdownBtn.MouseButton1Click:Connect(function()
    dropdownContainer.Visible = not dropdownContainer.Visible
    if dropdownContainer.Visible then updateDropdown() end
end)

-- Fling management
local flingSpin = nil
local function startFling()
    if flingSpin and flingSpin.Parent then return end
    if not plr.Character then return end
    local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    flingSpin = Instance.new("BodyAngularVelocity")
    flingSpin.AngularVelocity = Vector3.new(0, 9999, 0)
    flingSpin.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
    flingSpin.P = 10000
    flingSpin.Parent = hrp
end

local function stopFling()
    if flingSpin then
        pcall(function() flingSpin:Destroy() end)
        flingSpin = nil
    end
end

-- Buttons
local flingBtn = Instance.new("TextButton", frame)
flingBtn.Size = UDim2.new(0.92, 0, 0, 35)
flingBtn.Position = UDim2.new(0.04, 0, 0, 190)
flingBtn.Text = "▶️ Fling Once"
flingBtn.Font = Enum.Font.GothamBold
flingBtn.TextSize = 16
flingBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
flingBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", flingBtn).CornerRadius = UDim.new(0, 10)

local loopToggleBtn = Instance.new("TextButton", frame)
loopToggleBtn.Size = UDim2.new(0.4, 0, 0, 35)
loopToggleBtn.Position = UDim2.new(0.05, 0, 0, 145)
loopToggleBtn.Text = " Loop Fling: OFF"
loopToggleBtn.Font = Enum.Font.GothamBold
loopToggleBtn.TextSize = 14
loopToggleBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
loopToggleBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", loopToggleBtn).CornerRadius = UDim.new(0, 10)

local destroyBtn = Instance.new("TextButton", frame)
destroyBtn.Size = UDim2.new(0.4, 0, 0, 35)
destroyBtn.Position = UDim2.new(0.55, 0, 0, 145)
destroyBtn.Text = "❌ Destroy GUI"
destroyBtn.Font = Enum.Font.GothamBold
destroyBtn.TextSize = 14
destroyBtn.BackgroundColor3 = Color3.fromRGB(120, 40, 40)
destroyBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", destroyBtn).CornerRadius = UDim.new(0, 10)

destroyBtn.MouseButton1Click:Connect(function()
    stopFling()
    clearDropdown()
    if gui and gui.Parent then gui:Destroy() end
end)

-- Target finder
local function findTarget(name)
    if not name or name == "" then return nil end
    local nameLower = name:lower()
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= plr and p.Name:lower():sub(1, #nameLower) == nameLower then
            return p
        end
    end
    return nil
end

local function teleportAndFlingOnce(target)
    if not target then return end
    local targetChar = target.Character
    if not targetChar then return end
    local targetHRP = targetChar:FindFirstChild("HumanoidRootPart")
    if not targetHRP then return end
    local myChar = plr.Character
    if not myChar then return end
    local myHRP = myChar:FindFirstChild("HumanoidRootPart")
    if not myHRP then return end
    local ok, err = pcall(function()
        myHRP.CFrame = targetHRP.CFrame + Vector3.new(2, 0, 0)
    end)
    if not ok then warn("Teleport failed:", err) end
    startFling()
end

flingBtn.MouseButton1Click:Connect(function()
    local target = findTarget(nameBox.Text)
    if target then teleportAndFlingOnce(target)
    else
        warn("Player not found:", nameBox.Text)
    end
end)

-- Looping
local looping = false
loopToggleBtn.MouseButton1Click:Connect(function()
    looping = not looping
    loopToggleBtn.Text = looping and " Loop Fling: ON" or " Loop Fling: OFF"
    if not looping then stopFling() end
end)

local loopTick = 0
RunService.Heartbeat:Connect(function(dt)
    if looping then
        loopTick = loopTick + dt
        if loopTick >= 0.15 then
            loopTick = 0
            local target = findTarget(nameBox.Text)
            if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                local myHRP = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
                if myHRP then
                    local ok, err = pcall(function()
                        myHRP.CFrame = target.Character.HumanoidRootPart.CFrame + Vector3.new(2, 0, 0)
                    end)
                    if not ok then warn("Loop teleport failed:", err) end
                    startFling()
                end
            else
                stopFling()
            end
        end
    end
end)

-- Noclip
local noclipEnabled = false
local function setNoclip(state)
    local character = plr.Character
    if not character then return end
    for _, part in ipairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            pcall(function() part.CanCollide = not not state end)
        end
    end
end

RunService.Stepped:Connect(function()
    if noclipEnabled then
        setNoclip(true)
    end
end)

UIS.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.E then
        noclipEnabled = not noclipEnabled
        setNoclip(noclipEnabled)
        pcall(function()
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "Noclip";
                Text = noclipEnabled and "Enabled" or "Disabled";
                Duration = 2;
            })
        end)
    end
end)
