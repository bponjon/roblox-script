-- UNIVERSAL AUTO SUMMIT V37 - FINAL (Compact, Hide-fixed, Transparency slider)
-- Paste langsung. Uses MAP_CONFIG (provided by user) and auto-detects map by PlaceId.

local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local ok, playerGui = pcall(function() return player:WaitForChild("PlayerGui",5) end)
if not ok or not playerGui then warn("PlayerGui not ready. Abort."); return end

local CURRENT_PLACE_ID = tostring(game.PlaceId)

-- MAP_CONFIG (use the data you provided)
local MAP_CONFIG = {
["94261028489288"] = {name="KOHARU", checkpoints = {
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
["140014177882408"] = {name="GEMI", checkpoints = {
{name="Basecamp", pos=Vector3.new(1269.030, 639.076, 1793.997)},
{name="Puncak", pos=Vector3.new(-6665.046, 3151.532, -799.116)}
}},
["127557455707420"] = {name="JALUR", checkpoints = {
{name="Basecamp", pos=Vector3.new(-942.227, 14.021, -954.444)},
{name="CP1", pos=Vector3.new(-451.266, 78.021, -662.000)},
{name="CP2", pos=Vector3.new(-484.121, 78.015, 119.971)},
{name="CP3", pos=Vector3.new(576.478, 242.021, 852.784)},
{name="CP4", pos=Vector3.new(779.530, 606.021, -898.384)},
{name="CP5", pos=Vector3.new(-363.401, 1086.021, 705.354)},
{name="Puncak", pos=Vector3.new(292.418, 1274.021, 374.069)}
}},
["79272087242323"] = {name="LIRVANA", checkpoints = {
{name="CP0", pos=Vector3.new(-33.023, 86.149, 7.025)},{name="CP1", pos=Vector3.new(35.501,200.700,-559.027)},
{name="CP2", pos=Vector3.new(-381.037,316.700,-560.712)},{name="CP3", pos=Vector3.new(-401.126,456.700,-1014.478)},
{name="CP4", pos=Vector3.new(-35.014,548.700,-1028.476)},{name="CP5", pos=Vector3.new(-50.832,542.149,-1371.412)},
{name="CP6", pos=Vector3.new(-68.830,582.149,-1615.556)},{name="CP7", pos=Vector3.new(262.292,610.149,-1647.285)},
{name="CP8", pos=Vector3.new(270.919,678.149,-1378.510)},{name="CP9", pos=Vector3.new(278.914,622.149,-1025.756)},
{name="CP10", pos=Vector3.new(292.020,638.149,-676.378)},{name="CP11", pos=Vector3.new(601.175,678.149,-680.490)},
{name="CP12", pos=Vector3.new(617.442,626.149,-1028.689)},{name="CP13", pos=Vector3.new(600.942,678.149,-1370.222)},
{name="CP14", pos=Vector3.new(594.054,670.149,-1626.474)},{name="CP15", pos=Vector3.new(917.511,690.149,-1644.750)},
{name="CP16", pos=Vector3.new(899.131,702.149,-1362.030)},{name="CP17", pos=Vector3.new(971.016,674.149,-941.262)},
{name="CP18", pos=Vector3.new(880.015,710.149,-675.175)},{name="CP19", pos=Vector3.new(1187.287,694.149,-661.098)},
{name="CP20", pos=Vector3.new(1187.453,718.149,-332.297)},{name="Puncak", pos=Vector3.new(799.696,1001.949,207.303)}
}},
["129916920179384"] = {name="AHPAYAH", checkpoints = {
{name="Basecamp", pos=Vector3.new(-405.208,46.021,-540.538)},{name="CP1", pos=Vector3.new(-397.862,46.386,-225.315)},
{name="CP2", pos=Vector3.new(446.973,310.386,-454.457)},{name="CP3", pos=Vector3.new(389.741,415.219,-38.504)},
{name="CP4", pos=Vector3.new(228.787,358.386,420.735)},{name="CP5", pos=Vector3.new(-248.196,546.015,537.969)},
{name="CP6", pos=Vector3.new(-707.398,478.386,471.019)},{name="CP7", pos=Vector3.new(-823.563,598.903,-193.940)},
{name="CP8", pos=Vector3.new(-1539.058,682.267,-643.505)},{name="CP9", pos=Vector3.new(-1581.844,650.396,448.762)},
{name="CP10", pos=Vector3.new(-2566.289,662.396,450.378)},{name="Puncak", pos=Vector3.new(-2921.433,844.065,18.757)}
}},
["111417482709154"] = {name="BINGUNG", checkpoints = {
{name="Basecamp", pos=Vector3.new(166.00293,14.9578,822.9834)},{name="CP1", pos=Vector3.new(198.238098,10.1375217,128.423187)},
{name="CP2", pos=Vector3.new(228.194977,128.879974,-211.192383)},{name="CP3", pos=Vector3.new(231.817947,146.768204,-558.723816)},
{name="CP4", pos=Vector3.new(340.004669,132.319489,-987.244446)},{name="CP5", pos=Vector3.new(393.582062,119.624352,-1415.08472)},
{name="CP6", pos=Vector3.new(344.682739,190.306702,-2695.90625)},{name="CP7", pos=Vector3.new(353.37085,243.564514,-3065.35181)},
{name="CP8", pos=Vector3.new(-1.62862873,259.373474,-3431.15869)},{name="CP9", pos=Vector3.new(54.7402382,373.025543,-3835.73633)},
{name="CP10", pos=Vector3.new(-347.480225,505.230347,-4970.26514)},{name="CP11", pos=Vector3.new(-841.818359,506.035736,-4984.36621)},
{name="CP12", pos=Vector3.new(-825.191345,571.779053,-5727.79297)},{name="CP13", pos=Vector3.new(-831.682068,575.300842,-6424.26855)},
{name="CP14", pos=Vector3.new(-288.520508,661.583984,-6804.15234)},{name="CP15", pos=Vector3.new(675.513794,743.510742,-7249.33496)},
{name="CP16", pos=Vector3.new(816.311768,833.685852,-7606.22998)},{name="CP17", pos=Vector3.new(805.29248,821.01062,-8516.9082)},
{name="CP18", pos=Vector3.new(473.562775,879.063538,-8585.45312)},{name="CP19", pos=Vector3.new(268.831238,897.108215,-8576.44922)},
{name="CP20", pos=Vector3.new(285.314331,933.954651,-8983.91992)},{name="Puncak", pos=Vector3.new(107.141029,988.262573,-9015.23145)}
}},
["76084648389385"] = {name="TENERIE", checkpoints = {
{name="Basecamp", pos=Vector3.new(24.996,163.296,319.838)},{name="CP1", pos=Vector3.new(24.996,163.296,319.838)},
{name="CP2", pos=Vector3.new(-830.715,239.184,887.750)},{name="CP3", pos=Vector3.new(-1081.016,400.153,1662.579)},
{name="CP4", pos=Vector3.new(-638.603,659.233,3034.486)},{name="CP5", pos=Vector3.new(339.759,820.852,3891.180)},
{name="Puncak", pos=Vector3.new(878.573,1019.189,4704.508)}
}},
}

local currentMapConfig = MAP_CONFIG[CURRENT_PLACE_ID]
local scriptName = currentMapConfig and currentMapConfig.name or "UNIVERSAL"
local checkpoints = currentMapConfig and currentMapConfig.checkpoints or {}

-- state
local autoSummit, autoDeath, serverHop, autoRepeat, antiAFK = false,false,false,false,false
local summitCount, summitLimit, delayTime, walkSpeed = 0, 5, 5, 16
local currentCpIndex = 1
local summitThread, antiAFKThread = nil, nil

-- helper notify (safe)
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
        n.ZIndex = 200
        game:GetService("Debris"):AddItem(n,2)
    end)
end

-- safety: if map not found, still create GUI but show message & empty checkpoints
if not currentMapConfig or #checkpoints == 0 then
    notify("Map ID "..CURRENT_PLACE_ID.." tidak dikenali. GUI berjalan (no cp).", Color3.fromRGB(200,80,80))
end

-- nearest cp finder (robust)
local function findNearestCheckpoint()
    local char = player.Character or player.CharacterAdded:Wait()
    local root = char:FindFirstChild("HumanoidRootPart") or char:WaitForChild("HumanoidRootPart",5)
    if not root then return 1 end
    local pos = root.Position
    local ni, md = 1, math.huge
    for i,cp in ipairs(checkpoints) do
        if cp.pos and typeof(cp.pos) == "Vector3" then
            local d = (Vector3.new(pos.X,0,pos.Z) - Vector3.new(cp.pos.X,0,cp.pos.Z)).Magnitude
            if d < md then md, ni = d, i end
        end
    end
    if md > 300 and ni ~= #checkpoints then return 1 end
    if md < 50 and ni < #checkpoints then return ni + 1 end
    return ni
end

-- antiAFK simple
local function toggleAntiAFK(state)
    antiAFK = state
    if antiAFK and not antiAFKThread then
        notify("Anti-AFK ON", Color3.fromRGB(0,200,0))
        antiAFKThread = task.spawn(function()
            while antiAFK do
                pcall(function()
                    local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
                    if humanoid then humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end
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

-- server hop
local function doServerHop()
    notify("Server Hop...", Color3.fromRGB(0,140,220))
    pcall(function() TeleportService:Teleport(game.PlaceId, player) end)
    autoSummit = false
end

-- stop/start auto
local function stopAuto()
    if summitThread then task.cancel(summitThread); summitThread=nil end
    autoSummit=false
    local nextCp = math.min(currentCpIndex, #checkpoints)
    notify("Auto stopped. Next CP #"..nextCp..(checkpoints[nextCp] and (": "..checkpoints[nextCp].name) or ""), Color3.fromRGB(255,165,0))
end

local function startAuto()
    if autoSummit then return end
    autoSummit = true
    currentCpIndex = findNearestCheckpoint()
    local startIndex = currentCpIndex
    notify("Auto start from CP #"..startIndex..(checkpoints[startIndex] and (": "..checkpoints[startIndex].name) or ""), Color3.fromRGB(0,150,255))
    summitThread = task.spawn(function()
        while autoSummit do
            if serverHop and summitCount >= (summitLimit or 5) then doServerHop(); break end
            local completed = true
            for i = startIndex, #checkpoints do
                if not autoSummit then currentCpIndex = i; completed=false; break end
                local cp = checkpoints[i]
                local char = player.Character or player.CharacterAdded:Wait()
                if char and char.PrimaryPart and cp and typeof(cp.pos)=="Vector3" then
                    pcall(function() char:SetPrimaryPartCFrame(CFrame.new(cp.pos)) end)
                    notify("CP "..i.." -> "..cp.name, Color3.fromRGB(0,255,120))
                else
                    notify("Skip CP "..i, Color3.fromRGB(255,80,80))
                end
                currentCpIndex = i+1
                if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
                    player.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = walkSpeed
                end
                task.wait(delayTime)
            end
            if completed then
                summitCount = summitCount + 1
                currentCpIndex = 1
                if autoRepeat then
                    notify("Summit #"..summitCount.." done. AutoRepeat ON", Color3.fromRGB(0,255,100))
                    if autoDeath then
                        task.wait(0.5); pcall(function() if player.Character then player.Character:BreakJoints() end end)
                        player.CharacterAdded:Wait(); task.wait(1.2)
                    else
                        if player.Character and player.Character.PrimaryPart and checkpoints[1] and checkpoints[1].pos then
                            pcall(function() player.Character:SetPrimaryPartCFrame(CFrame.new(checkpoints[1].pos)) end)
                        end
                        task.wait(delayTime)
                    end
                else
                    notify("Summit #"..summitCount.." complete. Stopped.", Color3.fromRGB(0,255,100))
                    autoSummit=false; break
                end
            end
            if not autoRepeat and completed then break end
            startIndex = 1
        end
        summitThread = nil
        if not autoSummit then notify("Auto finished/paused.", Color3.fromRGB(255,165,0)) end
    end)
end

-- GUI: compact, neat, default dark + blue accents (not purple). Small font for settings.
if playerGui:FindFirstChild("UniversalV37") then playerGui.UniversalV37:Destroy() end
local gui = Instance.new("ScreenGui", playerGui); gui.Name="UniversalV37"; gui.ResetOnSpawn=false; gui.ZIndexBehavior = Enum.ZIndexBehavior.Global

local MAIN_W, MAIN_H = 700, 400
local HEADER_H = 30
local main = Instance.new("Frame", gui); main.Name="Main"; main.Size=UDim2.new(0,MAIN_W,0,MAIN_H); main.Position=UDim2.new(0.5,-MAIN_W/2,0.18,0)
main.BackgroundColor3 = Color3.fromRGB(22,22,22); main.BorderSizePixel=0; main.Active=true; main.Draggable=true; main.ZIndex=50
local header = Instance.new("Frame", main); header.Size=UDim2.new(1,0,0,HEADER_H); header.Position=UDim2.new(0,0,0,0); header.BackgroundColor3=Color3.fromRGB(30,30,30); header.ZIndex=60

local title = Instance.new("TextLabel", header); title.Size=UDim2.new(1,-160,1,0); title.Position=UDim2.new(0,6,0,0)
title.BackgroundTransparency=1; title.TextColor3=Color3.new(1,1,1); title.Font=Enum.Font.GothamBold; title.Text = "UniversalV37 - "..scriptName
title.TextXAlignment = Enum.TextXAlignment.Left; title.TextScaled=false; title.TextSize=16; title.ZIndex=61

local hideBtn = Instance.new("TextButton", header); hideBtn.Size=UDim2.new(0,60,1,0); hideBtn.Position=UDim2.new(1,-120,0,0)
hideBtn.Text="Hide"; hideBtn.Font=Enum.Font.GothamBold; hideBtn.TextScaled=false; hideBtn.TextSize=14; hideBtn.BackgroundColor3=Color3.fromRGB(60,60,60); hideBtn.ZIndex=61

local closeBtn = Instance.new("TextButton", header); closeBtn.Size=UDim2.new(0,60,1,0); closeBtn.Position=UDim2.new(1,-60,0,0)
closeBtn.Text="Close"; closeBtn.Font=Enum.Font.GothamBold; closeBtn.TextScaled=false; closeBtn.TextSize=14; closeBtn.BackgroundColor3=Color3.fromRGB(180,40,40); closeBtn.ZIndex=61

local tabPanel = Instance.new("Frame", main); tabPanel.Size=UDim2.new(0,100,1,-HEADER_H); tabPanel.Position=UDim2.new(0,0,0,HEADER_H)
tabPanel.BackgroundColor3=Color3.fromRGB(36,36,36); tabPanel.BorderSizePixel=0; tabPanel.ZIndex=56

local contentArea = Instance.new("Frame", main); contentArea.Size=UDim2.new(1,-100,1,-HEADER_H); contentArea.Position=UDim2.new(0,100,0,HEADER_H)
contentArea.BackgroundColor3=Color3.fromRGB(18,18,18); contentArea.BorderSizePixel=0; contentArea.ZIndex=56

-- tabs
local autoTab = Instance.new("Frame", contentArea); autoTab.Size=UDim2.new(1,0,1,0); autoTab.BackgroundTransparency=1
local settingTab = Instance.new("Frame", contentArea); settingTab.Size=UDim2.new(1,0,1,0); settingTab.BackgroundTransparency=1; settingTab.Visible=false
local infoTab = Instance.new("Frame", contentArea); infoTab.Size=UDim2.new(1,0,1,0); infoTab.BackgroundTransparency=1; infoTab.Visible=false
local serverTab = Instance.new("Frame", contentArea); serverTab.Size=UDim2.new(1,0,1,0); serverTab.BackgroundTransparency=1; serverTab.Visible=false

local function setTab(name, btn)
    autoTab.Visible = (name=="Auto"); settingTab.Visible = (name=="Setting"); infoTab.Visible = (name=="Info"); serverTab.Visible = (name=="Server")
    for _,c in ipairs(tabPanel:GetChildren()) do if c:IsA("TextButton") then c.BackgroundColor3 = Color3.fromRGB(36,36,36); c.TextColor3 = Color3.new(1,1,1) end end
    if btn then btn.BackgroundColor3 = Color3.fromRGB(24,24,24); btn.TextColor3 = Color3.new(1,1,1) end
end

local function makeTab(text, ypos, tabName)
    local b = Instance.new("TextButton", tabPanel); b.Size=UDim2.new(1,0,0,50); b.Position=UDim2.new(0,0,0,ypos)
    b.Text=text; b.Font=Enum.Font.GothamBold; b.TextScaled=false; b.TextSize=14; b.BackgroundColor3=Color3.fromRGB(36,36,36); b.TextColor3=Color3.new(1,1,1); b.BorderSizePixel=0; b.ZIndex=57
    b.MouseButton1Click:Connect(function() setTab(tabName, b) end)
    return b
end

local btnAuto = makeTab("Auto", 0, "Auto"); local btnSet = makeTab("Setting",50,"Setting"); local btnInfo = makeTab("Info",100,"Info"); local btnServer = makeTab("Server",150,"Server")
setTab("Auto", btnAuto)

-- AUTO tab content
local btnStart = Instance.new("TextButton", autoTab); btnStart.Size=UDim2.new(0.98,0,0,44); btnStart.Position=UDim2.new(0.01,0,0,8)
btnStart.Text="START Auto Summit"; btnStart.Font=Enum.Font.GothamBold; btnStart.TextScaled=false; btnStart.TextSize=14
btnStart.BackgroundColor3=Color3.fromRGB(0,140,220); btnStart.ZIndex=56
btnStart.MouseButton1Click:Connect(startAuto)

local btnStop = Instance.new("TextButton", autoTab); btnStop.Size=UDim2.new(0.98,0,0,40); btnStop.Position=UDim2.new(0.01,0,0,58)
btnStop.Text="STOP Auto Summit"; btnStop.Font=Enum.Font.GothamBold; btnStop.TextScaled=false; btnStop.TextSize=14
btnStop.BackgroundColor3=Color3.fromRGB(160,40,40); btnStop.ZIndex=56
btnStop.MouseButton1Click:Connect(stopAuto)

local cpLabel = Instance.new("TextLabel", autoTab); cpLabel.Size=UDim2.new(0.98,0,0,20); cpLabel.Position=UDim2.new(0.01,0,0,108)
cpLabel.BackgroundColor3=Color3.fromRGB(28,28,28); cpLabel.Text = "Checkpoint List ("..#checkpoints.." CP)"; cpLabel.Font=Enum.Font.GothamBold; cpLabel.TextScaled=false; cpLabel.TextSize=14; cpLabel.TextXAlignment=Enum.TextXAlignment.Left; cpLabel.ZIndex=56

local cpFrame = Instance.new("Frame", autoTab); cpFrame.Size=UDim2.new(0.98,0,1,-146); cpFrame.Position=UDim2.new(0.01,0,0,138); cpFrame.BackgroundColor3=Color3.fromRGB(28,28,28); cpFrame.ZIndex=56
local cpList = Instance.new("ScrollingFrame", cpFrame); cpList.Size=UDim2.new(1,0,1,0); cpList.CanvasSize=UDim2.new(0,0, math.max(1,#checkpoints)*30); cpList.ScrollBarThickness=6; cpList.BackgroundTransparency=1; cpList.ZIndex=56

local y = 0
for i,cp in ipairs(checkpoints) do
    local b = Instance.new("TextButton", cpList)
    b.Size = UDim2.new(1,0,0,28); b.Position = UDim2.new(0,0,0,y)
    b.Text = "#" .. i .. ": " .. cp.name; b.Font = Enum.Font.Gotham; b.TextScaled=false; b.TextSize=13
    b.TextXAlignment = Enum.TextXAlignment.Left; b.BackgroundColor3 = Color3.fromRGB(40,40,40)
    b.BorderSizePixel=0; b.ZIndex=56
    b.MouseButton1Click:Connect(function()
        if player.Character and player.Character.PrimaryPart and typeof(cp.pos)=="Vector3" then
            pcall(function() player.Character:SetPrimaryPartCFrame(CFrame.new(cp.pos)) end)
            notify("Teleported to "..cp.name, Color3.fromRGB(120,170,255))
            stopAuto()
        end
    end)
    y = y + 30
end

-- SETTING tab content (smaller fonts, transparency slider)
local sY = 6
local function makeToggle(parent, text, x, yPos, initial)
    local b = Instance.new("TextButton", parent); b.Size=UDim2.new(0.48,0,0,36); b.Position=UDim2.new(x,0,0,yPos)
    b.Text = text..": "..(initial and "ON" or "OFF"); b.Font=Enum.Font.GothamBold; b.TextScaled=false; b.TextSize=13
    b.BackgroundColor3 = initial and Color3.fromRGB(0,140,200) or Color3.fromRGB(64,64,64); b.BorderSizePixel=0; b.ZIndex=56
    return b
end

local autoRepeatBtn = makeToggle(settingTab, "AutoRepeat", 0.01, sY, autoRepeat)
local autoDeathBtn = makeToggle(settingTab, "AutoDeath", 0.51, sY, autoDeath)
local serverHopBtn = makeToggle(settingTab, "ServerHop", 0.01, sY+46, serverHop)
local antiAFKBtn = makeToggle(settingTab, "AntiAFK", 0.51, sY+46, antiAFK)

autoRepeatBtn.MouseButton1Click:Connect(function() autoRepeat = not autoRepeat; autoRepeatBtn.Text = "AutoRepeat: "..(autoRepeat and "ON" or "OFF"); autoRepeatBtn.BackgroundColor3 = autoRepeat and Color3.fromRGB(0,140,200) or Color3.fromRGB(64,64,64) end)
autoDeathBtn.MouseButton1Click:Connect(function() autoDeath = not autoDeath; autoDeathBtn.Text = "AutoDeath: "..(autoDeath and "ON" or "OFF"); autoDeathBtn.BackgroundColor3 = autoDeath and Color3.fromRGB(0,140,200) or Color3.fromRGB(64,64,64) end)
serverHopBtn.MouseButton1Click:Connect(function() serverHop = not serverHop; serverHopBtn.Text = "ServerHop: "..(serverHop and "ON" or "OFF"); serverHopBtn.BackgroundColor3 = serverHop and Color3.fromRGB(200,120,0) or Color3.fromRGB(64,64,64) end)
antiAFKBtn.MouseButton1Click:Connect(function() toggleAntiAFK(not antiAFK); antiAFKBtn.Text = "AntiAFK: "..(antiAFK and "ON" or "OFF"); antiAFKBtn.BackgroundColor3 = antiAFK and Color3.fromRGB(0,140,120) or Color3.fromRGB(64,64,64) end)

-- text boxes smaller
local function makeBox(parent, label, x, yPos, initial)
    local tb = Instance.new("TextBox", parent); tb.Size = UDim2.new(0.48,0,0,36); tb.Position = UDim2.new(x,0,0,yPos)
    tb.Text = label..": "..tostring(initial); tb.Font=Enum.Font.GothamBold; tb.TextScaled=false; tb.TextSize=13
    tb.BackgroundColor3 = Color3.fromRGB(44,44,44); tb.TextColor3 = Color3.new(1,1,1); tb.ClearTextOnFocus = false; tb.ZIndex=56
    return tb
end

local delayBox = makeBox(settingTab, "Delay(s)", 0.01, sY+96, delayTime)
local speedBox = makeBox(settingTab, "WalkSpeed", 0.51, sY+96, walkSpeed)
local limitBox = makeBox(settingTab, "HopLimit", 0.01, sY+146, summitLimit)

delayBox.FocusLost:Connect(function(enter) if enter then local v = tonumber(delayBox.Text:match("(%d+%.?%d*)") or delayBox.Text); if v and v>=0.5 then delayTime=v; notify("Delay = "..delayTime, Color3.fromRGB(255,165,0)) else notify("Delay invalid (min 0.5)", Color3.fromRGB(255,50,50)) end end end)
speedBox.FocusLost:Connect(function(enter) if enter then local v=tonumber(speedBox.Text:match("(%d+%.?%d*)") or speedBox.Text); if v and v>=1 then walkSpeed=v; if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then player.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = walkSpeed end notify("WalkSpeed = "..walkSpeed, Color3.fromRGB(255,165,0)) else notify("Speed invalid", Color3.fromRGB(255,50,50)) end end end)
limitBox.FocusLost:Connect(function(enter) if enter then local v=tonumber(limitBox.Text:match("(%d+%.?%d*)") or limitBox.Text); if v and v>=1 then summitLimit=v; notify("HopLimit = "..summitLimit, Color3.fromRGB(255,165,0)) else notify("Limit invalid", Color3.fromRGB(255,50,50)) end end end)

-- Transparency slider (draggable)
local sliderLabel = Instance.new("TextLabel", settingTab); sliderLabel.Size=UDim2.new(0.98,0,0,18); sliderLabel.Position=UDim2.new(0.01,0,0, sY+206); sliderLabel.BackgroundTransparency=1
sliderLabel.Text = "GUI Transparency (0 = opaque, 1 = invisible)"; sliderLabel.Font=Enum.Font.GothamBold; sliderLabel.TextScaled=false; sliderLabel.TextSize=12; sliderLabel.TextXAlignment=Enum.TextXAlignment.Left; sliderLabel.ZIndex=56

local sliderBar = Instance.new("Frame", settingTab); sliderBar.Size=UDim2.new(0.98,0,0,14); sliderBar.Position=UDim2.new(0.01,0,0,sY+226); sliderBar.BackgroundColor3=Color3.fromRGB(60,60,60); sliderBar.BorderSizePixel=0; sliderBar.ZIndex=56
local knob = Instance.new("Frame", sliderBar); knob.Size=UDim2.new(0,14,1,0); knob.Position=UDim2.new(0.1,0,0,0); knob.BackgroundColor3=Color3.fromRGB(140,140,140); knob.ZIndex=57; knob.AnchorPoint = Vector2.new(0.5,0.5)
knob.Position = UDim2.new(0.1,0,0.5,-7)

local transparencyVal = 0.1 -- default (near solid)
local function setTransparency(v)
    transparencyVal = math.clamp(v, 0, 1)
    main.BackgroundTransparency = transparencyVal
    tabPanel.BackgroundTransparency = transparencyVal
    contentArea.BackgroundTransparency = transparencyVal
    cpFrame.BackgroundTransparency = transparencyVal
    cpList.BackgroundTransparency = transparencyVal
end
setTransparency(transparencyVal)
-- knob drag logic
local dragging = false
local function updateKnob(inputPosX)
    local relative = math.clamp((inputPosX - sliderBar.AbsolutePosition.X) / sliderBar.AbsoluteSize.X, 0, 1)
    knob.Position = UDim2.new(relative,0,0.5,-7)
    setTransparency(relative)
end
knob.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true; UserInputService.MouseIconEnabled = true end
end)
UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        updateKnob(input.Position.X)
    end
end)
sliderBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then updateKnob(input.Position.X) end
end)

-- INFO tab
local infoY = 6
local function addInfo(txt)
    local l = Instance.new("TextLabel", infoTab); l.Size=UDim2.new(0.98,0,0,20); l.Position=UDim2.new(0.01,0,0,infoY)
    l.BackgroundTransparency = 1; l.TextColor3 = Color3.new(1,1,1); l.Font = Enum.Font.GothamBold; l.TextScaled = false; l.TextSize = 13; l.Text = txt; l.TextXAlignment = Enum.TextXAlignment.Left; l.ZIndex = 56
    infoY = infoY + 22; return l
end
addInfo("Map Aktif: "..scriptName)
local cpCountLabel = addInfo("Total CP: "..#checkpoints)
local currCpLabel = addInfo("Current CP Index: #"..currentCpIndex)
local summitLabel = addInfo("Summit sukses: "..summitCount)
RunService.Heartbeat:Connect(function()
    cpCountLabel.Text = "Total CP: "..#checkpoints
    currCpLabel.Text = "Current CP Index: #"..math.min(currentCpIndex,#checkpoints)
    summitLabel.Text = "Summit sukses: "..summitCount
end)

-- SERVER tab
local function serverBtn(text, color, func)
    local b = Instance.new("TextButton", serverTab); b.Size=UDim2.new(0.98,0,0,42); b.Position=UDim2.new(0.01,0,0, 10 + (#serverTab:GetChildren()*50))
    b.Text = text; b.BackgroundColor3 = color; b.Font = Enum.Font.GothamBold; b.TextScaled=false; b.TextSize=14; b.TextColor3 = Color3.new(1,1,1); b.BorderSizePixel=0; b.ZIndex=56
    b.MouseButton1Click:Connect(func); return b
end
serverBtn("Teleport Basecamp", Color3.fromRGB(140,40,200), function()
    local base = checkpoints[1]
    if base and player.Character and player.Character.PrimaryPart and typeof(base.pos)=="Vector3" then pcall(function() player.Character:SetPrimaryPartCFrame(CFrame.new(base.pos)) end); notify("Teleported basecamp", Color3.fromRGB(200,150,255)); stopAuto() end
end)
serverBtn("Forced Server Hop", Color3.fromRGB(0,100,200), doServerHop)

-- HIDE fix: keep header visible (shrink main to header)
local isHidden=false
local savedSize, savedPos = main.Size, main.Position
hideBtn.MouseButton1Click:Connect(function()
    if not isHidden then
        savedSize, savedPos = main.Size, main.Position
        main.Size = UDim2.new(main.Size.X.Scale, main.Size.X.Offset, 0, HEADER_H)
        -- hide children except header
        for _,c in ipairs(main:GetChildren()) do if c ~= header then c.Visible = false end end
        hideBtn.Text = "Show"; isHidden = true
    else
        main.Size = savedSize or UDim2.new(0,MAIN_W,0,MAIN_H)
        main.Position = savedPos or main.Position
        for _,c in ipairs(main:GetChildren()) do c.Visible = true end
        hideBtn.Text = "Hide"; isHidden = false
    end
end)

closeBtn.MouseButton1Click:Connect(function()
    toggleAntiAFK(false); stopAuto()
    pcall(function() gui:Destroy() end)
end)

-- ensure default walkSpeed
if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then player.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = walkSpeed end
player.CharacterAdded:Connect(function(c) local h = c:WaitForChild("Humanoid",5); if h then h.WalkSpeed = walkSpeed end end)

-- initial notification
notify("UniversalV37 loaded. Map: "..scriptName, Color3.fromRGB(0,200,100))

-- small UX: left-click focal buttons for toggles update text (already handled). Done.
