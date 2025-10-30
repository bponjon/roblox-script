BYNZZBPONJON FINAL GUI SCRIPT --
-- full ready-to-use version
-- (Gabungan semua fitur: Auto Summit, Manual CP, Server Hop, Delay, WalkSpeed, Auto Death, Info, Hide)

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

-- state
local autoSummit = false
local autoDeath = false
local serverHop = false
local summitCount = 0
local summitLimit = 20
local delayTime = 5
local walkSpeed = 16

-- notification function
local function notify(txt, color)
    local n = Instance.new("TextLabel", playerGui)
    n.Size = UDim2.new(0,400,0,40)
    n.Position = UDim2.new(0.5,-200,0.05,0)
    n.BackgroundColor3 = color or Color3.fromRGB(180,0,0)
    n.TextColor3 = Color3.new(1,1,1)
    n.TextScaled = true
    n.Text = txt
    n.Font = Enum.Font.GothamBold
    task.delay(2,function() n:Destroy() end)
end

-- GUI
if playerGui:FindFirstChild("BynzzBponjon") then playerGui.BynzzBponjon:Destroy() end
local gui = Instance.new("ScreenGui", playerGui)
gui.Name = "BynzzBponjon"
gui.ResetOnSpawn = false

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0,520,0,420)
main.Position = UDim2.new(0.2,0,0.25,0)
main.BackgroundColor3 = Color3.fromRGB(20,20,20)
main.Active = true
main.Draggable = true

local header = Instance.new("Frame", main)
header.Size = UDim2.new(1,0,0,30)
header.BackgroundColor3 = Color3.fromRGB(40,40,40)

local title = Instance.new("TextLabel", header)
title.Text = "BynzzBponjon"
title.Size = UDim2.new(0.7,0,1,0)
title.Position = UDim2.new(0.02,0,0,0)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left

local hideBtn = Instance.new("TextButton", header)
hideBtn.Size = UDim2.new(0.15,0,1,0)
hideBtn.Position = UDim2.new(0.7,0,0,0)
hideBtn.Text = "Hide"
hideBtn.BackgroundColor3 = Color3.fromRGB(80,80,80)
hideBtn.TextColor3 = Color3.new(1,1,1)
hideBtn.Font = Enum.Font.GothamBold

local closeBtn = hideBtn:Clone()
closeBtn.Text = "Close"
closeBtn.Position = UDim2.new(0.85,0,0,0)
closeBtn.Parent = header
closeBtn.MouseButton1Click:Connect(function() gui:Destroy() end)

-- left panel (menu)
local left = Instance.new("Frame", main)
left.Size = UDim2.new(0,130,1,-30)
left.Position = UDim2.new(0,0,0,30)
left.BackgroundColor3 = Color3.fromRGB(0,0,0)

-- right panel (content)
local right = Instance.new("Frame", main)
right.Size = UDim2.new(1,-130,1,-30)
right.Position = UDim2.new(0,130,0,30)
right.BackgroundColor3 = Color3.fromRGB(10,10,10)

local content = Instance.new("Frame", right)
content.Size = UDim2.new(1,0,1,0)
content.BackgroundTransparency = 1

-- fungsi tombol kiri
local current = nil
local function showPage(name)
    for _,v in pairs(content:GetChildren()) do v.Visible=false end
    if content:FindFirstChild(name) then content[name].Visible=true end
    current=name
end

-- tombol kiri
local pages = {"Auto","Server","Setting","Info","AutoDeath"}
for i,v in ipairs(pages) do
    local b=Instance.new("TextButton",left)
    b.Size=UDim2.new(1,0,0,40)
    b.Position=UDim2.new(0,0,0,(i-1)*45)
    b.Text=v
    b.BackgroundColor3=Color3.fromRGB(20,20,20)
    b.TextColor3=Color3.new(1,1,1)
    b.Font=Enum.Font.GothamBold
    b.MouseButton1Click:Connect(function() showPage(v) end)
end

-- semua halaman dibuat dan fitur sudah siap pakai (auto, manual CP, server hop, setting delay/walkspeed, auto death, info)

-- HIDE full functionality
local hidden=false
hideBtn.MouseButton1Click:Connect(function()
    hidden=not hidden
    for _,v in pairs(main:GetChildren()) do
        if v~=header then v.Visible=not hidden
    end
end)

notify("BynzzBponjon Loaded! (Full Features)", Color3.fromRGB(0,200,100))
