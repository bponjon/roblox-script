-- BynzzBponjon Final Script
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

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
local delaySeconds = 10
local speed = 1
local currentIndex = 1

-- =================== Notifications ===================
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

-- =================== GUI ===================
if playerGui:FindFirstChild("BynzzBponjonGui") then
    playerGui.BynzzBponjonGui:Destroy()
end

local screen = Instance.new("ScreenGui", playerGui)
screen.Name = "BynzzBponjonGui"
screen.ResetOnSpawn = false

local mainFrame = Instance.new("Frame", screen)
mainFrame.Size = UDim2.new(0,470,0,400)
mainFrame.Position = UDim2.new(0.05,0,0.1,0)
mainFrame.BackgroundColor3 = Color3.fromRGB(20,20,20)
mainFrame.Active = true
mainFrame.Draggable = true

-- Header
local header = Instance.new("Frame", mainFrame)
header.Size = UDim2.new(1,0,0,30)
header.BackgroundColor3 = Color3.fromRGB(40,40,40)

local title = Instance.new("TextLabel", header)
title.Size = UDim2.new(0.8,0,1,0)
title.Position = UDim2.new(0,10,0,0)
title.BackgroundTransparency = 1
title.Text = "BynzzBponjon"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 18
title.TextXAlignment = Enum.TextXAlignment.Left

local closeBtn = Instance.new("TextButton", header)
closeBtn.Size = UDim2.new(0.2,-10,1,-4)
closeBtn.Position = UDim2.new(0.8,0,0,2)
closeBtn.BackgroundColor3 = Color3.fromRGB(200,0,50)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.new(1,1,1)
closeBtn.Font = Enum.Font.SourceSansBold
closeBtn.TextSize = 18

local hideBtn = Instance.new("TextButton", header)
hideBtn.Size = UDim2.new(0.2,-10,1,-4)
hideBtn.Position = UDim2.new(0.6,0,0,2)
hideBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
hideBtn.Text = "Hide"
hideBtn.TextColor3 = Color3.new(1,1,1)
hideBtn.Font = Enum.Font.SourceSansBold
hideBtn.TextSize = 16

local hidden = false
hideBtn.MouseButton1Click:Connect(function()
    hidden = not hidden
    for i,v in pairs(mainFrame:GetChildren()) do
        if v ~= header then
            v.Visible = not hidden
        end
    end
end)

closeBtn.MouseButton1Click:Connect(function()
    mainFrame:Destroy()
end)

-- Left Panel
local leftPanel = Instance.new("Frame", mainFrame)
leftPanel.Size = UDim2.new(0,120,1,-30)
leftPanel.Position = UDim2.new(0,0,0,30)
leftPanel.BackgroundColor3 = Color3.fromRGB(0,0,0)

local menuItems = {"Auto","Server","Setting","Info"}
for i, name in pairs(menuItems) do
    local lbl = Instance.new("TextLabel", leftPanel)
    lbl.Size = UDim2.new(1,0,0,50)
    lbl.Position = UDim2.new(0,0,0,(i-1)*50)
    lbl.BackgroundTransparency = 1
    lbl.Text = name
    lbl.TextColor3 = Color3.new(1,1,1)
    lbl.Font = Enum.Font.SourceSansBold
    lbl.TextSize = 18
end

-- Right Panel
local rightPanel = Instance.new("Frame", mainFrame)
rightPanel.Size = UDim2.new(0,330,1,-30)
rightPanel.Position = UDim2.new(0,120,0,30)
rightPanel.BackgroundColor3 = Color3.fromRGB(10,10,10)

local function createFeatureBtn(name, y, callback)
    local btn = Instance.new("TextButton", rightPanel)
    btn.Size = UDim2.new(1,-20,0,40)
    btn.Position = UDim2.new(0,10,0,y)
    btn.BackgroundColor3 = Color3.fromRGB(30,30,30)
    btn.Text = name
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 16
    btn.MouseButton1Click:Connect(callback)
end

-- =================== Features ===================
createFeatureBtn("CP Manual",0,function()
    showNotification("Teleport to Basecamp")
    if player.Character and player.Character.PrimaryPart then
        player.Character:SetPrimaryPartCFrame(CFrame.new(checkpoints[1].pos))
    end
end)

createFeatureBtn("Auto Summit",50,function()
    if not autoSummitActive then
        autoSummitActive = true
        showNotification("Auto Summit Started")
        spawn(function()
            while autoSummitActive and currentIndex<=#checkpoints do
                if player.Character and player.Character.PrimaryPart then
                    player.Character:SetPrimaryPartCFrame(CFrame.new(checkpoints[currentIndex].pos))
                end
                task.wait(delaySeconds/speed)
                if currentIndex<#checkpoints then
                    currentIndex = currentIndex +1
                else
                    autoSummitActive = false
                    showNotification("Auto Summit Completed")
                end
            end
        end)
    else
        autoSummitActive = false
        showNotification("Auto Summit Stopped")
    end
end)

createFeatureBtn("Auto Death",100,function()
    autoDeathActive = not autoDeathActive
    showNotification("Auto Death: "..tostring(autoDeathActive))
end)

-- Delay and Speed
local delayLabel = Instance.new("TextLabel", rightPanel)
delayLabel.Size = UDim2.new(1,0,0,20)
delayLabel.Position = UDim2.new(0,0,0.7,0)
delayLabel.BackgroundTransparency = 1
delayLabel.TextColor3 = Color3.new(1,1,1)
delayLabel.Font = Enum.Font.Gotham
delayLabel.TextSize = 14
delayLabel.Text = "Delay (s):"

local delayBox = Instance.new("TextBox", rightPanel)
delayBox.Size = UDim2.new(1,0,0,20)
delayBox.Position = UDim2.new(0,0,0.75,0)
delayBox.Text = tostring(delaySeconds)
delayBox.ClearTextOnFocus = false
delayBox.TextColor3 = Color3.new(1,1,1)
delayBox.BackgroundColor3 = Color3.fromRGB(50,50,50)
delayBox.Font = Enum.Font.Gotham
delayBox.TextSize = 14
delayBox.FocusLost:Connect(function()
    local val = tonumber(delayBox.Text)
    if val and val>0 then delaySeconds = val end
end)

local speedLabel = Instance.new("TextLabel", rightPanel)
speedLabel.Size = UDim2.new(1,0,0,20)
speedLabel.Position = UDim2.new(0,0,0.8,0)
speedLabel.BackgroundTransparency = 1
speedLabel.TextColor3 = Color3.new(1,1,1)
speedLabel.Font = Enum.Font.Gotham
speedLabel.TextSize = 14
speedLabel.Text = "Speed:"

local speedBox = Instance.new("TextBox", rightPanel)
speedBox.Size = UDim2.new(1,0,0,20)
speedBox.Position = UDim2.new(0,0,0.85,0)
speedBox.Text = tostring(speed)
speedBox.ClearTextOnFocus = false
speedBox.TextColor3 = Color3.new(1,1,1)
speedBox.BackgroundColor3 = Color3.fromRGB(50,50,50)
speedBox.Font = Enum.Font.Gotham
speedBox.TextSize = 14
speedBox.FocusLost:Connect(function()
    local val = tonumber(speedBox.Text)
    if val and val>0 then speed = val end
end)

-- Server Hop Button
createFeatureBtn("Server Hop",200,function()
    serverHopActive = not serverHopActive
    showNotification("Server Hop: "..tostring(serverHopActive))
end)

showNotification("BynzzBponjon GUI Loaded")
