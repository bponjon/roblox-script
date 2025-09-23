-- Teleport Fling + Return + GUI (versi lengkap)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local LocalPlayer = Players.LocalPlayer

-- State flags
local noclipEnabled = false
local antiFallEnabled = false
local AllBool = false

-- Helpers
local function notify(title, text, duration)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = title,
            Text = text,
            Duration = duration or 3
        })
    end)
end

local function toggleNoclip()
    noclipEnabled = not noclipEnabled
    if noclipEnabled then
        notify("Noclip", "Enabled", 3)
    else
        notify("Noclip", "Disabled", 3)
    end
end

local function toggleAntiFall()
    antiFallEnabled = not antiFallEnabled
    if antiFallEnabled then
        notify("AntiFall", "Enabled (NDS)", 3)
    else
        notify("AntiFall", "Disabled", 3)
    end
end

local function getTarget(name)
    local nm = name:lower()
    if nm == "random" then
        local list = {}
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then
                table.insert(list, p)
            end
        end
        return #list > 0 and list[math.random(1, #list)] or nil
    elseif nm == "all" or nm == "others" then
        AllBool = true
        return nil
    else
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and (p.Name:lower():match("^"..nm) or p.DisplayName:lower():match("^"..nm)) then
                return p
            end
        end
    end
    return nil
end

local function teleportFlingReturn(target)
    if not target or not target.Character then notify("Error", "Target invalid", 3); return end
    local myChar = LocalPlayer.Character
    if not myChar then return end
    local hrp = myChar:FindFirstChild("HumanoidRootPart")
    local thrp = target.Character:FindFirstChild("HumanoidRootPart")
    if not hrp or not thrp then notify("Error", "Parts missing", 3); return end

    local originalCFrame = hrp.CFrame

    -- Teleport
    hrp.CFrame = thrp.CFrame

    -- Fling
    local bv = Instance.new("BodyAngularVelocity")
    bv.MaxTorque = Vector3.new(1e5,1e5,1e5)
    bv.P = 1e4
    bv.AngularVelocity = Vector3.new(0,9e9,0)
    bv.Parent = hrp

    task.wait(0.2)
    if bv.Parent then bv:Destroy() end

    -- Return
    hrp.CFrame = originalCFrame
end

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "MyFlingUI"
gui.ResetOnSpawn = false
gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 280, 0, 200)
frame.Position = UDim2.new(0.7, 0, 0.2, 0)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
frame.BorderSizePixel = 0
local uiCorner = Instance.new("UICorner", frame)
uiCorner.CornerRadius = UDim.new(0,8)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, -12, 0, 30)
title.Position = UDim2.new(0,6,0,6)
title.BackgroundTransparency = 1
title.Text = "Fling GUI"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 18

local inputBox = Instance.new("TextBox", frame)
inputBox.Size = UDim2.new(1, -12, 0, 32)
inputBox.Position = UDim2.new(0,6,0,50)
inputBox.PlaceholderText = "Target name / Random / All"
inputBox.BackgroundColor3 = Color3.fromRGB(40,40,40)
inputBox.TextColor3 = Color3.new(1,1,1)
inputBox.ClearTextOnFocus = false
inputBox.Font = Enum.Font.SourceSans
inputBox.TextSize = 16

local flingBtn = Instance.new("TextButton", frame)
flingBtn.Size = UDim2.new(0.48, -6, 0, 36)
flingBtn.Position = UDim2.new(0.05, 0, 0.7, 0)
flingBtn.Text = "Fling"
flingBtn.Font = Enum.Font.SourceSansBold
flingBtn.TextSize = 16
flingBtn.BackgroundColor3 = Color3.fromRGB(70,70,70)
flingBtn.TextColor3 = Color3.new(1,1,1)

local closeBtn = Instance.new("TextButton", frame)
closeBtn.Size = UDim2.new(0.48, -6, 0, 36)
closeBtn.Position = UDim2.new(0.50, 0, 0.7, 0)
closeBtn.Text = "Close"
closeBtn.Font = Enum.Font.SourceSansBold
closeBtn.TextSize = 16
closeBtn.BackgroundColor3 = Color3.fromRGB(120,40,40)
closeBtn.TextColor3 = Color3.new(1,1,1)

-- Button logic
flingBtn.MouseButton1Click:Connect(function()
    local text = inputBox.Text or ""
    if text == "" then notify("Error", "Enter a name", 3); return end
    local target = getTarget(text)
    if AllBool then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then
                teleportFlingReturn(p)
            end
        end
    elseif target then
        teleportFlingReturn(target)
    else
        notify("Error", "Target not found", 3)
    end
    AllBool = false
end)

closeBtn.MouseButton1Click:Connect(function()
    gui:Destroy()
end)
