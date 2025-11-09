-- ULTIMATE HUB V2 - LAYOUT FIXED + STRONG AC BYPASS
-- No overlap, proper spacing, advanced anti-cheat bypass

task.wait(2)

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui", 10)
local mouse = player:GetMouse()

pcall(function()
    if playerGui:FindFirstChild("UltimateHub") then
        playerGui.UltimateHub:Destroy()
        task.wait(0.5)
    end
end)

-- ============================================
-- ANTI-CHEAT BYPASS (ADVANCED)
-- ============================================

-- Spoof namecall
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    
    -- Block common AC checks
    if method == "FireServer" or method == "InvokeServer" then
        local remoteName = self.Name:lower()
        if remoteName:find("anticheat") or remoteName:find("ac") or 
           remoteName:find("kick") or remoteName:find("ban") or
           remoteName:find("detect") or remoteName:find("flag") then
            return wait(9e9)
        end
    end
    
    -- Block Humanoid modifications check
    if method == "GetPropertyChangedSignal" and self:IsA("Humanoid") then
        return Instance.new("BindableEvent").Event
    end
    
    return oldNamecall(self, ...)
end)

-- Spoof index
local oldIndex
oldIndex = hookmetamethod(game, "__index", function(self, key)
    -- Spoof WalkSpeed/JumpPower checks
    if self:IsA("Humanoid") then
        if key == "WalkSpeed" and self.WalkSpeed > 16 then
            return 16
        elseif key == "JumpPower" and self.JumpPower > 50 then
            return 50
        end
    end
    return oldIndex(self, key)
end)

-- Hook setfpscap to prevent FPS-based detection
if setfpscap then
    setfpscap(999)
end

-- Disable workspace changes tracking
local mt = getrawmetatable(game)
setreadonly(mt, false)
local oldNewIndex = mt.__newindex
mt.__newindex = newcclosure(function(t, k, v)
    if t:IsA("Workspace") and k == "FallenPartsDestroyHeight" then
        return
    end
    return oldNewIndex(t, k, v)
end)

-- Spoof client logs
local function spoofLogs()
    for _, obj in pairs(game:GetDescendants()) do
        if obj:IsA("RemoteEvent") and obj.Name:find("Log") then
            pcall(function() obj:Destroy() end)
        end
    end
end
task.spawn(function()
    while task.wait(5) do
        spoofLogs()
    end
end)

-- Remove common AC scripts
pcall(function()
    for _, script in pairs(game:GetDescendants()) do
        if script:IsA("LocalScript") then
            local name = script.Name:lower()
            if name:find("anticheat") or name:find("antiexploit") or 
               name:find("anticheats") or name:find("ac") then
                script:Destroy()
            end
        end
    end
end)

-- ============================================
-- VARIABLES
-- ============================================
local remotes = {}
local flying = false
local noclipping = false
local loopDeleteRunning = false
local espEnabled = false

local flyBV, flyBG
local noclipConnection
local loopDeleteConnection
local espConnection

-- ============================================
-- FUNCTIONS
-- ============================================

local function notif(msg)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Ultimate Hub";
            Text = msg;
            Duration = 2.5;
        })
    end)
    print("[Hub]", msg)
end

local function scanRemotes()
    remotes = {}
    for _, service in pairs(game:GetChildren()) do
        pcall(function()
            for _, obj in pairs(service:GetDescendants()) do
                if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
                    table.insert(remotes, obj)
                end
            end
        end)
    end
    notif("Ditemukan " .. #remotes .. " remotes!")
    return #remotes
end

local function deleteHover()
    if not mouse.Target then notif("❌ Tidak ada target!") return end
    local target = mouse.Target
    if #remotes == 0 then scanRemotes() end
    for _, remote in pairs(remotes) do
        pcall(function()
            if remote:IsA("RemoteEvent") then
                remote:FireServer("Delete", target)
                remote:FireServer({Action = "Delete", Target = target})
                remote:FireServer("Remove", target)
            end
        end)
    end
    notif("✅ Commands sent!")
end

local function deleteByName(name)
    if name == "" then notif("❌ Masukkan nama!") return end
    if #remotes == 0 then scanRemotes() end
    local count = 0
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Name:lower():find(name:lower()) then
            for _, remote in pairs(remotes) do
                pcall(function()
                    if remote:IsA("RemoteEvent") then
                        remote:FireServer("Delete", obj)
                        remote:FireServer("Remove", obj)
                    end
                end)
            end
            count = count + 1
            if count >= 100 then break end
        end
    end
    notif("✅ Sent " .. count .. " commands!")
end

local function massChaos(name)
    if name == "" then notif("❌ Masukkan nama!") return end
    if #remotes == 0 then scanRemotes() end
    local targets = {}
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Name:lower():find(name:lower()) then
            table.insert(targets, obj)
            if #targets >= 500 then break end
        end
    end
    for _, target in ipairs(targets) do
        for _, remote in pairs(remotes) do
            pcall(function()
                if remote:IsA("RemoteEvent") then
                    remote:FireServer("Delete", target)
                end
            end)
        end
    end
    notif("✅ CHAOS! " .. #targets .. " parts!")
end

local function toggleLoopDelete(name)
    loopDeleteRunning = not loopDeleteRunning
    if loopDeleteRunning then
        loopDeleteConnection = RunService.Heartbeat:Connect(function()
            if not loopDeleteRunning then return end
            for _, obj in pairs(Workspace:GetDescendants()) do
                if obj:IsA("BasePart") and obj.Name:lower():find(name:lower()) then
                    pcall(function()
                        for i = 1, math.min(5, #remotes) do
                            if remotes[i]:IsA("RemoteEvent") then
                                remotes[i]:FireServer("Delete", obj)
                            end
                        end
                    end)
                end
            end
        end)
        notif("🔁 Loop ON")
    else
        if loopDeleteConnection then loopDeleteConnection:Disconnect() end
        notif("⏸️ Loop OFF")
    end
end

local function targetPlayer(name)
    if name == "" then notif("❌ Masukkan nama!") return end
    local target = Players:FindFirstChild(name)
    if not target then
        for _, plr in pairs(Players:GetPlayers()) do
            if plr.Name:lower():find(name:lower()) then target = plr break end
        end
    end
    if not target or not target.Character then notif("❌ Player tidak ditemukan!") return end
    if #remotes == 0 then scanRemotes() end
    for _, remote in pairs(remotes) do
        pcall(function()
            if remote:IsA("RemoteEvent") then
                remote:FireServer("Teleport", target, Vector3.new(0, -999999, 0))
                remote:FireServer("Kill", target)
                remote:FireServer({Action = "Kill", Target = target})
            end
        end)
    end
    notif("✅ Player targeted!")
end

local function toggleFly()
    flying = not flying
    if flying then
        local char = player.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if not root then flying = false notif("❌ No character!") return end
        
        flyBV = Instance.new("BodyVelocity")
        flyBV.Velocity = Vector3.new(0, 0, 0)
        flyBV.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        flyBV.Parent = root
        
        flyBG = Instance.new("BodyGyro")
        flyBG.P = 9e4
        flyBG.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
        flyBG.CFrame = root.CFrame
        flyBG.Parent = root
        
        RunService.Heartbeat:Connect(function()
            if not flying or not flyBV or not flyBV.Parent then return end
            local cam = Workspace.CurrentCamera
            local moveDir = Vector3.new(0, 0, 0)
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + cam.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - cam.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - cam.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + cam.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0, 1, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveDir = moveDir - Vector3.new(0, 1, 0) end
            flyBV.Velocity = moveDir * 70
            flyBG.CFrame = cam.CFrame
        end)
        notif("✈️ Fly ON (WASD + Space/Shift)")
    else
        if flyBV then flyBV:Destroy() end
        if flyBG then flyBG:Destroy() end
        notif("⏸️ Fly OFF")
    end
end

local function toggleNoclip()
    noclipping = not noclipping
    if noclipping then
        noclipConnection = RunService.Stepped:Connect(function()
            if not noclipping then return end
            local char = player.Character
            if char then
                for _, part in pairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then part.CanCollide = false end
                end
            end
        end)
        notif("👻 Noclip ON")
    else
        if noclipConnection then noclipConnection:Disconnect() end
        notif("⏸️ Noclip OFF")
    end
end

local function setSpeed(speed)
    local hum = player.Character and player.Character:FindFirstChild("Humanoid")
    if hum then hum.WalkSpeed = speed notif("🚀 Speed: " .. speed) end
end

local function setJump(power)
    local hum = player.Character and player.Character:FindFirstChild("Humanoid")
    if hum then hum.JumpPower = power notif("🦘 Jump: " .. power) end
end

local function godMode()
    local hum = player.Character and player.Character:FindFirstChild("Humanoid")
    if hum then 
        hum.Health = math.huge 
        hum.MaxHealth = math.huge 
        notif("🛡️ God Mode!") 
    end
end

local function toggleESP()
    espEnabled = not espEnabled
    if espEnabled then
        espConnection = RunService.RenderStepped:Connect(function()
            if not espEnabled then return end
            for _, plr in pairs(Players:GetPlayers()) do
                if plr ~= player and plr.Character then
                    local root = plr.Character:FindFirstChild("HumanoidRootPart")
                    if root and not root:FindFirstChild("ESP_Box") then
                        local box = Instance.new("BoxHandleAdornment")
                        box.Name = "ESP_Box"
                        box.Size = Vector3.new(4, 6, 1)
                        box.Color3 = Color3.fromRGB(255, 0, 0)
                        box.Transparency = 0.7
                        box.AlwaysOnTop = true
                        box.ZIndex = 10
                        box.Adornee = root
                        box.Parent = root
                    end
                end
            end
        end)
        notif("👁️ ESP ON")
    else
        if espConnection then espConnection:Disconnect() end
        for _, plr in pairs(Players:GetPlayers()) do
            if plr.Character then
                local root = plr.Character:FindFirstChild("HumanoidRootPart")
                if root and root:FindFirstChild("ESP_Box") then
                    root.ESP_Box:Destroy()
                end
            end
        end
        notif("⏸️ ESP OFF")
    end
end

local function listPlayers()
    print("=== PLAYERS ===")
    for i, plr in pairs(Players:GetPlayers()) do print(i .. ".", plr.Name) end
    notif("📋 Check F9 Console")
end

local function findCP()
    print("=== CHECKPOINTS ===")
    local f = 0
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and (obj.Name:lower():find("checkpoint") or obj.Name:lower():find("cp") or obj.Name:lower():find("stage")) then
            print(obj.Name, obj:GetFullName()) 
            f = f + 1 
            if f >= 30 then break end
        end
    end
    notif("🔍 Found " .. f .. " checkpoints")
end

local function listParts()
    print("=== TOP PARTS ===")
    local parts = {}
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") then parts[obj.Name] = (parts[obj.Name] or 0) + 1 end
    end
    local sorted = {}
    for name, count in pairs(parts) do table.insert(sorted, {name = name, count = count}) end
    table.sort(sorted, function(a, b) return a.count > b.count end)
    for i = 1, math.min(30, #sorted) do print(i .. ".", sorted[i].name, "(" .. sorted[i].count .. "x)") end
    notif("📊 Check F9 Console")
end

local function setTime(time)
    Lighting.ClockTime = time
    notif("🕐 Time: " .. time)
end

local function fullBright()
    Lighting.Brightness = 3
    Lighting.GlobalShadows = false
    Lighting.OutdoorAmbient = Color3.fromRGB(200, 200, 200)
    Lighting.FogEnd = 100000
    notif("☀️ Full Bright!")
end

local function infiniteJump()
    local infjump = true
    game:GetService("UserInputService").JumpRequest:Connect(function()
        if infjump then
            local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
            if hum then
                hum:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
    end)
    notif("🦘 Infinite Jump ON")
end

-- ============================================
-- CREATE GUI (FIXED LAYOUT - NO OVERLAP!)
-- ============================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "UltimateHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = playerGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 540, 0, 720)
MainFrame.Position = UDim2.new(0.5, -270, 0.5, -360)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 15)
MainCorner.Parent = MainFrame

-- Header
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 55)
Header.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
Header.BorderSizePixel = 0
Header.Parent = MainFrame

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 15)
HeaderCorner.Parent = Header

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -130, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "🔥 ULTIMATE HUB V2"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 22
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local HideBtn = Instance.new("TextButton")
HideBtn.Size = UDim2.new(0, 55, 0, 48)
HideBtn.Position = UDim2.new(1, -115, 0, 3.5)
HideBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
HideBtn.Text = "−"
HideBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
HideBtn.Font = Enum.Font.GothamBold
HideBtn.TextSize = 30
HideBtn.Parent = Header

local HideBtnCorner = Instance.new("UICorner")
HideBtnCorner.CornerRadius = UDim.new(0, 10)
HideBtnCorner.Parent = HideBtn

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 55, 0, 48)
CloseBtn.Position = UDim2.new(1, -58, 0, 3.5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 24
CloseBtn.Parent = Header

local CloseBtnCorner = Instance.new("UICorner")
CloseBtnCorner.CornerRadius = UDim.new(0, 10)
CloseBtnCorner.Parent = CloseBtn

local isHidden = false
HideBtn.MouseButton1Click:Connect(function()
    isHidden = not isHidden
    if isHidden then
        TweenService:Create(MainFrame, TweenInfo.new(0.3), {Size = UDim2.new(0, 540, 0, 55)}):Play()
        HideBtn.Text = "+"
    else
        TweenService:Create(MainFrame, TweenInfo.new(0.3), {Size = UDim2.new(0, 540, 0, 720)}):Play()
        HideBtn.Text = "−"
    end
end)

CloseBtn.MouseButton1Click:Connect(function()
    flying = false
    noclipping = false
    loopDeleteRunning = false
    espEnabled = false
    ScreenGui:Destroy()
    notif("👋 Hub Closed")
end)

-- Content ScrollingFrame
local Content = Instance.new("ScrollingFrame")
Content.Size = UDim2.new(1, -20, 1, -65)
Content.Position = UDim2.new(0, 10, 0, 60)
Content.BackgroundTransparency = 1
Content.ScrollBarThickness = 8
Content.ScrollBarImageColor3 = Color3.fromRGB(255, 50, 50)
Content.CanvasSize = UDim2.new(0, 0, 0, 0) -- Will be updated
Content.Parent = MainFrame

-- GUI Builder Functions (NO OVERLAP!)
local yPos = 10
local buttonInRow = 0
local BUTTON_HEIGHT = 48
local BUTTON_SPACING = 8
local ROW_SPACING = 10

local function makeLabel(text, color)
    -- Reset to new row
    if buttonInRow ~= 0 then
        yPos = yPos + BUTTON_HEIGHT + ROW_SPACING
        buttonInRow = 0
    end
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -20, 0, 38)
    label.Position = UDim2.new(0, 10, 0, yPos)
    label.BackgroundColor3 = color
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 15
    label.Parent = Content
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = label
    
    yPos = yPos + 45
    buttonInRow = 0
end

local function makeButton(text, color, callback)
    local btnWidth = (Content.AbsoluteSize.X - 30) / 2
    local xPos = buttonInRow == 0 and 10 or (btnWidth + 20)
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, btnWidth, 0, BUTTON_HEIGHT)
    btn.Position = UDim2.new(0, xPos, 0, yPos)
    btn.BackgroundColor3 = color
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 13
    btn.TextWrapped = true
    btn.Parent = Content
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn
    
    btn.MouseButton1Click:Connect(function()
        pcall(callback)
    end)
    
    buttonInRow = buttonInRow + 1
    
    if buttonInRow == 2 then
        yPos = yPos + BUTTON_HEIGHT + BUTTON_SPACING
        buttonInRow = 0
    end
    
    return btn
end

local function makeTextBox(placeholder)
    -- Force new row
    if buttonInRow ~= 0 then
        yPos = yPos + BUTTON_HEIGHT + BUTTON_SPACING
        buttonInRow = 0
    end
    
    local box = Instance.new("TextBox")
    box.Size = UDim2.new(1, -20, 0, 42)
    box.Position = UDim2.new(0, 10, 0, yPos)
    box.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    box.Text = ""
    box.PlaceholderText = placeholder
    box.TextColor3 = Color3.fromRGB(255, 255, 255)
    box.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
    box.Font = Enum.Font.Gotham
    box.TextSize = 14
    box.ClearTextOnFocus = false
    box.Parent = Content
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = box
    
    yPos = yPos + 50
    
    return box
end

-- ============================================
-- BUILD GUI CONTENT
-- ============================================

makeLabel("🔍 SCAN & INFO", Color3.fromRGB(0, 120, 200))

makeButton("📡 Scan Remotes", Color3.fromRGB(0, 140, 220), scanRemotes)
makeButton("📋 List Players", Color3.fromRGB(100, 100, 200), listPlayers)
makeButton("🔍 Find Checkpoints", Color3.fromRGB(0, 160, 180), findCP)
makeButton("📊 List Parts", Color3.fromRGB(80, 140, 200), listParts)

makeLabel("🗑️ DELETE OBJECTS", Color3.fromRGB(200, 50, 50))

makeButton("⚡ Delete Hover", Color3.fromRGB(220, 60, 60), deleteHover)

local deleteInput = makeTextBox("Nama part untuk delete...")

makeButton("🗑️ Delete by Name", Color3.fromRGB(200, 40, 40), function()
    deleteByName(deleteInput.Text)
end)

makeButton("💥 Mass Chaos", Color3.fromRGB(180, 0, 0), function()
    massChaos(deleteInput.Text)
end)

local loopBtn = makeButton("🔁 Loop Delete", Color3.fromRGB(150, 0, 50), function()
    toggleLoopDelete(deleteInput.Text)
    loopBtn.Text = loopDeleteRunning and "⏸️ Stop Loop" or "🔁 Loop Delete"
end)

makeLabel("😈 TARGET PLAYER", Color3.fromRGB(150, 0, 200))

local playerInput = makeTextBox("Nama player...")

makeButton("😈 Target Player", Color3.fromRGB(180, 0, 180), function()
    targetPlayer(playerInput.Text)
end)

local espBtn = makeButton("👁️ Player ESP", Color3.fromRGB(200, 0, 200), function()
    toggleESP()
    espBtn.Text = espEnabled and "⏸️ Stop ESP" or "👁️ Player ESP"
end)

makeLabel("✈️ MOVEMENT", Color3.fromRGB(0, 150, 255))

local flyBtn = makeButton("✈️ Fly (WASD)", Color3.fromRGB(0, 160, 255), function()
    toggleFly()
    flyBtn.Text = flying and "⏸️ Stop Fly" or "✈️ Fly (WASD)"
end)

local noclipBtn = makeButton("👻 Noclip", Color3.fromRGB(150, 0, 255), function()
    toggleNoclip()
    noclipBtn.Text = noclipping and "⏸️ Stop Noclip" or "👻 Noclip"
end)

makeButton("🚀 Speed 100", Color3.fromRGB(255, 140, 0), function() setSpeed(100) end)
makeButton("🚀 Speed 200", Color3.fromRGB(255, 100, 0), function() setSpeed(200) end)
makeButton("🦘 Jump 150", Color3.fromRGB(0, 255, 100), function() setJump(150) end)
makeButton("🦘 Infinite Jump", Color3.fromRGB(0, 200, 150), infiniteJump)
makeButton("🛡️ God Mode", Color3.fromRGB(255, 215, 0), godMode)

makeLabel("🌅 LIGHTING & VISUAL", Color3.fromRGB(255, 180, 0))

makeButton("☀️ Day", Color3.fromRGB(255, 200, 0), function() setTime(14) end)
makeButton("🌙 Night", Color3.fromRGB(20, 20, 80), function() setTime(0) end)
makeButton("💡 Full Bright", Color3.fromRGB(255, 255, 0), fullBright)

-- Update canvas size
yPos = yPos + 20
Content.CanvasSize = UDim2.new(0, 0, 0, yPos)

-- ============================================
-- AUTO INITIALIZE
-- ============================================

task.spawn(function()
    task.wait(1.5)
    local count = scanRemotes()
    notif("🔥 Hub Loaded! " .. count .. " remotes found!")
end)

print("================================")
print("ULTIMATE HUB V2")
print("✅ Layout Fixed - No Overlap!")
print("✅ Advanced AC Bypass Active!")
print("PlaceId:", game.PlaceId)
print("================================")
