-- Player & Services
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")
local runService = game:GetService("RunService")
local userInputService = game:GetService("UserInputService")

-- Variables
local flying = false
local modMenuOpen = false
local speed = 60
local direction = Vector3.new(0,0,0)
local bodyVelocity, bodyGyro

-- GUI Setup
local screenGui = Instance.new("ScreenGui", player.PlayerGui)
screenGui.ResetOnSpawn = false

-- Mod Menu Toggle Button
local modButton = Instance.new("TextButton", screenGui)
modButton.Size = UDim2.new(0,100,0,50)
modButton.Position = UDim2.new(0,10,0,10)
modButton.Text = "Mod Menu"

-- Container untuk tombol fly & kontrol
local menuFrame = Instance.new("Frame", screenGui)
menuFrame.Size = UDim2.new(0,240,0,120)
menuFrame.Position = UDim2.new(0,10,0,70)
menuFrame.BackgroundColor3 = Color3.fromRGB(30,30,30)
menuFrame.BackgroundTransparency = 0.4
menuFrame.Visible = false

-- Fly Toggle Button
local flyButton = Instance.new("TextButton", menuFrame)
flyButton.Size = UDim2.new(0,100,0,50)
flyButton.Position = UDim2.new(0,0,0,0)
flyButton.Text = "Fly"

-- Up Button
local upButton = Instance.new("TextButton", menuFrame)
upButton.Size = UDim2.new(0,100,0,50)
upButton.Position = UDim2.new(0,120,0,0)
upButton.Text = "↑"

-- Down Button
local downButton = Instance.new("TextButton", menuFrame)
downButton.Size = UDim2.new(0,100,0,50)
downButton.Position = UDim2.new(0,120,0,60)
downButton.Text = "↓"

-- Joystick Frame
local joystickFrame = Instance.new("Frame", screenGui)
joystickFrame.Size = UDim2.new(0,150,0,150)
joystickFrame.Position = UDim2.new(1,-160,1,-160)
joystickFrame.BackgroundColor3 = Color3.fromRGB(50,50,50)
joystickFrame.BackgroundTransparency = 0.5
joystickFrame.AnchorPoint = Vector2.new(0,0)
joystickFrame.Visible = false

local joystickKnob = Instance.new("Frame", joystickFrame)
joystickKnob.Size = UDim2.new(0,50,0,50)
joystickKnob.Position = UDim2.new(0.5,-25,0.5,-25)
joystickKnob.BackgroundColor3 = Color3.fromRGB(200,200,200)
joystickKnob.AnchorPoint = Vector2.new(0.5,0.5)
joystickKnob.BorderSizePixel = 0
joystickKnob.ClipsDescendants = true
joystickKnob.Active = true

-- Toggle Mod Menu
modButton.MouseButton1Click:Connect(function()
    modMenuOpen = not modMenuOpen
    menuFrame.Visible = modMenuOpen
    joystickFrame.Visible = modMenuOpen
end)

-- Function to start flying
local function startFlying()
    if flying then return end
    flying = true

    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(4000,4000,4000)
    bodyVelocity.Velocity = Vector3.new(0,0,0)
    bodyVelocity.Parent = rootPart

    bodyGyro = Instance.new("BodyGyro")
    bodyGyro.MaxTorque = Vector3.new(4000,4000,4000)
    bodyGyro.CFrame = rootPart.CFrame
    bodyGyro.Parent = rootPart

    humanoid.PlatformStand = true
end

-- Function to stop flying
local function stopFlying()
    if not flying then return end
    flying = false

    bodyVelocity:Destroy()
    bodyGyro:Destroy()
    humanoid.PlatformStand = false
    direction = Vector3.new(0,0,0)
end

-- Fly button toggle
flyButton.MouseButton1Click:Connect(function()
    if flying then stopFlying() else startFlying() end
end)

-- Up/Down buttons
upButton.MouseButton1Down:Connect(function() direction = direction + Vector3.new(0,1,0) end)
upButton.MouseButton1Up:Connect(function() direction = direction - Vector3.new(0,1,0) end)

downButton.MouseButton1Down:Connect(function() direction = direction + Vector3.new(0,-1,0) end)
downButton.MouseButton1Up:Connect(function() direction = direction - Vector3.new(0,-1,0) end)

-- Joystick logic
local dragging = false
local function updateJoystick(inputPos)
    local center = joystickFrame.AbsolutePosition + Vector2.new(joystickFrame.AbsoluteSize.X/2, joystickFrame.AbsoluteSize.Y/2)
    local offset = inputPos - center
    local maxRadius = joystickFrame.AbsoluteSize.X/2
    if offset.Magnitude > maxRadius then
        offset = offset.Unit * maxRadius
    end
    joystickKnob.Position = UDim2.new(0.5, offset.X, 0.5, offset.Y)
    -- Calculate direction vector relative camera
    local cam = workspace.CurrentCamera
    local forward = cam.CFrame.LookVector
    local right = cam.CFrame.RightVector
    direction = forward * ( -offset.Y / maxRadius ) + right * ( offset.X / maxRadius )
end

joystickKnob.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
    end
end)
joystickKnob.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
        direction = Vector3.new(0,direction.Y,0)
        joystickKnob.Position = UDim2.new(0.5,-25,0.5,-25)
    end
end)
userInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.Touch then
        updateJoystick(input.Position)
    end
end)

-- Update loop
runService.RenderStepped:Connect(function()
    if flying and bodyVelocity then
        bodyVelocity.Velocity = direction * speed
        if direction.Magnitude > 0 then
            bodyGyro.CFrame = CFrame.new(rootPart.Position, rootPart.Position + direction)
        end
    end
end)
