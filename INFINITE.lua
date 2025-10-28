-- MountGemini AutoSummit
local plr = game:GetService("Players").LocalPlayer
local tp = game:GetService("TeleportService")
local hs = game:GetService("HttpService")
local guiParent = plr:WaitForChild("PlayerGui")

local checkpoints = {
    basecamp = Vector3.new(1272.160, 639.021, 1792.852),
    puncak = Vector3.new(-6652.260, 3151.055, -796.739)
}

local autoSummit = false

local function createUI()
    local old = guiParent:FindFirstChild("MGuiV")
    if old then old:Destroy() end

    local g = Instance.new("ScreenGui", guiParent)
    g.Name = "MGuiV"
    g.ResetOnSpawn = false

    local f = Instance.new("Frame", g)
    f.Size = UDim2.new(0, 280, 0, 300)
    f.Position = UDim2.new(0.05, 0, 0.1, 0)
    f.BackgroundColor3 = Color3.fromRGB(50, 0, 50)
    f.BorderSizePixel = 0
    f.Active = true
    f.Draggable = true

    local x = Instance.new("TextButton", f)
    x.Text = "X"
    x.Size = UDim2.new(0, 30, 0, 30)
    x.Position = UDim2.new(1, -35, 0, 5)
    x.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
    x.TextColor3 = Color3.fromRGB(255, 255, 255)
    x.MouseButton1Click:Connect(function() g.Enabled = false end)

    local hide = Instance.new("TextButton", f)
    hide.Text = "Hide"
    hide.Size = UDim2.new(0, 60, 0, 30)
    hide.Position = UDim2.new(0, 5, 0, 5)
    hide.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    hide.TextColor3 = Color3.fromRGB(255, 255, 255)

    local mini = Instance.new("ImageButton", g)
    mini.Size = UDim2.new(0, 50, 0, 50)
    mini.Position = UDim2.new(0.9, 0, 0.1, 0)
    mini.Image = "rbxassetid://YOUR_DRAGON_IMAGE_ID"
    mini.Visible = false
    mini.Active = true
    mini.Draggable = true

    hide.MouseButton1Click:Connect(function()
        f.Visible = false
        mini.Visible = true
    end)
    mini.MouseButton1Click:Connect(function()
        f.Visible = true
        mini.Visible = false
    end)

    local b = Instance.new("TextButton", f)
    b.Text = "Teleport Basecamp"
    b.Size = UDim2.new(1, -10, 0, 30)
    b.Position = UDim2.new(0, 5, 0, 50)
    b.BackgroundColor3 = Color3.fromRGB(30, 0, 30)
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.MouseButton1Click:Connect(function()
        if plr.Character and plr.Character.PrimaryPart then
            plr.Character:SetPrimaryPartCFrame(CFrame.new(checkpoints.basecamp))
        end
    end)

    local p = Instance.new("TextButton", f)
    p.Text = "Teleport Puncak"
    p.Size = UDim2.new(1, -10, 0, 30)
    p.Position = UDim2.new(0, 5, 0, 90)
    p.BackgroundColor3 = Color3.fromRGB(30, 0, 30)
    p.TextColor3 = Color3.fromRGB(255, 255, 255)
    p.MouseButton1Click:Connect(function()
        if plr.Character and plr.Character.PrimaryPart then
            plr.Character:SetPrimaryPartCFrame(CFrame.new(checkpoints.puncak))
        end
    end)

    local auto = Instance.new("TextButton", f)
    auto.Text = "Auto Summit"
    auto.Size = UDim2.new(0.5, -5, 0, 30)
    auto.Position = UDim2.new(0, 5, 1, -40)
    auto.BackgroundColor3 = Color3.fromRGB(80, 0, 80)
    auto.TextColor3 = Color3.fromRGB(255, 255, 255)

    local stop = Instance.new("TextButton", f)
    stop.Text = "Stop"
    stop.Size = UDim2.new(0.5, -5, 0, 30)
    stop.Position = UDim2.new(0.5, 0, 1, -40)
    stop.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
    stop.TextColor3 = Color3.fromRGB(255, 255, 255)

    local sh = Instance.new("TextButton", f)
    sh.Text = "Server Hop"
    sh.Size = UDim2.new(1, -10, 0, 30)
    sh.Position = UDim2.new(0, 5, 0, 130)
    sh.BackgroundColor3 = Color3.fromRGB(0, 0, 100)
    sh.TextColor3 = Color3.fromRGB(255, 255, 255)
    sh.MouseButton1Click:Connect(function()
        local servers = {}
        local ok, raw = pcall(function()
            return game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100")
        end)
        if ok and raw then
            local data = hs:JSONDecode(raw)
            for _, v in pairs(data.data) do
                if v.playing < v.maxPlayers then
                    table.insert(servers, v.id)
                end
            end
        end
        if #servers > 0 then
            tp:TeleportToPlaceInstance(game.PlaceId, servers[math.random(1, #servers)], plr)
        end
    end)

    auto.MouseButton1Click:Connect(function()
        if not autoSummit then
            autoSummit = true
            spawn(function()
                while autoSummit do
                    if plr.Character and plr.Character.PrimaryPart then
                        plr.Character:SetPrimaryPartCFrame(CFrame.new(checkpoints.basecamp))
                    end
                    task.wait(3)
                    if plr.Character and plr.Character.PrimaryPart then
                        plr.Character:SetPrimaryPartCFrame(CFrame.new(checkpoints.puncak))
                    end
                    task.wait(3)
                    if plr.Character then
                        pcall(function() plr.Character:BreakJoints() end)
                    end
                    plr.CharacterAdded:Wait()
                end
            end)
        end
    end)

    stop.MouseButton1Click:Connect(function()
        autoSummit = false
    end)
end

pcall(createUI)
