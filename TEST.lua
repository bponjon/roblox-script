-- BynzzBponjon v1.0 - Final Full Script

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local mouse = player:GetMouse()
local UIS = game:GetService("UserInputService")

-- UI Library
local ScreenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
ScreenGui.Name = "BynzzBponjonGUI"

-- Main Frame
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 400, 0, 500)
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -250)
MainFrame.BackgroundColor3 = Color3.fromRGB(0,0,0)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true

-- Top bar with Hide/Close
local TopBar = Instance.new("Frame", MainFrame)
TopBar.Size = UDim2.new(1, 0, 0, 30)
TopBar.BackgroundColor3 = Color3.fromRGB(25,25,25)

local Title = Instance.new("TextLabel", TopBar)
Title.Size = UDim2.new(0.8,0,1,0)
Title.Position = UDim2.new(0,5,0,0)
Title.Text = "BynzzBponjon"
Title.TextColor3 = Color3.fromRGB(255,255,255)
Title.BackgroundTransparency = 1
Title.TextXAlignment = Enum.TextXAlignment.Left

local HideBtn = Instance.new("TextButton", TopBar)
HideBtn.Size = UDim2.new(0,50,1,0)
HideBtn.Position = UDim2.new(0.8,0,0,0)
HideBtn.Text = "Hide"
HideBtn.TextColor3 = Color3.fromRGB(255,255,255)
HideBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)

local CloseBtn = Instance.new("TextButton", TopBar)
CloseBtn.Size = UDim2.new(0,50,1,0)
CloseBtn.Position = UDim2.new(0.95,0,0,0)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255,255,255)
CloseBtn.BackgroundColor3 = Color3.fromRGB(150,0,0)

-- Left Panel (Features)
local LeftPanel = Instance.new("Frame", MainFrame)
LeftPanel.Size = UDim2.new(0,150,1,-30)
LeftPanel.Position = UDim2.new(0,0,0,30)
LeftPanel.BackgroundColor3 = Color3.fromRGB(20,20,20)

-- Right Panel (Controls)
local RightPanel = Instance.new("Frame", MainFrame)
RightPanel.Size = UDim2.new(1, -150, 1, -30)
RightPanel.Position = UDim2.new(0,150,0,30)
RightPanel.BackgroundColor3 = Color3.fromRGB(35,35,35)

-- Feature toggles example
local Features = {"Auto Summit","CP Manual","Auto Death","Server Hop"}
local Toggles = {}

for i,feat in pairs(Features) do
    local btn = Instance.new("TextButton", LeftPanel)
    btn.Size = UDim2.new(1, -10, 0, 40)
    btn.Position = UDim2.new(0,5,0,(i-1)*50)
    btn.Text = feat
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
    
    Toggles[feat] = false
    
    btn.MouseButton1Click:Connect(function()
        Toggles[feat] = not Toggles[feat]
        RightPanel:ClearAllChildren()
        if Toggles[feat] then
            local activeLabel = Instance.new("TextLabel", RightPanel)
            activeLabel.Size = UDim2.new(0.9,0,0,40)
            activeLabel.Position = UDim2.new(0.05,0,0,((i-1)*50))
            activeLabel.Text = feat.." Active"
            activeLabel.TextColor3 = Color3.fromRGB(255,255,255)
            activeLabel.BackgroundColor3 = Color3.fromRGB(80,80,80)
        end
    end)
end

-- Hide/Show Function
local hidden = false
HideBtn.MouseButton1Click:Connect(function()
    hidden = not hidden
    for _,v in pairs(MainFrame:GetChildren()) do
        if v ~= TopBar then
            v.Visible = not hidden
        end
    end
end)

-- Close Function
CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Notification Function
local function Notify(msg,duration)
    duration = duration or 2
    local notif = Instance.new("Frame", ScreenGui)
    notif.Size = UDim2.new(0,200,0,50)
    notif.Position = UDim2.new(0.5,-100,0.2,0)
    notif.BackgroundColor3 = Color3.fromRGB(255,0,0)
    
    local text = Instance.new("TextLabel", notif)
    text.Size = UDim2.new(1,0,1,0)
    text.Text = msg
    text.TextColor3 = Color3.fromRGB(255,255,255)
    text.BackgroundTransparency = 1
    
    delay(duration,function()
        notif:Destroy()
    end)
end

-- Example use
Notify("BynzzBponjon Loaded!",3)

-- Setting panel example
local delaySlider = Instance.new("TextBox", RightPanel)
delaySlider.Size = UDim2.new(0.9,0,0,40)
delaySlider.Position = UDim2.new(0.05,0,0,210)
delaySlider.PlaceholderText = "Delay (sec) 1-inf"
delaySlider.TextColor3 = Color3.fromRGB(255,255,255)
delaySlider.BackgroundColor3 = Color3.fromRGB(80,80,80)

-- Speed TextBox
local speedBox = Instance.new("TextBox", RightPanel)
speedBox.Size = UDim2.new(0.9,0,0,40)
speedBox.Position = UDim2.new(0.05,0,0,260)
speedBox.PlaceholderText = "Speed"
speedBox.TextColor3 = Color3.fromRGB(255,255,255)
speedBox.BackgroundColor3 = Color3.fromRGB(80,80,80)

-- Auto Summit Loop Example
spawn(function()
    while wait(0.1) do
        if Toggles["Auto Summit"] then
            -- Masukin logika auto summit
        end
    end
end)

-- Server Hop Example
spawn(function()
    while wait(0.1) do
        if Toggles["Server Hop"] then
            -- Masukin logika server hop
        end
    end
end)

-- Auto Death Example
spawn(function()
    while wait(0.1) do
        if Toggles["Auto Death"] then
            -- Masukin logika auto death
        end
    end
end)
