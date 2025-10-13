-- MountYahayuk KW Final Script
-- Semua fitur: Manual Teleport, Auto Summit, Stop, GUI geser, Hide/Close

-- Posisi Checkpoint
local checkpoints = {
    {name="Basecamp", pos=Vector3.new(-16.8994255, 292.997986, -438.799927), cf=CFrame.new(-16.8994255, 292.997986, -438.799927)},
    {name="CP1", pos=Vector3.new(18.6971245, 342.034637, -18.864109), cf=CFrame.new(18.6971245, 342.034637, -18.864109)},
    {name="CP2", pos=Vector3.new(129.73764, 402.06366, 5.28063631), cf=CFrame.new(129.73764, 402.06366, 5.28063631)},
    {name="CP3", pos=Vector3.new(135.903488, 357.782928, 266.350739), cf=CFrame.new(135.903488, 357.782928, 266.350739)},
    {name="CP4", pos=Vector3.new(227.096115, 397.939697, 326.06488), cf=CFrame.new(227.096115, 397.939697, 326.06488)},
    {name="CP5", pos=Vector3.new(861.573914, 370.61972, 79.1034851), cf=CFrame.new(861.573914, 370.61972, 79.1034851)},
    {name="Puncak", pos=Vector3.new(1337.34399, 905.997986, -803.872925), cf=CFrame.new(1337.34399, 905.997986, -803.872925)}
}

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.CoreGui
local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 300, 0, 400)
Frame.Position = UDim2.new(0.7, 0, 0.2, 0)
Frame.BackgroundColor3 = Color3.fromRGB(64, 0, 64) -- ungu tua
Frame.Parent = ScreenGui
Frame.Active = true
Frame.Draggable = true

-- Title
local Title = Instance.new("TextLabel")
Title.Text = "MountYahayuk KW"
Title.Size = UDim2.new(1,0,0,40)
Title.BackgroundColor3 = Color3.fromRGB(0,0,0)
Title.TextColor3 = Color3.fromRGB(255,255,255)
Title.Parent = Frame

-- Buttons Container
local ButtonY = 50

local function CreateButton(name, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 280, 0, 30)
    btn.Position = UDim2.new(0, 10, 0, ButtonY)
    btn.Text = name
    btn.BackgroundColor3 = Color3.fromRGB(48,0,48)
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.Parent = Frame
    btn.MouseButton1Click:Connect(callback)
    ButtonY = ButtonY + 40
    return btn
end

-- Manual Teleport Buttons
for _, cp in ipairs(checkpoints) do
    CreateButton(cp.name, function()
        HumanoidRootPart.CFrame = cp.cf
    end)
end

-- Auto Summit
local autoSummitActive = false
local autoSummitStop = false

local autoBtn = CreateButton("Auto Summit", function()
    autoSummitActive = true
    autoSummitStop = false
    coroutine.wrap(function()
        while autoSummitActive and not autoSummitStop do
            for i, cp in ipairs(checkpoints) do
                if autoSummitStop then break end
                HumanoidRootPart.CFrame = cp.cf
                wait(4) -- delay antar checkpoint
                if cp.name == "Puncak" then
                    wait(10) -- delay di puncak
                    if autoSummitActive and not autoSummitStop then
                        Character:BreakJoints() -- mati otomatis
                        repeat wait() until Character and Character:FindFirstChild("HumanoidRootPart")
                        Character = LocalPlayer.Character
                        HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
                    end
                end
            end
        end
    end)()
end)

-- Stop Button
CreateButton("Stop", function()
    autoSummitStop = true
    autoSummitActive = false
end)

-- Hide Button
local hideBtn = CreateButton("Hide", function()
    Frame.Visible = false
    -- bisa ditambahkan logo draggable
end)

-- Close Button
local closeBtn = CreateButton("Close", function()
    ScreenGui:Destroy()
end)

print("MountYahayuk KW siap digunakan!")
