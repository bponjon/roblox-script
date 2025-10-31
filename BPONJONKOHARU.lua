--// BYNZZBPONJON FINAL CLEAN READY TO USE - FIXED V23 (Automatic Scrolling Pages) //--
-- Menggunakan UIListLayout dan AutomaticCanvasSize untuk memastikan scroll bar berfungsi di semua menu.

local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local UserInputService = game:GetService("UserInputService") 
local RunService = game:GetService("RunService")

-- checkpoints (Dihilangkan untuk brevity)
local checkpoints = {
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

-- variabel (Dihilangkan untuk brevity)
local autoSummit, autoDeath, serverHop, autoRepeat, antiAFK = false, false, false, false, false
local summitCount, summitLimit, delayTime, walkSpeed = 0, 20, 5, 16
local currentCpIndex = 1 
local summitThread = nil
local antiAFKThread = nil 
local guiOpacity = 0.9 

-- notif function (Dihilangkan untuk brevity)
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

-- [Fungsi findNearestCheckpoint, toggleAntiAFK, startAuto, stopAuto, dan Initializations Dihilangkan untuk brevity]
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
local function startAuto()
    if autoSummit then return end
    autoSummit = true
    notify("Auto Summit Started!",Color3.fromRGB(0,150,255))
    
    summitThread = task.spawn(function()
        while autoSummit do
            if serverHop and (summitCount >= (summitLimit or 20)) then
                TeleportService:Teleport(game.PlaceId, player)
                autoSummit=false
                break
            end
            
            local startIndex = autoRepeat and 1 or (currentCpIndex > #checkpoints and 1 or currentCpIndex)
            if not autoRepeat then
                notify("Auto Summit: Mulai dari CP #"..startIndex..": "..checkpoints[startIndex].name,Color3.fromRGB(0,200,200))
            else
                 notify("Auto Repeat: Memulai Summit Baru (Summit #"..(summitCount+1)..")", Color3.fromRGB(0, 255, 255))
            end

            local isComplete = true
            
            for i = startIndex, #checkpoints do
                local cp = checkpoints[i]
                if not autoSummit then currentCpIndex = i; isComplete = false; break end
                
                if i < #checkpoints - 1 then 
                    local nearestCpIndex = findNearestCheckpoint()
                    if nearestCpIndex < i then
                        local rollbackIndex = nearestCpIndex + 1
                        notify("CP Terlewat! Kembali ke CP #"..rollbackIndex, Color3.fromRGB(255, 100, 0))
                        i = rollbackIndex - 1
                        cp = checkpoints[rollbackIndex]
                    end
                end
                
                if player.Character and player.Character.PrimaryPart then
                    player.Character:SetPrimaryPartCFrame(CFrame.new(cp.pos))
                end
                
                currentCpIndex = i + 1 
                task.wait(delayTime)
            end
            
            if isComplete then
                summitCount+=1
                notify("Summit #"..summitCount.." Complete",Color3.fromRGB(0,255,100))
                currentCpIndex = 1
                
                if autoDeath then 
                    task.wait(0.5)
                    if player.Character then pcall(function() player.Character:BreakJoints() end) end
                    if autoRepeat then player.CharacterAdded:Wait(); task.wait(1.5) else autoSummit = false; break end
                else
                    autoSummit = false; break 
                end
            end
            
            if not autoRepeat then break end
            
        end 
        summitThread = nil
        if not autoSummit then notify("Auto Summit Finished/Stopped.", Color3.fromRGB(255,165,0)) end
    end)
end
local function stopAuto()
    if summitThread then task.cancel(summitThread); summitThread = nil end
    autoSummit = false 
    notify("Auto Summit Stopped", Color3.fromRGB(255, 50, 50))
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


-- GUI Setup
local gui = Instance.new("ScreenGui", playerGui)
gui.Name = "BynzzBponjon"
gui.ResetOnSpawn = false

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0,520,0,400)
main.Position = UDim2.new(0.25,0,0.25,0)
main.BackgroundColor3 = Color3.fromRGB(15,15,15)
main.BackgroundTransparency = 1 - guiOpacity 
main.Active = true
main.Draggable = true

local header = Instance.new("Frame", main)
header.Size = UDim2.new(1,0,0,30)
header.BackgroundColor3 = Color3.fromRGB(40,40,40)
header.BackgroundTransparency = 1 - guiOpacity 

local title = Instance.new("TextLabel", header)
title.Text = "BynzzBponjon GUI (V23 - Auto Scroll)"
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
hideBtn.BackgroundTransparency = 1 - guiOpacity
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
left.BackgroundTransparency = 1 - guiOpacity

local right = Instance.new("Frame", main)
right.Size = UDim2.new(1,-130,1,-30)
right.Position = UDim2.new(0,130,0,30)
right.BackgroundColor3 = Color3.fromRGB(10,10,10)
right.BackgroundTransparency = 1 - guiOpacity

-- CONTENT FRAME UTAMA (Frame biasa)
local content = Instance.new("Frame", right) 
content.Size = UDim2.new(1,0,1,0)
content.BackgroundTransparency = 1


-- Logika Show Page (mencari ScrollingFrame)
local function showPage(name)
    for _,v in pairs(content:GetChildren()) do 
        if v:IsA("ScrollingFrame") then 
            v.Visible = (v.Name == name)
        end
    end
end

-- Tombol Menu
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

-- =========================================================================
-- FUNCTION UNTUK MEMBUAT ELEMEN BERIKUTNYA MENGGUNAKAN UILISTLAYOUT
-- =========================================================================

local function setupLayout(parent)
    local layout = Instance.new("UIListLayout", parent)
    layout.Padding = UDim.new(0, 5)
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    
    -- Tambahkan Padding Awal (kosong) agar tidak menempel di atas
    local topPadding = Instance.new("Frame", parent)
    topPadding.Size = UDim2.new(0.9, 0, 0, 10) 
    topPadding.BackgroundTransparency = 1
end

-- Helper untuk membuat separator (menggunakan Frame, bukan posisi Y)
local function createLayoutSeparator(parent)
    local sepContainer = Instance.new("Frame", parent)
    sepContainer.Size = UDim2.new(0.9, 0, 0, 12) 
    sepContainer.BackgroundTransparency = 1 
    
    local sep = Instance.new("Frame", sepContainer)
    sep.Size = UDim2.new(1, 0, 0, 2)
    sep.Position = UDim2.new(0, 0, 0.5, -1)
    sep.BackgroundColor3 = Color3.fromRGB(40, 40, 40) 
    sep.Parent = sepContainer
end


-- AUTO PAGE (MENGGUNAKAN ScrollingFrame untuk daftar CP)
local autoPage=Instance.new("ScrollingFrame",content) 
autoPage.Name="Auto"
autoPage.Size=UDim2.new(1,0,1,0)
autoPage.BackgroundTransparency=1
autoPage.ScrollBarThickness=6
autoPage.ScrollBarInset = Enum.ScrollBarInset.Always 
autoPage.CanvasSize = UDim2.new(0,0,0, 480) -- Manual size karena ada sub-scrolling frame, nanti bisa disesuaikan
autoPage.Visible=true 

-- [Konten Auto Page]
local startBtn=Instance.new("TextButton",autoPage)
startBtn.Size=UDim2.new(0.9,0,0,35)
startBtn.Position=UDim2.new(0.05,0,0,10)
startBtn.Text="Mulai Auto Summit"
startBtn.BackgroundColor3=Color3.fromRGB(30,30,30)
startBtn.TextColor3=Color3.new(1,1,1)
startBtn.Font=Enum.Font.GothamBold

local stopBtn=startBtn:Clone()
stopBtn.Text="Stop Auto Summit"
stopBtn.Position=UDim2.new(0.05,0,0,55)
stopBtn.Parent=autoPage

local resetBtn=startBtn:Clone()
resetBtn.Text="Reset CP Index (Mulai dari Awal)"
resetBtn.Position=UDim2.new(0.05,0,0,100)
resetBtn.BackgroundColor3 = Color3.fromRGB(150,50,50)
resetBtn.Parent=autoPage

resetBtn.MouseButton1Click:Connect(function()
    currentCpIndex = 1
    notify("Checkpoint Index Reset ke Basecamp (CP #1)", Color3.fromRGB(255,100,0))
end)

-- SCROLLING FRAME UNTUK DAFTAR CP (Sub-scrollingframe)
local scroll=Instance.new("ScrollingFrame",autoPage) -- TETAP SCROLLING FRAME
scroll.Size=UDim2.new(0.9,0,0,250) 
scroll.Position=UDim2.new(0.05,0,0,145)
scroll.CanvasSize=UDim2.new(0,0,0,#checkpoints*35)
scroll.ScrollBarThickness=6
scroll.ScrollBarInset = Enum.ScrollBarInset.Always 
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


-- SERVER PAGE (ScrollingFrame DENGAN AUTO SIZE)
local serverPage=Instance.new("ScrollingFrame",content) 
serverPage.Name="Server"
serverPage.Size=UDim2.new(1,0,1,0)
serverPage.BackgroundTransparency=1
serverPage.ScrollBarThickness=6
serverPage.ScrollBarInset = Enum.ScrollBarInset.Always 
serverPage.AutomaticCanvasSize = Enum.AutomaticCanvasSize.Y -- KUNCI: Hitung CanvasSize otomatis
serverPage.Visible=false 

setupLayout(serverPage) -- Terapkan Layout

-- 1. KELOMPOK 1: AUTO LOOP CONTROL
local group1Header = Instance.new("TextLabel", serverPage)
group1Header.Size = UDim2.new(0.9, 0, 0, 20)
group1Header.Text = "AUTO LOOP CONTROL"
group1Header.TextColor3 = Color3.fromRGB(200, 200, 200)
group1Header.BackgroundTransparency = 1
group1Header.Font = Enum.Font.GothamBold

-- 1.1 TOGGLE AUTO REPEAT
local repeatToggle=Instance.new("TextButton",serverPage)
repeatToggle.Size=UDim2.new(0.9,0,0,35)
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

-- 1.2 AUTO DEATH TOGGLE
local deathToggle=repeatToggle:Clone()
deathToggle.Text="Auto Death: OFF"
deathToggle.Parent = serverPage

deathToggle.MouseButton1Click:Connect(function()
    autoDeath=not autoDeath
    deathToggle.Text="Auto Death: "..(autoDeath and "ON" or "OFF")
    deathToggle.BackgroundColor3=autoDeath and Color3.fromRGB(0,200,0) or Color3.fromRGB(200,0,0)
end)

createLayoutSeparator(serverPage) -- Garis Pemisah 1

-- 2. KELOMPOK 2: SERVER HOP
local group2Header = Instance.new("TextLabel", serverPage)
group2Header.Size = UDim2.new(0.9, 0, 0, 20)
group2Header.Text = "SERVER HOP CONTROL"
group2Header.TextColor3 = Color3.fromRGB(200, 200, 200)
group2Header.BackgroundTransparency = 1
group2Header.Font = Enum.Font.GothamBold

-- 2.1 Server Hop Toggle
local serverToggle=repeatToggle:Clone()
serverToggle.Text="Server Hop: OFF"
serverToggle.Parent = serverPage

serverToggle.MouseButton1Click:Connect(function()
    serverHop=not serverHop
    serverToggle.Text="Server Hop: "..(serverHop and "ON" or "OFF")
    serverToggle.BackgroundColor3=serverHop and Color3.fromRGB(0,200,0) or Color3.fromRGB(200,0,0)
end)

-- 2.2 Summit Limit Box
local limitBox=Instance.new("TextBox",serverPage)
limitBox.Size=UDim2.new(0.9,0,0,30)
limitBox.Text=tostring(summitLimit)
limitBox.PlaceholderText="Batas Summit (default 20)"
limitBox.BackgroundColor3=Color3.fromRGB(30,30,30)
limitBox.TextColor3=Color3.new(1,1,1)
limitBox.Font=Enum.Font.Gotham
limitBox.FocusLost:Connect(function()
    local v=tonumber(limitBox.Text)
    if v then summitLimit=v end
end)

createLayoutSeparator(serverPage) -- Garis Pemisah 2

-- 3. KELOMPOK 3: MANUAL ACTION & ANTI AFK
local group3Header = Instance.new("TextLabel", serverPage)
group3Header.Size = UDim2.new(0.9, 0, 0, 20)
group3Header.Text = "MANUAL ACTIONS & ANTI-AFK"
group3Header.TextColor3 = Color3.fromRGB(200, 200, 200)
group3Header.BackgroundTransparency = 1
group3Header.Font = Enum.Font.GothamBold

-- 3.1 TOGGLE ANTI-AFK 
local afkToggle=repeatToggle:Clone()
afkToggle.Text="Anti-AFK: OFF"
afkToggle.Parent = serverPage

afkToggle.MouseButton1Click:Connect(function()
    toggleAntiAFK(not antiAFK)
    afkToggle.Text="Anti-AFK: "..(antiAFK and "ON" or "OFF")
    afkToggle.BackgroundColor3=antiAFK and Color3.fromRGB(0,200,0) or Color3.fromRGB(200,0,0)
end)

-- 3.2 Manual Death
local manualDeath=deathToggle:Clone()
manualDeath.Text="Manual Death"
manualDeath.BackgroundColor3=Color3.fromRGB(80,80,80)
manualDeath.Parent=serverPage
manualDeath.MouseButton1Click:Connect(function()
    if player.Character then player.Character:BreakJoints() end
end)

-- 3.3 Manual Hop
local manualHop=serverToggle:Clone()
manualHop.Text="Ganti Server Manual"
manualHop.BackgroundColor3=Color3.fromRGB(80,80,80)
manualHop.Parent=serverPage
manualHop.MouseButton1Click:Connect(function()
    TeleportService:Teleport(game.PlaceId, player)
end)

-- =========================================================================

-- SETTING PAGE (ScrollingFrame DENGAN AUTO SIZE)
local setPage=Instance.new("ScrollingFrame",content)
setPage.Name="Setting"
setPage.Size=UDim2.new(1,0,1,0)
setPage.BackgroundTransparency=1
setPage.ScrollBarThickness=6
setPage.ScrollBarInset = Enum.ScrollBarInset.Always
setPage.AutomaticCanvasSize = Enum.AutomaticCanvasSize.Y -- KUNCI: Hitung CanvasSize otomatis
setPage.Visible=false 

setupLayout(setPage) -- Terapkan Layout

local delayBox=Instance.new("TextBox",setPage)
delayBox.Size=UDim2.new(0.9,0,0,30)
delayBox.Text=tostring(delayTime)
delayBox.PlaceholderText="Delay detik"
delayBox.BackgroundColor3=Color3.fromRGB(30,30,30)
delayBox.TextColor3=Color3.new(1,1,1)
delayBox.FocusLost:Connect(function()
    local v=tonumber(delayBox.Text)
    if v then delayTime=v end
end)

local speedBox=Instance.new("TextBox",setPage)
speedBox.Size=UDim2.new(0.9,0,0,30)
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

createLayoutSeparator(setPage)

local opacityLabel = Instance.new("TextLabel", setPage)
opacityLabel.Size = UDim2.new(0.9, 0, 0, 20)
opacityLabel.Text = "GUI Opacity: "..string.format("%.2f", guiOpacity)
opacityLabel.BackgroundTransparency = 1
opacityLabel.TextColor3 = Color3.new(1,1,1)
opacityLabel.Font = Enum.Font.GothamBold
opacityLabel.TextXAlignment = Enum.TextXAlignment.Left

local sliderContainer = Instance.new("Frame", setPage)
sliderContainer.Size = UDim2.new(0.9, 0, 0, 20)
sliderContainer.BackgroundTransparency = 1
local slider = Instance.new("Frame", sliderContainer)
slider.Size = UDim2.new(1, 0, 1, 0)
slider.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
slider.Position = UDim2.new(0,0,0,0)


local sliderHandle = Instance.new("TextButton", slider)
sliderHandle.Size = UDim2.new(0, 20, 1, 0)
sliderHandle.Position = UDim2.new(guiOpacity, -10, 0, 0)
sliderHandle.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
sliderHandle.Text = ""

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


-- INFO PAGE (ScrollingFrame DENGAN AUTO SIZE)
local infoPage=Instance.new("ScrollingFrame",content)
infoPage.Name="Info"
infoPage.Size=UDim2.new(1,0,1,0)
infoPage.BackgroundTransparency=1
infoPage.ScrollBarThickness=6
infoPage.ScrollBarInset = Enum.ScrollBarInset.Always
infoPage.AutomaticCanvasSize = Enum.AutomaticCanvasSize.Y -- KUNCI: Hitung CanvasSize otomatis
infoPage.Visible=false 

setupLayout(infoPage)

local infoText=Instance.new("TextLabel",infoPage)
infoText.Size=UDim2.new(0.9,0,0,130) -- Beri ukuran Y yang cukup untuk teks
infoText.BackgroundTransparency=1
infoText.Text="Created by BynzzBponjon\nAuto Summit GUI (Clean Final)\n\nVersion: V23 (Auto Scroll)\nFitur:\n- Auto Summit dan Loop\n- Anti-AFK (Server Page)\n- Slider Opacity GUI (Setting Page)\n- Semua Menu Sekarang Bisa Di-Scroll (Otomatis)"
infoText.TextColor3=Color3.new(1,1,1)
infoText.Font=Enum.Font.Gotham
infoText.TextWrapped=true
infoText.TextXAlignment = Enum.TextXAlignment.Left


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


local startCpName = checkpoints[currentCpIndex].name
notify("BynzzBponjon GUI (V23) Loaded. Semua menu sekarang bisa di-scroll secara otomatis!",Color3.fromRGB(0,200,100))
