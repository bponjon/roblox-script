-- mountbingung_final.lua
-- Script Auto Summit + Manual + GUI (Drag, Hide, Close, Logo)  
-- Warna: Ungu tua + hitam  

-- CONFIG
local CP_DATA = {
    {name="Basecamp", pos=Vector3.new(-16.8994255,292.997986,-438.799927)},
    {name="Checkpoint 1", pos=Vector3.new(18.029, 343.186, -31.423)},
    {name="Checkpoint 2", pos=Vector3.new(123.831, 403.215, -6.046)},
    {name="Checkpoint 3", pos=Vector3.new(135.316, 359.058, 277.262)},
    {name="Checkpoint 4", pos=Vector3.new(233.800, 399.091, 318.996)},
    {name="Checkpoint 5", pos=Vector3.new(861.573914,370.61972,79.1034851)},
    {name="Puncak", pos=Vector3.new(1338.89172,902.435425,-778.335144)}
}

local TELEPORT_DELAY = 4 -- detik antar CP
local PEAK_WAIT = 10 -- detik di puncak
local autosummitActive = false

-- SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumRoot = Character:WaitForChild("HumanoidRootPart")

-- GUI
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "MountbingungGUI"

-- Main Frame
local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0,300,0,400)
Frame.Position = UDim2.new(0.05,0,0.05,0)
Frame.BackgroundColor3 = Color3.fromRGB(48,0,48)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true

-- Title
local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(1,0,0,40)
Title.BackgroundTransparency = 1
Title.Text = "Mountbingung vFinal"
Title.TextColor3 = Color3.fromRGB(255,255,255)
Title.Font = Enum.Font.GothamBold
Title.TextScaled = true

-- Close Button
local CloseBtn = Instance.new("TextButton", Frame)
CloseBtn.Size = UDim2.new(0,30,0,30)
CloseBtn.Position = UDim2.new(1,-35,0,5)
CloseBtn.Text = "X"
CloseBtn.BackgroundColor3 = Color3.fromRGB(150,0,0)
CloseBtn.TextColor3 = Color3.fromRGB(255,255,255)
CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui.Enabled = false
end)

-- Hide Button
local HideBtn = Instance.new("TextButton", Frame)
HideBtn.Size = UDim2.new(0,30,0,30)
HideBtn.Position = UDim2.new(1,-70,0,5)
HideBtn.Text = "_"
HideBtn.BackgroundColor3 = Color3.fromRGB(50,0,50)
HideBtn.TextColor3 = Color3.fromRGB(255,255,255)
local Logo = Instance.new("ImageButton", ScreenGui)
Logo.Size = UDim2.new(0,50,0,50)
Logo.Position = UDim2.new(0,10,0,10)
Logo.Image = "rbxassetid://PUT_YOUR_LOGO_ID_HERE"
Logo.Visible = false
Logo.Active = true
Logo.Draggable = true
HideBtn.MouseButton1Click:Connect(function()
    Frame.Visible = false
    Logo.Visible = true
end)
Logo.MouseButton1Click:Connect(function()
    Frame.Visible = true
    Logo.Visible = false
end)

-- Autosummit Button
local AutoBtn = Instance.new("TextButton", Frame)
AutoBtn.Size = UDim2.new(0,120,0,30)
AutoBtn.Position = UDim2.new(0,10,0,50)
AutoBtn.Text = "Auto Summit"
AutoBtn.BackgroundColor3 = Color3.fromRGB(75,0,75)
AutoBtn.TextColor3 = Color3.fromRGB(255,255,255)
AutoBtn.MouseButton1Click:Connect(function()
    autosummitActive = true
end)

-- Stop Button
local StopBtn = Instance.new("TextButton", Frame)
StopBtn.Size = UDim2.new(0,120,0,30)
StopBtn.Position = UDim2.new(0,150,0,50)
StopBtn.Text = "Stop"
StopBtn.BackgroundColor3 = Color3.fromRGB(150,0,0)
StopBtn.TextColor3 = Color3.fromRGB(255,255,255)
StopBtn.MouseButton1Click:Connect(function()
    autosummitActive = false
end)

-- Checkpoint Buttons
local startY = 90
for i, cp in ipairs(CP_DATA) do
    local Btn = Instance.new("TextButton", Frame)
    Btn.Size = UDim2.new(0,280,0,25)
    Btn.Position = UDim2.new(0,10,0,startY + (i-1)*30)
    Btn.Text = cp.name
    Btn.BackgroundColor3 = Color3.fromRGB(50,0,50)
    Btn.TextColor3 = Color3.fromRGB(255,255,255)
    Btn.MouseButton1Click:Connect(function()
        HumRoot.CFrame = CFrame.new(cp.pos)
    end)
end

-- AUTOSUMMIT LOGIC
spawn(function()
    while true do
        wait(0.1)
        if autosummitActive then
            for i, cp in ipairs(CP_DATA) do
                HumRoot.CFrame = CFrame.new(cp.pos)
                wait(TELEPORT_DELAY)
                if i == #CP_DATA then
                    wait(PEAK_WAIT)
                    -- Simulate character death
                    if Character and Character:FindFirstChild("Humanoid") then
                        Character.Humanoid.Health = 0
                    end
                    wait(1)
                end
                if not autosummitActive then break end
            end
        end
    end
end)
