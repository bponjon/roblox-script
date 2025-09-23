-- FINALATIN-Style Fling (Owner version)
-- Teleport -> fling target -> return
-- Mobile-friendly GUI, Loop toggle, Random/All support
-- Primary: anchored spin (BodyAngularVelocity). Fallback: velocity spam.
-- Use only in places you own / for testing.

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local LocalPlayer = Players.LocalPlayer

-- ===== Config (ubah kalau mau) =====
local FLING_DURATION    = 0.16   -- seconds to apply fling effect
local VELO_SPAM_COUNT   = 10
local VELO_SPAM_WAIT    = 0.04
local LOOP_DELAY        = 0.28   -- delay between flings when looping
local BV_ANGVEL         = Vector3.new(0, 9000, 0)
local BV_MAXTORQUE      = Vector3.new(9e9, 9e9, 9e9)
local RETURN_SETTLE     = 0.05   -- small wait before returning
-- ===================================

-- state
local looping = false

-- utils
local function safeNotify(title, text)
    pcall(function()
        StarterGui:SetCore("SendNotification", {Title = title, Text = text, Duration = 2})
    end)
end

local function safeHRP(char)
    if not char then return nil end
    return char:FindFirstChild("HumanoidRootPart")
end

-- target finder: partial match on username or displayname; supports "random" and "all"
local function findTargetByPartial(name)
    if not name then return nil end
    local key = tostring(name):gsub("^%s+", ""):gsub("%s+$", "")
    local lname = key:lower()
    if lname == "" then return nil end

    if lname == "random" then
        local list = {}
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then table.insert(list, p) end
        end
        if #list > 0 then return list[math.random(1,#list)] end
        return nil
    elseif lname == "all" then
        return "all"
    end

    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            local uname = (p.Name or ""):lower()
            local dname = (p.DisplayName or ""):lower()
            if uname:sub(1, #lname) == lname or dname:sub(1, #lname) == lname then
                return p
            end
        end
    end
    return nil
end

-- ==== core fling methods ====
local function method_anchor_spin(origHRP, tgtHRP)
    if not origHRP or not tgtHRP then return false end
    local ok, err = pcall(function()
        -- teleport to exact target position
        origHRP.CFrame = tgtHRP.CFrame

        -- anchor to avoid ourselves being flung
        origHRP.Anchored = true

        -- create BodyAngularVelocity
        local bv = Instance.new("BodyAngularVelocity")
        bv.MaxTorque = BV_MAXTORQUE
        bv.AngularVelocity = BV_ANGVEL
        bv.P = 10000
        bv.Parent = origHRP

        task.wait(FLING_DURATION)

        pcall(function() if bv and bv.Parent then bv:Destroy() end end)
        origHRP.Anchored = false
    end)
    if not ok then
        warn("anchor_spin failed:", err)
        pcall(function() origHRP.Anchored = false end)
        return false
    end
    return true
end

local function method_velocity_spam(origHRP, tgtHRP)
    if not origHRP or not tgtHRP then return false end
    local ok, err = pcall(function()
        origHRP.CFrame = tgtHRP.CFrame
        for i = 1, VELO_SPAM_COUNT do
            -- spam a strong vector outward from target; adjust if too strong
            local vec = (tgtHRP.CFrame.LookVector * 12000) + Vector3.new(0, 8000, 0)
            origHRP.Velocity = vec
            task.wait(VELO_SPAM_WAIT)
        end
    end)
    if not ok then
        warn("velocity_spam failed:", err)
        return false
    end
    return true
end

-- wrapper: teleport -> try anchor_spin -> fallback velocity -> return
local function teleport_fling_return(target)
    if not target or not target.Character then
        safeNotify("Fling", "Target invalid")
        return
    end
    local myChar = LocalPlayer.Character
    if not myChar then safeNotify("Fling", "No character"); return end
    local origHRP = safeHRP(myChar)
    local tgtHRP = safeHRP(target.Character)
    if not origHRP or not tgtHRP then safeNotify("Fling", "Missing HRP"); return end

    local saved = origHRP.CFrame
    -- primary method: anchored spin
    local worked = method_anchor_spin(origHRP, tgtHRP)
    if not worked then
        -- fallback velocity spam
        worked = method_velocity_spam(origHRP, tgtHRP)
    end

    task.wait(RETURN_SETTLE)
    pcall(function() origHRP.CFrame = saved end)
end

-- ==== GUI (mobile-friendly) ====
local function createGui()
    local pg = LocalPlayer:WaitForChild("PlayerGui")
    if pg:FindFirstChild("FINALATIN_FlingGui") then
        pg.FINALATIN_FlingGui:Destroy()
    end

    local screen = Instance.new("ScreenGui", pg)
    screen.Name = "FINALATIN_FlingGui"
    screen.ResetOnSpawn = false

    local frame = Instance.new("Frame", screen)
    frame.Size = UDim2.new(0, 340, 0, 200)
    frame.Position = UDim2.new(0.58, 0, 0.58, 0)
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
    title.Text = "FINALATIN - Fling Panel"
    title.TextColor3 = Color3.new(1,1,1)
    title.TextSize = 14
    title.TextXAlignment = Enum.TextXAlignment.Left

    local inputBox = Instance.new("TextBox", frame)
    inputBox.Name = "TargetBox"
    inputBox.Size = UDim2.new(1, -12, 0, 36)
    inputBox.Position = UDim2.new(0, 6, 0, 40)
    inputBox.PlaceholderText = "username / displayname / random / all"
    inputBox.BackgroundColor3 = Color3.fromRGB(40,40,40)
    inputBox.TextColor3 = Color3.new(1,1,1)
    inputBox.ClearTextOnFocus = false
    inputBox.Font = Enum.Font.Gotham
    inputBox.TextSize = 14

    local flingBtn = Instance.new("TextButton", frame)
    flingBtn.Size = UDim2.new(0.48, -8, 0, 36)
    flingBtn.Position = UDim2.new(0, 6, 0, 84)
    flingBtn.Text = "Fling Once"
    flingBtn.Font = Enum.Font.GothamBold
    flingBtn.TextSize = 14
    flingBtn.BackgroundColor3 = Color3.fromRGB(180,40,40)
    flingBtn.TextColor3 = Color3.new(1,1,1)
    Instance.new("UICorner", flingBtn).CornerRadius = UDim.new(0,6)

    local loopBtn = Instance.new("TextButton", frame)
    loopBtn.Size = UDim2.new(0.48, -8, 0, 36)
    loopBtn.Position = UDim2.new(0.52, 0, 0, 84)
    loopBtn.Text = "Loop: OFF"
    loopBtn.Font = Enum.Font.GothamBold
    loopBtn.TextSize = 14
    loopBtn.BackgroundColor3 = Color3.fromRGB(70,70,70)
    loopBtn.TextColor3 = Color3.new(1,1,1)
    Instance.new("UICorner", loopBtn).CornerRadius = UDim.new(0,6)

    local testBtn = Instance.new("TextButton", frame)
    testBtn.Size = UDim2.new(1, -12, 0, 28)
    testBtn.Position = UDim2.new(0, 6, 0, 128)
    testBtn.Text = "Test nearest"
    testBtn.Font = Enum.Font.Gotham
    testBtn.TextSize = 13
    testBtn.BackgroundColor3 = Color3.fromRGB(90,90,90)
    testBtn.TextColor3 = Color3.new(1,1,1)
    Instance.new("UICorner", testBtn).CornerRadius = UDim.new(0,6)

    local closeBtn = Instance.new("TextButton", frame)
    closeBtn.Size = UDim2.new(1, -12, 0, 22)
    closeBtn.Position = UDim2.new(0,6,0,162)
    closeBtn.Text = "Close"
    closeBtn.Font = Enum.Font.Gotham
    closeBtn.TextSize = 12
    closeBtn.BackgroundColor3 = Color3.fromRGB(120,40,40)
    closeBtn.TextColor3 = Color3.new(1,1,1)
    Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0,6)

    -- bindings
    flingBtn.MouseButton1Click:Connect(function()
        local txt = inputBox.Text or ""
        local lower = tostring(txt):gsub("^%s+",""):gsub("%s+$",""):lower()
        if lower == "" then safeNotify("Fling","enter a name or 'random'/'all'"); return end
        if lower == "all" then
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LocalPlayer then teleport_fling_return(p) task.wait(0.09) end
            end
            return
        elseif lower == "random" then
            local list = {}
            for _, p in ipairs(Players:GetPlayers()) do if p ~= LocalPlayer then table.insert(list,p) end end
            if #list>0 then teleport_fling_return(list[math.random(1,#list)]) end
            return
        else
            local target = findTargetByPartial(lower)
            if target then
                teleport_fling_return(target)
            else
                safeNotify("Fling","Target not found")
            end
        end
    end)

    loopBtn.MouseButton1Click:Connect(function()
        looping = not looping
        loopBtn.Text = looping and "Loop: ON" or "Loop: OFF"
        loopBtn.BackgroundColor3 = looping and Color3.fromRGB(180,40,40) or Color3.fromRGB(70,70,70)
    end)

    testBtn.MouseButton1Click:Connect(function()
        local myHRP = safeHRP(LocalPlayer.Character)
        if not myHRP then safeNotify("Test","no char"); return end
        local nearest, nd = nil, math.huge
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local d = (p.Character.HumanoidRootPart.Position - myHRP.Position).Magnitude
                if d < nd then nearest, nd = p, d end
            end
        end
        if nearest then teleport_fling_return(nearest) else safeNotify("Test","no players") end
    end)

    closeBtn.MouseButton1Click:Connect(function()
        screen:Destroy()
    end)
end

-- make GUI
pcall(function() createGui() end)
safeNotify("FINALATIN", "GUI ready — fill target and press Fling Once or Loop ON")
