-- Final Yahayuk KW (HP Ready)
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local RunService = game:GetService("RunService")
local Debris = game:GetService("Debris")

-- Checkpoints
local Checkpoints = {
    {Name="Basecamp", Pos=Vector3.new(-16.8994255,292.997986,-438.799927)},
    {Name="CP1", Pos=Vector3.new(18.6971245,342.034637,-18.864109)},
    {Name="CP2", Pos=Vector3.new(129.73764,402.06366,5.28063631)},
    {Name="CP3", Pos=Vector3.new(135.903488,357.782928,266.350739)},
    {Name="CP4", Pos=Vector3.new(227.096115,397.939697,326.06488)},
    {Name="Puncak", Pos=Vector3.new(861.573914,370.61972,79.1034851)}
}

-- GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MountYahayukKW"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0,300,0,400)
MainFrame.Position = UDim2.new(0.5,-150,0.2,0)
MainFrame.BackgroundColor3 = Color3.fromRGB(50,0,50) -- ungu tua
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui
MainFrame.Active = true
MainFrame.Draggable = true

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1,0,0,30)
Title.BackgroundTransparency = 1
Title.Text = "Mount Yahayuk KW"
Title.TextColor3 = Color3.fromRGB(255,255,255)
Title.Parent = MainFrame

-- Close Button
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0,30,0,30)
CloseBtn.Position = UDim2.new(1,-30,0,0)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255,255,255)
CloseBtn.BackgroundColor3 = Color3.fromRGB(100,0,0)
CloseBtn.Parent = MainFrame
CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Hide Button
local HideBtn = Instance.new("TextButton")
HideBtn.Size = UDim2.new(0,30,0,30)
HideBtn.Position = UDim2.new(1,-60,0,0)
HideBtn.Text = "_"
HideBtn.TextColor3 = Color3.fromRGB(255,255,255)
HideBtn.BackgroundColor3 = Color3.fromRGB(50,0,50)
HideBtn.Parent = MainFrame

local LogoBtn = Instance.new("ImageButton")
LogoBtn.Size = UDim2.new(0,50,0,50)
LogoBtn.Position = UDim2.new(0,20,0,100)
LogoBtn.Image = "rbxassetid://LOGO_DECAL_ID" -- ganti nanti
LogoBtn.Visible = false
LogoBtn.Parent = ScreenGui
LogoBtn.Active = true
LogoBtn.Draggable = true

HideBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    LogoBtn.Visible = true
end)
LogoBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    LogoBtn.Visible = false
end)

-- Auto Summit
local AutoSummitActive = false
local StopAuto = false
local AutoBtn = Instance.new("TextButton")
AutoBtn.Size = UDim2.new(0,120,0,30)
AutoBtn.Position = UDim2.new(0,10,0,40)
AutoBtn.Text = "Auto Summit"
AutoBtn.TextColor3 = Color3.fromRGB(255,255,255)
AutoBtn.BackgroundColor3 = Color3.fromRGB(0,50,0)
AutoBtn.Parent = MainFrame

local StopBtn = Instance.new("TextButton")
StopBtn.Size = UDim2.new(0,120,0,30)
StopBtn.Position = UDim2.new(0,140,0,40)
StopBtn.Text = "Stop"
StopBtn.TextColor3 = Color3.fromRGB(255,255,255)
StopBtn.BackgroundColor3 = Color3.fromRGB(50,0,0)
StopBtn.Parent = MainFrame

AutoBtn.MouseButton1Click:Connect(function()
    AutoSummitActive = true
    StopAuto = false
end)
StopBtn.MouseButton1Click:Connect(function()
    StopAuto = true
    AutoSummitActive = false
end)

-- Manual Summit Buttons
local yPos = 80
for i,cp in ipairs(Checkpoints) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1,-20,0,30)
    btn.Position = UDim2.new(0,10,0,yPos)
    btn.Text = cp.Name
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.BackgroundColor3 = Color3.fromRGB(50,0,50)
    btn.Parent = MainFrame
    btn.MouseButton1Click:Connect(function()
        LocalPlayer.Character:SetPrimaryPartCFrame(CFrame.new(cp.Pos))
    end)
    yPos = yPos + 40
end

-- Function Teleport Auto Summit
spawn(function()
    while true do
        wait(0.1)
        if AutoSummitActive and not StopAuto and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            for i,cp in ipairs(Checkpoints) do
                if StopAuto then break end
                local hrp = LocalPlayer.Character.HumanoidRootPart
                hrp.CFrame = CFrame.new(cp.Pos)
                wait(4) -- Timer tiap CP
            end
            if StopAuto then continue end
            wait(10) -- Timer di puncak
            if LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid.Health = 0
            end
        end
        wait(0.1)
    end
end)
