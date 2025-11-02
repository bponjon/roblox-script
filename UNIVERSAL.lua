-- UNIVERSAL AUTO SUMMIT V37 (FINAL - UI TIDY + HIDE FIX + TRANSPARENCY SLIDER)
-- Paste ke LocalScript (client). Menggunakan MAP_CONFIG yang dikirim pengguna.

local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local ok, playerGui = pcall(function() return player:WaitForChild("PlayerGui",5) end)
if not ok or not playerGui then warn("PlayerGui not ready. Abort."); return end

local CURRENT_PLACE_ID = tostring(game.PlaceId)

-- MAP_CONFIG (gunakan data yang lo kirim; singkatkan penamaan)
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

-- safety: if no map found, show small notif and stop
if not currentMapConfig or #checkpoints == 0 then
    pcall(function()
        local t = Instance.new("TextLabel", playerGui)
        t.Size = UDim2.new(0,360,0,30)
        t.Position = UDim2.new(0.5,-180,0.06,0)
        t.BackgroundColor3 = Color3.fromRGB(200,60,60)
        t.TextColor3 = Color3.new(1,1,1)
        t.Text = "Map ID "..CURRENT_PLACE_ID.." tidak dikenali. Script nonaktif."
        t.Font = Enum.Font.GothamBold
        t.TextScaled = true
        game:GetService("Debris"):AddItem(t,4)
    end)
    return
end

-- state
local autoSummit, autoDeath, serverHop, autoRepeat, antiAFK = false,false,false,false,false
local summitCount, summitLimit, delayTime, walkSpeed = 0, 5, 4, 16
local currentCpIndex = 1
local summitThread, antiAFKThread = nil, nil

-- small notif util
local function notify(msg, color)
    pcall(function()
        local n = Instance.new("TextLabel", playerGui)
        n.Size = UDim2.new(0,420,0,34)
        n.Position = UDim2.new(0.5,-210,0.04,0)
        n.BackgroundColor3 = color or Color3.fromRGB(40,40,40)
        n.TextColor3 = Color3.new(1,1,1)
        n.Font = Enum.Font.GothamBold
        n.TextScaled = false
        n.TextSize = 14
        n.Text = msg
        n.ZIndex = 80
        game:GetService("Debris"):AddItem(n,2.2)
    end)
end

-- find nearest cp (resume logic)
local function findNearestCheckpoint()
    local char = player.Character or player.CharacterAdded:Wait()
    local root = char:FindFirstChild("HumanoidRootPart") or char:WaitForChild("HumanoidRootPart",5)
    if not root then return 1 end
    local p = root.Position
    local near, minD = 1, math.huge
    for i,cp in ipairs(checkpoints) do
        local pos = cp.pos
        if pos and typeof(pos) == "Vector3" then
            local d = (Vector3.new(p.X,0,p.Z) - Vector3.new(pos.X,0,pos.Z)).Magnitude
            if d < minD then minD, near = d, i end
        end
    end
    if minD > 300 and near ~= #checkpoints then return 1 end
    if minD < 50 and near < #checkpoints then return near + 1 end
    return near
end

-- anti AFK simpler (jump)
local function toggleAntiAFK(enable)
    antiAFK = enable
    if antiAFK and not antiAFKThread then
        notify("Anti-AFK ON", Color3.fromRGB(0,180,90))
        antiAFKThread = task.spawn(function()
            while antiAFK do
                pcall(function()
                    local char = player.Character
                    if char and char:FindFirstChildOfClass("Humanoid") then
                        char:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
                    end
                end)
                task.wait(12)
            end
            antiAFKThread = nil
        end)
    elseif not antiAFK and antiAFKThread then
        task.cancel(antiAFKThread); antiAFKThread = nil
        notify("Anti-AFK OFF", Color3.fromRGB(200,60,60))
    end
end

local function doServerHop()
    notify("Server Hop -> teleporting...", Color3.fromRGB(0,140,220))
    pcall(function() TeleportService:Teleport(game.PlaceId, player) end)
    autoSummit = false
end

local function stopAuto()
    if summitThread then 
        pcall(function() task.cancel(summitThread) end)
        summitThread = nil
    end
    autoSummit = false
    local nextCp = math.min(currentCpIndex, #checkpoints)
    notify("Auto stopped. Next CP #"..nextCp..": "..checkpoints[nextCp].name, Color3.fromRGB(255,170,0))
end

local function startAuto()
    if autoSummit then return end
    autoSummit = true
    currentCpIndex = findNearestCheckpoint()
    local startIndex = currentCpIndex
    notify("Auto start from CP #"..startIndex..": "..checkpoints[startIndex].name, Color3.fromRGB(0,160,255))
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
                        notify("CP #"..i..": "..checkpoints[i].name, Color3.fromRGB(0,220,120))
                    else
                        notify("CP #"..i.." invalid pos, skip", Color3.fromRGB(255,80,80))
                    end
                else
                    notify("Character missing, stopping", Color3.fromRGB(255,80,80))
                    autoSummit=false; completedAll=false; break
                end
                currentCpIndex = i + 1
                pcall(function()
                    local h = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
                    if h then h.WalkSpeed = walkSpeed end
                end)
                task.wait(delayTime)
            end
            if completedAll then
                summitCount = summitCount + 1
                currentCpIndex = 1
                if autoRepeat then
                    notify("Summit #"..summitCount.." complete. AutoRepeat ON", Color3.fromRGB(0,255,120))
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

-- GUI BUILD (tidy, smaller font, slider transparency)
if playerGui:FindFirstChild("UniversalV37") then playerGui.UniversalV37:Destroy() end
local gui = Instance.new("ScreenGui", playerGui)
gui.Name = "UniversalV37"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Global

local MAIN_W, MAIN_H = 660, 380
local HEADER_H = 30

local main = Instance.new("Frame", gui)
main.Name = "Main"; main.Size = UDim2.new(0,MAIN_W,0,MAIN_H); main.Position = UDim2.new(0.5,-MAIN_W/2,0.14,0)
main.BackgroundColor3 = Color3.fromRGB(28,28,28); main.Active=true; main.Draggable=true; main.BorderSizePixel=0; main.ZIndex=60

local header = Instance.new("Frame", main)
header.Size = UDim2.new(1,0,0,HEADER_H); header.Position = UDim2.new(0,0,0,0)
header.BackgroundColor3 = Color3.fromRGB(35,35,35); header.BorderSizePixel=0; header.ZIndex=61

local title = Instance.new("TextLabel", header)
title.Size = UDim2.new(1,-160,1,0); title.Position = UDim2.new(0,8,0,0)
title.BackgroundTransparency = 1
title.Text = "Universal Auto Summit V37 - "..scriptName
title.TextColor3 = Color3.new(1,1,1); title.Font = Enum.Font.GothamBold; title.TextScaled = false; title.TextSize = 14; title.TextXAlignment = Enum.TextXAlignment.Left; title.ZIndex=62

local btnHide = Instance.new("TextButton", header)
btnHide.Size = UDim2.new(0,70,1,0); btnHide.Position = UDim2.new(1,-150,0,0)
btnHide.Text = "Hide"; btnHide.Font = Enum.Font.GothamBold; btnHide.TextSize = 14; btnHide.BackgroundColor3 = Color3.fromRGB(70,70,70); btnHide.TextColor3 = Color3.new(1,1,1); btnHide.ZIndex=63

local btnClose = Instance.new("TextButton", header)
btnClose.Size = UDim2.new(0,70,1,0); btnClose.Position = UDim2.new(1,-74,0,0)
btnClose.Text = "Close"; btnClose.Font = Enum.Font.GothamBold; btnClose.TextSize = 14; btnClose.BackgroundColor3 = Color3.fromRGB(170,40,40); btnClose.TextColor3 = Color3.new(1,1,1); btnClose.ZIndex=63

local leftW = 100
local tabPanel = Instance.new("Frame", main)
tabPanel.Name = "TabPanel"; tabPanel.Size = UDim2.new(0,leftW,1,-HEADER_H); tabPanel.Position = UDim2.new(0,0,0,HEADER_H)
tabPanel.BackgroundColor3 = Color3.fromRGB(38,38,38); tabPanel.BorderSizePixel=0; tabPanel.ZIndex=61

local content = Instance.new("Frame", main)
content.Name = "Content"; content.Size = UDim2.new(1,-leftW,1,-HEADER_H); content.Position = UDim2.new(0,leftW,0,HEADER_H)
content.BackgroundColor3 = Color3.fromRGB(22,22,22); content.BorderSizePixel=0; content.ZIndex=61

-- tabs
local tabs = {}
local function newTabBtn(text, y)
    local b = Instance.new("TextButton", tabPanel)
    b.Size = UDim2.new(1,0,0,46); b.Position = UDim2.new(0,0,0,y)
    b.Text = text; b.Font = Enum.Font.GothamBold; b.TextSize = 13; b.TextColor3 = Color3.new(1,1,1)
    b.BackgroundColor3 = Color3.fromRGB(38,38,38); b.BorderSizePixel=0; b.ZIndex=62
    return b
end

local autoTabBtn = newTabBtn("Auto",0)
local setTabBtn = newTabBtn("Setting",46)
local infoTabBtn = newTabBtn("Info",92)
local serverTabBtn = newTabBtn("Server",138)

local autoTab = Instance.new("Frame", content); autoTab.Size = UDim2.new(1,0,1,0); autoTab.BackgroundTransparency=1; autoTab.ZIndex=62
local settingTab = Instance.new("Frame", content); settingTab.Size = UDim2.new(1,0,1,0); settingTab.BackgroundTransparency=1; settingTab.Visible=false; settingTab.ZIndex=62
local infoTab = Instance.new("Frame", content); infoTab.Size = UDim2.new(1,0,1,0); infoTab.BackgroundTransparency=1; infoTab.Visible=false; infoTab.ZIndex=62
local serverTab = Instance.new("Frame", content); serverTab.Size = UDim2.new(1,0,1,0); serverTab.BackgroundTransparency=1; serverTab.Visible=false; serverTab.ZIndex=62

local function setTab(name, btn)
    autoTab.Visible = (name=="Auto"); settingTab.Visible = (name=="Setting"); infoTab.Visible = (name=="Info"); serverTab.Visible = (name=="Server")
    for _,c in ipairs(tabPanel:GetChildren()) do if c:IsA("TextButton") then c.BackgroundColor3 = Color3.fromRGB(38,38,38) end end
    if btn then btn.BackgroundColor3 = Color3.fromRGB(28,28,28) end
end
setTab("Auto", autoTabBtn)

autoTabBtn.MouseButton1Click:Connect(function() setTab("Auto", autoTabBtn) end)
setTabBtn.MouseButton1Click:Connect(function() setTab("Setting", setTabBtn) end)
infoTabBtn.MouseButton1Click:Connect(function() setTab("Info", infoTabBtn) end)
serverTabBtn.MouseButton1Click:Connect(function() setTab("Server", serverTabBtn) end)

-- AUTO tab content
local startBtn = Instance.new("TextButton", autoTab)
startBtn.Size = UDim2.new(0.98,0,0,44); startBtn.Position = UDim2.new(0.01,0,0,10)
startBtn.Text = "START Auto Summit"; startBtn.Font = Enum.Font.GothamBold; startBtn.TextSize = 14
startBtn.BackgroundColor3 = Color3.fromRGB(0,150,0); startBtn.TextColor3 = Color3.new(1,1,1); startBtn.ZIndex=62
startBtn.MouseButton1Click:Connect(startAuto)

local stopBtn = Instance.new("TextButton", autoTab)
stopBtn.Size = UDim2.new(0.98,0,0,36); stopBtn.Position = UDim2.new(0.01,0,0,60)
stopBtn.Text = "STOP Auto Summit"; stopBtn.Font = Enum.Font.GothamBold; stopBtn.TextSize = 13
stopBtn.BackgroundColor3 = Color3.fromRGB(150,30,30); stopBtn.TextColor3 = Color3.new(1,1,1); stopBtn.ZIndex=62
stopBtn.MouseButton1Click:Connect(stopAuto)

local cpLabel = Instance.new("TextLabel", autoTab)
cpLabel.Size = UDim2.new(0.98,0,0,20); cpLabel.Position = UDim2.new(0.01,0,0,106); cpLabel.BackgroundColor3 = Color3.fromRGB(28,28,28)
cpLabel.Text = "Checkpoint List ("..#checkpoints.." CP)"; cpLabel.Font = Enum.Font.GothamBold; cpLabel.TextSize = 13; cpLabel.TextColor3 = Color3.new(1,1,1)
cpLabel.TextXAlignment = Enum.TextXAlignment.Left; cpLabel.ZIndex=62

local cpFrame = Instance.new("Frame", autoTab)
cpFrame.Size = UDim2.new(0.98,0,1,-150); cpFrame.Position = UDim2.new(0.01,0,0,140); cpFrame.BackgroundColor3 = Color3.fromRGB(28,28,28); cpFrame.BorderSizePixel=0; cpFrame.ZIndex=62

local cpList = Instance.new("ScrollingFrame", cpFrame)
cpList.Size = UDim2.new(1,0,1,0); cpList.CanvasSize = UDim2.new(0,0,#checkpoints*30); cpList.ScrollBarThickness = 6
cpList.BackgroundTransparency = 1; cpList.ZIndex = 62

-- populate cp list
do
    local y = 0
    for i,cp in ipairs(checkpoints) do
        local b = Instance.new("TextButton", cpList)
        b.Size = UDim2.new(1,0,0,28); b.Position = UDim2.new(0,0,0,y)
        b.Text = ("#%d: %s"):format(i, cp.name); b.Font = Enum.Font.Gotham; b.TextSize = 12
        b.TextXAlignment = Enum.TextXAlignment.Left; b.BackgroundColor3 = Color3.fromRGB(42,42,42); b.TextColor3 = Color3.new(1,1,1); b.BorderSizePixel=0; b.ZIndex=62
        b.MouseButton1Click:Connect(function()
            if player.Character and player.Character.PrimaryPart and typeof(cp.pos) == "Vector3" then
                pcall(function() player.Character:SetPrimaryPartCFrame(CFrame.new(cp.pos)) end)
                notify("Teleported to CP #"..i..": "..cp.name, Color3.fromRGB(120,160,255))
                stopAuto()
            end
        end)
        y = y + 30
    end
end

-- SETTING tab content (toggles + slider)
do
    local y = 8
    local function makeBtn(text, ypos)
        local b = Instance.new("TextButton", settingTab)
        b.Size = UDim2.new(0.48,0,0,36); b.Position = UDim2.new((ypos%2==0) and 0.01 or 0.51, 0, 0, 8 + math.floor(ypos/2)*46)
        b.Text = text; b.Font = Enum.Font.GothamBold; b.TextSize = 13; b.TextColor3 = Color3.new(1,1,1)
        b.BackgroundColor3 = Color3.fromRGB(60,60,60); b.BorderSizePixel=0; b.ZIndex=62
        return b
    end

    local idx = 0
    local btnAutoRepeat = makeBtn("Auto Repeat: OFF", idx); idx = idx + 1
    local btnAutoDeath = makeBtn("Auto Death: OFF", idx); idx = idx + 1
    local btnServerHop = makeBtn("Server Hop: OFF", idx); idx = idx + 1
    local btnAntiAFK = makeBtn("Anti-AFK: OFF", idx); idx = idx + 1

    btnAutoRepeat.MouseButton1Click:Connect(function()
        autoRepeat = not autoRepeat
        btnAutoRepeat.Text = "Auto Repeat: "..(autoRepeat and "ON" or "OFF")
        btnAutoRepeat.BackgroundColor3 = autoRepeat and Color3.fromRGB(0,150,200) or Color3.fromRGB(60,60,60)
    end)
    btnAutoDeath.MouseButton1Click:Connect(function()
        autoDeath = not autoDeath
        btnAutoDeath.Text = "Auto Death: "..(autoDeath and "ON" or "OFF")
        btnAutoDeath.BackgroundColor3 = autoDeath and Color3.fromRGB(0,150,200) or Color3.fromRGB(60,60,60)
    end)
    btnServerHop.MouseButton1Click:Connect(function()
        serverHop = not serverHop
        btnServerHop.Text = "Server Hop: "..(serverHop and "ON" or "OFF")
        btnServerHop.BackgroundColor3 = serverHop and Color3.fromRGB(200,100,0) or Color3.fromRGB(60,60,60)
    end)
    btnAntiAFK.MouseButton1Click:Connect(function()
        toggleAntiAFK(not antiAFK)
        btnAntiAFK.Text = "Anti-AFK: "..(antiAFK and "ON" or "OFF")
        btnAntiAFK.BackgroundColor3 = antiAFK and Color3.fromRGB(0,150,100) or Color3.fromRGB(60,60,60)
    end)

    -- TextBoxes: delay, walkspeed, limit
    local function makeBox(labelText, xpos, ypos, value)
        local box = Instance.new("TextBox", settingTab)
        box.Size = UDim2.new(0.48,0,0,36); box.Position = UDim2.new(xpos,0,0, 8 + ypos)
        box.Text = labelText..": "..tostring(value); box.Font = Enum.Font.GothamBold; box.TextSize = 13
        box.BackgroundColor3 = Color3.fromRGB(45,45,45); box.TextColor3 = Color3.new(1,1,1); box.ClearTextOnFocus=false; box.ZIndex=62
        return box
    end

    local delayBox = makeBox("Delay (s)", 0.01, 184, delayTime)
    local speedBox = makeBox("WalkSpeed", 0.51, 184, walkSpeed)
    local limitBox = makeBox("Hop Limit", 0.01, 230, summitLimit)

    delayBox.FocusLost:Connect(function(enter)
        if enter then
            local v = tonumber(delayBox.Text:match("(%d+%.?%d*)") or delayBox.Text)
            if v and v >= 0.5 then delayTime = v; delayBox.Text = "Delay (s): "..delayTime; notify("Delay set: "..delayTime, Color3.fromRGB(255,165,0))
            else notify("Delay invalid (min 0.5)", Color3.fromRGB(255,60,60)) end
        end
    end)
    speedBox.FocusLost:Connect(function(enter)
        if enter then
            local v = tonumber(speedBox.Text:match("(%d+%.?%d*)") or speedBox.Text)
            if v and v >= 1 then walkSpeed = v; speedBox.Text = "WalkSpeed: "..walkSpeed
                if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then player.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = walkSpeed end
                notify("WalkSpeed set: "..walkSpeed, Color3.fromRGB(255,165,0))
            else notify("Speed invalid", Color3.fromRGB(255,60,60)) end
        end
    end)
    limitBox.FocusLost:Connect(function(enter)
        if enter then
            local v = tonumber(limitBox.Text:match("(%d+%.?%d*)") or limitBox.Text)
            if v and v >= 1 then summitLimit = v; limitBox.Text = "Hop Limit: "..summitLimit; notify("Hop limit set: "..summitLimit, Color3.fromRGB(255,165,0))
            else notify("Limit invalid", Color3.fromRGB(255,60,60)) end
        end
    end)

    -- TRANSPARENCY SLIDER (track + knob)
    local sliderLabel = Instance.new("TextLabel", settingTab)
    sliderLabel.Size = UDim2.new(0.98,0,0,18); sliderLabel.Position = UDim2.new(0.01,0,0,280)
    sliderLabel.BackgroundTransparency = 1; sliderLabel.Text = "GUI Transparency"; sliderLabel.Font = Enum.Font.GothamBold; sliderLabel.TextSize = 13; sliderLabel.TextColor3 = Color3.new(1,1,1); sliderLabel.TextXAlignment = Enum.TextXAlignment.Left; sliderLabel.ZIndex=62

    local track = Instance.new("Frame", settingTab)
    track.Size = UDim2.new(0.9,0,0,10); track.Position = UDim2.new(0.05,0,0,305); track.BackgroundColor3 = Color3.fromRGB(70,70,70); track.BorderSizePixel=0; track.ZIndex=62
    local knob = Instance.new("ImageButton", track)
    knob.Size = UDim2.new(0,18,0,18); knob.Position = UDim2.new(0, -9, 0.5, -9); knob.BackgroundColor3 = Color3.fromRGB(200,200,200); knob.BorderSizePixel=0; knob.ZIndex=63; knob.AutoButtonColor = false

    local currentTransparency = 0.12 -- default
    local function applyTransparency(v)
        -- v in [0,0.9] where 0 = opaque (BgTransparency=0), 0.9 => BgTransparency=0.9
        local clamped = math.clamp(v, 0, 0.9)
        currentTransparency = clamped
        -- apply to main background-type elements
        local bgList = {main, tabPanel, content, cpFrame, cpList, delayBox, speedBox, limitBox}
        for _,ui in ipairs(bgList) do
            if ui and ui:IsA("Instance") and ui.BackgroundColor3 then
                ui.BackgroundTransparency = clamped
            end
        end
        notify(("Transparency: %.2f"):format(clamped), Color3.fromRGB(200,200,80))
    end

    -- draggable knob
    local dragging = false
    knob.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end
    end)
    knob.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
    track.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local absPos = UserInputService:GetMouseLocation()
            local trackAbs = track.AbsolutePosition.X
            local rel = math.clamp((absPos.X - trackAbs) / track.AbsoluteSize.X, 0, 1)
            knob.Position = UDim2.new(rel, -9, 0.5, -9)
            local transpar = rel * 0.9
            applyTransparency(transpar)
        end
    end)
    -- init knob pos
    do
        local rel = currentTransparency / 0.9
        knob.Position = UDim2.new(rel, -9, 0.5, -9)
        applyTransparency(currentTransparency)
    end
end

-- INFO tab
do
    local y = 8
    local function addInfo(txt)
        local l = Instance.new("TextLabel", infoTab)
        l.Size = UDim2.new(0.98,0,0,20); l.Position = UDim2.new(0.01,0,0,y)
        l.BackgroundTransparency = 1; l.Text = txt; l.Font = Enum.Font.GothamBold; l.TextSize = 13; l.TextColor3 = Color3.new(1,1,1); l.TextXAlignment = Enum.TextXAlignment.Left; l.ZIndex=62
        y = y + 24
        return l
    end
    addInfo("Map Aktif: "..scriptName)
    local cpCount = addInfo("Total CP: "..#checkpoints)
    local currCp = addInfo("Current CP Index: #"..currentCpIndex)
    local summ = addInfo("Summit berhasil: "..summitCount)
    RunService.Heartbeat:Connect(function()
        cpCount.Text = "Total CP: "..#checkpoints
        currCp.Text = "Current CP Index: #"..math.min(currentCpIndex, #checkpoints)
        summ.Text = "Summit berhasil: "..summitCount
    end)
end

-- SERVER tab
do
    local y = 8
    local function serverBtn(text, color, fn)
        local b = Instance.new("TextButton", serverTab)
        b.Size = UDim2.new(0.98,0,0,36); b.Position = UDim2.new(0.01,0,0,y)
        b.Text = text; b.Font = Enum.Font.GothamBold; b.TextSize = 13; b.BackgroundColor3 = color; b.TextColor3 = Color3.new(1,1,1); b.BorderSizePixel=0; b.ZIndex=62
        b.MouseButton1Click:Connect(fn)
        y = y + 46
        return b
    end
    serverBtn("Teleport ke Basecamp", Color3.fromRGB(150,60,150), function()
        local base = checkpoints[1]
        if base and player.Character and player.Character.PrimaryPart and typeof(base.pos) == "Vector3" then
            pcall(function() player.Character:SetPrimaryPartCFrame(CFrame.new(base.pos)) end)
            notify("Teleported to Basecamp", Color3.fromRGB(200,150,255)); stopAuto()
        end
    end)
    serverBtn("Forced Server Hop", Color3.fromRGB(0,110,200), doServerHop)
end

-- hide/close handlers
local isHidden = false
local preservedSize, preservedPos = main.Size, main.Position
btnHide.MouseButton1Click:Connect(function()
    if not isHidden then
        preservedSize = main.Size; preservedPos = main.Position
        main.Size = UDim2.new(main.Size.X.Scale, main.Size.X.Offset, 0, HEADER_H)
        -- hide children except header
        for _,c in ipairs(main:GetChildren()) do
            if c ~= header then c.Visible = false end
        end
        btnHide.Text = "Show"
        isHidden = true
    else
        main.Size = preservedSize or UDim2.new(0,MAIN_W,0,MAIN_H)
        main.Position = preservedPos or main.Position
        for _,c in ipairs(main:GetChildren()) do c.Visible = true end
        header.Visible = true
        btnHide.Text = "Hide"
        isHidden = false
    end
end)
btnClose.MouseButton1Click:Connect(function()
    toggleAntiAFK(false); stopAuto()
    pcall(function() gui:Destroy() end)
end)

-- init values / small safety
if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
    player.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = walkSpeed
end
player.CharacterAdded:Connect(function(c) local h = c:WaitForChild("Humanoid",5); if h then h.WalkSpeed = walkSpeed end end)

notify("UniversalV37 Loaded. Map: "..scriptName, Color3.fromRGB(0,200,100))
