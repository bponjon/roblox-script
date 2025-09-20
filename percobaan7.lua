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
local speed = 50
local verticalVelocity = 0
local ascendSpeed = 50

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
menuFrame.Size = UDim2.new(0, 240, 0, 120)
menuFrame.Position = UDim2.new(0, 10, 0, 70)
menuFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
menuFrame.BackgroundTransparency = 0.4
menuFrame.Visible = false

-- Fly Toggle Button
local flyButton = Instance.new("TextButton", menuFrame)
flyButton.Size = UDim2.new(0, 100, 0, 50)
flyButton.Position = UDim2.new(0, 0, 0, 0)
flyButton.Text = "Fly"

-- Up Button
local upButton = Instance.new("TextButton", menuFrame)
upButton.Size = UDim2.new(0, 100, 0, 50)
upButton.Position = UDim2.new(0, 120, 0, 0)
upButton.Text = "↑"

-- Down Button
local downButton = Instance.new("TextButton", menuFrame)
downButton.Size = UDim2.new(0, 100, 0, 50)
downButton.Position = UDim2.new(0, 120, 0, 60)
downButton.Text = "↓"

-- Toggle Mod Menu
modButton.MouseButton1Click:Connect(function()
    modMenuOpen = not modMenuOpen
    menuFrame.Visible = modMenuOpen
end)

-- Start/Stop flying dengan bypass animasi
local function startFlying()
    if flying then return end
    flying = true
    -- Bypass animasi: disable PlatformStand tapi tetap bisa terbang
    humanoid:ChangeState(Enum.HumanoidStateType.Physics)
end

local function stopFlying()
    if not flying then return end
    flying = false
    verticalVelocity = 0
    humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
end

flyButton.MouseButton1Click:Connect(function()
    if flying then stopFlying() else startFlying() end
end)

-- Tombol naik/turun
upButton.MouseButton1Down:Connect(function() verticalVelocity = ascendSpeed end)
upButton.MouseButton1Up:Connect(function() verticalVelocity = 0 end)

downButton.MouseButton1Down:Connect(function() verticalVelocity = -ascendSpeed end)
downButton.MouseButton1Up:Connect(function() verticalVelocity = 0 end)

-- Update loop
runService.RenderStepped:Connect(function(delta)
    if flying then
        -- Ambil arah horizontal dari kontrol HP bawaan
        local moveDir = humanoid.MoveDirection
        -- Gabungkan horizontal + vertical
        local velocity = moveDir * speed + Vector3.new(0, verticalVelocity, 0)
        rootPart.Velocity = velocity
    end
end)
