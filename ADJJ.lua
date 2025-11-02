-- UNIVERSAL MOUNT GUI FINAL
-- Map otomatis deteksi + tombol multiwarna + slider transparansi geser full + semua sudut bulat

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- MAP CONFIG (singkat)
local MAP_CONFIG = {
    ["94261028489288"] = {name="MOUNT KOHARU", cp=21},
    ["140014177882408"] = {name="MOUNT GEMI", cp=2},
    ["127557455707420"] = {name="MOUNT JALUR TAKDIR", cp=7},
    ["79272087242323"] = {name="MOUNT LIRVANA", cp=22},
    ["129916920179384"] = {name="MOUNT AHPAYAH", cp=12},
    ["111417482709154"] = {name="MOUNT BINGUNG", cp=22},
    ["76084648389385"] = {name="MOUNT TENERIE", cp=6},
}

-- GUI utama
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Universal Bponjon" 
ScreenGui.Parent = PlayerGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 350, 0, 500)
MainFrame.Position = UDim2.new(0.5, -175, 0.5, -250)
MainFrame.BackgroundColor3 = Color3.fromRGB(25,25,25)
MainFrame.BackgroundTransparency = 0.3
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui
MainFrame.AnchorPoint = Vector2.new(0.5,0.5)
MainFrame.ClipsDescendants = true
MainFrame.RoundedCorner = UDim.new(0, 15)

-- Fungsi buat rounded frame (semua frame/tombol)
local function makeRounded(frame, radius)
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, radius or 10)
    UICorner.Parent = frame
end
makeRounded(MainFrame,15)

-- Label map
local MapLabel = Instance.new("TextLabel")
MapLabel.Size = UDim2.new(1, -20, 0, 30)
MapLabel.Position = UDim2.new(0, 10, 0, 10)
MapLabel.BackgroundTransparency = 1
MapLabel.TextColor3 = Color3.fromRGB(255,255,255)
MapLabel.TextScaled = true
MapLabel.Font = Enum.Font.GothamBold
MapLabel.Text = "Map: Unknown"
MapLabel.Parent = MainFrame

-- Tombol helper
local function createButton(text,color,posY)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 150, 0, 35)
    btn.Position = UDim2.new(0, 10, 0, posY)
    btn.BackgroundColor3 = color
    btn.Text = text
    btn.Font = Enum.Font.GothamBold
    btn.TextScaled = true
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Parent = MainFrame
    makeRounded(btn,10)
    return btn
end

-- Tombol fitur (multi warna)
local teleportBtn = createButton("Teleport",Color3.fromRGB(0,150,255),50)
local serverHopBtn = createButton("Server Hop",Color3.fromRGB(0,150,255),95)
local manualDeathBtn = createButton("Manual Death",Color3.fromRGB(200,0,0),140)
local hideBtn = createButton("Hide GUI",Color3.fromRGB(100,100,100),185)
local closeBtn = createButton("Close GUI",Color3.fromRGB(200,0,0),230)

-- Slider transparansi
local TransparencyLabel = Instance.new("TextLabel")
TransparencyLabel.Size = UDim2.new(1, -20, 0, 25)
TransparencyLabel.Position = UDim2.new(0,10,0,280)
TransparencyLabel.BackgroundTransparency = 1
TransparencyLabel.TextColor3 = Color3.fromRGB(255,255,255)
TransparencyLabel.TextScaled = true
TransparencyLabel.Font = Enum.Font.GothamBold
TransparencyLabel.Text = "GUI Transparency"
TransparencyLabel.Parent = MainFrame

local TransparencySlider = Instance.new("Frame")
TransparencySlider.Size = UDim2.new(0.9,0,0,20)
TransparencySlider.Position = UDim2.new(0.05,0,0,310)
TransparencySlider.BackgroundColor3 = Color3.fromRGB(100,100,100)
TransparencySlider.Parent = MainFrame
makeRounded(TransparencySlider,10)

local SliderFill = Instance.new("Frame")
SliderFill.Size = UDim2.new(0.5,0,1,0)
SliderFill.Position = UDim2.new(0,0,0,0)
SliderFill.BackgroundColor3 = Color3.fromRGB(0,200,150)
SliderFill.Parent = TransparencySlider
makeRounded(SliderFill,10)

-- Slider interaktif
local dragging = false
SliderFill.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
    end
end)
SliderFill.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)
game:GetService("UserInputService").InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local mouseX = input.Position.X - TransparencySlider.AbsolutePosition.X
        local pct = math.clamp(mouseX/TransparencySlider.AbsoluteSize.X,0,1)
        SliderFill.Size = UDim2.new(pct,0,1,0)
        MainFrame.BackgroundTransparency = 1 - pct
    end
end)

-- Fungsi deteksi map otomatis
local function detectMap()
    local placeId = tostring(game.PlaceId)
    if MAP_CONFIG[placeId] then
        MapLabel.Text = "Map: "..MAP_CONFIG[placeId].name.." ("..MAP_CONFIG[placeId].cp.." CP)"
    else
        MapLabel.Text = "Map: Unknown"
    end
end

detectMap()
