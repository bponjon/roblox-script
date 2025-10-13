-- MountYahayuk KW | Auto Summit + GUI Draggable
-- Warna GUI: Ungu Tua + Hitam
-- Checkpoints
local checkpoints = {
    {Name = "Basecamp", CFrame = CFrame.new(-16.8994255, 292.997986, -438.799927)},
    {Name = "CP1", CFrame = CFrame.new(18.6971245, 342.034637, -18.864109)},
    {Name = "CP2", CFrame = CFrame.new(129.73764, 402.06366, 5.28063631)},
    {Name = "CP3", CFrame = CFrame.new(135.903488, 357.782928, 266.350739)},
    {Name = "CP4", CFrame = CFrame.new(227.096115, 397.939697, 326.06488)},
    {Name = "CP5", CFrame = CFrame.new(861.573914, 370.61972, 79.1034851)},
    {Name = "Puncak", CFrame = CFrame.new(1338.89172, 902.435425, -778.335144)},
}

-- Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HRP = Character:WaitForChild("HumanoidRootPart")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Variables
local autosummitActive = false
local stopAuto = false
local guiVisible = true

-- GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MountYahayuk"
ScreenGui.Parent = game:GetService("CoreGui")

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 220, 0, 300)
Frame.Position = UDim2.new(0.5, -110, 0.5, -150)
Frame.BackgroundColor3 = Color3.fromRGB(64, 0, 64)
Frame.BorderSizePixel = 0
Frame.Parent = ScreenGui
Frame.Active = true
Frame.Draggable = true

-- Title
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1,0,0,30)
Title.BackgroundTransparency = 1
Title.Text = "MountYahayuk KW"
Title.TextColor3 = Color3.fromRGB(255,255,255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.Parent = Frame

-- Close Button
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0,30,0,30)
CloseBtn.Position = UDim2.new(1,-30,0,0)
CloseBtn.Text = "X"
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 18
CloseBtn.TextColor3 = Color3.fromRGB(255,255,255)
CloseBtn.BackgroundColor3 = Color3.fromRGB(100,0,100)
CloseBtn.Parent = Frame
CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Hide Button
local HideBtn = Instance.new("TextButton")
HideBtn.Size = UDim2.new(0,30,0,30)
HideBtn.Position = UDim2.new(1,-60,0,0)
HideBtn.Text = "_"
HideBtn.Font = Enum.Font.GothamBold
HideBtn.TextSize = 18
HideBtn.TextColor3 = Color3.fromRGB(255,255,255)
HideBtn.BackgroundColor3 = Color3.fromRGB(100,0,100)
HideBtn.Parent = Frame

local Logo = Instance.new("ImageButton")
Logo.Size = UDim2.new(0,50,0,50)
Logo.Position = UDim2.new(0,10,0,10)
Logo.Image = "rbxassetid://0" -- placeholder
Logo.Visible = false
Logo.BackgroundTransparency = 0.5
Logo.BackgroundColor3 = Color3.fromRGB(64,0,64)
Logo.Parent = ScreenGui
Logo.Active = true
Logo.Draggable = true

HideBtn.MouseButton1Click:Connect(function()
    guiVisible = false
    Frame.Visible = false
    Logo.Visible = true
end)

Logo.MouseButton1Click:Connect(function()
    guiVisible = true
    Frame.Visible = true
    Logo.Visible = false
end)

-- Auto Summit + Stop Buttons
local AutoBtn = Instance.new("TextButton")
AutoBtn.Size = UDim2.new(1, -20, 0, 40)
AutoBtn.Position = UDim2.new(0,10,1,-90)
AutoBtn.Text = "Auto Summit"
AutoBtn.Font = Enum.Font.GothamBold
AutoBtn.TextSize = 16
AutoBtn.TextColor3 = Color3.fromRGB(255,255,255)
AutoBtn.BackgroundColor3 = Color3.fromRGB(64,0,64)
AutoBtn.Parent = Frame

local StopBtn = Instance.new("TextButton")
StopBtn.Size = UDim2.new(1, -20, 0, 40)
StopBtn.Position = UDim2.new(0,10,1,-45)
StopBtn.Text = "Stop"
StopBtn.Font = Enum.Font.GothamBold
StopBtn.TextSize = 16
StopBtn.TextColor3 = Color3.fromRGB(255,255,255)
StopBtn.BackgroundColor3 = Color3.fromRGB(64,0,64)
StopBtn.Parent = Frame

-- Functions
local function teleportToCheckpoint(cp)
    HRP.CFrame = cp.CFrame
end

local function autoSummit()
    autosummitActive = true
    stopAuto = false
    task.spawn(function()
        while autosummitActive do
            for i, cp in ipairs(checkpoints) do
                if stopAuto then break end
                teleportToCheckpoint(cp)
                -- Timer tiap CP
                task.wait(4)
            end
            if stopAuto then break end
            -- Sampai puncak, tunggu 10 detik
            task.wait(10)
            -- Character mati otomatis
            if Character:FindFirstChild("Humanoid") then
                Character.Humanoid.Health = 0
            end
            -- Reset karakter baru / lanjut Auto
            Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
            HRP = Character:WaitForChild("HumanoidRootPart")
            task.wait(1)
        end
    end)
end

AutoBtn.MouseButton1Click:Connect(function()
    if not autosummitActive then
        autoSummit()
    end
end)

StopBtn.MouseButton1Click:Connect(function()
    stopAuto = true
    autosummitActive = false
end)

-- Manual Teleport Buttons (optional, if mau ditambah)
for i, cp in ipairs(checkpoints) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 0, 30)
    btn.Position = UDim2.new(0,10,0, 40 + (i-1)*35)
    btn.Text = cp.Name
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.BackgroundColor3 = Color3.fromRGB(50,0,50)
    btn.Parent = Frame

    btn.MouseButton1Click:Connect(function()
        teleportToCheckpoint(cp)
    end)
end
