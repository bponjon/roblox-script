-- REF: Robust Fling (based on your VynRhxJV style)
-- Teleport -> fling -> return. Primary anchored spin, fallback velocity spam.
-- Many safety checks, debounce, mobile-friendly GUI.
-- Use in private/testing places only.

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local LocalPlayer = Players.LocalPlayer

-- ===== CONFIG (tweak these if needed) =====
local FLING_DURATION = 0.16      -- seconds to apply BodyAngularVelocity
local VELO_SPAM_COUNT = 10
local VELO_SPAM_WAIT = 0.04
local LOOP_DELAY = 0.28
local BV_ANGVEL = Vector3.new(0, 8500, 0)
local BV_MAXTORQUE = Vector3.new(9e9, 9e9, 9e9)
local RETURN_SETTLE = 0.06
-- ==========================================

-- state
local looping = false
local busy = false      -- debounce so multiple clicks don't overlap

-- util
local function notifyShort(t, m)
    pcall(function()
        StarterGui:SetCore("SendNotification", {Title = t, Text = m, Duration = 2})
    end)
end

local function safeHRP(character)
    if not character then return nil end
    return character:FindFirstChild("HumanoidRootPart")
end

local function findPlayerByPartial(input)
    if not input then return nil end
    local key = tostring(input):gsub("^%s+",""):gsub("%s+$","")
    local low = key:lower()
    if low == "" then return nil end
    if low == "random" then
        local list = {}
        for _,p in ipairs(Players:GetPlayers()) do if p ~= LocalPlayer then table.insert(list,p) end end
        if #list > 0 then return list[math.random(1,#list)] end
        return nil
    elseif low == "all" then
        return "all"
    end
    for _,p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            local uname = (p.Name or ""):lower()
            local dname = (p.DisplayName or ""):lower()
            if uname:sub(1, #low) == low or dname:sub(1, #low) == low then
                return p
            end
        end
    end
    return nil
end

-- Primary method: anchor local HRP, spin to transfer momentum to target
local function method_anchor_spin(origHRP, tgtHRP)
    if not origHRP or not tgtHRP then return false, "missing hrp" end
    local ok, err = pcall(function()
        -- teleport exactly to target center
        origHRP.CFrame = tgtHRP.CFrame

        -- anchor local HRP so we don't get flung
        origHRP.Anchored = true

        -- create BodyAngularVelocity
        local bv = Instance.new("BodyAngularVelocity")
        bv.MaxTorque = BV_MAXTORQUE
        bv.AngularVelocity = BV_ANGVEL
        bv.P = 10000
        bv.Parent = origHRP

        task.wait(FLING_DURATION)

        if bv and bv.Parent then pcall(function() bv:Destroy() end) end
        origHRP.Anchored = false
    end)
    if not ok then
        -- ensure we unanchor even on error
        pcall(function() origHRP.Anchored = false end)
        return false, tostring(err)
    end
    return true, "anchor_ok"
end

-- Fallback: velocity spam (lighter method for some mobile executors)
local function method_velocity_spam(origHRP, tgtHRP)
    if not origHRP or not tgtHRP then return false, "missing hrp" end
    local ok, err = pcall(function()
        origHRP.CFrame = tgtHRP.CFrame
        for i = 1, VELO_SPAM_COUNT do
            local vec = (tgtHRP.CFrame.LookVector * 12000) + Vector3.new(0, 8000, 0)
            origHRP.Velocity = vec
            task.wait(VELO_SPAM_WAIT)
        end
    end)
    if not ok then return false, tostring(err) end
    return true, "velocity_ok"
end

-- wrapper: teleport -> try anchor -> fallback -> return
local function teleport_fling_return(target)
    if not target or not target.Character then notifyShort("Fling","Target invalid") return end
    if busy then notifyShort("Fling","Busy, wait") return end
    busy = true
    local myChar = LocalPlayer.Character
    if not myChar then notifyShort("Fling","No character"); busy = false; return end
    local origHRP = safeHRP(myChar)
    local tgtHRP = safeHRP(target.Character)
    if not origHRP or not tgtHRP then notifyShort("Fling","Missing HumanoidRootPart"); busy=false; return end

    -- save position safely
    local savedCF
    pcall(function() savedCF = origHRP.CFrame end)

    -- try anchored spin first
    local ok, info = method_anchor_spin(origHRP, tgtHRP)
    if not ok then
        -- try velocity spam fallback
        local ok2, info2 = method_velocity_spam(origHRP, tgtHRP)
        if not ok2 then
            warn("Fling both methods failed:", info, info2)
            notifyShort("Fling","All methods failed")
        else
            notifyShort("Fling","Fallback velocity used")
        end
    else
        notifyShort("Fling","Anchor spin success")
    end

    -- small settle then return
    task.wait(RETURN_SETTLE)
    pcall(function()
        if savedCF then origHRP.CFrame = savedCF end
    end)
    busy = false
end

-- loop runner (when looping ON)
spawn(function()
    while true do
        if looping then
            local gui = LocalPlayer:FindFirstChild("PlayerGui")
            local name = ""
            if gui and gui:FindFirstChild("FINALATIN_FlingGui") then
                local tb = gui.FINALATIN_FlingGui:FindFirstChild("TargetBox")
                if tb and tb:IsA("TextBox") then name = tb.Text or "" end
            end

            if name:lower() == "random" then
                local list = {}
                for _,p in ipairs(Players:GetPlayers()) do if p ~= LocalPlayer then table.insert(list,p) end end
                if #list>0 then teleport_fling_return(list[math.random(1,#list)]) end
            elseif name:lower() == "all" then
                for _,p in ipairs(Players:GetPlayers()) do if p ~= LocalPlayer then teleport_fling_return(p) task.wait(0.09) end end
            else
                local target = findPlayerByPartial(name)
                if target then teleport_fling_return(target) end
            end

            task.wait(LOOP_DELAY)
        else
            task.wait(0.12)
        end
    end
end)

-- GUI creation (mobile-friendly)
local function createGui()
    local pg = LocalPlayer:WaitForChild("PlayerGui")
    if pg:FindFirstChild("FINALATIN_FlingGui") then pg.FINALATIN_FlingGui:Destroy() end

    local screen = Instance.new("ScreenGui", pg)
    screen.Name = "FINALATIN_FlingGui"
    screen.ResetOnSpawn = false

    local frame = Instance.new("Frame", screen)
    frame.Size = UDim2.new(0, 340, 0, 200)
    frame.Position = UDim2.new(0.58, 0, 0.58, 0)
    frame.BackgroundColor3 = Color3.fromRGB(28,28,28)
    frame.Active = true
    frame.Draggable = true
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0,8)

    local title = Instance.new("TextLabel", frame)
    title.Size = UDim2.new(1, -12, 0, 26)
    title.Position = UDim2.new(0,6,0,6)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamBold
    title.Text = "FINALATIN - Fling (refactored)"
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

    flingBtn.MouseButton1Click:Connect(function()
        local txt = inputBox.Text or ""
        local low = tostring(txt):gsub("^%s+",""):gsub("%s+$",""):lower()
        if low == "" then notifyShort("Fling","enter a name or 'random'/'all'"); return end
        if low == "all" then
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LocalPlayer then teleport_fling_return(p) task.wait(0.09) end
            end
            return
        elseif low == "random" then
            local list = {}
            for _, p in ipairs(Players:GetPlayers()) do if p ~= LocalPlayer then table.insert(list,p) end end
            if #list>0 then teleport_fling_return(list[math.random(1,#list)]) end
            return
        else
            local target = findPlayerByPartial(low)
            if target then teleport_fling_return(target) else notifyShort("Fling","Target not found") end
        end
    end)

    loopBtn.MouseButton1Click:Connect(function()
        looping = not looping
        loopBtn.Text = looping and "Loop: ON" or "Loop: OFF"
        loopBtn.BackgroundColor3 = looping and Color3.fromRGB(180,40,40) or Color3.fromRGB(70,70,70)
    end)

    testBtn.MouseButton1Click:Connect(function()
        local myHRP = safeHRP(LocalPlayer.Character)
        if not myHRP then notifyShort("Test","no char"); return end
        local nearest, nd = nil, math.huge
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local d = (p.Character.HumanoidRootPart.Position - myHRP.Position).Magnitude
                if d < nd then nearest, nd = p, d end
            end
        end
        if nearest then teleport_fling_return(nearest) else notifyShort("Test","no players") end
    end)

    closeBtn.MouseButton1Click:Connect(function()
        screen:Destroy()
    end)
end

-- create GUI
pcall(function() createGui() end)
notifyShort("FINALATIN", "GUI ready. Try 'random' or a partial name first.")
