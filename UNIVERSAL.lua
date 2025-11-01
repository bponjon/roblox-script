--// UNIVERSAL AUTO SUMMIT GUI V28 (TES STABILITAS UKURAN) //--
-- HANYA MEMUAT MOUNT GEMI (BARU) DAN MOUNT KOHARU (21 CP)
-- 5 Map lain dihapus untuk mengurangi ukuran skrip.

local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local CURRENT_PLACE_ID = tostring(game.PlaceId)

-- **********************************
-- ***** KONFIGURASI MAP (HANYA 2 MAP) *****
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
    -- MOUNT GEMI (2 CP - DATA BARU DARI USER)
    ["140014177882408"] = {name = "MOUNT GEMI (2 CP)", 
        checkpoints = {
            {name="Basecamp", pos=Vector3.new(1269.030, 639.076, 1793.997)},
            {name="Puncak", pos=Vector3.new(-6665.046, 3151.532, -799.116)}
        }
    }
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

-- **********************************
-- ***** DEKLARASI FUNGSI GLOBAL (FIRST) ****
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

-- Pengecekan Awal
if not currentMapConfig or #checkpoints == 0 then
    notify("V28 FAILED: Map ID ("..CURRENT_PLACE_ID..") TIDAK ditemukan di skrip ini.", Color3.fromRGB(255, 0, 0))
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
        local cpPos = (type(cp.pos) == "Vector3" and cp.pos) or cp.pos.p
        local cpPosXZ = Vector3.new(cpPos.X, 0, cpPos.Z)
        local playerPosXZ = Vector3.new(playerPos.X, 0, playerPos.Z)
        local distance = (playerPosXZ - cpPosXZ).Magnitude
        
        if distance < minDistance then
            minDistance = distance
            nearestIndex = i
        end
    end
    
    if minDistance > 300 and nearestIndex ~= #checkpoints then return 1 end
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
        if antiAFKThread then task.cancel(antiAFKThread) end
        antiAFKThread = nil
        notify("Anti-AFK Nonaktif", Color3.fromRGB(200, 50, 50))
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
                    local targetCFrame = (type(cp.pos) == "Vector3" and CFrame.new(cp.pos)) or cp.pos
                    character:PivotTo(targetCFrame)
                    notify("Teleported to CP #"..i..": "..cp.name, Color3.fromRGB(0, 255, 100))
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
-- ***** INIT DAN GUI (LAST) ****
-- **********************************

local function initialize()
    if playerGui:FindFirstChild("UniversalV28") then playerGui.UniversalV28:Destroy() end

    -- INIT CURRENT CP INDEX
    if player.Character then
        currentCpIndex = findNearestCheckpoint()
    end
    
    local nextCpName = checkpoints[currentCpIndex].name

    player.CharacterAdded:Connect(function(char)
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if humanoid then humanoid.WalkSpeed = walkSpeed end
    end)

    notify("V28 (2 MAPS) Loaded! Siap mulai dari CP #"..currentCpIndex..": "..nextCpName,Color3.fromRGB(0,200,100))

    -- (GUI V26/V14 yang disederhanakan)
    local gui = Instance.new("ScreenGui", playerGui)
    gui.Name = "UniversalV28"
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
    title.Text = "Universal Auto GUI V28 - Map: "..scriptName
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

    local repeatToggle=createToggle("Auto Repeat", Color3.fromRGB(200,0,0))
    repeatToggle.MouseButton1Click:Connect(function()
        autoRepeat=not autoRepeat
        repeatToggle.Text="Auto Repeat: "..(autoRepeat and "ON" or "OFF")
        repeatToggle.BackgroundColor3=autoRepeat and Color3.fromRGB(0,200,0) or Color3.fromRGB(200,0,0)
    end)

    local deathToggle=createToggle("Auto Death", Color3.fromRGB(50,50,50))
    deathToggle.MouseButton1Click:Connect(function()
        autoDeath=not autoDeath
        deathToggle.Text="Auto Death: "..(autoDeath and "ON" or "OFF")
        deathToggle.BackgroundColor3=autoDeath and Color3.fromRGB(0,100,200) or Color3.fromRGB(50,50,50)
    end)

    local serverToggle=createToggle("Server Hop", Color3.fromRGB(200,0,0))
    serverToggle.MouseButton1Click:Connect(function()
        serverHop=not serverHop
        serverToggle.Text="Server Hop: "..(serverHop and "ON" or "OFF")
        serverToggle.BackgroundColor3=serverHop and Color3.fromRGB(0,200,0) or Color3.fromRGB(200,0,0)
    end)

    local afkToggle=createToggle("Anti-AFK", Color3.fromRGB(200,0,0))
    afkToggle.MouseButton1Click:Connect(function()
        toggleAntiAFK(not antiAFK)
        afkToggle.Text="Anti-AFK: "..(antiAFK and "ON" or "OFF")
        afkToggle.BackgroundColor3=antiAFK and Color3.fromRGB(0,200,0) or Color3.fromRGB(200,0,0)
    end)
    yOffset = yOffset + 5
    
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
end

-- Panggil inisialisasi hanya setelah karakter dimuat
if player.Character then
    initialize()
else
    player.CharacterAdded:Wait()
    initialize()
end
