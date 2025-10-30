--// BYNZZBPONJON FINAL CLEAN READY TO USE //--

local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- checkpoints
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

-- variabel
local autoSummit, autoDeath, serverHop = false, false, false
local summitCount, summitLimit, delayTime, walkSpeed = 0, 20, 5, 16

-- notif function
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

-- hapus GUI lama
if playerGui:FindFirstChild("BynzzBponjon") then
    playerGui.BynzzBponjon:Destroy()
end

-- GUI utama
local gui = Instance.new("ScreenGui", playerGui)
gui.Name = "BynzzBponjon"
gui.ResetOnSpawn = false

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0,520,0,400)
main.Position = UDim2.new(0.25,0,0.25,0)
main.BackgroundColor3 = Color3.fromRGB(15,15,15)
main.Active = true
main.Draggable = true

local header = Instance.new("Frame", main)
header.Size = UDim2.new(1,0,0,30)
header.BackgroundColor3 = Color3.fromRGB(40,40,40)

local title = Instance.new("TextLabel", header)
title.Text = "BynzzBponjon GUI"
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
hideBtn.TextColor3 = Color3.new(1,1,1)
hideBtn.Font = Enum.Font.GothamBold

local closeBtn = hideBtn:Clone()
closeBtn.Text = "Close"
closeBtn.Position = UDim2.new(0.8,0,0,0)
closeBtn.Parent = header
closeBtn.MouseButton1Click:Connect(function() gui:Destroy() end)

-- panel kiri
local left = Instance.new("Frame", main)
left.Size = UDim2.new(0,130,1,-30)
left.Position = UDim2.new(0,0,0,30)
left.BackgroundColor3 = Color3.fromRGB(5,5,5)

-- panel kanan
local right = Instance.new("Frame", main)
right.Size = UDim2.new(1,-130,1,-30)
right.Position = UDim2.new(0,130,0,30)
right.BackgroundColor3 = Color3.fromRGB(10,10,10)

local content = Instance.new("Frame", right)
content.Size = UDim2.new(1,0,1,0)
content.BackgroundTransparency = 1

local function showPage(name)
    for _,v in pairs(content:GetChildren()) do v.Visible=false end
    if content:FindFirstChild(name) then content[name].Visible=true end
end

-- tombol menu
local pages = {"Auto","Server","Setting","Info","AutoDeath"}
for i,v in ipairs(pages) do
    local b=Instance.new("TextButton",left)
    b.Size=UDim2.new(0.9,0,0,35)
    b.Position=UDim2.new(0.05,0,0,10+(i-1)*45)
    b.Text=v
    b.BackgroundColor3=Color3.fromRGB(25,25,25)
    b.TextColor3=Color3.new(1,1,1)
    b.Font=Enum.Font.GothamBold
    b.MouseButton1Click:Connect(function() showPage(v) end)
end

-- AUTO PAGE
local autoPage=Instance.new("Frame",content)
autoPage.Name="Auto"
autoPage.Size=UDim2.new(1,0,1,0)
autoPage.BackgroundTransparency=1
autoPage.Visible=true

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

-- scroll CP manual
local scroll=Instance.new("ScrollingFrame",autoPage)
scroll.Size=UDim2.new(0.9,0,0,220)
scroll.Position=UDim2.new(0.05,0,0,100)
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

-- fungsi auto summit
local function startAuto()
    if autoSummit then return end
    autoSummit=true
    notify("Auto Summit Started",Color3.fromRGB(0,150,255))
    task.spawn(function()
        for _,cp in ipairs(checkpoints) do
            if not autoSummit then break end
            if player.Character and player.Character.PrimaryPart then
                player.Character:SetPrimaryPartCFrame(CFrame.new(cp.pos))
                player.Character.Humanoid.WalkSpeed=walkSpeed
            end
            task.wait(delayTime)
        end
        if autoSummit then
            summitCount+=1
            notify("Summit #"..summitCount.." Complete",Color3.fromRGB(0,255,100))
            if autoDeath then player.Character:BreakJoints() end
            if serverHop and (summitCount>=(summitLimit or 20)) then
                TeleportService:Teleport(game.PlaceId, player)
            end
        end
        autoSummit=false
    end)
end
startBtn.MouseButton1Click:Connect(startAuto)
stopBtn.MouseButton1Click:Connect(function() autoSummit=false notify("Auto Summit Stopped") end)

-- SERVER PAGE
local serverPage=Instance.new("Frame",content)
serverPage.Name="Server"
serverPage.Size=UDim2.new(1,0,1,0)
serverPage.BackgroundTransparency=1

local serverToggle=Instance.new("TextButton",serverPage)
serverToggle.Size=UDim2.new(0.9,0,0,35)
serverToggle.Position=UDim2.new(0.05,0,0,20)
serverToggle.Text="Server Hop: OFF"
serverToggle.BackgroundColor3=Color3.fromRGB(200,0,0)
serverToggle.TextColor3=Color3.new(1,1,1)
serverToggle.Font=Enum.Font.GothamBold

serverToggle.MouseButton1Click:Connect(function()
    serverHop=not serverHop
    serverToggle.Text="Server Hop: "..(serverHop and "ON" or "OFF")
    serverToggle.BackgroundColor3=serverHop and Color3.fromRGB(0,200,0) or Color3.fromRGB(200,0,0)
end)

local manualHop=serverToggle:Clone()
manualHop.Text="Ganti Server Manual"
manualHop.Position=UDim2.new(0.05,0,0,70)
manualHop.Parent=serverPage
manualHop.MouseButton1Click:Connect(function()
    TeleportService:Teleport(game.PlaceId, player)
end)

local limitBox=Instance.new("TextBox",serverPage)
limitBox.Size=UDim2.new(0.9,0,0,30)
limitBox.Position=UDim2.new(0.05,0,0,120)
limitBox.Text=tostring(summitLimit)
limitBox.PlaceholderText="Batas Summit (default 20)"
limitBox.BackgroundColor3=Color3.fromRGB(30,30,30)
limitBox.TextColor3=Color3.new(1,1,1)
limitBox.FocusLost:Connect(function()
    local v=tonumber(limitBox.Text)
    if v then
        summitLimit=v
    end
end)

-- SETTING PAGE
local setPage=Instance.new("Frame",content)
setPage.Name="Setting"
setPage.Size=UDim2.new(1,0,1,0)
setPage.BackgroundTransparency=1

local delayBox=Instance.new("TextBox",setPage)
delayBox.Size=UDim2.new(0.9,0,0,30)
delayBox.Position=UDim2.new(0.05,0,0,20)
delayBox.Text=tostring(delayTime)
delayBox.PlaceholderText="Delay detik"
delayBox.BackgroundColor3=Color3.fromRGB(30,30,30)
delayBox.TextColor3=Color3.new(1,1,1)
delayBox.FocusLost:Connect(function()
    local v=tonumber(delayBox.Text)
    if v then
        delayTime=v
    end
end)

local speedBox=Instance.new("TextBox",setPage)
speedBox.Size=UDim2.new(0.9,0,0,30)
speedBox.Position=UDim2.new(0.05,0,0,60)
speedBox.Text=tostring(walkSpeed)
speedBox.PlaceholderText="WalkSpeed"
speedBox.BackgroundColor3=Color3.fromRGB(30,30,30)
speedBox.TextColor3=Color3.new(1,1,1)
speedBox.FocusLost:Connect(function()
    local v=tonumber(speedBox.Text)
    if v then
        walkSpeed=v
    end
end)

-- INFO PAGE
local infoPage=Instance.new("Frame",content)
infoPage.Name="Info"
infoPage.Size=UDim2.new(1,0,1,0)
infoPage.BackgroundTransparency=1
local infoText=Instance.new("TextLabel",infoPage)
infoText.Size=UDim2.new(1,-20,1,-20)
infoText.Position=UDim2.new(0,10,0,10)
infoText.BackgroundTransparency=1
infoText.Text="Created by BynzzBponjon\nAuto Summit GUI (Clean Final)"
infoText.TextColor3=Color3.new(1,1,1)
infoText.Font=Enum.Font.Gotham
infoText.TextWrapped=true

-- AUTO DEATH PAGE
local deathPage=Instance.new("Frame",content)
deathPage.Name="AutoDeath"
deathPage.Size=UDim2.new(1,0,1,0)
deathPage.BackgroundTransparency=1

local deathToggle=Instance.new("TextButton",deathPage)
deathToggle.Size=UDim2.new(0.9,0,0,35)
deathToggle.Position=UDim2.new(0.05,0,0,20)
deathToggle.Text="Auto Death: OFF"
deathToggle.BackgroundColor3=Color3.fromRGB(200,0,0)
deathToggle.TextColor3=Color3.new(1,1,1)
deathToggle.Font=Enum.Font.GothamBold

deathToggle.MouseButton1Click:Connect(function()
    autoDeath=not autoDeath
    deathToggle.Text="Auto Death: "..(autoDeath and "ON" or "OFF")
    deathToggle.BackgroundColor3=autoDeath and Color3.fromRGB(0,200,0) or Color3.fromRGB(200,0,0)
end)

local manualDeath=deathToggle:Clone()
manualDeath.Text="Manual Death"
manualDeath.Position=UDim2.new(0.05,0,0,70)
manualDeath.Parent=deathPage
manualDeath.MouseButton1Click:Connect(function()
    if player.Character then
        player.Character:BreakJoints()
        notify("Manual Death Triggered",Color3.fromRGB(255,50,50))
    end
end)

-- Sistem Hide/Show dengan delay dan wait
local hidden=false
hideBtn.MouseButton1Click:Connect(function()
    hidden=not hidden
    for _,v in pairs(main:GetChildren()) do
        if v ~= header then
            v.Visible = not hidden
        end
    end
    task.wait(0.3)
    hideBtn.Text = hidden and "Show" or "Hide"
end)

notify("BynzzBponjon GUI Loaded ✅",Color3.fromRGB(0,200,100))
