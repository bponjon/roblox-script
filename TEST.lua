-- GUI Cek Script
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")

-- ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CekGUI"
screenGui.Parent = PlayerGui

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 400, 0, 350)
mainFrame.Position = UDim2.new(0.5, -200, 0.5, -175)
mainFrame.BackgroundColor3 = Color3.new(0,0,0)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

-- UIListLayout
local layout = Instance.new("UIListLayout")
layout.Parent = mainFrame
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Padding = UDim.new(0,5)

-- Function create button
local function createButton(text)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 40)
    btn.BackgroundColor3 = Color3.fromRGB(30,30,30)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Text = text
    btn.TextScaled = true
    btn.Parent = mainFrame

    btn.MouseEnter:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(50,0,0)
    end)
    btn.MouseLeave:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(30,30,30)
    end)
    return btn
end

-- Buttons
local autoSummitBtn = createButton("Auto Summit")
local cpManualBtn = createButton("CP Manual")
local serverHopBtn = createButton("Server Hop")
local settingBtn = createButton("Setting")
local infoBtn = createButton("Info")

-- CP Manual Scroll
local cpFrame = Instance.new("ScrollingFrame")
cpFrame.Size = UDim2.new(1, -10, 0, 150)
cpFrame.BackgroundColor3 = Color3.fromRGB(20,20,20)
cpFrame.CanvasSize = UDim2.new(0,0,0,600)
cpFrame.ScrollBarThickness = 6
cpFrame.Visible = false
cpFrame.Parent = mainFrame

cpManualBtn.MouseButton1Click:Connect(function()
    cpFrame.Visible = not cpFrame.Visible
end)

-- CP Buttons
for i=1,20 do
    local cpBtn = Instance.new("TextButton")
    cpBtn.Size = UDim2.new(1, -10, 0, 25)
    cpBtn.Position = UDim2.new(0, 0, 0, (i-1)*30)
    cpBtn.Text = "Checkpoint "..i
    cpBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
    cpBtn.TextColor3 = Color3.new(1,1,1)
    cpBtn.Parent = cpFrame
end

-- Delay Box
local delayBox = Instance.new("TextBox")
delayBox.Size = UDim2.new(1, -10, 0, 40)
delayBox.PlaceholderText = "Delay (detik)"
delayBox.TextColor3 = Color3.new(1,1,1)
delayBox.BackgroundColor3 = Color3.fromRGB(30,30,30)
delayBox.Parent = mainFrame

-- Auto Death Toggle
local autoDeathBtn = createButton("Auto Death: OFF")
local autoDeath = false
autoDeathBtn.MouseButton1Click:Connect(function()
    autoDeath = not autoDeath
    autoDeathBtn.Text = "Auto Death: "..(autoDeath and "ON" or "OFF")
end)

-- Notification Example
local function notify(text)
    local notif = Instance.new("TextLabel")
    notif.Size = UDim2.new(0, 300, 0, 50)
    notif.Position = UDim2.new(0.5, -150, 0, 50)
    notif.BackgroundColor3 = Color3.fromRGB(255,0,0)
    notif.TextColor3 = Color3.new(1,1,1)
    notif.TextScaled = true
    notif.Text = text
    notif.Parent = screenGui
    game:GetService("Debris"):AddItem(notif, 3)
end

autoSummitBtn.MouseButton1Click:Connect(function()
    notify("Auto Summit Start (Cek GUI)")
end)
