-- BynzzBponjon Final GUI dengan Hide/Show
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local RunService = game:GetService("RunService")

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

local autoSummitActive = false
local autoDeathActive = false
local serverHopActive = false
local delaySeconds = 10
local speedValue = 50
local currentIndex = 1
local guiHidden = false

local function showNotification(text)
    local notif = Instance.new("TextLabel")
    notif.Size = UDim2.new(0,400,0,50)
    notif.Position = UDim2.new(0.5,-200,0.05,0)
    notif.BackgroundColor3 = Color3.fromRGB(180,0,0)
    notif.TextColor3 = Color3.new(1,1,1)
    notif.Text = text
    notif.Font = Enum.Font.GothamBold
    notif.TextSize = 20
    notif.TextScaled = true
    notif.Parent = playerGui
    spawn(function()
        task.wait(3)
        notif:Destroy()
    end)
end

local function createGui()
    if playerGui:FindFirstChild("BynzzBponjonGui") then
        playerGui.BynzzBponjonGui:Destroy()
    end

    local screen = Instance.new("ScreenGui", playerGui)
    screen.Name = "BynzzBponjonGui"
    screen.ResetOnSpawn = false

    local mainFrame = Instance.new("Frame", screen)
    mainFrame.Size = UDim2.new(0, 470, 0, 400)
    mainFrame.Position = UDim2.new(0.05,0,0.1,0)
    mainFrame.BackgroundColor3 = Color3.fromRGB(20,20,20)
    mainFrame.Active = true
    mainFrame.Draggable = true

    -- Header
    local header = Instance.new("Frame", mainFrame)
    header.Size = UDim2.new(1,0,0,30)
    header.BackgroundColor3 = Color3.fromRGB(40,40,40)

    local headerLabel = Instance.new("TextLabel", header)
    headerLabel.Size = UDim2.new(0.6,0,1,0)
    headerLabel.Position = UDim2.new(0,10,0,0)
    headerLabel.BackgroundTransparency = 1
    headerLabel.Text = "BynzzBponjon"
    headerLabel.TextColor3 = Color3.fromRGB(255,255,255)
    headerLabel.Font = Enum.Font.SourceSansBold
    headerLabel.TextSize = 18
    headerLabel.TextXAlignment = Enum.TextXAlignment.Left

    -- Close Button
    local closeButton = Instance.new("TextButton", header)
    closeButton.Size = UDim2.new(0.2, -10, 1, -4)
    closeButton.Position = UDim2.new(0.8, 0, 0, 2)
    closeButton.BackgroundColor3 = Color3.fromRGB(200,0,50)
    closeButton.Text = "X"
    closeButton.TextColor3 = Color3.fromRGB(255,255,255)
    closeButton.Font = Enum.Font.SourceSansBold
    closeButton.TextSize = 18
    closeButton.MouseButton1Click:Connect(function()
        mainFrame.Visible = false
    end)

    -- Hide/Show Button
    local hideButton = Instance.new("TextButton", header)
    hideButton.Size = UDim2.new(0.2, -10, 1, -4)
    hideButton.Position = UDim2.new(0.6, 0, 0, 2)
    hideButton.BackgroundColor3 = Color3.fromRGB(80,80,80)
    hideButton.Text = "Hide"
    hideButton.TextColor3 = Color3.fromRGB(255,255,255)
    hideButton.Font = Enum.Font.SourceSansBold
    hideButton.TextSize = 16

    hideButton.MouseButton1Click:Connect(function()
        if not guiHidden then
            mainFrame.Size = UDim2.new(0, 200, 0, 30)
            guiHidden = true
        else
            mainFrame.Size = UDim2.new(0, 470, 0, 400)
            guiHidden = false
        end
    end)

    -- Left Panel
    local leftPanel = Instance.new("Frame", mainFrame)
    leftPanel.Size = UDim2.new(0, 120, 1, -30)
    leftPanel.Position = UDim2.new(0,0,0,30)
    leftPanel.BackgroundColor3 = Color3.fromRGB(0,0,0)

    local menuNames = {"Auto","Server","Setting","Info","Auto Death"}
    local menuButtons = {}

    for i,name in ipairs(menuNames) do
        local btn = Instance.new("TextButton", leftPanel)
        btn.Size = UDim2.new(1,0,0,50)
        btn.Position = UDim2.new(0,0,0,(i-1)*50)
        btn.BackgroundColor3 = Color3.fromRGB(20,20,20)
        btn.Text = name
        btn.TextColor3 = Color3.fromRGB(255,255,255)
        btn.Font = Enum.Font.SourceSansBold
        btn.TextSize = 18
        menuButtons[name] = btn
    end

    -- Right Panel
    local rightPanel = Instance.new("Frame", mainFrame)
    rightPanel.Size = UDim2.new(0, 350, 1, -30)
    rightPanel.Position = UDim2.new(0,120,0,30)
    rightPanel.BackgroundColor3 = Color3.fromRGB(10,10,10)

    -- Clear Right Panel function
    local function clearRightPanel()
        for _,v in pairs(rightPanel:GetChildren()) do
            if not v:IsA("UIListLayout") then v:Destroy() end
        end
    end

    -- Here you can connect menu buttons to create right panel content like Auto, Server, Setting, Info, Auto Death
    -- [Insert previous panel creation code here for Auto, Server, Setting, Info, Auto Death]
    -- ... (reuse the previous right panel content creation functions)
    
    -- Connect buttons
    menuButtons["Auto"].MouseButton1Click:Connect(function() createAutoPanel() end)
    menuButtons["Server"].MouseButton1Click:Connect(function() createServerPanel() end)
    menuButtons["Setting"].MouseButton1Click:Connect(function() createSettingPanel() end)
    menuButtons["Info"].MouseButton1Click:Connect(function() createInfoPanel() end)
    menuButtons["Auto Death"].MouseButton1Click:Connect(function() createAutoDeathPanel() end)
end

createGui()
