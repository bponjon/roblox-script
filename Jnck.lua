-- MountBingung AutoWalk Recorder + ALWAYS-ON Pathfinding (client-only)
-- Client loadstring: record HRP samples + jump flags; playback uses PathfindingService for EVERY segment.
-- Execute on your client (HP). Safe client-only.

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local PathfindingService = game:GetService("PathfindingService")

local player = Players.LocalPlayer
local pg = player:WaitForChild("PlayerGui")

-- CONFIG
local SAMPLE_INTERVAL_DEFAULT = 0.12
local PLAY_WALKSPEED_DEFAULT = 16
local RESTORE_WALKSPEED = true
local MOVE_TIMEOUT = 6
local STOP_ON_MANUAL_INPUT = true

-- STATE
local sampleInterval = SAMPLE_INTERVAL_DEFAULT
local recording = false
local playing = false
local path = {} -- { {t=sec, p={x,y,z}, yaw=num, jump=bool} }
local recordStart = 0
local humanoid, hrp
local recordConn, jumpConn
local pendingJump = false
local playStopRequested = false

-- GUI build (compact MountBingung style)
local screen = Instance.new("ScreenGui")
screen.Name = "MB_AutoWalk_Pathfind"
screen.ResetOnSpawn = false
screen.Parent = pg

local frame = Instance.new("Frame", screen)
frame.Size = UDim2.new(0,320,0,240)
frame.Position = UDim2.new(0.03,0,0.18,0)
frame.BackgroundColor3 = Color3.fromRGB(35,0,45)
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, -110, 0, 34)
title.Position = UDim2.new(0,10,0,6)
title.BackgroundTransparency = 1
title.Text = "MountBingung — AutoWalk (Pathfind)"
title.TextColor3 = Color3.fromRGB(245,245,245)
title.Font = Enum.Font.GothamBold
title.TextSize = 15
title.TextXAlignment = Enum.TextXAlignment.Left

local closeBtn = Instance.new("TextButton", frame)
closeBtn.Size = UDim2.new(0,44,0,28)
closeBtn.Position = UDim2.new(1,-52,0,6)
closeBtn.Text = "X"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.BackgroundColor3 = Color3.fromRGB(150,20,20)
closeBtn.TextColor3 = Color3.fromRGB(255,255,255)

local hideBtn = Instance.new("TextButton", frame)
hideBtn.Size = UDim2.new(0,36,0,28)
hideBtn.Position = UDim2.new(1,-94,0,6)
hideBtn.Text = "_"
hideBtn.Font = Enum.Font.GothamBold
hideBtn.BackgroundColor3 = Color3.fromRGB(70,0,70)
hideBtn.TextColor3 = Color3.fromRGB(255,255,255)

local infoLabel = Instance.new("TextLabel", frame)
infoLabel.Size = UDim2.new(1,-20,0,18)
infoLabel.Position = UDim2.new(0,10,0,46)
infoLabel.BackgroundTransparency = 1
infoLabel.Text = "Idle — Points: 0 | Interval: "..tostring(sampleInterval).."s"
infoLabel.TextColor3 = Color3.fromRGB(210,210,210)
infoLabel.Font = Enum.Font.SourceSans
infoLabel.TextSize = 12
infoLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Buttons
local btnRecord = Instance.new("TextButton", frame)
btnRecord.Size = UDim2.new(0,150,0,44)
btnRecord.Position = UDim2.new(0,10,0,72)
btnRecord.Text = "Start Record"

local btnStop = Instance.new("TextButton", frame)
btnStop.Size = UDim2.new(0,150,0,44)
btnStop.Position = UDim2.new(0,160,0,72)
btnStop.Text = "Stop"

local btnPlay = Instance.new("TextButton", frame)
btnPlay.Size = UDim2.new(0,150,0,36)
btnPlay.Position = UDim2.new(0,10,0,124)
btnPlay.Text = "Play Path"

local btnClear = Instance.new("TextButton", frame)
btnClear.Size = UDim2.new(0,150,0,36)
btnClear.Position = UDim2.new(0,160,0,124)
btnClear.Text = "Clear"

local btnUndo = Instance.new("TextButton", frame)
btnUndo.Size = UDim2.new(0,100,0,28)
btnUndo.Position = UDim2.new(0,10,0,172)
btnUndo.Text = "Undo Last"

local delFromBox = Instance.new("TextBox", frame)
delFromBox.Size = UDim2.new(0,60,0,28)
delFromBox.Position = UDim2.new(0,120,0,172)
delFromBox.PlaceholderText = "From idx"

local delToBox = Instance.new("TextBox", frame)
delToBox.Size = UDim2.new(0,60,0,28)
delToBox.Position = UDim2.new(0,190,0,172)
delToBox.PlaceholderText = "To idx"

local delBtn = Instance.new("TextButton", frame)
delBtn.Size = UDim2.new(0,48,0,28)
delBtn.Position = UDim2.new(0,260,0,172)
delBtn.Text = "Del"

local lblInterval = Instance.new("TextLabel", frame)
lblInterval.Size = UDim2.new(0,120,0,18)
lblInterval.Position = UDim2.new(0,10,0,204)
lblInterval.BackgroundTransparency = 1
lblInterval.Text = "Sample (s):"
lblInterval.TextColor3 = Color3.fromRGB(200,200,200)

local boxInterval = Instance.new("TextBox", frame)
boxInterval.Size = UDim2.new(0,60,0,18)
boxInterval.Position = UDim2.new(0,80,0,204)
boxInterval.PlaceholderText = tostring(sampleInterval)

local lblWS = Instance.new("TextLabel", frame)
lblWS.Size = UDim2.new(0,100,0,18)
lblWS.Position = UDim2.new(0,150,0,204)
lblWS.BackgroundTransparency = 1
lblWS.Text = "Play WS:"
lblWS.TextColor3 = Color3.fromRGB(200,200,200)

local boxWS = Instance.new("TextBox", frame)
boxWS.Size = UDim2.new(0,60,0,18)
boxWS.Position = UDim2.new(0,200,0,204)
boxWS.PlaceholderText = tostring(PLAY_WALKSPEED_DEFAULT)

local btnExport = Instance.new("TextButton", frame)
btnExport.Size = UDim2.new(0,150,0,26)
btnExport.Position = UDim2.new(0,10,0,226)
btnExport.Text = "Export JSON"

local btnImport = Instance.new("TextButton", frame)
btnImport.Size = UDim2.new(0,150,0,26)
btnImport.Position = UDim2.new(0,160,0,226)
btnImport.Text = "Import JSON"

-- hide icon
local icon = Instance.new("ImageButton", screen)
icon.Size = UDim2.new(0,48,0,48)
icon.Position = UDim2.new(0,10,0,120)
icon.BackgroundColor3 = Color3.fromRGB(35,0,45)
icon.Visible = false
icon.Active = true
icon.Draggable = true
icon.Image = ""

local prompt = Instance.new("TextBox", screen)
prompt.Size = UDim2.new(0,640,0,220)
prompt.Position = UDim2.new(0.5,-320,0.05,0)
prompt.Visible = false
prompt.MultiLine = true
prompt.ClearTextOnFocus = false

-- styling
local buttons = {btnRecord, btnStop, btnPlay, btnClear, btnUndo, delBtn, btnExport, btnImport}
for _,b in pairs(buttons) do
    b.Font = Enum.Font.Gotham
    b.TextSize = 14
    b.BackgroundColor3 = Color3.fromRGB(90,0,90)
    b.TextColor3 = Color3.fromRGB(255,255,255)
end
btnPlay.BackgroundColor3 = Color3.fromRGB(0,120,40)
btnClear.BackgroundColor3 = Color3.fromRGB(120,40,40)
btnStop.BackgroundColor3 = Color3.fromRGB(70,0,70)
btnRecord.BackgroundColor3 = Color3.fromRGB(170,0,170)

-- helpers
local function yawFromCFrame(cf)
    local rx, ry, rz = cf:ToEulerAnglesYXZ()
    return ry
end

local function refreshRefs()
    local char = player.Character
    if char then
        humanoid = char:FindFirstChildOfClass("Humanoid")
        hrp = char:FindFirstChild("HumanoidRootPart")
    else
        humanoid = nil; hrp = nil
    end
end

-- record sample
local function recordSample()
    if not hrp then return end
    local cf = hrp.CFrame
    local t = tick() - recordStart
    local yaw = yawFromCFrame(cf)
    local jumpFlag = false
    if pendingJump then jumpFlag = true; pendingJump = false end
    if hrp.Velocity and hrp.Velocity.Y > 1.4 then jumpFlag = true end
    table.insert(path, { t = t, p = {cf.X, cf.Y, cf.Z}, yaw = yaw, jump = jumpFlag })
    infoLabel.Text = ("Recording... Points: %d | Interval: %.2fs"):format(#path, sampleInterval)
end

-- attach/detach jump listener
local function attachJump()
    if humanoid and not jumpConn then
        jumpConn = humanoid.Jumping:Connect(function(isActive)
            if isActive then pendingJump = true end
        end)
    end
end
local function detachJump()
    if jumpConn then jumpConn:Disconnect(); jumpConn = nil end
end

-- start/stop record
local function startRecord()
    if recording then return end
    refreshRefs()
    if not hrp then infoLabel.Text = "No character to record"; return end
    recording = true
    path = {}
    recordStart = tick()
    pendingJump = false
    attachJump()
    local acc = 0
    recordConn = RunService.Heartbeat:Connect(function(dt)
        if not recording then return end
        acc = acc + dt
        if #path == 0 or acc >= sampleInterval then
            acc = 0
            recordSample()
        end
    end)
    infoLabel.Text = ("Recording... Points: %d | Interval: %.2fs"):format(#path, sampleInterval)
end

local function flushFinal()
    refreshRefs()
    if hrp then
        local lastPos = hrp.Position
        if #path == 0 or (Vector3.new(path[#path].p[1], path[#path].p[2], path[#path].p[3]) - lastPos).Magnitude > 0.4 then
            local cf = hrp.CFrame
            table.insert(path, { t = tick() - recordStart, p = {cf.X, cf.Y, cf.Z}, yaw = yawFromCFrame(cf), jump = (hrp.Velocity and hrp.Velocity.Y > 1.4) or false })
        end
    end
end

local function stopRecord()
    if not recording then return end
    recording = false
    if recordConn then recordConn:Disconnect(); recordConn = nil end
    flushFinal()
    detachJump()
    infoLabel.Text = ("Stopped recording. Points: %d"):format(#path)
end

-- playback helpers using PathfindingService
local function followPathway(waypoints)
    for _, wp in ipairs(waypoints) do
        if not playing then return false end
        local pos = wp.Position
        -- if Pathfinding waypoint requests Jump, trigger
        if wp.Action == Enum.PathWaypointAction.Jump or wp.Action == Enum.PathWaypointAction.Jump then
            pcall(function() humanoid.Jump = true end)
        end
        local ok, err = pcall(function() humanoid:MoveTo(pos) end)
        if not ok then
            -- fallback to teleport-like lerp
            local hr = hrp
            if hr then
                for i=1,6 do
                    if not playing then break end
                    hr.CFrame = hr.CFrame:Lerp(CFrame.new(pos), 0.5)
                    wait(0.04)
                end
            end
        else
            local startT = tick()
            while tick() - startT < MOVE_TIMEOUT do
                if not playing then return false end
                local hrNow = hrp
                if not hrNow then break end
                if (hrNow.Position - pos).Magnitude <= 2 then break end
                wait(0.04)
            end
        end
    end
    return true
end

-- play path: for each recorded node, run pathfinding from current to node
local function playPath()
    if playing then return end
    if #path == 0 then infoLabel.Text = "No path recorded"; return end
    refreshRefs()
    if not humanoid or not hrp then infoLabel.Text = "No humanoid"; return end

    playing = true
    playStopRequested = false
    infoLabel.Text = "Playing..."
    local prevWS = humanoid.WalkSpeed
    if RESTORE_WALKSPEED then prevWS = humanoid.WalkSpeed end
    humanoid.WalkSpeed = tonumber(boxWS.Text) or PLAY_WALKSPEED_DEFAULT

    -- teleport to start node smoothly
    local first = path[1]
    if first then
        pcall(function()
            hrp.CFrame = CFrame.new(first.p[1], first.p[2], first.p[3]) * CFrame.Angles(0, first.yaw or 0, 0)
        end)
        wait(0.06)
    end

    for i = 1, #path do
        if not playing then break end
        local node = path[i]
        local target = Vector3.new(node.p[1], node.p[2], node.p[3])
        -- if node.jump true, attempt to set Jump before path (helps clearing small steps)
        if node.jump then
            pcall(function() humanoid.Jump = true end)
        end

        -- create path from current hrp to target
        refreshRefs()
        if not hrp then break end
        local startPos = hrp.Position
        local pf = PathfindingService:CreatePath({
            AgentRadius = 2,
            AgentHeight = 5,
            AgentCanJump = true,
            AgentMaxSlope = 45,
            WaypointSpacing = 2
        })
        local success, computeErr = pcall(function() pf:ComputeAsync(startPos, target) end)
        local status = nil
        if success then
            status = pf.Status
        else
            status = Enum.PathStatus.NoPath
        end

        if status == Enum.PathStatus.Success then
            local waypoints = pf:GetWaypoints()
            -- follow path waypoints
            local ok = followPathway(waypoints)
            if not ok then
                -- stopped by user
                break
            end
        else
            -- fallback: smooth lerp between current position and target
            local hr = hrp
            if hr then
                for step = 1, 8 do
                    if not playing then break end
                    local alpha = step/8
                    local pos = hr.Position:Lerp(target, alpha)
                    pcall(function() hr.CFrame = CFrame.new(pos) end)
                    wait(0.04)
                end
            end
        end

        if playStopRequested then break end
        wait(0.01)
    end

    -- restore walkspeed
    if RESTORE_WALKSPEED and humanoid then
        humanoid.WalkSpeed = tonumber(boxWS.Text) or PLAY_WALKSPEED_DEFAULT
    end

    playing = false
    playStopRequested = false
    infoLabel.Text = "Playback finished"
end

local function stopPlay()
    if not playing then return end
    playStopRequested = true
    playing = false
    infoLabel.Text = "Playback stopped"
end

-- edits
local function undoLast()
    if #path > 0 then table.remove(path,#path); infoLabel.Text = ("Points: %d"):format(#path) else infoLabel.Text = "No points to undo" end
end
local function deleteRange(fromIdx,toIdx)
    fromIdx = math.max(1, math.floor(fromIdx or 1))
    toIdx = math.min(#path, math.floor(toIdx or #path))
    if fromIdx > toIdx then infoLabel.Text = "Invalid range"; return end
    local new={}
    for i=1,#path do if i<fromIdx or i>toIdx then table.insert(new,path[i]) end end
    path=new
    infoLabel.Text = ("Deleted %d-%d | Points: %d"):format(fromIdx,toIdx,#path)
end
local function clearPath() path={}; infoLabel.Text="Path cleared" end

-- export/import
local function exportJSON()
    if #path==0 then infoLabel.Text="No path to export"; return end
    local ok,s = pcall(function() return HttpService:JSONEncode(path) end)
    if ok and s then prompt.Text=s; prompt.Visible=true; infoLabel.Text="Exported JSON - copy text" else infoLabel.Text="Export failed" end
end
local function importJSON()
    prompt.Visible=true; prompt.Text=""; infoLabel.Text="Paste JSON and press Enter"
    local conn
    conn = prompt.FocusLost:Connect(function(enter)
        if not enter then return end
        local txt = prompt.Text
        local ok, t = pcall(function() return HttpService:JSONDecode(txt) end)
        if ok and type(t) == "table" and #t>0 then
            local new={}
            for _, node in ipairs(t) do
                if node and node.p and #node.p==3 then table.insert(new,node) end
            end
            path=new
            infoLabel.Text = ("Imported points: %d"):format(#path)
        else
            infoLabel.Text = "Invalid JSON"
        end
        prompt.Visible=false; conn:Disconnect()
    end)
end

-- UI binds
btnRecord.MouseButton1Click:Connect(function()
    if not recording then
        local v = tonumber(boxInterval.Text)
        if v and v>0 then sampleInterval=v end
        refreshRefs()
        if not hrp then infoLabel.Text="No character to record"; return end
        -- attach jump listener
        if humanoid and not jumpConn then
            jumpConn = humanoid.Jumping:Connect(function(isActive) if isActive then pendingJump=true end end)
        end
        recording = true
        path = {}
        recordStart = tick()
        local acc = 0
        recordConn = RunService.Heartbeat:Connect(function(dt)
            if not recording then return end
            acc = acc + dt
            if #path==0 or acc>=sampleInterval then
                acc = 0
                recordSample()
            end
        end)
        infoLabel.Text = ("Recording... Points: %d | Interval: %.2fs"):format(#path,sampleInterval)
        btnRecord.Text = "Recording..."
        btnRecord.BackgroundColor3 = Color3.fromRGB(220,40,80)
    else
        -- stop if already recording
        recording = false
    end
end)

btnStop.MouseButton1Click:Connect(function()
    if recording then
        stopRecord()
        btnRecord.Text = "Start Record"
        btnRecord.BackgroundColor3 = Color3.fromRGB(170,0,170)
    end
    if playing then stopPlay() end
end)

btnPlay.MouseButton1Click:Connect(function()
    if not playing then
        refreshRefs()
        if not humanoid or not hrp then infoLabel.Text="No humanoid to play"; return end
        playing = true
        spawn(function() playPath() end)
    else
        stopPlay()
    end
end)

btnClear.MouseButton1Click:Connect(clearPath)
btnUndo.MouseButton1Click:Connect(undoLast)
delBtn.MouseButton1Click:Connect(function()
    local f = tonumber(delFromBox.Text) or 1
    local t = tonumber(delToBox.Text) or #path
    deleteRange(f,t)
end)
btnExport.MouseButton1Click:Connect(exportJSON)
btnImport.MouseButton1Click:Connect(importJSON)

hideBtn.MouseButton1Click:Connect(function() frame.Visible=false; icon.Visible=true end)
icon.MouseButton1Click:Connect(function() frame.Visible=true; icon.Visible=false end)
closeBtn.MouseButton1Click:Connect(function() recording=false; playing=false; screen:Destroy() end)

-- stop on manual input
if STOP_ON_MANUAL_INPUT then
    UserInputService.InputBegan:Connect(function(inp, gp)
        if gp then return end
        if playing and (inp.UserInputType==Enum.UserInputType.Keyboard or inp.UserInputType==Enum.UserInputType.Touch or inp.UserInputType==Enum.UserInputType.MouseButton1) then
            stopPlay()
            infoLabel.Text = "Playback stopped by input"
        end
    end)
end

-- respawn handling
player.CharacterAdded:Connect(function()
    recording=false; playing=false
    refreshRefs()
    infoLabel.Text="Character respawned - stopped"
    wait(0.4)
end)

-- initial refresh
refreshRefs()
print("MountBingung AutoWalk + Pathfinding loaded. Pathfinding is active for every segment.")
