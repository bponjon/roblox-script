-- MountBingung AutoSummit + GUI
-- Basecamp → CP1 → CP2 → CP3 → CP4 → CP5 → Puncak
-- Timer tiap CP: 4 detik, Puncak: 10 detik
-- Stop menghentikan AutoSummit dan mencegah karakter mati otomatis

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local AutoSummitOn = false
local StopPressed = false

-- Checkpoints
local Checkpoints = {
    {Name="Basecamp", Pos=Vector3.new(-16.8994255, 292.997986, -438.799927)},
    {Name="CP1", Pos=Vector3.new(18.6971245, 342.034637, -18.864109)},
    {Name="CP2", Pos=Vector3.new(129.73764, 402.06366, 5.28063631)},
    {Name="CP3", Pos=Vector3.new(135.903488, 357.782928, 266.350739)},
    {Name="CP4", Pos=Vector3.new(227.096115, 397.939697, 326.06488)},
    {Name="CP5", Pos=Vector3.new(861.573914, 370.61972, 79.1034851)},
    {Name="Puncak", Pos=Vector3.new(1337.34399, 905.997986, -803.872925)}
}

-- GUI
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "MountBingungGUI"

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0,300,0,400)
MainFrame.Position = UDim2.new(0.5,-150,0.5,-200)
MainFrame.BackgroundColor3 = Color3.fromRGB(64,0,64) -- ungu tua
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true

-- Title
local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1,0,0,30)
Title.Position = UDim2.new(0,0,0,0)
Title.BackgroundColor3 = Color3.fromRGB(0,0,0)
Title.TextColor3 = Color3.fromRGB(255,255,255)
Title.Text = "MountBingung"
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 20

-- Hide Button
local HideButton = Instance.new("TextButton", MainFrame)
HideButton.Size = UDim2.new(0,30,0,30)
HideButton.Position = UDim2.new(1,-60,0,0)
HideButton.Text = "-"
HideButton.BackgroundColor3 = Color3.fromRGB(0,0,0)
HideButton.TextColor3 = Color3.fromRGB(255,255,255)

-- Close Button
local CloseButton = Instance.new("TextButton", MainFrame)
CloseButton.Size = UDim2.new(0,30,0,30)
CloseButton.Position = UDim2.new(1,-30,0,0)
CloseButton.Text = "X"
CloseButton.BackgroundColor3 = Color3.fromRGB(0,0,0)
CloseButton.TextColor3 = Color3.fromRGB(255,255,255)

-- AutoSummit Button
local AutoButton = Instance.new("TextButton", MainFrame)
AutoButton.Size = UDim2.new(0,100,0,30)
AutoButton.Position = UDim2.new(0,10,0,40)
AutoButton.Text = "AutoSummit: OFF"
AutoButton.BackgroundColor3 = Color3.fromRGB(128,0,128)
AutoButton.TextColor3 = Color3.fromRGB(255,255,255)

-- Stop Button
local StopButton = Instance.new("TextButton", MainFrame)
StopButton.Size = UDim2.new(0,60,0,30)
StopButton.Position = UDim2.new(0,120,0,40)
StopButton.Text = "Stop"
StopButton.BackgroundColor3 = Color3.fromRGB(128,0,128)
StopButton.TextColor3 = Color3.fromRGB(255,255,255)

-- Hide/Show Logic
local Hidden = false
HideButton.MouseButton1Click:Connect(function()
    if not Hidden then
        MainFrame.Visible = false
        Hidden = true
    else
        MainFrame.Visible = true
        Hidden = false
    end
end)

-- Close Logic
CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- AutoSummit Logic
AutoButton.MouseButton1Click:Connect(function()
    AutoSummitOn = not AutoSummitOn
    if AutoSummitOn then
        AutoButton.Text = "AutoSummit: ON"
        StopPressed = false
        coroutine.wrap(function()
            while AutoSummitOn and not StopPressed do
                for i, cp in ipairs(Checkpoints) do
                    if StopPressed then break end
                    HumanoidRootPart.CFrame = CFrame.new(cp.Pos)
                    if cp.Name ~= "Puncak" then
                        wait(4) -- timer tiap CP
                    else
                        wait(10) -- tunggu di puncak
                        if not StopPressed then
                            LocalPlayer.Character:BreakJoints() -- mati otomatis
                        end
                    end
                end
            end
        end)()
    else
        AutoButton.Text = "AutoSummit: OFF"
    end
end)

-- Stop Logic
StopButton.MouseButton1Click:Connect(function()
    StopPressed = true
    AutoSummitOn = false
    AutoButton.Text = "AutoSummit: OFF"
end)
