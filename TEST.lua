-- Gui Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BynzzBponjon"
ScreenGui.Parent = game.CoreGui

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 470, 0, 400)
MainFrame.Position = UDim2.new(0, 50, 0, 100)
MainFrame.BackgroundColor3 = Color3.fromRGB(20,20,20)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-- Header
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1,0,0,30)
Header.BackgroundColor3 = Color3.fromRGB(40,40,40)
Header.Parent = MainFrame

local HeaderLabel = Instance.new("TextLabel")
HeaderLabel.Size = UDim2.new(0.8,0,1,0)
HeaderLabel.Position = UDim2.new(0,10,0,0)
HeaderLabel.BackgroundTransparency = 1
HeaderLabel.Text = "BynzzBponjon"
HeaderLabel.TextColor3 = Color3.fromRGB(255,255,255)
HeaderLabel.Font = Enum.Font.SourceSansBold
HeaderLabel.TextSize = 18
HeaderLabel.TextXAlignment = Enum.TextXAlignment.Left
HeaderLabel.Parent = Header

-- Close Button
local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0.1, -5, 1, -4)
CloseButton.Position = UDim2.new(0.9, 0, 0, 2)
CloseButton.BackgroundColor3 = Color3.fromRGB(200,0,50)
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255,255,255)
CloseButton.Font = Enum.Font.SourceSansBold
CloseButton.TextSize = 18
CloseButton.Parent = Header

CloseButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
end)

-- Hide/Show Button
local HideButton = Instance.new("TextButton")
HideButton.Size = UDim2.new(0.1, -5, 1, -4)
HideButton.Position = UDim2.new(0.8, 0, 0, 2)
HideButton.BackgroundColor3 = Color3.fromRGB(100,100,100)
HideButton.Text = "_"
HideButton.TextColor3 = Color3.fromRGB(255,255,255)
HideButton.Font = Enum.Font.SourceSansBold
HideButton.TextSize = 18
HideButton.Parent = Header

local hidden = false
HideButton.MouseButton1Click:Connect(function()
    hidden = not hidden
    MainFrame.Size = hidden and UDim2.new(0, 200, 0, 40) or UDim2.new(0, 470, 0, 400)
    LeftPanel.Visible = not hidden
    RightPanel.Visible = not hidden
end)

-- Panel Kiri
local LeftPanel = Instance.new("Frame")
LeftPanel.Size = UDim2.new(0, 120, 1, -30)
LeftPanel.Position = UDim2.new(0, 0, 0, 30)
LeftPanel.BackgroundColor3 = Color3.fromRGB(0,0,0)
LeftPanel.Parent = MainFrame

local function createMenuText(name, yPos)
    local TextLabel = Instance.new("TextLabel")
    TextLabel.Size = UDim2.new(1, 0, 0, 50)
    TextLabel.Position = UDim2.new(0, 0, 0, yPos)
    TextLabel.BackgroundTransparency = 1
    TextLabel.Text = name
    TextLabel.TextColor3 = Color3.fromRGB(255,255,255)
    TextLabel.Font = Enum.Font.SourceSansBold
    TextLabel.TextSize = 18
    TextLabel.Parent = LeftPanel
end

createMenuText("Auto", 0)
createMenuText("Server", 50)
createMenuText("Setting", 100)
createMenuText("Info", 150)

-- Panel Kanan
local RightPanel = Instance.new("Frame")
RightPanel.Size = UDim2.new(0, 330, 1, -30)
RightPanel.Position = UDim2.new(0, 120, 0, 30)
RightPanel.BackgroundColor3 = Color3.fromRGB(10,10,10)
RightPanel.Parent = MainFrame

local function createFeatureButton(name, yPos)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 0, 40)
    btn.Position = UDim2.new(0, 10, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(30,30,30)
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 16
    btn.Parent = RightPanel

    btn.MouseButton1Click:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(200,0,100)
        print(name.." button clicked!")
    end)
end

-- Tombol fitur
createFeatureButton("CP Manual", 0)
createFeatureButton("Auto Summit", 50)
createFeatureButton("Auto Death", 100)
createFeatureButton("Server Hop On/Off", 150)
createFeatureButton("Delay Setting", 200)
createFeatureButton("Speed Setting", 250)
createFeatureButton("Info Panel", 300)

-- Checkpoints
local checkpoints = {
    Vector3.new(-883.288, 43.358, 933.698),
    Vector3.new(-473.240, 49.167, 624.194),
    Vector3.new(-182.927, 52.412, 691.074),
    Vector3.new(122.499, 202.548, 951.741),
    Vector3.new(10.684, 194.377, 340.400),
    Vector3.new(244.394, 194.369, 805.065),
    Vector3.new(660.531, 210.886, 749.360),
    Vector3.new(660.649, 202.965, 368.070),
    Vector3.new(520.852, 214.338, 281.842),
    Vector3.new(523.730, 214.369, -333.936),
    Vector3.new(561.610, 211.787, -559.470),
    Vector3.new(566.837, 282.541, -924.107),
    Vector3.new(115.198, 286.309, -655.635),
    Vector3.new(-308.343, 410.144, -612.031),
    Vector3.new(-487.722, 522.666, -663.426),
    Vector3.new(-679.093, 482.701, -971.988),
    Vector3.new(-559.058, 258.369, -1318.780),
    Vector3.new(-426.353, 374.369, -1512.621),
    Vector3.new(-984.797, 635.003, -1621.875),
    Vector3.new(-1394.228, 797.455, -1563.855),
    Vector3.new(-1534.938, 933.116, -2176.096)
}

print("Checkpoint count:", #checkpoints)
