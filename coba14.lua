-- Services
local player = game.Players.LocalPlayer
local runService = game:GetService("RunService")
local tweenService = game:GetService("TweenService")

-- Variabel global
local flying = false
local wallhack = false
local speed = 70
local ascendSpeed = 30
local verticalVelocity = 0
local menuFrame, flyButton, wallhackButton, modButton
local trailColor = Color3.fromRGB(128,0,255)
local glowColor = Color3.fromRGB(128,0,255)
local trailLength = 0.5
local trailWidth = 0.2
local particleRate = 30
local particleSpeed = {2,5}

local function setupCharacter(character)
    local humanoid = character:WaitForChild("Humanoid")
    local rootPart = character:WaitForChild("HumanoidRootPart")
    local rightFoot = character:WaitForChild("RightFoot")

    flying = false
    verticalVelocity = 0

    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(1e5,1e5,1e5)
    bodyVelocity.Velocity = Vector3.new(0,0,0)
    bodyVelocity.P = 1e4

    -- Trail
    local attachFoot = Instance.new("Attachment", rightFoot)
    local attachTrail = Instance.new("Attachment", rightFoot)
    local trail = Instance.new("Trail", rightFoot)
    trail.Attachment0 = attachFoot
    trail.Attachment1 = attachTrail
    trail.Lifetime = trailLength
    trail.Enabled = false
    trail.Color = ColorSequence.new{ColorSequenceKeypoint.new(0,trailColor), ColorSequenceKeypoint.new(1,Color3.fromRGB(255,0,255))}
    trail.WidthScale = NumberSequence.new{NumberSequenceKeypoint.new(0,trailWidth), NumberSequenceKeypoint.new(1,0)}

    -- Particle
    local particle = Instance.new("ParticleEmitter", rightFoot)
    particle.Rate = particleRate
    particle.Speed = NumberRange.new(particleSpeed[1],particleSpeed[2])
    particle.VelocityInheritance = 1
    particle.EmissionDirection = Enum.NormalId.Top
    particle.Orientation = Enum.ParticleOrientation.VelocityPerpendicular
    particle.Enabled = false
    particle.LightEmission = 0.8
    particle.Size = NumberSequence.new(0.3,0.1)
    particle.Color = ColorSequence.new(Color3.fromRGB(0,0,0))

    -- Glow
    local glow = Instance.new("PointLight", rightFoot)
    glow.Range = 10
    glow.Brightness = 1
    glow.Color = glowColor
    glow.Enabled = false

    -- GUI
    if not menuFrame then
        local screenGui = Instance.new("ScreenGui", player.PlayerGui)
        screenGui.ResetOnSpawn = false

        modButton = Instance.new("TextButton", screenGui)
        modButton.Size = UDim2.new(0,100,0,50)
        modButton.Position = UDim2.new(0,10,0,10)
        modButton.Text = "Mod Menu"

        menuFrame = Instance.new("Frame", screenGui)
        menuFrame.Size = UDim2.new(0,400,0,220)
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

        -- Realtime tweak trail
        local tweakTrailColor = Instance.new("TextButton", menuFrame)
        tweakTrailColor.Size = UDim2.new(0,120,0,30)
        tweakTrailColor.Position = UDim2.new(0,150,0,10)
        tweakTrailColor.Text = "Trail Color"
        tweakTrailColor.MouseButton1Click:Connect(function()
            trailColor = Color3.fromRGB(math.random(0,255),math.random(0,255),math.random(0,255))
            trail.Color = ColorSequence.new{ColorSequenceKeypoint.new(0,trailColor), ColorSequenceKeypoint.new(1,Color3.fromRGB(255,0,255))}
        end)

        local tweakTrailLength = Instance.new("TextButton", menuFrame)
        tweakTrailLength.Size = UDim2.new(0,120,0,30)
        tweakTrailLength.Position = UDim2.new(0,150,0,50)
        tweakTrailLength.Text = "Trail Length +"
        tweakTrailLength.MouseButton1Click:Connect(function()
            trailLength = trailLength + 0.1
            trail.Lifetime = trailLength
        end)

        local tweakTrailWidth = Instance.new("TextButton", menuFrame)
        tweakTrailWidth.Size = UDim2.new(0,120,0,30)
        tweakTrailWidth.Position = UDim2.new(0,150,0,90)
        tweakTrailWidth.Text = "Trail Width +"
        tweakTrailWidth.MouseButton1Click:Connect(function()
            trailWidth = trailWidth + 0.05
            trail.WidthScale = NumberSequence.new{NumberSequenceKeypoint.new(0,trailWidth), NumberSequenceKeypoint.new(1,0)}
        end)

        -- Realtime tweak glow
        local tweakGlowColor = Instance.new("TextButton", menuFrame)
        tweakGlowColor.Size = UDim2.new(0,120,0,30)
        tweakGlowColor.Position = UDim2.new(0,280,0,10)
        tweakGlowColor.Text = "Glow Color"
        tweakGlowColor.MouseButton1Click:Connect(function()
            glowColor = Color3.fromRGB(math.random(0,255),math.random(0,255),math.random(0,255))
            glow.Color = glowColor
        end)

        local tweakGlowBright = Instance.new("TextButton", menuFrame)
        tweakGlowBright.Size = UDim2.new(0,120,0,30)
        tweakGlowBright.Position = UDim2.new(0,280,0,50)
        tweakGlowBright.Text = "Glow Bright +"
        tweakGlowBright.MouseButton1Click:Connect(function()
            glow.Brightness = glow.Brightness + 0.5
        end)

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
        tweenService:Create(glow, TweenInfo.new(0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, -1, true), {Brightness = glow.Brightness, Range = 12}):Play()
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
            local cam = workspace.CurrentCamera
            local moveDir = (cam.CFrame.LookVector * direction.Magnitude) + Vector3.new(0,verticalVelocity,0)
            bodyVelocity.Velocity = bodyVelocity.Velocity:Lerp(moveDir
