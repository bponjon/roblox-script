-- Services
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")
local runService = game:GetService("RunService")

-- Variabel
local flying = false
local modMenuOpen = false
local wallhack = false
local speed = 50
local ascendSpeed = 25
local verticalVelocity = 0

-- GUI Setup
local screenGui = Instance.new("ScreenGui", player.PlayerGui)
screenGui.ResetOnSpawn = false

-- Mod Menu
local modButton = Instance.new("TextButton", screenGui)
modButton.Size = UDim2.new(0,100,0,50)
modButton.Position = UDim2.new(0,10,0,10)
modButton.Text = "Mod Menu"

local menuFrame = Instance.new("Frame", screenGui)
menuFrame.Size = UDim2.new(0,280,0,160)
menuFrame.Position = UDim2.new(0,10,0,70)
menuFrame.BackgroundColor3 = Color3.fromRGB(30,30,30)
menuFrame.BackgroundTransparency = 0.4
menuFrame.Visible = false

-- Tombol
local flyButton = Instance.new("TextButton", menuFrame)
flyButton.Size = UDim2.new(0,120,0,50)
flyButton.Position = UDim2.new(0,0,0,0)
flyButton.Text = "Fly"

local upButton = Instance.new("TextButton", menuFrame)
upButton.Size = UDim2.new(0,120,0,50)
upButton.Position = UDim2.new(0,140,0,0)
upButton.Text = "↑"

local downButton = Instance.new("TextButton", menuFrame)
downButton.Size = UDim2.new(0,120,0,50)
downButton.Position = UDim2.new(0,140,0,60)
downButton.Text = "↓"

local wallhackButton = Instance.new("TextButton", menuFrame)
wallhackButton.Size = UDim2.new(0,120,0,50)
wallhackButton.Position = UDim2.new(0,0,0,60)
wallhackButton.Text = "Wallhack"

-- Toggle Mod Menu
modButton.MouseButton1Click:Connect(function()
    modMenuOpen = not modMenuOpen
    menuFrame.Visible = modMenuOpen
end)

-- Flying Setup
local bodyVelocity = Instance.new("BodyVelocity")
bodyVelocity.MaxForce = Vector3.new(1e5,1e5,1e5)
bodyVelocity.Velocity = Vector3.new(0,0,0)
bodyVelocity.P = 1e4

-- Functions
local function startFlying()
    if flying then return end
    flying = true
    bodyVelocity.Parent = rootPart
    humanoid.PlatformStand = false
    humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall,false)
end

local function stopFlying()
    if not flying then return end
    flying = false
    verticalVelocity = 0
    bodyVelocity.Parent = nil
    humanoid.PlatformStand = false
    humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall,true)
end

flyButton.MouseButton1Click:Connect(function()
    if flying then stopFlying() else startFlying() end
end)

-- Tombol naik/turun
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
        -- Horizontal dengan MoveDirection → animasi normal
        humanoid:Move(humanoid.MoveDirection,false)

        -- Vertical & Horizontal smooth
        local targetVelocity = humanoid.MoveDirection*speed + Vector3.new(0,verticalVelocity,0)
        bodyVelocity.Velocity = bodyVelocity.Velocity:Lerp(targetVelocity,0.15) -- smoothing 0.15 → gerak halus
    end
end)
