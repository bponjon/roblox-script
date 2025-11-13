--// Teleport & Server Hop GUI 
local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "BrainrotGUI"

-- Main Frame
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 250, 0, 150)
frame.Position = UDim2.new(0.5, -125, 0.5, -75)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BorderSizePixel = 2
frame.Active = true
frame.Draggable = true

-- Title Bar
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
title.Text = "Brainrot GUI"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 20

-- Close Button
local close = Instance.new("TextButton", frame)
close.Size = UDim2.new(0, 30, 0, 30)
close.Position = UDim2.new(1, -30, 0, 0)
close.Text = "X"
close.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
close.TextColor3 = Color3.fromRGB(255, 255, 255)
close.MouseButton1Click:Connect(function() gui:Destroy() end)

-- Teleport Button
local tp = Instance.new("TextButton", frame)
tp.Size = UDim2.new(1, -20, 0, 40)
tp.Position = UDim2.new(0, 10, 0, 50)
tp.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
tp.Text = "Teleport ke Brainrot"
tp.TextColor3 = Color3.fromRGB(255, 255, 255)
tp.Font = Enum.Font.SourceSansBold
tp.TextSize = 18

tp.MouseButton1Click:Connect(function()
    local char = player.Character or player.CharacterAdded:Wait()
    char:MoveTo(Vector3.new(-472.293, -5.398, 5.711))
end)

-- Server Hop Button
local hop = Instance.new("TextButton", frame)
hop.Size = UDim2.new(1, -20, 0, 40)
hop.Position = UDim2.new(0, 10, 0, 100)
hop.BackgroundColor3 = Color3.fromRGB(0, 85, 255)
hop.Text = "Server Hop (Manual)"
hop.TextColor3 = Color3.fromRGB(255, 255, 255)
hop.Font = Enum.Font.SourceSansBold
hop.TextSize = 18

hop.MouseButton1Click:Connect(function()
    local Http = game:GetService("HttpService")
    local TPS = game:GetService("TeleportService")
    local Api = "https://games.roblox.com/v1/games/"
    local _place = game.PlaceId
    local servers = Api .. _place .. "/servers/Public?sortOrder=Asc&limit=100"
    local function ListServers(cursor)
        local raw = game:HttpGet(servers .. ((cursor and "&cursor=" .. cursor) or ""))
        return Http:JSONDecode(raw)
    end
    local server
    local data = ListServers()
    for _, v in pairs(data.data) do
        if v.playing < v.maxPlayers then
            server = v.id
            break
        end
    end
    if server then
        TPS:TeleportToPlaceInstance(_place, server, player)
    else
        print("Tidak ada server ditemukan.")
    end
end)
