-- BynzzBponjon GUI v1
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Main Screen GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BynzzBponjonGUI"
screenGui.Parent = playerGui

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 400, 0, 300)
mainFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
mainFrame.BackgroundColor3 = Color3.fromRGB(0,0,0)
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

-- Top Bar (Name + Close + Hide)
local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1,0,0,30)
topBar.BackgroundColor3 = Color3.fromRGB(20,20,20)
topBar.Parent = mainFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(0.5,0,1,0)
titleLabel.Position = UDim2.new(0,5,0,0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "BynzzBponjon"
titleLabel.TextColor3 = Color3.fromRGB(255,255,255)
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.TextSize = 18
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = topBar

local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0,50,1,0)
closeButton.Position = UDim2.new(1,-55,0,0)
closeButton.BackgroundColor3 = Color3.fromRGB(180,0,0)
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255,255,255)
closeButton.Font = Enum.Font.SourceSansBold
closeButton.TextSize = 18
closeButton.Parent = topBar

local hideButton = Instance.new("TextButton")
hideButton.Size = UDim2.new(0,50,1,0)
hideButton.Position = UDim2.new(1,-110,0,0)
hideButton.BackgroundColor3 = Color3.fromRGB(100,100,100)
hideButton.Text = "_"
hideButton.TextColor3 = Color3.fromRGB(255,255,255)
hideButton.Font = Enum.Font.SourceSansBold
hideButton.TextSize = 18
hideButton.Parent = topBar

-- Left Panel (Feature Names)
local leftPanel = Instance.new("Frame")
leftPanel.Size = UDim2.new(0,120,1,-30)
leftPanel.Position = UDim2.new(0,0,0,30)
leftPanel.BackgroundColor3 = Color3.fromRGB(25,25,25)
leftPanel.Parent = mainFrame

-- Right Panel (Feature Buttons)
local rightPanel = Instance.new("Frame")
rightPanel.Size = UDim2.new(1,-120,1,-30)
rightPanel.Position = UDim2.new(0,120,0,30)
rightPanel.BackgroundColor3 = Color3.fromRGB(15,15,15)
rightPanel.Parent = mainFrame

-- Notification function
local function notify(msg)
    local notif = Instance.new("TextLabel")
    notif.Size = UDim2.new(0,250,0,40)
    notif.Position = UDim2.new(0.5,-125,0.1,0)
    notif.BackgroundColor3 = Color3.fromRGB(255,0,0)
    notif.TextColor3 = Color3.fromRGB(255,255,255)
    notif.Font = Enum.Font.SourceSansBold
    notif.TextSize = 16
    notif.Text = msg
    notif.Parent = screenGui
    task.delay(3,function() notif:Destroy() end)
end

-- Example Features
local features = {
    {Name="Auto Summit", SubFeatures={"CP Manual", "Auto Summit"}, Active=false},
    {Name="Auto Death", SubFeatures={}, Active=false}
}

for i, feature in ipairs(features) do
    -- Left Label
    local label = Instance.new("TextButton")
    label.Size = UDim2.new(1,0,0,40)
    label.Position = UDim2.new(0,0,0,(i-1)*45)
    label.BackgroundColor3 = Color3.fromRGB(35,35,35)
    label.TextColor3 = Color3.fromRGB(255,255,255)
    label.Text = feature.Name
    label.Font = Enum.Font.SourceSansBold
    label.TextSize = 16
    label.Parent = leftPanel

    -- Right buttons container
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1,0,0,#feature.SubFeatures*40)
    container.Position = UDim2.new(0,0,0,0)
    container.BackgroundTransparency = 1
    container.Visible = false
    container.Parent = rightPanel

    for j, sub in ipairs(feature.SubFeatures) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0,180,0,35)
        btn.Position = UDim2.new(0,10,0,(j-1)*40)
        btn.BackgroundColor3 = Color3.fromRGB(60,60,60)
        btn.TextColor3 = Color3.fromRGB(255,255,255)
        btn.Text = sub
        btn.Font = Enum.Font.SourceSansBold
        btn.TextSize = 14
        btn.Parent = container

        btn.MouseButton1Click:Connect(function()
            notify(sub.." toggled!")
            -- TODO: tambahkan fungsi sub fitur disini
        end)
    end

    label.MouseButton1Click:Connect(function()
        container.Visible = not container.Visible
    end)
end

-- Close & Hide functionality
closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

hideButton.MouseButton1Click:Connect(function()
    mainFrame.Size = UDim2.new(0,400,0,30)
    leftPanel.Visible = false
    rightPanel.Visible = false
end)
