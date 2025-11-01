--// BYNZZBPONJON //--
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local UserInputService = game:GetService("UserInputService") 
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

local CURRENT_PLACE_ID = tostring(game.PlaceId)

-- **********************************
-- ***** KONFIGURASI MAP GLOBAL FINAL (7 MAPS) *****
-- **********************************
local MAP_CONFIG = {
    -- 1. MOUNT KOHARU (21 CP) - ID LAMA
    ["94261028489288"] = {
        name = "MOUNT KOHARU (21 CP)", 
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

    -- 2. MOUNT GEMI (2 CP) - ID LAMA
    ["140014177882408"] = {
        name = "MOUNT GEMI (2 CP)", 
        checkpoints = {
            {name="Awal (Start)", pos=Vector3.new(1947.5, 417.8, 1726.8)},
            {name="Finish GEMI", pos=Vector3.new(2080.7, 437.2, 1789.7)}
        }
    },
    
    -- 3. MOUNT JALUR TAKDIR (7 CP) - ID BARU
    ["127557455707420"] = {
        name = "MOUNT JALUR TAKDIR",
        checkpoints = {
            {name="Basecamp", pos=Vector3.new(-942.227, 14.021, -954.444)},
            {name="CP1", pos=Vector3.new(-451.266, 78.021, -662.000)},
            {name="CP2", pos=Vector3.new(-484.121, 78.015, 119.971)},
            {name="CP3", pos=Vector3.new(576.478, 242.021, 852.784)},
            {name="CP4", pos=Vector3.new(779.530, 606.021, -898.384)},
            {name="CP5", pos=Vector3.new(-363.401, 1086.021, 705.354)},
            {name="Puncak", pos=Vector3.new(292.418, 1274.021, 374.069)}
        }
    },

    -- 4. MOUNT LIRVANA (22 CP) - ID BARU
    ["79272087242323"] = {
        name = "MOUNT LIRVANA",
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

    -- 5. MOUNT AHPAYAH (12 CP) - ID BARU
    ["129916920179384"] = {
        name = "MOUNT AHPAYAH",
        checkpoints = {
            {name="Basecamp", pos=Vector3.new(-405.208, 46.021, -540.538)},
            {name="CP1", pos=Vector3.new(-397.862, 46.386, -225.315)},
            {name="CP2", pos=Vector3.new(446.973, 310.386, -454.457)},
            {name="CP3", pos=Vector3.new(389.741, 415.219, -38.504)},
            {name="CP4", pos=Vector3.new(228.787, 358.386, 420.735)},
            {name="CP5", pos=Vector3.new(-248.196, 546.015, 537.969)},
            {name="CP6", pos=Vector3.new(-707.398, 478.386, 471.019)},
            {name="CP7", pos=Vector3.new(-823.563, 598.903, -193.940)},
            {name="CP8", pos=Vector3.new(-1539.058, 682.267, -643.505)},
            {name="CP9", pos=Vector3.new(-1581.844, 650.396, 448.762)},
            {name="CP10", pos=Vector3.new(-2566.289, 662.396, 450.378)},
            {name="Puncak", pos=Vector3.new(-2921.433, 844.065, 18.757)}
        }
    },

    -- 6. MOUNT BINGUNG (21 CP) - ID BARU
    ["111417482709154"] = {
        name = "MOUNT BINGUNG",
        checkpoints = {
            {name="Basecamp", pos=Vector3.new(166.00293,14.9578,822.9834)},
            {name="CP1", pos=Vector3.new(198.238098,10.1375217,128.423187)},
            {name="CP2", pos=Vector3.new(228.194977,128.879974,-211.192383)},
            {name="CP3", pos=Vector3.new(231.817947,146.768204,-558.723816)},
            {name="CP4", pos=Vector3.new(340.004669,132.319489,-987.244446)},
            {name="CP5", pos=Vector3.new(393.582062,119.624352,-1415.08472)},
            {name="CP6", pos=Vector3.new(344.682739,190.306702,-2695.90625)},
            {name="CP7", pos=Vector3.new(353.37085,243.564514,-3065.35181)},
            {name="CP8", pos=Vector3.new(-1.62862873,259.373474,-3431.15869)},
            {name="CP9", pos=Vector3.new(54.7402382,373.025543,-3835.73633)},
            {name="CP10", pos=Vector3.new(-347.480225,505.230347,-4970.26514)},
            {name="CP11", pos=Vector3.new(-841.818359,506.035736,-4984.36621)},
            {name="CP12", pos=Vector3.new(-825.191345,571.779053,-5727.79297)},
            {name="CP13", pos=Vector3.new(-831.682068,575.300842,-6424.26855)},
            {name="CP14", pos=Vector3.new(-288.520508,661.583984,-6804.15234)},
            {name="CP15", pos=Vector3.new(675.513794,743.510742,-7249.33496)},
            {name="CP16", pos=Vector3.new(816.311768,833.685852,-7606.22998)},
            {name="CP17", pos=Vector3.new(805.29248,821.01062,-8516.9082)},
            {name="CP18", pos=Vector3.new(473.562775,879.063538,-8585.45312)},
            {name="CP19", pos=Vector3.new(268.831238,897.108215,-8576.44922)},
            {name="CP20", pos=Vector3.new(285.314331,933.954651,-8983.91992)},
            {name="Puncak", pos=Vector3.new(107.141029,988.262573,-9015.23145)}
        }
    },

    -- 7. MOUNT TENERIE (6 CP) - ID BARU
    -- NOTE: CFrame.p akan otomatis diubah menjadi Vector3
    ["76084648389385"] = {
        name = "MOUNT TENERIE", 
        checkpoints = {
            {name="CP1", pos=CFrame.new(24.996, 163.296, 319.838, -0.997991, 0.024712, -0.058331, -0.000000, 0.920780, 0.390083, 0.063350, 0.389299, -0.918930).p},
            {name="CP2", pos=CFrame.new(-830.715, 239.184, 887.750, -0.972382, -0.073546, 0.221503, -0.000009, 0.949065, 0.315080, -0.233393, 0.306376, -0.922855).p},
            {name="CP3", pos=CFrame.new(-1081.016, 400.153, 1662.579, -0.685627, 0.345798, -0.640578, 0.000000, 0.879971, 0.475027, 0.727953, 0.325691, -0.603332).p},
            {name="CP4", pos=CFrame.new(-638.603, 659.233, 3034.486, -0.840349, 0.156491, -0.518964, -0.000000, 0.957418, 0.288705, 0.542045, 0.242613, -0.804566).p},
            {name="CP5", pos=CFrame.new(339.759, 820.852, 3891.180, 0.120165, 0.220135, -0.968040, -0.000000, 0.975105, 0.221742, 0.992754, -0.026646, 0.117173).p},
            {name="Puncak", pos=CFrame.new(878.573, 1019.189, 4704.508, 0.005409, 0.375075, -0.926979, 0.000348, 0.926992, 0.375082, 0.999985, -0.002352, 0.004884).p}
        }
    },
}
-- **********************************

-- Cek apakah Map saat ini ada di konfigurasi (Sisanya sama seperti V2, hanya ganti CURRENT_PLACE_ID)
local currentMapConfig = MAP_CONFIG[CURRENT_PLACE_ID]
local scriptName = currentMapConfig and currentMapConfig.name or "UNIVERSAL (Map Tidak Dikenal)"
local checkpoints = currentMapConfig and currentMapConfig.checkpoints or {}

-- Hentikan eksekusi jika map tidak terdeteksi atau tidak ada CP
if not currentMapConfig or #checkpoints == 0 then
    local n = Instance.new("TextLabel", playerGui)
    n.Size = UDim2.new(0,400,0,35)
    n.Position = UDim2.new(0.5,-200,0.05,0)
    n.BackgroundColor3 = Color3.fromRGB(255, 100, 0)
    n.TextColor3 = Color3.new(1,1,1)
    n.Font = Enum.Font.GothamBold
    n.TextScaled = true
    n.Text = "Universal GUI: Map ID ("..CURRENT_PLACE_ID..") TIDAK ditemukan di konfigurasi. Script dihentikan."
    game:GetService("Debris"):AddItem(n, 5)
    return -- STOP SCRIPT
end


-- ===================================
-- SCRIPT LANJUT DENGAN CP YANG SESUAI
-- ===================================

-- variabel
local autoSummit, autoDeath, serverHop, autoRepeat, antiAFK = false, false, false, false, false
local summitCount, summitLimit, delayTime, walkSpeed = 0, 20, 5, 16
local currentCpIndex = 1 
local summitThread = nil
local antiAFKThread = nil 
local guiOpacity = 0.9 

-- FUNGSI UMUM
local function notify(txt, color)
    local n = Instance.new("TextLabel", playerGui)
    n.Size = UDim2.new(0,400,0,35)
    n.Position = UDim2.new(0.5,-200,0.05,0)
    n.BackgroundColor3 = color or Color3.fromRGB(30,30,30)
    n.TextColor3 = Color3.new(1,1,1)
    n.Font = Enum.Font.GothamBold
    n.TextScaled = true
    n.Text = txt
    game:GetService("Debris"):AddItem(n,2)
end

-- LOGIKA PENENTUAN CP TERDEKAT (V37 Logic)
local function findNearestCheckpoint()
    local character = player.Character or player.CharacterAdded:Wait()
    local rootPart = character:WaitForChild("HumanoidRootPart")
    local playerPos = rootPart.Position
    
    local nearestIndex = 1
    local minDistance = math.huge
    
    for i, cp in ipairs(checkpoints) do
        -- Pastikan cp.pos adalah Vector3
        local cpPos = (type(cp.pos) == "userdata" and cp.pos.X and cp.pos or CFrame.new(cp.pos)).p
        local playerPosXZ = Vector3.new(playerPos.X, 0, playerPos.Z)
        local cpPosXZ = Vector3.new(cpPos.X, 0, cpPos.Z)
        local distance = (playerPosXZ - cpPosXZ).Magnitude
        
        if distance < minDistance then
            minDistance = distance
            nearestIndex = i
        end
    end
    
    -- Amankan. Jika jarak > 300 stud, anggap di CP awal.
    if minDistance > 300 and nearestIndex ~= #checkpoints then 
        return 1
    end

    return nearestIndex
end

local function toggleAntiAFK(isEnable)
    if isEnable and not antiAFKThread then
        antiAFK = true
        notify("Anti-AFK Aktif", Color3.fromRGB(50, 200, 50))
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
        if antiAFKThread then
            task.cancel(antiAFKThread)
        end
        antiAFKThread = nil
        notify("Anti-AFK Nonaktif", Color3.fromRGB(200, 50, 50))
    end
end

local function doServerHop()
    local servers = {}
    local ok, raw = pcall(function() return game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100") end)
    
    if not ok or not raw then notify("Server Hop Gagal: Gagal Ambil Data", Color3.fromRGB(200, 50, 50)) return end
    
    local ok2, dec = pcall(function() return HttpService:JSONDecode(raw) end)
    if not ok2 or type(dec) ~= "table" or not dec.data then notify("Server Hop Gagal: Data Invalid", Color3.fromRGB(200, 50, 50)) return end
    
    for _,v in pairs(dec.data) do
        if v.playing and v.maxPlayers and v.playing < v.maxPlayers then table.insert(servers,v.id) end
    end
    
    if #servers > 0 then 
        local selectedServer = servers[math.random(1,#servers)]
        notify("Server Hop: Melompat ke server baru...", Color3.fromRGB(0, 100, 200))
        pcall(function() TeleportService:TeleportToPlaceInstance(game.PlaceId, selectedServer, player) end) 
    else
        notify("Server Hop Gagal: Tidak ada server kosong.", Color3.fromRGB(200, 50, 50))
    end
    autoSummit = false
end

-- FUNGSI UTAMA AUTO SUMMIT (Smart Loop Logic V37)
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
            
            if autoRepeat and startIndex == 1 then
                 notify("Auto Repeat: Memulai Summit Baru (Summit #"..(summitCount+1)..")", Color3.fromRGB(0, 255, 255))
            end

            local isComplete = true
            
            for i = startIndex, #checkpoints do
                local cp = checkpoints[i]
                
                if not autoSummit then 
                    currentCpIndex = i 
                    isComplete = false
                    break 
                end
                
                if player.Character and player.Character.PrimaryPart then
                    -- ** FIX: GANTI SetPrimaryPartCFrame KE PivotTo **
                    local cpPos = cp.pos
                    
                    if type(cpPos) == "userdata" and cpPos:IsA("CFrame") then
                        player.Character:PivotTo(cpPos)
                    else
                        player.Character:PivotTo(CFrame.new(cpPos))
                    end
                end
                
                currentCpIndex = i + 1 
                task.wait(delayTime)
            end
            
            if isComplete then
                summitCount+=1
                notify("Summit #"..summitCount.." Complete",Color3.fromRGB(0,255,100))
                currentCpIndex = 1 -- Reset ke 1 sebelum loop berikutnya
                
                if autoRepeat then
                    if autoDeath then
                        task.wait(0.5)
                        if player.Character then pcall(function() player.Character:BreakJoints() end) end
                        player.CharacterAdded:Wait()
                        task.wait(1.5)
                        startIndex = 1 
                    else
                        if player.Character and player.Character.PrimaryPart then
                            local cpPos = checkpoints[1].pos
                            -- ** FIX: GANTI SetPrimaryPartCFrame KE PivotTo **
                            if type(cpPos) == "userdata" and cpPos:IsA("CFrame") then
                                player.Character:PivotTo(cpPos)
                            else
                                player.Character:PivotTo(CFrame.new(cpPos))
                            end
                        end
                        task.wait(delayTime)
                        startIndex = 1 
                    end
                else
                    autoSummit = false; break 
                end
            end
            
            if not autoRepeat and isComplete then break end
            
            startIndex = 1 -- Reset untuk loop berikutnya jika AutoRepeat ON
        end 
        summitThread = nil
        
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
end


player.CharacterAdded:Connect(function(char)
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if humanoid then humanoid.WalkSpeed = walkSpeed end
end)

-- INIT CURRENT CP INDEX SAAT SCRIPT DIMULAI
do
    local nearestCp = findNearestCheckpoint()
    
    if nearestCp < #checkpoints then 
        currentCpIndex = nearestCp + 1 
    else 
        currentCpIndex = 1 
    end
end

if playerGui:FindFirstChild("UniversalBponjon") then playerGui.UniversalBponjon:Destroy() end


-- **********************************
-- ***** GUI (Fungsi Penuh) ****
-- **********************************
local gui = Instance.new("ScreenGui", playerGui)
gui.Name = "UniversalBponjon"
gui.ResetOnSpawn = false

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0,520,0,400)
main.Position = UDim2.new(0.25,0,0.25,0)
main.BackgroundColor3 = Color3.fromRGB(15,15,15)
local function getTransparency() return 1 - guiOpacity end 
main.BackgroundTransparency = getTransparency()
main.Active = true
main.Draggable = true

local header = Instance.new("Frame", main)
header.Size = UDim2.new(1,0,0,30)
header.BackgroundColor3 = Color3.fromRGB(40,40,40)
header.BackgroundTransparency = getTransparency() 

local title = Instance.new("TextLabel", header)
title.Text = "Universal Auto GUI - Map: "..scriptName
title.Size = UDim2.new(0.6,0,1,0)
title.Position = UDim2.new(0.03,0,0,0)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left

local hideBtn = Instance.new("TextButton", header)
hideBtn.Size = UDim2.new(0.2,0,1,0)
hideBtn.Position = UDim2.new(0.6,0,0,0)
hideBtn.Text = "Hide"
hideBtn.BackgroundColor3 = Color3.fromRGB(80,80,80)
hideBtn.BackgroundTransparency = getTransparency()
hideBtn.TextColor3 = Color3.new(1,1,1)
hideBtn.Font = Enum.Font.GothamBold

local closeBtn = hideBtn:Clone()
closeBtn.Text = "Close"
closeBtn.Position = UDim2.new(0.8,0,0,0)
closeBtn.Parent = header
closeBtn.MouseButton1Click:Connect(function() 
    toggleAntiAFK(false) 
    stopAuto()
    gui:Destroy() 
end)

local left = Instance.new("Frame", main)
left.Size = UDim2.new(0,130,1,-30)
left.Position = UDim2.new(0,0,0,30)
left.BackgroundColor3 = Color3.fromRGB(5,5,5)
left.BackgroundTransparency = getTransparency()

local right = Instance.new("Frame", main)
right.Size = UDim2.new(1,-130,1,-30)
right.Position = UDim2.new(0,130,0,30)
right.BackgroundColor3 = Color3.fromRGB(10,10,10)
right.BackgroundTransparency = getTransparency()

local content = Instance.new("Frame", right) 
content.Size = UDim2.new(1,0,1,0)
content.BackgroundTransparency = 1


local function showPage(name)
    for _,v in pairs(content:GetChildren()) do 
        if v:IsA("GuiObject") then
            v.Visible = (v.Name == name)
        end
    end
end

local pages = {"Auto","Setting","Info","Server"}
for i,v in ipairs(pages) do
    local b=Instance.new("TextButton",left)
    b.Size=UDim2.new(0.9,0,0,35)
    b.Position=UDim2.new(0.05,0,0,10+(i-1)*45)
    b.Text=v
    b.BackgroundColor3=Color3.fromRGB(25,25,25)
    b.TextColor3=Color3.new(1,1,1)
    b.Font = Enum.Font.GothamBold
    b.MouseButton1Click:Connect(function() showPage(v) end)
end

local function createSeparator(parent, y)
    local sep = Instance.new("Frame", parent)
    sep.Size = UDim2.new(0.9, 0, 0, 2)
    sep.Position = UDim2.new(0.05, 0, 0, y)
    sep.BackgroundColor3 = Color3.fromRGB(40, 40, 40) 
    return sep
end


-- AUTO PAGE (ScrollingFrame)
local autoPage=Instance.new("ScrollingFrame",content)
autoPage.Name="Auto"
autoPage.Size=UDim2.new(1,0,1,0)
autoPage.BackgroundTransparency=1
autoPage.CanvasSize = UDim2.new(0,0,0, (35*3) + 10 + (#checkpoints)*35 + 10) -- Disesuaikan dengan jumlah CP
autoPage.ScrollBarThickness=6
autoPage.Visible=true 

local startBtn=Instance.new("TextButton",autoPage)
startBtn.Size=UDim2.new(0.9,0,0,35)
startBtn.Position=UDim2.new(0.05,0,0,10)
startBtn.Text="Mulai Auto Summit (Implicit Resume)"
startBtn.BackgroundColor3=Color3.fromRGB(30,30,30)
startBtn.TextColor3=Color3.new(1,1,1)
startBtn.Font=Enum.Font.GothamBold

local stopBtn=startBtn:Clone()
stopBtn.Text="Stop Auto Summit"
stopBtn.Position=UDim2.new(0.05,0,0,55)
stopBtn.BackgroundColor3=Color3.fromRGB(200,50,50)
stopBtn.Parent=autoPage

local resetBtn=startBtn:Clone()
resetBtn.Text="Reset CP Index (Mulai dari CP #1)"
resetBtn.Position=UDim2.new(0.05,0,0,100)
resetBtn.BackgroundColor3 = Color3.fromRGB(150,50,50)
resetBtn.Parent=autoPage

resetBtn.MouseButton1Click:Connect(function()
    currentCpIndex = 1
    notify("Checkpoint Index Reset ke CP #1: "..checkpoints[1].name, Color3.fromRGB(255,100,0))
end)

-- SCROLLING FRAME UNTUK DAFTAR CP
local scroll=Instance.new("ScrollingFrame",autoPage)
scroll.Size=UDim2.new(0.9,0,0,250) 
scroll.Position=UDim2.new(0.05,0,0,145)
scroll.CanvasSize=UDim2.new(0,0,0,#checkpoints*35)
scroll.ScrollBarThickness=6
scroll.BackgroundColor3=Color3.fromRGB(15,15,15)

for i,cp in ipairs(checkpoints) do
    local b=Instance.new("TextButton",scroll)
    b.Size=UDim2.new(1,0,0,30)
    b.Position=UDim2.new(0,0,0,(i-1)*35)
    b.Text=cp.name
    b.BackgroundColor3=Color3.fromRGB(25,25,25)
    b.TextColor3=Color3.new(1,1,1)
    b.Font=Enum.Font.Gotham
    b.MouseButton1Click:Connect(function()
        if player.Character and player.Character.PrimaryPart then
             local cpPos = cp.pos
             -- ** FIX: GANTI SetPrimaryPartCFrame KE PivotTo **
             if type(cpPos) == "userdata" and cpPos:IsA("CFrame") then
                player.Character:PivotTo(cpPos)
            else
                player.Character:PivotTo(CFrame.new(cpPos))
            end
            notify("Teleported to "..cp.name,Color3.fromRGB(0,200,100))
        end
    end)
end

startBtn.MouseButton1Click:Connect(startAuto)
stopBtn.MouseButton1Click:Connect(stopAuto)


-- SERVER PAGE (ScrollingFrame)
local serverPage=Instance.new("ScrollingFrame",content)
serverPage.Name="Server"
serverPage.Size=UDim2.new(1,0,1,0)
serverPage.BackgroundTransparency=1
serverPage.ScrollBarThickness=6
serverPage.CanvasSize = UDim2.new(0,0,0, 420) 
serverPage.Visible=false 

local yPos = 10 

-- KELOMPOK 1: AUTO LOOP CONTROL
local group1Header = Instance.new("TextLabel", serverPage)
group1Header.Size = UDim2.new(0.9, 0, 0, 20)
group1Header.Position = UDim2.new(0.05, 0, 0, yPos)
group1Header.Text = "AUTO LOOP CONTROL"
group1Header.TextColor3 = Color3.fromRGB(200, 200, 200)
group1Header.BackgroundTransparency = 1
group1Header.Font = Enum.Font.GothamBold
yPos = yPos + 25

-- 1. TOGGLE AUTO REPEAT
local repeatToggle=Instance.new("TextButton",serverPage)
repeatToggle.Size=UDim2.new(0.9,0,0,35)
repeatToggle.Position=UDim2.new(0.05,0,0,yPos)
repeatToggle.Text="Auto Repeat: OFF"
repeatToggle.BackgroundColor3=Color3.fromRGB(200,0,0)
repeatToggle.TextColor3=Color3.new(1,1,1)
repeatToggle.Font=Enum.Font.GothamBold

repeatToggle.MouseButton1Click:Connect(function()
    autoRepeat=not autoRepeat
    repeatToggle.Text="Auto Repeat: "..(autoRepeat and "ON" or "OFF")
    repeatToggle.BackgroundColor3=autoRepeat and Color3.fromRGB(0,200,0) or Color3.fromRGB(200,0,0)
    notify("Auto Repeat: "..(autoRepeat and "Aktif" or "Nonaktif"), autoRepeat and Color3.fromRGB(0,200,0) or Color3.fromRGB(200,0,0))
end)
yPos = yPos + 40

-- 2. AUTO DEATH TOGGLE
local deathToggle=repeatToggle:Clone()
deathToggle.Position=UDim2.new(0.05,0,0,yPos)
deathToggle.Text="Auto Death: OFF"
deathToggle.Parent = serverPage

deathToggle.MouseButton1Click:Connect(function()
    autoDeath=not autoDeath
    deathToggle.Text="Auto Death: "..(autoDeath and "ON" or "OFF")
    deathToggle.BackgroundColor3=autoDeath and Color3.fromRGB(0,200,0) or Color3.fromRGB(200,0,0)
end)
yPos = yPos + 40

-- Garis Pemisah 1
createSeparator(serverPage, yPos)
yPos = yPos + 10 

-- KELOMPOK 2: SERVER HOP
local group2Header = Instance.new("TextLabel", serverPage)
group2Header.Size = UDim2.new(0.9, 0, 0, 20)
group2Header.Position = UDim2.new(0.05, 0, 0, yPos)
group2Header.Text = "SERVER HOP CONTROL"
group2Header.TextColor3 = Color3.fromRGB(200, 200, 200)
group2Header.BackgroundTransparency = 1
group2Header.Font = Enum.Font.GothamBold
yPos = yPos + 25

-- 3. Server Hop Toggle
local serverToggle=repeatToggle:Clone()
serverToggle.Position=UDim2.new(0.05,0,0,yPos)
serverToggle.Text="Server Hop: OFF"
serverToggle.Parent = serverPage

serverToggle.MouseButton1Click:Connect(function()
    serverHop=not serverHop
    serverToggle.Text="Server Hop: "..(serverHop and "ON" or "OFF")
    serverToggle.BackgroundColor3=serverHop and Color3.fromRGB(0,200,0) or Color3.fromRGB(200,0,0)
end)
yPos = yPos + 40

-- 4. Summit Limit Box
local limitBox=Instance.new("TextBox",serverPage)
limitBox.Size=UDim2.new(0.9,0,0,30)
limitBox.Position=UDim2.new(0.05,0,0,yPos)
limitBox.Text=tostring(summitLimit)
limitBox.PlaceholderText="Batas Summit (default 20)"
limitBox.BackgroundColor3=Color3.fromRGB(30,30,30)
limitBox.TextColor3=Color3.new(1,1,1)
limitBox.Font=Enum.Font.Gotham
limitBox.FocusLost:Connect(function()
    local v=tonumber(limitBox.Text)
    if v then summitLimit=v end
end)
yPos = yPos + 35

-- Garis Pemisah 2
createSeparator(serverPage, yPos)
yPos = yPos + 10 

-- KELOMPOK 3: MANUAL ACTION & ANTI AFK
local group3Header = Instance.new("TextLabel", serverPage)
group3Header.Size = UDim2.new(0.9, 0, 0, 20)
group3Header.Position = UDim2.new(0.05, 0, 0, yPos)
group3Header.Text = "MANUAL ACTIONS & ANTI-AFK"
group3Header.TextColor3 = Color3.fromRGB(200, 200, 200)
group3Header.BackgroundTransparency = 1
group3Header.Font = Enum.Font.GothamBold
yPos = yPos + 25

-- 5. TOGGLE ANTI-AFK 
local afkToggle=repeatToggle:Clone()
afkToggle.Position=UDim2.new(0.05,0,0,yPos)
afkToggle.Text="Anti-AFK: OFF"
afkToggle.Parent = serverPage

afkToggle.MouseButton1Click:Connect(function()
    toggleAntiAFK(not antiAFK)
    afkToggle.Text="Anti-AFK: "..(antiAFK and "ON" or "OFF")
    afkToggle.BackgroundColor3=antiAFK and Color3.fromRGB(0,200,0) or Color3.fromRGB(200,0,0)
end)
yPos = yPos + 40

-- 6. Manual Death
local manualDeath=deathToggle:Clone()
manualDeath.Text="Manual Death"
manualDeath.Position=UDim2.new(0.05,0,0,yPos)
manualDeath.BackgroundColor3=Color3.fromRGB(80,80,80)
manualDeath.Parent=serverPage
manualDeath.MouseButton1Click:Connect(function()
    if player.Character then pcall(function() player.Character:BreakJoints() end) end
end)
yPos = yPos + 40

-- 7. Manual Hop
local manualHop=serverToggle:Clone()
manualHop.Text="Ganti Server Manual"
manualHop.Position=UDim2.new(0.05,0,0,yPos)
manualHop.BackgroundColor3=Color3.fromRGB(80,80,80)
manualHop.Parent=serverPage
manualHop.MouseButton1Click:Connect(function()
    doServerHop()
end)


-- SETTING PAGE (ScrollingFrame)
local setPage=Instance.new("ScrollingFrame",content)
setPage.Name="Setting"
setPage.Size=UDim2.new(1,0,1,0)
setPage.BackgroundTransparency=1
setPage.ScrollBarThickness=6
setPage.CanvasSize = UDim2.new(0,0,0, 260) 
setPage.Visible=false 

local setYPos = 20

local delayBox=Instance.new("TextBox",setPage)
delayBox.Size=UDim2.new(0.9,0,0,30)
delayBox.Position=UDim2.new(0.05,0,0,setYPos)
delayBox.Text=tostring(delayTime)
delayBox.PlaceholderText="Delay detik"
delayBox.BackgroundColor3=Color3.fromRGB(30,30,30)
delayBox.TextColor3=Color3.new(1,1,1)
delayBox.FocusLost:Connect(function()
    local v=tonumber(delayBox.Text)
    if v then delayTime=v end
end)
setYPos = setYPos + 40

local speedBox=Instance.new("TextBox",setPage)
speedBox.Size=UDim2.new(0.9,0,0,30)
speedBox.Position=UDim2.new(0.05,0,0,setYPos)
speedBox.Text=tostring(walkSpeed)
speedBox.PlaceholderText="WalkSpeed"
speedBox.BackgroundColor3=Color3.fromRGB(30,30,30)
speedBox.TextColor3=Color3.new(1,1,1)
speedBox.FocusLost:Connect(function()
    local v=tonumber(speedBox.Text)
    if v then
        walkSpeed=v
        if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
            player.Character.Humanoid.WalkSpeed = walkSpeed
        end
    end
end)
setYPos = setYPos + 40

createSeparator(setPage, setYPos)
setYPos = setYPos + 10

-- SLIDER TRANSPARANSI
local opacityLabel = Instance.new("TextLabel", setPage)
opacityLabel.Size = UDim2.new(0.9, 0, 0, 20)
opacityLabel.Position = UDim2.new(0.05, 0, 0, setYPos)
opacityLabel.Text = "GUI Opacity: "..string.format("%.2f", guiOpacity)
opacityLabel.BackgroundTransparency = 1
opacityLabel.TextColor3 = Color3.new(1,1,1)
opacityLabel.Font = Enum.Font.GothamBold
opacityLabel.TextXAlignment = Enum.TextXAlignment.Left
setYPos = setYPos + 25

local slider = Instance.new("Frame", setPage)
slider.Size = UDim2.new(0.9, 0, 0, 20)
slider.Position = UDim2.new(0.05, 0, 0, setYPos)
slider.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
local sliderHandle = Instance.new("TextButton", slider)
sliderHandle.Size = UDim2.new(0, 20, 1, 0)
sliderHandle.Position = UDim2.new(guiOpacity, -10, 0, 0)
sliderHandle.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
sliderHandle.Text = ""

-- Fungsi untuk mengupdate Opacity
local function updateOpacity(x)
    local newOpacity = math.min(1, math.max(0.1, x / slider.AbsoluteSize.X)) 
    guiOpacity = newOpacity
    opacityLabel.Text = "GUI Opacity: " .. string.format("%.2f", guiOpacity)
    
    local transparency = 1 - guiOpacity
    main.BackgroundTransparency = transparency
    header.BackgroundTransparency = transparency
    left.BackgroundTransparency = transparency
    right.BackgroundTransparency = transparency
    hideBtn.BackgroundTransparency = transparency
    closeBtn.BackgroundTransparency = transparency
    
    sliderHandle.Position = UDim2.new(newOpacity, -10, 0, 0)
}

local isDragging = false
sliderHandle.MouseButton1Down:Connect(function() isDragging = true end)
sliderHandle.MouseButton1Up:Connect(function() isDragging = false end)

RunService.RenderStepped:Connect(function()
    if isDragging then
        local mouse = player:GetMouse()
        local relativeX = mouse.X - slider.AbsolutePosition.X
        updateOpacity(relativeX)
    end
end)


-- INFO PAGE (ScrollingFrame)
local infoPage=Instance.new("ScrollingFrame",content)
infoPage.Name="Info"
infoPage.Size=UDim2.new(1,-20,1,-20)
infoPage.Position=UDim2.new(0,10,0,10)
infoPage.BackgroundTransparency=1
infoPage.ScrollBarThickness=6
infoPage.CanvasSize = UDim2.new(0,0,0, 150) 
infoPage.Visible=false 

local infoText=Instance.new("TextLabel",infoPage)
infoText.Size=UDim2.new(1,0,0,140)
infoText.Position=UDim2.new(0,0,0,0)
infoText.BackgroundTransparency=1
infoText.Text="Universal Auto GUI\nMap Saat Ini: "..scriptName.."\nTotal Checkpoint: "..#checkpoints.."\n\nVersi: V4 (PivotTo Fix)\nMap Terintegrasi: "..#MAP_CONFIG.."\nFitur:\n- Deteksi map otomatis.\n- Menggunakan PivotTo (teleportasi modern).\n- Loop, Hop, AFK, dan Pengaturan Kecepatan."
infoText.TextColor3=Color3.new(1,1,1)
infoText.Font=Enum.Font.Gotham
infoText.TextWrapped=true
infoText.TextXAlignment = Enum.TextXAlignment.Left


--- IMPLEMENTASI HIDE/SHOW LOGIC 
local isHiddenMode = false
local originalMainSize = main.Size 
local headerHeight = header.Size.Y.Offset 

local function toggleGuiDisplay()
    isHiddenMode = not isHiddenMode
    
    if isHiddenMode then
        main.Size = UDim2.new(originalMainSize.X.Scale, originalMainSize.X.Offset, 0, headerHeight) 
        left.Visible = false
        right.Visible = false
        hideBtn.Text = "Show"
    else
        main.Size = originalMainSize 
        left.Visible = true
        right.Visible = true
        hideBtn.Text = "Hide"
    end
    main.Active = true
    main.Draggable = true
end

hideBtn.MouseButton1Click:Connect(toggleGuiDisplay)


-- Notifikasi akhir
local nextCpIndex = math.min(currentCpIndex, #checkpoints)
local startCpName = checkpoints[nextCpIndex].name
notify("Universal GUI Loaded for "..scriptName..". Siap Mulai dari CP #"..nextCpIndex..": "..startCpName,Color3.fromRGB(0,200,100))
