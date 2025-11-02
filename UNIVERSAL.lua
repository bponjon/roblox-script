-- UNIVERSAL AUTO SUMMIT V37 (HIDE FIXED) - Ready to paste
-- Hide now leaves header visible (only header remains). ZIndex & stability tweaks included.

local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local ok, playerGui = pcall(function() return player:WaitForChild("PlayerGui",5) end)
if not ok or not playerGui then warn("PlayerGui not ready. Abort."); return end

local CURRENT_PLACE_ID = tostring(game.PlaceId)

local MAP_CONFIG = {
    ["94261028489288"] = {name="MOUNT KOHARU (21 CP)", checkpoints = {
        {name="Basecamp", pos=Vector3.new(-883.288,43.358,933.698)},
        {name="CP1", pos=Vector3.new(-473.240,49.167,624.194)},
        {name="CP2", pos=Vector3.new(-182.927,52.412,691.074)},
        {name="CP3", pos=Vector3.new(122.499,202.548,951.741)},
        {name="CP4", pos=Vector3.new(10.684,194.377,340.400)},
        {name="CP5", pos=Vector3.new(244.394,194.369,805.065)},
        {name="CP6", pos=Vector3.new(660.531,210.886,749.360)},
        {name="CP7", pos=Vector3.new(660.649,202.965,368.070)},
        {name="CP8", pos=Vector3.new(520.852,214.338,281.842)},
        {name="CP9", pos=Vector3.new(523.730,214.369,-333.936)},
        {name="CP10", pos=Vector3.new(561.610,211.787,-559.470)},
        {name="CP11", pos=Vector3.new(566.837,282.541,-924.107)},
        {name="CP12", pos=Vector3.new(115.198,286.309,-655.635)},
        {name="CP13", pos=Vector3.new(-308.343,410.144,-612.031)},
        {name="CP14", pos=Vector3.new(-487.722,522.666,-663.426)},
        {name="CP15", pos=Vector3.new(-679.093,482.701,-971.988)},
        {name="CP16", pos=Vector3.new(-559.058,258.369,-1318.780)},
        {name="CP17", pos=Vector3.new(-426.353,374.369,-1512.621)},
        {name="CP18", pos=Vector3.new(-984.797,635.003,-1621.875)},
        {name="CP19", pos=Vector3.new(-1394.228,797.455,-1563.855)},
        {name="Puncak", pos=Vector3.new(-1534.938,933.116,-2176.096)}
    }},
    ["140014177882408"] = {name="MOUNT GEMI (2 CP)", checkpoints = {
        {name="Basecamp", pos=Vector3.new(1269.030, 639.076, 1793.997)},
        {name="Puncak", pos=Vector3.new(-6665.046, 3151.532, -799.116)}
    }},
    ["127557455707420"] = {name="MOUNT JALUR TAKDIR (7 CP)", checkpoints = {
        {name="Basecamp", pos=Vector3.new(-942.227, 14.021, -954.444)},
        {name="Checkpoint 1", pos=Vector3.new(-451.266, 78.021, -662.000)},
        {name="Checkpoint 2", pos=Vector3.new(-484.121, 78.015, 119.971)},
        {name="Checkpoint 3", pos=Vector3.new(576.478, 242.021, 852.784)},
        {name="Checkpoint 4", pos=Vector3.new(779.530, 606.021, -898.384)},
        {name="Checkpoint 5", pos=Vector3.new(-363.401, 1086.021, 705.354)},
        {name="Puncak", pos=Vector3.new(292.418, 1274.021, 374.069)}
    }},
    ["79272087242323"] = {name="MOUNT LIRVANA (22 CP)", checkpoints = {
        {name="Checkpoint 0", pos=Vector3.new(-33.023, 86.149, 7.025)},
        {name="Checkpoint 1", pos=Vector3.new(35.501, 200.700, -559.027)},
        {name="Checkpoint 2", pos=Vector3.new(-381.037, 316.700, -560.712)},
        {name="Checkpoint 3", pos=Vector3.new(-401.126, 456.700, -1014.478)},
        {name="Checkpoint 4", pos=Vector3.new(-35.014, 548.700, -1028.476)},
        {name="Checkpoint 5", pos=Vector3.new(-50.832, 542.149, -1371.412)},
        {name="Checkpoint 6", pos=Vector3.new(-68.830, 582.149, -1615.556)},
        {name="Checkpoint 7", pos=Vector3.new(262.292, 610.149, -1647.285)},
        {name="Checkpoint 8", pos=Vector3.new(270.919, 678.149, -1378.510)},
        {name="Checkpoint 9", pos=Vector3.new(278.914, 622.149, -1025.756)},
        {name="Checkpoint 10", pos=Vector3.new(292.020, 638.149, -676.378)},
        {name="Checkpoint 11", pos=Vector3.new(601.175, 678.149, -680.490)},
        {name="Checkpoint 12", pos=Vector3.new(617.442, 626.149, -1028.689)},
        {name="Checkpoint 13", pos=Vector3.new(600.942, 678.149, -1370.222)},
        {name="Checkpoint 14", pos=Vector3.new(594.054, 670.149, -1626.474)},
        {name="Checkpoint 15", pos=Vector3.new(917.511, 690.149, -1644.750)},
        {name="Checkpoint 16", pos=Vector3.new(899.131, 702.149, -1362.030)},
        {name="Checkpoint 17", pos=Vector3.new(971.016, 674.149, -941.262)},
        {name="Checkpoint 18", pos=Vector3.new(880.015, 710.149, -675.175)},
        {name="Checkpoint 19", pos=Vector3.new(1187.287, 694.149, -661.098)},
        {name="Checkpoint 20", pos=Vector3.new(1187.453, 718.149, -332.297)},
        {name="Puncak", pos=Vector3.new(799.696, 1001.949, 207.303)}
    }},
    ["129916920179384"] = {name="MOUNT AHPAYAH (12 CP)", checkpoints = {
        {name="Basecamp", pos=Vector3.new(-405.208, 46.021, -540.538)},
        {name="Checkpoint 1", pos=Vector3.new(-397.862, 46.386, -225.315)},
        {name="Checkpoint 2", pos=Vector3.new(446.973, 310.386, -454.457)},
        {name="Checkpoint 3", pos=Vector3.new(389.741, 415.219, -38.504)},
        {name="Checkpoint 4", pos=Vector3.new(228.787, 358.386, 420.735)},
        {name="Checkpoint 5", pos=Vector3.new(-248.196, 546.015, 537.969)},
        {name="Checkpoint 6", pos=Vector3.new(-707.398, 478.386, 471.019)},
        {name="Checkpoint 7", pos=Vector3.new(-823.563, 598.903, -193.940)},
        {name="Checkpoint 8", pos=Vector3.new(-1539.058, 682.267, -643.505)},
        {name="Checkpoint 9", pos=Vector3.new(-1581.844, 650.396, 448.762)},
        {name="Checkpoint 10", pos=Vector3.new(-2566.289, 662.396, 450.378)},
        {name="Puncak", pos=Vector3.new(-2921.433, 844.065, 18.757)}
    }},
    ["111417482709154"] = {name="MOUNT BINGUNG (22 CP)", checkpoints = {
        {name="Basecamp", pos=Vector3.new(166.00293,14.9578,822.9834)},
        {name="Checkpoint 1", pos=Vector3.new(198.238098,10.1375217,128.423187)},
        {name="Checkpoint 2", pos=Vector3.new(228.194977,128.879974,-211.192383)},
        {name="Checkpoint 3", pos=Vector3.new(231.817947,146.768204,-558.723816)},
        {name="Checkpoint 4", pos=Vector3.new(340.004669,132.319489,-987.244446)},
        {name="Checkpoint 5", pos=Vector3.new(393.582062,119.624352,-1415.08472)},
        {name="Checkpoint 6", pos=Vector3.new(344.682739,190.306702,-2695.90625)},
        {name="Checkpoint 7", pos=Vector3.new(353.37085,243.564514,-3065.35181)},
        {name="Checkpoint 8", pos=Vector3.new(-1.62862873,259.373474,-3431.15869)},
        {name="Checkpoint 9", pos=Vector3.new(54.7402382,373.025543,-3835.73633)},
        {name="Checkpoint 10", pos=Vector3.new(-347.480225,505.230347,-4970.26514)},
        {name="Checkpoint 11", pos=Vector3.new(-841.818359,506.035736,-4984.36621)},
        {name="Checkpoint 12", pos=Vector3.new(-825.191345,571.779053,-5727.79297)},
        {name="Checkpoint 13", pos=Vector3.new(-831.682068,575.300842,-6424.26855)},
        {name="Checkpoint 14", pos=Vector3.new(-288.520508,661.583984,-6804.15234)},
        {name="Checkpoint 15", pos=Vector3.new(675.513794,743.510742,-7249.33496)},
        {name="Checkpoint 16", pos=Vector3.new(816.311768,833.685852,-7606.22998)},
        {name="Checkpoint 17", pos=Vector3.new(805.29248,821.01062,-8516.9082)},
        {name="Checkpoint 18", pos=Vector3.new(473.562775,879.063538,-8585.45312)},
        {name="Checkpoint 19", pos=Vector3.new(268.831238,897.108215,-8576.44922)},
        {name="Checkpoint 20", pos=Vector3.new(285.314331,933.954651,-8983.91992)},
        {name="Puncak", pos=Vector3.new(107.141029,988.262573,-9015.23145)}
    }},
    ["76084648389385"] = {name="MOUNT TENERIE (6 CP)", checkpoints = {
        {name="Basecamp", pos=Vector3.new(24.996, 163.296, 319.838)},
        {name="Checkpoint 1", pos=Vector3.new(24.996, 163.296, 319.838)},
        {name="Checkpoint 2", pos=Vector3.new(-830.715, 239.184, 887.750)},
        {name="Checkpoint 3", pos=Vector3.new(-1081.016, 400.153, 1662.579)},
        {name="Checkpoint 4", pos=Vector3.new(-638.603, 659.233, 3034.486)},
        {name="Checkpoint 5", pos=Vector3.new(339.759, 820.852, 3891.180)},
        {name="Puncak", pos=Vector3.new(878.573, 1019.189, 4704.508)}
    }},
}

local currentMapConfig = MAP_CONFIG[CURRENT_PLACE_ID]
local scriptName = currentMapConfig and currentMapConfig.name or "UNIVERSAL (Map Tdk Dikenal)"
local checkpoints = currentMapConfig and currentMapConfig.checkpoints or {}

if not currentMapConfig or #checkpoints == 0 then
    local function tinyNotify(msg)
        pcall(function()
            local t = Instance.new("TextLabel", playerGui)
            t.Size = UDim2.new(0,350,0,30)
            t.Position = UDim2.new(0.5,-175,0.05,0)
            t.BackgroundColor3 = Color3.fromRGB(200,50,50)
            t.TextColor3 = Color3.new(1,1,1)
            t.Text = msg
            t.Font = Enum.Font.GothamBold
            t.TextScaled = true
            game:GetService("Debris"):AddItem(t,3)
        end)
    end
    tinyNotify("Map ID "..CURRENT_PLACE_ID.." tidak dikenali. Hentikan.")
    return
end

-- state
local autoSummit, autoDeath, serverHop, autoRepeat, antiAFK = false,false,false,false,false
local summitCount, summitLimit, delayTime, walkSpeed = 0, 5, 5, 16
local currentCpIndex = 1
local summitThread, antiAFKThread = nil, nil

local function notify(txt, color)
    pcall(function()
        local n = Instance.new("TextLabel", playerGui)
        n.Size = UDim2.new(0,420,0,36)
        n.Position = UDim2.new(0.5,-210,0.04,0)
        n.BackgroundColor3 = color or Color3.fromRGB(30,30,30)
        n.TextColor3 = Color3.new(1,1,1)
        n.Font = Enum.Font.GothamBold
        n.TextScaled = true
        n.Text = txt
        n.ZIndex = 50
        game:GetService("Debris"):AddItem(n,2)
    end)
end

local function findNearestCheckpoint()
    local character = player.Character or player.CharacterAdded:Wait()
    local rootPart = character:FindFirstChild("HumanoidRootPart") or character:WaitForChild("HumanoidRootPart",5)
    if not rootPart then return 1 end
    local playerPos = rootPart.Position
    local nearestIndex, minDist = 1, math.huge
    for i,cp in ipairs(checkpoints) do
        local cpPos = cp.pos
        if cpPos and typeof(cpPos) == "Vector3" then
            local d = (Vector3.new(playerPos.X,0,playerPos.Z) - Vector3.new(cpPos.X,0,cpPos.Z)).Magnitude
            if d < minDist then minDist, nearestIndex = d, i end
        end
    end
    if minDist > 300 and nearestIndex ~= #checkpoints then return 1 end
    if minDist < 50 and nearestIndex < #checkpoints then return nearestIndex + 1 end
    return nearestIndex
end

local function toggleAntiAFK(isEnable)
    antiAFK = isEnable
    if antiAFK and not antiAFKThread then
        notify("Anti-AFK ON", Color3.fromRGB(0,200,0))
        antiAFKThread = task.spawn(function()
            while antiAFK do
                pcall(function() 
                    -- fallback: simple jump to avoid using deprecated simulate
                    if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
                        player.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
                    end
                end)
                task.wait(12)
            end
            antiAFKThread = nil
        end)
    elseif not antiAFK and antiAFKThread then
        task.cancel(antiAFKThread); antiAFKThread=nil
        notify("Anti-AFK OFF", Color3.fromRGB(200,50,50))
    end
end

local function doServerHop()
    notify("Server Hop triggered...", Color3.fromRGB(0,120,220))
    pcall(function() TeleportService:Teleport(game.PlaceId, player) end)
    autoSummit = false
end

local function stopAuto()
    if summitThread then task.cancel(summitThread); summitThread = nil end
    autoSummit = false
    local nextCp = math.min(currentCpIndex, #checkpoints)
    notify("Auto Summit stopped. Next CP #"..nextCp..": "..checkpoints[nextCp].name, Color3.fromRGB(255,165,0))
end

local function startAuto()
    if autoSummit then return end
    autoSummit = true
    currentCpIndex = findNearestCheckpoint()
    local startIndex = currentCpIndex
    notify("Auto Summit start from CP #"..startIndex..": "..checkpoints[startIndex].name, Color3.fromRGB(0,150,255))
    summitThread = task.spawn(function()
        while autoSummit do
            if serverHop and summitCount >= (summitLimit or 5) then
                doServerHop(); break
            end
            local completedAll = true
            for i = startIndex, #checkpoints do
                if not autoSummit then currentCpIndex = i; completedAll=false; break end
                local char = player.Character or player.CharacterAdded:Wait()
                if char and char.PrimaryPart then
                    local t = checkpoints[i].pos
                    if t and typeof(t) == "Vector3" then
                        pcall(function() char:SetPrimaryPartCFrame(CFrame.new(t)) end)
                        notify("Teleport to CP #"..i..": "..checkpoints[i].name, Color3.fromRGB(0,255,120))
                    else
                        notify("Invalid CP #"..i.." pos, skip", Color3.fromRGB(255,80,80))
                    end
                else
                    notify("Character missing. Stop Auto.", Color3.fromRGB(255,80,80))
                    autoSummit=false; completedAll=false; break
                end
                currentCpIndex = i + 1
                if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
                    player.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = walkSpeed
                end
                task.wait(delayTime)
            end
            if completedAll then
                summitCount = summitCount + 1
                currentCpIndex = 1
                if autoRepeat then
                    notify("Summit #"..summitCount.." complete. AutoRepeat ON", Color3.fromRGB(0,255,100))
                    if autoDeath then
                        task.wait(0.5)
                        pcall(function() if player.Character then player.Character:BreakJoints() end end)
                        player.CharacterAdded:Wait(); task.wait(1.2)
                    else
                        if player.Character and player.Character.PrimaryPart and checkpoints[1].pos then
                            pcall(function() player.Character:SetPrimaryPartCFrame(CFrame.new(checkpoints[1].pos)) end)
                        end
                        task.wait(delayTime)
                    end
                else
                    notify("Summit #"..summitCount.." complete. Stopped.", Color3.fromRGB(0,255,100))
                    autoSummit = false; break
                end
            end
            if not autoRepeat and completedAll then break end
            startIndex = 1
        end
        summitThread = nil
        if not autoSummit then
            local nextCp = math.min(currentCpIndex, #checkpoints)
            notify("Stopped. Next CP #"..nextCp..": "..checkpoints[nextCp].name, Color3.fromRGB(255,165,0))
        end
    end)
end

-- GUI INIT
if playerGui:FindFirstChild("UniversalV37") then playerGui.UniversalV37:Destroy() end

local gui = Instance.new("ScreenGui", playerGui)
gui.Name = "UniversalV37"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Global

local MAIN_FULL_SIZE = UDim2.new(0,700,0,400)
local HEADER_SIZE = UDim2.new(0,700,0,30)
local MAIN_POS = UDim2.new(0.5,-350,0.18,0)

local main = Instance.new("Frame", gui)
main.Name = "Main"
main.Size = MAIN_FULL_SIZE
main.Position = MAIN_POS
main.BackgroundColor3 = Color3.fromRGB(25,25,25)
main.Active = true
main.Draggable = true
main.BorderSizePixel = 0
main.ZIndex = 50

local header = Instance.new("Frame", main)
header.Size = HEADER_SIZE
header.Position = UDim2.new(0,0,0,0)
header.BackgroundColor3 = Color3.fromRGB(30,30,30)
header.BorderSizePixel = 0
header.ZIndex = 60

local title = Instance.new("TextLabel", header)
title.Text = "Universal Auto Summit V37 - "..scriptName
title.Size = UDim2.new(1,-120,1,0)
title.Position = UDim2.new(0,6,0,0)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextScaled = true
title.TextXAlignment = Enum.TextXAlignment.Left
title.ZIndex = 61

local hideBtn = Instance.new("TextButton", header)
hideBtn.Size = UDim2.new(0,60,1,0)
hideBtn.Position = UDim2.new(1,-120,0,0)
hideBtn.Text = "Hide"
hideBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
hideBtn.TextColor3 = Color3.new(1,1,1)
hideBtn.Font = Enum.Font.GothamBold
hideBtn.ZIndex = 61

local closeBtn = Instance.new("TextButton", header)
closeBtn.Size = UDim2.new(0,60,1,0)
closeBtn.Position = UDim2.new(1,-60,0,0)
closeBtn.Text = "Close"
closeBtn.BackgroundColor3 = Color3.fromRGB(180,40,40)
closeBtn.TextColor3 = Color3.new(1,1,1)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.ZIndex = 61

local tabPanel = Instance.new("Frame", main)
tabPanel.Name = "TabPanel"
tabPanel.Size = UDim2.new(0,100,1,-30)
tabPanel.Position = UDim2.new(0,0,0,30)
tabPanel.BackgroundColor3 = Color3.fromRGB(35,35,35)
tabPanel.BorderSizePixel = 0
tabPanel.ZIndex = 55

local contentArea = Instance.new("Frame", main)
contentArea.Name = "ContentArea"
contentArea.Size = UDim2.new(1,-100,1,-30)
contentArea.Position = UDim2.new(0,100,0,30)
contentArea.BackgroundColor3 = Color3.fromRGB(20,20,20)
contentArea.BorderSizePixel = 0
contentArea.ZIndex = 55

-- Tabs
local autoTab = Instance.new("Frame", contentArea); autoTab.Size = UDim2.new(1,0,1,0); autoTab.BackgroundTransparency=1
local settingTab = Instance.new("Frame", contentArea); settingTab.Size = UDim2.new(1,0,1,0); settingTab.BackgroundTransparency=1; settingTab.Visible=false
local infoTab = Instance.new("Frame", contentArea); infoTab.Size = UDim2.new(1,0,1,0); infoTab.BackgroundTransparency=1; infoTab.Visible=false
local serverTab = Instance.new("Frame", contentArea); serverTab.Size = UDim2.new(1,0,1,0); serverTab.BackgroundTransparency=1; serverTab.Visible=false

local function setTab(name, btn)
    autoTab.Visible = (name=="AutoTab")
    settingTab.Visible = (name=="SettingTab")
    infoTab.Visible = (name=="InfoTab")
    serverTab.Visible = (name=="ServerTab")
    for _,c in ipairs(tabPanel:GetChildren()) do if c:IsA("TextButton") then c.BackgroundColor3 = Color3.fromRGB(35,35,35) end end
    if btn then btn.BackgroundColor3 = Color3.fromRGB(20,20,20) end
end

local tabY = 0
local function makeTab(text, tabName)
    local b = Instance.new("TextButton", tabPanel)
    b.Size = UDim2.new(1,0,0,50); b.Position = UDim2.new(0,0,0,tabY)
    b.Text = text; b.Font = Enum.Font.GothamBold; b.TextScaled = true
    b.BackgroundColor3 = Color3.fromRGB(35,35,35); b.TextColor3 = Color3.new(1,1,1); b.BorderSizePixel=0; b.ZIndex=56
    b.MouseButton1Click:Connect(function() setTab(tabName, b) end)
    tabY = tabY + 50
    return b
end

local btnAuto = makeTab("Auto","AutoTab")
local btnSet = makeTab("Setting","SettingTab")
local btnInfo = makeTab("Info","InfoTab")
local btnServer = makeTab("Server","ServerTab")
setTab("AutoTab", btnAuto)

-- AUTO TAB content
local startBtn = Instance.new("TextButton", autoTab)
startBtn.Size = UDim2.new(0.98,0,0,46); startBtn.Position=UDim2.new(0.01,0,0,8)
startBtn.Text="MULAI Auto Summit"; startBtn.Font=Enum.Font.GothamBold; startBtn.TextScaled=true
startBtn.BackgroundColor3=Color3.fromRGB(0,160,0); startBtn.TextColor3=Color3.new(1,1,1)
startBtn.ZIndex = 56
startBtn.MouseButton1Click:Connect(startAuto)

local stopBtn = Instance.new("TextButton", autoTab)
stopBtn.Size = UDim2.new(0.98,0,0,40); stopBtn.Position=UDim2.new(0.01,0,0,60)
stopBtn.Text="STOP Auto Summit"; stopBtn.Font=Enum.Font.GothamBold; stopBtn.TextScaled=true
stopBtn.BackgroundColor3=Color3.fromRGB(160,0,0); stopBtn.TextColor3=Color3.new(1,1,1)
stopBtn.ZIndex = 56
stopBtn.MouseButton1Click:Connect(stopAuto)

local cpLabel = Instance.new("TextLabel", autoTab)
cpLabel.Size = UDim2.new(0.98,0,0,20); cpLabel.Position = UDim2.new(0.01,0,0,110)
cpLabel.Text = "Checkpoint List ("..#checkpoints.." CP)"; cpLabel.BackgroundColor3=Color3.fromRGB(30,30,30)
cpLabel.TextColor3 = Color3.new(1,1,1); cpLabel.Font = Enum.Font.GothamBold; cpLabel.TextScaled = true; cpLabel.ZIndex = 56
cpLabel.TextXAlignment = Enum.TextXAlignment.Left

local cpFrame = Instance.new("Frame", autoTab)
cpFrame.Size = UDim2.new(0.98,0,1,-150); cpFrame.Position = UDim2.new(0.01,0,0,140)
cpFrame.BackgroundColor3 = Color3.fromRGB(30,30,30); cpFrame.BorderSizePixel = 0; cpFrame.ZIndex = 56

local cpList = Instance.new("ScrollingFrame", cpFrame)
cpList.Size = UDim2.new(1,0,1,0); cpList.BackgroundTransparency = 1; cpList.CanvasSize = UDim2.new(0,0,#checkpoints*30); cpList.ScrollBarThickness = 6; cpList.ZIndex = 56

local y = 0
for i,cp in ipairs(checkpoints) do
    local btn = Instance.new("TextButton", cpList)
    btn.Size = UDim2.new(1,0,0,28); btn.Position = UDim2.new(0,0,0,y)
    btn.Text = "#" .. i .. ": " .. cp.name; btn.Font = Enum.Font.SourceSans; btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.BackgroundColor3 = Color3.fromRGB(40,40,40); btn.TextColor3 = Color3.new(1,1,1); btn.BorderSizePixel = 0; btn.ZIndex = 56
    btn.MouseButton1Click:Connect(function()
        if player.Character and player.Character.PrimaryPart and typeof(cp.pos)=="Vector3" then
            pcall(function() player.Character:SetPrimaryPartCFrame(CFrame.new(cp.pos)) end)
            notify("Teleport to CP #"..i..": "..cp.name, Color3.fromRGB(120,170,255))
            stopAuto()
        end
    end)
    y = y + 30
end

-- SETTING TAB content
local function makeToggleBtn(parent, text, xpos, ypos, initial)
    local b = Instance.new("TextButton", parent)
    b.Size = UDim2.new(0.48,0,0,40); b.Position = UDim2.new(xpos,0,0,ypos)
    b.Text = text..": "..(initial and "ON" or "OFF"); b.Font = Enum.Font.GothamBold; b.TextScaled = true
    b.BackgroundColor3 = initial and Color3.fromRGB(0,150,200) or Color3.fromRGB(60,60,60)
    b.TextColor3 = Color3.new(1,1,1); b.BorderSizePixel = 0; b.ZIndex = 56
    return b
end

local settingY = 10
local autoRepeatBtn = makeToggleBtn(settingTab, "Auto Repeat", 0.01, settingY, autoRepeat)
local autoDeathBtn = makeToggleBtn(settingTab, "Auto Death", 0.01, settingY+50, autoDeath)
local serverHopBtn = makeToggleBtn(settingTab, "Server Hop", 0.51, settingY, serverHop)
local antiAFKBtn = makeToggleBtn(settingTab, "Anti-AFK", 0.51, settingY+50, antiAFK)

autoRepeatBtn.MouseButton1Click:Connect(function() autoRepeat = not autoRepeat; autoRepeatBtn.BackgroundColor3 = autoRepeat and Color3.fromRGB(0,150,200) or Color3.fromRGB(60,60,60); autoRepeatBtn.Text = "Auto Repeat: "..(autoRepeat and "ON" or "OFF") end)
autoDeathBtn.MouseButton1Click:Connect(function() autoDeath = not autoDeath; autoDeathBtn.BackgroundColor3 = autoDeath and Color3.fromRGB(0,150,200) or Color3.fromRGB(60,60,60); autoDeathBtn.Text = "Auto Death: "..(autoDeath and "ON" or "OFF") end)
serverHopBtn.MouseButton1Click:Connect(function() serverHop = not serverHop; serverHopBtn.BackgroundColor3 = serverHop and Color3.fromRGB(200,100,0) or Color3.fromRGB(60,60,60); serverHopBtn.Text = "Server Hop: "..(serverHop and "ON" or "OFF") end)
antiAFKBtn.MouseButton1Click:Connect(function() toggleAntiAFK(not antiAFK); antiAFKBtn.BackgroundColor3 = antiAFK and Color3.fromRGB(0,150,0) or Color3.fromRGB(60,60,60); antiAFKBtn.Text = "Anti-AFK: "..(antiAFK and "ON" or "OFF") end)

-- text boxes for delay/walkspeed/limit
local function makeBox(parent, text, xpos, ypos, initial)
    local b = Instance.new("TextBox", parent)
    b.Size = UDim2.new(0.48,0,0,40); b.Position = UDim2.new(xpos,0,0,ypos)
    b.Text = text..": "..tostring(initial); b.Font = Enum.Font.GothamBold; b.TextScaled=true
    b.BackgroundColor3 = Color3.fromRGB(40,40,40); b.TextColor3 = Color3.new(1,1,1); b.ClearTextOnFocus=false; b.ZIndex=56
    return b
end

local delayBox = makeBox(settingTab, "Delay (s)", 0.01, settingY+110, delayTime)
local speedBox = makeBox(settingTab, "WalkSpeed", 0.51, settingY+110, walkSpeed)
local limitBox = makeBox(settingTab, "Hop Limit (x)", 0.01, settingY+170, summitLimit)

delayBox.FocusLost:Connect(function(enter) if enter then local v = tonumber(delayBox.Text:match("(%d+%.?%d*)") or delayBox.Text); if v and v>=0.5 then delayTime=v; notify("Delay set: "..delayTime, Color3.fromRGB(255,165,0)) else notify("Delay invalid (min 0.5)", Color3.fromRGB(255,50,50)) end end end)
speedBox.FocusLost:Connect(function(enter) if enter then local v = tonumber(speedBox.Text:match("(%d+%.?%d*)") or speedBox.Text); if v and v>=1 then walkSpeed=v; if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then player.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = walkSpeed end notify("WalkSpeed set: "..walkSpeed, Color3.fromRGB(255,165,0)) else notify("Speed invalid", Color3.fromRGB(255,50,50)) end end end)
limitBox.FocusLost:Connect(function(enter) if enter then local v = tonumber(limitBox.Text:match("(%d+%.?%d*)") or limitBox.Text); if v and v>=1 then summitLimit=v; notify("Hop limit set: "..summitLimit, Color3.fromRGB(255,165,0)) else notify("Limit invalid", Color3.fromRGB(255,50,50)) end end end)

-- INFO TAB
local infoY = 10
local function addInfo(txt)
    local l = Instance.new("TextLabel", infoTab)
    l.Size = UDim2.new(0.98,0,0,24); l.Position = UDim2.new(0.01,0,0,infoY)
    l.Text = txt; l.BackgroundTransparency = 1; l.TextColor3 = Color3.new(1,1,1); l.Font = Enum.Font.GothamBold; l.TextScaled = true; l.TextXAlignment = Enum.TextXAlignment.Left; l.ZIndex = 56
    infoY = infoY + 26
    return l
end
addInfo("Map Aktif: "..scriptName)
local cpCountLabel = addInfo("Total CP: "..#checkpoints)
local currCpLabel = addInfo("Current CP Index: #"..currentCpIndex)
local summitLabel = addInfo("Summit berhasil: "..summitCount)
RunService.Heartbeat:Connect(function() cpCountLabel.Text = "Total CP: "..#checkpoints; currCpLabel.Text = "Current CP Index: #"..math.min(currentCpIndex,#checkpoints); summitLabel.Text = "Summit berhasil: "..summitCount end)

-- SERVER TAB
local function serverBtn(text, color, func) local b=Instance.new("TextButton", serverTab); b.Size=UDim2.new(0.98,0,0,44); b.Position=UDim2.new(0.01,0,0, #serverTab:GetChildren()*54); b.Text=text; b.BackgroundColor3=color; b.TextColor3=Color3.new(1,1,1); b.Font=Enum.Font.GothamBold; b.TextScaled=true; b.BorderSizePixel=0; b.ZIndex=56; b.MouseButton1Click:Connect(func); return b end
serverBtn("Teleport ke Basecamp", Color3.fromRGB(150,50,150), function()
    local base = checkpoints[1]
    if base and player.Character and player.Character.PrimaryPart and typeof(base.pos)=="Vector3" then
        pcall(function() player.Character:SetPrimaryPartCFrame(CFrame.new(base.pos)) end)
        notify("Teleported to Basecamp", Color3.fromRGB(200,150,255)); stopAuto()
    end
end)
serverBtn("Forced Server Hop", Color3.fromRGB(0,100,200), doServerHop)

-- HIDE logic (FIX)
local isHidden = false
local preservedSize = MAIN_FULL_SIZE
local preservedPos = MAIN_POS

hideBtn.MouseButton1Click:Connect(function()
    if not isHidden then
        -- hide body, keep header visible: shrink main to header size and reposition so header stays where it was
        preservedSize = main.Size
        preservedPos = main.Position
        main.Size = HEADER_SIZE
        main.Position = UDim2.new(main.Position.X.Scale, main.Position.X.Offset, main.Position.Y.Scale, main.Position.Y.Offset) -- keep pos
        -- hide children except header (but keep header's hide/close functional)
        for _,c in ipairs(main:GetChildren()) do
            if c ~= header then c.Visible = false end
        end
        hideBtn.Text = "Show"
        isHidden = true
    else
        -- restore
        main.Size = preservedSize or MAIN_FULL_SIZE
        main.Position = preservedPos or MAIN_POS
        for _,c in ipairs(main:GetChildren()) do c.Visible = true end
        -- make sure header is visible on top
        header.Visible = true
        hideBtn.Text = "Hide"
        isHidden = false
    end
end)

closeBtn.MouseButton1Click:Connect(function()
    toggleAntiAFK(false)
    stopAuto()
    if gui then pcall(function() gui:Destroy() end) end
end)

-- ensure initial character walkspeed
if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then player.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = walkSpeed end
player.CharacterAdded:Connect(function(c) local h = c:WaitForChild("Humanoid",5); if h then h.WalkSpeed = walkSpeed end end)

notify("UniversalV37 Loaded. Map: "..scriptName, Color3.fromRGB(0,200,100))
