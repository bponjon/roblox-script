--// BYNZZBPONJON //--
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local UserInputService = game:GetService("UserInputService") 
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

-- **********************************
-- ***** CHECKPOINTS KEMBALI 2 CP (DIPASTIKAN BENAR) ****
-- **********************************
local checkpoints = {
    {name="Basecamp", pos=Vector3.new(1272.160, 639.021, 1792.852)}, -- Harap Ganti Jika Berbeda
    {name="Puncak", pos=Vector3.new(-6652.260, 3151.055, -796.739)}   -- Harap Ganti Jika Berbeda
}
-- **********************************

-- variabel
local autoSummit, autoDeath, serverHop, autoRepeat, antiAFK = false, false, false, false, false
local summitCount, summitLimit, delayTime, walkSpeed = 0, 20, 5, 16
local currentCpIndex = 1 
local summitThread = nil
local antiAFKThread = nil 
local guiOpacity = 0.9 

-- (FUNGSI UMUM DAN FUNGSI GUI TIDAK BERUBAH DARI V31)

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

local function findNearestCheckpoint()
    local character = player.Character or player.CharacterAdded:Wait()
    local rootPart = character:WaitForChild("HumanoidRootPart")
    local playerPos = rootPart.Position
    
    local nearestIndex = 1
    local minDistance = math.huge
    
    for i, cp in ipairs(checkpoints) do
        local cpPosXZ = Vector3.new(cp.pos.X, 0, cp.pos.Z)
        local playerPosXZ = Vector3.new(playerPos.X, 0, playerPos.Z)
        local distance = (playerPosXZ - cpPosXZ).Magnitude
        
        if distance < minDistance then
            minDistance = distance
            nearestIndex = i
        end
    end
    
    if minDistance > 300 then 
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
-- ***** FUNGSI UTAMA AUTO SUMMIT (MODIFIKASI LOGIKA LOOP) ****
-- **********************************
local function startAuto()
    if autoSummit then return end
    autoSummit = true
    
    -- Tentukan Index Mulai (Implicit Resume Logic)
    local startIndex = 1
    if not autoRepeat and currentCpIndex > 1 and currentCpIndex <= #checkpoints then
        startIndex = currentCpIndex
    end

    notify("Auto Summit Started! Mulai dari CP #"..startIndex..": "..checkpoints[startIndex].name,Color3.fromRGB(0,150,255))
    
    summitThread = task.spawn(function()
        while autoSummit do
            if serverHop and (summitCount >= (summitLimit or 20)) then
                doServerHop()
                autoSummit=false
                break
            end
            
            if autoRepeat then
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
                        -- MODE 2: AutoDeath OFF -> Teleport Basecamp (Sudah terjadi di Reset currentCpIndex=1, tapi ditegaskan)
                        -- Teleport ke CP1 (Basecamp) agar cepat, meskipun game seharusnya merespon.
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

do
    local nearestCp = findNearestCheckpoint()
    if nearestCp < #checkpoints then currentCpIndex = nearestCp + 1 else currentCpIndex = 1 end
end

if playerGui:FindFirstChild("BynzzBponjon") then playerGui.BynzzBponjon:Destroy() end


-- **********************************
-- ***** GUI (V27 FITUR LENGKAP) ****
-- **********************************
local gui = Instance.new("ScreenGui", playerGui)
gui.Name = "BynzzBponjon"
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
title.Text = "BynzzBponjon GUI (V32 - Smart Loop)"
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
autoPage.CanvasSize = UDim2.new(0,0,0, (35*3) + 10 + 180 + 10) 
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
resetBtn.Text="Reset CP Index (Mulai dari Basecamp)"
resetBtn.Position=UDim2.new(0.05,0,0,100)
resetBtn.BackgroundColor3 = Color3.fromRGB(150,50,50)
resetBtn.Parent=autoPage

resetBtn.MouseButton1Click:Connect(function()
    currentCpIndex = 1
    notify("Checkpoint Index Reset ke Basecamp (CP #1)", Color3.fromRGB(255,100,0))
end)

-- SCROLLING FRAME UNTUK DAFTAR CP
local scroll=Instance.new("ScrollingFrame",autoPage)
scroll.Size=UDim2.new(0.9,0,0,180)
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
            player.Character:SetPrimaryPartCFrame(CFrame.new(cp.pos))
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
end

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
infoPage.Size=UDim2.new(1,0,1,0)
infoPage.BackgroundTransparency=1
infoPage.ScrollBarThickness=6
infoPage.CanvasSize = UDim2.new(0,0,0, 150) 
infoPage.Visible=false 

local infoText=Instance.new("TextLabel",infoPage)
infoText.Size=UDim2.new(1,-20,1,-20)
infoText.Position=UDim2.new(0,10,0,10)
infoText.BackgroundTransparency=1
infoText.Text="Created by BynzzBponjon\nAuto Summit GUI (Clean Final)\n\nVersion: V32 (Smart Loop Logic)\nFitur:\n- Auto Summit dan Loop (2 CP)\n- **Smart Loop: Mati+Respawn (jika AutoDeath ON) atau Langsung Teleport Basecamp (jika AutoDeath OFF)**\n- Implicit Resume (Lanjut dari CP Terakhir) di Tombol Start\n- Anti-AFK (Server Page)\n- Slider Opacity GUI (Setting Page)\n- Scrollable Menus"
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
local startCpName = checkpoints[currentCpIndex].name
notify("BynzzBponjon GUI (V32) Loaded. Smart Loop Aktif!",Color3.fromRGB(0,200,100))
