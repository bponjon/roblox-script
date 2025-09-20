-- Player & Services
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")
local runService = game:GetService("RunService")
local userInputService = game:GetService("UserInputService")

-- Variabel
local flying = false
local modMenuOpen = false
local wallhack = false
local speed = 50
local verticalSpeed = 0
local ascendSpeed = 25 -- vertical speed lebih kecil biar tangan normal

-- GUI Setup
local screenGui = Instance.new("ScreenGui", player.PlayerGui)
screenGui.ResetOnSpawn = false

-- Mod Menu Toggle Button
local modButton = Instance.new("TextButton", screenGui)
modButton.Size = UDim2.new(0, 100, 0, 50)
modButton.Position = UDim2.new(0, 10, 0, 10)
modButton.Text = "Mod Menu"

-- Container tombol
local menuFrame = Instance.new("Frame", screenGui)
menuFrame.Size = UDim2.new(0, 280, 0, 160)
menuFrame.Position = UDim2.new(0, 10, 0, 70)
menuFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
menuFrame.BackgroundTransparency = 0.4
menuFrame.Visible = false

-- Fly Toggle Button
local flyButton = Instance.new("TextButton", menuFrame)
flyButton.Size = UDim2.new(0, 120, 0, 50)
flyButton.Position = UDim2.new(0, 0, 0, 0)
flyButton.Text = "Fly"

-- Up Button
local upButton = Instance.new("TextButton", menuFrame)
upButton.Size = UDim2.new(0, 120, 0, 50)
upButton.Position = UDim2.new(0, 140, 0, 0)
upButton.Text = "↑"

-- Down Button
local downButton = Instance.new("TextButton", menuFrame)
downButton.Size = UDim2.new(0, 120, 0, 50)
downButton.Position = UDim2.new(0, 140, 0, 60)
downButton.Text = "↓"

-- Wallhack Toggle
local wallhackButton = Instance.new("TextButton", menuFrame)
wallhackButton.Size = UDim2.new(0, 120, 0, 50)
wallhackButton.Position = UDim2.new(0, 0, 0, 60)
wallhackButton.Text = "Wallhack"

-- Toggle Mod Menu
modButton.MouseButton1Click:Connect(function()
    modMenuOpen = not modMenuOpen
    menuFrame.Visible = modMenuOpen
end)

-- Start/Stop flying
local function startFlying()
    if flying then return end
    flying = true
    humanoid.PlatformStand = false
    -- Nonaktifkan fall damage
    humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall, false)
end

local function stopFlying()
    if not flying then return end
    flying = false
    verticalSpeed = 0
    humanoid.PlatformStand = false
    humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall, true)
end

flyButton.MouseButton1Click:Connect(function()
    if flying then stopFlying() else startFlying() end
end)

-- Tombol naik/turun
upButton.MouseButton1Down:Connect(function() verticalSpeed = ascendSpeed end)
upButton.MouseButton1Up:Connect(function() verticalSpeed = 0 end)

downButton.MouseButton1Down:Connect(function() verticalSpeed = -ascendSpeed end)
downButton.MouseButton1Up:Connect(function() verticalSpeed = 0 end)

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
        -- Ambil arah horizontal dari kontrol HP bawaan
        local moveDir = humanoid.MoveDirection
        -- Gabungkan horizontal + vertical
        local newVelocity = moveDir * speed + Vector3.new(0, verticalSpeed, 0)
        rootPart.Velocity = newVelocity
    end
end)
