-- Services
local player = game.Players.LocalPlayer
local runService = game:GetService("RunService")
local tweenService = game:GetService("TweenService")

-- Variabel global
local flying = false
local wallhack = false
local speed = 50
local ascendSpeed = 25
local verticalVelocity = 0
local menuFrame, flyButton, upButton, downButton, wallhackButton, modButton

-- Fungsi setup karakter & GUI
local function setupCharacter(character)
    local humanoid = character:WaitForChild("Humanoid")
    local rootPart = character:WaitForChild("HumanoidRootPart")

    -- Reset flying
    flying = false
    verticalVelocity = 0

    -- BodyVelocity untuk gerak smooth
    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(1e5,1e5,1e5)
    bodyVelocity.Velocity = Vector3.new(0,0,0)
    bodyVelocity.P = 1e4

    -- Trail (ungu)
    local trail = Instance.new("Trail", rootPart)
    local attach0 = Instance.new("Attachment", rootPart)
    local attach1 = Instance.new("Attachment", character:WaitForChild("RightHand"))
    trail.Attachment0 = attach0
    trail.Attachment1 = attach1
    trail.Lifetime = 0.3
    trail.Enabled = false
    trail.Color = ColorSequence.new(Color3.fromRGB(128,0,255))

    -- Particle (hitam pekat)
    local particle = Instance.new("ParticleEmitter", rootPart)
    particle.Rate = 15
    particle.Speed = NumberRange.new(1,3)
    particle.VelocityInheritance = 0.8
    particle.EmissionDirection = Enum.NormalId.Top
    particle.Orientation = Enum.ParticleOrientation.VelocityPerpendicular
    particle.Enabled = false
    particle.LightEmission = 0.7
    particle.Size = NumberSequence.new(0.3,0.1)
    particle.Color = ColorSequence.new(Color3.fromRGB(0,0,0))

    -- Glow (ungu)
    local glow = Instance.new("PointLight", rootPart)
    glow.Range = 8
    glow.Brightness = 1
    glow.Color = Color3.fromRGB(128,0,255)
    glow.Enabled = false

    -- GUI Setup
    if not menuFrame then
        local screenGui = Instance.new("ScreenGui", player.PlayerGui)
        screenGui.ResetOnSpawn = false

        -- Mod Menu Toggle
        modButton = Instance.new("TextButton", screenGui)
        modButton.Size = UDim2.new(0,100,0,50)
        modButton.Position = UDim2.new(0,10,0,10)
        modButton.Text = "Mod Menu"

        menuFrame = Instance.new("Frame", screenGui)
        menuFrame.Size = UDim2.new(0,280,0,160)
        menuFrame.Position = UDim2.new(0,10,0,70)
        menuFrame.BackgroundColor3 = Color3.fromRGB(30,30,30)
        menuFrame.BackgroundTransparency = 0.4
        menuFrame.Visible = false

        flyButton = Instance.new("TextButton", menuFrame)
        flyButton.Size = UDim2.new(0,120,0,50)
        flyButton.Position = UDim2.new(0,0,0,0)
        flyButton.Text = "Fly"

        upButton = Instance.new("TextButton", menuFrame)
        upButton.Size = UDim2.new(0,120,0,50)
        upButton.Position = UDim2.new(0,140,0,0)
        upButton.Text = "↑"

        downButton = Instance.new("TextButton", menuFrame)
        downButton.Size = UDim2.new(0,120,0,50)
        downButton.Position = UDim2.new(0,140,0,60)
        downButton.Text = "↓"

        wallhackButton = Instance.new("TextButton", menuFrame)
        wallhackButton.Size = UDim2.new(0,120,0,50)
        wallhackButton.Position = UDim2.new(0,0,0,60)
        wallhackButton.Text = "Wallhack"

        modButton.MouseButton1Click:Connect(function()
            menuFrame.Visible = not menuFrame.Visible
        end)
    end

    -- Start/Stop flying functions
    local function startFlying()
        if flying then return end
        flying = true
        bodyVelocity.Parent = rootPart
        humanoid.PlatformStand = false
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall,false)
        trail.Enabled = true
        particle.Enabled = true
        glow.Enabled = true
        -- Tween glow sesuai speed
        tweenService:Create(glow, TweenInfo.new(0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, -1, true), {Brightness = 2, Range = 10}):Play()
    end

    local function stopFlying()
        if not flying then return end
        flying = false
        verticalVelocity = 0
        bodyVelocity.Parent = nil
        humanoid.PlatformStand = false
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall,true)
        trail.Enabled = false
        particle.Enabled = false
        glow.Enabled = false
    end

    -- Tombol Fly
    flyButton.MouseButton1Click:Connect(function()
        if flying then stopFlying() else startFlying() end
    end)

    -- Tombol Naik/Turun
    upButton.MouseButton1Down:Connect(function() verticalVelocity = ascendSpeed end)
    upButton.MouseButton1Up:Connect(function() verticalVelocity = 0 end)
    downButton.MouseButton1Down:Connect(function() verticalVelocity = -ascendSpeed end)
    downButton.MouseButton1Up:Connect(function() verticalVelocity = 0 end)

    -- Wallhack toggle
    wallhackButton.MouseButton1Click:Connect(function()
        wallhack = not wallhack
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = not wallhack
            end
        end
    end)

    -- Update loop
    runService.RenderStepped:Connect(function(delta)
        if flying then
            -- Horizontal movement → animasi jalan normal
            humanoid:Move(humanoid.MoveDirection,false)
            -- Smooth velocity horizontal + vertical
            local targetVelocity = humanoid.MoveDirection*speed + Vector3.new(0,verticalVelocity,0)
            bodyVelocity.Velocity = bodyVelocity.Velocity:Lerp(targetVelocity,0.15)
        end
    end)

    -- Reset saat mati
    humanoid.Died:Connect(function()
        stopFlying()
        verticalVelocity = 0
    end)
end

-- Setup pertama kali
if player.Character then
    setupCharacter(player.Character)
end

-- Setup ulang tiap respawn
player.CharacterAdded:Connect(function(char)
    setupCharacter(char)
end)
