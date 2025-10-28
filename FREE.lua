-- ===== Server Hop v2 =====
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local player = Players.LocalPlayer

-- ===== GUI =====
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "ServerHopGUI"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 250, 0, 160)
frame.Position = UDim2.new(0.05, 0, 0.1, 0)
frame.BackgroundColor3 = Color3.fromRGB(35, 0, 50)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

-- Title
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.Text = "Server Utility"
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextColor3 = Color3.fromRGB(255, 255, 255)

-- Hide button
local hideBtn = Instance.new("TextButton", frame)
hideBtn.Size = UDim2.new(0, 60, 0, 25)
hideBtn.Position = UDim2.new(0, 5, 0, 5)
hideBtn.Text = "Hide"
hideBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
hideBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
hideBtn.Font = Enum.Font.GothamBold
hideBtn.TextSize = 13

-- Close button
local closeBtn = Instance.new("TextButton", frame)
closeBtn.Size = UDim2.new(0, 30, 0, 25)
closeBtn.Position = UDim2.new(1, -35, 0, 5)
closeBtn.Text = "X"
closeBtn.BackgroundColor3 = Color3.fromRGB(120, 0, 0)
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 13

-- Server Hop button
local hopBtn = Instance.new("TextButton", frame)
hopBtn.Size = UDim2.new(1, -20, 0, 40)
hopBtn.Position = UDim2.new(0, 10, 0, 50)
hopBtn.Text = "🔁 Server Hop"
hopBtn.BackgroundColor3 = Color3.fromRGB(70, 0, 100)
hopBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
hopBtn.Font = Enum.Font.GothamBold
hopBtn.TextSize = 14

-- Rejoin button
local rejoinBtn = Instance.new("TextButton", frame)
rejoinBtn.Size = UDim2.new(1, -20, 0, 40)
rejoinBtn.Position = UDim2.new(0, 10, 0, 100)
rejoinBtn.Text = "🔄 Rejoin Server"
rejoinBtn.BackgroundColor3 = Color3.fromRGB(40, 0, 80)
rejoinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
rejoinBtn.Font = Enum.Font.GothamBold
rejoinBtn.TextSize = 14

-- Logo (buat toggle GUI)
local logo = Instance.new("TextButton", gui)
logo.Size = UDim2.new(0, 50, 0, 50)
logo.Position = UDim2.new(0.9, 0, 0.1, 0)
logo.Text = "🌐"
logo.TextSize = 30
logo.BackgroundColor3 = Color3.fromRGB(40, 0, 60)
logo.TextColor3 = Color3.fromRGB(255, 255, 255)
logo.Visible = false
logo.Active = true
logo.Draggable = true

-- Hide/Show logic
hideBtn.MouseButton1Click:Connect(function()
	frame.Visible = false
	logo.Visible = true
end)
logo.MouseButton1Click:Connect(function()
	frame.Visible = true
	logo.Visible = false
end)

-- Close logic
closeBtn.MouseButton1Click:Connect(function()
	gui:Destroy()
end)

-- ===== FUNGSI =====

-- Fungsi Server Hop
local function serverHop()
	local success, result = pcall(function()
		return game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100")
	end)

	if success and result then
		local decoded = HttpService:JSONDecode(result)
		local servers = {}
		for _, v in pairs(decoded.data) do
			if v.playing < v.maxPlayers then
				table.insert(servers, v.id)
			end
		end
		if #servers > 0 then
			local randomServer = servers[math.random(1, #servers)]
			TeleportService:TeleportToPlaceInstance(game.PlaceId, randomServer, player)
		else
			warn("⚠️ Tidak ada server kosong.")
		end
	else
		warn("❌ Gagal ambil data server.")
	end
end

-- Fungsi Rejoin
local function rejoin()
	TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, player)
end

-- Tombol klik
hopBtn.MouseButton1Click:Connect(serverHop)
rejoinBtn.MouseButton1Click:Connect(rejoin)
