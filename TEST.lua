-- BynzzBponjon Final GUI & Fitur
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local RunService = game:GetService("RunService")

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
local currentIndex = 1
local delaySeconds = 5
local speed = 1
local autoDeath = false
local serverHop = false

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
    mainFrame.Size = UDim2.new(0,500,0,300)
    mainFrame.Position = UDim2.new(0.1,0,0.1,0)
    mainFrame.BackgroundColor3 = Color3.fromRGB(25,25,25)
    mainFrame.BorderSizePixel = 0
    mainFrame.Active = true
    mainFrame.Draggable = true

    -- Header
    local header = Instance.new("Frame", mainFrame)
    header.Size = UDim2.new(1,0,0,30)
    header.BackgroundColor3 = Color3.fromRGB(50,50,50)

    local title = Instance.new("TextLabel", header)
    title.Size = UDim2.new(0.6,0,1,0)
    title.Position = UDim2.new(0,10,0,0)
    title.BackgroundTransparency = 1
    title.Text = "BynzzBponjon"
    title.TextColor3 = Color3.new(1,1,1)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 18
    title.TextXAlignment = Enum.TextXAlignment.Left

    local hideBtn = Instance.new("TextButton", header)
    hideBtn.Size = UDim2.new(0.2,0,1,0)
    hideBtn.Position = UDim2.new(0.6,0,0,0)
    hideBtn.Text = "Hide"
    hideBtn.TextColor3 = Color3.new(1,1,1)
    hideBtn.BackgroundColor3 = Color3.fromRGB(100,100,100)

    local closeBtn = Instance.new("TextButton", header)
    closeBtn.Size = UDim2.new(0.2,0,1,0)
    closeBtn.Position = UDim2.new(0.8,0,0,0)
    closeBtn.Text = "X"
    closeBtn.TextColor3 = Color3.new(1,1,1)
    closeBtn.BackgroundColor3 = Color3.fromRGB(200,0,50)

    closeBtn.MouseButton1Click:Connect(function() mainFrame:Destroy() end)

    -- Panels
    local leftPanel = Instance.new("Frame", mainFrame)
    leftPanel.Size = UDim2.new(0,120,1,-30)
    leftPanel.Position = UDim2.new(0,0,0,30)
    leftPanel.BackgroundColor3 = Color3.fromRGB(15,15,15)

    local rightPanel = Instance.new("Frame", mainFrame)
    rightPanel.Size = UDim2.new(1,-120,1,-30)
    rightPanel.Position = UDim2.new(0,120,0,30)
    rightPanel.BackgroundColor3 = Color3.fromRGB(20,20,20)

    -- Menu Buttons
    local menuItems = {"Auto","Server","Setting","Info","Auto Death"}
    local menuButtons = {}
    for i,name in ipairs(menuItems) do
        local btn = Instance.new("TextButton", leftPanel)
        btn.Size = UDim2.new(1,0,0,40)
        btn.Position = UDim2.new(0,0,0,(i-1)*45)
        btn.Text = name
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 16
        btn.TextColor3 = Color3.new(1,1,1)
        btn.BackgroundColor3 = Color3.fromRGB(25,25,25)
        menuButtons[name] = btn
    end

    -- Right panel content holder
    local function clearRight()
        for _,v in pairs(rightPanel:GetChildren()) do
            if v:IsA("GuiObject") then v:Destroy() end
        end
    end

    -- ================= Right Panel Contents =================
    local function showAuto()
        clearRight()
        local startBtn = Instance.new("TextButton", rightPanel)
        startBtn.Size = UDim2.new(0.4,0,0,40)
        startBtn.Position = UDim2.new(0.05,0,0,10)
        startBtn.Text = "Start"
        startBtn.BackgroundColor3 = Color3.fromRGB(0,200,0)
        startBtn.TextColor3 = Color3.new(1,1,1)
        local stopBtn = Instance.new("TextButton", rightPanel)
        stopBtn.Size = UDim2.new(0.4,0,0,40)
        stopBtn.Position = UDim2.new(0.55,0,0,10)
        stopBtn.Text = "Stop"
        stopBtn.BackgroundColor3 = Color3.fromRGB(200,0,0)
        stopBtn.TextColor3 = Color3.new(1,1,1)

        startBtn.MouseButton1Click:Connect(function()
            if autoSummitActive then return end
            autoSummitActive = true
            showNotification("Auto Summit Started")
            spawn(function()
                while autoSummitActive and currentIndex<=#checkpoints do
                    local cp = checkpoints[currentIndex]
                    if player.Character and player.Character.PrimaryPart then
                        player.Character:SetPrimaryPartCFrame(CFrame.new(cp.pos))
                    end
                    task.wait(delaySeconds/speed)
                    currentIndex = currentIndex + 1
                end
                autoSummitActive = false
                currentIndex = 1
                showNotification("Auto Summit Finished")
            end)
        end)

        stopBtn.MouseButton1Click:Connect(function()
            if autoSummitActive then
                autoSummitActive = false
                showNotification("Auto Summit Stopped")
                currentIndex = 1
            end
        end)
    end

    local function showCPManual()
        clearRight()
        for i,cp in ipairs(checkpoints) do
            local btn = Instance.new("TextButton", rightPanel)
            btn.Size = UDim2.new(1,-20,0,30)
            btn.Position = UDim2.new(0,10,0,(i-1)*35)
            btn.Text = cp.name
            btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
            btn.TextColor3 = Color3.new(1,1,1)
            btn.MouseButton1Click:Connect(function()
                if player.Character and player.Character.PrimaryPart then
                    player.Character:SetPrimaryPartCFrame(CFrame.new(cp.pos))
                end
            end)
        end
    end

    local function showServer()
        clearRight()
        local serverBtn = Instance.new("TextButton", rightPanel)
        serverBtn.Size = UDim2.new(0.5,0,0,40)
        serverBtn.Position = UDim2.new(0.25,0,0,10)
        serverBtn.Text = serverHop and "ON" or "OFF"
        serverBtn.BackgroundColor3 = serverHop and Color3.fromRGB(0,200,0) or Color3.fromRGB(200,0,0)
        serverBtn.TextColor3 = Color3.new(1,1,1)
        serverBtn.MouseButton1Click:Connect(function()
            serverHop = not serverHop
            serverBtn.Text = serverHop and "ON" or "OFF"
            serverBtn.BackgroundColor3 = serverHop and Color3.fromRGB(0,200,0) or Color3.fromRGB(200,0,0)
        end)
    end

    local function showSetting()
        clearRight()
        -- Delay
        local delayLabel = Instance.new("TextLabel", rightPanel)
        delayLabel.Size = UDim2.new(0.4,0,0,30)
        delayLabel.Position = UDim2.new(0.05,0,0,10)
        delayLabel.Text = "Delay:"
        delayLabel.TextColor3 = Color3.new(1,1,1)
        delayLabel.BackgroundTransparency = 1
        local delayBox = Instance.new("TextBox", rightPanel)
        delayBox.Size = UDim2.new(0.5,0,0,30)
        delayBox.Position = UDim2.new(0.5,0,0,10)
        delayBox.Text = tostring(delaySeconds)
        delayBox.TextColor3 = Color3.new(1,1,1)
        delayBox.BackgroundColor3 = Color3.fromRGB(50,50,50)
        delayBox.FocusLost:Connect(function()
            local val = tonumber(delayBox.Text)
            if val and val>0 then delaySeconds = val end
        end)
        -- Speed
        local speedLabel = Instance.new("TextLabel", rightPanel)
        speedLabel.Size = UDim2.new(0.4,0,0,30)
        speedLabel.Position = UDim2.new(0.05,0,0,50)
        speedLabel.Text = "Speed:"
        speedLabel.TextColor3 = Color3.new(1,1,1)
        speedLabel.BackgroundTransparency = 1
        local speedBox = Instance.new("TextBox", rightPanel)
        speedBox.Size = UDim2.new(0.5,0,0,30)
        speedBox.Position = UDim2.new(0.5,0,0,50)
        speedBox.Text = tostring(speed)
        speedBox.TextColor3 = Color3.new(1,1,1)
        speedBox.BackgroundColor3 = Color3.fromRGB(50,50,50)
        speedBox.FocusLost:Connect(function()
            local val = tonumber(speedBox.Text)
            if val and val>0 then speed = val end
        end)
    end

    local function showInfo()
        clearRight()
        local info = Instance.new("TextLabel", rightPanel)
        info.Size = UDim2.new(1,0,1,0)
        info.Position = UDim2.new(0,0,0,0)
        info.Text = "BynzzBponjon Script Info\nVersion: Final\nBypass Summit v1.0"
        info.TextColor3 = Color3.new(1,1,1)
        info.BackgroundTransparency = 1
        info.TextScaled = true
    end

    local function showAutoDeath()
        clearRight()
        local adBtn = Instance.new("TextButton", rightPanel)
        adBtn.Size = UDim2.new(0.5,0,0,40)
        adBtn.Position = UDim2.new(0.25,0,0,10)
        adBtn.Text = autoDeath and "ON" or "OFF"
        adBtn.BackgroundColor3 = autoDeath and Color3.fromRGB(0,200,0) or Color3.fromRGB(200,0,0)
        adBtn.TextColor3 = Color3.new(1,1,1)
        adBtn.MouseButton1Click:Connect(function()
            autoDeath = not autoDeath
            adBtn.Text = autoDeath and "ON" or "OFF"
            adBtn.BackgroundColor3 = autoDeath and Color3.fromRGB(0,200,0) or Color3.fromRGB(200,0,0)
        end)
    end

    -- Menu button clicks
    menuButtons["Auto"].MouseButton1Click:Connect(showAuto)
    menuButtons["Server"].MouseButton1Click:Connect(showServer)
    menuButtons["Setting"].MouseButton1Click:Connect(showSetting)
    menuButtons["Info"].MouseButton1Click:Connect(showInfo)
    menuButtons["Auto Death"].MouseButton1Click:Connect(showAutoDeath)
    menuButtons["Auto"].MouseButton1Click:Connect(showAuto)

    -- CP Manual (sub-menu di Auto)
    local cpBtn = Instance.new("TextButton", leftPanel)
    cpBtn.Size = UDim2.new(1,0,0,40)
    cpBtn.Position = UDim2.new(0,0,0,225)
    cpBtn.Text = "CP Manual"
    cpBtn.Font = Enum.Font.GothamBold
    cpBtn.TextSize = 16
    cpBtn.TextColor3 = Color3.new(1,1,1)
    cpBtn.BackgroundColor3 = Color3.fromRGB(25,25,25)
    cpBtn.MouseButton1Click:Connect(showCPManual)

    -- Hide functionality
    local hidden = false
    hideBtn.MouseButton1Click:Connect(function()
        hidden = not hidden
        for _,v in pairs(mainFrame:GetChildren()) do
            if v ~= header then
                v.Visible = not hidden
            end
        end
    end)
end

createGui()
