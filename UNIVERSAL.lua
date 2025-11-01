--// UNIVERSAL AUTO SUMMIT GUI (V10 - V3 REBORN DENGAN KOREKSI INTELIJEN) //--

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local CURRENT_PLACE_ID = tostring(game.PlaceId)

-- **********************************
-- ***** KONFIGURASI MAP GLOBAL FINAL (7 MAPS) *****
-- **********************************
local MAP_CONFIG = {
    -- 1. MOUNT KOHARU (21 CP) - Menggunakan MOUNT KOHARU
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

    -- 2. MOUNT GEMI (2 CP) - Menggunakan MOUNT GEMI
    ["140014177882408"] = {
        name = "MOUNT GEMI (2 CP)", 
        checkpoints = {
            {name="Awal (Start)", pos=Vector3.new(1947.5, 417.8, 1726.8)},
            {name="Finish GEMI", pos=Vector3.new(2080.7, 437.2, 1789.7)}
        }
    },
    
    -- 7. MOUNT TENERIE (6 CP) - Data Terakhir yang Anda konfirmasi bekerja
    ["76084648389385"] = {
        name = "MOUNT TENERIE", 
        checkpoints = {
            {name="CP1", pos=Vector3.new(24.996, 163.296, 319.838)},
            {name="CP2", pos=Vector3.new(-830.715, 239.184, 887.750)},
            {name="CP3", pos=Vector3.new(-1081.016, 400.153, 1662.579)},
            {name="CP4", pos=Vector3.new(-638.603, 659.233, 3034.486)},
            {name="CP5", pos=Vector3.new(339.759, 820.852, 3891.180)},
            {name="Puncak", pos=Vector3.new(878.573, 1019.189, 4704.508)}
        }
    },
    
    -- Tambahkan Map lain jika Anda butuh CP lain di V3 (menggunakan data V9)
    -- ...
}
-- **********************************

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
    n.Text = "V10: Map ID ("..CURRENT_PLACE_ID..") TIDAK ditemukan. Script dihentikan."
    game:GetService("Debris"):AddItem(n, 5)
    return -- STOP SCRIPT
end

-- Variabel status
local autoSummit = false
local currentCpIndex = 1
local delayTime = 5
local summitThread = nil

-- FUNGSI UMUM NOTIFIKASI
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

-- FUNGSI PENCARIAN CP TERDEKAT (Revisi V10)
local function findNearestCheckpoint()
    local character = player.Character or player.CharacterAdded:Wait()
    local rootPart = character:WaitForChild("HumanoidRootPart", 5)
    if not rootPart then return 1 end

    local playerPos = rootPart.Position
    
    local nearestIndex = 1
    local minDistance = math.huge
    
    for i, cp in ipairs(checkpoints) do
        local distance = (playerPos - cp.pos).Magnitude 
        
        if distance < minDistance then
            minDistance = distance
            nearestIndex = i
        end
    end
    
    -- Jika jaraknya masih sangat jauh (> 500 stud), anggap di CP #1.
    if minDistance > 500 then 
        return 1
    end
    
    -- Jika sudah sangat dekat (misal < 50 stud) ke CP, mulai dari CP berikutnya.
    if minDistance < 50 and nearestIndex < #checkpoints then
         return nearestIndex + 1
    end

    -- Jika jaraknya di tengah-tengah tapi dekat dengan CP, kembalikan CP itu.
    return nearestIndex
end

-- FUNGSI UTAMA AUTO SUMMIT (Revisi V10)
local function startAuto()
    if autoSummit then return end
    autoSummit = true
    
    -- Tentukan CP mulai
    local startIndex = findNearestCheckpoint()
    currentCpIndex = startIndex 

    notify("Auto Summit Started! Map: "..scriptName..". Mulai dari CP #"..startIndex..": "..checkpoints[startIndex].name,Color3.fromRGB(0,150,255))
    
    summitThread = task.spawn(function()
        
        for i = startIndex, #checkpoints do
            local cp = checkpoints[i]
            
            if not autoSummit then 
                currentCpIndex = i 
                break 
            end
            
            local character = player.Character or player.CharacterAdded:Wait()
            local rootPart = character:WaitForChild("HumanoidRootPart", 5) 
            
            if rootPart then
                local cpPos = cp.pos
                -- PERINTAH INTI TELEPORTASI
                character:PivotTo(CFrame.new(cpPos))
                notify("Teleported to CP #"..i..": "..cp.name, Color3.fromRGB(0, 255, 100))
            else
                notify("Gagal menemukan HumanoidRootPart. Stop Auto.", Color3.fromRGB(255, 50, 50))
                autoSummit = false
                break
            end
            
            currentCpIndex = i + 1 
            task.wait(delayTime)
        end
        
        -- Setelah loop selesai
        if autoSummit then
            notify("Summit Complete!",Color3.fromRGB(0,255,100))
        else
            local nextCp = math.min(currentCpIndex, #checkpoints)
            local nextCpName = checkpoints[nextCp].name
            notify("Auto Summit Stopped. Siap Lanjut dari CP #"..nextCp..": "..nextCpName, Color3.fromRGB(255,165,0)) 
        end
        
        autoSummit = false
        summitThread = nil

    end)
end

local function stopAuto()
    if summitThread then task.cancel(summitThread); summitThread = nil end
    autoSummit = false 
    notify("Auto Summit Dihentikan.", Color3.fromRGB(200,50,50))
end

-- **********************************
-- ***** GUI (FUNGSI PENUH V3) ****
-- **********************************

if playerGui:FindFirstChild("UniversalV3") then playerGui.UniversalV3:Destroy() end

local gui = Instance.new("ScreenGui", playerGui)
gui.Name = "UniversalV3"
gui.ResetOnSpawn = false

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0,300,0,300)
main.Position = UDim2.new(0.5,-150,0.2,0)
main.BackgroundColor3 = Color3.fromRGB(15,15,15)
main.Active = true
main.Draggable = true

local header = Instance.new("Frame", main)
header.Size = UDim2.new(1,0,0,30)
header.BackgroundColor3 = Color3.fromRGB(40,40,40)

local title = Instance.new("TextLabel", header)
title.Text = "Universal Summit V10 ("..scriptName..")"
title.Size = UDim2.new(1,0,1,0)
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
    stopAuto()
    gui:Destroy() 
end)

-- Tombol Auto Summit
local startBtn=Instance.new("TextButton",main)
startBtn.Size=UDim2.new(0.9,0,0,40)
startBtn.Position=UDim2.new(0.05,0,0,40)
startBtn.Text="Mulai Auto Summit"
startBtn.BackgroundColor3=Color3.fromRGB(0,150,0)
startBtn.TextColor3=Color3.new(1,1,1)
startBtn.Font=Enum.Font.GothamBold

local stopBtn=startBtn:Clone()
stopBtn.Text="Stop Auto Summit"
stopBtn.Position=UDim2.new(0.05,0,0,90)
stopBtn.BackgroundColor3=Color3.fromRGB(150,0,0)

-- Tombol Reset CP
local resetBtn=startBtn:Clone()
resetBtn.Text="Reset CP Index (Mulai dari CP #1)"
resetBtn.Position=UDim2.new(0.05,0,0,140)
resetBtn.BackgroundColor3=Color3.fromRGB(100,100,0)

-- Area Checkpoint Manual
local scroll=Instance.new("ScrollingFrame",main)
scroll.Size=UDim2.new(0.9,0,0,130) 
scroll.Position=UDim2.new(0.05,0,0,170)
scroll.CanvasSize=UDim2.new(0,0,0,#checkpoints*35)
scroll.ScrollBarThickness=6
scroll.BackgroundColor3=Color3.fromRGB(25,25,25)

for i,cp in ipairs(checkpoints) do
    local b=Instance.new("TextButton",scroll)
    b.Size=UDim2.new(1,0,0,30)
    b.Position=UDim2.new(0,0,0,(i-1)*35)
    b.Text=cp.name
    b.BackgroundColor3=Color3.fromRGB(40,40,40)
    b.TextColor3=Color3.new(1,1,1)
    b.Font=Enum.Font.Gotham
    b.MouseButton1Click:Connect(function()
        local character = player.Character or player.CharacterAdded:Wait()
        local rootPart = character:WaitForChild("HumanoidRootPart", 5) 

        if rootPart then
             character:PivotTo(CFrame.new(cp.pos))
            notify("Teleported to "..cp.name,Color3.fromRGB(0,200,100))
        end
    end)
end

-- Koneksi Tombol
startBtn.MouseButton1Click:Connect(startAuto)
stopBtn.MouseButton1Click:Connect(stopAuto)
resetBtn.MouseButton1Click:Connect(function()
    currentCpIndex = 1
    notify("Checkpoint Index Reset ke CP #1: "..checkpoints[1].name, Color3.fromRGB(255,100,0))
end)

-- Notifikasi akhir
local nextCpIndex = findNearestCheckpoint()
local startCpName = checkpoints[nextCpIndex].name
currentCpIndex = nextCpIndex 

notify("V10 Loaded. Stabil (Mirip V3). Siap mulai dari CP #"..nextCpIndex..": "..startCpName,Color3.fromRGB(0,200,100))
