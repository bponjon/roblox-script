--// BynzzBponjon GUI Fix v2
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local RunService = game:GetService("RunService")

local char = player.Character or player.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")

local delaySeconds = 10
local walkSpeedValue = 16
local autoSummitActive = false
local currentIndex = 1
local checkpoints = {
    {name="Basecamp", pos=Vector3.new(-883.288,43.358,933.698)},
    {name="CP1", pos=Vector3.new(-473.240,49.167,624.194)},
    {name="CP2", pos=Vector3.new(-182.927,52.412,691.074)},
    {name="Puncak", pos=Vector3.new(-1534.938,933.116,-2176.096)},
}

-- Notif
local function showNotif(txt)
    local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
    gui.ResetOnSpawn = false
    local t = Instance.new("TextLabel", gui)
    t.Size = UDim2.new(0,300,0,40)
    t.Position = UDim2.new(0.5,-150,0.05,0)
    t.BackgroundColor3 = Color3.fromRGB(20,20,20)
    t.TextColor3 = Color3.fromRGB(255,255,255)
    t.Text = txt
    t.Font = Enum.Font.GothamBold
    t.TextSize = 18
    game:GetService("Debris"):AddItem(gui,2)
end

-- GUI
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "BynzzBponjon"
gui.ResetOnSpawn = false

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0,520,0,380)
main.Position = UDim2.new(0.05,0,0.1,0)
main.BackgroundColor3 = Color3.fromRGB(15,15,15)
main.Active = true
main.Draggable = true

-- Header
local head = Instance.new("Frame", main)
head.Size = UDim2.new(1,0,0,30)
head.BackgroundColor3 = Color3.fromRGB(40,40,40)

local title = Instance.new("TextLabel", head)
title.Size = UDim2.new(0.7,0,1,0)
title.Position = UDim2.new(0,10,0,0)
title.BackgroundTransparency = 1
title.Text = "BynzzBponjon"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextXAlignment = Enum.TextXAlignment.Left

-- Hide & Close
local hideBtn = Instance.new("TextButton", head)
hideBtn.Size = UDim2.new(0,60,0,24)
hideBtn.Position = UDim2.new(0.75,0,0.1,0)
hideBtn.BackgroundColor3 = Color3.fromRGB(0,120,200)
hideBtn.Text = "Hide"
hideBtn.TextColor3 = Color3.new(1,1,1)
hideBtn.Font = Enum.Font.GothamBold
hideBtn.TextSize = 14

local closeBtn = Instance.new("TextButton", head)
closeBtn.Size = UDim2.new(0,50,0,24)
closeBtn.Position = UDim2.new(0.88,0,0.1,0)
closeBtn.BackgroundColor3 = Color3.fromRGB(200,0,50)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.new(1,1,1)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 14

-- Panel kiri
local left = Instance.new("Frame", main)
left.Size = UDim2.new(0,120,1,-30)
left.Position = UDim2.new(0,0,0,30)
left.BackgroundColor3 = Color3.fromRGB(0,0,0)

local right = Instance.new("Frame", main)
right.Size = UDim2.new(0,400,1,-30)
right.Position = UDim2.new(0,120,0,30)
right.BackgroundColor3 = Color3.fromRGB(10,10,10)

local pages = {}

local function newPage(name)
    local f = Instance.new("Frame", right)
    f.Size = UDim2.new(1,0,1,0)
    f.BackgroundTransparency = 1
    f.Visible = false
    pages[name] = f
    return f
end

local function newButton(name,y)
    local b = Instance.new("TextButton", left)
    b.Size = UDim2.new(1,0,0,40)
    b.Position = UDim2.new(0,0,0,y)
    b.BackgroundColor3 = Color3.fromRGB(30,30,30)
    b.TextColor3 = Color3.new(1,1,1)
    b.Text = name
    b.Font = Enum.Font.GothamBold
    b.TextSize = 16
    return b
end

-- Buat menu
local autoPage = newPage("Auto")
local serverPage = newPage("Server")
local settingPage = newPage("Setting")
local infoPage = newPage("Info")
local deathPage = newPage("Auto Death")

-- Tombol kiri
local autoBtn = newButton("Auto",0)
local serverBtn = newButton("Server",0.12)
local settingBtn = newButton("Setting",0.24)
local infoBtn = newButton("Info",0.36)
local deathBtn = newButton("Auto Death",0.48)

local allBtns = {autoBtn,serverBtn,settingBtn,infoBtn,deathBtn}
local function openPage(p)
    for _,v in pairs(pages) do v.Visible=false end
    for _,v in pairs(allBtns) do v.BackgroundColor3=Color3.fromRGB(30,30,30) end
    p.Visible=true
end

autoBtn.MouseButton1Click:Connect(function() openPage(autoPage) autoBtn.BackgroundColor3=Color3.fromRGB(0,120,200) end)
serverBtn.MouseButton1Click:Connect(function() openPage(serverPage) serverBtn.BackgroundColor3=Color3.fromRGB(0,120,200) end)
settingBtn.MouseButton1Click:Connect(function() openPage(settingPage) settingBtn.BackgroundColor3=Color3.fromRGB(0,120,200) end)
infoBtn.MouseButton1Click:Connect(function() openPage(infoPage) infoBtn.BackgroundColor3=Color3.fromRGB(0,120,200) end)
deathBtn.MouseButton1Click:Connect(function() openPage(deathPage) deathBtn.BackgroundColor3=Color3.fromRGB(0,120,200) end)

-- Hide system
local hidden = false
hideBtn.MouseButton1Click:Connect(function()
    hidden = not hidden
    left.Visible = not hidden
    right.Visible = not hidden
    if hidden then
        hideBtn.Text = "Show"
    else
        hideBtn.Text = "Hide"
    end
end)

closeBtn.MouseButton1Click:Connect(function() gui:Destroy() end)

-- Auto Page isi
local startBtn = Instance.new("TextButton", autoPage)
startBtn.Size = UDim2.new(0,150,0,40)
startBtn.Position = UDim2.new(0,20,0,20)
startBtn.Text = "Mulai Auto Summit"
startBtn.BackgroundColor3 = Color3.fromRGB(0,150,0)
startBtn.TextColor3 = Color3.new(1,1,1)
startBtn.Font = Enum.Font.GothamBold

local stopBtn = Instance.new("TextButton", autoPage)
stopBtn.Size = UDim2.new(0,150,0,40)
stopBtn.Position = UDim2.new(0,20,0,70)
stopBtn.Text = "Stop Auto Summit"
stopBtn.BackgroundColor3 = Color3.fromRGB(200,0,0)
stopBtn.TextColor3 = Color3.new(1,1,1)
stopBtn.Font = Enum.Font.GothamBold

startBtn.MouseButton1Click:Connect(function()
    if autoSummitActive then return end
    autoSummitActive = true
    showNotif("Auto Summit Started")
    spawn(function()
        for i=1,#checkpoints do
            if not autoSummitActive then break end
            local cp = checkpoints[i]
            if player.Character and player.Character.PrimaryPart then
                player.Character:SetPrimaryPartCFrame(CFrame.new(cp.pos))
            end
            task.wait(delaySeconds)
        end
        showNotif("Auto Summit Done")
        autoSummitActive = false
    end)
end)

stopBtn.MouseButton1Click:Connect(function()
    autoSummitActive = false
    showNotif("Stopped Auto Summit")
end)

-- Setting page isi
local dLabel = Instance.new("TextLabel", settingPage)
dLabel.Size = UDim2.new(0,150,0,30)
dLabel.Position = UDim2.new(0,20,0,20)
dLabel.Text = "Delay (detik):"
dLabel.TextColor3 = Color3.new(1,1,1)
dLabel.BackgroundTransparency = 1

local dBox = Instance.new("TextBox", settingPage)
dBox.Size = UDim2.new(0,100,0,30)
dBox.Position = UDim2.new(0,180,0,20)
dBox.Text = tostring(delaySeconds)
dBox.TextColor3 = Color3.new(1,1,1)
dBox.BackgroundColor3 = Color3.fromRGB(40,40,40)
dBox.Font = Enum.Font.Gotham
dBox.TextSize = 14

local sLabel = Instance.new("TextLabel", settingPage)
sLabel.Size = UDim2.new(0,150,0,30)
sLabel.Position = UDim2.new(0,20,0,70)
sLabel.Text = "WalkSpeed:"
sLabel.TextColor3 = Color3.new(1,1,1)
sLabel.BackgroundTransparency = 1

local sBox = Instance.new("TextBox", settingPage)
sBox.Size = UDim2.new(0,100,0,30)
sBox.Position = UDim2.new(0,180,0,70)
sBox.Text = tostring(walkSpeedValue)
sBox.TextColor3 = Color3.new(1,1,1)
sBox.BackgroundColor3 = Color3.fromRGB(40,40,40)
sBox.Font = Enum.Font.Gotham
sBox.TextSize = 14

-- fungsi realtime
dBox.FocusLost:Connect(function()
    local v = tonumber(dBox.Text)
    if v and v>0 then delaySeconds = v showNotif("Delay diubah ke "..v.." detik") end
end)
sBox.FocusLost:Connect(function()
    local v = tonumber(sBox.Text)
    if v and v>0 then walkSpeedValue = v hum.WalkSpeed = v showNotif("Speed diubah ke "..v) end
end)

-- Info isi
local infoText = Instance.new("TextLabel", infoPage)
infoText.Size = UDim2.new(1,-20,1,-20)
infoText.Position = UDim2.new(0,10,0,10)
infoText.TextWrapped = true
infoText.TextColor3 = Color3.new(1,1,1)
infoText.Text = "BynzzBponjon GUI v2\nCreated by ChatGPT (Fix all function)"
infoText.Font = Enum.Font.GothamBold
infoText.TextSize = 16

openPage(autoPage)
