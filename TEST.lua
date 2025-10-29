-- BynzzBponjon Final GUI Scrollable
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local RunService = game:GetService("RunService")

-- =================== Checkpoints ===================
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
local delaySeconds = 2
local speedValue = 50

-- =================== GUI ===================
if playerGui:FindFirstChild("BynzzBponjonGui") then
    playerGui.BynzzBponjonGui:Destroy()
end

local screen = Instance.new("ScreenGui", playerGui)
screen.Name = "BynzzBponjonGui"
screen.ResetOnSpawn = false

-- Main Frame
local mainFrame = Instance.new("Frame", screen)
mainFrame.Size = UDim2.new(0,470,0,400)
mainFrame.Position = UDim2.new(0,50,0,100)
mainFrame.BackgroundColor3 = Color3.fromRGB(20,20,20)
mainFrame.Active = true
mainFrame.Draggable = true

-- Header
local header = Instance.new("Frame", mainFrame)
header.Size = UDim2.new(1,0,0,30)
header.BackgroundColor3 = Color3.fromRGB(40,40,40)

local headerLabel = Instance.new("TextLabel", header)
headerLabel.Size = UDim2.new(0.8,0,1,0)
headerLabel.Position = UDim2.new(0,10,0,0)
headerLabel.Text = "BynzzBponjon"
headerLabel.TextColor3 = Color3.new(1,1,1)
headerLabel.BackgroundTransparency = 1
headerLabel.Font = Enum.Font.SourceSansBold
headerLabel.TextSize = 18
headerLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Close / Hide Buttons
local hideBtn = Instance.new("TextButton", header)
hideBtn.Size = UDim2.new(0.1,0,1,0)
hideBtn.Position = UDim2.new(0.8,0,0,0)
hideBtn.Text = "_"
hideBtn.TextColor3 = Color3.new(1,1,1)
hideBtn.BackgroundColor3 = Color3.fromRGB(100,100,100)
hideBtn.Font = Enum.Font.SourceSansBold
hideBtn.TextSize = 18

local closeBtn = Instance.new("TextButton", header)
closeBtn.Size = UDim2.new(0.1,0,1,0)
closeBtn.Position = UDim2.new(0.9,0,0,0)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.new(1,1,1)
closeBtn.BackgroundColor3 = Color3.fromRGB(200,0,50)
closeBtn.Font = Enum.Font.SourceSansBold
closeBtn.TextSize = 18

closeBtn.MouseButton1Click:Connect(function()
    screen:Destroy()
end)

local rightPanelVisible = true
hideBtn.MouseButton1Click:Connect(function()
    if rightPanelVisible then
        mainFrame.Size = UDim2.new(0,470,0,30)
        rightPanel.Visible = false
    else
        mainFrame.Size = UDim2.new(0,470,0,400)
        rightPanel.Visible = true
    end
    rightPanelVisible = not rightPanelVisible
end)

-- Left Panel
local leftPanel = Instance.new("Frame", mainFrame)
leftPanel.Size = UDim2.new(0,120,1,-30)
leftPanel.Position = UDim2.new(0,0,0,30)
leftPanel.BackgroundColor3 = Color3.fromRGB(0,0,0)

local leftMenu = {"Auto","Server","Setting","Info","Auto Death"}
local leftButtons = {}
for i,name in ipairs(leftMenu) do
    local btn = Instance.new("TextButton", leftPanel)
    btn.Size = UDim2.new(1,0,0,50)
    btn.Position = UDim2.new(0,0,0,(i-1)*50)
    btn.Text = name
    btn.TextColor3 = Color3.new(1,1,1)
    btn.BackgroundColor3 = Color3.fromRGB(30,30,30)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 16
    leftButtons[name] = btn
end

-- Right Panel with ScrollingFrame
local rightPanel = Instance.new("Frame", mainFrame)
rightPanel.Size = UDim2.new(0,350,1,-30)
rightPanel.Position = UDim2.new(0,120,0,30)
rightPanel.BackgroundColor3 = Color3.fromRGB(10,10,10)

local scrollFrame = Instance.new("ScrollingFrame", rightPanel)
scrollFrame.Size = UDim2.new(1,0,1,0)
scrollFrame.BackgroundTransparency = 1
scrollFrame.CanvasSize = UDim2.new(0,0,0,0)
scrollFrame.ScrollBarThickness = 8
scrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y

local uiList = Instance.new("UIListLayout", scrollFrame)
uiList.SortOrder = Enum.SortOrder.LayoutOrder
uiList.Padding = UDim.new(0,5)

-- Clear right panel function
local function clearRightPanel()
    for _,v in ipairs(scrollFrame:GetChildren()) do
        if v:IsA("TextButton") or v:IsA("TextLabel") or v:IsA("TextBox") then
            v:Destroy()
        end
    end
end

-- Helper to create buttons in scrollFrame
local function createFeatureButton(name,callback)
    local btn = Instance.new("TextButton", scrollFrame)
    btn.Size = UDim2.new(1,-20,0,40)
    btn.Text = name
    btn.TextColor3 = Color3.new(1,1,1)
    btn.BackgroundColor3 = Color3.fromRGB(30,30,30)
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 16
    btn.AutoButtonColor = true
    btn.MouseButton1Click:Connect(callback)
end

-- Menu Logic
local function showAutoMenu()
    clearRightPanel()
    createFeatureButton("Start Auto Summit",function()
        if not autoSummitActive then
            autoSummitActive = true
            spawn(function()
                while autoSummitActive and currentIndex<=#checkpoints do
                    local cp = checkpoints[currentIndex]
                    if player.Character and player.Character.PrimaryPart then
                        player.Character:SetPrimaryPartCFrame(CFrame.new(cp.pos))
                    end
                    task.wait(delaySeconds)
                    if currentIndex<#checkpoints then
                        currentIndex = currentIndex + 1
                    else
                        autoSummitActive = false
                    end
                end
            end)
        end
    end)
    createFeatureButton("Stop Auto Summit",function()
        autoSummitActive = false
    end)
    createFeatureButton("CP Manual",function()
        clearRightPanel()
        for _,cp in ipairs(checkpoints) do
            createFeatureButton(cp.name,function()
                if player.Character and player.Character.PrimaryPart then
                    player.Character:SetPrimaryPartCFrame(CFrame.new(cp.pos))
                end
            end)
        end
    end)
end

local function showServerMenu()
    clearRightPanel()
    createFeatureButton("Server Hop On/Off",function()
        serverHopActive = not serverHopActive
    end)
end

local function showSettingMenu()
    clearRightPanel()
    local delayLabel = Instance.new("TextLabel",scrollFrame)
    delayLabel.Size = UDim2.new(1,0,0,20)
    delayLabel.Text = "Delay (s)"
    delayLabel.TextColor3 = Color3.new(1,1,1)
    delayLabel.BackgroundTransparency = 1
    delayLabel.Font = Enum.Font.SourceSans
    delayLabel.TextSize = 16

    local delayBox = Instance.new("TextBox",scrollFrame)
    delayBox.Size = UDim2.new(1,0,0,20)
    delayBox.Text = tostring(delaySeconds)
    delayBox.TextColor3 = Color3.new(1,1,1)
    delayBox.BackgroundColor3 = Color3.fromRGB(20,20,20)
    delayBox.Font = Enum.Font.SourceSans
    delayBox.TextSize = 16
    delayBox.ClearTextOnFocus = false
    delayBox.FocusLost:Connect(function()
        local val = tonumber(delayBox.Text)
        if val and val>0 then delaySeconds = val end
    end)

    local speedLabel = Instance.new("TextLabel",scrollFrame)
    speedLabel.Size = UDim2.new(1,0,0,20)
    speedLabel.Text = "Speed"
    speedLabel.TextColor3 = Color3.new(1,1,1)
    speedLabel.BackgroundTransparency = 1
    speedLabel.Font = Enum.Font.SourceSans
    speedLabel.TextSize = 16

    local speedBox = Instance.new("TextBox",scrollFrame)
    speedBox.Size = UDim2.new(1,0,0,20)
    speedBox.Text = tostring(speedValue)
    speedBox.TextColor3 = Color3.new(1,1,1)
    speedBox.BackgroundColor3 = Color3.fromRGB(20,20,20)
    speedBox.Font = Enum.Font.SourceSans
    speedBox.TextSize = 16
    speedBox.ClearTextOnFocus = false
    speedBox.FocusLost:Connect(function()
        local val = tonumber(speedBox.Text)
        if val and val>0 then speedValue = val end
    end)
end

local function showInfoMenu()
    clearRightPanel()
    local info = Instance.new("TextLabel",scrollFrame)
    info.Size = UDim2.new(1,0,0,200)
    info.Text = "BynzzBponjon v1.0\nAll features ready"
    info.TextColor3 = Color3.new(1,1,1)
    info.BackgroundTransparency = 1
    info.Font = Enum.Font.SourceSans
    info.TextSize = 16
    info.TextWrapped = true
end

local function showAutoDeathMenu()
    clearRightPanel()
    createFeatureButton("Toggle Auto Death",function()
        autoDeathActive = not autoDeathActive
    end)
end

leftButtons["Auto"].MouseButton1Click:Connect(showAutoMenu)
leftButtons["Server"].MouseButton1Click:Connect(showServerMenu)
leftButtons["Setting"].MouseButton1Click:Connect(showSettingMenu)
leftButtons["Info"].MouseButton1Click:Connect(showInfoMenu)
leftButtons["Auto Death"].MouseButton1Click:Connect(showAutoDeathMenu)

-- Default Menu
showAutoMenu()
