-- MountBingung-style Path Recorder & AutoWalk (client-only)
-- Execute via loadstring / LocalScript (HP-friendly)
-- Records HRP CFrame samples, plays back using Humanoid:MoveTo
-- GUI styled: ungu tua + hitam, draggable, hide->icon, close
-- Author: assistant (custom)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local guiParent = player:WaitForChild("PlayerGui")

-- ===== Config (ubah sesuai preferensi) =====
local SAMPLE_INTERVAL_DEFAULT = 0.28   -- detik antara sampel (lebih kecil = lebih halus & berat)
local WALK_SPEED_DEFAULT = 16          -- speed saat playback
local MOVE_TIMEOUT = 6                 -- max detik nunggu MoveToFinished tiap waypoint
local RESTORE_WALKSPEED = true         -- restore WS setelah playback

-- ===== State =====
local recording = false
local playing = false
local path = {} -- { {p = {x,y,z}, r = {rx,ry,rz}} }
local sampleInterval = SAMPLE_INTERVAL_DEFAULT
local playbackWalkSpeed = WALK_SPEED_DEFAULT
local originalWalkSpeed = nil

-- ===== Helpers =====
local function getCharacter() return player.Character end
local function getHRP()
    local c = getCharacter()
    if not c then return nil end
    return c:FindFirstChild("HumanoidRootPart")
end
local function getHumanoid()
    local c = getCharacter()
    if not c then return nil end
    return c:FindFirstChildOfClass("Humanoid")
end

local function safeEncode(t)
    local ok, out = pcall(function() return HttpService:JSONEncode(t) end)
    if ok then return out else return nil end
end
local function safeDecode(s)
    local ok, out = pcall(function() return HttpService:JSONDecode(s) end)
    if ok then return out else return nil end
end

-- ===== GUI (MountBingung style) =====
local screen = Instance.new("ScreenGui")
screen.Name = "MountBingung_PathRecorder"
screen.ResetOnSpawn = false
screen.Parent = guiParent

local frame = Instance.new("Frame", screen)
frame.Size = UDim2.new(0,300,0,220)
frame.Position = UDim2.new(0.03,0,0.2,0)
frame.BackgroundColor3 = Color3.fromRGB(40, 0, 40) -- ungu tua
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Name = "MainFrame"

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, -60, 0, 36)
title.Position = UDim2.new(0,10,0,6)
title.BackgroundTransparency = 1
title.Text = "MountBingung — Path Recorder"
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.TextColor3 = Color3.fromRGB(240,240,240)
title.TextXAlignment = Enum.TextXAlignment.Left

local closeBtn = Instance.new("TextButton", frame)
closeBtn.Size = UDim2.new(0,40,0,28)
closeBtn.Position = UDim2.new(1,-46,0,6)
closeBtn.Text = "X"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 14
closeBtn.BackgroundColor3 = Color3.fromRGB(140,20,20)
closeBtn.TextColor3 = Color3.fromRGB(255,255,255)

local hideBtn = Instance.new("TextButton", frame)
hideBtn.Size = UDim2.new(0,34,0,28)
hideBtn.Position = UDim2.new(1,-92,0,6)
hideBtn.Text = "_"
hideBtn.Font = Enum.Font.GothamBold
hideBtn.TextSize = 18
hideBtn.BackgroundColor3 = Color3.fromRGB(65,0,65)
hideBtn.TextColor3 = Color3.fromRGB(255,255,255)

local infoLabel = Instance.new("TextLabel", frame)
infoLabel.Size = UDim2.new(1, -20, 0, 18)
infoLabel.Position = UDim2.new(0,10,0,46)
infoLabel.BackgroundTransparency = 1
infoLabel.Text = "Idle — Samples: 0 | Interval: "..tostring(sampleInterval).."s"
infoLabel.Font = Enum.Font.SourceSans
infoLabel.TextSize = 12
infoLabel.TextColor3 = Color3.fromRGB(210,210,210)
infoLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Buttons
local btnRecord = Instance.new("TextButton", frame)
btnRecord.Size = UDim2.new(0,140,0,36)
btnRecord.Position = UDim2.new(0,10,0,70)
btnRecord.Text = "Start Record"
btnRecord.Font = Enum.Font.Gotham
btnRecord.TextSize = 14
btnRecord.BackgroundColor3 = Color3.fromRGB(170,0,170)
btnRecord.TextColor3 = Color3.fromRGB(255,255,255)

local btnStop = Instance.new("TextButton", frame)
btnStop.Size = UDim2.new(0,140,0,36)
btnStop.Position = UDim2.new(0,150,0,70)
btnStop.Text = "Stop"
btnStop.Font = Enum.Font.Gotham
btnStop.TextSize = 14
btnStop.BackgroundColor3 = Color3.fromRGB(100,0,100)
btnStop.TextColor3 = Color3.fromRGB(255,255,255)

local btnPlay = Instance.new("TextButton", frame)
btnPlay.Size = UDim2.new(0,140,0,34)
btnPlay.Position = UDim2.new(0,10,0,112)
btnPlay.Text = "Play Path"
btnPlay.Font = Enum.Font.Gotham
btnPlay.TextSize = 14
btnPlay.BackgroundColor3 = Color3.fromRGB(0,120,40)
btnPlay.TextColor3 = Color3.fromRGB(255,255,255)

local btnClear = Instance.new("TextButton", frame)
btnClear.Size = UDim2.new(0,140,0,34)
btnClear.Position = UDim2.new(0,150,0,112)
btnClear.Text = "Clear"
btnClear.Font = Enum.Font.Gotham
btnClear.TextSize = 14
btnClear.BackgroundColor3 = Color3.fromRGB(120,40,40)
btnClear.TextColor3 = Color3.fromRGB(255,255,255)

local lblInterval = Instance.new("TextLabel", frame)
lblInterval.Size = UDim2.new(0,120,0,20)
lblInterval.Position = UDim2.new(0,10,0,156)
lblInterval.BackgroundTransparency = 1
lblInterval.Text = "Sample interval (s):"
lblInterval.Font = Enum.Font.SourceSans
lblInterval.TextSize = 12
lblInterval.TextColor3 = Color3.fromRGB(200,200,200)

local boxInterval = Instance.new("TextBox", frame)
boxInterval.Size = UDim2.new(0,60,0,20)
boxInterval.Position = UDim2.new(0,130,0,156)
boxInterval.PlaceholderText = tostring(sampleInterval)
boxInterval.ClearTextOnFocus = true
boxInterval.Text = ""

local lblWS = Instance.new("TextLabel", frame)
lblWS.Size = UDim2.new(0,120,0,20)
lblWS.Position = UDim2.new(0,10,0,178)
lblWS.BackgroundTransparency = 1
lblWS.Text = "Playback WalkSpeed:"
lblWS.Font = Enum.Font.SourceSans
lblWS.TextSize = 12
lblWS.TextColor3 = Color3.fromRGB(200,200,200)

local boxWS = Instance.new("TextBox", frame)
boxWS.Size = UDim2.new(0,60,0,20)
boxWS.Position = UDim2.new(0,130,0,178)
boxWS.PlaceholderText = tostring(playbackWalkSpeed)
boxWS.ClearTextOnFocus = true
boxWS.Text = ""

local btnExport = Instance.new("TextButton", frame)
btnExport.Size = UDim2.new(0,140,0,28)
btnExport.Position = UDim2.new(0,10,0,204)
btnExport.Text = "Export JSON"
btnExport.Font = Enum.Font.SourceSans
btnExport.TextSize = 12
btnExport.BackgroundColor3 = Color3.fromRGB(80,40,120)
btnExport.TextColor3 = Color3.fromRGB(255,255,255)

local btnImport = Instance.new("TextButton", frame)
btnImport.Size = UDim2.new(0,140,0,28)
btnImport.Position = UDim2.new(0,150,0,204)
btnImport.Text = "Import JSON"
btnImport.Font = Enum.Font.SourceSans
btnImport.TextSize = 12
btnImport.BackgroundColor3 = Color3.fromRGB(80,40,120)
btnImport.TextColor3 = Color3.fromRGB(255,255,255)

-- Hide icon
local icon = Instance.new("ImageButton", screen)
icon.Size = UDim2.new(0,48,0,48)
icon.Position = UDim2.new(0,10,0,120)
icon.BackgroundColor3 = Color3.fromRGB(40,0,40)
icon.Image = "" -- kosong default; user bisa ganti Image later
icon.Visible = false
icon.Active = true
icon.Draggable = true

-- Prompt box for import/export raw JSON
local prompt = Instance.new("TextBox", screen)
prompt.Size = UDim2.new(0,600,0,200)
prompt.Position = UDim2.new(0.5,-300,0.08,0)
prompt.BackgroundColor3 = Color3.fromRGB(245,245,245)
prompt.TextWrapped = true
prompt.Visible = false
prompt.MultiLine = true
prompt.ClearTextOnFocus = false
prompt.Text = ""
prompt.TextColor3 = Color3.fromRGB(10,10,10)
prompt.Font = Enum.Font.SourceSans

-- ===== Recording logic =====
local function startRecording()
    if recording then return end
    recording = true
    path = {}
    infoLabel.Text = ("Recording... Points: %d | Interval: %.2fs"):format(#path, sampleInterval)
    spawn(function()
        local acc = 0
        local last = tick()
        while recording do
            local now = tick()
            local dt = now - last
            last = now
            acc = acc + dt
            if acc >= sampleInterval then
                acc = acc - sampleInterval
                local hrp = getHRP()
                if hrp then
                    local cf = hrp.CFrame
                    -- store position and Y-axis rotation (yaw) to keep facing direction
                    local px,py,pz = cf.X, cf.Y, cf.Z
                    local rx, ry, rz = cf:ToEulerAnglesYXZ() -- returns radians
                    table.insert(path, {p = {px,py,pz}, r = {rx,ry,rz}})
                    infoLabel.Text = ("Recording... Points: %d | Interval: %.2fs"):format(#path, sampleInterval)
                end
            end
            wait(0.03)
        end
        infoLabel.Text = ("Stopped recording. Points: %d"):format(#path)
    end)
end

local function stopRecording()
    if not recording then return end
    recording = false
    infoLabel.Text = ("Stopped recording. Points: %d"):format(#path)
end

-- Playback using MoveTo step-by-step
local function playPath()
    if playing then return end
    if #path == 0 then
        infoLabel.Text = "No path recorded"
        return
    end
    local humanoid = getHumanoid()
    local hrp = getHRP()
    if not humanoid or not hrp then
        infoLabel.Text = "No character / Humanoid"
        return
    end
    playing = true
    infoLabel.Text = "Playing..."
    -- Save original WS
    if RESTORE_WALKSPEED then
        originalWalkSpeed = humanoid.WalkSpeed
    end
    humanoid.WalkSpeed = playbackWalkSpeed

    for i, node in ipairs(path) do
        if not playing then break end
        if not (player.Character and player.Character.Parent) then break end
        local targetPos = Vector3.new(node.p[1], node.p[2], node.p[3])
        -- small vertical offset so feet don't clip
        targetPos = targetPos + Vector3.new(0, 0.6, 0)

        local ok = pcall(function() humanoid:MoveTo(targetPos) end)
        -- Wait up to MOVE_TIMEOUT or until close
        local startT = tick()
        while tick() - startT < MOVE_TIMEOUT do
            if not playing then break end
            if not (player.Character and player.Character.Parent) then break end
            local hrpNow = getHRP()
            if hrpNow and (hrpNow.Position - targetPos).Magnitude <= 2 then break end
            wait(0.05)
        end
        wait(0.03)
    end

    -- restore walk speed
    if RESTORE_WALKSPEED and originalWalkSpeed then
        local hum = getHumanoid()
        if hum then hum.WalkSpeed = originalWalkSpeed end
    end
    playing = false
    infoLabel.Text = "Playback finished"
end

-- ===== Button binds =====
btnRecord.MouseButton1Click:Connect(function()
    if not recording then
        -- refresh sample interval from box
        local v = tonumber(boxInterval.Text)
        if v and v > 0 then sampleInterval = v end
        startRecording()
        btnRecord.Text = "Recording..."
        btnRecord.BackgroundColor3 = Color3.fromRGB(220,40,80)
    else
        stopRecording()
        btnRecord.Text = "Start Record"
        btnRecord.BackgroundColor3 = Color3.fromRGB(170,0,170)
    end
end)

btnStop.MouseButton1Click:Connect(function()
    -- stop both record & play
    if recording then
        stopRecording()
        btnRecord.Text = "Start Record"
        btnRecord.BackgroundColor3 = Color3.fromRGB(170,0,170)
    end
    if playing then
        playing = false
        infoLabel.Text = "Playback stopped"
    end
end)

btnPlay.MouseButton1Click:Connect(function()
    local v = tonumber(boxWS.Text)
    if v and v > 0 then playbackWalkSpeed = v end
    if not playing then
        spawn(playPath)
    else
        playing = false
    end
end)

btnClear.MouseButton1Click:Connect(function()
    path = {}
    infoLabel.Text = "Path cleared"
end)

btnExport.MouseButton1Click:Connect(function()
    if #path == 0 then
        infoLabel.Text = "No path to export"
        return
    end
    local data = safeEncode(path)
    if data then
        prompt.Text = data
        prompt.Visible = true
        infoLabel.Text = "Exported JSON - copy the text"
    else
        infoLabel.Text = "Export failed"
    end
end)

btnImport.MouseButton1Click:Connect(function()
    prompt.Visible = true
    prompt.Text = ""
    infoLabel.Text = "Paste JSON and press Enter"
    -- wait for user to paste & press Enter (FocusLost)
    local conn
    conn = prompt.FocusLost:Connect(function(enterPressed)
        if not enterPressed then return end
        local txt = prompt.Text
        local decode = safeDecode(txt)
        if type(decode) == "table" then
            -- basic sanitize: ensure each item has p with 3 numbers
            local okcount = 0
            local newpath = {}
            for _, node in ipairs(decode) do
                if node and node.p and #node.p == 3 then
                    table.insert(newpath, node)
                    okcount = okcount + 1
                end
            end
            path = newpath
            infoLabel.Text = "Imported points: "..tostring(#path)
        else
            infoLabel.Text = "Invalid JSON"
        end
        prompt.Visible = false
        conn:Disconnect()
    end)
end)

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
end)

-- auto-stop on respawn
player.CharacterAdded:Connect(function()
    recording = false
    playing = false
    infoLabel.Text = "Character respawned - stopped"
    wait(0.5)
end)

-- quick tips shown once in output
print("MountBingung Path Recorder loaded. Tips:")
print(" - Start Record, walk the path slowly, Stop. Then Play Path.")
print(" - Export JSON to copy path; Import JSON to load on another device.")
print(" - Sample interval lower = smoother path but heavier on device.")
