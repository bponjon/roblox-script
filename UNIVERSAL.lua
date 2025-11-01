--// BYNZZBPONJON //--
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local CURRENT_PLACE_ID = tostring(game.PlaceId)

-- **********************************
-- ***** KONFIGURASI MAP GLOBAL (TIDAK BERUBAH DARI V31) *****
-- **********************************
local MAP_CONFIG = {
    -- MOUNT KOHARU (21 CP)
    ["94261028489288"] = {name = "MOUNT KOHARU (21 CP)", 
        checkpoints = {
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
            {name="Basecamp", pos=Vector3.new(-942.227, 14.021, -954.444)}, 
            {name="Checkpoint 1", pos=Vector3.new(-451.266, 78.021, -662.000)},
            {name="Checkpoint 2", pos=Vector3.new(-484.121, 78.015, 119.971)},
            {name="Checkpoint 3", pos=Vector3.new(576.478, 242.021, 852.784)},
            {name="Checkpoint 4", pos=Vector3.new(779.530, 606.021, -898.384)},
            {name="Checkpoint 5", pos=Vector3.new(-363.401, 1086.021, 705.354)},
            {name="Puncak", pos=Vector3.new(292.418, 1274.021, 374.069)}
        }
    },
    -- MOUNT LIRVANA (22 CP)
    ["79272087242323"] = {name = "MOUNT LIRVANA (22 CP)", 
        checkpoints = {
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
            {name="Checkpoint 21", pos=Vector3.new(799.696, 1001.949, 207.303)}
        }
    },
    -- MOUNT AHPAYAH (12 CP)
    ["129916920179384"] = {name = "MOUNT AHPAYAH (12 CP)", 
        checkpoints = {
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
        }
    },
    -- MOUNT BINGUNG (22 CP)
    ["111417482709154"] = {name = "MOUNT BINGUNG (22 CP)", 
        checkpoints = {
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
        }
    },
    -- MOUNT TENERIE (6 CP - Vector3)
    ["76084648389385"] = {name = "MOUNT TENERIE (6 CP)", 
        checkpoints = {
            {name="Checkpoint 1", pos=Vector3.new(24.996, 163.296, 319.838)},
            {name="Checkpoint 2", pos=Vector3.new(-830.715, 239.184, 887.750)},
            {name="Checkpoint 3", pos=Vector3.new(-1081.016, 400.153, 1662.579)},
            {name="Checkpoint 4", pos=Vector3.new(-638.603, 659.233, 3034.486)},
            {name="Checkpoint 5", pos=Vector3.new(339.759, 820.852, 3891.180)},
            {name="Puncak", pos=Vector3.new(878.573, 1019.189, 4704.508)}
        }
    },
}
-- **********************************

local currentMapConfig = MAP_CONFIG[CURRENT_PLACE_ID]
local scriptName = currentMapConfig and currentMapConfig.name or "UNIVERSAL (Map Tdk Dikenal)"
local checkpoints = currentMapConfig and currentMapConfig.checkpoints or {}

-- Variabel Status
local autoSummit, autoDeath, serverHop, autoRepeat, antiAFK = false, false, false, false, false
local summitCount, summitLimit, delayTime, walkSpeed = 0, 20, 5, 16 
local currentCpIndex = 1 
local summitThread = nil
local antiAFKThread = nil 

-- (Logika Fungsi [notify, findNearestCheckpoint, toggleAntiAFK, doServerHop, stopAuto, startAuto] TIDAK BERUBAH DARI V31)
-- **********************************
-- ***** DEKLARASI FUNGSI GLOBAL (COPY PASTE DARI V31 DI SINI) ****
-- **********************************

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

-- PENGECEKAN AWAL 
if not currentMapConfig or #checkpoints == 0 then
    notify("V32 FAILED: Map ID ("..CURRENT_PLACE_ID..") TIDAK ditemukan.", Color3.fromRGB(255, 0, 0))
    return 
end

local function findNearestCheckpoint()
    local character = player.Character or player.CharacterAdded:Wait()
    local rootPart = character:WaitForChild("HumanoidRootPart", 5)
    if not rootPart then return 1 end
    local playerPos = rootPart.Position
    
    local nearestIndex = 1
    local minDistance = math.huge
    
    for i, cp in ipairs(checkpoints) do
        local cpPos = (typeof(cp.pos) == "Vector3" and cp.pos) or cp.pos.p 
        
        local cpPosXZ = Vector3.new(cpPos.X, 0, cpPos.Z)
        local playerPosXZ = Vector3.new(playerPos.X, 0, playerPos.Z)
        local distance = (playerPosXZ - cpPosXZ).Magnitude
        
        if distance < minDistance then
            minDistance = distance
            nearestIndex = i
        end
    end
    
    if minDistance > 300 and nearestIndex ~= #checkpoints then return 1 end
    
    if minDistance < 50 and nearestIndex < #checkpoints then
        return nearestIndex + 1
    end
    
    return nearestIndex
end

local function toggleAntiAFK(isEnable)
    local textBox = playerGui.UniversalV32.Main.TabMenu.SettingTab:FindFirstChild("AntiAFK_Text")
    
    if isEnable and not antiAFKThread then
        antiAFK = true
        notify("Anti-AFK Aktif", Color3.fromRGB(50, 200, 50))
        if textBox then textBox.Text = "Anti-AFK: ON" end
        antiAFKThread = task.spawn(function()
            while antiAFK do
                local input = Instance.new("InputObject")
                input.UserInputType = Enum.UserInputType.MouseButton1
                input.UserInputState = Enum.UserInputState.Begin
                input.Position = Vector3.new(50, 50, 0)
                UserInputService:SimulateMouseClick(input)
                
                input.UserInputState = Enum.UserInputState.End
                UserInputService:SimulateMouseClick(input)
                
                task.wait(15) 
            end
            antiAFKThread = nil
        end)
    elseif not isEnable and antiAFKThread then
        antiAFK = false
        if antiAFKThread then task.cancel(antiAFKThread) end
        antiAFKThread = nil
        notify("Anti-AFK Nonaktif", Color3.fromRGB(200, 50, 50))
        if textBox then textBox.Text = "Anti-AFK: OFF" end
    end
end

local function doServerHop()
    notify("Server Hop: Melompat ke server acak...", Color3.fromRGB(0, 100, 200))
    pcall(function() TeleportService:Teleport(game.PlaceId, player) end) 
    autoSummit = false
end

local function stopAuto()
    if summitThread then task.cancel(summitThread); summitThread = nil end
    autoSummit = false 
    
    local nextCp = math.min(currentCpIndex, #checkpoints)
    local nextCpName = checkpoints[nextCp].name
    notify("Auto Summit Dihentikan. Siap Lanjut dari CP #"..nextCp..": "..nextCpName, Color3.fromRGB(255,165,0)) 
end

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
                if character and character.PrimaryPart then
                    
                    local targetCFrame
                    if typeof(cp.pos) == "Vector3" then
                        targetCFrame = CFrame.new(cp.pos)
                    elseif typeof(cp.pos) == "CFrame" then
                        targetCFrame = cp.pos
                    end
                    
                    if targetCFrame then
                        character:SetPrimaryPartCFrame(targetCFrame) 
                        notify("Teleported to CP #"..i..": "..cp.name, Color3.fromRGB(0, 255, 100))
                    else
                        notify("Data CP #"..i.." error (bukan Vector3 atau CFrame).", Color3.fromRGB(255, 50, 50))
                    end
                else
                    notify("Gagal menemukan karakter. Stop Auto.", Color3.fromRGB(255, 50, 50))
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
                        local character = player.Character or player.CharacterAdded:Wait()
                        if character and character.PrimaryPart then
                            local startCFrame
                            if typeof(checkpoints[1].pos) == "Vector3" then
                                startCFrame = CFrame.new(checkpoints[1].pos)
                            elseif typeof(checkpoints[1].pos) == "CFrame" then
                                startCFrame = checkpoints[1].pos
                            end
                            character:SetPrimaryPartCFrame(startCFrame)
                        end
                        task.wait(delayTime)
                    end
                else
                    notify("Summit #"..summitCount.." Complete. Auto Repeat OFF. Stopped.",Color3.fromRGB(0,255,100))
                    autoSummit = false; break 
                end
            end
            
            if not autoRepeat and isComplete then break end
            startIndex = 1 
        end 
        summitThread = nil
        
        if not autoSummit then
            local nextCp = math.min(currentCpIndex, #checkpoints)
            local nextCpName = checkpoints[nextCp].name
            notify("Auto Summit Stopped. Siap Lanjut dari CP #"..nextCp..": "..nextCpName, Color3.fromRGB(255,165,0))
        end
    end)
end
-- **********************************

-- **********************************
-- ***** INIT DAN GUI V32 (Custom Look) ****
-- **********************************

local function initialize()
    if playerGui:FindFirstChild("UniversalV32") then playerGui.UniversalV32:Destroy() end

    -- INIT CURRENT CP INDEX
    if player.Character then
        currentCpIndex = findNearestCheckpoint()
    end
    
    local nextCpName = checkpoints[currentCpIndex].name

    player.CharacterAdded:Connect(function(char)
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if humanoid then humanoid.WalkSpeed = walkSpeed end
    end)
    if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
        player.Character.Humanoid.WalkSpeed = walkSpeed
    end

    notify("V32 Loaded! (FINAL Look). Siap dari CP #"..currentCpIndex..": "..nextCpName,Color3.fromRGB(0,200,100))

    -- ** GUI SETUP **
    local gui = Instance.new("ScreenGui", playerGui)
    gui.Name = "UniversalV32"
    gui.ResetOnSpawn = false

    local main = Instance.new("Frame", gui)
    main.Size = UDim2.new(0,500,0,350) 
    main.Position = UDim2.new(0.5,-250,0.2,0)
    main.BackgroundColor3 = Color3.fromRGB(25,25,25) -- Background gelap
    main.Active = true
    main.Draggable = true

    -- Header
    local header = Instance.new("Frame", main)
    header.Size = UDim2.new(1,0,0,30)
    header.BackgroundColor3 = Color3.fromRGB(40,40,40)

    local title = Instance.new("TextLabel", header)
    title.Text = "Universal Auto Summit V32 - "..scriptName
    title.Size = UDim2.new(1,-60,1,0)
    title.Position = UDim2.new(0,0,0,0)
    title.BackgroundTransparency = 1
    title.TextColor3 = Color3.new(1,1,1)
    title.Font = Enum.Font.GothamBold
    title.TextScaled = true

    local closeBtn = Instance.new("TextButton", header)
    closeBtn.Size = UDim2.new(0,60,1,0)
    closeBtn.Position = UDim2.new(1,-60,0,0)
    closeBtn.Text = "Close"
    closeBtn.BackgroundColor3 = Color3.fromRGB(200,50,50)
    closeBtn.TextColor3 = Color3.new(1,1,1)
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.MouseButton1Click:Connect(function() 
        toggleAntiAFK(false) 
        stopAuto()
        gui:Destroy() 
    end)

    -- Tab Panel Container (Kiri)
    local tabPanel = Instance.new("Frame", main)
    tabPanel.Size = UDim2.new(0.2,0,1,-30) -- 20% lebar, sisa tinggi - header
    tabPanel.Position = UDim2.new(0,0,0,30)
    tabPanel.BackgroundColor3 = Color3.fromRGB(30,30,30)
    
    -- Content Area Container (Kanan)
    local contentArea = Instance.new("Frame", main)
    contentArea.Name = "TabMenu"
    contentArea.Size = UDim2.new(0.8,0,1,-30) -- 80% lebar
    contentArea.Position = UDim2.new(0.2,0,0,30)
    contentArea.BackgroundColor3 = Color3.fromRGB(20,20,20)
    
    -- TAB CONTENT FRAMES
    local autoTab = Instance.new("Frame", contentArea)
    autoTab.Name = "AutoTab"
    autoTab.Size = UDim2.new(1,0,1,0)
    autoTab.BackgroundTransparency = 1
    autoTab.Visible = true
    
    local settingTab = Instance.new("Frame", contentArea)
    settingTab.Name = "SettingTab"
    settingTab.Size = UDim2.new(1,0,1,0)
    settingTab.BackgroundTransparency = 1
    settingTab.Visible = false
    
    local serverTab = Instance.new("Frame", contentArea)
    serverTab.Name = "ServerTab"
    serverTab.Size = UDim2.new(1,0,1,0)
    serverTab.BackgroundTransparency = 1
    serverTab.Visible = false

    -- Fungsi untuk Mengganti Tab
    local function setTab(tabName)
        for _, tab in ipairs({autoTab, settingTab, serverTab}) do
            tab.Visible = (tab.Name == tabName)
        end
    end
    
    -- Fungsi untuk Membuat Tombol Tab
    local tabY = 0
    local function createTabButton(text, tabName)
        local btn = Instance.new("TextButton", tabPanel)
        btn.Size = UDim2.new(1,0,0,35)
        btn.Position = UDim2.new(0,0,0,tabY)
        btn.Text = text
        btn.BackgroundColor3 = Color3.fromRGB(40,40,40)
        btn.TextColor3 = Color3.new(1,1,1)
        btn.Font = Enum.Font.GothamBold
        btn.TextScaled = true
        btn.MouseButton1Click:Connect(function()
            setTab(tabName)
            -- Highlight Tombol
            for _, child in ipairs(tabPanel:GetChildren()) do
                if child:IsA("TextButton") then
                    child.BackgroundColor3 = Color3.fromRGB(40,40,40)
                end
            end
            btn.BackgroundColor3 = Color3.fromRGB(60,60,60)
        end)
        tabY = tabY + 35
        return btn
    end

    -- Inisialisasi Tombol Tab
    local btnAuto = createTabButton("Auto", "AutoTab")
    btnAuto.BackgroundColor3 = Color3.fromRGB(60,60,60) -- Default Active
    createTabButton("Setting", "SettingTab")
    createTabButton("Server", "ServerTab")
    
    -- **********************************
    -- ***** ISI TAB AUTO (Tombol Utama) ****
    -- **********************************
    local autoY = 10
    local function createAutoButton(text, color, onClick)
        local btn = Instance.new("TextButton", autoTab)
        btn.Size = UDim2.new(0.9,0,0,45)
        btn.Position = UDim2.new(0.05,0,0,autoY)
        btn.Text = text
        btn.BackgroundColor3 = color
        btn.TextColor3 = Color3.new(1,1,1)
        btn.Font = Enum.Font.GothamBold
        btn.TextScaled = true
        btn.MouseButton1Click:Connect(onClick)
        autoY = autoY + 50
        return btn
    end

    createAutoButton("MULAI Auto Summit", Color3.fromRGB(0,180,0), startAuto)
    createAutoButton("STOP Auto Summit", Color3.fromRGB(180,0,0), stopAuto)
    
    -- Tombol Checkpoint List (Tampilan Cek CP seperti gambar Anda)
    local cpFrame = Instance.new("Frame", autoTab)
    cpFrame.Size = UDim2.new(0.9,0,1,-autoY)
    cpFrame.Position = UDim2.new(0.05,0,0,autoY)
    cpFrame.BackgroundColor3 = Color3.fromRGB(30,30,30)
    
    local cpList = Instance.new("ScrollingFrame", cpFrame)
    cpList.Size = UDim2.new(1,0,1,-25)
    cpList.BackgroundTransparency = 1
    cpList.CanvasSize = UDim2.new(0,0,0, #checkpoints * 30) -- Tinggi Canvas
    
    local cpTitle = Instance.new("TextLabel", cpFrame)
    cpTitle.Size = UDim2.new(1,0,0,25)
    cpTitle.Text = "Checkpoint List (Total: "..#checkpoints..")"
    cpTitle.BackgroundColor3 = Color3.fromRGB(40,40,40)
    cpTitle.TextColor3 = Color3.new(1,1,1)
    cpTitle.Font = Enum.Font.GothamBold

    local cpY = 0
    for i, cp in ipairs(checkpoints) do
        local cpBtn = Instance.new("TextButton", cpList)
        cpBtn.Size = UDim2.new(1,0,0,28)
        cpBtn.Position = UDim2.new(0,0,0,cpY)
        cpBtn.Text = "#"..i..": "..cp.name
        cpBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
        cpBtn.TextColor3 = Color3.new(1,1,1)
        cpBtn.Font = Enum.Font.Gotham
        cpBtn.TextXAlignment = Enum.TextXAlignment.Left
        cpBtn.TextInsets = Insets.new(5, 0, 0, 0)
        
        -- Logic Teleport Manual Per CP
        cpBtn.MouseButton1Click:Connect(function()
            currentCpIndex = i 
            if player.Character and player.Character.PrimaryPart then
                local targetCFrame
                if typeof(cp.pos) == "Vector3" then
                    targetCFrame = CFrame.new(cp.pos)
                elseif typeof(cp.pos) == "CFrame" then
                    targetCFrame = cp.pos
                end
                player.Character:SetPrimaryPartCFrame(targetCFrame)
                notify("Teleport Manual ke CP #"..i..": "..cp.name, Color3.fromRGB(100, 100, 255))
                stopAuto() -- Pastikan Auto Summit berhenti saat TP manual
            end
        end)
        
        cpY = cpY + 30
    end
    
    -- **********************************
    -- ***** ISI TAB SETTING (Toggles dan Text Input) ****
    -- **********************************
    local settingY = 10
    local function createToggle(text, varRef, colorOn, colorOff, onClick)
        local btn = Instance.new("TextButton", settingTab)
        btn.Name = text:gsub("%s+", ""):gsub(":", "") .. "_Btn"
        btn.Size=UDim2.new(0.9,0,0,35)
        btn.Position=UDim2.new(0.05,0,0,settingY)
        btn.Text=text..": OFF"
        btn.BackgroundColor3=colorOff or Color3.fromRGB(50,50,50)
        btn.TextColor3=Color3.new(1,1,1)
        btn.Font=Enum.Font.GothamBold
        btn.MouseButton1Click:Connect(function()
            local newState = not _G[varRef] -- Ambil state saat ini
            _G[varRef] = newState
            btn.Text=text..": "..(newState and "ON" or "OFF")
            btn.BackgroundColor3=newState and colorOn or colorOff
            if onClick then onClick(newState) end
        end)
        
        -- Gunakan _G[] untuk mengakses variabel lokal di luar fungsi, dan set default.
        _G[varRef] = false 
        
        settingY = settingY + 40
        return btn
    end

    local function createTextBox(text, varRef, isNumber)
        local box = Instance.new("TextBox", settingTab)
        box.Name = text:gsub("%s+", ""):gsub("[^%w_]", "") .. "_Text"
        box.Size = UDim2.new(0.9, 0, 0, 30)
        box.Position = UDim2.new(0.05, 0, 0, settingY)
        
        local defaultValue
        if varRef == "delayTime" then defaultValue = delayTime
        elseif varRef == "walkSpeed" then defaultValue = walkSpeed
        elseif varRef == "summitLimit" then defaultValue = summitLimit end
        
        box.Text = text..": "..tostring(defaultValue)
        box.PlaceholderText = text
        box.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        box.TextColor3 = Color3.new(1, 1, 1)
        box.Font = Enum.Font.Gotham
        box.TextScaled = true
        
        box.FocusLost:Connect(function(enterPressed)
            if enterPressed then
                local v = tonumber(box.Text)
                if isNumber and v then
                    if varRef == "delayTime" and v >= 0.5 then
                        delayTime = v
                        notify("Delay diatur ke "..delayTime.." detik", Color3.fromRGB(255, 165, 0))
                    elseif varRef == "walkSpeed" then
                        walkSpeed = v
                        if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
                            player.Character.Humanoid.WalkSpeed = walkSpeed
                        end
                        notify("WalkSpeed diatur ke "..walkSpeed, Color3.fromRGB(255, 165, 0))
                    elseif varRef == "summitLimit" and v >= 1 then
                        summitLimit = v
                        notify("Summit Limit diatur ke "..summitLimit, Color3.fromRGB(255, 165, 0))
                    end
                end
            end
            local currentValue
            if varRef == "delayTime" then currentValue = delayTime
            elseif varRef == "walkSpeed" then currentValue = walkSpeed
            elseif varRef == "summitLimit" then currentValue = summitLimit end
            box.Text = text..": "..tostring(currentValue)
        end)
        settingY = settingY + 35
        return box
    end
    
    -- Toggles
    createToggle("Auto Repeat", "autoRepeat", Color3.fromRGB(0,200,0), Color3.fromRGB(50,50,50))
    createToggle("Auto Death", "autoDeath", Color3.fromRGB(0,100,200), Color3.fromRGB(50,50,50))
    createToggle("Server Hop", "serverHop", Color3.fromRGB(0,200,0), Color3.fromRGB(50,50,50))
    createToggle("Anti-AFK", "antiAFK", Color3.fromRGB(0,200,0), Color3.fromRGB(50,50,50), toggleAntiAFK)

    -- Text Inputs
    createTextBox("Delay (detik)", "delayTime", true)
    createTextBox("WalkSpeed", "walkSpeed", true)
    createTextBox("Summit Limit", "summitLimit", true)

    -- **********************************
    -- ***** ISI TAB SERVER ****
    -- **********************************
    local serverY = 10
    local function createServerButton(text, color, onClick)
        local btn = Instance.new("TextButton", serverTab)
        btn.Size = UDim2.new(0.9,0,0,45)
        btn.Position = UDim2.new(0.05,0,0,serverY)
        btn.Text = text
        btn.BackgroundColor3 = color
        btn.TextColor3 = Color3.new(1,1,1)
        btn.Font = Enum.Font.GothamBold
        btn.TextScaled = true
        btn.MouseButton1Click:Connect(onClick)
        serverY = serverY + 50
        return btn
    end
    
    createServerButton("Ganti Server Manual", Color3.fromRGB(80,80,80), doServerHop)
    createServerButton("Reset CP Index (Mulai dari CP #1)", Color3.fromRGB(100,100,0), function()
        currentCpIndex = 1
        notify("Checkpoint Index Reset ke CP #1: "..checkpoints[1].name, Color3.fromRGB(255,100,0))
    end)
    
end

-- Panggil inisialisasi dan tunggu karakter dimuat
local charConnection
charConnection = player.CharacterAdded:Connect(function()
    if charConnection then charConnection:Disconnect() end
    initialize()
end)

-- Panggil langsung jika karakter sudah ada
if player.Character then
    if charConnection then charConnection:Disconnect() end
    initialize()
end
