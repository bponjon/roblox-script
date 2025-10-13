-- MountYahayuk.lua
-- Final versi stabil, autosummit + manual teleport + GUI draggable + hide/close
-- Warna GUI: ungu tua + hitam

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")

--================= Config =================--
local Checkpoints = {
    {name="Basecamp", pos=Vector3.new(-16.8994255,292.997986,-438.799927)},
    {name="CP1", pos=Vector3.new(18.6971245,342.034637,-18.864109)},
    {name="CP2", pos=Vector3.new(129.73764,402.06366,5.28063631)},
    {name="CP3", pos=Vector3.new(135.903488,357.782928,266.350739)},
    {name="CP4", pos=Vector3.new(227.096115,397.939697,326.06488)},
    {name="CP5", pos=Vector3.new(861.573914,370.61972,79.1034851)},
    {name="Puncak", pos=Vector3.new(1338.89172,902.435425,-778.335144)},
}

local TELEPORT_DELAY = 4 -- detik tiap CP
local PEAK_WAIT = 10     -- detik tunggu pas puncak

--================= GUI =================--
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MountYahayukGui"
ScreenGui.Parent = game.CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0,250,0,300)
MainFrame.Position = UDim2.new(0.5,-125,0.3,0)
MainFrame.BackgroundColor3 = Color3.fromRGB(55,0,55) -- ungu tua
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui
MainFrame.Active = true
MainFrame.Draggable = true

local UIPadding = Instance.new("UIPadding")
UIPadding.PaddingTop = UDim.new(0,5)
UIPadding.PaddingLeft = UDim.new(0,5)
UIPadding.Parent = MainFrame

-- Hide & Close Buttons
local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0,20,0,20)
CloseButton.Position = UDim2.new(1,-25,0,5)
CloseButton.Text = "X"
CloseButton.BackgroundColor3 = Color3.fromRGB(150,0,0)
CloseButton.TextColor3 = Color3.new(1,1,1)
CloseButton.Parent = MainFrame

local HideButton = Instance.new("TextButton")
HideButton.Size = UDim2.new(0,20,0,20)
HideButton.Position = UDim2.new(1,-50,0,5)
HideButton.Text = "_"
HideButton.BackgroundColor3 = Color3.fromRGB(50,0,50)
HideButton.TextColor3 = Color3.new(1,1,1)
HideButton.Parent = MainFrame

local ButtonsFrame = Instance.new("Frame")
ButtonsFrame.Size = UDim2.new(1,0,1,-30)
ButtonsFrame.Position = UDim2.new(0,0,0,30)
ButtonsFrame.BackgroundTransparency = 1
ButtonsFrame.Parent = MainFrame

-- Autosummit + Stop Buttons
local AutoButton = Instance.new("TextButton")
AutoButton.Size = UDim2.new(1,0,0,30)
AutoButton.Position = UDim2.new(0,0,0,0)
AutoButton.Text = "Auto Summit"
AutoButton.BackgroundColor3 = Color3.fromRGB(75,0,75)
AutoButton.TextColor3 = Color3.new(1,1,1)
AutoButton.Parent = ButtonsFrame

local StopButton = Instance.new("TextButton")
StopButton.Size = UDim2.new(1,0,0,30)
StopButton.Position = UDim2.new(0,0,0,35)
StopButton.Text = "Stop"
StopButton.BackgroundColor3 = Color3.fromRGB(150,0,0)
StopButton.TextColor3 = Color3.new(1,1,1)
StopButton.Parent = ButtonsFrame

-- Manual Teleport Buttons
local yPos = 70
for i,cp in ipairs(Checkpoints) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1,0,0,30)
    btn.Position = UDim2.new(0,0,0,yPos)
    btn.Text = cp.name
    btn.BackgroundColor3 = Color3.fromRGB(50,0,50)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Parent = ButtonsFrame
    btn.MouseButton1Click:Connect(function()
        local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = CFrame.new(cp.pos)
        end
    end)
    yPos = yPos + 35
end

--================= Logic =================--
local autosummitActive = false
local stopAuto = false

local function AutoSummit()
    if autosummitActive then return end
    autosummitActive = true
    stopAuto = false
    spawn(function()
        while autosummitActive and not stopAuto do
            for i,cp in ipairs(Checkpoints) do
                local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    hrp.CFrame = CFrame.new(cp.pos)
                end
                if cp.name == "Puncak" then
                    wait(PEAK_WAIT)
                    local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
                    if humanoid then
                        humanoid.Health = 0
                    end
                    wait(1)
                else
                    wait(TELEPORT_DELAY)
                end
                if stopAuto then break end
            end
        end
        autosummitActive = false
    end)
end

AutoButton.MouseButton1Click:Connect(AutoSummit)
StopButton.MouseButton1Click:Connect(function()
    stopAuto = true
end)

-- GUI Controls
CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

HideButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
end)

-- GUI Draggable toggle
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        -- bisa ditambah draggable manual
    end
end)
