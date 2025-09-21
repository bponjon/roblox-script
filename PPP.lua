local player = game.Players.LocalPlayer
local runService = game:GetService("RunService")
local uis = game:GetService("UserInputService")

-- Pastikan character siap
local function getCharacter()
    local char = player.Character or player.CharacterAdded:Wait()
    local hum = char:WaitForChild("Humanoid")
    local root = char:WaitForChild("HumanoidRootPart")
    return char, hum, root
end

local character, humanoid, root = getCharacter()

-- Data FINALATIN pos 26 & puncak
local pos26 = Vector3.new(10,50,20)  -- ganti sesuai FINALATIN
local puncak = Vector3.new(100,200,150) -- ganti sesuai FINALATIN

-- States
local flying = false
local wallhack = false
local autoSummitActive = false

-- BodyVelocity untuk Fly
local bv = Instance.new("BodyVelocity")
bv.MaxForce = Vector3.new(1e5,1e5,1e5)
bv.Velocity = Vector3.new(0,0,0)
bv.Parent = root

-- Mod Menu GUI
local screenGui = Instance.new("ScreenGui", player.PlayerGui)
screenGui.ResetOnSpawn = false

local modButton = Instance.new("TextButton", screenGui)
modButton.Size = UDim2.new(0,100,0,50)
modButton.Position = UDim2.new(0,10,0,10)
modButton.Text = "Mod Menu"

local menuFrame = Instance.new("Frame", screenGui)
menuFrame.Size = UDim2.new(0,300,0,200)
menuFrame.Position = UDim2.new(0,10,0,70)
menuFrame.BackgroundColor3 = Color3.fromRGB(30,30,30)
menuFrame.BackgroundTransparency = 0.4
menuFrame.Visible = false

-- Buttons
local flyButton = Instance.new("TextButton", menuFrame)
flyButton.Size = UDim2.new(0,100,0,40)
flyButton.Position = UDim2.new(0,10,0,10)
flyButton.Text = "Fly"

local wallhackButton = Instance.new("TextButton", menuFrame)
wallhackButton.Size = UDim2.new(0,100,0,40)
wallhackButton.Position = UDim2.new(0,10,0,60)
wallhackButton.Text = "Wallhack"

local autoSummitButton = Instance.new("TextButton", menuFrame)
autoSummitButton.Size = UDim2.new(0,120,0,40)
autoSummitButton.Position = UDim2.new(0,150,0,10)
autoSummitButton.Text = "Auto Summit"

-- Toggle menu
modButton.MouseButton1Click:Connect(function()
    menuFrame.Visible = not menuFrame.Visible
end)

-- Fly toggle
flyButton.MouseButton1Click:Connect(function()
    flying = not flying
end)

-- Wallhack toggle
wallhackButton.MouseButton1Click:Connect(function()
    wallhack = not wallhack
    for _, part in pairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = not wallhack
        end
    end
end)

-- Auto Summit instan
autoSummitButton.MouseButton1Click:Connect(function()
    if autoSummitActive then return end
    autoSummitActive = true

    -- Pastikan character siap
    character, humanoid, root = getCharacter()

    -- Teleport pos26
    root.CFrame = CFrame.new(pos26)
    task.wait(0.5) -- tunggu checkpoint

    -- Teleport puncak
    root.CFrame = CFrame.new(puncak)
    autoSummitActive = false
end)

-- Respawn handler
player.CharacterAdded:Connect(function(char)
    character, humanoid, root = getCharacter()
    bv.Parent = root
end)

-- RenderStepped loop untuk Fly
runService.RenderStepped:Connect(function(delta)
    if flying then
        local cam = workspace.CurrentCamera
        local direction = cam.CFrame.LookVector
        bv.Velocity = direction * 50 -- kecepatan bisa diubah
    else
        bv.Velocity = Vector3.new(0,0,0)
    end
end)
