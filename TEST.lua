-- BynzzBponjon — Final AutoSummit GUI (Client-side)
-- Salin & paste ini ke LocalScript (client) atau loadstring di client
-- WARNING: Teleport API calls may require that the exploit/environment supports HttpGet & TeleportService.

local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- ========== CONFIG / CHECKPOINTS ==========
local checkpoints = {
	{name="Basecamp", pos=Vector3.new(-883.288, 43.358, 933.698)},
	{name="CP1", pos=Vector3.new(-473.240, 49.167, 624.194)},
	{name="CP2", pos=Vector3.new(-182.927, 52.412, 691.074)},
	{name="CP3", pos=Vector3.new(122.499, 202.548, 951.741)},
	{name="CP4", pos=Vector3.new(10.684, 194.377, 340.400)},
	{name="CP5", pos=Vector3.new(244.394, 194.369, 805.065)},
	{name="CP6", pos=Vector3.new(660.531, 210.886, 749.360)},
	{name="CP7", pos=Vector3.new(660.649, 202.965, 368.070)},
	{name="CP8", pos=Vector3.new(520.852, 214.338, 281.842)},
	{name="CP9", pos=Vector3.new(523.730, 214.369, -333.936)},
	{name="CP10", pos=Vector3.new(561.610, 211.787, -559.470)},
	{name="CP11", pos=Vector3.new(566.837, 282.541, -924.107)},
	{name="CP12", pos=Vector3.new(115.198, 286.309, -655.635)},
	{name="CP13", pos=Vector3.new(-308.343, 410.144, -612.031)},
	{name="CP14", pos=Vector3.new(-487.722, 522.666, -663.426)},
	{name="CP15", pos=Vector3.new(-679.093, 482.701, -971.988)},
	{name="CP16", pos=Vector3.new(-559.058, 258.369, -1318.780)},
	{name="CP17", pos=Vector3.new(-426.353, 374.369, -1512.621)},
	{name="CP18", pos=Vector3.new(-984.797, 635.003, -1621.875)},
	{name="CP19", pos=Vector3.new(-1394.228, 797.455, -1563.855)},
	{name="Puncak", pos=Vector3.new(-1534.938, 933.116, -2176.096)}
}

-- ========== STATE ==========
local state = {
	autoSummit = false,
	autoDeath = false,
	serverHopEnabled = false,
	summitCount = 0,
	summitLimit = 20,   -- if serverHopEnabled, hop after this many summits
	delaySeconds = 10,  -- default delay between teleports (seconds)
	walkSpeed = 16,     -- default walkspeed to set while teleporting
	currentIndex = 1,   -- which checkpoint to teleport to next (1..#checkpoints)
	hidden = false
}

-- ========== HELPERS ==========
local function safeNotify(text, color)
	color = color or Color3.fromRGB(200,0,0)
	local notif = Instance.new("Frame")
	notif.Size = UDim2.new(0, 500, 0, 50)
	notif.AnchorPoint = Vector2.new(0.5, 0)
	notif.Position = UDim2.new(0.5, 0, 0.03, 0)
	notif.BackgroundColor3 = color
	notif.BorderSizePixel = 0
	notif.ZIndex = 10000
	local label = Instance.new("TextLabel", notif)
	label.Size = UDim2.new(1, -10, 1, 0)
	label.Position = UDim2.new(0, 5, 0, 0)
	label.BackgroundTransparency = 1
	label.Text = text
	label.TextColor3 = Color3.new(1,1,1)
	label.Font = Enum.Font.GothamBold
	label.TextScaled = true
	label.ZIndex = 10001
	notif.Parent = playerGui
	task.delay(2.5, function() notif:Destroy() end)
end

local function setPlayerWalkSpeed(speed)
	local char = player.Character
	if char then
		local humanoid = char:FindFirstChildOfClass("Humanoid")
		if humanoid then
			pcall(function() humanoid.WalkSpeed = speed end)
		end
	end
end

local function teleportToVector(vec)
	if player.Character and player.Character.PrimaryPart then
		pcall(function()
			player.Character:SetPrimaryPartCFrame(CFrame.new(vec))
		end)
	end
end

-- server hop: best-effort pick a public server with free slots
local function serverHop()
	local ok, raw = pcall(function()
		return game:HttpGet("https://games.roblox.com/v1/games/"..tostring(game.PlaceId).."/servers/Public?sortOrder=Asc&limit=100")
	end)
	if not ok or not raw then
		safeNotify("Server list request failed", Color3.fromRGB(180,80,0))
		return
	end
	local decoded
	ok, decoded = pcall(function() return HttpService:JSONDecode(raw) end)
	if not ok or type(decoded) ~= "table" or not decoded.data then
		safeNotify("Server list decode failed", Color3.fromRGB(180,80,0))
		return
	end
	local ids = {}
	for _,v in ipairs(decoded.data) do
		if type(v)=="table" and v.playing and v.maxPlayers and v.playing < v.maxPlayers then
			table.insert(ids, v.id)
		end
	end
	if #ids == 0 then
		safeNotify("No suitable servers found", Color3.fromRGB(180,80,0))
		return
	end
	local choice = ids[math.random(1, #ids)]
	pcall(function()
		TeleportService:TeleportToPlaceInstance(game.PlaceId, choice, player)
	end)
end

-- Resume-safe: when user teleports manually to a CP, set currentIndex to next CP automatically
local function setCurrentFromIndex(index)
	state.currentIndex = math.clamp(index, 1, #checkpoints)
end

-- ========== GUI BUILD ==========
-- remove old if exists
local EXIST = playerGui:FindFirstChild("BynzzBponjonGui")
if EXIST then EXIST:Destroy() end

local screen = Instance.new("ScreenGui")
screen.Name = "BynzzBponjonGui"
screen.ResetOnSpawn = false
screen.Parent = playerGui

local main = Instance.new("Frame", screen)
main.Name = "Main"
main.Size = UDim2.new(0, 620, 0, 420)
main.Position = UDim2.new(0.2, 0, 0.12, 0)
main.BackgroundColor3 = Color3.fromRGB(10,10,10)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true

-- header
local header = Instance.new("Frame", main)
header.Size = UDim2.new(1,0,0,34)
header.BackgroundColor3 = Color3.fromRGB(25,25,25)

local title = Instance.new("TextLabel", header)
title.Text = "BynzzBponjon"
title.Size = UDim2.new(0.6,0,1,0)
title.Position = UDim2.new(0.01,0,0,0)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.TextSize = 18

local hideBtn = Instance.new("TextButton", header)
hideBtn.Size = UDim2.new(0.17,0,1,0)
hideBtn.Position = UDim2.new(0.62,0,0,0)
hideBtn.Text = "Hide"
hideBtn.Font = Enum.Font.GothamBold
hideBtn.TextColor3 = Color3.new(1,1,1)
hideBtn.BackgroundColor3 = Color3.fromRGB(80,80,80)

local closeBtn = Instance.new("TextButton", header)
closeBtn.Size = UDim2.new(0.17,0,1,0)
closeBtn.Position = UDim2.new(0.79,0,0,0)
closeBtn.Text = "Close"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextColor3 = Color3.new(1,1,1)
closeBtn.BackgroundColor3 = Color3.fromRGB(160,20,20)

-- left menu
local left = Instance.new("Frame", main)
left.Size = UDim2.new(0, 150, 1, -34)
left.Position = UDim2.new(0, 0, 0, 34)
left.BackgroundColor3 = Color3.fromRGB(15,15,15)

local menuButtons = {}
local pageNames = {"Auto","Server","Setting","Info","AutoDeath","ManualCP"}
for i,name in ipairs(pageNames) do
	local btn = Instance.new("TextButton", left)
	btn.Size = UDim2.new(1, -10, 0, 40)
	btn.Position = UDim2.new(0, 5, 0, (i-1)*45 + 10)
	btn.Text = name
	btn.Font = Enum.Font.GothamBold
	btn.TextColor3 = Color3.new(1,1,1)
	btn.BackgroundColor3 = Color3.fromRGB(25,25,25)
	menuButtons[name] = btn
end

-- right content area
local right = Instance.new("Frame", main)
right.Size = UDim2.new(1, -150, 1, -34)
right.Position = UDim2.new(0, 150, 0, 34)
right.BackgroundColor3 = Color3.fromRGB(8,8,8)

local pages = Instance.new("Frame", right)
pages.Size = UDim2.new(1,1,1,1)
pages.BackgroundTransparency = 1

local function makePage(name)
	local f = Instance.new("Frame", pages)
	f.Name = name
	f.Size = UDim2.new(1,1,1,1)
	f.BackgroundTransparency = 1
	f.Visible = false
	return f
end

-- === Auto Page ===
local autoPage = makePage("Auto")
autoPage.Visible = true

local lblAuto = Instance.new("TextLabel", autoPage)
lblAuto.Size = UDim2.new(1, -20, 0, 28)
lblAuto.Position = UDim2.new(0, 10, 0, 10)
lblAuto.BackgroundTransparency = 1
lblAuto.Text = "Auto Summit"
lblAuto.TextColor3 = Color3.new(1,1,1)
lblAuto.Font = Enum.Font.GothamBold
lblAuto.TextSize = 18

local startBtn = Instance.new("TextButton", autoPage)
startBtn.Size = UDim2.new(0.48, -10, 0, 38)
startBtn.Position = UDim2.new(0, 10, 0, 50)
startBtn.Text = "Start"
startBtn.Font = Enum.Font.GothamBold
startBtn.BackgroundColor3 = Color3.fromRGB(0,140,0)
startBtn.TextColor3 = Color3.new(1,1,1)

local stopBtn = Instance.new("TextButton", autoPage)
stopBtn.Size = UDim2.new(0.48, -10, 0, 38)
stopBtn.Position = UDim2.new(0.52, 0, 0, 50)
stopBtn.Text = "Stop"
stopBtn.Font = Enum.Font.GothamBold
stopBtn.BackgroundColor3 = Color3.fromRGB(140,0,0)
stopBtn.TextColor3 = Color3.new(1,1,1)

local lblAutoInfo = Instance.new("TextLabel", autoPage)
lblAutoInfo.Size = UDim2.new(1, -20, 0, 22)
lblAutoInfo.Position = UDim2.new(0, 10, 0, 96)
lblAutoInfo.BackgroundTransparency = 1
lblAutoInfo.Text = "Auto will resume from your last CP. Toggle AutoDeath in AutoDeath page."
lblAutoInfo.TextColor3 = Color3.new(0.8,0.8,0.8)
lblAutoInfo.TextWrapped = true
lblAutoInfo.Font = Enum.Font.Gotham
lblAutoInfo.TextSize = 12

-- manual CP list inside Auto page for quick teleport
local cpLabel = Instance.new("TextLabel", autoPage)
cpLabel.Size = UDim2.new(1,-20,0,22)
cpLabel.Position = UDim2.new(0,10,0,128)
cpLabel.BackgroundTransparency = 1
cpLabel.Text = "Manual Checkpoints (quick):"
cpLabel.TextColor3 = Color3.new(1,1,1)
cpLabel.Font = Enum.Font.GothamBold

local cpScroll = Instance.new("ScrollingFrame", autoPage)
cpScroll.Size = UDim2.new(1, -40, 0, 200)
cpScroll.Position = UDim2.new(0, 20, 0, 152)
cpScroll.CanvasSize = UDim2.new(0, 0, 0, #checkpoints * 36)
cpScroll.ScrollBarThickness = 6
cpScroll.BackgroundColor3 = Color3.fromRGB(12,12,12)
cpScroll.BorderSizePixel = 0

for i,cp in ipairs(checkpoints) do
	local b = Instance.new("TextButton", cpScroll)
	b.Size = UDim2.new(1, -10, 0, 32)
	b.Position = UDim2.new(0, 5, 0, (i-1)*36)
	b.Text = cp.name
	b.Font = Enum.Font.Gotham
	b.TextColor3 = Color3.new(1,1,1)
	b.BackgroundColor3 = Color3.fromRGB(30,30,30)
	b.MouseButton1Click:Connect(function()
		teleportToVector(cp.pos)
		setPlayerWalkSpeed(state.walkSpeed)
		state.currentIndex = math.min(i+1, #checkpoints) -- resume next
		safeNotify("Teleported to "..cp.name, Color3.fromRGB(0,150,0))
	end)
end

-- === Server Page ===
local serverPage = makePage("Server")

local serverToggle = Instance.new("TextButton", serverPage)
serverToggle.Size = UDim2.new(0.48, -10, 0, 40)
serverToggle.Position = UDim2.new(0, 10, 0, 16)
serverToggle.Text = "Server Hop: OFF"
serverToggle.Font = Enum.Font.GothamBold
serverToggle.BackgroundColor3 = Color3.fromRGB(180,0,0)
serverToggle.TextColor3 = Color3.new(1,1,1)

local manualHopBtn = Instance.new("TextButton", serverPage)
manualHopBtn.Size = UDim2.new(0.48, -10, 0, 40)
manualHopBtn.Position = UDim2.new(0.52, 0, 0, 16)
manualHopBtn.Text = "Manual Hop"
manualHopBtn.Font = Enum.Font.GothamBold
manualHopBtn.BackgroundColor3 = Color3.fromRGB(30,30,30)
manualHopBtn.TextColor3 = Color3.new(1,1,1)

local summitLimitLabel = Instance.new("TextLabel", serverPage)
summitLimitLabel.Size = UDim2.new(1, -20, 0, 22)
summitLimitLabel.Position = UDim2.new(0, 10, 0, 72)
summitLimitLabel.BackgroundTransparency = 1
summitLimitLabel.Text = "Hop after X summits (when server hop enabled):"
summitLimitLabel.TextColor3 = Color3.new(1,1,1)
summitLimitLabel.Font = Enum.Font.Gotham

local summitLimitBox = Instance.new("TextBox", serverPage)
summitLimitBox.Size = UDim2.new(0.4,0,0,28)
summitLimitBox.Position = UDim2.new(0, 10, 0, 100)
summitLimitBox.Text = tostring(state.summitLimit)
summitLimitBox.ClearTextOnFocus = false
summitLimitBox.BackgroundColor3 = Color3.fromRGB(20,20,20)
summitLimitBox.TextColor3 = Color3.new(1,1,1)
summitLimitBox.Font = Enum.Font.Gotham

-- behaviour
serverToggle.MouseButton1Click:Connect(function()
	state.serverHopEnabled = not state.serverHopEnabled
	if state.serverHopEnabled then
		serverToggle.Text = "Server Hop: ON"
		serverToggle.BackgroundColor3 = Color3.fromRGB(0,160,0)
		safeNotify("Server Hop enabled", Color3.fromRGB(0,160,0))
	else
		serverToggle.Text = "Server Hop: OFF"
		serverToggle.BackgroundColor3 = Color3.fromRGB(180,0,0)
		safeNotify("Server Hop disabled", Color3.fromRGB(180,0,0))
	end
end)

manualHopBtn.MouseButton1Click:Connect(function()
	spawn(function()
		safeNotify("Manual server hop running...")
		serverHop()
	end)
end)

summitLimitBox.FocusLost:Connect(function()
	local v = tonumber(summitLimitBox.Text)
	if v and v > 0 then
		state.summitLimit = math.floor(v)
		safeNotify("Summit limit set to "..tostring(state.summitLimit), Color3.fromRGB(0,150,200))
	else
		summitLimitBox.Text = tostring(state.summitLimit)
	end
end)

-- === Setting Page ===
local settingPage = makePage("Setting")

local delayLabel = Instance.new("TextLabel", settingPage)
delayLabel.Size = UDim2.new(0.45, -10, 0, 20)
delayLabel.Position = UDim2.new(0, 10, 0, 12)
delayLabel.BackgroundTransparency = 1
delayLabel.Text = "Delay (s):"
delayLabel.TextColor3 = Color3.new(1,1,1)
delayLabel.Font = Enum.Font.Gotham

local delayBox = Instance.new("TextBox", settingPage)
delayBox.Size = UDim2.new(0.45, 0, 0, 28)
delayBox.Position = UDim2.new(0, 10, 0, 34)
delayBox.Text = tostring(state.delaySeconds)
delayBox.ClearTextOnFocus = false
delayBox.BackgroundColor3 = Color3.fromRGB(20,20,20)
delayBox.TextColor3 = Color3.new(1,1,1)
delayBox.Font = Enum.Font.Gotham

local speedLabel = Instance.new("TextLabel", settingPage)
speedLabel.Size = UDim2.new(0.45, -10, 0, 20)
speedLabel.Position = UDim2.new(0.5, 10, 0, 12)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "WalkSpeed:"
speedLabel.TextColor3 = Color3.new(1,1,1)
speedLabel.Font = Enum.Font.Gotham

local speedBox = Instance.new("TextBox", settingPage)
speedBox.Size = UDim2.new(0.45, 0, 0, 28)
speedBox.Position = UDim2.new(0.5, 10, 0, 34)
speedBox.Text = tostring(state.walkSpeed)
speedBox.ClearTextOnFocus = false
speedBox.BackgroundColor3 = Color3.fromRGB(20,20,20)
speedBox.TextColor3 = Color3.new(1,1,1)
speedBox.Font = Enum.Font.Gotham

delayBox.FocusLost:Connect(function()
	local v = tonumber(delayBox.Text)
	if v and v > 0 then
		state.delaySeconds = v
		safeNotify("Delay set to "..tostring(state.delaySeconds).."s", Color3.fromRGB(0,160,200))
	else
		delayBox.Text = tostring(state.delaySeconds)
	end
end)

speedBox.FocusLost:Connect(function()
	local v = tonumber(speedBox.Text)
	if v and v > 0 then
		state.walkSpeed = v
		setPlayerWalkSpeed(state.walkSpeed)
		safeNotify("WalkSpeed set to "..tostring(state.walkSpeed), Color3.fromRGB(0,160,200))
	else
		speedBox.Text = tostring(state.walkSpeed)
	end
end)

-- === Info Page ===
local infoPage = makePage("Info")
local infoLabel = Instance.new("TextLabel", infoPage)
infoLabel.Size = UDim2.new(1, -20, 1, -20)
infoLabel.Position = UDim2.new(0, 10, 0, 10)
infoLabel.BackgroundTransparency = 1
infoLabel.TextWrapped = true
infoLabel.Text = "BynzzBponjon AutoSummit\nFeatures:\n• Auto Summit (resume)\n• Manual Checkpoints (scroll)\n• ServerHop (auto/manual)\n• Auto Death (on/off)\n• Settings: delay & walkspeed\n• Hide bar (top only) + notifications\nCreated for you."
infoLabel.TextColor3 = Color3.new(1,1,1)
infoLabel.Font = Enum.Font.Gotham

-- === AutoDeath Page ===
local deathPage = makePage("AutoDeath")
local deathToggle = Instance.new("TextButton", deathPage)
deathToggle.Size = UDim2.new(0.48, -10, 0, 40)
deathToggle.Position = UDim2.new(0, 10, 0, 16)
deathToggle.Text = "Auto Death: OFF"
deathToggle.Font = Enum.Font.GothamBold
deathToggle.BackgroundColor3 = Color3.fromRGB(180,0,0)
deathToggle.TextColor3 = Color3.new(1,1,1)

deathToggle.MouseButton1Click:Connect(function()
	state.autoDeath = not state.autoDeath
	if state.autoDeath then
		deathToggle.Text = "Auto Death: ON"
		deathToggle.BackgroundColor3 = Color3.fromRGB(0,160,0)
		safeNotify("Auto Death: ON", Color3.fromRGB(0,160,0))
	else
		deathToggle.Text = "Auto Death: OFF"
		deathToggle.BackgroundColor3 = Color3.fromRGB(180,0,0)
		safeNotify("Auto Death: OFF", Color3.fromRGB(180,0,0))
	end
end)

-- === ManualCP page (full list & scroll) ===
local manualPage = makePage("ManualCP")
local fullLabel = Instance.new("TextLabel", manualPage)
fullLabel.Size = UDim2.new(1,-20,0,24)
fullLabel.Position = UDim2.new(0,10,0,8)
fullLabel.BackgroundTransparency = 1
fullLabel.Text = "All Checkpoints (manual)"
fullLabel.Font = Enum.Font.GothamBold
fullLabel.TextColor3 = Color3.new(1,1,1)

local fullScroll = Instance.new("ScrollingFrame", manualPage)
fullScroll.Size = UDim2.new(1, -40, 1, -50)
fullScroll.Position = UDim2.new(0, 20, 0, 36)
fullScroll.CanvasSize = UDim2.new(0, 0, 0, #checkpoints * 36)
fullScroll.ScrollBarThickness = 6
fullScroll.BackgroundColor3 = Color3.fromRGB(12,12,12)

for i,cp in ipairs(checkpoints) do
	local b = Instance.new("TextButton", fullScroll)
	b.Size = UDim2.new(1, -10, 0, 32)
	b.Position = UDim2.new(0, 5, 0, (i-1)*36)
	b.Text = cp.name
	b.Font = Enum.Font.Gotham
	b.TextColor3 = Color3.new(1,1,1)
	b.BackgroundColor3 = Color3.fromRGB(30,30,30)
	b.MouseButton1Click:Connect(function()
		teleportToVector(cp.pos)
		setPlayerWalkSpeed(state.walkSpeed)
		state.currentIndex = math.min(i+1, #checkpoints) -- resume next
		safeNotify("Teleported to "..cp.name, Color3.fromRGB(0,150,0))
	end)
end

-- ========== PAGE SWITCHING ==========
local function showPage(name)
	for _,child in pairs(pages:GetChildren()) do
		if child:IsA("Frame") then child.Visible = (child.Name == name) end
	end
	-- highlight left button
	for n,btn in pairs(menuButtons) do
		if n == name then
			btn.BackgroundColor3 = Color3.fromRGB(40,40,40)
		else
			btn.BackgroundColor3 = Color3.fromRGB(25,25,25)
		end
	end
end

-- connect menu buttons
for name,btn in pairs(menuButtons) do
	btn.MouseButton1Click:Connect(function()
		showPage(name)
	end)
end
showPage("Auto")

-- ========== HIDE / CLOSE BEHAVIOUR ==========
closeBtn.MouseButton1Click:Connect(function()
	screen:Destroy()
end)

hideBtn.MouseButton1Click:Connect(function()
	state.hidden = not state.hidden
	if state.hidden then
		-- hide everything except header
		for _,v in pairs(main:GetChildren()) do
			if v ~= header then v.Visible = false end
		end
		-- shrink main to header size (but keep draggable)
		main.Size = UDim2.new(0, 320, 0, 34)
		main.Position = main.Position -- keep position
	else
		-- restore size and show children
		main.Size = UDim2.new(0, 620, 0, 420)
		for _,v in pairs(main:GetChildren()) do v.Visible = true end
	end
end)

-- when header clicked while hidden, user can move/drag header (draggable property set earlier)
-- clicking Hide again will restore (handled above)

-- ========== AUTO-SUMMIT LOGIC ==========
local autoLoopThread = nil
local function startAutoSummit()
	if state.autoSummit then return end
	state.autoSummit = true
	safeNotify("Auto Summit started", Color3.fromRGB(0,150,255))

	autoLoopThread = spawn(function()
		while state.autoSummit do
			-- ensure index valid
			local idx = math.clamp(state.currentIndex, 1, #checkpoints)
			-- go from current index up to last
			for i = idx, #checkpoints do
				if not state.autoSummit then break end
				local cp = checkpoints[i]
				teleportToVector(cp.pos)
				setPlayerWalkSpeed(state.walkSpeed)
				-- after teleport, set currentIndex to next so resume continues
				state.currentIndex = math.min(i + 1, #checkpoints)
				-- wait delay while keeping responsiveness
				local tot = state.delaySeconds
				local elapsed = 0
				while state.autoSummit and elapsed < tot do
					task.wait(0.2)
					elapsed = elapsed + 0.2
				end
			end

			if not state.autoSummit then break end

			-- reached Puncak
			state.summitCount = state.summitCount + 1
			safeNotify("Summit #"..tostring(state.summitCount).." reached", Color3.fromRGB(0,200,100))

			-- auto death (optional)
			if state.autoDeath then
				pcall(function()
					if player.Character then player.Character:BreakJoints() end
				end)
				-- wait respawn
				player.CharacterAdded:Wait()
			end

			-- server hop if enabled and limit reached
			if state.serverHopEnabled and state.summitCount >= state.summitLimit then
				safeNotify("ServerHop triggered after "..tostring(state.summitCount).." summits", Color3.fromRGB(180,150,0))
				state.summitCount = 0
				serverHop()
				-- give some time (teleport returns control to new server)
				task.wait(2)
				-- if teleport fails, continue
			end

			-- loop: resume from start (basecamp) unless stopped; user wanted auto-repeat
			state.currentIndex = 1
			-- tiny pause before next loop to avoid spamming
			task.wait(0.2)
		end
		safeNotify("Auto Summit stopped", Color3.fromRGB(160,60,60))
	end)
end

local function stopAutoSummit()
	if state.autoSummit then
		state.autoSummit = false
		safeNotify("Auto Summit stopped", Color3.fromRGB(160,60,60))
	end
end

startBtn.MouseButton1Click:Connect(startAutoSummit)
stopBtn.MouseButton1Click:Connect(stopAutoSummit)

-- ========== OTHER INTERACTIONS ==========
-- Clicking a manual CP from manual page already sets state.currentIndex to next cp.

-- reflect serverHop toggle in UI when summary limit changed
summitLimitBox.FocusLost:Connect(function()
	local v = tonumber(summitLimitBox.Text)
	if v and v > 0 then
		state.summitLimit = math.floor(v)
		safeNotify("Summit limit = "..tostring(state.summitLimit), Color3.fromRGB(0,160,200))
	else
		summitLimitBox.Text = tostring(state.summitLimit)
	end
end)

-- ensure walkSpeed applied on respawn
player.CharacterAdded:Connect(function()
	task.wait(0.5)
	setPlayerWalkSpeed(state.walkSpeed)
end)

-- Keep UI responsive: clicking left menu while hidden should unhide + show page
for name,btn in pairs(menuButtons) do
	btn.MouseButton1Click:Connect(function()
		if state.hidden then
			-- unhide first
			state.hidden = false
			main.Size = UDim2.new(0, 620, 0, 420)
			for _,v in pairs(main:GetChildren()) do v.Visible = true end
		end
		showPage(name)
	end)
end

-- make sure initial visibility and values match state
delayBox.Text = tostring(state.delaySeconds)
speedBox.Text = tostring(state.walkSpeed)
summitLimitBox.Text = tostring(state.summitLimit)
serverToggle.Text = state.serverHopEnabled and "Server Hop: ON" or "Server Hop: OFF"
serverToggle.BackgroundColor3 = state.serverHopEnabled and Color3.fromRGB(0,160,0) or Color3.fromRGB(180,0,0)
deathToggle.Text = state.autoDeath and "Auto Death: ON" or "Auto Death: OFF"
deathToggle.BackgroundColor3 = state.autoDeath and Color3.fromRGB(0,160,0) or Color3.fromRGB(180,0,0)

safeNotify("BynzzBponjon loaded!", Color3.fromRGB(0,200,100))

-- End of script
