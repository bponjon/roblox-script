-- ==== Fully Integrated FINALATIN + Mod Menu Fly/Wallhack/Teleport Pos ====
-- Pastikan FINALATINPath dari script FINALATIN asli sudah terdefinisi

local player = game.Players.LocalPlayer
local runService = game:GetService("RunService")
local uis = game:GetService("UserInputService")

-- Karakter
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local root = character:WaitForChild("HumanoidRootPart")

-- States
local flying = false
local wallhack = false

-- Fly BodyVelocity
local bv = Instance.new("BodyVelocity")
bv.MaxForce = Vector3.new(1e5,1e5,1e5)
bv.Velocity = Vector3.new(0,0,0)
bv.Parent = root

-- GUI
local screenGui = Instance.new("ScreenGui", player.PlayerGui)
screenGui.ResetOnSpawn = false

local modButton = Instance.new("TextButton", screenGui)
modButton.Size = UDim2.new(0,100,0,50)
modButton.Position = UDim2.new(0,10,0,10)
modButton.Text = "Mod Menu"

local menuFrame = Instance.new("Frame", screenGui)
menuFrame.Size = UDim2.new(0,300,0,400)
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

-- Pos buttons (pos1 → puncak)
local posButtons = {}
for i, pos in ipairs(FINALATINPath) do
    local btn = Instance.new("TextButton", menuFrame)
    btn.Size = UDim2.new(0,120,0,30)
    btn.Position = UDim2.new(0,10,0,100 + (i-1)*35)
    btn.Text = "Pos "..i
    btn.MouseButton1Click:Connect(function()
        root.CFrame = CFrame.new(pos)
    end)
    table.insert(posButtons, btn)
end

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

-- Respawn handler
player.CharacterAdded:Connect(function(char)
    character = char
    humanoid = character:WaitForChild("Humanoid")
    root = character:WaitForChild("HumanoidRootPart")
    bv.Parent = root
end)

-- Fly movement
runService.RenderStepped:Connect(function(delta)
    if flying then
        local cam = workspace.CurrentCamera
        local direction = cam.CFrame.LookVector
        bv.Velocity = direction * 50
    else
        bv.Velocity = Vector3.new(0,0,0)
    end
end)

-- ==== Efek visual kaki (trail/particle ungu) bisa ditambahkan di sini ====
