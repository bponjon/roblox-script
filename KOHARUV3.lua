-- Mount Koharu AutoSummit
-- Bponjon
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- === checkpoints (Mount Koharu) ===
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

-- === state ===
local autoSummitActive = false
local lastVisitedIndex = 0        -- index of last arrived checkpoint (0 = none yet)
local delayBetween = 10          -- 10 seconds per permintaan
local puncakWait = 10            -- wait at puncak before death
local guiName = "MountGeminiGui_vKoharu"

-- Helper: safe teleport (client-side set CFrame)
local function teleportTo(vec)
    local char = player.Character
    if char and char.PrimaryPart then
        pcall(function()
            char:SetPrimaryPartCFrame(CFrame.new(vec))
        end)
    end
end

-- remember & restore positions (frame & icon) via player attributes
local function saveFramePos(ud)
    if not ud then return end
    player:SetAttribute("MB_FrameXScale", ud.X.Scale)
    player:SetAttribute("MB_FrameXOffset", ud.X.Offset)
    player:SetAttribute("MB_FrameYScale", ud.Y.Scale)
    player:SetAttribute("MB_FrameYOffset", ud.Y.Offset)
end
local function loadFramePos()
    local xs = player:GetAttribute("MB_FrameXScale")
    local xo = player:GetAttribute("MB_FrameXOffset")
    local ys = player:GetAttribute("MB_FrameYScale")
    local yo = player:GetAttribute("MB_FrameYOffset")
    if xs and xo and ys and yo then
        return UDim2.new(xs, xo, ys, yo)
    end
    return nil
end
local function saveIconPos(ud)
    if not ud then return end
    player:SetAttribute("MB_IconXScale", ud.X.Scale)
    player:SetAttribute("MB_IconXOffset", ud.X.Offset)
    player:SetAttribute("MB_IconYScale", ud.Y.Scale)
    player:SetAttribute("MB_IconYOffset", ud.Y.Offset)
end
local function loadIconPos()
    local xs = player:GetAttribute("MB_IconXScale")
    local xo = player:GetAttribute("MB_IconXOffset")
    local ys = player:GetAttribute("MB_IconYScale")
    local yo = player:GetAttribute("MB_IconYOffset")
    if xs and xo and ys and yo then
        return UDim2.new(xs, xo, ys, yo)
    end
    return nil
end

-- === GUI build ===
local function createGui()
    -- cleanup
    local old = playerGui:FindFirstChild(guiName)
    if old then old:Destroy() end

    local screen = Instance.new("ScreenGui")
    screen.Name = guiName
    screen.ResetOnSpawn = false
    screen.Parent = playerGui

    -- frame (smaller so ga nutup layar)
    local frame = Instance.new("Frame", screen)
    frame.Size = UDim2.new(0, 260, 0, 360)
    frame.Position = loadFramePos() or UDim2.new(0.04, 0, 0.12, 0)
    frame.BackgroundColor3 = Color3.fromRGB(50, 0, 50)
    frame.BorderSizePixel = 0
    frame.Active = true
    frame.Draggable = true

    -- save frame pos when moved
    frame:GetPropertyChangedSignal("Position"):Connect(function()
        saveFramePos(frame.Position)
    end)

    local title = Instance.new("TextLabel", frame)
    title.Size = UDim2.new(1, -80, 0, 28)
    title.Position = UDim2.new(0, 12, 0, 6)
    title.BackgroundTransparency = 1
    title.Text = "MountKoharu — AutoSummit"
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.TextColor3 = Color3.fromRGB(245, 245, 245)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 16

    local closeBtn = Instance.new("TextButton", frame)
    closeBtn.Size = UDim2.new(0, 40, 0, 28)
    closeBtn.Position = UDim2.new(1, -52, 0, 6)
    closeBtn.Text = "X"
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.BackgroundColor3 = Color3.fromRGB(160, 20, 20)
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

    local hideBtn = Instance.new("TextButton", frame)
    hideBtn.Size = UDim2.new(0, 56, 0, 28)
    hideBtn.Position = UDim2.new(1, -110, 0, 6)
    hideBtn.Text = "Hide"
    hideBtn.Font = Enum.Font.GothamBold
    hideBtn.BackgroundColor3 = Color3.fromRGB(60, 0, 60)
    hideBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

    -- draggable icon (mini) that appears when frame hidden
    local icon = Instance.new("TextButton", screen)
    icon.Size = UDim2.new(0, 44, 0, 44)
    icon.Position = loadIconPos() or UDim2.new(0.9, 0, 0.08, 0)
    icon.Text = "🚀"
    icon.BackgroundColor3 = Color3.fromRGB(45, 0, 45)
    icon.TextColor3 = Color3.fromRGB(255,255,255)
    icon.Visible = false
    icon.Active = true
    icon.Draggable = true

    -- save icon pos when moved
    icon:GetPropertyChangedSignal("Position"):Connect(function()
        saveIconPos(icon.Position)
    end)

    -- scroll for many checkpoint buttons
    local scrollFrame = Instance.new("ScrollingFrame", frame)
    scrollFrame.Size = UDim2.new(1, -10, 1, -150)
    scrollFrame.Position = UDim2.new(0, 5, 0, 46)
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 10)
    scrollFrame.ScrollBarThickness = 8
    scrollFrame.BackgroundTransparency = 1

    local uiList = Instance.new("UIListLayout", scrollFrame)
    uiList.SortOrder = Enum.SortOrder.LayoutOrder
    uiList.Padding = UDim.new(0, 6)

    -- create CP buttons
    for i, cp in ipairs(checkpoints) do
        local btn = Instance.new("TextButton", scrollFrame)
        btn.Size = UDim2.new(1, 0, 0, 34)
        btn.Text = cp.name
        btn.BackgroundColor3 = Color3.fromRGB(35, 0, 35)
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.Font = Enum.Font.Gotham
        btn.LayoutOrder = i

        btn.MouseButton1Click:Connect(function()
            teleportTo(cp.pos)
            lastVisitedIndex = i
        end)
    end

    uiList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        scrollFrame.CanvasSize = UDim2.new(0, 0, 0, uiList.AbsoluteContentSize.Y + 6)
    end)

    -- bottom controls
    local autoBtn = Instance.new("TextButton", frame)
    autoBtn.Size = UDim2.new(0.5, -8, 0, 36)
    autoBtn.Position = UDim2.new(0, 8, 1, -86)
    autoBtn.Text = "Auto Summit"
    autoBtn.BackgroundColor3 = Color3.fromRGB(90, 0, 90)
    autoBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

    local stopBtn = Instance.new("TextButton", frame)
    stopBtn.Size = UDim2.new(0.5, -8, 0, 36)
    stopBtn.Position = UDim2.new(0.5, 4, 1, -86)
    stopBtn.Text = "Stop"
    stopBtn.BackgroundColor3 = Color3.fromRGB(120, 0, 0)
    stopBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

    local serverHopBtn = Instance.new("TextButton", frame)
    serverHopBtn.Size = UDim2.new(1, -20, 0, 32)
    serverHopBtn.Position = UDim2.new(0, 10, 1, -132)
    serverHopBtn.Text = "Manual Server Hop"
    serverHopBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 100)
    serverHopBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

    -- hide / restore
    hideBtn.MouseButton1Click:Connect(function()
        frame.Visible = false
        icon.Visible = true
    end)
    icon.MouseButton1Click:Connect(function()
        frame.Visible = true
        icon.Visible = false
    end)
    closeBtn.MouseButton1Click:Connect(function()
        screen:Destroy()
        autoSummitActive = false
    end)

    -- server hop function (manual)
    serverHopBtn.MouseButton1Click:Connect(function()
        -- best effort: find public servers with slots (may be rate-limited)
        spawn(function()
            local ok, raw = pcall(function()
                return game:HttpGet("https://games.roblox.com/v1/games/" .. tostring(game.PlaceId) .. "/servers/Public?sortOrder=Asc&limit=100")
            end)
            if not ok or not raw then return end
            local ok2, dec = pcall(function() return game:GetService("HttpService"):JSONDecode(raw) end)
            if not ok2 or type(dec) ~= "table" or not dec.data then return end
            local ids = {}
            for _, v in ipairs(dec.data) do
                if type(v) == "table" and v.playing and v.maxPlayers and v.playing < v.maxPlayers then
                    table.insert(ids, v.id)
                end
            end
            if #ids > 0 then
                pcall(function()
                    game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, ids[math.random(1,#ids)], player)
                end)
            end
        end)
    end)

    -- Auto summit behavior: resume from next CP after lastVisitedIndex
    local function startAuto()
        if autoSummitActive then return end
        autoSummitActive = true
        spawn(function()
            while autoSummitActive do
                -- compute start index
                local startIndex = math.clamp(lastVisitedIndex + 1, 1, #checkpoints)
                for i = startIndex, #checkpoints do
                    if not autoSummitActive then break end
                    local cp = checkpoints[i]
                    teleportTo(cp.pos)
                    lastVisitedIndex = i
                    -- if reached puncak:
                    if i == #checkpoints then
                        -- wait on puncak then die (so summit counts)
                        task.wait(puncakWait)
                        if player.Character then
                            pcall(function() player.Character:BreakJoints() end)
                        end
                        -- reset lastVisitedIndex so next auto-run starts from Basecamp
                        lastVisitedIndex = 0
                        -- wait respawn
                        player.CharacterAdded:Wait()
                        break -- after puncak, break for-loop to restart loop (auto-repeat)
                    else
                        task.wait(delayBetween)
                    end
                end
                -- if loop finished naturally (no puncak?), respawn wait to avoid tight loop
                if autoSummitActive then
                    -- small yield to avoid any accidental busy loop
                    task.wait(0.5)
                end
            end
        end)
    end

    local function stopAuto()
        autoSummitActive = false
    end

    autoBtn.MouseButton1Click:Connect(function()
        -- If currently stopped mid-run (lastVisitedIndex >0 and < #), start will resume from next
        startAuto()
    end)
    stopBtn.MouseButton1Click:Connect(stopAuto)

    -- When player manually teleports via buttons, lastVisitedIndex updated earlier.
    -- Also update lastVisitedIndex on actual character moves by checking proximity (optional):
    -- We'll add a heartbeat watcher that updates lastVisitedIndex if player near a checkpoint (helps if teleport done externally)
    spawn(function()
        while screen.Parent and screen.Parent.Parent do
            local char = player.Character
            if char and char.PrimaryPart then
                local pos = char.PrimaryPart.Position
                for i, cp in ipairs(checkpoints) do
                    if (pos - cp.pos).Magnitude < 6 then -- threshold near CP
                        lastVisitedIndex = i
                        break
                    end
                end
            end
            task.wait(1)
        end
    end)
end

-- init
createGui()
print("MountGemini (Koharu) AutoSummit loaded.")
