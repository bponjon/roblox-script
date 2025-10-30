--// BYNZZBPONJON FINAL GUI (CLEAN LAYOUT) //--

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
local autoSummit, autoDeath, serverHop = false, false, false
local summitCount, summitLimit, delayTime, walkSpeed = 0, 20, 5, 16

local function notify(txt)
	local n = Instance.new("TextLabel", playerGui)
	n.Size = UDim2.new(0, 400, 0, 35)
	n.Position = UDim2.new(0.5, -200, 0.05, 0)
	n.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	n.TextColor3 = Color3.fromRGB(255, 255, 255)
	n.Font = Enum.Font.GothamBold
	n.TextScaled = true
	n.Text = txt
	n.BackgroundTransparency = 0.2
	game:GetService("Debris"):AddItem(n, 2)
end

-- clear old
if playerGui:FindFirstChild("BynzzBponjon") then
	playerGui.BynzzBponjon:Destroy()
end

local gui = Instance.new("ScreenGui", playerGui)
gui.Name = "BynzzBponjon"
gui.ResetOnSpawn = false

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 520, 0, 400)
main.Position = UDim2.new(0.25, 0, 0.25, 0)
main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
main.BorderSizePixel = 0
main.Active, main.Draggable = true, true

local header = Instance.new("Frame", main)
header.Size = UDim2.new(1, 0, 0, 30)
header.BackgroundColor3 = Color3.fromRGB(40, 40, 40)

local title = Instance.new("TextLabel", header)
title.Size = UDim2.new(0.6, 0, 1, 0)
title.Position = UDim2.new(0.03, 0, 0, 0)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextColor3 = Color3.new(1, 1, 1)
title.Text = "BynzzBponjon GUI"

local hideBtn = Instance.new("TextButton", header)
hideBtn.Size = UDim2.new(0.2, 0, 1, 0)
hideBtn.Position = UDim2.new(0.6, 0, 0, 0)
hideBtn.Text = "Hide"
hideBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
hideBtn.TextColor3 = Color3.new(1, 1, 1)
hideBtn.Font = Enum.Font.GothamBold

local closeBtn = hideBtn:Clone()
closeBtn.Text = "Close"
closeBtn.Position = UDim2.new(0.8, 0, 0, 0)
closeBtn.Parent = header

closeBtn.MouseButton1Click:Connect(function() gui:Destroy() end)

-- left panel
local left = Instance.new("Frame", main)
left.Size = UDim2.new(0, 130, 1, -30)
left.Position = UDim2.new(0, 0, 0, 30)
left.BackgroundColor3 = Color3.fromRGB(5, 5, 5)

-- right panel
local right = Instance.new("Frame", main)
right.Size = UDim2.new(1, -130, 1, -30)
right.Position = UDim2.new(0, 130, 0, 30)
right.BackgroundColor3 = Color3.fromRGB(10, 10, 10)

-- content
local content = Instance.new("Frame", right)
content.Size = UDim2.new(1, 0, 1, 0)
content.BackgroundTransparency = 1

local function showPage(name)
	for _, v in pairs(content:GetChildren()) do v.Visible = false end
	if content:FindFirstChild(name) then content[name].Visible = true end
end

local pages = {"Auto", "Server", "Setting", "Info", "AutoDeath"}
for i, v in ipairs(pages) do
	local b = Instance.new("TextButton", left)
	b.Size = UDim2.new(0.9, 0, 0, 35)
	b.Position = UDim2.new(0.05, 0, 0, 10 + (i - 1) * 45)
	b.Text = v
	b.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
	b.TextColor3 = Color3.new(1, 1, 1)
	b.Font = Enum.Font.GothamBold
	b.MouseButton1Click:Connect(function() showPage(v) end)
end

-- AUTO PAGE
local autoPage = Instance.new("Frame", content)
autoPage.Name = "Auto"
autoPage.Size = UDim2.new(1, 0, 1, 0)
autoPage.BackgroundTransparency = 1
autoPage.Visible = true

local startBtn = Instance.new("TextButton", autoPage)
startBtn.Size = UDim2.new(0.9, 0, 0, 35)
startBtn.Position = UDim2.new(0.05, 0, 0, 10)
startBtn.Text = "Mulai Auto Summit"
startBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
startBtn.TextColor3 = Color3.new(1, 1, 1)
startBtn.Font = Enum.Font.GothamBold

local stopBtn = startBtn:Clone()
stopBtn.Text = "Stop Auto Summit"
stopBtn.Position = UDim2.new(0.05, 0, 0, 55)
stopBtn.Parent = autoPage

-- scroll checkpoints
local scroll = Instance.new("ScrollingFrame", autoPage)
scroll.Size = UDim2.new(0.9, 0, 0, 200)
scroll.Position = UDim2.new(0.05, 0, 0, 100)
scroll.CanvasSize = UDim2.new(0, 0, 0, #checkpoints * 35)
scroll.ScrollBarThickness = 6
scroll.BackgroundColor3 = Color3.fromRGB(15, 15, 15)

for i, cp in ipairs(checkpoints) do
	local b = Instance.new("TextButton", scroll)
	b.Size = UDim2.new(1, 0, 0, 30)
	b.Position = UDim2.new(0, 0, 0, (i - 1) * 35)
	b.Text = cp.name
	b.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
	b.TextColor3 = Color3.new(1, 1, 1)
	b.Font = Enum.Font.Gotham
	b.MouseButton1Click:Connect(function()
		if player.Character and player.Character.PrimaryPart then
			player.Character:SetPrimaryPartCFrame(CFrame.new(cp.pos))
			notify("Teleported to " .. cp.name)
		end
	end)
end

-- HIDE FUNCTION
local hidden = false
hideBtn.MouseButton1Click:Connect(function()
	hidden = not hidden
	for _, v in pairs(main:GetChildren()) do
		if v ~= header then v.Visible = not hidden end
	end
end)

notify("GUI BynzzBponjon (Layout Clean) Loaded ✅")
