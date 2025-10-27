-- ===== MountGemini AutoSummit v3 =====
local player = game.Players.LocalPlayer
local tpService = game:GetService("TeleportService")

-- ===== Checkpoints =====
local checkpoints = {
    {name="Basecamp", pos=Vector3.new(1272.160, 639.021, 1792.852)},
    {name="Puncak", pos=Vector3.new(-6652.260, 3151.055, -796.739)}
}

-- ===== GUI Setup =====
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "MountGeminiMenu"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,280,0,300)
frame.Position = UDim2.new(0.05,0,0.1,0)
frame.BackgroundColor3 = Color3.fromRGB(50,0,50)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,30)
title.BackgroundColor3 = Color3.fromRGB(30,0,30)
title.TextColor3 = Color3.fromRGB(255,255,255)
title.Text = "🏔 MountGemini Control Panel"
title.TextScaled = true

-- ===== Close & Hide =====
local closeBtn = Instance.new("TextButton", frame)
closeBtn.Text = "X"
closeBtn.Size = UDim2.new(0,30,0,30)
closeBtn.Position = UDim2.new(1,-35,0,0)
closeBtn.BackgroundColor3 = Color3.fromRGB(150,0,0)
closeBtn.TextColor3 = Color3.fromRGB(255,255,255)
closeBtn.MouseButton1Click:Connect(function()
	gui.Enabled = false
end)

local hideBtn = Instance.new("TextButton", frame)
hideBtn.Text = "Hide"
hideBtn.Size = UDim2.new(0,60,0,30)
hideBtn.Position = UDim2.new(0,5,0,0)
hideBtn.BackgroundColor3 = Color3.fromRGB(0,0,0)
hideBtn.TextColor3 = Color3.fromRGB(255,255,255)

local logo = Instance.new("TextButton", gui)
logo.Text = "🚀"
logo.Size = UDim2.new(0,50,0,50)
logo.Position = UDim2.new(0.9,0,0.1,0)
logo.Visible = false
logo.Active = true
logo.Draggable = true

hideBtn.MouseButton1Click:Connect(function()
	frame.Visible = false
	logo.Visible = true
end)

logo.MouseButton1Click:Connect(function()
	frame.Visible = true
	logo.Visible = false
end)

-- ===== Manual TP Buttons =====
local scrollFrame = Instance.new("ScrollingFrame", frame)
scrollFrame.Size = UDim2.new(1,0,0,120)
scrollFrame.Position = UDim2.new(0,0,0,40)
scrollFrame.BackgroundTransparency = 1
scrollFrame.CanvasSize = UDim2.new(0,0,0,100)
scrollFrame.ScrollBarThickness = 10

local uiList = Instance.new("UIListLayout", scrollFrame)
uiList.SortOrder = Enum.SortOrder.LayoutOrder
uiList.Padding = UDim.new(0,5)

for i = 1, #checkpoints do
	local cp = checkpoints[i]
	local btn = Instance.new("TextButton", scrollFrame)
	btn.Text = "Teleport ke " .. cp.name
	btn.Size = UDim2.new(1,-10,0,30)
	btn.Position = UDim2.new(0,5,0,0)
	btn.BackgroundColor3 = Color3.fromRGB(30,0,30)
	btn.TextColor3 = Color3.fromRGB(255,255,255)
	btn.LayoutOrder = i
	btn.MouseButton1Click:Connect(function()
		if player.Character and player.Character.PrimaryPart then
			player.Character:SetPrimaryPartCFrame(CFrame.new(cp.pos))
			print("📍 Teleport ke " .. cp.name)
		end
	end)
end

-- ===== AutoSummit + Stop =====
local autoBtn = Instance.new("TextButton", frame)
autoBtn.Text = "AutoSummit"
autoBtn.Size = UDim2.new(1,-10,0,40)
autoBtn.Position = UDim2.new(0,5,0,170)
autoBtn.BackgroundColor3 = Color3.fromRGB(90,0,90)
autoBtn.TextColor3 = Color3.fromRGB(255,255,255)

local stopBtn = Instance.new("TextButton", frame)
stopBtn.Text = "Stop"
stopBtn.Size = UDim2.new(0.5,-10,0,40)
stopBtn.Position = UDim2.new(0,5,0,220)
stopBtn.BackgroundColor3 = Color3.fromRGB(100,0,0)
stopBtn.TextColor3 = Color3.fromRGB(255,255,255)

local hopBtn = Instance.new("TextButton", frame)
hopBtn.Text = "Server Hop"
hopBtn.Size = UDim2.new(0.5,-10,0,40)
hopBtn.Position = UDim2.new(0.5,5,0,220)
hopBtn.BackgroundColor3 = Color3.fromRGB(0,0,150)
hopBtn.TextColor3 = Color3.fromRGB(255,255,255)

-- ===== AutoSummit Logic =====
local autoSummitActive = false

local function startAutoSummit()
	autoSummitActive = true
	spawn(function()
		for i = 1,#checkpoints do
			if not autoSummitActive then break end
			local cp = checkpoints[i]
			if player.Character and player.Character.PrimaryPart then
				player.Character:SetPrimaryPartCFrame(CFrame.new(cp.pos))
			end
			wait(4)
			if cp.name == "Puncak" then
				autoSummitActive = false
				print("✅ Sudah sampai puncak, autoSummit berhenti otomatis.")
				break
			end
		end
	end)
end

autoBtn.MouseButton1Click:Connect(startAutoSummit)
stopBtn.MouseButton1Click:Connect(function()
	autoSummitActive = false
	print("⛔ AutoSummit dihentikan manual.")
end)

-- ===== Server Hop =====
hopBtn.MouseButton1Click:Connect(function()
	print("🔄 Server Hop dimulai...")
	local servers = {}
	local req = game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100")
	local data = game:GetService("HttpService"):JSONDecode(req)
	for _,v in pairs(data.data) do
		if v.playing < v.maxPlayers and v.id ~= game.JobId then
			table.insert(servers, v.id)
		end
	end
	if #servers > 0 then
		local randomServer = servers[math.random(1, #servers)]
		tpService:TeleportToPlaceInstance(game.PlaceId, randomServer, player)
	else
		print("⚠️ Tidak ada server lain yang tersedia.")
	end
end)
