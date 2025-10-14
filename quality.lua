-- MountBingung Path Recorder v2 (fix)
-- Client-only loadstring. Records HRP CFrame + jump events reliably and plays back with MoveTo + Jump.
-- Paste & run in executor / LocalScript (HP-friendly).

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local pg = player:WaitForChild("PlayerGui")

-- CONFIG (ubah jika perlu)
local SAMPLE_INTERVAL_DEFAULT = 0.10 -- seconds between samples (smaller = smoother, heavier)
local MOVE_TIMEOUT = 6               -- seconds to wait per waypoint
local PLAY_WALKSPEED = 16
local RESTORE_WALKSPEED = true
local STOP_ON_MANUAL_INPUT = true    -- stop playback when player gives input

-- STATE
local sampleInterval = SAMPLE_INTERVAL_DEFAULT
local recording = false
local playing = false
local path = {} -- { {t=sec, p={x,y,z}, yaw=num, jump=bool} }
local recordStart = 0
local lastSampleTime = 0
local humanoid = nil
local hrp = nil
local originalWalkSpeed = nil

-- helper getters
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

-- bind humanoid references when available
local function refreshHumanoidRefs()
    humanoid = getHumanoid()
    hrp = getHRP()
    -- attach Jump event if humanoid exists
end

-- GUI (MountBingung style compact)
local screen = Instance.new("ScreenGui")
screen.Name = "MountBingung_Recorder_v2"
screen.ResetOnSpawn = false
screen.Parent = pg

local frame = Instance.new("Frame", screen)
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
title.Text = "MountBingung — Recorder v2"
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

-- controls
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
boxWS.PlaceholderText = tostring(PLAY_WALKSPEED)
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

-- hide icon
local icon = Instance.new("ImageButton", screen)
icon.Size = UDim2.new(0,48,0,48)
icon.Position = UDim2.new(0,10,0,120)
icon.BackgroundColor3 = Color3.fromRGB(40,0,40)
icon.Image = ""
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

-- Internals: jump detection
local pendingJump = false
local jumpConn = nil

local function attachJumpListener()
    if humanoid and not jumpConn then
        jumpConn = humanoid.Jumping:Connect(function(isActive)
            -- record immediate jump by setting flag; will be captured at next sample
            if isActive then
                pendingJump = true
            end
        end)
    end
end
local function detachJumpListener()
    if jumpConn then
        jumpConn:Disconnect()
        jumpConn = nil
    end
end

-- Recording loop
local recordHeartbeatConn = nil
local function startRecording()
    if recording then return end
    refreshHumanoidRefs()
    if not hrp then
        infoLabel.Text = "No character to record"
        return
    end
    recording = true
    path = {}
    recordStart = tick()
    lastSampleTime = 0
    infoLabel.Text = ("Recording... Points: %d | Interval: %.2fs"):format(#path, sampleInterval)
    attachJumpListener()

    recordHeartbeatConn = RunService.Heartbeat:Connect(function(dt)
        if not recording then return end
        local now = tick()
        local elapsed = now - recordStart
        if (#path == 0) or (elapsed - (path[#path].t or 0) >= sampleInterval - 1e-6) then
            -- capture sample
            local hrpNow = getHRP()
            local humNow = getHumanoid()
            if hrpNow then
                -- yaw from CFrame: extract Y rotation (approx)
                local rx, ry, rz = hrpNow.CFrame:ToEulerAnglesYXZ()
                local jumpFlag = false
                if pendingJump then
                    jumpFlag = true
                    pendingJump = false
                else
                    -- additional jump detection fallback: vertical velocity
                    if hrpNow.Velocity and hrpNow.Velocity.Y > 1.4 then jumpFlag = true end
                end
                table.insert(path, { t = elapsed, p = {hrpNow.Position.X, hrpNow.Position.Y, hrpNow.Position.Z}, yaw = ry, jump = jumpFlag })
                infoLabel.Text = ("Recording... Points: %d | Interval: %.2fs"):format(#path, sampleInterval)
            end
        end
    end)
end

-- Ensure final flush on stop (push last position)
local function flushFinalSample()
    local hrpNow = getHRP()
    if hrpNow then
        local now = tick()
        local elapsed = now - recordStart
        local rx, ry, rz = hrpNow.CFrame:ToEulerAnglesYXZ()
        local jumpFlag = false
        if hrpNow.Velocity and hrpNow.Velocity.Y > 1.4 then jumpFlag = true end
        -- only add if path empty or last sample differs significantly
        if #path == 0 or (Vector3.new(path[#path].p[1], path[#path].p[2], path[#path].p[3]) - hrpNow.Position).Magnitude > 0.5 then
            table.insert(path, { t = elapsed, p = {hrpNow.Position.X, hrpNow.Position.Y, hrpNow.Position.Z}, yaw = ry, jump = jumpFlag })
        end
    end
end

local function stopRecording()
    if not recording then return end
    recording = false
    if recordHeartbeatConn then
        recordHeartbeatConn:Disconnect()
        recordHeartbeatConn = nil
    end
    flushFinalSample()
    detachJumpListener()
    infoLabel.Text = ("Stopped recording. Points: %d"):format(#path)
end

-- Playback
local playStopRequested = false
local function playPath()
    if playing then return end
    if #path == 0 then
        infoLabel.Text = "No path recorded"
        return
    end
    refreshHumanoidRefs()
    if not humanoid or not hrp then
        infoLabel.Text = "No humanoid/HRP"
        return
    end

    playing = true
    playStopRequested = false
    infoLabel.Text = "Playing..."
    if RESTORE_WALKSPEED then originalWalkSpeed = humanoid.WalkSpeed end
    humanoid.WalkSpeed = tonumber(boxWS.Text) or PLAY_WALKSPEED

    for i = 1, #path do
        if playStopRequested then break end
        local node = path[i]
        local target = Vector3.new(node.p[1], node.p[2], node.p[3]) + Vector3.new(0, 0.6, 0)
        -- trigger jump if recorded (do it slightly before move if needed)
        if node.jump then
            pcall(function() humanoid.Jump = true end)
        end
        -- attempt MoveTo
        local ok = pcall(function() humanoid:MoveTo(target) end)
        local startT = tick()
        while tick() - startT < MOVE_TIMEOUT do
            if playStopRequested then break end
            local hrpNow = getHRP()
            if not hrpNow then break end
            if (hrpNow.Position - target).Magnitude <= 2 then break end
            wait(0.035)
        end
        wait(0.02)
    end

    -- ensure last node reached: if not, try set CFrame small lerp (fallback)
    if not playStopRequested then
        local last = path[#path]
        if last then
            local lastPos = Vector3.new(last.p[1], last.p[2], last.p[3]) + Vector3.new(0,0.6,0)
            local hrpNow = getHRP()
            if hrpNow and (hrpNow.Position - lastPos).Magnitude > 3 then
                -- try gentle approach
                for _=1,6 do
                    local hr = getHRP()
                    if not hr then break end
                    hr.CFrame = hr.CFrame:Lerp(CFrame.new(lastPos), 0.5)
                    wait(0.05)
                end
            end
        end
    end

    -- restore walkspeed
    if RESTORE_WALKSPEED and originalWalkSpeed then
        local humNow = getHumanoid()
        if humNow then humNow.WalkSpeed = originalWalkSpeed end
    end

    playing = false
    playStopRequested = false
    infoLabel.Text = "Playback finished"
end

local function stopPlayback()
    if not playing then return end
    playStopRequested = true
    playing = false
    infoLabel.Text = "Playback stopped"
end

-- Edit helpers
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
    for i=1,#path do
        if i < fromIdx or i > toIdx then
            table.insert(new, path[i])
        end
    end
    path = new
    infoLabel.Text = ("Deleted %d-%d | Points: %d"):format(fromIdx, toIdx, #path)
end

local function clearPath()
    path = {}
    infoLabel.Text = "Path cleared"
end

-- Export / Import
local function exportJSON()
    if #path == 0 then
        infoLabel.Text = "No path to export"
        return
    end
    local ok, s = pcall(function() return HttpService:JSONEncode(path) end)
    if ok and s then
        prompt.Text = s
        prompt.Visible = true
        infoLabel.Text = "Exported JSON - copy text"
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
        local ok, t = pcall(function() return HttpService:JSONDecode(txt) end)
        if ok and type(t) == "table" and #t > 0 then
            local new = {}
            for _, node in ipairs(t) do
                if node and node.p and #node.p == 3 then
                    table.insert(new, node)
                end
            end
            path = new
            infoLabel.Text = ("Imported points: %d"):format(#path)
        else
            infoLabel.Text = "Invalid JSON"
        end
        prompt.Visible = false
        conn:Disconnect()
    end)
end

-- UI Bindings
btnRecord.MouseButton1Click:Connect(function()
    if not recording then
        local v = tonumber(boxInterval.Text)
        if v and v > 0 then sampleInterval = v end
        refreshHumanoidRefs()
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
    if v and v > 0 then PLAY_WALKSPEED = v end
    if not playing then
        spawn(function() playPath() end)
    else
        stopPlayback()
    end
end)

btnClear.MouseButton1Click:Connect(clearPath)
btnUndo.MouseButton1Click:Connect(undoLast)
btnDeleteRange.MouseButton1Click:Connect(function()
    local f = tonumber(delFromBox.Text) or 1
    local t = tonumber(delToBox.Text) or #path
    deleteRange(f,t)
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

-- stop playback on manual input (optional)
if STOP_ON_MANUAL_INPUT then
    UserInputService.InputBegan:Connect(function(inp, processed)
        if processed then return end
        if playing and (inp.UserInputType == Enum.UserInputType.Keyboard or inp.UserInputType == Enum.UserInputType.Touch or inp.UserInputType == Enum.UserInputType.MouseButton1) then
            stopPlayback()
            infoLabel.Text = "Playback stopped by input"
        end
    end)
end

-- ensure refs on respawn
player.CharacterAdded:Connect(function(char)
    wait(0.4)
    refreshHumanoidRefs()
    recording = false
    playing = false
    infoLabel.Text = "Character respawned - stopped"
end)

-- initial refresh
refreshHumanoidRefs()

print("MountBingung Recorder v2 loaded. Tips: walk smooth & slow while recording. Stop to flush final sample.")
