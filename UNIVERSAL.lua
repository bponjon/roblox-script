--// UNIVERSAL AUTO SUMMIT GUI V27 (STRUKTUR LINEAR V14 + FIXES) //--

-- Variabel global untuk memaksa inisialisasi di awal (Mengatasi nil value error di lingkungan V14)
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local CURRENT_PLACE_ID = tostring(game.PlaceId)

-- **********************************
-- ***** KONFIGURASI MAP GLOBAL (Data Lengkap) *****
-- **********************************
local MAP_CONFIG = {
    -- MOUNT KOHARU (21 CP)
    ["94261028489288"] = {name = "MOUNT KOHARU (21 CP)", 
        checkpoints = {
            {name="Basecamp", pos=Vector3.new(-883.288,43.358,933.698)}, {name="CP1", pos=Vector3.new(-473.240,49.167,624.194)},
            {name="CP2", pos=Vector3.new(-182.927,52.412,691.074)}, {name="CP3", pos=Vector3.new(122.499,202.548,951.741)},
            {name="CP4", pos=Vector3.new(10.684,194.377,340.400)}, {name="CP5", pos=Vector3.new(244.394,194.369,805.065)},
            {name="CP6", pos=Vector3.new(660.531,210.886,749.360)}, {name="CP7", pos=Vector3.new(660.649,202.965,368.070)},
            {name="CP8", pos=Vector3.new(520.852,214.338,281.842)}, {name="CP9", pos=Vector3.new(523.730,214.369,-333.936)},
            {name="CP10", pos=Vector3.new(561.610,211.787,-559.470)}, {name="CP11", pos=Vector3.new(566.837,282.541,-924.107)},
            {name="CP12", pos=Vector3.new(115.198,286.309,-655.635)}, {name="CP13", pos=Vector3.new(-308.343,410.144,-612.031)},
            {name="CP14", pos=Vector3.new(-487.722,522.666,-663.426)}, {name="CP15", pos=Vector3.new(-679.093,482.701,-971.988)},
            {name="CP16", pos=Vector3.new(-559.058,258.369,-1318.780)}, {name="CP17", pos=Vector3.new(-426.353,374.369,-1512.621)},
            {name="CP18", pos=Vector3.new(-984.797,635.003,-1621.875)}, {name="CP19", pos=Vector3.new(-1394.228,797.455,-1563.855)},
            {name="Puncak", pos=Vector3.new(-1534.938,933.116,-2176.096)}
        }
    },
    -- MOUNT GEMI (2 CP)
    ["140014177882408"] = {name = "MOUNT GEMI (2 CP)", 
        checkpoints = {
            {name="Basecamp", pos=Vector3.new(1269.030, 639.076, 1793.997)},
            {name="Puncak", pos=Vector3.new(-6665.046, 3151.532, -799.116)}
        }
    },
    -- MOUNT JALUR TAKDIR (7 CP)
    ["127557455707420"] = {name = "MOUNT JALUR TAKDIR (7 CP)", 
        checkpoints = {
            {name="Basecamp", pos=Vector3.new(-942.227, 14.021, -954.444)}, {name="Checkpoint 1", pos=Vector3.new(-451.266, 78.021, -662.000)},
            {name="Checkpoint 2", pos=Vector3.new(-484.121, 78.015, 119.971)}, {name="Checkpoint 3", pos=Vector3.new(576.478, 242.021, 852.784)},
            {name="Checkpoint 4", pos=Vector3.new(779.530, 606.021, -898.384)}, {name="Checkpoint 5", pos=Vector3.new(-363.401, 1086.021, 705.354)},
            {name="Puncak", pos=Vector3.new(292.418, 1274.021, 374.069)}
        }
    },
    -- MOUNT LIRVANA (22 CP)
    ["79272087242323"] = {name = "MOUNT LIRVANA (22 CP)", 
        checkpoints = {
            {name="CP0", pos=Vector3.new(-33.023, 86.149, 7.025)}, {name="CP1", pos=Vector3.new(35.501, 200.700, -559.027)}, 
            {name="CP2", pos=Vector3.new(-381.037, 316.700, -560.712)}, {name="CP3", pos=Vector3.new(-401.126, 456.700, -1014.478)},
            {name="CP4", pos=Vector3.new(-35.014, 548.700, -1028.476)}, {name="CP5", pos=Vector3.new(-50.832, 542.149, -1371.412)},
            {name="CP6", pos=Vector3.new(-68.830, 582.149, -1615.556)}, {name="CP7", pos=Vector3.new(262.292, 610.149, -1647.285)},
            {name="CP8", pos=Vector3.new(270.919, 678.149, -1378.510)}, {name="CP9", pos=Vector3.new(278.914, 622.149, -1025.756)},
            {name="CP10", pos=Vector3.new(292.020, 638.149, -676.378)}, {name="CP11", pos=Vector3.new(601.175, 678.149, -680.490)},
            {name="CP12", pos=Vector3.new(617.442, 626.149, -1028.689)}, {name="CP13", pos=Vector3.new(600.942, 678.149, -1370.222)},
            {name="CP14", pos=Vector3.new(594.054, 670.149, -1626.474)}, {name="CP15", pos=Vector3.new(917.511, 690.149, -1644.750)},
            {name="CP16", pos=Vector3.new(899.131, 702.149, -1362.030)}, {name="CP17", pos=Vector3.new(971.016, 674.149, -941.262)},
            {name="CP18", pos=Vector3.new(880.015, 710.149, -675.175)}, {name="CP19", pos=Vector3.new(1187.287, 694.149, -661.098)},
            {name="CP20", pos=Vector3.new(1187.453, 718.149, -332.297)}, {name="CP21", pos=Vector3.new(799.696, 1001.949, 207.303)}
        }
    },
    -- MOUNT AHPAYAH (12 CP)
    ["129916920179384"] = {name = "MOUNT AHPAYAH (12 CP)", 
        checkpoints = {
            {name="Basecamp", pos=Vector3.new(-405.208, 46.021, -540.538)}, {name="CP1", pos=Vector3.new(-397.862, 46.386, -225.315)},
            {name="CP2", pos=Vector3.new(446.973, 310.386, -454.457)}, {name="CP3", pos=Vector3.new(389.741, 415.219, -38.504)},
            {name="CP4", pos=Vector3.new(228.787, 358.386, 420.735)}, {name="CP5", pos=Vector3.new(-248.196, 546.015, 537.969)},
            {name="CP6", pos=Vector3.new(-707.398, 478.386, 471.019)}, {name="CP7", pos=Vector3.new(-823.563, 598.903, -193.940)},
            {name="CP8", pos=Vector3.new(-1539.058, 682.267, -643.505)}, {name="CP9", pos=Vector3.new(-1581.844, 650.396, 448.762)},
            {name="CP10", pos=Vector3.new(-2566.289, 662.396, 450.378)}, {name="Puncak", pos=Vector3.new(-2921.433, 844.065, 18.757)}
        }
    },
    -- MOUNT BINGUNG (22 CP)
    ["111417482709154"] = {name = "MOUNT BINGUNG (22 CP)", 
        checkpoints = {
            {name="Basecamp", pos=Vector3.new(166.00293,14.9578,822.9834)}, {name="CP1", pos=Vector3.new(198.238098,10.1375217,128.423187)},
            {name="CP2", pos=Vector3.new(228.194977,128.879974,-211.192383)}, {name="CP3", pos=Vector3.new(231.817947,146.768204,-558.723816)},
            {name="CP4", pos=Vector3.new(340.004669,132.319489,-987.244446)}, {name="CP5", pos=Vector3.new(393.582062,119.624352,-1415.08472)},
            {name="CP6", pos=Vector3.new(344.682739,190.306702,-2695.90625)}, {name="CP7", pos=Vector3.new(353.37085,243.564514,-3065.35181)},
            {name="CP8", pos=Vector3.new(-1.62862873,259.373474,-3431.15869)}, {name="CP9", pos=Vector3.new(54.7402382,373.025543,-3835.73633)},
            {name="CP10", pos=Vector3.new(-347.480225,505.230347,-4970.26514)}, {name="CP11", pos=Vector3.new(-841.818359,506.035736,-4984.36621)},
            {name="CP12", pos=Vector3.new(-825.191345,571.779053,-5727.79297)}, {name="CP13", pos=Vector3.new(-831.682068,575.300842,-6424.26855)},
            {name="CP14", pos=Vector3.new(-288.520508,661.583984,-6804.15234)}, {name="CP15", pos=Vector3.new(675.513794,743.510742,-7249.33496)},
            {name="CP16", pos=Vector3.new(816.311768,833.685852,-7606.22998)}, {name="CP17", pos=Vector3.new(805.29248,821.01062,-8516.9082)},
            {name="CP18", pos=Vector3.new(473.562775,879.063538,-8585.45312)}, {name="CP19", pos=Vector3.new(268.831238,897.108215,-8576.44922)},
            {name="CP20", pos=Vector3.new(285.314331,933.954651,-8983.91992)}, {name="Puncak", pos=Vector3.new(107.141029,988.262573,-9015.23145)}
        }
    },
    -- MOUNT TENERIE (6 CP - Menggunakan CFrame)
    ["76084648389385"] = {name = "MOUNT TENERIE (6 CP)", 
        checkpoints = {
            {name="CP1", pos=CFrame.new(24.996, 163.296, 319.838, -0.997991, 0.024712, -0.058331, -0.000000, 0.920780, 0.390083, 0.063350, 0.389299, -0.918930)},
            {name="CP2", pos=CFrame.new(-830.715, 239.184, 887.750, -0.972382, -0.073546, 0.221503, -0.000009, 0.949065, 0.315080, -0.233393, 0.306376, -0.922855)},
            {name="CP3", pos=CFrame.new(-1081.016, 400.153, 1662.579, -0.685627, 0.345798, -0.640578, 0.000000, 0.879971, 0.475027, 0.727953, 0.325691, -0.603332)},
            {name="CP4", pos=CFrame.new(-638.603, 659.233, 3034.486, -0.840349, 0.156491, -0.518964, -0.000000, 0.957418, 0.288705, 0.542045, 0.242613, -0.804566)},
            {name="CP5", pos=CFrame.new(339.759, 820.852, 3891.180, 0.120165, 0.220135, -0.968040, -0.000000, 0.975105, 0.221742, 0.992754, -0.026646, 0.117173)},
            {name="Puncak", pos=CFrame.new(878.573, 1019.189, 4704.508, 0.005409, 0.375075, -0.926979, 0.000348, 0.926992, 0.375082, 0.999985, -0.002352, 0.004884)}
        }
    },
}
-- **********************************

local currentMapConfig = MAP_CONFIG[CURRENT_PLACE_ID]
local scriptName = currentMapConfig and currentMapConfig.name or "UNIVERSAL (Map Tidak Dikenal)"
local checkpoints = currentMapConfig and currentMapConfig.checkpoints or {}

-- Variabel Status & Fitur
local autoSummit, autoDeath, serverHop, autoRepeat, antiAFK = false, false, false, false, false
local summitCount, summitLimit, delayTime, walkSpeed = 0, 20, 5, 16
local currentCpIndex = 1 
local summitThread = nil
local antiAFKThread = nil 

-- FUNGSI UMUM NOTIFIKASI
local function notify(txt, color)
    pcall(function()
        local n = Instance.new("TextLabel", playerGui)
        n.Size = UDim2.new(0,400,0,35)
        n.Position = UDim2.new(0.5,-200,0.05,0)
        n.BackgroundColor3 = color or Color3.fromRGB(30,30,30)
        n.TextColor3 = Color3.new(1,1,1)
        n.Font = Enum.Font.GothamBold
        n.TextScaled = true
        n.Text = txt
        game:GetService("Debris"):AddItem(n,2)
    end)
end

-- Pengecekan Awal
if not currentMapConfig or #checkpoints == 0 then
    notify("V27 FAILED: Map ID ("..CURRENT_PLACE_ID..") TIDAK ditemukan atau CP kosong.", Color3.fromRGB(255, 0, 0))
    return -- STOP SCRIPT
end

-- LOGIKA PENENTUAN CP TERDEKAT
local function findNearestCheckpoint()
    local character = player.Character or player.CharacterAdded:Wait()
    local rootPart = character:WaitForChild("HumanoidRootPart", 5)
    if not rootPart then return 1 end

    local playerPos = rootPart.Position
    local nearestIndex = 1
    local minDistance = math.huge
    
    for i, cp in ipairs(checkpoints) do
        -- Mendukung Vector3 (pos) dan CFrame (pos.p)
        local cpPos = (type(cp.pos) == "Vector3" and cp.pos) or cp.pos.p
        local cpPosXZ = Vector3.new(cpPos.X, 0, cpPos.Z)
        local playerPosXZ = Vector3.new(playerPos.X, 0, playerPos.Z)
        
        local distance = (playerPosXZ - cpPosXZ).Magnitude 
        if distance < minDistance then
            minDistance = distance
            nearestIndex = i
        end
    end
    
    -- Jika jarak lebih dari 300 stud dari CP terdekat, anggap mulai dari CP 1 (Basecamp), kecuali CP terdekat adalah Puncak
    if minDistance > 300 and nearestIndex ~= #checkpoints then return 1 end
    
    -- Jika sangat dekat dengan CP, maju ke CP berikutnya (kecuali sudah di Puncak)
    if minDistance < 50 and nearestIndex < #checkpoints then return nearestIndex + 1 end
    
    return nearestIndex
end

local function doServerHop()
    notify("Server Hop: Melompat ke server acak...", Color3.fromRGB(0, 100, 200))
    pcall(function() TeleportService:Teleport(game.PlaceId, player) end) 
    autoSummit = false
end

local function toggleAntiAFK(isEnable)
    if isEnable and not antiAFKThread then
        antiAFK = true
        notify("Anti-AFK Aktif", Color3.fromRGB(50, 200, 50))
        antiAFKThread = task.spawn(function()
            while antiAFK do
                local input = Instance.new("InputObject"); input.UserInputType = Enum.UserInputType.MouseButton1
                input.UserInputState = Enum.UserInputState.Begin; input.Position = Vector3.new(50, 50, 0); UserInputService:SimulateMouseClick(input)
                input.UserInputState = Enum.UserInputState.End; UserInputService:SimulateMouseClick(input)
                task.wait(15) 
            end
            antiAFKThread = nil
        end)
    elseif not isEnable and antiAFKThread then
        antiAFK = false
        if antiAFKThread then task.cancel(antiAFKThread) end
        antiAFKThread = nil
        notify("Anti-AFK Nonaktif", Color3.fromRGB(200, 50, 50))
    end
end

-- FUNGSI UTAMA AUTO SUMMIT
local function startAuto()
    if autoSummit then return end
    autoSummit = true
    local startIndex = currentCpIndex
    
    notify("Auto Summit Started! Map: "..scriptName..". Mulai dari CP #"..startIndex..": "..checkpoints[startIndex].name,Color3.fromRGB(0,150,255))
    
    summitThread = task.spawn(function()
        while autoSummit do
            if serverHop and (summitCount >= (summitLimit or 20)) then
                doServerHop()
                autoSummit=false
                break
            end
            
            local isComplete = true
            
            for i = startIndex, #checkpoints do
                local cp = checkpoints[i]
                
                if not autoSummit then currentCpIndex = i; isComplete = false; break end
                
                local character = player.Character or player.CharacterAdded:Wait()
                local rootPart = character:WaitForChild("HumanoidRootPart", 5) 
                
                if rootPart then
                    -- TELEPORTASI FIX (PivotTo, Mendukung Vector3 atau CFrame)
                    local targetCFrame = (type(cp.pos) == "Vector3" and CFrame.new(cp.pos)) or cp.pos
                    character:PivotTo(targetCFrame) 
                    notify("Teleported to CP #"..i..": "..cp.name, Color3.fromRGB(0, 255, 100))
                else
                    notify("Gagal menemukan HumanoidRootPart. Stop Auto.", Color3.fromRGB(255, 50, 50))
                    autoSummit = false; isComplete = false; break
                end
                
                currentCpIndex = i + 1 
                task.wait(delayTime)
            end
            
            if isComplete then
                summitCount+=1
                currentCpIndex = 1
                
                if autoRepeat then
                    notify("Summit #"..summitCount.." Complete. Auto Repeat ON. Restarting...",Color3.fromRGB(0,255,100))
                    
                    if autoDeath then
                        task.wait(0.5)
                        if player.Character then pcall(function() player.Character:BreakJoints() end) end 
                        player.CharacterAdded:Wait()
                        task.wait(1.5)
                    else
                        -- Teleport manual ke Basecamp
                        local character = player.Character or player.CharacterAdded:Wait()
                        if character and character.PrimaryPart then
                            local startPos = (type(checkpoints[1].pos) == "Vector3" and CFrame.new(checkpoints[1].pos)) or checkpoints[1].pos
                            character:PivotTo(startPos)
                        end
                        task.wait(delayTime)
                    end
                else
                    notify("Summit #"..summitCount.." Complete. Auto Repeat OFF. Stopped.",Color3.fromRGB(0,255,100))
                    autoSummit = false; break 
                end
            end
            
            if not autoRepeat and isComplete then break end
            
            -- Set startIndex ke 1 untuk loop berikutnya jika autoRepeat ON
            startIndex = 1 
        end
        summitThread = nil
        
        -- Notifikasi akhir setelah loop selesai
        if not autoSummit then
            local nextCp = math.min(currentCpIndex, #checkpoints)
            local nextCpName = checkpoints[nextCp].name
            notify("Auto Summit Stopped. Siap Lanjut dari CP #"..nextCp..": "..nextCpName, Color3.fromRGB(255,165,0))
        end
    end)
end

local function stopAuto()
    if summitThread then task.cancel(summitThread); summitThread = nil end
    autoSummit = false 
    
    local nextCp = math.min(currentCpIndex, #checkpoints)
    local nextCpName = checkpoints[nextCp].name
    notify("Auto Summit Dihentikan. Siap Lanjut dari CP #"..nextCp..": "..nextCpName, Color3.fromRGB(200,50,50))
end


-- **********************************
-- ***** INISIALISASI AKHIR DAN EVENT HANDLERS ****
-- **********************************

-- Handle WalkSpeed
player.CharacterAdded:Connect(function(char)
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if humanoid then humanoid.WalkSpeed = walkSpeed end
end)

-- INIT CP INDEX (Dilakukan setelah semua fungsi di atas terdefinisi)
do
    local nearestCp = 1
    if player.Character then
        nearestCp = findNearestCheckpoint()
    else
        player.CharacterAdded:Wait()
        nearestCp = findNearestCheckpoint()
    end
    currentCpIndex = nearestCp
end

if playerGui:FindFirstChild("UniversalV27") then playerGui.UniversalV27:Destroy() end


-- **********************************
-- ***** GUI V27 (Struktur V14) ****
-- **********************************
pcall(function() 

    local gui = Instance.new("ScreenGui", playerGui)
    gui.Name = "UniversalV27" -- Ubah nama GUI
    gui.ResetOnSpawn = false

    local main = Instance.new("Frame", gui)
    main.Size = UDim2.new(0,350,0,550) 
    main.Position = UDim2.new(0.5,-175,0.2,0)
    main.BackgroundColor3 = Color3.fromRGB(15,15,15)
    main.Active = true
    main.Draggable = true

    local header = Instance.new("Frame", main)
    header.Size = UDim2.new(1,0,0,30)
    header.BackgroundColor3 = Color3.fromRGB(40,40,40)

    local title = Instance.new("TextLabel", header)
    title.Text = "Universal Auto GUI V27 - Map: "..scriptName
    title.Size = UDim2.new(1,-50,1,0)
    title.Position = UDim2.new(0,0,0,0)
    title.BackgroundTransparency = 1
    title.TextColor3 = Color3.new(1,1,1)
    title.Font = Enum.Font.GothamBold
    title.TextScaled = true

    local closeBtn = Instance.new("TextButton", header)
    closeBtn.Size = UDim2.new(0,50,1,0)
    closeBtn.Position = UDim2.new(1,-50,0,0)
    closeBtn.Text = "X"
    closeBtn.BackgroundColor3 = Color3.fromRGB(200,50,50)
    closeBtn.TextColor3 = Color3.new(1,1,1)
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.MouseButton1Click:Connect(function() 
        toggleAntiAFK(false) 
        stopAuto()
        gui:Destroy() 
    end)

    local yOffset = 40
    local buttonHeight = 35
    
    -- Function untuk membuat tombol Toggle
    local function createToggle(text, colorOff)
        local btn = Instance.new("TextButton", main)
        btn.Size=UDim2.new(0.9,0,0,buttonHeight)
        btn.Position=UDim2.new(0.05,0,0,yOffset)
        btn.Text=text..": OFF"
        btn.BackgroundColor3=colorOff or Color3.fromRGB(200,0,0)
        btn.TextColor3=Color3.new(1,1,1)
        btn.Font=Enum.Font.GothamBold
        yOffset = yOffset + buttonHeight + 5
        return btn
    end


    -- START/STOP BUTTONS
    local startBtn=Instance.new("TextButton",main)
    startBtn.Size=UDim2.new(0.9,0,0,buttonHeight)
    startBtn.Position=UDim2.new(0.05,0,0,yOffset)
    startBtn.Text="Mulai Auto Summit"
    startBtn.BackgroundColor3=Color3.fromRGB(0,150,0)
    startBtn.TextColor3=Color3.new(1,1,1)
    startBtn.Font=Enum.Font.GothamBold
    startBtn.MouseButton1Click:Connect(startAuto)
    yOffset = yOffset + buttonHeight + 5

    local stopBtn=startBtn:Clone()
    stopBtn.Text="Stop Auto Summit"
    stopBtn.Position=UDim2.new(0.05,0,0,yOffset)
    stopBtn.BackgroundColor3=Color3.fromRGB(150,0,0)
    stopBtn.Parent = main
    stopBtn.MouseButton1Click:Connect(stopAuto)
    yOffset = yOffset + buttonHeight + 5

    -- AUTO REPEAT TOGGLE
    local repeatToggle=createToggle("Auto Repeat", Color3.fromRGB(200,0,0))
    repeatToggle.MouseButton1Click:Connect(function()
        autoRepeat=not autoRepeat
        repeatToggle.Text="Auto Repeat: "..(autoRepeat and "ON" or "OFF")
        repeatToggle.BackgroundColor3=autoRepeat and Color3.fromRGB(0,200,0) or Color3.fromRGB(200,0,0)
    end)

    -- AUTO DEATH TOGGLE
    local deathToggle=createToggle("Auto Death", Color3.fromRGB(50,50,50))
    deathToggle.MouseButton1Click:Connect(function()
        autoDeath=not autoDeath
        deathToggle.Text="Auto Death: "..(autoDeath and "ON" or "OFF")
        deathToggle.BackgroundColor3=autoDeath and Color3.fromRGB(0,100,200) or Color3.fromRGB(50,50,50)
    end)

    -- SERVER HOP TOGGLE
    local serverToggle=createToggle("Server Hop", Color3.fromRGB(200,0,0))
    serverToggle.MouseButton1Click:Connect(function()
        serverHop=not serverHop
        serverToggle.Text="Server Hop: "..(serverHop and "ON" or "OFF")
        serverToggle.BackgroundColor3=serverHop and Color3.fromRGB(0,200,0) or Color3.fromRGB(200,0,0)
    end)

    -- ANTI-AFK TOGGLE
    local afkToggle=createToggle("Anti-AFK", Color3.fromRGB(200,0,0))
    afkToggle.MouseButton1Click:Connect(function()
        toggleAntiAFK(not antiAFK)
        afkToggle.Text="Anti-AFK: "..(antiAFK and "ON" or "OFF")
        afkToggle.BackgroundColor3=antiAFK and Color3.fromRGB(0,200,0) or Color3.fromRGB(200,0,0)
    end)
    yOffset = yOffset + 5 -- Tambahan spasi sebelum TextBoxes

    -- SETTINGS TEXTBOXES
    local function createTextBox(text, defaultValue, focusLostHandler)
        local box = Instance.new("TextBox", main)
        box.Size = UDim2.new(0.9, 0, 0, 25)
        box.Position = UDim2.new(0.05, 0, 0, yOffset)
        box.Text = text..": "..tostring(defaultValue)
        box.PlaceholderText = text
        box.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        box.TextColor3 = Color3.new(1, 1, 1)
        box.Font = Enum.Font.Gotham
        box.TextScaled = true
        box.FocusLost:Connect(function(enterPressed)
            if enterPressed and focusLostHandler then
                focusLostHandler(box)
            else
                box.Text = text..": "..tostring(defaultValue)
            end
        end)
        yOffset = yOffset + 30
        return box
    end

    createTextBox("Delay (detik)", delayTime, function(box)
        local v=tonumber(box.Text)
        if v and v >= 0.5 then 
            delayTime=v 
            box.Text="Delay (detik): "..tostring(delayTime)
            notify("Delay diatur ke "..delayTime.." detik", Color3.fromRGB(255, 165, 0))
        else
            box.Text="Delay (detik): "..tostring(delayTime)
        end
    end)

    createTextBox("WalkSpeed", walkSpeed, function(box)
        local v=tonumber(box.Text)
        if v then
            walkSpeed=v
            box.Text="WalkSpeed: "..tostring(walkSpeed)
            if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
                player.Character.Humanoid.WalkSpeed = walkSpeed
            end
        else
            box.Text="WalkSpeed: "..tostring(walkSpeed)
        end
    end)

    createTextBox("Summit Limit", summitLimit, function(box)
        local v=tonumber(box.Text)
        if v and v >= 1 then 
            summitLimit=v 
            box.Text="Summit Limit: "..tostring(summitLimit)
        else
            box.Text="Summit Limit: "..tostring(summitLimit)
        end
    end)

    -- MANUAL ACTIONS
    yOffset = yOffset + 10
    local manualHop=startBtn:Clone()
    manualHop.Text="Ganti Server Manual"
    manualHop.Position=UDim2.new(0.05,0,0,yOffset)
    manualHop.BackgroundColor3=Color3.fromRGB(80,80,80)
    manualHop.Parent=main
    manualHop.MouseButton1Click:Connect(doServerHop)
    yOffset = yOffset + buttonHeight + 5

    local resetBtn=startBtn:Clone()
    resetBtn.Text="Reset CP Index (Mulai dari CP #1)"
    resetBtn.Position=UDim2.new(0.05,0,0,yOffset)
    resetBtn.BackgroundColor3 = Color3.fromRGB(100,100,0)
    resetBtn.Parent=main
    resetBtn.MouseButton1Click:Connect(function()
        currentCpIndex = 1
        notify("Checkpoint Index Reset ke CP #1: "..checkpoints[1].name, Color3.fromRGB(255,100,0))
    end)
    yOffset = yOffset + buttonHeight + 5


    -- Notifikasi akhir
    local startCpName = checkpoints[currentCpIndex].name

    notify("V27 Loaded! V14 Style Fix. Siap mulai dari CP #"..currentCpIndex..": "..startCpName,Color3.fromRGB(0,200,100))
    
end) -- End pcall for GUI creation
