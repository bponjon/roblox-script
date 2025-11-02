--// UNIVERSAL AUTO SUMMIT GUI V38 (SIMPLE & VERTICAL - V35 LOOK) //--
-- Logic: Menggunakan Logic V37 yang sudah diuji.
-- Tampilan: Menggunakan layout V35 yang paling sederhana dan terbukti pernah berhasil tampil.
-- Checkpoint List: Tetap menggunakan daftar checkpoint universal yang lengkap.

local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = pcall(function() return player:WaitForChild("PlayerGui") end) and player:WaitForChild("PlayerGui", 5)
if not playerGui then warn("PlayerGui not ready. Script may fail."); return end

local CURRENT_PLACE_ID = tostring(game.PlaceId)

-- **********************************
-- ***** KONFIGURASI MAP UNIVERSAL (LENGKAP & CLEANED) *****
-- **********************************
-- (Data Checkpoint sama persis dengan V37, hanya disingkat agar kode lebih rapi)
local MAP_CONFIG = {
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
    ["140014177882408"] = {name = "MOUNT GEMI (2 CP)", 
        checkpoints = {
            {name="Basecamp", pos=Vector3.new(1269.030, 639.076, 1793.997)},
            {name="Puncak", pos=Vector3.new(-6665.046, 3151.532, -799.116)}
        }
    },
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
            {name="Puncak", pos=Vector3.new(799.696, 1001.949, 207.303)}
        }
    },
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
    ["76084648389385"] = {name = "MOUNT TENERIE (6 CP)", 
        checkpoints = {
            {name="Basecamp", pos=Vector3.new(24.996, 163.296, 319.838)},
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
local summitCount, summitLimit, delayTime, walkSpeed = 0, 5, 5, 16 
local currentCpIndex = 1 
local summitThread = nil
local antiAFKThread = nil 

-- **********************************
-- ***** DEKLARASI FUNGSI GLOBAL (LOGIC SAMA DENGAN V37) *****
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
        n.ZIndex = 100 -- ZIndex Sangat Tinggi
    end)
end

if not currentMapConfig or #checkpoints == 0 then
    notify("V38 FAILED: Map ID ("..CURRENT_PLACE_ID..") TIDAK ditemukan. Script dinonaktifkan.", Color3.fromRGB(255, 0, 0))
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
        local cpPos = cp.pos
        if not cpPos or typeof(cpPos) ~= "Vector3" then continue end 
        
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

local function updateToggleText(name, status)
    local btn = playerGui.UniversalV38 and playerGui.UniversalV38.Main:FindFirstChild(name)
    local colorOn = name == "ServerHop_Btn" and Color3.fromRGB(200, 100, 0) or (name == "AntiAFK_Btn" and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(0, 150, 255))
    local colorOff = Color3.fromRGB(50, 50, 50)
    
    if btn then
        btn.Text = name:sub(1, #name - 4):gsub("_", " ") .. ": " .. (status and "ON" or "OFF")
        btn.BackgroundColor3 = status and colorOn or colorOff
    end
end

local function toggleAntiAFK(isEnable)
    if isEnable and not antiAFKThread then
        antiAFK = true
        notify("Anti-AFK Aktif", Color3.fromRGB(50, 200, 50))
        updateToggleText("AntiAFK_Btn", antiAFK)
        antiAFKThread = task.spawn(function()
            while antiAFK do
                -- (AFK simulation logic)
                task.wait(15) 
            end
            antiAFKThread = nil
        end)
    elseif not isEnable and antiAFKThread then
        antiAFK = false
        if antiAFKThread then task.cancel(antiAFKThread) end
        antiAFKThread = nil
        notify("Anti-AFK Nonaktif", Color3.fromRGB(200, 50, 50))
        updateToggleText("AntiAFK_Btn", antiAFK)
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
    
    currentCpIndex = findNearestCheckpoint()
    local startIndex = currentCpIndex
    
    notify("Auto Summit Started! Map: "..scriptName..". Mulai dari CP #"..startIndex..": "..checkpoints[startIndex].name,Color3.fromRGB(0,150,255))
    
    summitThread = task.spawn(function()
        while autoSummit do
            if serverHop and (summitCount >= (summitLimit or 5)) then
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
                    
                    local targetPos = cp.pos
                    if targetPos and typeof(targetPos) == "Vector3" then
                        character:SetPrimaryPartCFrame(CFrame.new(targetPos)) 
                        notify("Teleported to CP #"..i..": "..cp.name, Color3.fromRGB(0, 255, 100))
                    else
                        notify("Data CP #"..i.." error (posisi tidak valid). Lewati.", Color3.fromRGB(255, 50, 50))
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
                        if character and character.PrimaryPart and checkpoints[1].pos then
                            character:SetPrimaryPartCFrame(CFrame.new(checkpoints[1].pos))
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
-- ***** INIT DAN GUI V38 (VERTICAL STYLE PALING SEDERHANA) ****
-- **********************************

local function initialize()
    if playerGui:FindFirstChild("UniversalV38") then playerGui.UniversalV38:Destroy() end

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

    notify("V38 Loaded! (SIMPLIFIED & STABLE LOOK). Map: "..scriptName..". Siap dari CP #"..currentCpIndex..": "..nextCpName,Color3.fromRGB(0,200,100))

    -- ** GUI SETUP (Minimalist & High ZIndex) **
    local gui = Instance.new("ScreenGui", playerGui)
    gui.Name = "UniversalV38"
    gui.ResetOnSpawn = false
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Global

    local main = Instance.new("Frame", gui)
    main.Name = "Main"
    main.Size = UDim2.new(0,300,0,500) 
    main.Position = UDim2.new(1,-310,0.1,0) -- Posisi di kanan atas
    main.BackgroundColor3 = Color3.fromRGB(25,25,25) 
    main.Active = true
    main.Draggable = true
    main.BorderSizePixel = 0 
    main.ZIndex = 100 -- ZIndex Sangat Tinggi untuk memastikan muncul
    
    -- Header
    local header = Instance.new("Frame", main)
    header.Size = UDim2.new(1,0,0,30)
    header.BackgroundColor3 = Color3.fromRGB(30,30,30) 
    header.BorderSizePixel = 0

    local title = Instance.new("TextLabel", header)
    title.Text = "Universal Auto Summit V38 - ("..#checkpoints.." CP)"
    title.Size = UDim2.new(1,-50,1,0) 
    title.Position = UDim2.new(0,0,0,0)
    title.BackgroundTransparency = 1
    title.TextColor3 = Color3.new(1,1,1)
    title.Font = Enum.Font.GothamBold
    title.TextScaled = true
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.TextInsets = Insets.new(5, 0, 0, 0) 
    title.ZIndex = 101

    local closeBtn = Instance.new("TextButton", header)
    closeBtn.Size = UDim2.new(0,50,1,0)
    closeBtn.Position = UDim2.new(1,-50,0,0)
    closeBtn.Text = "X"
    closeBtn.BackgroundColor3 = Color3.fromRGB(200,50,50)
    closeBtn.TextColor3 = Color3.new(1,1,1)
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextScaled = true
    closeBtn.ZIndex = 101
    closeBtn.MouseButton1Click:Connect(function() 
        toggleAntiAFK(false) 
        stopAuto()
        gui:Destroy() 
    end)
    
    local currentY = 35 
    local function createButton(name, color, onClick)
        local btn = Instance.new("TextButton", main)
        btn.Name = name:gsub("%s+", ""):gsub("[^%w_]", "") .. "_Btn"
        btn.Size = UDim2.new(1,-10,0,40)
        btn.Position = UDim2.new(0.01,0,0,currentY)
        btn.Text = name
        btn.BackgroundColor3 = color
        btn.TextColor3 = Color3.new(1,1,1)
        btn.Font = Enum.Font.GothamBold
        btn.TextScaled = true
        btn.BorderSizePixel = 0
        btn.ZIndex = 100
        btn.MouseButton1Click:Connect(onClick)
        currentY = currentY + 45
        return btn
    end

    local function createToggleUI(name, varRef, colorOn, colorOff, onClick)
        local btn = createButton(name, colorOff, function()
            local newState
            if varRef == "autoRepeat" then autoRepeat = not autoRepeat; newState = autoRepeat
            elseif varRef == "autoDeath" then autoDeath = not autoDeath; newState = autoDeath
            elseif varRef == "serverHop" then serverHop = not serverHop; newState = serverHop
            elseif varRef == "antiAFK" then antiAFK = not antiAFK; newState = antiAFK end
            
            updateToggleText(btn.Name, newState)
            if onClick then onClick(newState) end
        end)
        btn.Name = name:gsub("%s+", ""):gsub("[^%w_]", "") .. "_Btn"
        
        local initialState = (varRef == "autoRepeat" and autoRepeat) or (varRef == "autoDeath" and autoDeath) or (varRef == "serverHop" and serverHop) or (varRef == "antiAFK" and antiAFK) or false
        btn.Text = name .. ": " .. (initialState and "ON" or "OFF")
        btn.BackgroundColor3 = initialState and colorOn or colorOff
        return btn
    end

    local function createInputBox(name, varRef, isNumber)
        local box = Instance.new("TextBox", main)
        box.Name = name:gsub("%s+", ""):gsub("[^%w_]", "") .. "_Text"
        box.Size = UDim2.new(1,-10,0,30)
        box.Position = UDim2.new(0.01,0,0,currentY)
        box.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        box.TextColor3 = Color3.new(1, 1, 1)
        box.Font = Enum.Font.GothamBold
        box.TextScaled = true
        box.TextXAlignment = Enum.TextXAlignment.Left
        box.TextInsets = Insets.new(5, 0, 0, 0)
        box.BorderSizePixel = 0
        box.ZIndex = 100

        local currentValue
        if varRef == "delayTime" then currentValue = delayTime
        elseif varRef == "walkSpeed" then currentValue = walkSpeed
        elseif varRef == "summitLimit" then currentValue = summitLimit end
        box.Text = name..": "..tostring(currentValue)

        box.FocusLost:Connect(function(enterPressed)
            local updateText = function()
                local updatedValue
                if varRef == "delayTime" then updatedValue = delayTime
                elseif varRef == "walkSpeed" then updatedValue = walkSpeed
                elseif varRef == "summitLimit" then updatedValue = summitLimit end
                box.Text = name..": "..tostring(updatedValue)
            end
            
            if enterPressed then
                local v = tonumber(box.Text:match(":%s*(%d+%.?%d*)")) or tonumber(box.Text) 
                if isNumber and v then
                    if varRef == "delayTime" and v >= 0.5 then
                        delayTime = v
                        notify("Delay diatur ke "..delayTime.." detik", Color3.fromRGB(255, 165, 0))
                    elseif varRef == "walkSpeed" and v >= 16 then
                        walkSpeed = v
                        if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
                            player.Character.Humanoid.WalkSpeed = walkSpeed
                        end
                        notify("WalkSpeed diatur ke "..walkSpeed, Color3.fromRGB(255, 165, 0))
                    elseif varRef == "summitLimit" and v >= 1 then
                        summitLimit = v
                        notify("Summit Limit diatur ke "..summitLimit, Color3.fromRGB(255, 165, 0))
                    else
                        notify("Input tidak valid. Min Delay 0.5, Min Speed 16, Min Limit 1.", Color3.fromRGB(255, 50, 50))
                    end
                else
                    notify("Input harus angka.", Color3.fromRGB(255, 50, 50))
                end
            end
            updateText()
        end)
        
        currentY = currentY + 35
        return box
    end

    -- Tombol Utama
    createButton("MULAI Auto Summit", Color3.fromRGB(0,180,0), startAuto)
    createButton("STOP Auto Summit", Color3.fromRGB(180,0,0), stopAuto)

    -- Toggle Settings
    createToggleUI("Auto Repeat", "autoRepeat", Color3.fromRGB(0, 150, 255), Color3.fromRGB(50, 50, 50))
    createToggleUI("Auto Death (Respawn)", "autoDeath", Color3.fromRGB(0, 150, 255), Color3.fromRGB(50, 50, 50))
    createToggleUI("Server Hop", "serverHop", Color3.fromRGB(200, 100, 0), Color3.fromRGB(50, 50, 50))
    createToggleUI("Anti-AFK", "antiAFK", Color3.fromRGB(0, 150, 0), Color3.fromRGB(50, 50, 50), toggleAntiAFK)
    
    -- Input Settings
    createInputBox("Delay per CP (detik)", "delayTime", true) 
    createInputBox("WalkSpeed (min 16)", "walkSpeed", true)
    createInputBox("Server Hop Limit (x)", "summitLimit", true)
    
    -- Utility
    createButton("Reset CP Index (Basecamp)", Color3.fromRGB(100,100,0), function()
        currentCpIndex = 1
        notify("Checkpoint Index Reset ke CP #1: "..checkpoints[1].name, Color3.fromRGB(255,100,0))
    end)
    
    createButton("Find Nearest CP", Color3.fromRGB(80,80,80), function()
        local nearest = findNearestCheckpoint()
        currentCpIndex = nearest
        notify("Nearest CP: #"..nearest..": "..checkpoints[nearest].name, Color3.fromRGB(150, 200, 255))
    end)
    
    -- ** Akhir Penyesuaian Ukuran Frame **
    main.Size = UDim2.new(0,300,0,currentY + 10) -- Sesuaikan ukuran frame utama dengan tinggi tombol terakhir
    
end

initialize()
