-- MountKoharu AutoSummit — Resume + Draggable Mini + 6s delay
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- === POSISI CHECKPOINT URUT ===
local checkpoints = {
    { "Basecamp", Vector3.new(-883.288, 43.358, 933.698) },
    { "Checkpoint 1", Vector3.new(-473.240, 49.167, 624.194) },
    { "Checkpoint 2", Vector3.new(-182.927, 52.412, 691.074) },
    { "Checkpoint 3", Vector3.new(122.499, 202.548, 951.741) },
    { "Checkpoint 4", Vector3.new(10.684, 194.377, 340.400) },
    { "Checkpoint 5", Vector3.new(244.394, 194.369, 805.065) },
    { "Checkpoint 6", Vector3.new(660.531, 210.886, 749.360) },
    { "Checkpoint 7", Vector3.new(660.649, 202.965, 368.070) },
    { "Checkpoint 8", Vector3.new(520.852, 214.338, 281.842) },
    { "Checkpoint 9", Vector3.new(523.730, 214.369, -333.936) },
    { "Checkpoint 10", Vector3.new(561.610, 211.787, -559.470) },
    { "Checkpoint 11", Vector3.new(566.837, 282.541, -924.107) },
    { "Checkpoint 12", Vector3.new(115.198, 286.309, -655.635) },
    { "Checkpoint 13", Vector3.new(-308.343, 410.144, -612.031) },
    { "Checkpoint 14", Vector3.new(-487.722, 522.666, -663.426) },
    { "Checkpoint 15", Vector3.new(-679.093, 482.701, -971.988) },
    { "Checkpoint 16", Vector3.new(-559.058, 258.369, -1318.780) },
    { "Checkpoint 17", Vector3.new(-426.353, 374.369, -1512.621) },
    { "Checkpoint 18", Vector3.new(-984.797, 635.003, -1621.875) },
    { "Checkpoint 19", Vector3.new(-1394.228, 797.455, -1563.855) },
    { "Puncak", Vector3.new(-1534.938, 933.116, -2176.096) }
}

local autoSummitActive = false
local lastVisitedIndex = 0 -- index checkpoint terakhir yang sudah dikunjungi (0 = belum)
local TELEPORT_DELAY = 6 -- detik antara teleport (sesuai permintaan)

-- === Server Hop (manual) ===
local function serverHop()
    local ok, raw = pcall(function()
        return game:HttpGet("https://games.roblox.com/v1/games/" .. tostring(game.PlaceId) .. "/servers/Public?sortOrder=Asc&limit=100")
    end)
    if not ok or not raw then return end

    local decoded
    ok, decoded = pcall(function() return HttpService:JSONDecode(raw) end)
    if not ok or type(decoded) ~= "table" or not decoded.data then return end

    local candidates = {}
    for _, v in ipairs(decoded.data) do
        if type(v) == "table" and v.playing and v.maxPlayers and v.playing < v.maxPlayers then
            table.insert(candidates, v.id)
        end
    end

    if #candidates > 0 then
        local choice = candidates[math.random(1, #candidates)]
        pcall(function()
            TeleportService:TeleportToPlaceInstance(game.PlaceId, choice, player)
        end)
    end
end

-- === GUI BUILD ===
local function createGui()
    -- cleanup
    local old = playerGui:FindFirstChild("MountKoharuGui")
    if old then old:Destroy() end

    local screen = Instance.new("ScreenGui")
    screen.Name = "MountKoharuGui"
    screen.ResetOnSpawn = false
    screen.Parent = playerGui

    local frame = Instance.new("Frame", screen)
    frame.Size = UDim2.new(0, 320, 0, 460)
    frame.Position = UDim2.new(0.04, 0, 0.12, 0)
    frame.BackgroundColor3 = Color3.fromRGB(50, 0, 60)
    frame.BorderSizePixel = 0
    frame.Active = true
    frame.Draggable = true

    local title = Instance.new("TextLabel", frame)
    title.Size = UDim2.new(1, -100, 0, 28)
    title.Position = UDim2.new(0, 12, 0, 6)
    title.BackgroundTransparency = 1
    title.Text = "Mount Koharu — AutoSummit"
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.TextColor3 = Color3.fromRGB(245, 245, 245)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 16

    local closeBtn = Instance.new("TextButton", frame)
    closeBtn.Size = UDim2.new(0, 40, 0, 28)
    closeBtn.Position = UDim2.new(1, -52, 0, 6)
    closeBtn.Text = "X"
    closeBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

    local hideBtn = Instance.new("TextButton", frame)
    hideBtn.Size = UDim2.new(0, 40, 0, 28)
    hideBtn.Position = UDim2.new(1, -100, 0, 6)
    hideBtn.Text = "-"
    hideBtn.BackgroundColor3 = Color3.fromRGB(70, 0, 70)
    hideBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

    local scroll = Instance.new("ScrollingFrame", frame)
    scroll.Size = UDim2.new(1, -20, 0, 330)
    scroll.Position = UDim2.new(0, 10, 0, 40)
    scroll.ScrollBarThickness = 6
    scroll.CanvasSize = UDim2.new(0, 0, 0, #checkpoints * 36)
    scroll.BackgroundTransparency = 1

    -- create ordered buttons and hook updates to lastVisitedIndex
    for i, cp in ipairs(checkpoints) do
        local btn = Instance.new("TextButton", scroll)
        btn.Size = UDim2.new(1, -4, 0, 30)
        btn.Position = UDim2.new(0, 2, 0, (i - 1) * 32)
        btn.Text = cp[1]
        btn.BackgroundColor3 = Color3.fromRGB(60, 0, 70)
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)

        btn.MouseButton1Click:Connect(function()
            if player.Character and player.Character.PrimaryPart then
                pcall(function() player.Character:SetPrimaryPartCFrame(CFrame.new(cp[2])) end)
                lastVisitedIndex = i -- update last visited (manual teleport)
            end
        end)
    end

    local autoBtn = Instance.new("TextButton", frame)
    autoBtn.Size = UDim2.new(0.33, -8, 0, 36)
    autoBtn.Position = UDim2.new(0, 10, 1, -46)
    autoBtn.Text = "Auto"
    autoBtn.BackgroundColor3 = Color3.fromRGB(90, 0, 90)
    autoBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

    local stopBtn = Instance.new("TextButton", frame)
    stopBtn.Size = UDim2.new(0.33, -8, 0, 36)
    stopBtn.Position = UDim2.new(0.34, 4, 1, -46)
    stopBtn.Text = "Stop"
    stopBtn.BackgroundColor3 = Color3.fromRGB(120, 0, 0)
    stopBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

    local hopBtn = Instance.new("TextButton", frame)
    hopBtn.Size = UDim2.new(0.33, -8, 0, 36)
    hopBtn.Position = UDim2.new(0.67, 4, 1, -46)
    hopBtn.Text = "Server Hop"
    hopBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 100)
    hopBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    hopBtn.MouseButton1Click:Connect(serverHop)

    -- mini draggable button (created/used when hide pressed)
    local miniBtn
    local function createMini()
        if miniBtn and miniBtn.Parent then return miniBtn end
        miniBtn = Instance.new("TextButton", screen)
        miniBtn.Size = UDim2.new(0, 60, 0, 40)
        miniBtn.Position = UDim2.new(0.02, 0, 0.12, 0)
        miniBtn.Text = "Show"
        miniBtn.Active = true
        miniBtn.Draggable = true -- draggable mini
        miniBtn.BackgroundColor3 = Color3.fromRGB(80, 0, 80)
        miniBtn.TextColor3 = Color3.fromRGB(255,255,255)
        miniBtn.ZIndex = 9999

        miniBtn.MouseButton1Click:Connect(function()
            frame.Visible = true
            if miniBtn then pcall(function() miniBtn:Destroy() end) end
        end)
        return miniBtn
    end

    hideBtn.MouseButton1Click:Connect(function()
        frame.Visible = false
        createMini()
    end)

    closeBtn.MouseButton1Click:Connect(function()
        autoSummitActive = false
        screen:Destroy()
    end)

    -- Auto logic with resume: start from lastVisitedIndex+1 (or 1 if none)
    local function startAutoSummit()
        if autoSummitActive then return end
        autoSummitActive = true
        task.spawn(function()
            while autoSummitActive do
                local startIndex = (lastVisitedIndex or 0) + 1
                if startIndex > #checkpoints then startIndex = 1 end

                for i = startIndex, #checkpoints do
                    if not autoSummitActive then break end
                    local cp = checkpoints[i]
                    if player.Character and player.Character.PrimaryPart then
                        pcall(function() player.Character:SetPrimaryPartCFrame(CFrame.new(cp[2])) end)
                    end
                    lastVisitedIndex = i -- mark visited
                    task.wait(TELEPORT_DELAY)
                end

                -- reached Puncak (end of list) -> force death to count summit, then reset lastVisitedIndex to 0 (so next resume starts from basecamp)
                if autoSummitActive then
                    pcall(function() player.Character:BreakJoints() end)
                    lastVisitedIndex = 0
                    player.CharacterAdded:Wait()
                end
            end
        end)
    end

    autoBtn.MouseButton1Click:Connect(startAutoSummit)
    stopBtn.MouseButton1Click:Connect(function()
        autoSummitActive = false
    end)
end

createGui()
print("✅ MountKoharu AutoSummit (resume + draggable mini + 6s delay) loaded.")
