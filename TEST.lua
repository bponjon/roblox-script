-- BynzzBponjon — Final (ready-to-use)
-- Paste into a LocalScript / executor (client-side)

local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- ======= CHECKPOINTS (Mount Koharu - sesuai request) =======
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

-- ======= STATE DEFAULTS =======
local state = {
	autoSummit = false,
	autoDeath = false,
	serverHopEnabled = false,
	summitCount = 0,
	summitLimit = 20,      -- if serverHopEnabled true, will hop after summitLimit
	delaySeconds = 30,     -- default delay (user changed to any positive)
	walkSpeed = 16,
	currentIndex = 1       -- resume index
}

-- ======= UTIL: Notification =======
local function showNotification(text, bgColor)
	bgColor = bgColor or Color3.fromRGB(180, 0, 0)
	local notif = Instance.new("Frame")
	notif.Size = UDim2.new(0, 480, 0, 46)
	notif.Position = UDim2.new(0.5, -240, 0.045, 0)
	notif.AnchorPoint = Vector2.new(0.5, 0)
	notif.BackgroundColor3 = bgColor
	notif.BorderSizePixel = 0
	notif.ZIndex = 9999
	notif.Parent = playerGui

	local label = Instance.new("TextLabel", notif)
	label.Size = UDim2.new(1, 0, 1, 0)
	label.BackgroundTransparency = 1
	label.Text = text
	label.TextColor3 = Color3.new(1, 1, 1)
	label.Font = Enum.Font.GothamBold
	label.TextSize = 18
	label.TextScaled = true

	spawn(function()
		task.wait(2.5)
		if notif and notif.Parent then notif:Destroy() end
	end)
end

-- ======= UTIL: Server Hop (public servers with free slots) =======
local function serverHop()
	-- Best-effort; may fail depending on Roblox HTTP restrictions.
	local ok, raw = pcall(function()
		return game:HttpGet("https://games.roblox.com/v1/games/" .. tostring(game.PlaceId) .. "/servers/Public?sortOrder=Asc&limit=100")
	end)
	if not ok or not raw then
		showNotification("Server hop failed (fetch).", Color3.fromRGB(200,100,0))
		return
	end

	local success, decoded = pcall(function() return HttpService:JSONDecode(raw) end)
	if not success or type(decoded) ~= "table" or not decoded.data then
		showNotification("Server hop failed (decode).", Color3.fromRGB(200,100,0))
		return
	end

	local candidates = {}
	for _,v in ipairs(decoded.data) do
		if type(v) == "table" and v.playing and v.maxPlayers and v.playing < v.maxPlayers then
			table.insert(candidates, v.id)
		end
	end

	if #candidates > 0 then
		local chosen = candidates[math.random(1, #candidates)]
		pcall(function()
			TeleportService:TeleportToPlaceInstance(game.PlaceId, chosen, player)
		end)
	else
		showNotification("No suitable servers found.", Color3.fromRGB(200,100,0))
	end
end

-- ======= GUI BUILD =======
if playerGui:FindFirstChild("BynzzBponjon") then playerGui.BynzzBponjon:Destroy() end
local gui = Instance.new("ScreenGui", playerGui)
gui.Name = "BynzzBponjon"
gui.ResetOnSpawn = false

local main = Instance.new("Frame", gui)
main.Name = "Main"
main.Size = UDim2.new(0, 700, 0, 420)
main.Position = UDim2.new(0.12, 0, 0.12, 0)
main.BackgroundColor3 = Color3.fromRGB(18,18,18)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true

-- header (only part visible when hidden)
local header = Instance.new("Frame", main)
header.Size = UDim2.new(1, 0, 0, 36)
header.Position = UDim2.new(0,0,0,0)
header.BackgroundColor3 = Color3.fromRGB(32,32,32)

local title = Instance.new("TextLabel", header)
title.Size = UDim2.new(0.6, 0, 1, 0)
title.Position = UDim2.new(0.01, 0, 0, 0)
title.BackgroundTransparency = 1
title.Text = "BynzzBponjon"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextXAlignment = Enum.TextXAlignment.Left

local hideBtn = Instance.new("TextButton", header)
hideBtn.Size = UDim2.new(0.18, 0, 1, 0)
hideBtn.Position = UDim2.new(0.62, 0, 0, 0)
hideBtn.Text = "Hide"
hideBtn.Font = Enum.Font.GothamBold
hideBtn.TextColor3 = Color3.new(1,1,1)
hideBtn.BackgroundColor3 = Color3.fromRGB(80,80,80)

local closeBtn = Instance.new("TextButton", header)
closeBtn.Size = UDim2.new(0.18, 0, 1, 0)
closeBtn.Position = UDim2.new(0.8, 0, 0, 0)
closeBtn.Text = "Close"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextColor3 = Color3.new(1,1,1)
closeBtn.BackgroundColor3 = Color3.fromRGB(160,20,20)

closeBtn.MouseButton1Click:Connect(function()
	gui:Destroy()
end)

-- left menu
local left = Instance.new("Frame", main)
left.Size = UDim2.new(0, 160, 1, -36)
left.Position = UDim2.new(0, 0, 0, 36)
left.BackgroundColor3 = Color3.fromRGB(12,12,12)

local menuNames = {"Auto","Server","Setting","Info","AutoDeath"}
local menuButtons = {}
for i,name in ipairs(menuNames) do
	local b = Instance.new("TextButton", left)
	b.Size = UDim2.new(1, 0, 0, 48)
	b.Position = UDim2.new(0, 0, 0, (i-1)*50)
	b.Text = name
	b.Font = Enum.Font.GothamBold
	b.TextSize = 16
	b.BackgroundColor3 = Color3.fromRGB(22,22,22)
	b.TextColor3 = Color3.new(1,1,1)
	menuButtons[name] = b
end

-- right content area
local right = Instance.new("Frame", main)
right.Size = UDim2.new(1, -160, 1, -36)
right.Position = UDim2.new(0, 160, 0, 36)
right.BackgroundColor3 = Color3.fromRGB(8,8,8)

-- content pages container
local pagesFolder = Instance.new("Folder", right)
pagesFolder.Name = "Pages"

local function clearPages()
	for _,v in pairs(pagesFolder:GetChildren()) do v:Destroy() end
end

-- ========== PAGE: Auto ==========
local autoPage = Instance.new("Frame", pagesFolder); autoPage.Name="Auto"; autoPage.Size = UDim2.new(1,0,1,0); autoPage.BackgroundTransparency = 1
-- Start / Stop
local startBtn = Instance.new("TextButton", autoPage)
startBtn.Size = UDim2.new(0.45, -10, 0, 40)
startBtn.Position = UDim2.new(0.02, 0, 0.03, 0)
startBtn.Text = "Start Auto Summit"
startBtn.Font = Enum.Font.GothamBold
startBtn.TextSize = 16
startBtn.BackgroundColor3 = Color3.fromRGB(60, 0, 160)
startBtn.TextColor3 = Color3.new(1,1,1)

local stopBtn = Instance.new("TextButton", autoPage)
stopBtn.Size = UDim2.new(0.45, -10, 0, 40)
stopBtn.Position = UDim2.new(0.5, 0, 0.03, 0)
stopBtn.Text = "Stop Auto Summit"
stopBtn.Font = Enum.Font.GothamBold
stopBtn.TextSize = 16
stopBtn.BackgroundColor3 = Color3.fromRGB(140, 0, 0)
stopBtn.TextColor3 = Color3.new(1,1,1)

-- small label about resume
local resumeLabel = Instance.new("TextLabel", autoPage)
resumeLabel.Size = UDim2.new(0.96, 0, 0, 20)
resumeLabel.Position = UDim2.new(0.02,0,0.12,0)
resumeLabel.BackgroundTransparency = 1
resumeLabel.Text = "Auto will resume from last stopped checkpoint. Stop keeps current position."
resumeLabel.Font = Enum.Font.Gotham
resumeLabel.TextSize = 13
resumeLabel.TextColor3 = Color3.fromRGB(200,200,200)

-- CP manual scroll (on right side of auto page)
local cpFrame = Instance.new("Frame", autoPage)
cpFrame.Size = UDim2.new(0.46, 0, 0.78, 0)
cpFrame.Position = UDim2.new(0.51, 0, 0.18, 0)
cpFrame.BackgroundColor3 = Color3.fromRGB(14,14,14)
cpFrame.BorderSizePixel = 0

local cpLabel = Instance.new("TextLabel", cpFrame)
cpLabel.Size = UDim2.new(1,0,0,28)
cpLabel.Position = UDim2.new(0,0,0,0)
cpLabel.BackgroundTransparency = 1
cpLabel.Text = "Checkpoint Manual"
cpLabel.Font = Enum.Font.GothamBold
cpLabel.TextSize = 16
cpLabel.TextColor3 = Color3.new(1,1,1)

local cpScroll = Instance.new("ScrollingFrame", cpFrame)
cpScroll.Size = UDim2.new(1, -10, 1, -36)
cpScroll.Position = UDim2.new(0,5,0,36)
cpScroll.CanvasSize = UDim2.new(0,0,0, #checkpoints * 36)
cpScroll.ScrollBarThickness = 6
cpScroll.BackgroundTransparency = 1

for i,cp in ipairs(checkpoints) do
	local btn = Instance.new("TextButton", cpScroll)
	btn.Size = UDim2.new(1, 0, 0, 32)
	btn.Position = UDim2.new(0, 0, 0, (i-1)*36)
	btn.Text = cp.name
	btn.Font = Enum.Font.Gotham
	btn.TextSize = 14
	btn.BackgroundColor3 = Color3.fromRGB(28,28,28)
	btn.TextColor3 = Color3.new(1,1,1)
	btn.MouseButton1Click:Connect(function()
		if player.Character and player.Character.PrimaryPart then
			pcall(function() player.Character:SetPrimaryPartCFrame(CFrame.new(cp.pos)) end)
			showNotification("Teleported: "..cp.name, Color3.fromRGB(0,150,80))
			-- update currentIndex to next after this selected one
			state.currentIndex = math.clamp(i + 1, 1, #checkpoints)
		end
	end)
end

-- ========== PAGE: Server ==========
local serverPage = Instance.new("Frame", pagesFolder); serverPage.Name="Server"; serverPage.Size = UDim2.new(1,0,1,0); serverPage.BackgroundTransparency = 1
local serverToggle = Instance.new("TextButton", serverPage)
serverToggle.Size = UDim2.new(0.6,0,0,40)
serverToggle.Position = UDim2.new(0.02,0,0.03,0)
serverToggle.Text = "Server Hop: OFF"
serverToggle.Font = Enum.Font.GothamBold
serverToggle.TextSize = 16
serverToggle.BackgroundColor3 = Color3.fromRGB(200,0,0)
serverToggle.TextColor3 = Color3.new(1,1,1)

local manualHopBtn = Instance.new("TextButton", serverPage)
manualHopBtn.Size = UDim2.new(0.3,0,0,40)
manualHopBtn.Position = UDim2.new(0.64,0,0.03,0)
manualHopBtn.Text = "Manual Hop"
manualHopBtn.Font = Enum.Font.Gotham
manualHopBtn.TextSize = 14
manualHopBtn.BackgroundColor3 = Color3.fromRGB(30,30,30)
manualHopBtn.TextColor3 = Color3.new(1,1,1)

local limitLabel = Instance.new("TextLabel", serverPage)
limitLabel.Size = UDim2.new(0.96,0,0,20)
limitLabel.Position = UDim2.new(0.02,0,0.12,0)
limitLabel.BackgroundTransparency = 1
limitLabel.Text = "Server Hop Limit (summits):"
limitLabel.Font = Enum.Font.Gotham
limitLabel.TextSize = 14
limitLabel.TextColor3 = Color3.fromRGB(200,200,200)

local limitBox = Instance.new("TextBox", serverPage)
limitBox.Size = UDim2.new(0.3,0,0,30)
limitBox.Position = UDim2.new(0.02,0,0.16,0)
limitBox.Text = tostring(state.summitLimit)
limitBox.Font = Enum.Font.Gotham
limitBox.TextColor3 = Color3.new(1,1,1)
limitBox.BackgroundColor3 = Color3.fromRGB(28,28,28)
limitBox.FocusLost:Connect(function(enter)
	local v = tonumber(limitBox.Text)
	if v and v > 0 then state.summitLimit = math.floor(v) end
end)

-- ========== PAGE: Setting ==========
local setPage = Instance.new("Frame", pagesFolder); setPage.Name="Setting"; setPage.Size = UDim2.new(1,0,1,0); setPage.BackgroundTransparency = 1
local delayLabel = Instance.new("TextLabel", setPage)
delayLabel.Size = UDim2.new(0.96,0,0,18)
delayLabel.Position = UDim2.new(0.02,0,0.03,0)
delayLabel.BackgroundTransparency = 1
delayLabel.Text = "Delay (seconds) — min 1"
delayLabel.Font = Enum.Font.Gotham
delayLabel.TextSize = 14
delayLabel.TextColor3 = Color3.fromRGB(200,200,200)

local delayBox = Instance.new("TextBox", setPage)
delayBox.Size = UDim2.new(0.45,0,0,36)
delayBox.Position = UDim2.new(0.02,0,0.08,0)
delayBox.Text = tostring(state.delaySeconds)
delayBox.Font = Enum.Font.Gotham
delayBox.TextColor3 = Color3.new(1,1,1)
delayBox.BackgroundColor3 = Color3.fromRGB(28,28,28)
delayBox.ClearTextOnFocus = false
delayBox.FocusLost:Connect(function()
	local v = tonumber(delayBox.Text)
	if v and v >= 1 then state.delaySeconds = v showNotification("Delay set to "..v.."s", Color3.fromRGB(0,150,200))
	else delayBox.Text = tostring(state.delaySeconds) end
end)

local speedLabel = Instance.new("TextLabel", setPage)
speedLabel.Size = UDim2.new(0.96,0,0,18)
speedLabel.Position = UDim2.new(0.02,0,0.28,0)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "WalkSpeed (player speed)"
speedLabel.Font = Enum.Font.Gotham
speedLabel.TextSize = 14
speedLabel.TextColor3 = Color3.fromRGB(200,200,200)

local speedBox = Instance.new("TextBox", setPage)
speedBox.Size = UDim2.new(0.45,0,0,36)
speedBox.Position = UDim2.new(0.02,0,0.33,0)
speedBox.Text = tostring(state.walkSpeed)
speedBox.Font = Enum.Font.Gotham
speedBox.TextColor3 = Color3.new(1,1,1)
speedBox.BackgroundColor3 = Color3.fromRGB(28,28,28)
speedBox.ClearTextOnFocus = false
speedBox.FocusLost:Connect(function()
	local v = tonumber(speedBox.Text)
	if v and v >= 0 then state.walkSpeed = v showNotification("WalkSpeed set to "..v, Color3.fromRGB(0,150,200))
	else speedBox.Text = tostring(state.walkSpeed) end
end)

-- ========== PAGE: Info ==========
local infoPage = Instance.new("Frame", pagesFolder); infoPage.Name="Info"; infoPage.Size = UDim2.new(1,0,1,0); infoPage.BackgroundTransparency = 1
local infoLabel = Instance.new("TextLabel", infoPage)
infoLabel.Size = UDim2.new(0.96,0,0.9,0)
infoLabel.Position = UDim2.new(0.02,0,0.03,0)
infoLabel.BackgroundTransparency = 1
infoLabel.Text = "BynzzBponjon\nFinal GUI\nFeatures:\n• Auto Summit (resume)\n• Manual checkpoint teleports\n• Auto Death toggle\n• Server Hop (auto/manual)\n• Delay & WalkSpeed settings\n• Notifications\n\nMade based on your requests."
infoLabel.Font = Enum.Font.Gotham
infoLabel.TextSize = 14
infoLabel.TextColor3 = Color3.new(1,1,1)
infoLabel.TextWrapped = true

-- ========== PAGE: AutoDeath ==========
local deathPage = Instance.new("Frame", pagesFolder); deathPage.Name="AutoDeath"; deathPage.Size = UDim2.new(1,0,1,0); deathPage.BackgroundTransparency = 1
local deathToggle = Instance.new("TextButton", deathPage)
deathToggle.Size = UDim2.new(0.6,0,0,40)
deathToggle.Position = UDim2.new(0.02,0,0.03,0)
deathToggle.Text = "Auto Death: OFF"
deathToggle.Font = Enum.Font.GothamBold
deathToggle.TextSize = 16
deathToggle.BackgroundColor3 = Color3.fromRGB(200,0,0)
deathToggle.TextColor3 = Color3.new(1,1,1)

-- ======= SHOW/HIDE PAGE FUNCTION =======
local currentPage = nil
local function showPage(name)
	for _,v in pairs(pagesFolder:GetChildren()) do v.Visible = false end
	local p = pagesFolder:FindFirstChild(name)
	if p then p.Visible = true currentPage = name end
end

-- default open Auto
showPage("Auto")

-- connect left menu
for name,btn in pairs(menuButtons) do
	btn.MouseButton1Click:Connect(function()
		showPage(name)
	end)
end

-- ======= HOOKUP BUTTONS BEHAVIOR =======
-- Server toggle
serverToggle.MouseButton1Click:Connect(function()
	state.serverHopEnabled = not state.serverHopEnabled
	if state.serverHopEnabled then
		serverToggle.Text = "Server Hop: ON"
		serverToggle.BackgroundColor3 = Color3.fromRGB(0,200,0)
		showNotification("Server Hop: ON", Color3.fromRGB(0,150,200))
	else
		serverToggle.Text = "Server Hop: OFF"
		serverToggle.BackgroundColor3 = Color3.fromRGB(200,0,0)
		showNotification("Server Hop: OFF", Color3.fromRGB(200,100,0))
	end
end)

manualHopBtn.MouseButton1Click:Connect(function()
	showNotification("Manual server hop...", Color3.fromRGB(200,150,0))
	serverHop()
end)

-- Auto Death toggle
deathToggle.MouseButton1Click:Connect(function()
	state.autoDeath = not state.autoDeath
	if state.autoDeath then
		deathToggle.Text = "Auto Death: ON"
		deathToggle.BackgroundColor3 = Color3.fromRGB(0,200,0)
	else
		deathToggle.Text = "Auto Death: OFF"
		deathToggle.BackgroundColor3 = Color3.fromRGB(200,0,0)
	end
end)

-- Start / Stop auto summit logic (resume behavior)
local autoLoopThread = nil
local function setPlayerSpeed(v)
	if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
		pcall(function() player.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = v end)
	end
end

local function startAutoSummit()
	if state.autoSummit then return end
	state.autoSummit = true
	showNotification("Auto Summit started", Color3.fromRGB(0,150,255))

	autoLoopThread = spawn(function()
		-- begin from currentIndex; when finished, increment summitCount and optionally hop
		local i = state.currentIndex
		while state.autoSummit do
			-- safety: clamp i
			if i < 1 then i = 1 end
			if i > #checkpoints then
				-- reached top
				state.summitCount = state.summitCount + 1
				showNotification("Summit complete #"..state.summitCount, Color3.fromRGB(0,200,120))
				-- auto death if enabled
				if state.autoDeath and player.Character then
					pcall(function() player.Character:BreakJoints() end)
				end
				-- server hop if enabled and limit reached
				if state.serverHopEnabled and state.summitCount >= state.summitLimit then
					state.summitCount = 0
					showNotification("Auto server hop...", Color3.fromRGB(200,150,0))
					serverHop()
					-- wait a short moment after teleport attempt to avoid loop issues
					task.wait(1)
				end
				-- reset to start for next repeat
				i = 1
				state.currentIndex = 1
				-- continue loop (auto-repeat)
			end

			-- teleport to checkpoint i
			local cp = checkpoints[i]
			if player.Character and player.Character.PrimaryPart then
				pcall(function()
					player.Character:SetPrimaryPartCFrame(CFrame.new(cp.pos))
				end)
				-- apply WalkSpeed each teleport
				setPlayerSpeed(state.walkSpeed)
			end

			-- after teleport wait requested seconds (user adjustable)
			-- ensure minimum of 1 second
			local waitFor = math.max(1, tonumber(state.delaySeconds) or 1)
			local waited = 0
			-- simple wait loop that breaks if user stops
			while state.autoSummit and waited < waitFor do
				task.wait(0.2)
				waited = waited + 0.2
			end

			if not state.autoSummit then
				-- stopped mid-run: record next index to resume
				state.currentIndex = i + 1
				if state.currentIndex > #checkpoints then state.currentIndex = 1 end
				break
			end

			-- move to next
			i = i + 1
			state.currentIndex = i
		end

		-- stopped
		if not state.autoSummit then
			showNotification("Auto Summit stopped", Color3.fromRGB(200,80,80))
		end
	end)
end

local function stopAutoSummit()
	if not state.autoSummit then return end
	state.autoSummit = false
	-- autoLoopThread will end itself; keep currentIndex so start resumes properly
end

startBtn.MouseButton1Click:Connect(function()
	startAutoSummit()
end)
stopBtn.MouseButton1Click:Connect(function()
	stopAutoSummit()
end)

-- hide behavior: hide everything except header (title/hide/close). Header remains draggable.
local hidden = false
hideBtn.MouseButton1Click:Connect(function()
	hidden = not hidden
	for _,child in pairs(main:GetChildren()) do
		if child ~= header then child.Visible = not hidden end
	end
	-- when hidden, shrink main to header height to avoid blocking screen
	if hidden then
		main.Size = UDim2.new(main.Size.X.Scale, main.Size.X.Offset, 0, 36)
	else
		main.Size = UDim2.new(0, 700, 0, 420)
	end
end)

-- make sure header stays draggable even when hidden: main.Active already true and draggable

-- serverLimit box and setting hookup already connected above via FocusLost

-- walkSpeed apply when user changes in settings (FocusLost handler already sets state.walkSpeed)
-- apply WalkSpeed immediately when changed (ensure current character humanoid updated)
speedBox.FocusLost:Connect(function()
	local v = tonumber(speedBox.Text)
	if v and v >= 0 then
		state.walkSpeed = v
		setPlayerSpeed(v)
		showNotification("WalkSpeed updated: "..v, Color3.fromRGB(0,150,200))
	else
		speedBox.Text = tostring(state.walkSpeed)
	end
end)

-- delayBox already hooked earlier but ensure local state updated
delayBox.FocusLost:Connect(function()
	local v = tonumber(delayBox.Text)
	if v and v >= 1 then
		state.delaySeconds = v
		showNotification("Delay updated: "..v.."s", Color3.fromRGB(0,150,200))
	else
		delayBox.Text = tostring(state.delaySeconds)
	end
end)

-- AutoDeath toggle already hooked earlier via deathToggle button

-- ensure manual teleport UI created; pages added to folder earlier, so showPage works
-- by default opening "Auto" above

-- helper: keep humanoid speed when respawned
player.CharacterAdded:Connect(function(char)
	task.wait(0.5)
	setPlayerSpeed(state.walkSpeed)
end)

-- final ready message
showNotification("BynzzBponjon loaded — GUI ready", Color3.fromRGB(0,200,100))
