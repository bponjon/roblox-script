-- MountYahayuk Final Estetik
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

-- Checkpoints
local checkpoints = {
    {Name="Basecamp", Pos=Vector3.new(-16.8994255, 292.997986, -438.799927)},
    {Name="CP1", Pos=Vector3.new(18.6971245, 342.034637, -18.864109)},
    {Name="CP2", Pos=Vector3.new(129.73764, 402.06366, 5.28063631)},
    {Name="CP3", Pos=Vector3.new(135.903488, 357.782928, 266.350739)},
    {Name="CP4", Pos=Vector3.new(227.096115, 397.939697, 326.06488)},
    {Name="CP5", Pos=Vector3.new(861.573914, 370.61972, 79.1034851)},
    {Name="Puncak", Pos=Vector3.new(1338.89172, 902.435425, -778.335144)}
}

-- GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MountYahayukGUI_Estetik"
ScreenGui.Parent = game.CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 180, 0, 200)
MainFrame.Position = UDim2.new(0.5, -90, 0.3, -100)
MainFrame.BackgroundColor3 = Color3.fromRGB(40,0,40)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui
MainFrame.Active = true
MainFrame.Draggable = true

-- Close Button
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 25, 0, 25)
CloseBtn.Position = UDim2.new(1, -30, 0, 5)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255,255,255)
CloseBtn.BackgroundColor3 = Color3.fromRGB(100,0,100)
CloseBtn.Parent = MainFrame
CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

-- Hide Button
local HideBtn = Instance.new("TextButton")
HideBtn.Size = UDim2.new(0, 25, 0, 25)
HideBtn.Position = UDim2.new(1, -60, 0, 5)
HideBtn.Text = "_"
HideBtn.TextColor3 = Color3.fromRGB(255,255,255)
HideBtn.BackgroundColor3 = Color3.fromRGB(100,0,100)
HideBtn.Parent = MainFrame

-- Logo
local LogoBtn = Instance.new("TextButton")
LogoBtn.Size = UDim2.new(0,40,0,40)
LogoBtn.Position = UDim2.new(0.5,-20,0.5,-20)
LogoBtn.Text = "🐉"
LogoBtn.TextColor3 = Color3.fromRGB(150,0,150)
LogoBtn.BackgroundColor3 = Color3.fromRGB(0,0,0)
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

-- Buttons
local AutoSummitBtn = Instance.new("TextButton")
AutoSummitBtn.Size = UDim2.new(0, 90, 0, 25)
AutoSummitBtn.Position = UDim2.new(0,10,0,50)
AutoSummitBtn.Text = "Auto Summit"
AutoSummitBtn.BackgroundColor3 = Color3.fromRGB(120,0,120)
AutoSummitBtn.TextColor3 = Color3.fromRGB(255,255,255)
AutoSummitBtn.Parent = MainFrame

local StopBtn = Instance.new("TextButton")
StopBtn.Size = UDim2.new(0, 50,0,25)
StopBtn.Position = UDim2.new(0,105,0,50)
StopBtn.Text = "Stop"
StopBtn.BackgroundColor3 = Color3.fromRGB(120,0,120)
StopBtn.TextColor3 = Color3.fromRGB(255,255,255)
StopBtn.Parent = MainFrame

local AutoSummitActive = false

local function teleportTo(pos)
    HumanoidRootPart.CFrame = CFrame.new(pos)
end

local function autoSummit()
    AutoSummitActive = true
    spawn(function()
        while AutoSummitActive do
            for i,cp in ipairs(checkpoints) do
                if not AutoSummitActive then break end
                teleportTo(cp.Pos)
                wait(4)
                if cp.Name == "Puncak" then
                    wait(10)
                    local Humanoid = Character:FindFirstChildOfClass("Humanoid")
                    if Humanoid then
                        Humanoid.Health = 0
                    end
                    repeat wait() until LocalPlayer.Character
                    Character = LocalPlayer.Character
                    HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
                end
            end
        end
    end)
end

AutoSummitBtn.MouseButton1Click:Connect(function()
    if not AutoSummitActive then
        autoSummit()
    end
end)

StopBtn.MouseButton1Click:Connect(function()
    AutoSummitActive = false
end)
