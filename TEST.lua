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
HeaderLabel.Size = UDim2.new(0.6,0,1,0)
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

-- Hide/Show Button
local HideButton = Instance.new("TextButton")
HideButton.Size = UDim2.new(0.2, -10, 1, -4)
HideButton.Position = UDim2.new(0.6, 0, 0, 2)
HideButton.BackgroundColor3 = Color3.fromRGB(50,50,50)
HideButton.Text = "_"
HideButton.TextColor3 = Color3.fromRGB(255,255,255)
HideButton.Font = Enum.Font.SourceSansBold
HideButton.TextSize = 18
HideButton.Parent = Header

HideButton.MouseButton1Click:Connect(function()
    MainFrame.Size = MainFrame.Size == UDim2.new(0,470,0,30) and UDim2.new(0,470,0,400) or UDim2.new(0,470,0,30)
end)

-- Panel Kiri (Menu)
local LeftPanel = Instance.new("Frame")
LeftPanel.Name = "LeftPanel"
LeftPanel.Size = UDim2.new(0, 120, 1, -30)
LeftPanel.Position = UDim2.new(0, 0, 0, 30)
LeftPanel.BackgroundColor3 = Color3.fromRGB(0,0,0)
LeftPanel.Parent = MainFrame

local menuItems = {"Auto","Server","Setting","Info"}
for i, name in ipairs(menuItems) do
    local TextLabel = Instance.new("TextLabel")
    TextLabel.Size = UDim2.new(1,0,0,50)
    TextLabel.Position = UDim2.new(0,0,0,(i-1)*50)
    TextLabel.BackgroundTransparency = 1
    TextLabel.Text = name
    TextLabel.TextColor3 = Color3.fromRGB(255,255,255)
    TextLabel.Font = Enum.Font.SourceSansBold
    TextLabel.TextSize = 18
    TextLabel.Parent = LeftPanel
end

-- Panel Kanan (Fitur)
local RightPanel = Instance.new("ScrollingFrame")
RightPanel.Name = "RightPanel"
RightPanel.Size = UDim2.new(0, 330, 1, -30)
RightPanel.Position = UDim2.new(0, 120, 0, 30)
RightPanel.BackgroundColor3 = Color3.fromRGB(10,10,10)
RightPanel.CanvasSize = UDim2.new(0,0,0,500)
RightPanel.ScrollBarThickness = 6
RightPanel.Parent = MainFrame

-- Fungsi buat tombol fitur
local function createFeatureButton(name, yPos)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 0, 40)
    btn.Position = UDim2.new(0,10,0,yPos)
    btn.BackgroundColor3 = Color3.fromRGB(30,30,30)
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 16
    btn.Parent = RightPanel

    -- Toggle warna pas aktif
    local active = false
    btn.MouseButton1Click:Connect(function()
        active = not active
        btn.BackgroundColor3 = active and Color3.fromRGB(200,0,100) or Color3.fromRGB(30,30,30)
        print(name.." toggled "..tostring(active))
        -- Contoh logic tiap fitur bisa diisi di sini
        if name == "Auto Death" then
            -- aktif/nonaktif auto death
        elseif name == "Auto Summit" then
            -- jalankan auto summit
        elseif name == "CP Manual" then
            -- aktifkan cp manual
        end
    end)
end

-- List semua fitur
local features = {"CP Manual","Auto Summit","Auto Death","Delay Setting","Extra Feature 1","Extra Feature 2","Extra Feature 3"}
for i, feat in ipairs(features) do
    createFeatureButton(feat, (i-1)*50)
end
