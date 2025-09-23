-- Teleport-Fling-Return (HP GUI) v1.0
-- Features:
--  - Tap GUI to Fling Once
--  - Loop toggle (auto fling repeatedly)
--  - Teleport -> fling target -> return to original pos
--  - Anchored + BodyAngularVelocity primary method, velocity spam fallback
--  - Safe checks + pcall to reduce crashes on mobile executors

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local LocalPlayer = Players.LocalPlayer

-- Config (ubah kalau mau)
local FLING_DURATION = 0.16    -- detik (lama spin / spam)
local VELO_SPAM_COUNT = 10
local VELO_SPAM_WAIT = 0.04
local LOOP_DELAY = 0.28        -- delay antar fling waktu looping
local BV_ANGVEL = Vector3.new(0, 8000, 0)  -- angular velocity untuk BV
local BV_MAXTORQUE = Vector3.new(9e9, 9e9, 9e9)

-- state
local looping = false

-- helpers
local function notify(title, text)
    pcall(function()
        StarterGui:SetCore("SendNotification", {Title = title, Text = text, Duration = 2})
    end)
end

local function findTargetByPartial(name)
    if not name or name == "" then return nil end
    local lname = name:lower()
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Name:lower():sub(1, #lname) == lname then
            return p
        end
    end
    return nil
end

local function safeHRP(char)
    if not char then return nil end
    return char:FindFirstChild("HumanoidRootPart")
end

-- core fling methods
local function do_anchor_spin(origHRP, tgtHRP)
    -- returns true if BV created (meaning anchored method used)
    local ok, err = pcall(function()
        -- teleport exactly into target (center)
        origHRP.CFrame = tgtHRP.CFrame
        -- anchor local HRP so we don't fly
        origHRP.Anchored = true

        -- create BodyAngularVelocity
        local bv = Instance.new("BodyAngularVelocity")
        bv.MaxTorque = BV_MAXTORQUE
        bv.AngularVelocity = BV_ANGVEL
        bv.P = 10000
        bv.Parent = origHRP

        task.wait(FLING_DURATION)

        if bv and bv.Parent then
            pcall(function() bv:Destroy() end)
        end
        origHRP.Anchored = false
    end)
    if not ok then
        warn("anchor_spin err:", err)
        -- try to ensure unanchored
        pcall(function() origHRP.Anchored = false end)
        return false
    end
    return true
end

local function do_velocity_spam(origHRP, tgtHRP)
    local ok, err = pcall(function()
        origHRP.CFrame = tgtHRP.CFrame
        for i = 1, VELO_SPAM_COUNT do
            -- spam a strong vector outward from target's look vector
            local vec = (tgtHRP.CFrame.LookVector * 12000) + Vector3.new(0, 8000, 0)
            origHRP.Velocity = vec
            task.wait(VELO_SPAM_WAIT)
        end
    end)
    if not ok then
        warn("velocity_spam err:", err)
        return false
    end
    return true
end

-- wrapper: teleport -> try anchor spin -> fallback velocity -> return
local function teleport_fling_return(target)
    if not target or not target.Character then
        notify("Fling", "Target invalid")
        return
    end
    local myChar = LocalPlayer.Character
    if not myChar then notify("Fling", "No character"); return end
    local origHRP = safeHRP(myChar)
    local tgtHRP = safeHRP(target.Character)
    if not origHRP or not tgtHRP then notify("Fling", "Missing HRP"); return end

    -- save original position (try multiple ways)
    local savedCFrame = origHRP.CFrame

    -- try anchored spin first
    local worked = do_anchor_spin(origHRP, tgtHRP)
    if not worked then
        -- fallback velocity spam
        worked = do_velocity_spam(origHRP, tgtHRP)
    end

    -- small settle
    task.wait(0.05)
    -- return to saved position (pcall to avoid errors)
    pcall(function() origHRP.CFrame = savedCFrame end)
end

-- loop runner
spawn(function()
    while true do
        if looping then
            -- read target name from GUI (if exists)
            local pg = LocalPlayer:FindFirstChild("PlayerGui")
            local targetName = ""
            if pg and pg:FindFirstChild("FlingGui") then
                local tbox = pg.FlingGui:FindFirstChild("TargetBox")
                if tbox and tbox:IsA("TextBox") then
                    targetName = tbox.Text or ""
                end
            end

            if targetName:lower() == "random" then
                local list = {}
                for _, p in ipairs(Players:GetPlayers()) do if p ~= LocalPlayer then table.insert(list,p) end end
                if #list > 0 then
                    local t = list[math.random(1,#list)]
                    teleport_fling_return(t)
                end
            else
                local target = findTargetByPartial(targetName)
                if target then
                    teleport_fling_return(target)
                end
            end
            task.wait(LOOP_DELAY)
        else
            task.wait(0.12)
        end
    end
end)

-- GUI (mobile friendly)
local function createGui()
    local pg = LocalPlayer:WaitForChild("PlayerGui")
    if pg:FindFirstChild("FlingGui") then pg.FlingGui:Destroy() end

    local screen = Instance.new("ScreenGui", pg)
    screen.Name = "FlingGui"
    screen.ResetOnSpawn = false

    local frame = Instance.new("Frame", screen)
    frame.Size = UDim2.new(0, 320, 0, 180)
    frame.Position = UDim2.new(0.62, 0, 0.58, 0)
    frame.BackgroundColor3 = Color3.fromRGB(28,28,28)
    frame.BorderSizePixel = 0
    frame.Active = true
    frame.Draggable = true
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0,8)

    local title = Instance.new("TextLabel", frame)
    title.Size = UDim2.new(1, -12, 0, 26)
    title.Position = UDim2.new(0,6,0,6)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamBold
    title.Text = "FLING (teleport → fling → return)"
    title.TextColor3 = Color3.new(1,1,1)
    title.TextSize = 14
    title.TextXAlignment = Enum.TextXAlignment.Left

    local tbox = Instance.new("TextBox", frame)
    tbox.Name = "TargetBox"
    tbox.Size = UDim2.new(1, -12, 0, 36)
    tbox.Position = UDim2.new(0,6,0,36)
    tbox.PlaceholderText = "target (partial) or 'random' or 'all'"
    tbox.BackgroundColor3 = Color3.fromRGB(40,40,40)
    tbox.TextColor3 = Color3.new(1,1,1)
    tbox.ClearTextOnFocus = false
    tbox.Font = Enum.Font.Gotham
    tbox.TextSize = 14

    local flingBtn = Instance.new("TextButton", frame)
    flingBtn.Size = UDim2.new(0.48, -8, 0, 36)
    flingBtn.Position = UDim2.new(0,6,0,82)
    flingBtn.Text = "Fling Once"
    flingBtn.Font = Enum.Font.GothamBold
    flingBtn.TextSize = 14
    flingBtn.BackgroundColor3 = Color3.fromRGB(160,40,40)
    flingBtn.TextColor3 = Color3.new(1,1,1)
    Instance.new("UICorner", flingBtn).CornerRadius = UDim.new(0,6)

    local loopBtn = Instance.new("TextButton", frame)
    loopBtn.Size = UDim2.new(0.48, -8, 0, 36)
    loopBtn.Position = UDim2.new(0.52, 0, 0, 82)
    loopBtn.Text = "Loop: OFF"
    loopBtn.Font = Enum.Font.GothamBold
    loopBtn.TextSize = 14
    loopBtn.BackgroundColor3 = Color3.fromRGB(70,70,70)
    loopBtn.TextColor3 = Color3.new(1,1,1)
    Instance.new("UICorner", loopBtn).CornerRadius = UDim.new(0,6)

    local testBtn = Instance.new("TextButton", frame)
    testBtn.Size = UDim2.new(1, -12, 0, 28)
    testBtn.Position = UDim2.new(0,6,0,126)
    testBtn.Text = "Test Nearest"
    testBtn.Font = Enum.Font.Gotham
    testBtn.TextSize = 13
    testBtn.BackgroundColor3 = Color3.fromRGB(90,90,90)
    testBtn.TextColor3 = Color3.new(1,1,1)
    Instance.new("UICorner", testBtn).CornerRadius = UDim.new(0,6)

    local closeBtn = Instance.new("TextButton", frame)
    closeBtn.Size = UDim2.new(1, -12, 0, 22)
    closeBtn.Position = UDim2.new(0,6,0,156)
    closeBtn.Text = "Close"
    closeBtn.Font = Enum.Font.Gotham
    closeBtn.TextSize = 12
    closeBtn.BackgroundColor3 = Color3.fromRGB(120,40,40)
    closeBtn.TextColor3 = Color3.new(1,1,1)
    Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0,6)

    -- bindings
    flingBtn.MouseButton1Click:Connect(function()
        local txt = tbox.Text or ""
        if txt:lower() == "all" then
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LocalPlayer then teleport_fling_return(p, 0); task.wait(0.09) end
            end
            return
        elseif txt:lower() == "random" then
            local list = {}
            for _, p in ipairs(Players:GetPlayers()) do if p ~= LocalPlayer then table.insert(list,p) end end
            if #list > 0 then teleport_fling_return(list[math.random(1,#list)], 0) end
            return
        end
        local target = findTargetByPartial(txt)
        if target then teleport_fling_return(target, 0) else notify("Fling", "target not found") end
    end)

    loopBtn.MouseButton1Click:Connect(function()
        looping = not looping
        loopBtn.Text = looping and "Loop: ON" or "Loop: OFF"
        loopBtn.BackgroundColor3 = looping and Color3.fromRGB(160,40,40) or Color3.fromRGB(70,70,70)
    end)

    testBtn.MouseButton1Click:Connect(function()
        -- find nearest other player
        local myHRP = safeHRP(LocalPlayer.Character)
        if not myHRP then notify("Test", "no char"); return end
        local nearest, nd = nil, math.huge
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local d = (p.Character.HumanoidRootPart.Position - myHRP.Position).Magnitude
                if d < nd then nearest, nd = p, d end
            end
        end
        if nearest then teleport_fling_return(nearest, 0) else notify("Test","no players") end
    end)

    closeBtn.MouseButton1Click:Connect(function()
        screen:Destroy()
    end)
end

-- build gui
pcall(function() createGui() end)
notify("Fling", "GUI ready — fill target and tap Fling Once or Loop ON")
