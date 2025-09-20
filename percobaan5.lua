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
local ascendSpeed = 50

-- GUI Setup
local screenGui = Instance.new("ScreenGui", player.PlayerGui)
screenGui.ResetOnSpawn = false

-- Mod Menu Toggle Button
local modButton = Instance.new("TextButton", screenGui)
modButton.Size = UDim2.new(0, 100, 0, 50)
modButton.Position = UDim2.new(0, 10, 0, 10)
modButton.Text = "Mod Menu"

-- Container untuk tombol fly & kontrol
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

-- Function to start flying
local function startFlying()
    if flying then return end
    flying = true
    humanoid.PlatformStand = true
end

-- Function to stop flying
local function stopFlying()
    if not flying then return end
    flying = false
    humanoid.PlatformStand = false
end

-- Fly button toggle
flyButton.MouseButton1Click:Connect(function()
    if flying then stopFlying() else startFlying() end
end)

-- Up/Down buttons
upButton.MouseButton1Down:Connect(function() flying = true end)
upButton.MouseButton1Up:Connect(function() end)

downButton.MouseButton1Down:Connect(function() flying = true end)
downButton.MouseButton1Up:Connect(function() end)

-- Update loop untuk terbang
runService.RenderStepped:Connect(function(delta)
    if flying then
        -- Ambil arah gerak dari kontrol HP bawaan
        local moveDir = humanoid.MoveDirection
        local velocity = moveDir * speed
        velocity = velocity + Vector3.new(0, (userInputService:IsKeyDown(Enum.KeyCode.Space) and ascendSpeed or 0) - (userInputService:IsKeyDown(Enum.KeyCode.LeftControl) and ascendSpeed or 0), 0)
        rootPart.Velocity = velocity
    end
end)
