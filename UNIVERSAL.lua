-- UNIVERSAL AUTO SUMMIT --

local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local ok, playerGui = pcall(function() return player:WaitForChild("PlayerGui",5) end)
if not ok or not playerGui then warn("PlayerGui missing"); return end

local CURRENT_PLACE_ID = tostring(game.PlaceId)

-- MAP_CONFIG (use the full map data you provided)
local MAP_CONFIG = {
["94261028489288"]={name="KOHARU",checkpoints={
{name="Basecamp",pos=Vector3.new(-883.288,43.358,933.698)},{name="CP1",pos=Vector3.new(-473.240,49.167,624.194)},
{name="CP2",pos=Vector3.new(-182.927,52.412,691.074)},{name="CP3",pos=Vector3.new(122.499,202.548,951.741)},
{name="CP4",pos=Vector3.new(10.684,194.377,340.400)},{name="CP5",pos=Vector3.new(244.394,194.369,805.065)},
{name="CP6",pos=Vector3.new(660.531,210.886,749.360)},{name="CP7",pos=Vector3.new(660.649,202.965,368.070)},
{name="CP8",pos=Vector3.new(520.852,214.338,281.842)},{name="CP9",pos=Vector3.new(523.730,214.369,-333.936)},
{name="CP10",pos=Vector3.new(561.610,211.787,-559.470)},{name="CP11",pos=Vector3.new(566.837,282.541,-924.107)},
{name="CP12",pos=Vector3.new(115.198,286.309,-655.635)},{name="CP13",pos=Vector3.new(-308.343,410.144,-612.031)},
{name="CP14",pos=Vector3.new(-487.722,522.666,-663.426)},{name="CP15",pos=Vector3.new(-679.093,482.701,-971.988)},
{name="CP16",pos=Vector3.new(-559.058,258.369,-1318.780)},{name="CP17",pos=Vector3.new(-426.353,374.369,-1512.621)},
{name="CP18",pos=Vector3.new(-984.797,635.003,-1621.875)},{name="CP19",pos=Vector3.new(-1394.228,797.455,-1563.855)},
{name="Puncak",pos=Vector3.new(-1534.938,933.116,-2176.096)}
}},
["140014177882408"]={name="GEMI",checkpoints={
{name="Basecamp",pos=Vector3.new(1269.030,639.076,1793.997)},{name="Puncak",pos=Vector3.new(-6665.046,3151.532,-799.116)}
}},
["127557455707420"]={name="JALUR",checkpoints={
{name="Basecamp",pos=Vector3.new(-942.227,14.021,-954.444)},{name="CP1",pos=Vector3.new(-451.266,78.021,-662.000)},
{name="CP2",pos=Vector3.new(-484.121,78.015,119.971)},{name="CP3",pos=Vector3.new(576.478,242.021,852.784)},
{name="CP4",pos=Vector3.new(779.530,606.021,-898.384)},{name="CP5",pos=Vector3.new(-363.401,1086.021,705.354)},
{name="Puncak",pos=Vector3.new(292.418,1274.021,374.069)}
}},
["79272087242323"]={name="LIRVANA",checkpoints={
{name="CP0",pos=Vector3.new(-33.023,86.149,7.025)},{name="CP1",pos=Vector3.new(35.501,200.700,-559.027)},
{name="CP2",pos=Vector3.new(-381.037,316.700,-560.712)},{name="CP3",pos=Vector3.new(-401.126,456.700,-1014.478)},
{name="CP4",pos=Vector3.new(-35.014,548.700,-1028.476)},{name="CP5",pos=Vector3.new(-50.832,542.149,-1371.412)},
{name="CP6",pos=Vector3.new(-68.830,582.149,-1615.556)},{name="CP7",pos=Vector3.new(262.292,610.149,-1647.285)},
{name="CP8",pos=Vector3.new(270.919,678.149,-1378.510)},{name="CP9",pos=Vector3.new(278.914,622.149,-1025.756)},
{name="CP10",pos=Vector3.new(292.020,638.149,-676.378)},{name="CP11",pos=Vector3.new(601.175,678.149,-680.490)},
{name="CP12",pos=Vector3.new(617.442,626.149,-1028.689)},{name="CP13",pos=Vector3.new(600.942,678.149,-1370.222)},
{name="CP14",pos=Vector3.new(594.054,670.149,-1626.474)},{name="CP15",pos=Vector3.new(917.511,690.149,-1644.750)},
{name="CP16",pos=Vector3.new(899.131,702.149,-1362.030)},{name="CP17",pos=Vector3.new(971.016,674.149,-941.262)},
{name="CP18",pos=Vector3.new(880.015,710.149,-675.175)},{name="CP19",pos=Vector3.new(1187.287,694.149,-661.098)},
{name="CP20",pos=Vector3.new(1187.453,718.149,-332.297)},{name="Puncak",pos=Vector3.new(799.696,1001.949,207.303)}
}},
["129916920179384"]={name="AHPAYAH",checkpoints={
{name="Basecamp",pos=Vector3.new(-405.208,46.021,-540.538)},{name="CP1",pos=Vector3.new(-397.862,46.386,-225.315)},
{name="CP2",pos=Vector3.new(446.973,310.386,-454.457)},{name="CP3",pos=Vector3.new(389.741,415.219,-38.504)},
{name="CP4",pos=Vector3.new(228.787,358.386,420.735)},{name="CP5",pos=Vector3.new(-248.196,546.015,537.969)},
{name="CP6",pos=Vector3.new(-707.398,478.386,471.019)},{name="CP7",pos=Vector3.new(-823.563,598.903,-193.940)},
{name="CP8",pos=Vector3.new(-1539.058,682.267,-643.505)},{name="CP9",pos=Vector3.new(-1581.844,650.396,448.762)},
{name="CP10",pos=Vector3.new(-2566.289,662.396,450.378)},{name="Puncak",pos=Vector3.new(-2921.433,844.065,18.757)}
}},
["111417482709154"]={name="BINGUNG",checkpoints={
{name="Basecamp",pos=Vector3.new(166.00293,14.9578,822.9834)},{name="CP1",pos=Vector3.new(198.238098,10.1375217,128.423187)},
{name="CP2",pos=Vector3.new(228.194977,128.879974,-211.192383)},{name="CP3",pos=Vector3.new(231.817947,146.768204,-558.723816)},
{name="CP4",pos=Vector3.new(340.004669,132.319489,-987.244446)},{name="CP5",pos=Vector3.new(393.582062,119.624352,-1415.08472)},
{name="CP6",pos=Vector3.new(344.682739,190.306702,-2695.90625)},{name="CP7",pos=Vector3.new(353.37085,243.564514,-3065.35181)},
{name="CP8",pos=Vector3.new(-1.62862873,259.373474,-3431.15869)},{name="CP9",pos=Vector3.new(54.7402382,373.025543,-3835.73633)},
{name="CP10",pos=Vector3.new(-347.480225,505.230347,-4970.26514)},{name="CP11",pos=Vector3.new(-841.818359,506.035736,-4984.36621)},
{name="CP12",pos=Vector3.new(-825.191345,571.779053,-5727.79297)},{name="CP13",pos=Vector3.new(-831.682068,575.300842,-6424.26855)},
{name="CP14",pos=Vector3.new(-288.520508,661.583984,-6804.15234)},{name="CP15",pos=Vector3.new(675.513794,743.510742,-7249.33496)},
{name="CP16",pos=Vector3.new(816.311768,833.685852,-7606.22998)},{name="CP17",pos=Vector3.new(805.29248,821.01062,-8516.9082)},
{name="CP18",pos=Vector3.new(473.562775,879.063538,-8585.45312)},{name="CP19",pos=Vector3.new(268.831238,897.108215,-8576.44922)},
{name="CP20",pos=Vector3.new(285.314331,933.954651,-8983.91992)},{name="Puncak",pos=Vector3.new(107.141029,988.262573,-9015.23145)}
}},
["76084648389385"]={name="TENERIE",checkpoints={
{name="Basecamp",pos=Vector3.new(24.996,163.296,319.838)},{name="CP1",pos=Vector3.new(24.996,163.296,319.838)},
{name="CP2",pos=Vector3.new(-830.715,239.184,887.750)},{name="CP3",pos=Vector3.new(-1081.016,400.153,1662.579)},
{name="CP4",pos=Vector3.new(-638.603,659.233,3034.486)},{name="CP5",pos=Vector3.new(339.759,820.852,3891.180)},
{name="Puncak",pos=Vector3.new(878.573,1019.189,4704.508)}
}},
["114702582394171"]={name = "MOUNT SANCTUARY (14 CP)",checkpoints = {
{name="Basecamp", pos=Vector3.new(-1058.330, 482.876, 22.816)},
{name="Checkpoint 1", pos=Vector3.new(-907.786, 507.505, 432.683)},
{name="Checkpoint 2", pos=Vector3.new(-645.016, 526.631, 760.042)},
{name="Checkpoint 3", pos=Vector3.new(-260.155, 514.804, 852.550)},
{name="Checkpoint 4", pos=Vector3.new(-643.335, 469.523, -769.794)},
{name="Checkpoint 5", pos=Vector3.new(-231.974, 512.663, -897.238)},
{name="Checkpoint 6", pos=Vector3.new(-9.306, 534.836, -838.912)},
{name="Checkpoint 7", pos=Vector3.new(173.864, 496.479, -535.563)},
{name="Checkpoint 8", pos=Vector3.new(-120.117, 539.087, -655.649)},
{name="Checkpoint 9", pos=Vector3.new(-278.626, 546.659, -676.250)},
{name="Checkpoint 10", pos=Vector3.new(-103.049, 544.814, -398.753)},
{name="Checkpoint 11", pos=Vector3.new(-28.370, 506.116, 573.861)},
{name="Checkpoint 12", pos=Vector3.new(322.179, 532.353, 300.433)},
{name="Checkpoint 13", pos=Vector3.new(942.603, 615.702, -588.890)},
{name="Puncak", pos=Vector3.new(756.920, 934.766, -263.931)}
}},
}

local currentMapConfig = MAP_CONFIG[CURRENT_PLACE_ID]
local scriptName = currentMapConfig and currentMapConfig.name or "UNIVERSAL"
local checkpoints = currentMapConfig and currentMapConfig.checkpoints or {}
if not currentMapConfig or #checkpoints==0 then
    local t=Instance.new("TextLabel",playerGui); t.Size=UDim2.new(0,420,0,36); t.Position=UDim2.new(0.5,-210,0.05,0)
    t.BackgroundColor3=Color3.fromRGB(180,40,40); t.TextColor3=Color3.new(1,1,1); t.Font=Enum.Font.GothamBold; t.TextScaled=true
    t.Text="Map ID "..CURRENT_PLACE_ID.." tidak dikenali. Hentikan."; game:GetService("Debris"):AddItem(t,4)
    return
end

-- state
local autoSummit,autoDeath,serverHop,autoRepeat,antiAFK=false,false,false,false,false
local summitCount,summitLimit,delayTime,walkSpeed=0,5,5,16
local currentCpIndex=1
local summitThread,antiAFKThread=nil,nil

-- small notify util
local function notify(txt,color)
    pcall(function()
        local n=Instance.new("TextLabel",playerGui)
        n.Size=UDim2.new(0,380,0,30); n.Position=UDim2.new(0.5,-190,0.04,0)
        n.BackgroundColor3=color or Color3.fromRGB(30,30,30); n.TextColor3=Color3.new(1,1,1)
        n.Font=Enum.Font.GothamBold; n.TextScaled=false; n.TextSize=14; n.Text=txt; n.ZIndex=120
        game:GetService("Debris"):AddItem(n,2)
    end)
end

-- helper: find nearest cp (resume)
local function findNearestCheckpoint()
    local char = player.Character or player.CharacterAdded:Wait()
    local root = char:FindFirstChild("HumanoidRootPart") or char:WaitForChild("HumanoidRootPart",5)
    if not root then return 1 end
    local p=root.Position
    local nearest,md=1,math.huge
    for i,cp in ipairs(checkpoints) do
        local cpPos=cp.pos
        if cpPos and typeof(cpPos)=="Vector3" then
            local d=(Vector3.new(p.X,0,p.Z)-Vector3.new(cpPos.X,0,cpPos.Z)).Magnitude
            if d<md then md,nearest=d,i end
        end
    end
    if md>300 and nearest~=#checkpoints then return 1 end
    if md<50 and nearest<#checkpoints then return nearest+1 end
    return nearest
end

-- anti AFK simple (jump)
local function toggleAntiAFK(enable)
    antiAFK=enable
    if enable and not antiAFKThread then
        notify("Anti-AFK ON",Color3.fromRGB(0,180,0))
        antiAFKThread=task.spawn(function()
            while antiAFK do
                pcall(function()
                    local h = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
                    if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
                end)
                task.wait(12)
            end
            antiAFKThread=nil
        end)
    elseif not enable and antiAFKThread then
        task.cancel(antiAFKThread); antiAFKThread=nil
        notify("Anti-AFK OFF",Color3.fromRGB(200,60,60))
    end
end

local function doServerHop()
    notify("Server Hop...",Color3.fromRGB(0,120,220))
    pcall(function() TeleportService:Teleport(game.PlaceId,player) end)
    autoSummit=false
end

local function stopAuto()
    if summitThread then task.cancel(summitThread); summitThread=nil end
    autoSummit=false
    local nextCp=math.min(currentCpIndex,#checkpoints)
    notify("Auto stopped. Next CP #"..nextCp..": "..checkpoints[nextCp].name,Color3.fromRGB(255,165,0))
end

local function startAuto()
    if autoSummit then return end
    if not player.Character then notify("No character found",Color3.fromRGB(255,60,60)); return end
    autoSummit=true
    currentCpIndex=findNearestCheckpoint(); local startIndex=currentCpIndex
    notify("Auto start from CP #"..startIndex..": "..checkpoints[startIndex].name,Color3.fromRGB(0,150,255))
    summitThread=task.spawn(function()
        while autoSummit do
            if serverHop and summitCount>=(summitLimit or 5) then doServerHop(); break end
            local completed=true
            for i=startIndex,#checkpoints do
                if not autoSummit then currentCpIndex=i; completed=false; break end
                local char=player.Character or player.CharacterAdded:Wait()
                if char and char.PrimaryPart then
                    local t = checkpoints[i].pos
                    if t and typeof(t)=="Vector3" then
                        pcall(function() char:SetPrimaryPartCFrame(CFrame.new(t)) end)
                        notify("CP "..i..": "..checkpoints[i].name,Color3.fromRGB(0,255,120))
                    else
                        notify("Invalid CP "..i,Color3.fromRGB(255,80,80))
                    end
                else
                    notify("Character missing. Stop.",Color3.fromRGB(255,80,80)); autoSummit=false; completed=false; break
                end
                currentCpIndex=i+1
                local h = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
                if h then h.WalkSpeed=walkSpeed end
                task.wait(delayTime)
            end
            if completed then
                summitCount=summitCount+1; currentCpIndex=1
                if autoRepeat then
                    notify("Summit "..summitCount.." complete. AutoRepeat ON",Color3.fromRGB(0,255,100))
                    if autoDeath then task.wait(0.5); pcall(function() if player.Character then player.Character:BreakJoints() end end); player.CharacterAdded:Wait(); task.wait(1.2)
                    else if player.Character and player.Character.PrimaryPart then pcall(function() player.Character:SetPrimaryPartCFrame(CFrame.new(checkpoints[1].pos)) end) end; task.wait(delayTime) end
                else
                    notify("Summit "..summitCount.." complete. Stopped.",Color3.fromRGB(0,255,100)); autoSummit=false; break
                end
            end
            if not autoRepeat and completed then break end
            startIndex=1
        end
        summitThread=nil
        if not autoSummit then local nextCp=math.min(currentCpIndex,#checkpoints); notify("Stopped. Next CP #"..nextCp..": "..checkpoints[nextCp].name,Color3.fromRGB(255,165,0)) end
    end)
end

-- GUI: remove old
if playerGui:FindFirstChild("UniversalV37") then playerGui.UniversalV37:Destroy() end

local gui = Instance.new("ScreenGui",playerGui); gui.Name="UniversalV37"; gui.ResetOnSpawn=false; gui.ZIndexBehavior=Enum.ZIndexBehavior.Global
local MAIN_FULL=UDim2.new(0,680,0,380); local HEADER=UDim2.new(0,680,0,30); local MAIN_POS=UDim2.new(0.5,-340,0.18,0)

local main = Instance.new("Frame",gui); main.Name="Main"; main.Size=MAIN_FULL; main.Position=MAIN_POS
main.BackgroundColor3=Color3.fromRGB(18,18,18); main.BorderSizePixel=0; main.Active=true; main.Draggable=true; main.ZIndex=100

local header = Instance.new("Frame",main); header.Size=HEADER; header.Position=UDim2.new(0,0,0,0); header.BackgroundColor3=Color3.fromRGB(28,28,28); header.BorderSizePixel=0; header.ZIndex=110
local title = Instance.new("TextLabel",header); title.Text="UniversalV37 - "..scriptName; title.Size=UDim2.new(1,-140,1,0); title.Position=UDim2.new(0,8,0,0)
title.BackgroundTransparency=1; title.TextColor3=Color3.new(1,1,1); title.Font=Enum.Font.Gotham; title.TextScaled=false; title.TextSize=14; title.TextXAlignment=Enum.TextXAlignment.Left; title.ZIndex=111

local hideBtn = Instance.new("TextButton",header); hideBtn.Size=UDim2.new(0,60,1,0); hideBtn.Position=UDim2.new(1,-140,0,0); hideBtn.Text="Hide"; hideBtn.Font=Enum.Font.Gotham; hideBtn.TextSize=14
hideBtn.BackgroundColor3=Color3.fromRGB(90,90,90); hideBtn.TextColor3=Color3.new(1,1,1); hideBtn.ZIndex=111
local closeBtn = Instance.new("TextButton",header); closeBtn.Size=UDim2.new(0,60,1,0); closeBtn.Position=UDim2.new(1,-70,0,0); closeBtn.Text="Close"; closeBtn.Font=Enum.Font.Gotham; closeBtn.TextSize=14
closeBtn.BackgroundColor3=Color3.fromRGB(180,40,40); closeBtn.TextColor3=Color3.new(1,1,1); closeBtn.ZIndex=111

local tabPanel = Instance.new("Frame",main); tabPanel.Size=UDim2.new(0,100,1,-30); tabPanel.Position=UDim2.new(0,0,0,30)
tabPanel.BackgroundColor3=Color3.fromRGB(35,35,35); tabPanel.BorderSizePixel=0; tabPanel.ZIndex=100
local content = Instance.new("Frame",main); content.Size=UDim2.new(1,-100,1,-30); content.Position=UDim2.new(0,100,0,30)
content.BackgroundColor3=Color3.fromRGB(22,22,22); content.BorderSizePixel=0; content.ZIndex=100

-- tabs
local autoTab = Instance.new("Frame",content); autoTab.Size=UDim2.new(1,0,1,0); autoTab.BackgroundTransparency=1
local setTab = Instance.new("Frame",content); setTab.Size=UDim2.new(1,0,1,0); setTab.BackgroundTransparency=1; setTab.Visible=false
local infoTab = Instance.new("Frame",content); infoTab.Size=UDim2.new(1,0,1,0); infoTab.BackgroundTransparency=1; infoTab.Visible=false
local servTab = Instance.new("Frame",content); servTab.Size=UDim2.new(1,0,1,0); servTab.BackgroundTransparency=1; servTab.Visible=false

local function setTabVisible(name,btn)
    autoTab.Visible=(name=="Auto"); setTab.Visible=(name=="Setting"); infoTab.Visible=(name=="Info"); servTab.Visible=(name=="Server")
    for _,c in ipairs(tabPanel:GetChildren()) do if c:IsA("TextButton") then c.BackgroundColor3=Color3.fromRGB(35,35,35) end end
    if btn then btn.BackgroundColor3=Color3.fromRGB(20,20,20) end
end

local function makeTab(text,y,tabName)
    local b=Instance.new("TextButton",tabPanel); b.Size=UDim2.new(1,0,0,50); b.Position=UDim2.new(0,0,0,y); b.Text=text; b.Font=Enum.Font.Gotham; b.TextSize=14
    b.BackgroundColor3=Color3.fromRGB(35,35,35); b.TextColor3=Color3.new(1,1,1); b.ZIndex=101
    b.MouseButton1Click:Connect(function() setTabVisible(tabName,b) end); return b
end

local btnAuto=makeTab("Auto",0,"Auto"); local btnSet=makeTab("Setting",50,"Setting"); local btnInfo=makeTab("Info",100,"Info"); local btnServer=makeTab("Server",150,"Server")
setTabVisible("Auto",btnAuto)

-- Auto Tab: buttons (colored)
local function mkBtn(parent,txt,posY,color,textSize)
    local b=Instance.new("TextButton",parent); b.Size=UDim2.new(0.98,0,0,40); b.Position=UDim2.new(0.01,0,0,posY); b.Text=txt; b.Font=Enum.Font.Gotham; b.TextSize=textSize or 14
    b.BackgroundColor3=color; b.TextColor3=Color3.new(1,1,1); b.BorderSizePixel=0; b.ZIndex=105; return b
end

local startB = mkBtn(autoTab,"Mulai Auto Summit",8,Color3.fromRGB(0,150,0),14); startB.MouseButton1Click:Connect(startAuto)
local stopB = mkBtn(autoTab,"Stop Auto Summit",56,Color3.fromRGB(180,20,20),14); stopB.MouseButton1Click:Connect(stopAuto)

-- CP list
local cpLabel=Instance.new("TextLabel",autoTab); cpLabel.Size=UDim2.new(0.98,0,0,20); cpLabel.Position=UDim2.new(0.01,0,0,108)
cpLabel.Text="Checkpoint List ("..#checkpoints.." CP)"; cpLabel.Font=Enum.Font.Gotham; cpLabel.TextSize=13; cpLabel.BackgroundColor3=Color3.fromRGB(28,28,28); cpLabel.TextColor3=Color3.new(1,1,1); cpLabel.ZIndex=105; cpLabel.TextXAlignment=Enum.TextXAlignment.Left

local cpFrame=Instance.new("Frame",autoTab); cpFrame.Size=UDim2.new(0.98,0,1,-150); cpFrame.Position=UDim2.new(0.01,0,0,140); cpFrame.BackgroundColor3=Color3.fromRGB(28,28,28); cpFrame.BorderSizePixel=0; cpFrame.ZIndex=105
local cpScroll=Instance.new("ScrollingFrame",cpFrame); cpScroll.Size=UDim2.new(1,0,1,0); cpScroll.CanvasSize=UDim2.new(0,0,#checkpoints*30); cpScroll.ScrollBarThickness=6; cpScroll.BackgroundTransparency=1; cpScroll.ZIndex=105

local yy=0
for i,cp in ipairs(checkpoints) do
    local b=Instance.new("TextButton",cpScroll); b.Size=UDim2.new(1,0,0,28); b.Position=UDim2.new(0,0,0,yy)
    b.Text="#"..i..": "..cp.name; b.Font=Enum.Font.SourceSans; b.TextSize=13; b.TextXAlignment=Enum.TextXAlignment.Left
    b.BackgroundColor3=Color3.fromRGB(40,40,40); b.TextColor3=Color3.new(1,1,1); b.BorderSizePixel=0; b.ZIndex=105
    b.MouseButton1Click:Connect(function()
        if player.Character and player.Character.PrimaryPart and cp.pos and typeof(cp.pos)=="Vector3" then
            pcall(function() player.Character:SetPrimaryPartCFrame(CFrame.new(cp.pos)) end)
            notify("Manual TP CP#"..i..": "..cp.name,Color3.fromRGB(100,160,255)); stopAuto()
        end
    end)
    yy=yy+30
end

-- Setting Tab: toggles & boxes & slider transparency
local function mkToggle(txt,x,y,init,callback)
    local b=Instance.new("TextButton",setTab); b.Size=UDim2.new(0.48,0,0,36); b.Position=UDim2.new(x,0,0,y); b.Text=txt..": "..(init and "ON" or "OFF"); b.Font=Enum.Font.Gotham; b.TextSize=13
    b.BackgroundColor3= init and Color3.fromRGB(0,150,200) or Color3.fromRGB(60,60,60); b.TextColor3=Color3.new(1,1,1); b.BorderSizePixel=0; b.ZIndex=105
    b.MouseButton1Click:Connect(function()
        local n=not (string.match(b.Text, "ON") and true or false)
        b.Text=txt..": "..(n and "ON" or "OFF"); b.BackgroundColor3 = n and Color3.fromRGB(0,150,200) or Color3.fromRGB(60,60,60)
        if callback then callback(n) end
    end)
    return b
end

local autoRepeatB = mkToggle("AutoRepeat",0.01,10,autoRepeat,function(v) autoRepeat=v end)
local autoDeathB = mkToggle("AutoDeath",0.01,60,autoDeath,function(v) autoDeath=v end)
local serverHopB = mkToggle("ServerHop",0.51,10,serverHop,function(v) serverHop=v end)
local antiAFKB = mkToggle("AntiAFK",0.51,60,antiAFK,function(v) toggleAntiAFK(v) end)

local function mkBox(txt,x,y,init,onChange)
    local tb=Instance.new("TextBox",setTab); tb.Size=UDim2.new(0.48,0,0,36); tb.Position=UDim2.new(x,0,0,y)
    tb.Font=Enum.Font.Gotham; tb.TextSize=13; tb.BackgroundColor3=Color3.fromRGB(40,40,40); tb.TextColor3=Color3.new(1,1,1)
    tb.Text=txt..": "..tostring(init); tb.ClearTextOnFocus=false; tb.ZIndex=105
    tb.FocusLost:Connect(function(enter)
        if enter then
            local v=tonumber(tb.Text:match("(%-?%d+%.?%d*)") or tb.Text)
            if v then onChange(v) else notify("Input harus angka",Color3.fromRGB(255,60,60)) end
            tb.Text=txt..": "..tostring((v and v) or init)
        end
    end)
    return tb
end

local delayBox = mkBox("Delay(s)",0.01,130,delayTime,function(v) if v>=0.1 then delayTime=v; notify("Delay set "..delayTime,Color3.fromRGB(255,165,0)) else notify("Min delay 0.1",Color3.fromRGB(255,60,60)) end end)
local speedBox = mkBox("WalkSpeed",0.51,130,walkSpeed,function(v) if v>=1 then walkSpeed=v; local h = player.Character and player.Character:FindFirstChildOfClass("Humanoid"); if h then h.WalkSpeed=walkSpeed end; notify("WalkSpeed "..walkSpeed,Color3.fromRGB(255,165,0)) else notify("Speed invalid",Color3.fromRGB(255,60,60)) end end)
local limitBox = mkBox("HopLimit(x)",0.01,180,summitLimit,function(v) if v>=1 then summitLimit=v; notify("HopLimit "..summitLimit,Color3.fromRGB(255,165,0)) end end)

-- transparency slider (draggable) + textbox (unlimited)
local transLabel = Instance.new("TextLabel",setTab); transLabel.Position=UDim2.new(0.01,0,0,230); transLabel.Size=UDim2.new(0.98,0,0,18); transLabel.Text="GUI Transparency (0=solid, >1 allowed)"; transLabel.Font=Enum.Font.Gotham; transLabel.TextSize=12; transLabel.BackgroundTransparency=1; transLabel.TextColor3=Color3.new(1,1,1); transLabel.ZIndex=105

local track = Instance.new("Frame",setTab); track.Position=UDim2.new(0.01,0,0,250); track.Size=UDim2.new(0.7,0,0,14); track.BackgroundColor3=Color3.fromRGB(60,60,60); track.ZIndex=105
local fill = Instance.new("Frame",track); fill.Size=UDim2.new(0.2,0,1,0); fill.BackgroundColor3=Color3.fromRGB(120,120,120); fill.ZIndex=106
local knob = Instance.new("TextButton",track); knob.Size=UDim2.new(0,12,0,14); knob.Position=UDim2.new(0.2,0,0,0); knob.Text=""; knob.BackgroundColor3=Color3.fromRGB(200,200,200); knob.ZIndex=107; knob.AutoButtonColor=false

local transBox = Instance.new("TextBox",setTab); transBox.Size=UDim2.new(0.28,0,0,24); transBox.Position=UDim2.new(0.73,0,0,246); transBox.Text="0.2"; transBox.Font=Enum.Font.Gotham; transBox.TextSize=13; transBox.BackgroundColor3=Color3.fromRGB(40,40,40); transBox.TextColor3=Color3.new(1,1,1); transBox.ClearTextOnFocus=false; transBox.ZIndex=105

local function applyTransparency(v)
    if type(v)~="number" then return end
    -- apply: we define base color dark and set BackgroundTransparency accordingly (clamp 0..1 for visibility but allow >1 meaning fully invisible plus)
    local trans = math.max(0, v)
    -- For simplicity: set content.BackgroundTransparency = min(trans,1) and header keep visible
    content.BackgroundTransparency = math.min(trans,1)
    for _,c in pairs(content:GetDescendants()) do
        if c:IsA("Frame") or c:IsA("TextLabel") or c:IsA("TextButton") or c:IsA("ScrollingFrame") or c:IsA("TextBox") then
            -- preserve buttons colors by only adjusting their BackgroundTransparency if user wants >0
            c.BackgroundTransparency = math.min(trans,0.92)
            if c:IsA("TextLabel") or c:IsA("TextBox") or c:IsA("TextButton") then
                -- adjust text transparency a bit
                if c.TextTransparency then c.TextTransparency = math.min(trans*0.6,0.9) end
            end
        end
    end
end

-- knob drag logic
local dragging=false
local function updateFromX(x)
    local abs = math.clamp(x - track.AbsolutePosition.X, 0, track.AbsoluteSize.X)
    local frac = abs/track.AbsoluteSize.X
    fill.Size = UDim2.new(frac,0,1,0)
    knob.Position = UDim2.new(frac, -6, 0, 0)
    local val = math.floor(frac*100)/100
    transBox.Text = tostring(val)
    applyTransparency(val)
end

knob.InputBegan:Connect(function(input)
    if input.UserInputType==Enum.UserInputType.MouseButton1 then dragging=true end
end)
UserInputService.InputEnded:Connect(function(input) if input.UserInputType==Enum.UserInputType.MouseButton1 then dragging=false end end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType==Enum.UserInputType.MouseMovement then
        updateFromX(input.Position.X)
    end
end)
-- click on track to move
track.InputBegan:Connect(function(input)
    if input.UserInputType==Enum.UserInputType.MouseButton1 then updateFromX(input.Position.X) end
end)

transBox.FocusLost:Connect(function(enter)
    if enter then
        local v=tonumber(transBox.Text)
        if v then
            local frac = math.max(0, math.min(1, v)) -- slider visual limited 0..1
            fill.Size = UDim2.new(frac,0,1,0); knob.Position = UDim2.new(frac,-6,0,0)
            applyTransparency(v)
        else notify("Trans harus angka",Color3.fromRGB(255,60,60)) end
    end
end)

-- Info tab
local yinfo=10
local function addInfo(txt)
    local l=Instance.new("TextLabel",infoTab); l.Size=UDim2.new(0.98,0,0,22); l.Position=UDim2.new(0.01,0,0,yinfo)
    l.BackgroundTransparency=1; l.Text=txt; l.TextColor3=Color3.new(1,1,1); l.Font=Enum.Font.Gotham; l.TextSize=13; l.TextXAlignment=Enum.TextXAlignment.Left; l.ZIndex=105
    yinfo=yinfo+24; return l
end
addInfo("Map: "..scriptName); local totalLabel = addInfo("Total CP: "..#checkpoints)
local curLabel = addInfo("Current CP: #"..currentCpIndex); local sumLabel = addInfo("Summit: "..summitCount)
RunService.Heartbeat:Connect(function() totalLabel.Text="Total CP: "..#checkpoints; curLabel.Text="Current CP: #"..math.min(currentCpIndex,#checkpoints); sumLabel.Text="Summit: "..summitCount end)

-- Server tab: teleport & manual server hop & manual death
local tpBtn = mkBtn(servTab,"Teleport ke Basecamp",10,Color3.fromRGB(40,120,200),13)
tpBtn.MouseButton1Click:Connect(function()
    local base = checkpoints[1]
    if base and player.Character and player.Character.PrimaryPart and typeof(base.pos)=="Vector3" then
        pcall(function() player.Character:SetPrimaryPartCFrame(CFrame.new(base.pos)) end)
        notify("Teleported to Basecamp",Color3.fromRGB(120,160,255)); stopAuto()
    end
end)

local manualHopBtn = mkBtn(servTab,"Manual Server Hop",66,Color3.fromRGB(0,100,200),13)
manualHopBtn.MouseButton1Click:Connect(function() doServerHop() end)

local manualDeathBtn = mkBtn(servTab,"Manual Death",122,Color3.fromRGB(200,50,50),13)
manualDeathBtn.MouseButton1Click:Connect(function()
    if player.Character then pcall(function() player.Character:BreakJoints() end); notify("Manual Death triggered",Color3.fromRGB(255,80,80)) end
end)

-- Hide logic: keep header visible only
local isHidden=false
local saved = {Size = main.Size, Position = main.Position}
hideBtn.MouseButton1Click:Connect(function()
    if not isHidden then
        saved.Size = main.Size; saved.Position = main.Position
        main.Size = UDim2.new(main.Size.X.Scale, main.Size.X.Offset, 0, HEADER.Y.Scale==nil and 30 or 30) -- shrink to header (30px)
        -- hide children except header
        for _,c in ipairs(main:GetChildren()) do if c~=header then c.Visible=false end end
        hideBtn.Text="Show"; isHidden=true
    else
        main.Size = saved.Size or MAIN_FULL; main.Position = saved.Position or MAIN_POS
        for _,c in ipairs(main:GetChildren()) do c.Visible=true end
        header.Visible=true; hideBtn.Text="Hide"; isHidden=false
    end
end)

-- Close
closeBtn.MouseButton1Click:Connect(function() toggleAntiAFK(false); stopAuto(); pcall(function() gui:Destroy() end) end)

-- initial walk speed set
if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then player.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = walkSpeed end
player.CharacterAdded:Connect(function(c) local h = c:WaitForChild("Humanoid",5); if h then h.WalkSpeed=walkSpeed end end)

-- mark small visual tweaks for buttons colors (multi color)
-- ensure buttons already created have intended colors (start/stop done above)
-- final notify
notify("UniversalV37 FINAL loaded for map: "..scriptName, Color3.fromRGB(0,200,100))
