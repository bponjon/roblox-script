-- BynzzBponjon 
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
local delaySeconds = 10 -- default 10, bisa diubah di textbox

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
    mainFrame.Size = UDim2.new(0,180,0,50)
    mainFrame.Position = UDim2.new(0.05,0,0.1,0)
    mainFrame.BackgroundColor3 = Color3.new(0,0,0)
    mainFrame.BorderSizePixel = 0
    mainFrame.Active = true
    mainFrame.Draggable = true

    -- Menu Buttons
    local function createMenuButton(parent, text, y)
        local btn = Instance.new("TextButton", parent)
        btn.Size = UDim2.new(1,0,0,30)
        btn.Position = UDim2.new(0,0,0,y)
        btn.Text = text
        btn.BackgroundColor3 = Color3.new(0,0,0)
        btn.TextColor3 = Color3.new(1,1,1)
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 16
        return btn
    end

    local autoBtn = createMenuButton(mainFrame,"Auto Summit",0)
    local manualBtn = createMenuButton(mainFrame,"Manual Checkpoints",0.5)
    local delayLabel = Instance.new("TextLabel",mainFrame)
    delayLabel.Size = UDim2.new(1,0,0,20)
    delayLabel.Position = UDim2.new(0,0,0.7,0)
    delayLabel.Text = "Delay (s):"
    delayLabel.TextColor3 = Color3.new(1,1,1)
    delayLabel.BackgroundTransparency = 1
    delayLabel.Font = Enum.Font.Gotham
    delayLabel.TextSize = 14

    local delayBox = Instance.new("TextBox",mainFrame)
    delayBox.Size = UDim2.new(1,0,0,20)
    delayBox.Position = UDim2.new(0,0,0.75,0)
    delayBox.Text = tostring(delaySeconds)
    delayBox.ClearTextOnFocus = false
    delayBox.TextColor3 = Color3.new(1,1,1)
    delayBox.BackgroundColor3 = Color3.new(0.2,0.2,0.2)
    delayBox.Font = Enum.Font.Gotham
    delayBox.TextSize = 14
    delayBox.FocusLost:Connect(function()
        local val = tonumber(delayBox.Text)
        if val and val>0 then delaySeconds = val end
    end)

    return screen, autoBtn, manualBtn
end

local screen, autoBtn, manualBtn = createGui()

-- =================== Auto Summit Logic ===================
local function startAutoSummit()
    if autoSummitActive then return end
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
end

local function stopAutoSummit()
    if autoSummitActive then
        autoSummitActive = false
        showNotification("Auto Summit Stopped")
    end
end

autoBtn.MouseButton1Click:Connect(function()
    if not autoSummitActive then
        startAutoSummit()
    else
        stopAutoSummit()
    end
end)
