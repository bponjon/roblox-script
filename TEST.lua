-- BynzzBponjon Final
local Players = game:GetService("Players")
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
local function createGui()
    if playerGui:FindFirstChild("BynzzBponjonGui") then
        playerGui.BynzzBponjonGui:Destroy()
    end

    local screen = Instance.new("ScreenGui", playerGui)
    screen.Name = "BynzzBponjonGui"
    screen.ResetOnSpawn = false

    local mainFrame = Instance.new("Frame", screen)
    mainFrame.Size = UDim2.new(0,500,0,350)
    mainFrame.Position = UDim2.new(0.1,0,0.1,0)
    mainFrame.BackgroundColor3 = Color3.fromRGB(20,20,20)
    mainFrame.Active = true
    mainFrame.Draggable = true

    -- Header
    local header = Instance.new("Frame", mainFrame)
    header.Size = UDim2.new(1,0,0,30)
    header.BackgroundColor3 = Color3.fromRGB(40,40,40)

    local headerLabel = Instance.new("TextLabel", header)
    headerLabel.Size = UDim2.new(0.7,0,1,0)
    headerLabel.Position = UDim2.new(0,10,0,0)
    headerLabel.Text = "BynzzBponjon"
    headerLabel.TextColor3 = Color3.new(1,1,1)
    headerLabel.BackgroundTransparency = 1
    headerLabel.Font = Enum.Font.SourceSansBold
    headerLabel.TextSize = 18
    headerLabel.TextXAlignment = Enum.TextXAlignment.Left

    -- Hide / Close Buttons
    local hideBtn = Instance.new("TextButton", header)
    hideBtn.Size = UDim2.new(0.15,0,1,0)
    hideBtn.Position = UDim2.new(0.7,0,0,0)
    hideBtn.Text = "Hide"
    hideBtn.BackgroundColor3 = Color3.fromRGB(180,180,180)
    hideBtn.TextColor3 = Color3.new(0,0,0)

    local closeBtn = Instance.new("TextButton", header)
    closeBtn.Size = UDim2.new(0.15,0,1,0)
    closeBtn.Position = UDim2.new(0.85,0,0,0)
    closeBtn.Text = "X"
    closeBtn.BackgroundColor3 = Color3.fromRGB(200,0,50)
    closeBtn.TextColor3 = Color3.new(1,1,1)

    closeBtn.MouseButton1Click:Connect(function()
        mainFrame:Destroy()
    end)

    local leftPanel = Instance.new("Frame", mainFrame)
    leftPanel.Size = UDim2.new(0,120,1,-30)
    leftPanel.Position = UDim2.new(0,0,0,30)
    leftPanel.BackgroundColor3 = Color3.fromRGB(0,0,0)

    local rightPanel = Instance.new("Frame", mainFrame)
    rightPanel.Size = UDim2.new(0,380,1,-30)
    rightPanel.Position = UDim2.new(0,120,0,30)
    rightPanel.BackgroundColor3 = Color3.fromRGB(10,10,10)

    -- Menu
    local menus = {"Auto","Server","Setting","Info","Auto Death"}
    local menuBtns = {}
    for i, m in ipairs(menus) do
        local btn = Instance.new("TextButton", leftPanel)
        btn.Size = UDim2.new(1,0,0,50)
        btn.Position = UDim2.new(0,0,0,(i-1)*50)
        btn.Text = m
        btn.Font = Enum.Font.SourceSansBold
        btn.TextSize = 18
        btn.BackgroundColor3 = Color3.fromRGB(30,30,30)
        btn.TextColor3 = Color3.new(1,1,1)
        menuBtns[m] = btn
    end

    -- Right Panel Update Function
    local function clearRightPanel()
        for _,c in pairs(rightPanel:GetChildren()) do
            if not c:IsA("UIListLayout") then
                c:Destroy()
            end
        end
    end

    -- Auto Summit
    local function showAuto()
        clearRightPanel()
        local startBtn = Instance.new("TextButton", rightPanel)
        startBtn.Size = UDim2.new(0.8,0,0,40)
        startBtn.Position = UDim2.new(0.1,0,0,20)
        startBtn.Text = "Start Auto Summit"
        startBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
        startBtn.TextColor3 = Color3.new(1,1,1)
        startBtn.Font = Enum.Font.SourceSans
        startBtn.TextSize = 16
        startBtn.MouseButton1Click:Connect(function()
            if not autoSummitActive then
                autoSummitActive = true
                showNotification("Auto Summit Started")
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
                            showNotification("Auto Summit Completed")
                        end
                    end
                end)
            else
                autoSummitActive = false
                showNotification("Auto Summit Stopped")
            end
        end)
    end

    -- CP Manual
    local function showCPManual()
        clearRightPanel()
        for i,cp in ipairs(checkpoints) do
            local btn = Instance.new("TextButton", rightPanel)
            btn.Size = UDim2.new(0.8,0,0,30)
            btn.Position = UDim2.new(0.1,0,0,(i-1)*35)
            btn.Text = cp.name
            btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
            btn.TextColor3 = Color3.new(1,1,1)
            btn.Font = Enum.Font.SourceSans
            btn.TextSize = 14
            btn.MouseButton1Click:Connect(function()
                if player.Character and player.Character.PrimaryPart then
                    player.Character:SetPrimaryPartCFrame(CFrame.new(cp.pos))
                end
            end)
        end
    end

    menuBtns["Auto"].MouseButton1Click:Connect(showAuto)
    menuBtns["Auto Death"].MouseButton1Click:Connect(function()
        clearRightPanel()
        local toggleBtn = Instance.new("TextButton", rightPanel)
        toggleBtn.Size = UDim2.new(0.8,0,0,40)
        toggleBtn.Position = UDim2.new(0.1,0,0,20)
        toggleBtn.Text = "Toggle Auto Death"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
        toggleBtn.TextColor3 = Color3.new(1,1,1)
        toggleBtn.Font = Enum.Font.SourceSans
        toggleBtn.TextSize = 16
        toggleBtn.MouseButton1Click:Connect(function()
            autoDeathActive = not autoDeathActive
            showNotification("Auto Death "..(autoDeathActive and "Enabled" or "Disabled"))
        end)
    end)
    menuBtns["Server"].MouseButton1Click:Connect(function()
        clearRightPanel()
        local toggleBtn = Instance.new("TextButton", rightPanel)
        toggleBtn.Size = UDim2.new(0.8,0,0,40)
        toggleBtn.Position = UDim2.new(0.1,0,0,20)
        toggleBtn.Text = "Toggle Server Hop"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
        toggleBtn.TextColor3 = Color3.new(1,1,1)
        toggleBtn.Font = Enum.Font.SourceSans
        toggleBtn.TextSize = 16
        toggleBtn.MouseButton1Click:Connect(function()
            serverHopActive = not serverHopActive
            showNotification("Server Hop "..(serverHopActive and "Enabled" or "Disabled"))
        end)
    end)
    menuBtns["Setting"].MouseButton1Click:Connect(function()
        clearRightPanel()
        local delayLabel = Instance.new("TextLabel", rightPanel)
        delayLabel.Size = UDim2.new(0.8,0,0,30)
        delayLabel.Position = UDim2.new(0.1,0,0,20)
        delayLabel.Text = "Delay (s):"
        delayLabel.TextColor3 = Color3.new(1,1,1)
        delayLabel.BackgroundTransparency = 1
        delayLabel.Font = Enum.Font.SourceSans
        delayLabel.TextSize = 16

        local delayBox = Instance.new("TextBox", rightPanel)
        delayBox.Size = UDim2.new(0.8,0,0,30)
        delayBox.Position = UDim2.new(0.1,0,0,60)
        delayBox.Text = tostring(delaySeconds)
        delayBox.TextColor3 = Color3.new(1,1,1)
        delayBox.BackgroundColor3 = Color3.fromRGB(30,30,30)
        delayBox.Font = Enum.Font.SourceSans
        delayBox.TextSize = 16
        delayBox.ClearTextOnFocus = false
        delayBox.FocusLost:Connect(function()
            local val = tonumber(delayBox.Text)
            if val and val>0 then delaySeconds = val end
        end)

        local speedLabel = Instance.new("TextLabel", rightPanel)
        speedLabel.Size = UDim2.new(0.8,0,0,30)
        speedLabel.Position = UDim2.new(0.1,0,0,100)
        speedLabel.Text = "Speed:"
        speedLabel.TextColor3 = Color3.new(1,1,1)
        speedLabel.BackgroundTransparency = 1
        speedLabel.Font = Enum.Font.SourceSans
        speedLabel.TextSize = 16

        local speedBox = Instance.new("TextBox", rightPanel)
        speedBox.Size = UDim2.new(0.8,0,0,30)
        speedBox.Position = UDim2.new(0.1,0,0,130)
        speedBox.Text = tostring(speed)
        speedBox.TextColor3 = Color3.new(1,1,1)
        speedBox.BackgroundColor3 = Color3.fromRGB(30,30,30)
        speedBox.Font = Enum.Font.SourceSans
        speedBox.TextSize = 16
        speedBox.ClearTextOnFocus = false
        speedBox.FocusLost:Connect(function()
            local val = tonumber(speedBox.Text)
            if val and val>0 then speed = val end
        end)
    end)
    menuBtns["Info"].MouseButton1Click:Connect(function()
        clearRightPanel()
        local infoLabel = Instance.new("TextLabel", rightPanel)
        infoLabel.Size = UDim2.new(0.9,0,0.9,0)
        infoLabel.Position = UDim2.new(0.05,0,0.05,0)
        infoLabel.Text = "BynzzBponjon Info\nVersion 1.0"
        infoLabel.TextColor3 = Color3.new(1,1,1)
        infoLabel.BackgroundTransparency = 1
        infoLabel.Font = Enum.Font.SourceSans
        infoLabel.TextSize = 16
    end)

    -- Hide Button Logic
    local hidden = false
    hideBtn.MouseButton1Click:Connect(function()
        hidden = not hidden
        for _,c in pairs(mainFrame:GetChildren()) do
            if c ~= header then
                c.Visible = not hidden
            end
        end
    end)

    return screen
end

createGui()
