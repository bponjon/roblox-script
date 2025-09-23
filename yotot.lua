--// Refactor SkidFling GUI Script (Mkt6djAP)
-- Fitur: SkidFling, Fling All, Random, Noclip, AntiFallDamage (NDS), GUI tombol

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- Helper safe find
local function safeFind(inst, name)
    if inst and inst:FindFirstChild(name) then
        return inst[name]
    end
    return nil
end

-- Noclip toggle
local noclip = false
RunService.Stepped:Connect(function()
    if noclip and LocalPlayer.Character then
        for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
    end
end)

-- Anti Fall Damage (khusus Natural Disaster Survival)
local function antiFallDamage()
    local char = LocalPlayer.Character
    if not char then return end
    local hum = safeFind(char, "Humanoid")
    if hum then
        hum.StateChanged:Connect(function(_, newState)
            if newState == Enum.HumanoidStateType.Freefall then
                hum:ChangeState(Enum.HumanoidStateType.GettingUp)
            end
        end)
    end
end

-- SkidFling function
local function skidFling(target)
    if not target or not target.Character then return end
    local hrp = safeFind(LocalPlayer.Character, "HumanoidRootPart")
    local thrp = safeFind(target.Character, "HumanoidRootPart")
    if not hrp or not thrp then return end

    local bv = Instance.new("BodyAngularVelocity")
    bv.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    bv.AngularVelocity = Vector3.new(9e9, 9e9, 9e9)
    bv.Parent = hrp

    local start = tick()
    while target.Character and safeFind(target.Character, "HumanoidRootPart") 
          and tick() - start < 5 do
        hrp.CFrame = thrp.CFrame
        RunService.Heartbeat:Wait()
    end

    bv:Destroy()
end

-- Buat GUI
local ScreenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
ScreenGui.Name = "FlingGui"

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 200, 0, 250)
Frame.Position = UDim2.new(0.05, 0, 0.25, 0)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.Active = true
Frame.Draggable = true

local function makeButton(text, yPos, callback)
    local btn = Instance.new("TextButton", Frame)
    btn.Size = UDim2.new(1, -20, 0, 30)
    btn.Position = UDim2.new(0, 10, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 16
    btn.Text = text
    btn.MouseButton1Click:Connect(callback)
    return btn
end

makeButton("Fling Random", 10, function()
    local plist = Players:GetPlayers()
    if #plist > 1 then
        local target = plist[math.random(1, #plist)]
        if target ~= LocalPlayer then
            skidFling(target)
        end
    end
end)

makeButton("Fling All", 50, function()
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            skidFling(p)
        end
    end
end)

makeButton("Toggle Noclip", 90, function()
    noclip = not noclip
end)

makeButton("Anti Fall Damage", 130, function()
    antiFallDamage()
end)

makeButton("Close", 170, function()
    ScreenGui:Destroy()
end)
