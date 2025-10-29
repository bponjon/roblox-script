-- Gui Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BynzzBponjon"
ScreenGui.Parent = game.CoreGui

-- Main Frame (Draggable)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 470, 0, 400)
MainFrame.Position = UDim2.new(0, 50, 0, 100)
MainFrame.BackgroundColor3 = Color3.fromRGB(20,20,20)
MainFrame.Parent = ScreenGui

-- Draggable
MainFrame.Active = true
MainFrame.Draggable = true

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
CloseButton.Size = UDim2.new(0.2, -10, 1, -4)
CloseButton.Position = UDim2.new(0.8, 0, 0, 2)
CloseButton.BackgroundColor3 = Color3.fromRGB(200,0,50)
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255,255,255)
CloseButton.Font = Enum.Font.SourceSansBold
CloseButton.TextSize = 18
CloseButton.Parent = Header

CloseButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
end)

-- Panel Kiri (Menu)
local LeftPanel = Instance.new("Frame")
LeftPanel.Name = "LeftPanel"
LeftPanel.Size = UDim2.new(0, 120, 1, -30) -- Tinggi minus header
LeftPanel.Position = UDim2.new(0, 0, 0, 30)
LeftPanel.BackgroundColor3 = Color3.fromRGB(0,0,0)
LeftPanel.Parent = MainFrame

-- Teks Menu
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

-- Panel Kanan (Fitur)
local RightPanel = Instance.new("Frame")
RightPanel.Name = "RightPanel"
RightPanel.Size = UDim2.new(0, 330, 1, -30) -- Lebih lebar, tinggi minus header
RightPanel.Position = UDim2.new(0, 120, 0, 30)
RightPanel.BackgroundColor3 = Color3.fromRGB(10,10,10)
RightPanel.Parent = MainFrame

-- Contoh Tombol Fitur
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
        btn.BackgroundColor3 = Color3.fromRGB(200,0,100) -- Highlight saat aktif
        print(name.." button clicked!")
    end)
end

-- Contoh tombol di panel kanan
createFeatureButton("CP Manual", 0)
createFeatureButton("Auto Summit", 50)
createFeatureButton("Auto Death", 100)
createFeatureButton("Delay Setting", 150)
