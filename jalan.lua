-- MountBingung FULL Path Recorder (Full-input-style approximation)
-- Client-side loadstring (HP-friendly). Records HRP CFrame samples + jump flags + timestamps.
-- Playback uses Humanoid:MoveTo + Humanoid.Jump to simulate recorded movement.
-- Includes GUI MountBingung-like: Record / Stop / Play / Undo / Delete Range / Clear / Export / Import / Hide / Close
-- Persistent GUI (ResetOnSpawn = false)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local pg = player:WaitForChild("PlayerGui")

-- ===== CONFIG =====
local SAMPLE_INTERVAL_DEFAULT = 0.12  -- seconds between samples (smaller = smoother, heavier)
local MOVE_TIMEOUT = 6                -- seconds to wait for MoveToFinished per waypoint
local WALK_SPEED_PLAYBACK = 16        -- WalkSpeed during playback
local RESTORE_WALKSPEED = true
local STOP_ON_MANUAL_INPUT = true     -- if player gives manual input, stop playback

-- ===== STATE =====
local recording = false
local playing = false
local path = {} -- array of {t = <time since start>, p = {x,y,z}, yaw = <number>, jump = bool}
local startRecordTime = 0
local sampleInterval = SAMPLE_INTERVAL_DEFAULT
local playbackWalkSpeed = WALK_SPEED_PLAYBACK
local originalWalkSpeed = nil

-- helpers
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

-- ===== GUI (MountBingung style) =====
local screen = Instance.new("ScreenGui")
screen.Name = "MountBingung_FullRecorder"
screen.ResetOnSpawn = false
screen.Parent = pg

local frame = Instance.new("Frame", screen)
frame.Name = "MainFrame"
frame.Size = UDim2.new(0,320,0,260)
frame.Position = UDim2.new(0.03,0,0.18,0)
frame.BackgroundColor3 = Color3.fromRGB(40,0,40)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, -120, 0, 34)
title.Position = UDim2.new(0,12,0,6)
title.BackgroundTransparency = 1
title.Text = "MountBingung — Full Recorder"
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.TextColor3 = Color3.fromRGB(240,240,240)
title.TextXAlignment = Enum.TextXAlignment.Left

local closeBtn = Instance.new("TextButton", frame)
closeBtn.Size = UDim2.new(0,44,0,28)
closeBtn.Position = UDim2.new(1,-52,0,6)
closeBtn.Text = "X"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 14
closeBtn.BackgroundColor3 = Color3.fromRGB(150,20,20)
closeBtn.TextColor3 = Color3.fromRGB(255,255,255)

local hideBtn = Instance.new("TextButton", frame)
hideBtn.Size = UDim2.new(0,36,0,28)
hideBtn.Position = UDim2.new(1,-94,0,6)
hideBtn.Text = "_"
hideBtn.Font = Enum.Font.GothamBold
hideBtn.TextSize = 16
hideBtn.BackgroundColor3 = Color3.fromRGB(70,0,70)
hideBtn.TextColor3 = Color3.fromRGB(255,255,255)

local infoLabel = Instance.new("TextLabel", frame)
infoLabel.Size = UDim2.new(1, -20, 0, 18)
infoLabel.Position = UDim2.new(0,10,0,46)
infoLabel.BackgroundTransparency = 1
infoLabel.Text = "Idle — Points: 0 | Interval: "..tostring(sampleInterval).."s"
infoLabel.Font = Enum.Font.SourceSans
infoLabel.TextSize = 12
infoLabel.TextColor3 = Color3.fromRGB(210,210,210)
infoLabel.TextXAlignment = Enum.TextXAlignment.Left

-- buttons row 1
local btnRecord = Instance.new("TextButton", frame)
btnRecord.Size = UDim2.new(0,150,0,40)
btnRecord.Position = UDim2.new(0,10,0,70)
btnRecord.Text = "Start Record"
btnRecord.Font = Enum.Font.GothamBold
btnRecord.TextSize = 15
btnRecord.BackgroundColor3 = Color3.fromRGB(170,0,170)
btnRecord.TextColor3 = Color3.fromRGB(255,255,255)

local btnStop = Instance.new("TextButton", frame)
btnStop.Size = UDim2.new(0,150,0,40)
btnStop.Position = UDim2.new(0,160,0,70)
btnStop.Text = "Stop"
btnStop.Font = Enum.Font.GothamBold
btnStop.TextSize = 15
btnStop.BackgroundColor3 = Color3.fromRGB(100,0,100)
btnStop.TextColor3 = Color3.fromRGB(255,255,255)

-- buttons row 2
local btnPlay = Instance.new("TextButton", frame)
btnPlay.Size = UDim2.new(0,150,0,36)
btnPlay.Position = UDim2.new(0,10,0,120)
btnPlay.Text = "Play Path"
btnPlay.Font = Enum.Font.Gotham
btnPlay.TextSize = 14
btnPlay.BackgroundColor3 = Color3.fromRGB(0,120,40)
btnPlay.TextColor3 = Color3.fromRGB(255,255,255)

local btnClear = Instance.new("TextButton", frame)
btnClear.Size = UDim2.new(0,150,0,36)
btnClear.Position = UDim2.new(0,160,0,120)
btnClear.Text = "Clear"
btnClear.Font = Enum.Font.Gotham
btnClear.TextSize = 14
btnClear.BackgroundColor3 = Color3.fromRGB(120,40,40)
btnClear.TextColor3 = Color3.fromRGB(255,255,255)

-- edit controls
local btnUndo = Instance.new("TextButton", frame)
btnUndo.Size = UDim2.new(0,100,0,28)
btnUndo.Position = UDim2.new(0,10,0,164)
btnUndo.Text = "Undo Last"
btnUndo.Font = Enum.Font.Gotham
btnUndo.TextSize = 12
btnUndo.BackgroundColor3 = Color3.fromRGB(100,0,100)
btnUndo.TextColor3 = Color3.fromRGB(255,255,255)

local delFromBox = Instance.new("TextBox", frame)
delFromBox.Size = UDim2.new(0,60,0,28)
delFromBox.Position = UDim2.new(0,120,0,164)
delFromBox.PlaceholderText = "From idx"
delFromBox.ClearTextOnFocus = true
delFromBox.Text = ""

local delToBox = Instance.new("TextBox", frame)
delToBox.Size = UDim2.new(0,60,0,28)
delToBox.Position = UDim2.new(0,190,0,164)
delToBox.PlaceholderText = "To idx"
delToBox.ClearTextOnFocus = true
delToBox.Text = ""

local btnDeleteRange = Instance.new("TextButton", frame)
btnDeleteRange.Size = UDim2.new(0,48,0,28)
btnDeleteRange.Position = UDim2.new(0,260,0,164)
btnDeleteRange.Text = "Del"
btnDeleteRange.Font = Enum.Font.Gotham
btnDeleteRange.TextSize = 12
btnDeleteRange.BackgroundColor3 = Color3.fromRGB(150,40,40)
btnDeleteRange.TextColor3 = Color3.fromRGB(255,255,255)

-- sample interval and walkspeed
local lblInterval = Instance.new("TextLabel", frame)
lblInterval.Size = UDim2.new(0,140,0,18)
lblInterval.Position = UDim2.new(0,10,0,200)
lblInterval.BackgroundTransparency = 1
lblInterval.Text = "Sample (s):"
lblInterval.Font = Enum.Font.SourceSans
lblInterval.TextSize = 12
lblInterval.TextColor3 = Color3.fromRGB(200,200,200)

local boxInterval = Instance.new("TextBox", frame)
boxInterval.Size = UDim2.new(0,60,0,18)
boxInterval.Position = UDim2.new(0,10,0,218)
boxInterval.PlaceholderText = tostring(sampleInterval)
boxInterval.ClearTextOnFocus = true
boxInterval.Text = ""

local lblWS = Instance.new("TextLabel", frame)
lblWS.Size = UDim2.new(0,120,0,18)
lblWS.Position = UDim2.new(0,100,0,200)
lblWS.BackgroundTransparency = 1
lblWS.Text = "Play WalkSpeed:"
lblWS.Font = Enum.Font.SourceSans
lblWS.TextSize = 12
lblWS.TextColor3 = Color3.fromRGB(200,200,200)

local boxWS = Instance.new("TextBox", frame)
boxWS.Size = UDim2.new(0,60,0,18)
boxWS.Position = UDim2.new(0,100,0,218)
boxWS.PlaceholderText = tostring(playbackWalkSpeed)
boxWS.ClearTextOnFocus = true
boxWS.Text = ""

local btnExport = Instance.new("TextButton", frame)
btnExport.Size = UDim2.new(0,150,0,28)
btnExport.Position = UDim2.new(0,160,0,204)
btnExport.Text = "Export JSON"
btnExport.Font = Enum.Font.SourceSans
btnExport.TextSize = 12
btnExport.BackgroundColor3 = Color3.fromRGB(80,40,120)
btnExport.TextColor3 = Color3.fromRGB(255,255,255)

local btnImport = Instance.new("TextButton", frame)
btnImport.Size = UDim2.new(0,150,0,28)
btnImport.Position = UDim2.new(0,10,0,204)
btnImport.Text = "Import JSON"
btnImport.Font = Enum.Font.SourceSans
btnImport.TextSize = 12
btnImport.BackgroundColor3 = Color3.fromRGB(80,40,120)
btnImport.TextColor3 = Color3.fromRGB(255,255,255)

-- hide icon (draggable)
local icon = Instance.new("ImageButton", screen)
icon.Size = UDim2.new(0,48,0,48)
icon.Position = UDim2.new(0,10,0,120)
icon.BackgroundColor3 = Color3.fromRGB(40,0,40)
icon.Image = "" -- user can set later via Image property
icon.Visible = false
icon.Active = true
icon.Draggable = true

-- import/export prompt
local prompt = Instance.new("TextBox", screen)
prompt.Size = UDim2.new(0,640,0,220)
prompt.Position = UDim2.new(0.5,-320,0.05,0)
prompt.BackgroundColor3 = Color3.fromRGB(250,250,250)
prompt.TextWrapped = true
prompt.Visible = false
prompt.MultiLine = true
prompt.ClearTextOnFocus = false
prompt.Text = ""
prompt.TextColor3 = Color3.fromRGB(10,10,10)
prompt.Font = Enum.Font.SourceSans

-- ===== RECORDING LOGIC (full-ish) =====
-- We'll record CFrame (position+orientation) + Jump events timestamped.
-- Playback: iterate points and MoveTo to each, trigger Jump when recorded.

local function encodePath(tbl)
    return HttpService:JSONEncode(tbl)
end
local function decodePath(str)
    local ok, t = pcall(function() return HttpService:JSONDecode(str) end)
    if ok and type(t) == "table" then return t end
    return nil
end

-- record loop
local recordConn
local function startRecording()
    if recording then return end
    local hrp = getHRP()
    if not hrp then
        infoLabel.Text = "No character to record"
        return
    end
    recording = true
    path = {}
    startRecordTime = tick()
    infoLabel.Text = ("Recording... Points: %d | Interval: %.2fs"):format(#path, sampleInterval)
    recordConn = RunService.Heartbeat:Connect(function(dt)
        if not recording then return end
        local now = tick()
        local elapsed = now - startRecordTime
        -- sample by interval using elapsed
        if (#path == 0) or (elapsed - path[#path].t >= sampleInterval - 1e-6) then
            -- capture
            local hrpNow = getHRP()
            local humanoid = getHumanoid()
            if hrpNow then
                local cf = hrpNow.CFrame
                local yaw = cf:ToEulerAnglesYXZ() -- returns rx,ry,rz (we'll use yaw-ish: rx,ry,rz)
                -- check jump state: detect recent jump input (humanoid.Jump is set when user requests jump)
                local jumpFlag = false
                if humanoid then
                    -- humanoid:GetState() can be used; but simpler: detect if Vertical velocity upwards
                    local vel = hrpNow.Velocity
                    if vel.Y > 1.5 then jumpFlag = true end
                end
                table.insert(path, { t = elapsed, p = {cf.X, cf.Y, cf.Z}, r = {yaw}, jump = jumpFlag })
                infoLabel.Text = ("Recording... Points: %d | Interval: %.2fs"):format(#path, sampleInterval)
            end
        end
    end)
end

local function stopRecording()
    if not recording then return end
    recording = false
    if recordConn then recordConn:Disconnect(); recordConn = nil end
    infoLabel.Text = ("Stopped recording. Points: %d"):format(#path)
end

-- ===== PLAYBACK LOGIC =====
local playStopFlag = false
local function playPath()
    if playing then return end
    if #path == 0 then
        infoLabel.Text = "No path recorded"
        return
    end
    local humanoid = getHumanoid()
    local hrp = getHRP()
    if not humanoid or not hrp then
        infoLabel.Text = "No character/humanoid"
        return
    end

    playing = true
    playStopFlag = false
    infoLabel.Text = "Playing..."
    -- store and set WalkSpeed
    if RESTORE_WALKSPEED then
        originalWalkSpeed = humanoid.WalkSpeed
    end
    humanoid.WalkSpeed = playbackWalkSpeed

    -- iterate samples sequentially using MoveTo
    for i = 1, #path do
        if not playing or playStopFlag then break end
        local node = path[i]
        local targetPos = Vector3.new(node.p[1], node.p[2], node.p[3]) + Vector3.new(0, 0.6, 0)
        -- trigger jump if recorded
        if node.jump then
            pcall(function() humanoid.Jump = true end)
        end
        -- try MoveTo
        local ok, err = pcall(function() humanoid:MoveTo(targetPos) end)
        -- wait for MoveToFinished or until close enough or timeout
        local startT = tick()
        while tick() - startT < MOVE_TIMEOUT do
            if not playing or playStopFlag then break end
            local hrpNow = getHRP()
            if not hrpNow then break end
            if (hrpNow.Position - targetPos).Magnitude <= 2 then break end
            wait(0.04)
        end
        wait(0.02) -- tiny smoothing delay
    end

    -- restore WalkSpeed
    if RESTORE_WALKSPEED and originalWalkSpeed then
        local humNow = getHumanoid()
        if humNow then humNow.WalkSpeed = originalWalkSpeed end
    end

    playing = false
    infoLabel.Text = "Playback finished"
end

-- stop playback
local function stopPlayback()
    playStopFlag = true
    playing = false
    infoLabel.Text = "Playback stopped"
end

-- ===== EDIT FUNCTIONS (Undo, Delete Range, Clear) =====
local function undoLast()
    if #path > 0 then
        table.remove(path, #path)
        infoLabel.Text = ("Points: %d"):format(#path)
    else
        infoLabel.Text = "No points to undo"
    end
end

local function deleteRange(fromIdx, toIdx)
    fromIdx = math.max(1, math.floor(fromIdx or 1))
    toIdx = math.min(#path, math.floor(toIdx or #path))
    if fromIdx > toIdx then
        infoLabel.Text = "Invalid range"
        return
    end
    local new = {}
    for i = 1, #path do
        if i < fromIdx or i > toIdx then
            table.insert(new, path[i])
        end
    end
    path = new
    infoLabel.Text = ("Deleted %d-%d | New points: %d"):format(fromIdx, toIdx, #path)
end

local function clearPath()
    path = {}
    infoLabel.Text = "Path cleared"
end

-- ===== EXPORT / IMPORT =====
local function exportJSON()
    if #path == 0 then
        infoLabel.Text = "No path to export"
        return
    end
    local ok, s = pcall(function() return HttpService:JSONEncode(path) end)
    if ok and s then
        prompt.Text = s
        prompt.Visible = true
        infoLabel.Text = "Exported JSON (copy to save)"
    else
        infoLabel.Text = "Export failed"
    end
end

local function importJSON()
    prompt.Visible = true
    prompt.Text = ""
    infoLabel.Text = "Paste JSON and press Enter"
    local conn
    conn = prompt.FocusLost:Connect(function(enter)
        if not enter then return end
        local txt = prompt.Text
        local dec = decodePath(txt)
        if type(dec) == "table" and #dec > 0 then
            -- sanitize entries
            local new = {}
            for _, node in ipairs(dec) do
                if node and node.p and #node.p == 3 then
                    table.insert(new, node)
                end
            end
            path = new
            infoLabel.Text = ("Imported %d points"):format(#path)
        else
            infoLabel.Text = "Invalid JSON"
        end
        prompt.Visible = false
        conn:Disconnect()
    end)
end

-- ===== UI Bindings =====
btnRecord.MouseButton1Click:Connect(function()
    if not recording then
        -- apply sampleInterval from box if provided
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
    if recording then
        stopRecording()
        btnRecord.Text = "Start Record"
        btnRecord.BackgroundColor3 = Color3.fromRGB(170,0,170)
    end
    if playing then
        stopPlayback()
    end
end)

btnPlay.MouseButton1Click:Connect(function()
    local v = tonumber(boxWS.Text)
    if v and v > 0 then playbackWalkSpeed = v end
    if not playing then
        spawn(function()
            playPath()
        end)
    else
        stopPlayback()
    end
end)

btnClear.MouseButton1Click:Connect(function() clearPath() end)
btnUndo.MouseButton1Click:Connect(function() undoLast() end)
btnDeleteRange.MouseButton1Click:Connect(function()
    local f = tonumber(delFromBox.Text) or 1
    local t = tonumber(delToBox.Text) or #path
    deleteRange(f, t)
end)

btnExport.MouseButton1Click:Connect(exportJSON)
btnImport.MouseButton1Click:Connect(importJSON)

hideBtn.MouseButton1Click:Connect(function()
    frame.Visible = false
    icon.Visible = true
end)
icon.MouseButton1Click:Connect(function()
    frame.Visible = true
    icon.Visible = false
end)

closeBtn.MouseButton1Click:Connect(function()
    recording = false
    playing = false
    screen:Destroy()
end)

-- stop on manual input (optional)
if STOP_ON_MANUAL_INPUT then
    UserInputService.InputBegan:Connect(function(input, gp)
        if gp then return end
        if playing and (input.UserInputType == Enum.UserInputType.Keyboard or input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1) then
            -- stop playback if user gives manual control
            stopPlayback()
            infoLabel.Text = "Playback stopped by input"
        end
    end)
end

-- auto-stop on respawn
player.CharacterAdded:Connect(function()
    recording = false
    playing = false
    infoLabel.Text = "Character respawned - stopped"
    wait(0.6)
end)

-- small helper prints
print("MountBingung Full Recorder loaded.")
print("Usage: Start Record -> walk path (try slow) -> Stop -> Play Path")
print("Tip: reduce SAMPLE_INTERVAL for smoother results but heavier on device.")

-- end of script
