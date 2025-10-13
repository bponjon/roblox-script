-- AutoSummit Teleport GUI (mobile friendly)
-- LocalScript -> StarterPlayer > StarterPlayerScripts

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- ========== CONFIG ==========
local positions = {
    ["Basecamp"] = CFrame.new(166.00293, 14.9578047, 822.983398, 1,0,0,0,1,0,0,0,1),
    ["Checkpoint 1"] = CFrame.new(198.238098, 10.1375217, 128.423187, 0.297114909, -6.26922301e-08, -0.954841733, 6.72768081e-08, 1, -4.47228992e-08, 0.954841733, -5.09508631e-08, 0.297114909),
    ["Checkpoint 2"] = CFrame.new(228.194977, 128.879974, -211.192383, 0.930309892, -1.11155147e-08, 0.36677441, 9.689052236e-09, 1, 5.73020786e-09, -0.36677441, -1.77717285e-09, 0.930309892),
    ["Checkpoint 3"] = CFrame.new(231.817947, 146.768204, -558.723816, 0.99507767, 8.875423956e-09, 0.0990978107, -4.19529134e-10, 1, -8.53496047e-08, -0.0990978107, 8.48879154e-08, 0.99507767),
    ["Checkpoint 4"] = CFrame.new(340.004669, 132.319489, -987.244446, -0.996993601, -4.518562246e-08, 0.0774841309, -4.71957868e-08, 1, -2.41117188e-08, -0.0774841309, -2.76961547e-08, -0.996993601),
    ["Checkpoint 5"] = CFrame.new(393.582062, 119.624352, -1415.08472, 0.756209016, 7.0278702e-08, 0.654330134, -5.55788056e-08, 1, -4.31731735e-08, -0.654330134, -3.71894227e-09, 0.756209016),
    ["Checkpoint 6"] = CFrame.new(344.682739, 190.306702, -2695.90625, 0.980871737, 2.58374264e-08, -0.19465512, -1.79544788e-08, 1, 4.2261334e-08, 0.19465512, -3.79580172e-08, 0.980871737),
    ["Checkpoint 7"] = CFrame.new(353.37085, 243.564514, -3065.35181, 0.978326917, -1.47223256e-08, 0.207066193, 1.8734445e-08, 1, -1.74151431e-08, -0.207066193, 2.09169748e-08, 0.978326917),
    ["Checkpoint 8"] = CFrame.new(-1.62862873, 259.373474, -3431.15869, -0.999732554, 1.05878204e-08, -0.0231267698, 1.0155965e-08, 1, 1.87908646e-08, 0.0231267698, 1.855096346e-08, -0.999732554),
    ["Checkpoint 9"] = CFrame.new(54.7402382, 373.025543, -3835.73633, 0.125666484, 2.95962566e-09, -0.992072523, 1.01765352e-07, 1, 1.58739599e-08, 0.992072523, -1.02953436e-07, 0.125666484),
    ["Checkpoint 10"] = CFrame.new(-347.480225, 505.230347, -4970.26514, -0.292055368, 1.06151949e-08, 0.956401408, 3.49071749e-09, 1, -1.003314320e-08, -0.956401408, 4.08293815e-10, -0.292055368),
    ["Checkpoint 11"] = CFrame.new(-841.818359, 506.035736, -4984.36621, -0.328407794, -2.23714647e-08, 0.94453603, -8.12940915e-09, 1, 2.08586037e-08, -0.94453603, -8.28391855e-10, -0.328407794),
    ["Checkpoint 12"] = CFrame.new(-825.191345, 571.779053, -5727.79297, 0.85375303, 0.0102608558, 0.520577013, -3.63395181e-09, 0.999805808, -0.0197067093, -0.520678163, 0.0168246608, 0.85358727),
    ["Checkpoint 13"] = CFrame.new(-831.682068, 575.300842, -6424.26855, 0.769421041, 0.102390364, 0.630481958, -4.09726875e-09, 0.987068355, -0.160300031, -0.63874197, 0.123338215, 0.759471118),
    ["Checkpoint 14"] = CFrame.new(-288.520508, 661.583984, -6804.15234, 0.0439650156, -0.277349204, 0.959762752, 2.29591568e-09, 0.960691631, 0.277617633, -0.999033093, -0.012205461, 0.0422368236),
    ["Checkpoint 15"] = CFrame.new(675.513794, 743.510742, -7249.33496, 0.379798591, 0.297456264, -0.875941098, -2.32756943e-08, 0.9468925, 0.32155025, 0.925069213, -0.122124314, 0.359628439),
    ["Checkpoint 16"] = CFrame.new(816.311768, 833.685852, -7606.22998, 0.991881549, -0.027550973, 0.124144726, -9.52097956e-10, 0.976248205, 0.216655105, -0.127165124, -0.214896202, 0.968322575),
    ["Checkpoint 17"] = CFrame.new(805.29248, 821.01062, -8516.9082, -0.541260362, 0.118070729, 0.83252418, -2.273996e-09, 0.990092397, -0.140417457, -0.840855062, -0.0760024115, -0.535897791),
    ["Checkpoint 18"] = CFrame.new(473.562775, 879.063538, -8585.45312, -0.0594493598, -0.242220789, 0.968398094, 1.39715528e-09, 0.970113933, 0.242649958, -0.998231351, 0.0144253857, -0.0576726496),
    ["Checkpoint 19"] = CFrame.new(268.831238, 897.108215, -8576.44922, -0.826247036, 0.176753983, -0.534858704, 7.78606246e-09, 0.94949615, 0.313778609, 0.563307941, 0.259258658, -0.784518421),
    ["Checkpoint 20"] = CFrame.new(285.314331, 933.954651, -8983.91992, 0.255577058, -0.153196886, 0.95457375, 1.514940352e-08, 0.987365484, 0.158459529, -0.966788709, -0.0404986069, 0.252347976),
    ["Puncak"] = CFrame.new(107.141029, 988.262573, -9015.23145, -0.914149523, -0.173696652, 0.366278797, 1.36677043e-08, 0.903550506, 0.428481579, -0.405377209, 0.391696215, -0.825980246)
}

local proximityThreshold = 8     -- jarak (stud) untuk "menganggap" checkpoint diinjak
local perCheckpointTimeout = 8   -- detik timeout kalau gak masuk area (jaga agar script nggak nempel forever)

-- ========== GUI ==========
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AutoSummitGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 260, 0, 540)
frame.Position = UDim2.new(0.5, -130, 0.5, -270)
frame.BackgroundColor3 = Color3.fromRGB(20, 0, 30)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, -20, 0, 36)
title.Position = UDim2.new(0, 10, 0, 8)
title.BackgroundTransparency = 1
title.Text = "AutoSummit — Mount Atin"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 18

local closeBtn = Instance.new("TextButton", frame)
closeBtn.Size = UDim2.new(0, 34, 0, 30)
closeBtn.Position = UDim2.new(1, -42, 0, 6)
closeBtn.Text = "✕"
closeBtn.BackgroundColor3 = Color3.fromRGB(90,0,110)
closeBtn.TextColor3 = Color3.new(1,1,1)
closeBtn.Parent = frame
closeBtn.MouseButton1Click:Connect(function() frame.Visible = false end)

-- tombol AutoSummit & Stop
local autoBtn = Instance.new("TextButton", frame)
autoBtn.Size = UDim2.new(0, 120, 0, 36)
autoBtn.Position = UDim2.new(0, 10, 0, 50)
autoBtn.Text = "AutoSummit"
autoBtn.BackgroundColor3 = Color3.fromRGB(110,0,170)
autoBtn.TextColor3 = Color3.new(1,1,1)
autoBtn.Font = Enum.Font.SourceSansBold
autoBtn.TextSize = 16
autoBtn.Parent = frame

local stopBtn = Instance.new("TextButton", frame)
stopBtn.Size = UDim2.new(0, 120, 0, 36)
stopBtn.Position = UDim2.new(0, 140, 0, 50)
stopBtn.Text = "Stop"
stopBtn.BackgroundColor3 = Color3.fromRGB(160,30,30)
stopBtn.TextColor3 = Color3.new(1,1,1)
stopBtn.Font = Enum.Font.SourceSansBold
stopBtn.TextSize = 16
stopBtn.Parent = frame

local toastContainer = Instance.new("Frame", frame)
toastContainer.Size = UDim2.new(1, -20, 0, 26)
toastContainer.Position = UDim2.new(0, 10, 0, 92)
toastContainer.BackgroundTransparency = 1

local function toast(text, time)
    time = time or 2
    local lbl = Instance.new("TextLabel", toastContainer)
    lbl.Size = UDim2.new(1, 0, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = Color3.new(1,1,1)
    lbl.Font = Enum.Font.SourceSans
    lbl.TextSize = 14
    task.delay(time, function() pcall(function() lbl:Destroy() end) end)
end

-- tombol per-pos (scrollable)
local scrollingFrame = Instance.new("ScrollingFrame", frame)
scrollingFrame.Size = UDim2.new(1, -20, 0, 400)
scrollingFrame.Position = UDim2.new(0, 10, 0, 120)
scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 10)
scrollingFrame.BackgroundTransparency = 1
scrollingFrame.ScrollBarThickness = 8

local uiList = Instance.new("UIListLayout", scrollingFrame)
uiList.Padding = UDim.new(0,8)
uiList.HorizontalAlignment = Enum.HorizontalAlignment.Center
uiList.SortOrder = Enum.SortOrder.LayoutOrder

-- create buttons for each pos
local order = {} -- array of names in order
for name, cf in pairs(positions) do
    table.insert(order, name)
end
table.sort(order, function(a,b)
    -- try to keep natural order: Basecamp first, Puncak last, otherwise by name
    if a == "Basecamp" then return true end
    if b == "Basecamp" then return false end
    if a == "Puncak" then return false end
    if b == "Puncak" then return true end
    return a < b
end)

for i, name in ipairs(order) do
    local btn = Instance.new("TextButton")
    btn.Name = "Btn_"..i
    btn.Size = UDim2.new(0, 220, 0, 36)
    btn.LayoutOrder = i
    btn.Text = name
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 15
    btn.BackgroundColor3 = Color3.fromRGB(120,0,160)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Parent = scrollingFrame

    btn.MouseButton1Click:Connect(function()
        if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end
        player.Character.HumanoidRootPart.CFrame = positions[name]
    end)
end

-- adjust canvas size
task.defer(function()
    task.wait(0.05)
    local total = #order
    scrollingFrame.CanvasSize = UDim2.new(0,0,0, total * 44)
end)

-- ========== AutoSummit logic ==========
local running = false
local function isPlayerAlive()
    return player.Character and player.Character.Parent and player.Character:FindFirstChildOfClass("Humanoid") and player.Character:FindFirstChild("Humanoid").Health > 0
end

local function gotoAndWait(cf)
    if not isPlayerAlive() then return false, "dead" end
    local root = player.Character:FindFirstChild("HumanoidRootPart")
    if not root then return false, "no root" end

    -- teleport to near-checkpoint first (slightly above to avoid clipping)
    root.CFrame = cf + Vector3.new(0, 2, 0)

    -- wait until player is within proximityThreshold OR timeout OR died OR user stopped
    local start = tick()
    while running and isPlayerAlive() do
        local dist = (root.Position - cf.Position).Magnitude
        if dist <= proximityThreshold then
            -- give a small buffer so checkpoint trigger registers
            task.wait(0.9)
            return true, "ok"
        end
        if tick() - start > perCheckpointTimeout then
            return false, "timeout"
        end
        task.wait(0.25)
    end
    return false, "stopped"
end

autoBtn.MouseButton1Click:Connect(function()
    if running then return end
    running = true
    toast("AutoSummit started", 1.5)

    -- iterate ordered checkpoints (from order table)
    for _, name in ipairs(order) do
        if not running then break end
        local cf = positions[name]
        if not cf then
            toast("Missing pos: "..tostring(name), 2)
        else
            toast("Going to "..name, 1.2)
            local ok, reason = gotoAndWait(cf)
            if not ok then
                toast("Failed at "..tostring(name).." ("..tostring(reason)..")", 2)
                -- try a short retry once
                if reason == "timeout" and running then
                    toast("Retrying "..name, 1)
                    local ok2, r2 = gotoAndWait(cf)
                    if not ok2 then
                        toast("Skip "..name.." ("..r2..")", 1.6)
                    end
                end
            else
                toast("Reached "..name, 0.9)
            end
            -- short pause to ensure server checkpoint registers
            task.wait(0.6)
        end
        -- if player died while moving, stop
        if not isPlayerAlive() then
            toast("You died — AutoSummit stopped", 2)
            running = false
            break
        end
    end

    if running then
        toast("AutoSummit finished (attempt complete)", 2.4)
    end
    running = false
end)

stopBtn.MouseButton1Click:Connect(function()
    if running then
        running = false
        toast("AutoSummit stopped by user", 1.2)
    end
end)

-- stop AutoSummit if player respawns/dies
player.CharacterAdded:Connect(function()
    if running then
        running = false
        toast("Respawn detected — AutoSummit stopped", 1.6)
    end
end)

-- init
toast("AutoSummit GUI ready", 1.4)
