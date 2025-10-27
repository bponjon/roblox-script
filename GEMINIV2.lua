-- ===== MountGemini AutoSummit v2 =====
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
frame.Size = UDim2.new(0,280,0,200)
frame.Position = UDim2.new(0.05,0,0.1,0)
frame.BackgroundColor3 = Color3.fromRGB(50,0,50)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,30)
title.BackgroundColor3 = Color3.fromRGB(30,0,30)
title.TextColor3 = Color3.fromRGB(255,255,255)
title.Text = "MountGemini AutoSummit"
title.TextScaled = true

-- ===== Buttons =====
local autoBtn = Instance.new("TextButton", frame)
autoBtn.Text = "AutoSummit"
autoBtn.Size = UDim2.new(1,-10,0,40)
autoBtn.Position = UDim2.new(0,5,0,40)
autoBtn.BackgroundColor3 = Color3.fromRGB(90,0,90)
autoBtn.TextColor3 = Color3.fromRGB(255,255,255)

local stopBtn = Instance.new("TextButton", frame)
stopBtn.Text = "Stop"
stopBtn.Size = UDim2.new(0.5,-10,0,40)
stopBtn.Position = UDim2.new(0,5,0,90)
stopBtn.BackgroundColor3 = Color3.fromRGB(100,0,0)
stopBtn.TextColor3 = Color3.fromRGB(255,255,255)

local hopBtn = Instance.new("TextButton", frame)
hopBtn.Text = "Server Hop"
hopBtn.Size = UDim2.new(0.5,-10,0,40)
hopBtn.Position = UDim2.new(0.5,5,0,90)
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
