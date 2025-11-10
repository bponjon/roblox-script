-- BACKDOOR PENETRATION TESTER
-- Test ALL remotes and show which ones are VULNERABLE

task.wait(1)

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local mouse = player:GetMouse()

pcall(function()
    if player.PlayerGui:FindFirstChild("PenetrationTester") then
        player.PlayerGui.PenetrationTester:Destroy()
        task.wait(0.3)
    end
end)

-- ============================================
-- VARIABLES
-- ============================================

local allRemotes = {}
local vulnerableRemotes = {}
local secureRemotes = {}
local testProgress = 0
local isTesting = false
local hoveredPart = nil

-- ============================================
-- NOTIFICATION
-- ============================================

local function notify(text)
    pcall(function()
        game.StarterGui:SetCore("SendNotification", {
            Title = "🔓 Penetration Test";
            Text = text;
            Duration = 4;
        })
    end)
    print("[PenTest]", text)
end

-- ============================================
-- SCAN REMOTES
-- ============================================

local function scanAllRemotes()
    allRemotes = {}
    
    print("\n" .. string.rep("=", 60))
    print("🔍 SCANNING ALL REMOTES...")
    print(string.rep("=", 60))
    
    for _, service in pairs(game:GetChildren()) do
        pcall(function()
            for _, obj in pairs(service:GetDescendants()) do
                if obj:IsA("RemoteEvent") then
                    table.insert(allRemotes, obj)
                end
            end
        end)
    end
    
    notify("Found " .. #allRemotes .. " RemoteEvents")
    
    print("\n📊 TOTAL REMOTES FOUND: " .. #allRemotes)
    print("\nLIST OF ALL REMOTES:")
    for i, remote in pairs(allRemotes) do
        print(i .. ". " .. remote.Name .. " (" .. remote:GetFullName() .. ")")
    end
    print(string.rep("=", 60) .. "\n")
    
    return #allRemotes
end

-- ============================================
-- PENETRATION TESTING
-- ============================================

local function findTestPart()
    local testParts = {}
    
    -- Find multiple suitable test parts
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Size.Magnitude < 30 and 
           obj.Name ~= "Baseplate" and obj.CanCollide and 
           not obj:IsDescendantOf(player.Character or workspace) then
            table.insert(testParts, obj)
            if #testParts >= 5 then break end
        end
    end
    
    return testParts[1]
end

local function testSingleRemote(remote, testPart)
    if not testPart then
        return {
            remote = remote,
            vulnerable = false,
            workingMethods = {},
            reason = "No test part available"
        }
    end
    
    local originalPos = testPart.Position
    local testPos = originalPos + Vector3.new(0, 7, 0)
    
    local result = {
        remote = remote,
        vulnerable = false,
        workingMethods = {},
        reason = "Secure (no vulnerabilities found)"
    }
    
    -- 25+ different exploit patterns
    local patterns = {
        -- Basic patterns
        {name = "Direct (part, pos)", func = function() remote:FireServer(testPart, testPos) end},
        {name = "Direct (part, x, y, z)", func = function() remote:FireServer(testPart, testPos.X, testPos.Y, testPos.Z) end},
        {name = "Direct (part, cframe)", func = function() remote:FireServer(testPart, CFrame.new(testPos)) end},
        
        -- Command string patterns
        {name = "Command: Teleport", func = function() remote:FireServer("Teleport", testPart, testPos) end},
        {name = "Command: TP", func = function() remote:FireServer("TP", testPart, testPos) end},
        {name = "Command: Move", func = function() remote:FireServer("Move", testPart, testPos) end},
        {name = "Command: MoveTo", func = function() remote:FireServer("MoveTo", testPart, testPos) end},
        {name = "Command: SetPosition", func = function() remote:FireServer("SetPosition", testPart, testPos) end},
        {name = "Command: Position", func = function() remote:FireServer("Position", testPart, testPos) end},
        {name = "Command: Set", func = function() remote:FireServer("Set", testPart, testPos) end},
        {name = "Command: Change", func = function() remote:FireServer("Change", testPart, testPos) end},
        
        -- Table patterns
        {name = "Table: {part, pos}", func = function() remote:FireServer({testPart, testPos}) end},
        {name = "Table: {Part=, Position=}", func = function() remote:FireServer({Part = testPart, Position = testPos}) end},
        {name = "Table: {Object=, Pos=}", func = function() remote:FireServer({Object = testPart, Pos = testPos}) end},
        {name = "Table: {Target=, NewPos=}", func = function() remote:FireServer({Target = testPart, NewPosition = testPos}) end},
        {name = "Table: {Action=TP, Part=}", func = function() remote:FireServer({Action = "Teleport", Part = testPart, Position = testPos}) end},
        {name = "Table: {Action=TP, Target=}", func = function() remote:FireServer({Action = "TP", Target = testPart, Pos = testPos}) end},
        {name = "Table: {Command=Move}", func = function() remote:FireServer({Command = "Move", Object = testPart, Position = testPos}) end},
        {name = "Table: {Type=TP, Item=}", func = function() remote:FireServer({Type = "Teleport", Item = testPart, Location = testPos}) end},
        
        -- CFrame patterns
        {name = "CFrame: (cmd, part, cf)", func = function() remote:FireServer("CFrame", testPart, CFrame.new(testPos)) end},
        {name = "CFrame: SetCFrame", func = function() remote:FireServer("SetCFrame", testPart, CFrame.new(testPos)) end},
        
        -- Property change patterns
        {name = "Property: Position", func = function() remote:FireServer("ChangeProperty", testPart, "Position", testPos) end},
        {name = "Property: SetProperty", func = function() remote:FireServer("SetProperty", testPart, "Position", testPos) end},
        {name = "Property: CFrame", func = function() remote:FireServer("ChangeProperty", testPart, "CFrame", CFrame.new(testPos)) end},
        
        -- Admin command patterns
        {name = "Admin: execute", func = function() remote:FireServer("execute", testPart, testPos) end},
        {name = "Admin: run", func = function() remote:FireServer("run", "tp", testPart, testPos) end},
    }
    
    -- Test each pattern
    for _, pattern in pairs(patterns) do
        local success = pcall(function()
            pattern.func()
            task.wait(0.1)
            
            -- Check if position changed
            local distance = (testPart.Position - originalPos).Magnitude
            
            if distance > 3 then
                table.insert(result.workingMethods, pattern.name)
                result.vulnerable = true
                
                -- Try to reset position
                pcall(function()
                    testPart.Position = originalPos
                    task.wait(0.05)
                end)
            end
        end)
    end
    
    if result.vulnerable then
        result.reason = "VULNERABLE! Found " .. #result.workingMethods .. " working exploit(s)"
    end
    
    return result
end

local function startPenetrationTest(statusLabel, progressLabel, resultsLabel)
    if isTesting then
        notify("⚠️ Test already running!")
        return
    end
    
    if #allRemotes == 0 then
        notify("❌ Scan remotes first!")
        return
    end
    
    isTesting = true
    vulnerableRemotes = {}
    secureRemotes = {}
    testProgress = 0
    
    notify("🔥 Starting penetration test on " .. #allRemotes .. " remotes...")
    
    print("\n" .. string.rep("=", 60))
    print("🔓 PENETRATION TEST STARTED")
    print(string.rep("=", 60))
    
    statusLabel.Text = "🔥 TESTING IN PROGRESS..."
    statusLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
    
    local testPart = findTestPart()
    
    if not testPart then
        notify("❌ No suitable test part found!")
        statusLabel.Text = "❌ ERROR: No test part found"
        statusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
        isTesting = false
        return
    end
    
    print("Using test part: " .. testPart.Name .. " at " .. tostring(testPart.Position))
    print()
    
    -- Test each remote
    for i, remote in pairs(allRemotes) do
        if not isTesting then break end
        
        testProgress = i
        progressLabel.Text = "Progress: " .. i .. "/" .. #allRemotes .. " (" .. math.floor((i/#allRemotes)*100) .. "%)"
        
        print("[" .. i .. "/" .. #allRemotes .. "] Testing: " .. remote.Name)
        
        local result = testSingleRemote(remote, testPart)
        
        if result.vulnerable then
            table.insert(vulnerableRemotes, result)
            print("🔥 VULNERABLE! Methods: " .. #result.workingMethods)
            for _, method in pairs(result.workingMethods) do
                print("   ✅ " .. method)
            end
        else
            table.insert(secureRemotes, result)
            print("✅ Secure")
        end
        
        print()
        task.wait(0.15)
    end
    
    -- Results
    print(string.rep("=", 60))
    print("📊 PENETRATION TEST RESULTS")
    print(string.rep("=", 60))
    print("Total Tested: " .. #allRemotes)
    print("🔥 Vulnerable: " .. #vulnerableRemotes)
    print("✅ Secure: " .. #secureRemotes)
    print()
    
    if #vulnerableRemotes > 0 then
        print("🔥 VULNERABLE REMOTES:")
        for i, result in pairs(vulnerableRemotes) do
            print("\n" .. i .. ". " .. result.remote.Name)
            print("   Location: " .. result.remote:GetFullName())
            print("   Working Methods (" .. #result.workingMethods .. "):")
            for j, method in pairs(result.workingMethods) do
                print("   " .. j .. ". " .. method)
            end
        end
        
        statusLabel.Text = "✅ TEST COMPLETE!\n🔥 Found " .. #vulnerableRemotes .. " VULNERABLE remotes!"
        statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
        
        resultsLabel.Text = "🔥 VULNERABLE: " .. #vulnerableRemotes .. "\n✅ SECURE: " .. #secureRemotes .. "\n\n" ..
            "Check F9 console for full details!"
        resultsLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
        
        notify("🔥 FOUND " .. #vulnerableRemotes .. " BACKDOORS!")
    else
        print("✅ No vulnerabilities found. Game appears secure!")
        
        statusLabel.Text = "✅ TEST COMPLETE!\nNo vulnerabilities found"
        statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
        
        resultsLabel.Text = "✅ All " .. #allRemotes .. " remotes are SECURE!\n\n" ..
            "No backdoors found in this game."
        resultsLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
        
        notify("✅ Game is secure - no backdoors found")
    end
    
    print(string.rep("=", 60) .. "\n")
    
    isTesting = false
end

-- ============================================
-- EXPLOIT FUNCTIONS
-- ============================================

local function exploitWithVulnerable(target, height)
    if #vulnerableRemotes == 0 then
        notify("❌ No vulnerable remotes found! Run test first")
        return false
    end
    
    local targetPos = Vector3.new(target.Position.X, height, target.Position.Z)
    local exploited = false
    
    print("\n💥 EXPLOITING TARGET: " .. target.Name)
    
    for _, result in pairs(vulnerableRemotes) do
        local remote = result.remote
        
        print("Using backdoor: " .. remote.Name)
        
        -- Use all working methods
        for _, method in pairs(result.workingMethods) do
            pcall(function()
                if method:find("Direct") then
                    if method:find("cframe") then
                        remote:FireServer(target, CFrame.new(targetPos))
                    elseif method:find("x, y, z") then
                        remote:FireServer(target, targetPos.X, targetPos.Y, targetPos.Z)
                    else
                        remote:FireServer(target, targetPos)
                    end
                elseif method:find("Command:") then
                    local cmd = method:match("Command: (%w+)")
                    remote:FireServer(cmd, target, targetPos)
                elseif method:find("Table:") then
                    remote:FireServer({
                        Action = "Teleport",
                        Part = target,
                        Object = target,
                        Target = target,
                        Position = targetPos,
                        Pos = targetPos,
                        NewPosition = targetPos
                    })
                elseif method:find("CFrame:") then
                    remote:FireServer("CFrame", target, CFrame.new(targetPos))
                elseif method:find("Property:") then
                    remote:FireServer("ChangeProperty", target, "Position", targetPos)
                end
                
                exploited = true
            end)
        end
    end
    
    if exploited then
        notify("✅ Exploited with " .. #vulnerableRemotes .. " backdoors!")
    end
    
    return exploited
end

-- ============================================
-- GUI CREATION
-- ============================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PenetrationTester"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = player.PlayerGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 580, 0, 650)
MainFrame.Position = UDim2.new(0.5, -290, 0.5, -325)
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
Header.BackgroundColor3 = Color3.fromRGB(255, 0, 100)
Header.BorderSizePixel = 0
Header.Parent = MainFrame

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 12)
HeaderCorner.Parent = Header

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -110, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "🔓 PENETRATION TESTER"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 19
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
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
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
        Size = isHidden and UDim2.new(0, 580, 0, 55) or UDim2.new(0, 580, 0, 650)
    }):Play()
    HideBtn.Text = isHidden and "+" or "−"
end)

CloseBtn.MouseButton1Click:Connect(function()
    isTesting = false
    ScreenGui:Destroy()
end)

-- Content
local Content = Instance.new("ScrollingFrame")
Content.Size = UDim2.new(1, -20, 1, -65)
Content.Position = UDim2.new(0, 10, 0, 60)
Content.BackgroundTransparency = 1
Content.ScrollBarThickness = 6
Content.ScrollBarImageColor3 = Color3.fromRGB(255, 0, 100)
Content.BorderSizePixel = 0
Content.CanvasSize = UDim2.new(0, 0, 0, 0)
Content.Parent = MainFrame

local Layout = Instance.new("UIListLayout")
Layout.Padding = UDim.new(0, 10)
Layout.Parent = Content

Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    Content.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y + 10)
end)

-- UI Builders
local function section(text, color)
    local s = Instance.new("TextLabel")
    s.Size = UDim2.new(1, -10, 0, 40)
    s.BackgroundColor3 = color
    s.Text = text
    s.TextColor3 = Color3.fromRGB(255, 255, 255)
    s.Font = Enum.Font.GothamBold
    s.TextSize = 16
    s.Parent = Content
    
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 8)
    c.Parent = s
end

local function button(text, color, callback)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -10, 0, 48)
    b.BackgroundColor3 = color
    b.Text = text
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 14
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
    t.Size = UDim2.new(1, -10, 0, 42)
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

local function infoBox(text, color)
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1, -10, 0, 70)
    l.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    l.Text = text
    l.TextColor3 = color or Color3.fromRGB(200, 200, 200)
    l.Font = Enum.Font.Gotham
    l.TextSize = 13
    l.TextWrapped = true
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.TextYAlignment = Enum.TextYAlignment.Top
    l.Parent = Content
    
    local padding = Instance.new("UIPadding")
    padding.PaddingLeft = UDim.new(0, 10)
    padding.PaddingRight = UDim.new(0, 10)
    padding.PaddingTop = UDim.new(0, 10)
    padding.PaddingBottom = UDim.new(0, 10)
    padding.Parent = l
    
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 8)
    c.Parent = l
    
    return l
end

-- ============================================
-- BUILD INTERFACE
-- ============================================

section("🎯 STEP 1: SCAN", Color3.fromRGB(0, 120, 200))

button("📡 Scan All RemoteEvents", Color3.fromRGB(0, 140, 220), scanAllRemotes)

section("🔥 STEP 2: PENETRATION TEST", Color3.fromRGB(255, 100, 0))

local statusLabel = infoBox("Status: Ready\nClick 'Start Full Test' to begin", Color3.fromRGB(200, 200, 200))

local progressLabel = infoBox("Progress: 0/0 (0%)", Color3.fromRGB(200, 200, 200))

button("🔓 Start Full Penetration Test", Color3.fromRGB(200, 0, 100), function()
    startPenetrationTest(statusLabel, progressLabel, resultsLabel)
end)

button("⏸️ Stop Test", Color3.fromRGB(100, 0, 50), function()
    isTesting = false
    notify("⏸️ Test stopped")
end)

section("📊 RESULTS", Color3.fromRGB(100, 0, 200))

resultsLabel = infoBox("Results will appear here after test", Color3.fromRGB(150, 150, 150))

section("💥 EXPLOIT VULNERABLE", Color3.fromRGB(255, 0, 0))

local hoverLabel = infoBox("Hover: None", Color3.fromRGB(255, 200, 0))

local heightBox = textbox("Height (Y position, default: -1000)")

button("🔥 Exploit Hovered Part", Color3.fromRGB(220, 0, 0), function()
    if not hoveredPart then
        notify("❌ Hover mouse over a part!")
        return
    end
    local h = tonumber(heightBox.Text) or -1000
    exploitWithVulnerable(hoveredPart, h)
end)

local partNameBox = textbox("Part name (checkpoint, stage, etc)")

button("💥 Exploit Parts by Name", Color3.fromRGB(180, 0, 0), function()
    if partNameBox.Text == "" then
        notify("❌ Enter part name!")
        return
    end
    
    local h = tonumber(heightBox.Text) or -1000
    local count = 0
    
    for _, obj in pairs(Workspace:GetDescendants()) do
        pcall(function()
            if obj:IsA("BasePart") and obj.Name:lower():find(partNameBox.Text:lower()) then
                exploitWithVulnerable(obj, h)
                count = count + 1
            end
        end)
        if count >= 30 then break end
    end
    
    notify("Exploited " .. count .. " parts!")
end)

-- ============================================
-- HOVER DETECTION
-- ============================================

RunService.RenderStepped:Connect(function()
    hoveredPart = mouse.Target
    if hoveredPart and hoveredPart:IsA("BasePart") then
        hoverLabel.Text = "Hover: " .. hoveredPart.Name .. " (Y:" .. math.floor(hoveredPart.Position.Y) .. ")"
        hoverLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
    else
        hoverLabel.Text = "Hover: None (point mouse at part)"
        hoverLabel.TextColor3 = Color3.fromRGB(255, 150, 0)
    end
end)

-- ============================================
-- AUTO START
-- ============================================

task.spawn(function()
    task.wait(1)
    notify("✅ Ready! Start with 'Scan All RemoteEvents'")
end)
