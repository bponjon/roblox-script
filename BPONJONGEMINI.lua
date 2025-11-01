--// BYNZZBPONJON //--
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local UserInputService = game:GetService("UserInputService") 
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

-- **********************************
-- ***** CHECKPOINTS KHK (2 CP) *****
-- **********************************
local checkpoints = {
    -- Ini biasanya adalah Base atau CP terdekat sebelum CP utama
    {name="Awal (Start)", pos=Vector3.new(1947.5, 417.8, 1726.8)},
    -- Ini adalah CP utama / CP Finish (Contoh CP KHK)
    {name="Finish KHK", pos=Vector3.new(2080.7, 437.2, 1789.7)}
}
-- **********************************

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
        -- HANYA BANDINGKAN JARAK DI SUMBU X DAN Z
        local cpPosXZ = Vector3.new(cp.pos.X, 0, cp.pos.Z)
        local playerPosXZ = Vector3.new(playerPos.X, 0, playerPos.Z)
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

-- **********************************
-- ***** FUNGSI UTAMA AUTO SUMMIT (SMART LOOP LOGIC) ****
-- **********************************
local function startAuto()
    if autoSummit then return end
    autoSummit = true
    
    -- FIX V37 LOGIC: StartIndex SELALU menggunakan currentCpIndex (CP berikutnya setelah yang terdekat)
    local startIndex = currentCpIndex
    
    notify("Auto Summit Started! Mulai dari CP #"..startIndex..": "..checkpoints[startIndex].name,Color3.fromRGB(0,150,255))
    
    summitThread = task.spawn(function()
        while autoSummit do
            if serverHop and (summitCount >= (summitLimit or 20)) then
                doServerHop()
                autoSummit=false
                break
            end
            
            -- Hanya notifikasi 'Summit Baru' jika AutoRepeat ON dan ini BUKAN start awal loop
            if autoRepeat and startIndex == 1 then
                 notify("Auto Repeat: Memulai Summit Baru (Summit #"..(summitCount+1)..")", Color3.fromRGB(0, 255, 255))
            end

            local isComplete = true
            
            for i = startIndex, #checkpoints do
                local cp = checkpoints[i]
                
                -- LOGIKA RESUME: SIMPAN INDEX SAAT DI-STOP
                if not autoSummit then 
                    currentCpIndex = i 
                    isComplete = false
                    break 
                end
                
                -- TELEPORT
                if player.Character and player.Character.PrimaryPart then
                    player.Character:SetPrimaryPartCFrame(CFrame.new(cp.pos))
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
                        -- MODE 1: AutoDeath ON -> Mati dan Respawn di Basecamp
                        task.wait(0.5)
                        if player.Character then pcall(function() player.Character:BreakJoints() end) end
                        player.CharacterAdded:Wait()
                        task.wait(1.5)
                        startIndex = 1 -- Pastikan loop berikutnya mulai dari 1
                        -- Lanjut ke loop while berikutnya
                    else
                        -- MODE 2: AutoDeath OFF -> Langsung Teleport Basecamp
                        if player.Character and player.Character.PrimaryPart then
                            player.Character:SetPrimaryPartCFrame(CFrame.new(checkpoints[1].pos))
                        end
                        task.wait(delayTime)
                        startIndex = 1 -- Pastikan loop berikutnya mulai dari 1
                        -- Lanjut ke loop while berikutnya
                    end
                else
                    -- MODE 3: AutoRepeat OFF
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

if playerGui:FindFirstChild("KHKBponjon") then playerGui.KHKBponjon:Destroy() end


-- **********************************
-- ***** GUI (Hanya fungsionalitas utama) ****
-- **********************************
local gui = Instance.new("ScreenGui", playerGui)
gui.Name = "KHKBponjon"
gui.ResetOnSpawn = false

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0,300,0,250)
main.Position = UDim2.new(0.5,-150,0.5,-125)
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
title.Text = "KHK Auto GUI (V2 - 2 CP Resume Fix)"
title.Size = UDim2.new(1,-35,1,0)
title.Position = UDim2.new(0,0,0,0)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.TextWrapped = true
title.TextScaled = true

local closeBtn = Instance.new("TextButton", header)
closeBtn.Size = UDim2.new(0,30,1,0)
closeBtn.Position = UDim2.new(1,-30,0,0)
closeBtn.Text = "X"
closeBtn.BackgroundColor3 = Color3.fromRGB(200,50,50)
closeBtn.BackgroundTransparency = getTransparency()
closeBtn.TextColor3 = Color3.new(1,1,1)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.MouseButton1Click:Connect(function() 
    toggleAntiAFK(false) 
    stopAuto()
    gui:Destroy() 
end)

local content = Instance.new("Frame", main)
content.Size = UDim2.new(1,0,1,-30)
content.Position = UDim2.new(0,0,0,30)
content.BackgroundTransparency = 1

local startBtn=Instance.new("TextButton",content)
startBtn.Size=UDim2.new(0.9,0,0,35)
startBtn.Position=UDim2.new(0.05,0,0,10)
startBtn.Text="Mulai Auto KHK (Resume)"
startBtn.BackgroundColor3=Color3.fromRGB(0,150,0)
startBtn.TextColor3=Color3.new(1,1,1)
startBtn.Font=Enum.Font.GothamBold
startBtn.MouseButton1Click:Connect(startAuto)

local stopBtn=startBtn:Clone()
stopBtn.Text="Stop Auto KHK"
stopBtn.Position=UDim2.new(0.05,0,0,55)
stopBtn.BackgroundColor3=Color3.fromRGB(200,50,50)
stopBtn.Parent=content
stopBtn.MouseButton1Click:Connect(stopAuto)

-- TOGGLE AUTO REPEAT
local repeatToggle=startBtn:Clone()
repeatToggle.Position=UDim2.new(0.05,0,0,100)
repeatToggle.Text="Auto Repeat: OFF"
repeatToggle.BackgroundColor3=Color3.fromRGB(200,0,0)
repeatToggle.Parent = content

repeatToggle.MouseButton1Click:Connect(function()
    autoRepeat=not autoRepeat
    repeatToggle.Text="Auto Repeat: "..(autoRepeat and "ON" or "OFF")
    repeatToggle.BackgroundColor3=autoRepeat and Color3.fromRGB(0,200,0) or Color3.fromRGB(200,0,0)
    notify("Auto Repeat KHK: "..(autoRepeat and "Aktif" or "Nonaktif"), autoRepeat and Color3.fromRGB(0,200,0) or Color3.fromRGB(200,0,0))
end)

-- Manual Teleport ke Finish
local finishTpBtn = startBtn:Clone()
finishTpBtn.Text = "Teleport ke Finish"
finishTpBtn.Position = UDim2.new(0.05, 0, 0, 145)
finishTpBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
finishTpBtn.Parent = content
finishTpBtn.MouseButton1Click:Connect(function()
    local cp = checkpoints[#checkpoints]
    if player.Character and player.Character.PrimaryPart then
        player.Character:SetPrimaryPartCFrame(CFrame.new(cp.pos))
        notify("Teleported to KHK Finish", Color3.fromRGB(0,200,100))
    end
end)

-- Notifikasi akhir
local nextCpIndex = math.min(currentCpIndex, #checkpoints)
local startCpName = checkpoints[nextCpIndex].name
notify("KHK Auto GUI (V2) Loaded. Siap Mulai dari CP #"..nextCpIndex..": "..startCpName,Color3.fromRGB(0,200,100))
