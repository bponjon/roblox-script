-- ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AutoSummitGUI"
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 350, 0, 400)
MainFrame.Position = UDim2.new(0.3,0,0.3,0)
MainFrame.BackgroundColor3 = Color3.fromRGB(30,30,30)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui
MainFrame.Active = true
MainFrame.Draggable = true

-- Top Bar
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1,0,0,30)
TopBar.Position = UDim2.new(0,0,0,0)
TopBar.BackgroundColor3 = Color3.fromRGB(50,50,50)
TopBar.Parent = MainFrame

-- Title
local Title = Instance.new("TextLabel")
Title.Text = "Auto Summit"
Title.Size = UDim2.new(0.6,0,1,0)
Title.Position = UDim2.new(0,5,0,0)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.new(1,1,1)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 18
Title.Parent = TopBar

-- Close Button
local CloseBtn = Instance.new("TextButton")
CloseBtn.Text = "X"
CloseBtn.Size = UDim2.new(0,30,1,0)
CloseBtn.Position = UDim2.new(0.9,0,0,0)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200,0,0)
CloseBtn.TextColor3 = Color3.new(1,1,1)
CloseBtn.Font = Enum.Font.SourceSansBold
CloseBtn.TextSize = 18
CloseBtn.Parent = TopBar

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui.Enabled = false
end)

-- Hide Button
local HideBtn = Instance.new("TextButton")
HideBtn.Text = "_"
HideBtn.Size = UDim2.new(0,30,1,0)
HideBtn.Position = UDim2.new(0.85,0,0,0)
HideBtn.BackgroundColor3 = Color3.fromRGB(100,100,100)
HideBtn.TextColor3 = Color3.new(1,1,1)
HideBtn.Font = Enum.Font.SourceSansBold
HideBtn.TextSize = 18
HideBtn.Parent = TopBar

HideBtn.MouseButton1Click:Connect(function()
    for i,v in pairs(MainFrame:GetChildren()) do
        if v ~= TopBar then
            v.Visible = not v.Visible
        end
    end
end)

-- Feature List Frame
local FeatureFrame = Instance.new("ScrollingFrame")
FeatureFrame.Size = UDim2.new(1,0,1,-30)
FeatureFrame.Position = UDim2.new(0,0,0,30)
FeatureFrame.BackgroundTransparency = 1
FeatureFrame.ScrollBarThickness = 6
FeatureFrame.Parent = MainFrame

-- Sample Features
local features = {
    {name="Auto Summit", type="toggle", value=false},
    {name="CP Manual", type="button"},
    {name="Auto Death", type="toggle", value=false},
    {name="Server Hop", type="toggle", value=false},
    {name="Settings", type="slider", min=1, max=100, value=10}, -- contoh delay
    {name="Info", type="button"}
}

local function createFeature(f,i)
    local fFrame = Instance.new("Frame")
    fFrame.Size = UDim2.new(1,0,0,35)
    fFrame.Position = UDim2.new(0,0,0, (i-1)*40)
    fFrame.BackgroundTransparency = 1
    fFrame.Parent = FeatureFrame

    local fName = Instance.new("TextLabel")
    fName.Text = f.name
    fName.Size = UDim2.new(0.5,0,1,0)
    fName.BackgroundTransparency = 1
    fName.TextColor3 = Color3.new(1,1,1)
    fName.Font = Enum.Font.SourceSansBold
    fName.TextSize = 16
    fName.TextXAlignment = Enum.TextXAlignment.Left
    fName.Parent = fFrame

    if f.type=="toggle" then
        local toggle = Instance.new("TextButton")
        toggle.Text = "OFF"
        toggle.Size = UDim2.new(0.4,0,0.7,0)
        toggle.Position = UDim2.new(0.55,0,0.15,0)
        toggle.BackgroundColor3 = Color3.fromRGB(100,100,100)
        toggle.TextColor3 = Color3.new(1,1,1)
        toggle.Font = Enum.Font.SourceSansBold
        toggle.TextSize = 14
        toggle.Parent = fFrame

        toggle.MouseButton1Click:Connect(function()
            f.value = not f.value
            toggle.Text = f.value and "ON" or "OFF"
            toggle.BackgroundColor3 = f.value and Color3.fromRGB(0,200,0) or Color3.fromRGB(100,100,100)
        end)
    elseif f.type=="button" then
        local btn = Instance.new("TextButton")
        btn.Text = "Open"
        btn.Size = UDim2.new(0.4,0,0.7,0)
        btn.Position = UDim2.new(0.55,0,0.15,0)
        btn.BackgroundColor3 = Color3.fromRGB(100,100,100)
        btn.TextColor3 = Color3.new(1,1,1)
        btn.Font = Enum.Font.SourceSansBold
        btn.TextSize = 14
        btn.Parent = fFrame
        -- placeholder function
        btn.MouseButton1Click:Connect(function()
            print(f.name.." clicked")
        end)
    elseif f.type=="slider" then
        local slider = Instance.new("TextBox")
        slider.Text = tostring(f.value)
        slider.Size = UDim2.new(0.4,0,0.7,0)
        slider.Position = UDim2.new(0.55,0,0.15,0)
        slider.BackgroundColor3 = Color3.fromRGB(80,80,80)
        slider.TextColor3 = Color3.new(1,1,1)
        slider.Font = Enum.Font.SourceSansBold
        slider.TextSize = 14
        slider.Parent = fFrame

        slider.FocusLost:Connect(function(enter)
            local val = tonumber(slider.Text)
            if val then
                if val<f.min then val=f.min end
                if val>f.max then val=f.max end
                f.value = val
                slider.Text = tostring(f.value)
            else
                slider.Text = tostring(f.value)
            end
        end)
    end
end

for i,f in ipairs(features) do
    createFeature(f,i)
end

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

print("GUI & Checkpoints loaded!")
