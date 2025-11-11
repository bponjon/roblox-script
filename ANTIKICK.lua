-- ULTIMATE OBJECT DESTROYER + STRONG BYPASS
-- Delete objects with advanced anti-kick protection

task.wait(1)

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Stats = game:GetService("Stats")

local player = Players.LocalPlayer
local mouse = player:GetMouse()

pcall(function()
    if player.PlayerGui:FindFirstChild("ObjectDestroyer") then
        player.PlayerGui.ObjectDestroyer:Destroy()
        task.wait(0.3)
    end
end)

-- ============================================
-- ADVANCED ANTI-KICK BYPASS
-- ============================================

print("\n🛡️ INITIALIZING ADVANCED BYPASS...")

-- 1. Hook __namecall to block kick/ban remotes
if hookmetamethod and newcclosure then
    local oldNamecall
    oldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
        local method = getnamecallmethod()
        local args = {...}
        
        if method == "FireServer" or method == "InvokeServer" then
            local remoteName = tostring(self.Name):lower()
            
            -- Block anti-cheat remotes
            if remoteName:find("kick") or remoteName:find("ban") or 
               remoteName:find("anticheat") or remoteName:find("ac") or
               remoteName:find("detect") or remoteName:find("flag") or
               remoteName:find("log") or remoteName:find("report") or
               remoteName:find("admin") or remoteName:find("mod") then
                print("🛡️ Blocked AC remote: " .. self.Name)
                return
            end
            
            -- Block if trying to kick this player
            if args[1] == player or args[1] == player.UserId or args[1] == player.Name then
                if remoteName:find("remove") or remoteName:find("kick") then
                    print("🛡️ Blocked kick attempt")
                    return
                end
            end
        end
        
        return oldNamecall(self, ...)
    end))
    print("✅ Namecall hook active")
end

-- 2. Hook __index to spoof checks
if hookmetamethod and newcclosure then
    local oldIndex
    oldIndex = hookmetamethod(game, "__index", newcclosure(function(self, key)
        -- Spoof Humanoid properties
        if self:IsA("Humanoid") then
            if key == "WalkSpeed" and self.WalkSpeed > 16 then
                return 16
            elseif key == "JumpPower" and self.JumpPower > 50 then
                return 50
            end
        end
        
        return oldIndex(self, key)
    end))
    print("✅ Index hook active")
end

-- 3. Disable common anti-cheat scripts
pcall(function()
    for _, script in pairs(game:GetDescendants()) do
        if script:IsA("LocalScript") or script:IsA("ModuleScript") then
            local name = script.Name:lower()
            if name:find("anticheat") or name:find("anticheats") or 
               name:find("antiexploit") or name:find("ac") or
               name:find("detection") then
                script:Destroy()
                print("🛡️ Removed AC script: " .. script.Name)
            end
        end
    end
end)

-- 4. Block log remotes
task.spawn(function()
    while task.wait(5) do
        pcall(function()
            for _, obj in pairs(game:GetDescendants()) do
                if obj:IsA("RemoteEvent") then
                    local name = obj.Name:lower()
                    if name:find("log") or name:find("report") or name:find("analytics") then
                        obj:Destroy()
                    end
                end
            end
        end)
    end
end)

-- 5. Spoof ping/network stats
pcall(function()
    local mt = getrawmetatable(game)
    setreadonly(mt, false)
    
    local oldNewIndex = mt.__newindex
    mt.__newindex = newcclosure(function(t, k, v)
        if t == Stats.PerformanceStats then
            return
        end
        return oldNewIndex(t, k, v)
    end)
    
    setreadonly(mt, true)
    print("✅ Network stats spoofed")
end)

-- 6. Anti-AFK
pcall(function()
    local vu = game:GetService("VirtualUser")
    player.Idled:Connect(function()
        vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        task.wait(1)
        vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    end)
    print("✅ Anti-AFK enabled")
end)

-- 7. Hook Player.Kick
pcall(function()
    local oldKick = player.Kick
    player.Kick = function(...)
        print("🛡️ Blocked Player:Kick() attempt")
        return
    end
    print("✅ Player.Kick blocked")
end)

-- 8. Randomize request timing (avoid pattern detection)
local function randomDelay()
    task.wait(math.random(10, 50) / 1000) -- 10-50ms random delay
end

-- 9. Limit requests per second (avoid rate limit detection)
local requestCount = 0
local lastReset = tick()

local function checkRateLimit()
    if tick() - lastReset > 1 then
        requestCount = 0
        lastReset = tick()
    end
    
    if requestCount > 30 then
        task.wait(1)
        requestCount = 0
    end
    
    requestCount = requestCount + 1
end

print("✅ BYPASS FULLY LOADED\n")

-- ============================================
-- VARIABLES
-- ============================================

local allRemotes = {}
local workingRemotes = {}
local hoveredObject = nil
local safeMode = true -- Slower but safer

-- ============================================
-- NOTIFICATION
-- ============================================

local function notify(text)
    pcall(function()
        game.StarterGui:SetCore("SendNotification", {
            Title = "💥 Destroyer [BYPASS]";
            Text = text;
            Duration = 3;
        })
    end)
    print("[Destroyer]", text)
end

-- ============================================
-- SCAN REMOTES (STEALTH)
-- ============================================

local function scanRemotes()
    allRemotes = {}
    
    print("\n🔍 Stealth scanning remotes...")
    
    for _, service in pairs(game:GetChildren()) do
        pcall(function()
            for _, obj in pairs(service:GetDescendants()) do
                if obj:IsA("RemoteEvent") then
                    local name = obj.Name:lower()
                    -- Skip obvious AC remotes
                    if not (name:find("anticheat") or name:find("kick") or name:find("ban")) then
                        table.insert(allRemotes, obj)
                    end
                end
            end
        end)
    end
    
    notify("Found " .. #allRemotes .. " safe remotes")
    print("✅ Found " .. #allRemotes .. " remotes\n")
    
    return #allRemotes
end

-- ============================================
-- DELETE METHODS (WITH BYPASS)
-- ============================================

-- Client-Side Delete
local function clientDelete(obj)
    local success = pcall(function()
        obj:Destroy()
    end)
    return success
end

-- Safe Remote Delete (with rate limiting & randomization)
local function safeRemoteDelete(obj)
    if #allRemotes == 0 then scanRemotes() end
    
    print("💥 Safe remote delete: " .. obj.Name)
    
    local attempts = 0
    local maxAttempts = safeMode and 10 or #allRemotes
    
    for i = 1, math.min(maxAttempts, #allRemotes) do
        checkRateLimit() -- Check rate limit
        randomDelay() -- Random delay
        
        local remote = allRemotes[i]
        
        pcall(function()
            -- Delete patterns
            remote:FireServer("Delete", obj)
            remote:FireServer("Remove", obj)
            remote:FireServer({Action = "Delete", Target = obj})
            
            attempts = attempts + 1
        end)
    end
    
    print("✅ Sent " .. attempts .. " safe delete commands")
    return attempts > 0
end

-- Stealth Delete (use working remotes only)
local function stealthDelete(obj)
    if #workingRemotes == 0 then
        notify("⚠️ No working remotes found! Use 'Test Remotes' first")
        return safeRemoteDelete(obj)
    end
    
    print("🕵️ Stealth delete: " .. obj.Name)
    
    for _, remote in pairs(workingRemotes) do
        checkRateLimit()
        randomDelay()
        
        pcall(function()
            remote:FireServer("Delete", obj)
            remote:FireServer({Action = "Delete", Target = obj})
        end)
    end
    
    print("✅ Stealth delete complete")
    return true
end

-- Aggressive Delete (bypass mode)
local function aggressiveDelete(obj)
    print("\n💥 AGGRESSIVE DELETE: " .. obj.Name)
    
    -- 1. Client delete
    pcall(function()
        obj:Destroy()
        print("✅ Client delete")
    end)
    
    -- 2. Working remotes first (if available)
    if #workingRemotes > 0 then
        for _, remote in pairs(workingRemotes) do
            checkRateLimit()
            pcall(function()
                remote:FireServer("Delete", obj)
            end)
        end
        print("✅ Used " .. #workingRemotes .. " working remotes")
    end
    
    -- 3. Try safe amount of other remotes
    local maxTries = safeMode and 15 or 50
    for i = 1, math.min(maxTries, #allRemotes) do
        checkRateLimit()
        randomDelay()
        
        pcall(function()
            allRemotes[i]:FireServer("Delete", obj)
            allRemotes[i]:FireServer({Action = "Delete", Target = obj})
        end)
    end
    
    print("✅ Aggressive delete complete")
    return true
end

-- Mass Delete (with safety limits)
local function massDelete(objectName)
    if objectName == "" then
        notify("❌ Enter object name!")
        return 0
    end
    
    local count = 0
    local found = {}
    
    print("\n🔍 Searching: " .. objectName)
    
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Name:lower():find(objectName:lower()) then
            table.insert(found, obj)
        end
    end
    
    print("Found " .. #found .. " objects")
    
    -- Delete with delays
    for _, obj in pairs(found) do
        pcall(function()
            if safeMode then
                stealthDelete(obj)
                task.wait(0.2) -- Delay between deletes
            else
                aggressiveDelete(obj)
                task.wait(0.1)
            end
            count = count + 1
        end)
        
        if count >= 50 then break end -- Safety limit
    end
    
    notify("💥 Deleted " .. count .. " objects")
    print("✅ Mass delete: " .. count .. " objects\n")
    
    return count
end

-- Loop Delete (with bypass)
local loopDeleteActive = false
local loopDeleteConnection = nil

local function toggleLoopDelete(objectName)
    if objectName == "" then
        notify("❌ Enter object name!")
        return
    end
    
    loopDeleteActive = not loopDeleteActive
    
    if loopDeleteActive then
        notify("🔁 Loop delete ON: " .. objectName)
        print("\n🔁 LOOP DELETE STARTED")
        
        loopDeleteConnection = RunService.Heartbeat:Connect(function()
            pcall(function()
                for _, obj in pairs(Workspace:GetDescendants()) do
                    if obj:IsA("BasePart") and obj.Name:lower():find(objectName:lower()) then
                        checkRateLimit()
                        
                        -- Client delete
                        obj:Destroy()
                        
                        -- Use working remotes
                        if #workingRemotes > 0 then
                            workingRemotes[1]:FireServer("Delete", obj)
                        end
                    end
                end
            end)
            
            task.wait(0.5) -- Slower loop for safety
        end)
    else
        notify("⏸️ Loop delete OFF")
        print("⏸️ Loop stopped\n")
        
        if loopDeleteConnection then
            loopDeleteConnection:Disconnect()
        end
    end
end

-- Test Working Remotes (safe testing)
local function findWorkingDeleteRemotes()
    if #allRemotes == 0 then scanRemotes() end
    
    workingRemotes = {}
    
    print("\n🧪 Testing remotes (safe mode)...")
    
    local testObj = nil
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Size.Magnitude < 20 and obj.Name ~= "Baseplate" then
            testObj = obj
            break
        end
    end
    
    if not testObj then
        notify("❌ No test object!")
        return
    end
    
    print("Test object: " .. testObj.Name)
    
    local originalParent = testObj.Parent
    
    -- Test only first 20 remotes for safety
    for i = 1, math.min(20, #allRemotes) do
        checkRateLimit()
        randomDelay()
        
        local remote = allRemotes[i]
        
        pcall(function()
            remote:FireServer("Delete", testObj)
            task.wait(0.15)
            
            if not testObj.Parent or testObj.Parent ~= originalParent then
                table.insert(workingRemotes, remote)
                print("✅ WORKING: " .. remote.Name)
                
                pcall(function()
                    testObj.Parent = originalParent
                end)
            end
        end)
    end
    
    notify("Found " .. #workingRemotes .. " working remotes!")
    print("✅ Found " .. #workingRemotes .. " working remotes\n")
    
    return #workingRemotes
end

-- ============================================
-- GUI CREATION
-- ============================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ObjectDestroyer"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = player.PlayerGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 520, 0, 680)
MainFrame.Position = UDim2.new(0.5, -260, 0.5, -340)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

-- Header
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 55)
Header.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
Header.BorderSizePixel = 0
Header.Parent = MainFrame

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 12)
HeaderCorner.Parent = Header

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -110, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "💥 DESTROYER [BYPASS]"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local HideBtn = Instance.new("TextButton")
HideBtn.Size = UDim2.new(0, 50, 0, 48)
HideBtn.Position = UDim2.new(1, -105, 0, 3.5)
HideBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
HideBtn.Text = "−"
HideBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
HideBtn.Font = Enum.Font.GothamBold
HideBtn.TextSize = 28
HideBtn.Parent = Header

local HideBtnCorner = Instance.new("UICorner")
HideBtnCorner.CornerRadius = UDim.new(0, 10)
HideBtnCorner.Parent = HideBtn

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 50, 0, 48)
CloseBtn.Position = UDim2.new(1, -52, 0, 3.5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 20
CloseBtn.Parent = Header

local CloseBtnCorner = Instance.new("UICorner")
CloseBtnCorner.CornerRadius = UDim.new(0, 10)
CloseBtnCorner.Parent = CloseBtn

local isHidden = false
HideBtn.MouseButton1Click:Connect(function()
    isHidden = not isHidden
    TweenService:Create(MainFrame, TweenInfo.new(0.3), {
        Size = isHidden and UDim2.new(0, 520, 0, 55) or UDim2.new(0, 520, 0, 680)
    }):Play()
    HideBtn.Text = isHidden and "+" or "−"
end)

CloseBtn.MouseButton1Click:Connect(function()
    loopDeleteActive = false
    if loopDeleteConnection then loopDeleteConnection:Disconnect() end
    ScreenGui:Destroy()
end)

-- Content
local Content = Instance.new("ScrollingFrame")
Content.Size = UDim2.new(1, -20, 1, -65)
Content.Position = UDim2.new(0, 10, 0, 60)
Content.BackgroundTransparency = 1
Content.ScrollBarThickness = 6
Content.ScrollBarImageColor3 = Color3.fromRGB(200, 0, 0)
Content.BorderSizePixel = 0
Content.CanvasSize = UDim2.new(0, 0, 0, 0)
Content.Parent = MainFrame

local Layout = Instance.new("UIListLayout")
Layout.Padding = UDim.new(0, 8)
Layout.Parent = Content

Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    Content.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y + 10)
end)

-- UI Builders
local function section(text, color)
    local s = Instance.new("TextLabel")
    s.Size = UDim2.new(1, -10, 0, 38)
    s.BackgroundColor3 = color
    s.Text = text
    s.TextColor3 = Color3.fromRGB(255, 255, 255)
    s.Font = Enum.Font.GothamBold
    s.TextSize = 15
    s.Parent = Content
    
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 8)
    c.Parent = s
end

local function button(text, color, callback)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -10, 0, 45)
    b.BackgroundColor3 = color
    b.Text = text
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 13
    b.TextWrapped = true
    b.Parent = Content
    
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 8)
    c.Parent = b
    
    b.MouseButton1Click:Connect(function()
        pcall(callback)
    end)
    
    return b
end

local function textbox(placeholder)
    local t = Instance.new("TextBox")
    t.Size = UDim2.new(1, -10, 0, 40)
    t.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    t.Text = ""
    t.PlaceholderText = placeholder
    t.TextColor3 = Color3.fromRGB(255, 255, 255)
    t.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
    t.Font = Enum.Font.Gotham
    t.TextSize = 13
    t.ClearTextOnFocus = false
    t.Parent = Content
    
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 8)
    c.Parent = t
    
    return t
end

local function infoLabel(text, color)
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1, -10, 0, 32)
    l.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    l.Text = text
    l.TextColor3 = color
    l.Font = Enum.Font.Gotham
    l.TextSize = 12
    l.Parent = Content
    
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 6)
    c.Parent = l
    
    return l
end

-- ============================================
-- BUILD INTERFACE
-- ============================================

section("🛡️ BYPASS STATUS", Color3.fromRGB(0, 150, 0))

local bypassLabel = infoLabel("✅ Anti-Kick: ACTIVE | Rate Limit: SAFE", Color3.fromRGB(0, 255, 100))

section("⚙️ SAFETY MODE", Color3.fromRGB(100, 100, 0))

local safeModeBtn = button("🛡️ Safe Mode: ON (Recommended)", Color3.fromRGB(0, 150, 0), function()
    safeMode = not safeMode
    safeModeBtn.Text = safeMode and "🛡️ Safe Mode: ON (Recommended)" or "⚡ Fast Mode: ON (Risky)"
    safeModeBtn.BackgroundColor3 = safeMode and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(200, 100, 0)
    notify(safeMode and "🛡️ Safe Mode ON" or "⚡ Fast Mode ON")
end)

section("🔍 STEP 1: SETUP", Color3.fromRGB(0, 100, 200))

button("📡 Scan Safe Remotes", Color3.fromRGB(0, 120, 220), scanRemotes)

button("🧪 Test Working Remotes", Color3.fromRGB(200, 100, 0), findWorkingDeleteRemotes)

section("💥 DELETE HOVERED", Color3.fromRGB(200, 0, 0))

local hoverLabel = infoLabel("Hover: None", Color3.fromRGB(255, 200, 0))

button("💣 Client Delete (Safe)", Color3.fromRGB(100, 0, 100), function()
    if not hoveredObject then
        notify("❌ Hover object first!")
        return
    end
    clientDelete(hoveredObject)
    notify("✅ Client: " .. hoveredObject.Name)
end)

button("🕵️ Stealth Delete (Working Remotes)", Color3.fromRGB(150, 50, 0), function()
    if not hoveredObject then
        notify("❌ Hover object first!")
        return
    end
    stealthDelete(hoveredObject)
end)

button("💥 Aggressive Delete (All Methods)", Color3.fromRGB(255, 0, 0), function()
    if not hoveredObject then
        notify("❌ Hover object first!")
        return
    end
    aggressiveDelete(hoveredObject)
end)

section("🗑️ MASS DELETE", Color3.fromRGB(150, 0, 150))

local objectNameBox = textbox("Object name (checkpoint, stage, kill, etc)")

button("💥 Mass Delete by Name", Color3.fromRGB(180, 0, 100), function()
    massDelete(objectNameBox.Text)
end)

local loopBtn = button("🔁 Loop Delete (Toggle)", Color3.fromRGB(100, 0, 150), function()
    toggleLoopDelete(objectNameBox.Text)
    loopBtn.Text = loopDeleteActive and "⏸️ Stop Loop" or "🔁 Loop Delete (Toggle)"
end)

section("⚡ QUICK DELETE", Color3.fromRGB(60, 60, 60))

button("💣 All 'Checkpoint'", Color3.fromRGB(80, 80, 80), function()
    massDelete("checkpoint")
end)

button("💣 All 'Stage'", Color3.fromRGB(70, 70, 70), function()
    massDelete("stage")
end)

button("💣 All 'Kill'", Color3.fromRGB(60, 60, 60), function()
    massDelete("kill")
end)

-- ============================================
-- HOVER DETECTION
-- ============================================

RunService.RenderStepped:Connect(function()
    hoveredObject = mouse.Target
    if hoveredObject and hoveredObject:IsA("BasePart") then
        hoverLabel.Text = "Hover: " .. hoveredObject.Name
        hoverLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
    else
        hoverLabel.Text = "Hover: None"
        hoverLabel.TextColor3 = Color3.fromRGB(255, 150, 0)
    end
end)

-- ============================================
-- AUTO START
-- ============================================

task.spawn(function()
    task.wait(1.5)
    scanRemotes()
    notify("🛡️ BYPASS ACTIVE - " .. #allRemotes .. " remotes")
end)
