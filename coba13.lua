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
local menuFrame, flyButton, wallhackButton, modButton

-- Fungsi setup karakter & GUI
local function setupCharacter(character)
    local humanoid = character:WaitForChild("Humanoid")
    local rootPart = character:WaitForChild("HumanoidRootPart")
    local leftFoot = character:WaitForChild("LeftFoot")
    local rightFoot = character:WaitForChild("RightFoot")

    -- Reset flying
    flying = false
    verticalVelocity = 0

    -- BodyVelocity untuk terbang
    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(1e5,1e5,1e5)
    bodyVelocity.Velocity = Vector3.new(0,0,0)
    bodyVelocity.P = 1e4

    -- Efek kaki
    local attachFoot = Instance.new("Attachment", rightFoot)
    
    -- Trail ungu
    local trail = Instance.new("Trail", rightFoot)
    local attachTrail0 = Instance.new("Attachment", rightFoot)
    trail.Attachment0 = attachFoot
    trail.Attachment1 = attachTrail0
    trail.Lifetime = 0.3
    trail.Enabled = false
    trail.Color = ColorSequence.new(Color3.fromRGB(128,0,255))

    -- Particle hitam pekat
    local particle = Instance.new("ParticleEmitter", rightFoot)
    particle.Rate = 15
    particle.Speed = NumberRange.new(1,3)
    particle.VelocityInheritance = 0.8
    particle.EmissionDirection = Enum.NormalId.Top
    particle.Orientation = Enum.ParticleOrientation.VelocityPerpendicular
    particle.Enabled = false
    particle.LightEmission = 0.7
    particle.Size = NumberSequence.new(0.3,0.1)
    particle.Color = ColorSequence.new(Color3.fromRGB(0,0,0))

    -- Glow kaki
    local glow = Instance.new("PointLight", rightFoot)
    glow.Range = 8
    glow.Brightness = 1
    glow.Color = Color3.fromRGB(128,0,255)
    glow.Enabled = false

    -- GUI Setup
    if not menuFrame then
        local screenGui = Instance.new("ScreenGui", player.PlayerGui)
        screenGui.ResetOnSpawn = false

        modButton = Instance.new("TextButton", screenGui)
        modButton.Size = UDim2.new(0,100,0,50)
        modButton.Position = UDim2.new(0,10,0,10)
        modButton.Text = "Mod Menu"

        menuFrame = Instance.new("Frame", screenGui)
        menuFrame.Size = UDim2.new(0,220,0,100)
        menuFrame.Position = UDim2.new(0,10,0,70)
        menuFrame.BackgroundColor3 = Color3.fromRGB(30,30,30)
        menuFrame.BackgroundTransparency = 0.4
        menuFrame.Visible = false

        flyButton = Instance.new("TextButton", menuFrame)
        flyButton.Size = UDim2.new(0,100,0,40)
        flyButton.Position = UDim2.new(0,10,0,10)
        flyButton.Text = "Fly"

        wallhackButton = Instance.new("TextButton", menuFrame)
        wallhackButton.Size = UDim2.new(0,100,0,40)
        wallhackButton.Position = UDim2.new(0,10,0,60)
        wallhackButton.Text = "Wallhack"

        modButton.MouseButton1Click:Connect(function()
            menuFrame.Visible = not menuFrame.Visible
        end)
    end

    -- Start/Stop flying
    local function startFlying()
        if flying then return end
        flying = true
        bodyVelocity.Parent = rootPart
        humanoid.PlatformStand = false
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall,false)
        trail.Enabled = true
        particle.Enabled = true
        glow.Enabled = true
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

    flyButton.MouseButton1Click:Connect(function()
        if flying then stopFlying() else startFlying() end
    end)

    wallhackButton.MouseButton1Click:Connect(function()
        wallhack = not wallhack
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = not wallhack
            end
        end
    end)

    -- Update loop
    runService.RenderStepped:Connect(function()
        if flying then
            local direction = humanoid.MoveDirection
            -- Ambil arah layar HP untuk naik/turun
            local cam = workspace.CurrentCamera
            local moveDir = (cam.CFrame.LookVector * direction.Magnitude) + Vector3.new(0,verticalVelocity,0)
            bodyVelocity.Velocity = bodyVelocity.Velocity:Lerp(moveDir*speed,0.15)
            humanoid:Move(direction,false)
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
