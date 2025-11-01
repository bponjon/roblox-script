--// UNIVERSAL AUTO SUMMIT GUI (V14 - SOLUSI ERROR INIT) //--

-- Variabel global untuk memaksa inisialisasi di awal (Mengatasi nil value error)
Players = game:GetService("Players")
TeleportService = game:GetService("TeleportService")
UserInputService = game:GetService("UserInputService")
player = Players.LocalPlayer
playerGui = player:WaitForChild("PlayerGui")
CURRENT_PLACE_ID = tostring(game.PlaceId)

-- **********************************
-- ***** KONFIGURASI MAP GLOBAL (7 MAPS) *****
-- **********************************
-- Dipertahankan seperti V13 (disederhanakan untuk CP)
MAP_CONFIG = {
    ["94261028489288"] = {name = "MOUNT KOHARU (21 CP)", 
        checkpoints = {
            {name="Basecamp", pos=Vector3.new(-883.288,43.358,933.698)},
            {name="CP1", pos=Vector3.new(-473.240,49.167,624.194)},
            {name="Puncak", pos=Vector3.new(-1534.938,933.116,-2176.096)}
        }
    }, -- Hanya 3 CP untuk uji coba
    ["140014177882408"] = {name = "MOUNT GEMI (2 CP)", checkpoints = {{name="Awal (Start)", pos=Vector3.new(1947.5, 417.8, 1726.8)}, {name="Finish GEMI", pos=Vector3.new(2080.7, 437.2, 1789.7)}}},
    ["127557455707420"] = {name = "MOUNT JALUR TAKDIR", checkpoints = {{name="Basecamp", pos=Vector3.new(-942.227, 14.021, -954.444)}, {name="Puncak", pos=Vector3.new(292.418, 1274.021, 374.069)}}},
    ["79272087242323"] = {name = "MOUNT LIRVANA", checkpoints = {{name="Checkpoint 0", pos=Vector3.new(-33.023, 86.149, 7.025)}, {name="Checkpoint 21", pos=Vector3.new(799.696, 1001.949, 207.303)}}},
    ["129916920179384"] = {name = "MOUNT AHPAYAH", checkpoints = {{name="Basecamp", pos=Vector3.new(-405.208, 46.021, -540.538)}, {name="Puncak", pos=Vector3.new(-2921.433, 844.065, 18.757)}}},
    ["111417482709154"] = {name = "MOUNT BINGUNG", checkpoints = {{name="Basecamp", pos=Vector3.new(166.00293,14.9578,822.9834)}, {name="Puncak", pos=Vector3.new(107.141029,988.262573,-9015.23145)}}},
    ["76084648389385"] = {name = "MOUNT TENERIE", checkpoints = {{name="CP1", pos=Vector3.new(24.996, 163.296, 319.838)}, {name="Puncak", pos=Vector3.new(878.573, 1019.189, 4704.508)}}},
}
-- **********************************

currentMapConfig = MAP_CONFIG[CURRENT_PLACE_ID]
scriptName = currentMapConfig and currentMapConfig.name or "UNIVERSAL (Map Tidak Dikenal)"
checkpoints = currentMapConfig and currentMapConfig.checkpoints or {}

-- FUNGSI UMUM NOTIFIKASI
function notify(txt, color)
    -- Pengecekan pcall untuk mencegah error di fungsi notifikasi
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
    notify("V14 FAILED: Map ID ("..CURRENT_PLACE_ID..") TIDAK ditemukan atau CP kosong.", Color3.fromRGB(255, 0, 0))
    return -- STOP SCRIPT
end

-- Variabel Status & Fitur
autoSummit, autoDeath, serverHop, autoRepeat, antiAFK = false, false, false, false, false
summitCount, summitLimit, delayTime, walkSpeed = 0, 20, 5, 16
currentCpIndex = 1 
summitThread = nil
antiAFKThread = nil 

-- LOGIKA PENENTUAN CP TERDEKAT
function findNearestCheckpoint()
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
    
    if minDistance > 500 then return 1 end
    if minDistance < 50 and nearestIndex < #checkpoints then return nearestIndex + 1 end
    return nearestIndex
end

function doServerHop()
    notify("Server Hop: Melompat ke server acak...", Color3.fromRGB(0, 100, 200))
    pcall(function() TeleportService:Teleport(game.PlaceId, player) end) 
    autoSummit = false
end

-- FUNGSI UTAMA AUTO SUMMIT (Logic Inti V12/V11)
function startAuto()
    if autoSummit then return end
    autoSummit = true
    local startIndex = currentCpIndex
    
    notify("Auto Summit Started! Map: "..scriptName..". Mulai dari CP #"..startIndex..": "..checkpoints[startIndex].name,Color3.fromRGB(0,150,255))
    
    summitThread = task.spawn(function()
        local currentLoopStart = startIndex
        
        while autoSummit do
            if serverHop and (summitCount >= (summitLimit or 20)) then
                doServerHop()
                autoSummit=false
                break
            end
            
            local isComplete = true
            
            for i = currentLoopStart, #checkpoints do
                local cp = checkpoints[i]
                
                if not autoSummit then currentCpIndex = i; isComplete = false; break end
                
                local character = player.Character or player.CharacterAdded:Wait()
                local rootPart = character:WaitForChild("HumanoidRootPart", 5) 
                
                if rootPart then
                    -- TELEPORTASI FIX (PivotTo)
                    character:PivotTo(CFrame.new(cp.pos) * CFrame.Angles(0, 0, 0)) 
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
                if autoRepeat then
                    notify("Summit #"..summitCount.." Complete. Auto Repeat ON. Restarting...",Color3.fromRGB(0,255,100))
                    currentCpIndex = 1; currentLoopStart = 1
                    
                    if autoDeath then
                        task.wait(0.5)
                        if player.Character then pcall(function() player.Character.Humanoid.Health = 0 end) end 
                        player.CharacterAdded:Wait()
                        task.wait(1.5)
                    else
                        if player.Character and player.Character.PrimaryPart then
                            local cpPos = checkpoints[1].pos
                            player.Character:PivotTo(CFrame.new(cpPos) * CFrame.Angles(0, 0, 0))
                        end
                        task.wait(delayTime)
                    end
                else
                    notify("Summit #"..summitCount.." Complete. Auto Repeat OFF. Stopped.",Color3.fromRGB(0,255,100))
                    autoSummit = false; break 
                end
            end
            
            if not autoRepeat and isComplete then break end
        end
        summitThread = nil
    end)
end

function stopAuto()
    if summitThread then task.cancel(summitThread); summitThread = nil end
    autoSummit = false 
    notify("Auto Summit Dihentikan.", Color3.fromRGB(200,50,50))
end

-- Toggle Anti-AFK (Logika Dipertahankan)
function toggleAntiAFK(isEnable)
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

player.CharacterAdded:Connect(function(char)
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if humanoid then humanoid.WalkSpeed = walkSpeed end
end)

-- INIT CP INDEX
do
    local nearestCp = findNearestCheckpoint()
    currentCpIndex = nearestCp
end

if playerGui:FindFirstChild("UniversalV14") then playerGui.UniversalV14:Destroy() end


-- **********************************
-- ***** GUI V14 (Struktur Sederhana V13) ****
-- **********************************
pcall(function() 

    gui = Instance.new("ScreenGui", playerGui)
    gui.Name = "UniversalV14"
    gui.ResetOnSpawn = false

    main = Instance.new("Frame", gui)
    main.Size = UDim2.new(0,350,0,550) 
    main.Position = UDim2.new(0.5,-175,0.2,0)
    main.BackgroundColor3 = Color3.fromRGB(15,15,15)
    main.Active = true
    main.Draggable = true

    header = Instance.new("Frame", main)
    header.Size = UDim2.new(1,0,0,30)
    header.BackgroundColor3 = Color3.fromRGB(40,40,40)

    title = Instance.new("TextLabel", header)
    title.Text = "Universal Auto GUI V14 - Map: "..scriptName
    title.Size = UDim2.new(1,-50,1,0)
    title.Position = UDim2.new(0,0,0,0)
    title.BackgroundTransparency = 1
    title.TextColor3 = Color3.new(1,1,1)
    title.Font = Enum.Font.GothamBold
    title.TextScaled = true

    closeBtn = Instance.new("TextButton", header)
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

    yOffset = 40
    buttonHeight = 35

    -- START/STOP BUTTONS
    startBtn=Instance.new("TextButton",main)
    startBtn.Size=UDim2.new(0.9,0,0,buttonHeight)
    startBtn.Position=UDim2.new(0.05,0,0,yOffset)
    startBtn.Text="Mulai Auto Summit"
    startBtn.BackgroundColor3=Color3.fromRGB(0,150,0)
    startBtn.TextColor3=Color3.new(1,1,1)
    startBtn.Font=Enum.Font.GothamBold
    yOffset = yOffset + buttonHeight + 5

    stopBtn=startBtn:Clone()
    stopBtn.Text="Stop Auto Summit"
    stopBtn.Position=UDim2.new(0.05,0,0,yOffset)
    stopBtn.BackgroundColor3=Color3.fromRGB(150,0,0)
    stopBtn.Parent = main
    yOffset = yOffset + buttonHeight + 5

    -- AUTO REPEAT TOGGLE
    repeatToggle=startBtn:Clone()
    repeatToggle.Position=UDim2.new(0.05,0,0,yOffset)
    repeatToggle.Text="Auto Repeat: OFF"
    repeatToggle.BackgroundColor3=Color3.fromRGB(200,0,0)
    repeatToggle.Parent = main

    repeatToggle.MouseButton1Click:Connect(function()
        autoRepeat=not autoRepeat
        repeatToggle.Text="Auto Repeat: "..(autoRepeat and "ON" or "OFF")
        repeatToggle.BackgroundColor3=autoRepeat and Color3.fromRGB(0,200,0) or Color3.fromRGB(200,0,0)
    end)
    yOffset = yOffset + buttonHeight + 5

    -- AUTO DEATH TOGGLE
    deathToggle=repeatToggle:Clone()
    deathToggle.Position=UDim2.new(0.05,0,0,yOffset)
    deathToggle.Text="Auto Death: OFF"
    deathToggle.BackgroundColor3 = Color3.fromRGB(50,50,50)
    deathToggle.Parent = main

    deathToggle.MouseButton1Click:Connect(function()
        autoDeath=not autoDeath
        deathToggle.Text="Auto Death: "..(autoDeath and "ON" or "OFF")
        deathToggle.BackgroundColor3=autoDeath and Color3.fromRGB(0,100,200) or Color3.fromRGB(50,50,50)
    end)
    yOffset = yOffset + buttonHeight + 5

    -- SERVER HOP TOGGLE
    serverToggle=repeatToggle:Clone()
    serverToggle.Position=UDim2.new(0.05,0,0,yOffset)
    serverToggle.Text="Server Hop: OFF"
    serverToggle.BackgroundColor3=Color3.fromRGB(200,0,0)
    serverToggle.Parent = main

    serverToggle.MouseButton1Click:Connect(function()
        serverHop=not serverHop
        serverToggle.Text="Server Hop: "..(serverHop and "ON" or "OFF")
        serverToggle.BackgroundColor3=serverHop and Color3.fromRGB(0,200,0) or Color3.fromRGB(200,0,0)
    end)
    yOffset = yOffset + buttonHeight + 5

    -- ANTI-AFK TOGGLE
    afkToggle=repeatToggle:Clone()
    afkToggle.Position=UDim2.new(0.05,0,0,yOffset)
    afkToggle.Text="Anti-AFK: OFF"
    afkToggle.BackgroundColor3=Color3.fromRGB(200,0,0)
    afkToggle.Parent = main

    afkToggle.MouseButton1Click:Connect(function()
        toggleAntiAFK(not antiAFK)
        afkToggle.Text="Anti-AFK: "..(antiAFK and "ON" or "OFF")
        afkToggle.BackgroundColor3=antiAFK and Color3.fromRGB(0,200,0) or Color3.fromRGB(200,0,0)
    end)
    yOffset = yOffset + buttonHeight + 10


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
        if v and v > 0.5 then 
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
        if v then 
            summitLimit=v 
            box.Text="Summit Limit: "..tostring(summitLimit)
        else
            box.Text="Summit Limit: "..tostring(summitLimit)
        end
    end)

    -- MANUAL ACTIONS
    yOffset = yOffset + 10
    manualHop=startBtn:Clone()
    manualHop.Text="Ganti Server Manual"
    manualHop.Position=UDim2.new(0.05,0,0,yOffset)
    manualHop.BackgroundColor3=Color3.fromRGB(80,80,80)
    manualHop.Parent=main

    manualHop.MouseButton1Click:Connect(doServerHop)
    yOffset = yOffset + buttonHeight + 5

    resetBtn=startBtn:Clone()
    resetBtn.Text="Reset CP Index (Mulai dari CP #1)"
    resetBtn.Position=UDim2.new(0.05,0,0,yOffset)
    resetBtn.BackgroundColor3 = Color3.fromRGB(100,100,0)
    resetBtn.Parent=main

    resetBtn.MouseButton1Click:Connect(function()
        currentCpIndex = 1
        notify("Checkpoint Index Reset ke CP #1: "..checkpoints[1].name, Color3.fromRGB(255,100,0))
    end)
    yOffset = yOffset + buttonHeight + 5


    -- Event Connectors
    startBtn.MouseButton1Click:Connect(startAuto)
    stopBtn.MouseButton1Click:Connect(stopAuto)


    -- Notifikasi akhir
    local nextCpIndex = findNearestCheckpoint()
    local startCpName = checkpoints[nextCpIndex].name
    currentCpIndex = nextCpIndex 

    notify("V14 Loaded! FINAL FIX. Siap mulai dari CP #"..nextCpIndex..": "..startCpName,Color3.fromRGB(0,200,100))
    
end) -- End pcall for GUI creation
