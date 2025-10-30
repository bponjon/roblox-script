-- BynzzBponjon — Final Ready-to-Use LocalScript
-- Paste into a LocalScript / execute on client (PlayerGui)

local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- ====== Checkpoints (Koharu set yang lo kirim) ======
local checkpoints = {
	{name="Basecamp", pos=Vector3.new(-883.288, 43.358, 933.698)},
	{name="Checkpoint 1", pos=Vector3.new(-473.240, 49.167, 624.194)},
	{name="Checkpoint 2", pos=Vector3.new(-182.927, 52.412, 691.074)},
	{name="Checkpoint 3", pos=Vector3.new(122.499, 202.548, 951.741)},
	{name="Checkpoint 4", pos=Vector3.new(10.684, 194.377, 340.400)},
	{name="Checkpoint 5", pos=Vector3.new(244.394, 194.369, 805.065)},
	{name="Checkpoint 6", pos=Vector3.new(660.531, 210.886, 749.360)},
	{name="Checkpoint 7", pos=Vector3.new(660.649, 202.965, 368.070)},
	{name="Checkpoint 8", pos=Vector3.new(520.852, 214.338, 281.842)},
	{name="Checkpoint 9", pos=Vector3.new(523.730, 214.369, -333.936)},
	{name="Checkpoint 10", pos=Vector3.new(561.610, 211.787, -559.470)},
	{name="Checkpoint 11", pos=Vector3.new(566.837, 282.541, -924.107)},
	{name="Checkpoint 12", pos=Vector3.new(115.198, 286.309, -655.635)},
	{name="Checkpoint 13", pos=Vector3.new(-308.343, 410.144, -612.031)},
	{name="Checkpoint 14", pos=Vector3.new(-487.722, 522.666, -663.426)},
	{name="Checkpoint 15", pos=Vector3.new(-679.093, 482.701, -971.988)},
	{name="Checkpoint 16", pos=Vector3.new(-559.058, 258.369, -1318.780)},
	{name="Checkpoint 17", pos=Vector3.new(-426.353, 374.369, -1512.621)},
	{name="Checkpoint 18", pos=Vector3.new(-984.797, 635.003, -1621.875)},
	{name="Checkpoint 19", pos=Vector3.new(-1394.228, 797.455, -1563.855)},
	{name="Puncak", pos=Vector3.new(-1534.938, 933.116, -2176.096)}
}

-- ====== State defaults ======
local autoSummitActive = false
local autoDeath = false
local serverHopEnabled = false
local summitCount = 0
local summitLimit = 20 -- when serverHopEnabled true, after this many summits try hop
local delaySeconds = 10 -- default delay (seconds). user adjustable
local walkSpeed = 16 -- default walk speed
local currentIndex = 1 -- resume index for auto summit

-- ====== Helper functions ======
local function safeSetCFrame(vec)
	if player.Character and player.Character.PrimaryPart then
		pcall(function() player.Character:SetPrimaryPartCFrame(CFrame.new(vec)) end)
	end
end

local function applyWalkSpeedToHumanoid()
	local char = player.Character
	if not char then return end
	local humanoid = char:FindFirstChildOfClass("Humanoid")
	if humanoid then
		pcall(function() humanoid.WalkSpeed = walkSpeed end)
	end
end

local function notify(text, duration, bgColor)
	duration = duration or 2.5
	bgColor = bgColor or Color3.fromRGB(180,0,0)
	local frame = Instance.new("Frame", playerGui)
	frame.Size = UDim2.new(0, 420, 0, 48)
	frame.Position = UDim2.new(0.5, -210, 0.04, 0)
	frame.BackgroundColor3 = bgColor
	frame.BorderSizePixel = 0
	frame.ZIndex = 1000

	local label = Instance.new("TextLabel", frame)
	label.Size = UDim2.new(1, -10, 1, -6)
	label.Position = UDim2.new(0, 5, 0, 3)
	label.BackgroundTransparency = 1
	label.TextColor3 = Color3.new(1,1,1)
	label.Font = Enum.Font.GothamBold
	label.TextSize = 20
	label.Text = text
	label.TextWrapped = true

	-- fade-out + destroy after duration
	spawn(function()
		task.wait(duration)
		frame:Destroy()
	end)
end

local function serverHop()
	-- best-effort: fetch public servers & teleport to one with slots
	local ok, raw = pcall(function()
		return game:HttpGet("https://games.roblox.com/v1/games/" .. tostring(game.PlaceId) .. "/servers/Public?sortOrder=Asc&limit=100")
	end)
	if not ok or not raw then
		notify("Server hop failed (no response)", 3, Color3.fromRGB(200,50,50))
		return
	end

	local decodeOk, data = pcall(function() return HttpService:JSONDecode(raw) end)
	if not decodeOk or type(data) ~= "table" or not data.data then
		notify("Server hop failed (bad data)", 3, Color3.fromRGB(200,50,50))
		return
	end

	local candidates = {}
	for _,v in ipairs(data.data) do
		if type(v) == "table" and v.playing and v.maxPlayers and v.playing < v.maxPlayers then
			table.insert(candidates, v.id)
		end
	end

	if #candidates == 0 then
		notify("No server candidates found", 3, Color3.fromRGB(200,50,50))
		return
	end

	local pick = candidates[math.random(1, #candidates)]
	pcall(function()
		TeleportService:TeleportToPlaceInstance(game.PlaceId, pick, player)
	end)
end

-- when respawn, reapply walkspeed
player.CharacterAdded:Connect(function(char)
	task.defer(function()
		task.wait(0.5)
		applyWalkSpeedToHumanoid()
	end)
end)

-- ====== Build GUI ======
if playerGui:FindFirstChild("BynzzBponjonGui") then
	playerGui.BynzzBponjonGui:Destroy()
end

local screen = Instance.new("ScreenGui")
screen.Name = "BynzzBponjonGui"
screen.ResetOnSpawn = false
screen.Parent = playerGui

local main = Instance.new("Frame", screen)
main.Name = "Main"
main.Size = UDim2.new(0, 620, 0, 420)
main.Position = UDim2.new(0.15, 0, 0.12, 0)
main.BackgroundColor3 = Color3.fromRGB(18,18,18)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true

-- header (always stays visible; used for hide/unhide & dragging)
local header = Instance.new("Frame", main)
header.Size = UDim2.new(1, 0, 0, 36)
header.Position = UDim2.new(0,0,0,0)
header.BackgroundColor3 = Color3.fromRGB(34,34,34)
header.BorderSizePixel = 0

local title = Instance.new("TextLabel", header)
title.Size = UDim2.new(0.6, 0, 1, 0)
title.Position = UDim2.new(0.02, 0, 0, 0)
title.BackgroundTransparency = 1
title.Text = "BynzzBponjon"
title.TextColor3 = Color3.fromRGB(255,255,255)
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextXAlignment = Enum.TextXAlignment.Left

local hideBtn = Instance.new("TextButton", header)
hideBtn.Size = UDim2.new(0.16, 0, 1, -4)
hideBtn.Position = UDim2.new(0.62, 0, 0, 2)
hideBtn.Text = "Hide"
hideBtn.Font = Enum.Font.GothamBold
hideBtn.TextSize = 14
hideBtn.BackgroundColor3 = Color3.fromRGB(70,70,70)
hideBtn.TextColor3 = Color3.fromRGB(255,255,255)

local closeBtn = Instance.new("TextButton", header)
closeBtn.Size = UDim2.new(0.16, 0, 1, -4)
closeBtn.Position = UDim2.new(0.78, 0, 0, 2)
closeBtn.Text = "Close"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 14
closeBtn.BackgroundColor3 = Color3.fromRGB(140,20,20)
closeBtn.TextColor3 = Color3.fromRGB(255,255,255)

closeBtn.MouseButton1Click:Connect(function()
	screen:Destroy()
end)

-- left menu
local left = Instance.new("Frame", main)
left.Size = UDim2.new(0, 150, 1, -36)
left.Position = UDim2.new(0, 0, 0, 36)
left.BackgroundColor3 = Color3.fromRGB(10,10,10)

local pages = {"Auto","Server","Setting","Info","AutoDeath"}
local pageFrames = {}

local function makeLeftButton(txt, idx)
	local btn = Instance.new("TextButton", left)
	btn.Size = UDim2.new(1, 0, 0, 44)
	btn.Position = UDim2.new(0, 0, 0, (idx-1)*46)
	btn.Text = txt
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 16
	btn.BackgroundColor3 = Color3.fromRGB(18,18,18)
	btn.TextColor3 = Color3.fromRGB(255,255,255)
	return btn
end

for i, name in ipairs(pages) do
	local b = makeLeftButton(name, i)
	b.MouseButton1Click:Connect(function()
		for k, f in pairs(pageFrames) do f.Visible = false end
		pageFrames[name].Visible = true
	end)
end

-- right content area
local right = Instance.new("Frame", main)
right.Size = UDim2.new(1, -150, 1, -36)
right.Position = UDim2.new(0, 150, 0, 36)
right.BackgroundColor3 = Color3.fromRGB(16,16,16)

-- helper to create page frame
local function newPage(name)
	local f = Instance.new("Frame", right)
	f.Name = name
	f.Size = UDim2.new(1, 0, 1, 0)
	f.BackgroundTransparency = 1
	f.Visible = false
	pageFrames[name] = f
	return f
end

-- ===== PAGE: Auto =====
local autoPage = newPage("Auto")
autoPage.Visible = true

local autoTitle = Instance.new("TextLabel", autoPage)
autoTitle.Text = "Auto Summit"
autoTitle.Size = UDim2.new(1, -20, 0, 28)
autoTitle.Position = UDim2.new(0, 10, 0, 10)
autoTitle.BackgroundTransparency = 1
autoTitle.TextColor3 = Color3.new(1,1,1)
autoTitle.Font = Enum.Font.GothamBold
autoTitle.TextSize = 18
autoTitle.TextXAlignment = Enum.TextXAlignment.Left

local startBtn = Instance.new("TextButton", autoPage)
startBtn.Text = "Start"
startBtn.Size = UDim2.new(0.22, 0, 0, 34)
startBtn.Position = UDim2.new(0.02, 0, 0, 44)
startBtn.BackgroundColor3 = Color3.fromRGB(0,140,0)
startBtn.Font = Enum.Font.GothamBold
startBtn.TextColor3 = Color3.new(1,1,1)

local stopBtn = Instance.new("TextButton", autoPage)
stopBtn.Text = "Stop"
stopBtn.Size = UDim2.new(0.22, 0, 0, 34)
stopBtn.Position = UDim2.new(0.26, 0, 0, 44)
stopBtn.BackgroundColor3 = Color3.fromRGB(140,0,0)
stopBtn.Font = Enum.Font.GothamBold
stopBtn.TextColor3 = Color3.new(1,1,1)

local resumeLabel = Instance.new("TextLabel", autoPage)
resumeLabel.Size = UDim2.new(0.5, 0, 0, 24)
resumeLabel.Position = UDim2.new(0.02, 0, 0, 84)
resumeLabel.BackgroundTransparency = 1
resumeLabel.TextColor3 = Color3.new(1,1,1)
resumeLabel.Font = Enum.Font.Gotham
resumeLabel.TextSize = 14
resumeLabel.Text = "Resume from last CP: yes"

-- scrollable CP manual area (left column on this page)
local cpScroll = Instance.new("ScrollingFrame", autoPage)
cpScroll.Size = UDim2.new(0.48, -20, 0.78, -20)
cpScroll.Position = UDim2.new(0.02, 0, 0.12, 0)
cpScroll.BackgroundColor3 = Color3.fromRGB(12,12,12)
cpScroll.CanvasSize = UDim2.new(0, 0, 0, #checkpoints * 36 + 10)
cpScroll.ScrollBarThickness = 8

-- add each cp button
for i, cp in ipairs(checkpoints) do
	local btn = Instance.new("TextButton", cpScroll)
	btn.Size = UDim2.new(1, -8, 0, 32)
	btn.Position = UDim2.new(0, 4, 0, (i-1)*36)
	btn.Text = cp.name
	btn.Font = Enum.Font.Gotham
	btn.TextColor3 = Color3.new(1,1,1)
	btn.BackgroundColor3 = Color3.fromRGB(22,22,22)
	btn.MouseButton1Click:Connect(function()
		currentIndex = i
		safeSetCFrame(cp.pos)
		applyWalkSpeedToHumanoid()
		notify("Teleported to "..cp.name, 2, Color3.fromRGB(0,170,90))
	end)
end

-- right side of Auto page: info & small controls
local infoBox = Instance.new("Frame", autoPage)
infoBox.Size = UDim2.new(0.48, -20, 0.4, 0)
infoBox.Position = UDim2.new(0.5, 10, 0.12, 0)
infoBox.BackgroundColor3 = Color3.fromRGB(10,10,10)

local infoLabel = Instance.new("TextLabel", infoBox)
infoLabel.Size = UDim2.new(1, -12, 1, -12)
infoLabel.Position = UDim2.new(0, 6, 0, 6)
infoLabel.BackgroundTransparency = 1
infoLabel.TextColor3 = Color3.new(1,1,1)
infoLabel.Font = Enum.Font.Gotham
infoLabel.TextSize = 14
infoLabel.TextWrapped = true
infoLabel.Text = "Auto Summit controls:\n- Start/Stop auto-run from current CP.\n- Delay & WalkSpeed set in Settings.\n- AutoDeath & ServerHop options are in their pages."

-- Auto logic (resume support)
local autoThread
local function runAutoSummit()
	if autoSummitActive then return end
	autoSummitActive = true
	notify("Auto Summit started", 2, Color3.fromRGB(0,150,255))
	-- ensure index in bounds
	if currentIndex < 1 then currentIndex = 1 end
	if currentIndex > #checkpoints then currentIndex = 1 end

	autoThread = spawn(function()
		while autoSummitActive do
			local cp = checkpoints[currentIndex]
			if cp then
				safeSetCFrame(cp.pos)
				applyWalkSpeedToHumanoid()
			end
			-- wait configured delay
			local waited = 0
			while waited < delaySeconds and autoSummitActive do
				task.wait(0.25); waited = waited + 0.25
			end

			-- move index forward
			if not autoSummitActive then break end
			-- if reached Puncak
			if currentIndex >= #checkpoints then
				-- finished a summit
				summitCount = summitCount + 1
				notify("Summit #" .. tostring(summitCount) .. " reached", 2, Color3.fromRGB(0,200,120))
				-- optional auto death
				if autoDeath and player.Character then
					pcall(function() player.Character:BreakJoints() end)
				end
				-- server hop if enabled and meets limit
				if serverHopEnabled and summitLimit > 0 and summitCount >= summitLimit then
					summitCount = 0
					notify("Server Hop (auto) ...", 2, Color3.fromRGB(255,200,0))
					pcall(serverHop)
					-- if teleport succeeded script may stop here due to new server
					task.wait(1)
				end

				-- prepare for next run: go back to basecamp (resume stays at 1)
				currentIndex = 1
				-- if autoDeath off, we still continue after delay; if on, respawn event will apply
				-- small safety wait
				task.wait(0.5)
			else
				currentIndex = currentIndex + 1
			end
		end
		autoSummitActive = false
		notify("Auto Summit stopped", 2, Color3.fromRGB(200,60,60))
	end)
end

startBtn.MouseButton1Click:Connect(function()
	if not autoSummitActive then
		runAutoSummit()
	else
		notify("Already running", 1.5)
	end
end)

stopBtn.MouseButton1Click:Connect(function()
	if autoSummitActive then
		autoSummitActive = false
		notify("Stopping Auto Summit...", 1.5, Color3.fromRGB(200,80,80))
	else
		notify("Auto not running", 1.5)
	end
end)

-- ===== PAGE: Server =====
local serverPage = newPage("Server")

local serverTitle = Instance.new("TextLabel", serverPage)
serverTitle.Size = UDim2.new(1, -20, 0, 28)
serverTitle.Position = UDim2.new(0, 10, 0, 10)
serverTitle.BackgroundTransparency = 1
serverTitle.Text = "Server"
serverTitle.TextColor3 = Color3.new(1,1,1)
serverTitle.Font = Enum.Font.GothamBold
serverTitle.TextSize = 18

-- server hop toggle (on/off)
local serverToggle = Instance.new("TextButton", serverPage)
serverToggle.Size = UDim2.new(0.45, -10, 0, 40)
serverToggle.Position = UDim2.new(0.02, 0, 0, 50)
serverToggle.Text = "Server Hop: OFF"
serverToggle.Font = Enum.Font.GothamBold
serverToggle.TextColor3 = Color3.new(1,1,1)
serverToggle.BackgroundColor3 = Color3.fromRGB(170,40,40)

serverToggle.MouseButton1Click:Connect(function()
	serverHopEnabled = not serverHopEnabled
	if serverHopEnabled then
		serverToggle.Text = "Server Hop: ON"
		serverToggle.BackgroundColor3 = Color3.fromRGB(30,160,40)
	else
		serverToggle.Text = "Server Hop: OFF"
		serverToggle.BackgroundColor3 = Color3.fromRGB(170,40,40)
	end
end)

local manualHopBtn = Instance.new("TextButton", serverPage)
manualHopBtn.Size = UDim2.new(0.45, -10, 0, 40)
manualHopBtn.Position = UDim2.new(0.5, 10, 0, 50)
manualHopBtn.Text = "Manual Server Hop"
manualHopBtn.Font = Enum.Font.GothamBold
manualHopBtn.TextColor3 = Color3.new(1,1,1)
manualHopBtn.BackgroundColor3 = Color3.fromRGB(50,50,150)

manualHopBtn.MouseButton1Click:Connect(function()
	notify("Manual Server Hop ...", 2, Color3.fromRGB(255,200,0))
	pcall(serverHop)
end)

local summitLimitLabel = Instance.new("TextLabel", serverPage)
summitLimitLabel.Size = UDim2.new(0.9, 0, 0, 20)
summitLimitLabel.Position = UDim2.new(0.02, 0, 0, 100)
summitLimitLabel.BackgroundTransparency = 1
summitLimitLabel.Text = "Auto server hop after how many summits? (0 = disabled)"
summitLimitLabel.TextColor3 = Color3.new(1,1,1)
summitLimitLabel.Font = Enum.Font.Gotham
summitLimitLabel.TextSize = 13

local summitLimitBox = Instance.new("TextBox", serverPage)
summitLimitBox.Size = UDim2.new(0.9, 0, 0, 30)
summitLimitBox.Position = UDim2.new(0.02, 0, 0, 126)
summitLimitBox.Text = tostring(summitLimit)
summitLimitBox.ClearTextOnFocus = false
summitLimitBox.BackgroundColor3 = Color3.fromRGB(20,20,20)
summitLimitBox.TextColor3 = Color3.new(1,1,1)
summitLimitBox.Font = Enum.Font.Gotham
summitLimitBox.FocusLost:Connect(function()
	local v = tonumber(summitLimitBox.Text)
	if v and v >= 0 then summitLimit = v; notify("Summit limit set to "..v, 1.5, Color3.fromRGB(0,170,90)) end
end)

-- ===== PAGE: Setting =====
local setPage = newPage("Setting")
local setTitle = Instance.new("TextLabel", setPage)
setTitle.Size = UDim2.new(1, -20, 0, 28)
setTitle.Position = UDim2.new(0, 10, 0, 10)
setTitle.BackgroundTransparency = 1
setTitle.Text = "Settings"
setTitle.TextColor3 = Color3.new(1,1,1)
setTitle.Font = Enum.Font.GothamBold
setTitle.TextSize = 18

local delayLabel = Instance.new("TextLabel", setPage)
delayLabel.Size = UDim2.new(0.9, 0, 0, 18)
delayLabel.Position = UDim2.new(0.02, 0, 0, 50)
delayLabel.BackgroundTransparency = 1
delayLabel.Text = "Delay (seconds):"
delayLabel.TextColor3 = Color3.new(1,1,1)
delayLabel.Font = Enum.Font.Gotham

local delayBox = Instance.new("TextBox", setPage)
delayBox.Size = UDim2.new(0.9, 0, 0, 30)
delayBox.Position = UDim2.new(0.02, 0, 0, 72)
delayBox.Text = tostring(delaySeconds)
delayBox.ClearTextOnFocus = false
delayBox.BackgroundColor3 = Color3.fromRGB(20,20,20)
delayBox.TextColor3 = Color3.new(1,1,1)
delayBox.Font = Enum.Font.Gotham
delayBox.FocusLost:Connect(function()
	local v = tonumber(delayBox.Text)
	if v and v > 0 then delaySeconds = v; notify("Delay set to "..v.."s", 1.5, Color3.fromRGB(0,170,90)) end
end)

local speedLabel = Instance.new("TextLabel", setPage)
speedLabel.Size = UDim2.new(0.9, 0, 0, 18)
speedLabel.Position = UDim2.new(0.02, 0, 0, 112)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "WalkSpeed:"
speedLabel.TextColor3 = Color3.new(1,1,1)
speedLabel.Font = Enum.Font.Gotham

local speedBox = Instance.new("TextBox", setPage)
speedBox.Size = UDim2.new(0.9, 0, 0, 30)
speedBox.Position = UDim2.new(0.02, 0, 0, 134)
speedBox.Text = tostring(walkSpeed)
speedBox.ClearTextOnFocus = false
speedBox.BackgroundColor3 = Color3.fromRGB(20,20,20)
speedBox.TextColor3 = Color3.new(1,1,1)
speedBox.Font = Enum.Font.Gotham
speedBox.FocusLost:Connect(function()
	local v = tonumber(speedBox.Text)
	if v and v >= 0 then walkSpeed = v; applyWalkSpeedToHumanoid(); notify("WalkSpeed set to "..v, 1.5, Color3.fromRGB(0,170,90)) end
end)

-- ===== PAGE: Info =====
local infoPage = newPage("Info")
local infoTitle = Instance.new("TextLabel", infoPage)
infoTitle.Size = UDim2.new(1,-20,0,28)
infoTitle.Position = UDim2.new(0,10,0,10)
infoTitle.BackgroundTransparency = 1
infoTitle.Text = "Info"
infoTitle.TextColor3 = Color3.new(1,1,1)
infoTitle.Font = Enum.Font.GothamBold
infoTitle.TextSize = 18

local infoText = Instance.new("TextLabel", infoPage)
infoText.Size = UDim2.new(1,-20,1,-60)
infoText.Position = UDim2.new(0,10,0,46)
infoText.BackgroundTransparency = 1
infoText.TextColor3 = Color3.new(1,1,1)
infoText.Font = Enum.Font.Gotham
infoText.TextSize = 14
infoText.TextWrapped = true
infoText.Text = "Created by BynzzBponjon\nFeatures:\n- Manual CP teleport (scrollable)\n- Auto Summit (resume, configurable delay & speed)\n- Auto Death (on/off) + Manual Death button\n- Server Hop (manual & auto after N summits)\n- Hide/Close header, notifications."

-- ===== PAGE: AutoDeath =====
local deathPage = newPage("AutoDeath")

local deathTitle = Instance.new("TextLabel", deathPage)
deathTitle.Size = UDim2.new(1,-20,0,28)
deathTitle.Position = UDim2.new(0,10,0,10)
deathTitle.BackgroundTransparency = 1
deathTitle.Text = "Auto Death"
deathTitle.TextColor3 = Color3.new(1,1,1)
deathTitle.Font = Enum.Font.GothamBold
deathTitle.TextSize = 18

local autoDeathToggle = Instance.new("TextButton", deathPage)
autoDeathToggle.Size = UDim2.new(0.45, -10, 0, 40)
autoDeathToggle.Position = UDim2.new(0.02, 0, 0, 48)
autoDeathToggle.Text = "Auto Death: OFF"
autoDeathToggle.Font = Enum.Font.GothamBold
autoDeathToggle.TextColor3 = Color3.new(1,1,1)
autoDeathToggle.BackgroundColor3 = Color3.fromRGB(170,40,40)
autoDeathToggle.MouseButton1Click:Connect(function()
	autoDeath = not autoDeath
	if autoDeath then
		autoDeathToggle.Text = "Auto Death: ON"
		autoDeathToggle.BackgroundColor3 = Color3.fromRGB(40,170,40)
	else
		autoDeathToggle.Text = "Auto Death: OFF"
		autoDeathToggle.BackgroundColor3 = Color3.fromRGB(170,40,40)
	end
end)

local manualDeathBtn = Instance.new("TextButton", deathPage)
manualDeathBtn.Size = UDim2.new(0.45, -10, 0, 40)
manualDeathBtn.Position = UDim2.new(0.5, 10, 0, 48)
manualDeathBtn.Text = "Manual Death"
manualDeathBtn.Font = Enum.Font.GothamBold
manualDeathBtn.TextColor3 = Color3.new(1,1,1)
manualDeathBtn.BackgroundColor3 = Color3.fromRGB(140,20,20)
manualDeathBtn.MouseButton1Click:Connect(function()
	if player.Character then
		pcall(function() player.Character:BreakJoints() end)
		notify("Manual death triggered", 1.5, Color3.fromRGB(200,60,60))
	end
end)

-- ====== Hide behavior ======
local isHidden = false
hideBtn.MouseButton1Click:Connect(function()
	isHidden = not isHidden
	if isHidden then
		-- hide everything except header (but leave hide/close/title visible)
		for _,child in pairs(main:GetChildren()) do
			if child ~= header then child.Visible = false end
		end
		-- shrink header slightly so only top bar remains visible
		main.Size = UDim2.new(main.Size.X.Scale, main.Size.X.Offset, 0, 36)
	else
		-- restore main size & children visibility
		main.Size = UDim2.new(0, 620, 0, 420)
		for _,child in pairs(main:GetChildren()) do child.Visible = true end
	end
end)

-- Make header draggable by setting main.Active = true and main.Draggable = true (already set)
-- But allow moving while hidden: header will still be draggable because main is draggable.

-- ====== Final initialization / open default page ======
-- show Auto page by default
for k,f in pairs(pageFrames) do f.Visible = false end
pageFrames["Auto"].Visible = true

-- small convenience: clicking a CP while auto running should update currentIndex accordingly (already done)
-- ensure walkSpeed applied immediately if changed
speedBox.FocusLost:Connect(function()
	local v = tonumber(speedBox.Text)
	if v and v >= 0 then walkSpeed = v; applyWalkSpeedToHumanoid(); notify("WalkSpeed saved: "..v, 1.5, Color3.fromRGB(0,170,90)) end
end)

-- ensure delay update if typed in Settings
delayBox.FocusLost:Connect(function()
	local v = tonumber(delayBox.Text)
	if v and v > 0 then delaySeconds = v; notify("Delay saved: "..v.."s", 1.5, Color3.fromRGB(0,170,90)) end
end)

-- safe apply on start if player already spawned
applyWalkSpeedToHumanoid()

notify("BynzzBponjon GUI loaded", 2, Color3.fromRGB(0,200,120))
