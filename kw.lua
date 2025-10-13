-- Final Yahayuk KW - Loadstring siap pakai
-- =====================================================
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

-- GUI utama
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MountYahayukGUI"
ScreenGui.Parent = game:GetService("CoreGui")

local Frame = Instance.new("Frame")
Frame.Name = "MainFrame"
Frame.Size = UDim2.new(0, 350, 0, 450)
Frame.Position = UDim2.new(0.3,0,0.2,0)
Frame.BackgroundColor3 = Color3.fromRGB(45,0,55) -- ungu tua
Frame.BorderSizePixel = 0
Frame.Parent = ScreenGui
Frame.Active = true
Frame.Draggable = true

-- Tombol Close
local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -35, 0, 5)
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.new(1,1,1)
CloseButton.BackgroundColor3 = Color3.fromRGB(120,0,120)
CloseButton.Parent = Frame
CloseButton.MouseButton1Click:Connect(function()
    ScreenGui.Enabled = false
end)

-- Tombol Hide
local HideButton = Instance.new("TextButton")
HideButton.Size = UDim2.new(0, 30, 0, 30)
HideButton.Position = UDim2.new(1, -70, 0, 5)
HideButton.Text = "-"
HideButton.TextColor3 = Color3.new(1,1,1)
HideButton.BackgroundColor3 = Color3.fromRGB(120,0,120)
HideButton.Parent = Frame

local LogoButton = Instance.new("ImageButton")
LogoButton.Size = UDim2.new(0,50,0,50)
LogoButton.Position = UDim2.new(0.9,0,0.1,0)
LogoButton.Image = "rbxassetid://LOGO_ID" -- ganti nanti
LogoButton.Visible = false
LogoButton.Active = true
LogoButton.Draggable = true
LogoButton.Parent = ScreenGui

HideButton.MouseButton1Click:Connect(function()
    Frame.Visible = false
    LogoButton.Visible = true
end)
LogoButton.MouseButton1Click:Connect(function()
    Frame.Visible = true
    LogoButton.Visible = false
end)

-- Tombol Auto Summit
local AutoSummitBtn = Instance.new("TextButton")
AutoSummitBtn.Size = UDim2.new(0, 120, 0, 35)
AutoSummitBtn.Position = UDim2.new(0,10,1,-80)
AutoSummitBtn.Text = "Auto Summit"
AutoSummitBtn.BackgroundColor3 = Color3.fromRGB(80,0,80)
AutoSummitBtn.TextColor3 = Color3.new(1,1,1)
AutoSummitBtn.Parent = Frame

-- Tombol Stop
local StopBtn = Instance.new("TextButton")
StopBtn.Size = UDim2.new(0, 80, 0, 35)
StopBtn.Position = UDim2.new(0,140,1,-80)
StopBtn.Text = "Stop"
StopBtn.BackgroundColor3 = Color3.fromRGB(80,0,80)
StopBtn.TextColor3 = Color3.new(1,1,1)
StopBtn.Parent = Frame

-- Checkpoints
local Checkpoints = {
    {Name="Basecamp", CFrame=CFrame.new(-16.8994255, 292.997986, -438.799927)},
    {Name="CP1", CFrame=CFrame.new(18.6971245, 342.034637, -18.864109)},
    {Name="CP2", CFrame=CFrame.new(129.73764, 402.06366, 5.28063631)},
    {Name="CP3", CFrame=CFrame.new(135.903488, 357.782928, 266.350739)},
    {Name="CP4", CFrame=CFrame.new(227.096115, 397.939697, 326.06488)},
    {Name="CP5", CFrame=CFrame.new(861.573914, 370.61972, 79.1034851)},
    {Name="Puncak", CFrame=CFrame.new(1338.89172, 902.435425, -778.335144,
        0.978289902, 2.462535736e-09, -0.207240969,
        -2.71482414e-09, 1, -9.32968813e-10,
        0.207240969, 1.47533685e-09, 0.978289902)}
}

-- Status Auto Summit
local AutoSummitActive = false
local StopAutoSummit = false

local function TeleportToCFrame(cf)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = cf
    end
end

-- Fungsi Auto Summit
local function AutoSummit()
    AutoSummitActive = true
    StopAutoSummit = false
    spawn(function()
        while AutoSummitActive and not StopAutoSummit do
            for i, cp in ipairs(Checkpoints) do
                if StopAutoSummit then break end
                TeleportToCFrame(cp.CFrame)
                wait(4)
            end
            wait(10) -- Tunggu di Puncak
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid.Health = 0 -- Mati otomatis
            end
        end
    end)
end

AutoSummitBtn.MouseButton1Click:Connect(function()
    if not AutoSummitActive then
        AutoSummit()
    end
end)

StopBtn.MouseButton1Click:Connect(function()
    StopAutoSummit = true
    AutoSummitActive = false
end)
