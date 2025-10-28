-- ===== MountGemini AutoSummit====
local plr = game:GetService("Players").LocalPlayer
local tp = game:GetService("TeleportService")
local guiParent = plr:WaitForChild("PlayerGui")

-- posisi teleport (misal basecamp + puncak)
local checkpoints = {
    basecamp = Vector3.new(1272.160, 639.021, 1792.852),
    puncak   = Vector3.new(-6652.260, 3151.055, -796.739)
}

local autoSummit = false
local privateServerCode = "ccccbafc5e70c140ac26c0dfda8669eb" -- ganti sesuai code yang valid

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

    local tpBaseBtn = Instance.new("TextButton", f)
    tpBaseBtn.Text = "Teleport Basecamp"
    tpBaseBtn.Size = UDim2.new(1, -10, 0, 30)
    tpBaseBtn.Position = UDim2.new(0, 5, 0, 50)
    tpBaseBtn.BackgroundColor3 = Color3.fromRGB(30, 0, 30)
    tpBaseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    tpBaseBtn.MouseButton1Click:Connect(function()
        if plr.Character and plr.Character.PrimaryPart then
            pcall(function() plr.Character:SetPrimaryPartCFrame(CFrame.new(checkpoints.basecamp)) end)
        end
    end)

    local tpPuncakBtn = Instance.new("TextButton", f)
    tpPuncakBtn.Text = "Teleport Puncak"
    tpPuncakBtn.Size = UDim2.new(1, -10, 0, 30)
    tpPuncakBtn.Position = UDim2.new(0, 5, 0, 90)
    tpPuncakBtn.BackgroundColor3 = Color3.fromRGB(30, 0, 30)
    tpPuncakBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    tpPuncakBtn.MouseButton1Click:Connect(function()
        if plr.Character and plr.Character.PrimaryPart then
            pcall(function() plr.Character:SetPrimaryPartCFrame(CFrame.new(checkpoints.puncak)) end)
        end
    end)

    local autoBtn = Instance.new("TextButton", f)
    autoBtn.Text = "Auto Summit"
    autoBtn.Size = UDim2.new(0.5, -5, 0, 30)
    autoBtn.Position = UDim2.new(0, 5, 1, -40)
    autoBtn.BackgroundColor3 = Color3.fromRGB(80, 0, 80)
    autoBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

    local stopBtn = Instance.new("TextButton", f)
    stopBtn.Text = "Stop"
    stopBtn.Size = UDim2.new(0.5, -5, 0, 30)
    stopBtn.Position = UDim2.new(0.5, 0, 1, -40)
    stopBtn.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
    stopBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

    local hopBtn = Instance.new("TextButton", f)
    hopBtn.Text = "Server Hop (Private)"
    hopBtn.Size = UDim2.new(1, -10, 0, 30)
    hopBtn.Position = UDim2.new(0, 5, 0, 130)
    hopBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 100)
    hopBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

    hopBtn.MouseButton1Click:Connect(function()
        -- teleport ke private server (butuh akses)
        local ok, err = pcall(function()
            tp:TeleportToPrivateServer(game.PlaceId, privateServerCode, {plr})
        end)
        if not ok then
            warn("Teleport ke private server gagal:", err)
        end
    end)

    autoBtn.MouseButton1Click:Connect(function()
        if not autoSummit then
            autoSummit = true
            spawn(function()
                while autoSummit do
                    if plr.Character and plr.Character.PrimaryPart then
                        pcall(function() plr.Character:SetPrimaryPartCFrame(CFrame.new(checkpoints.basecamp)) end)
                    end
                    task.wait(3)
                    if plr.Character and plr.Character.PrimaryPart then
                        pcall(function() plr.Character:SetPrimaryPartCFrame(CFrame.new(checkpoints.puncak)) end)
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

    stopBtn.MouseButton1Click:Connect(function()
        autoSummit = false
    end)
end

pcall(createUI)
