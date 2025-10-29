-- BynzzBponjon Final
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- =================== Positions ===================
local checkpoints = {
    {name="Basecamp", pos=Vector3.new(-883.288, 43.358, 933.698)},
    {name="CP1", pos=Vector3.new(-473.240, 49.167, 624.194)},
    {name="CP2", pos=Vector3.new(-182.927, 52.412, 691.074)},
    {name="CP3", pos=Vector3.new(122.499, 202.548, 951.741)},
    {name="CP4", pos=Vector3.new(10.684, 194.377, 340.400)},
    {name="CP5", pos=Vector3.new(244.394, 194.369, 805.065)},
    {name="CP6", pos=Vector3.new(660.531, 210.886, 749.360)},
    {name="CP7", pos=Vector3.new(660.649, 202.965, 368.070)},
    {name="CP8", pos=Vector3.new(520.852, 214.338, 281.842)},
    {name="CP9", pos=Vector3.new(523.730, 214.369, -333.936)},
    {name="CP10", pos=Vector3.new(561.610, 211.787, -559.470)},
    {name="CP11", pos=Vector3.new(566.837, 282.541, -924.107)},
    {name="CP12", pos=Vector3.new(115.198, 286.309, -655.635)},
    {name="CP13", pos=Vector3.new(-308.343, 410.144, -612.031)},
    {name="CP14", pos=Vector3.new(-487.722, 522.666, -663.426)},
    {name="CP15", pos=Vector3.new(-679.093, 482.701, -971.988)},
    {name="CP16", pos=Vector3.new(-559.058, 258.369, -1318.780)},
    {name="CP17", pos=Vector3.new(-426.353, 374.369, -1512.621)},
    {name="CP18", pos=Vector3.new(-984.797, 635.003, -1621.875)},
    {name="CP19", pos=Vector3.new(-1394.228, 797.455, -1563.855)},
    {name="Puncak", pos=Vector3.new(-1534.938, 933.116, -2176.096)}
}

-- =================== State ===================
local autoSummitActive = false
local autoDeathActive = false
local serverHopActive = false
local currentIndex = 1
local delaySeconds = 10
local speedMultiplier = 1

-- =================== Notifications ===================
local function notify(msg)
    local notif = Instance.new("TextLabel")
    notif.Size = UDim2.new(0,400,0,50)
    notif.Position = UDim2.new(0.5,-200,0.05,0)
    notif.BackgroundColor3 = Color3.fromRGB(180,0,0)
    notif.TextColor3 = Color3.new(1,1,1)
    notif.Text = msg
    notif.Font = Enum.Font.GothamBold
    notif.TextSize = 20
    notif.TextScaled = true
    notif.Parent = playerGui
    spawn(function()
        task.wait(3)
        notif:Destroy()
    end)
end

-- =================== GUI ===================
local screen = Instance.new("ScreenGui")
screen.Name = "BynzzBponjonGui"
screen.Parent = playerGui
screen.ResetOnSpawn = false

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0,480,0,400)
mainFrame.Position = UDim2.new(0.05,0,0.1,0)
mainFrame.BackgroundColor3 = Color3.fromRGB(20,20,20)
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screen

-- Header
local header = Instance.new("Frame")
header.Size = UDim2.new(1,0,0,30)
header.BackgroundColor3 = Color3.fromRGB(40,40,40)
header.Parent = mainFrame

local headerLabel = Instance.new("TextLabel")
headerLabel.Size = UDim2.new(0.8,0,1,0)
headerLabel.Position = UDim2.new(0,10,0,0)
headerLabel.BackgroundTransparency = 1
headerLabel.Text = "BynzzBponjon"
headerLabel.TextColor3 = Color3.fromRGB(255,255,255)
headerLabel.Font = Enum.Font.SourceSansBold
headerLabel.TextSize = 18
headerLabel.TextXAlignment = Enum.TextXAlignment.Left
headerLabel.Parent = header

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0.2, -10, 1, -4)
closeBtn.Position = UDim2.new(0.8, 0, 0, 2)
closeBtn.BackgroundColor3 = Color3.fromRGB(200,0,50)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255,255,255)
closeBtn.Font = Enum.Font.SourceSansBold
closeBtn.TextSize = 18
closeBtn.Parent = header

closeBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
end)

-- Left Panel (Menu)
local leftPanel = Instance.new("Frame")
leftPanel.Size = UDim2.new(0,120,1,-30)
leftPanel.Position = UDim2.new(0,0,0,30)
leftPanel.BackgroundColor3 = Color3.fromRGB(0,0,0)
leftPanel.Parent = mainFrame

local menuItems = {"Auto","Server","Setting","Info"}
local menuButtons = {}

for i,name in ipairs(menuItems) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1,0,0,50)
    btn.Position = UDim2.new(0,0,0,(i-1)*50)
    btn.BackgroundTransparency = 1
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 18
    btn.Parent = leftPanel
    menuButtons[name] = btn
end

-- Right Panel (Dynamic)
local rightPanel = Instance.new("Frame")
rightPanel.Size = UDim2.new(0,360,1,-30)
rightPanel.Position = UDim2.new(0,120,0,30)
rightPanel.BackgroundColor3 = Color3.fromRGB(10,10,10)
rightPanel.Parent = mainFrame

local function clearRightPanel()
    for _,v in pairs(rightPanel:GetChildren()) do
        if v:IsA("GuiObject") then v:Destroy() end
    end
end

-- =================== Features ===================
-- Auto Panel
local function setupAutoPanel()
    clearRightPanel()
    -- CP Manual
    local cpBtn = Instance.new("TextButton")
    cpBtn.Size = UDim2.new(1,-20,0,50)
    cpBtn.Position = UDim2.new(0,10,0,10)
    cpBtn.BackgroundColor3 = Color3.fromRGB(30,30,30)
    cpBtn.Text = "CP Manual"
    cpBtn.TextColor3 = Color3.fromRGB(255,255,255)
    cpBtn.Font = Enum.Font.SourceSans
    cpBtn.TextSize = 16
    cpBtn.Parent = rightPanel
    cpBtn.MouseButton1Click:Connect(function()
        currentIndex = 1
        notify("CP Manual activated")
        if player.Character and player.Character.PrimaryPart then
            player.Character:SetPrimaryPartCFrame(CFrame.new(checkpoints[currentIndex].pos))
        end
    end)

    -- Auto Summit
    local summitBtn = Instance.new("TextButton")
    summitBtn.Size = UDim2.new(1,-20,0,50)
    summitBtn.Position = UDim2.new(0,10,0,70)
    summitBtn.BackgroundColor3 = Color3.fromRGB(30,30,30)
    summitBtn.Text = "Auto Summit"
    summitBtn.TextColor3 = Color3.fromRGB(255,255,255)
    summitBtn.Font = Enum.Font.SourceSans
    summitBtn.TextSize = 16
    summitBtn.Parent = rightPanel
    summitBtn.MouseButton1Click:Connect(function()
        if autoSummitActive then
            autoSummitActive = false
            notify("Auto Summit Stopped")
        else
            autoSummitActive = true
            notify("Auto Summit Started")
            spawn(function()
                while autoSummitActive and currentIndex<=#checkpoints do
                    local cp = checkpoints[currentIndex]
                    if player.Character and player.Character.PrimaryPart then
                        player.Character:SetPrimaryPartCFrame(CFrame.new(cp.pos))
                    end
                    task.wait(delaySeconds/speedMultiplier)
                    if currentIndex<#checkpoints then
                        currentIndex = currentIndex + 1
                    else
                        autoSummitActive = false
                        notify("Auto Summit Completed")
                    end
                end
            end)
        end
    end)

    -- Auto Death ON/OFF
    local deathBtn = Instance.new("TextButton")
    deathBtn.Size = UDim2.new(1,-20,0,50)
    deathBtn.Position = UDim2.new(0,10,0,130)
    deathBtn.BackgroundColor3 = Color3.fromRGB(30,30,30)
    deathBtn.Text = "Auto Death: OFF"
    deathBtn.TextColor3 = Color3.fromRGB(255,255,255)
    deathBtn.Font = Enum.Font.SourceSans
    deathBtn.TextSize = 16
    deathBtn.Parent = rightPanel
    deathBtn.MouseButton1Click:Connect(function()
        autoDeathActive = not autoDeathActive
        deathBtn.Text = "Auto Death: "..(autoDeathActive and "ON" or "OFF")
        notify("Auto Death "..(autoDeathActive and "Enabled" or "Disabled"))
    end)
end

-- Server Panel
local function setupServerPanel()
    clearRightPanel()
    local serverBtn = Instance.new("TextButton")
    serverBtn.Size = UDim2.new(1,-20,0,50)
    serverBtn.Position = UDim2.new(0,10,0,10)
    serverBtn.BackgroundColor3 = Color3.fromRGB(30,30,30)
    serverBtn.Text = "Server Hop: OFF"
    serverBtn.TextColor3 = Color3.fromRGB(255,255,255)
    serverBtn.Font = Enum.Font.SourceSans
    serverBtn.TextSize = 16
    serverBtn.Parent = rightPanel
    serverBtn.MouseButton1Click:Connect(function()
        serverHopActive = not serverHopActive
        serverBtn.Text = "Server Hop: "..(serverHopActive and "ON" or "OFF")
        notify("Server Hop "..(serverHopActive and "Enabled" or "Disabled"))
    end)
end

-- Setting Panel
local function setupSettingPanel()
    clearRightPanel()
    -- Delay
    local delayLbl = Instance.new("TextLabel")
    delayLbl.Size = UDim2.new(1,0,0,30)
    delayLbl.Position = UDim2.new(0,0,0,10)
    delayLbl.BackgroundTransparency = 1
    delayLbl.Text = "Delay (s):"
    delayLbl.TextColor3 = Color3.new(1,1,1)
    delayLbl.Font = Enum.Font.SourceSans
    delayLbl.TextSize = 16
    delayLbl.Parent = rightPanel

    local delayBox = Instance.new("TextBox")
    delayBox.Size = UDim2.new(1,0,0,30)
    delayBox.Position = UDim2.new(0,0,0,40)
    delayBox.Text = tostring(delaySeconds)
    delayBox.TextColor3 = Color3.new(1,1,1)
    delayBox.BackgroundColor3 = Color3.fromRGB(30,30,30)
    delayBox.Font = Enum.Font.SourceSans
    delayBox.TextSize = 16
    delayBox.ClearTextOnFocus = false
    delayBox.Parent = rightPanel
    delayBox.FocusLost:Connect(function()
        local val = tonumber(delayBox.Text)
        if val and val>0 then delaySeconds = val end
    end)

    -- Speed
    local speedLbl = Instance.new("TextLabel")
    speedLbl.Size = UDim2.new(1,0,0,30)
    speedLbl.Position = UDim2.new(0,0,0,80)
    speedLbl.BackgroundTransparency = 1
    speedLbl.Text = "Speed Multiplier:"
    speedLbl.TextColor3 = Color3.new(1,1,1)
    speedLbl.Font = Enum.Font.SourceSans
    speedLbl.TextSize = 16
    speedLbl.Parent = rightPanel

    local speedBox = Instance.new("TextBox")
    speedBox.Size = UDim2.new(1,0,0,30)
    speedBox.Position = UDim2.new(0,0,0,110)
    speedBox.Text = tostring(speedMultiplier)
    speedBox.TextColor3 = Color3.new(1,1,1)
    speedBox.BackgroundColor3 = Color3.fromRGB(30,30,30)
    speedBox.Font = Enum.Font.SourceSans
    speedBox.TextSize = 16
    speedBox.ClearTextOnFocus = false
    speedBox.Parent = rightPanel
    speedBox.FocusLost:Connect(function()
        local val = tonumber(speedBox.Text)
        if val and val>0 then speedMultiplier = val end
    end)
end

-- Info Panel
local function setupInfoPanel()
    clearRightPanel()
    local infoLbl = Instance.new("TextLabel")
    infoLbl.Size = UDim2.new(1,0,1,0)
    infoLbl.Position = UDim2.new(0,0,0,0)
    infoLbl.BackgroundTransparency = 1
    infoLbl.TextColor3 = Color3.new(1,1,1)
    infoLbl.Font = Enum.Font.SourceSans
    infoLbl.TextSize = 16
    infoLbl.TextWrapped = true
    infoLbl.Text = "BynzzBponjon Script\nVersion 1.0\nCreator: You\nFitur: Auto Summit, Auto Death, Server Hop, Setting Delay/Speed"
    infoLbl.Parent = rightPanel
end

-- =================== Menu Button Events ===================
menuButtons["Auto"].MouseButton1Click:Connect(setupAutoPanel)
menuButtons["Server"].MouseButton1Click:Connect(setupServerPanel)
menuButtons["Setting"].MouseButton1Click:Connect(setupSettingPanel)
menuButtons["Info"].MouseButton1Click:Connect(setupInfoPanel)

-- Load default panel
setupAutoPanel()
