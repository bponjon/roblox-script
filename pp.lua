-- ==== Masukkan seluruh script FINALATIN asli di sini ====

-- Contoh: tinggal paste semua script FINALATIN asli, jangan diubah
-- Auto Summit, path, checkpoint, animasi, teleport semua tetap original

-- ==== Tambahan Mod Menu Fly + Wallhack ====
local player = game.Players.LocalPlayer
local runService = game:GetService("RunService")

local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local root = character:WaitForChild("HumanoidRootPart")

local flying = false
local wallhack = false

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
menuFrame.Size = UDim2.new(0,200,0,150)
menuFrame.Position = UDim2.new(0,10,0,70)
menuFrame.BackgroundColor3 = Color3.fromRGB(30,30,30)
menuFrame.BackgroundTransparency = 0.4
menuFrame.Visible = false

local flyButton = Instance.new("TextButton", menuFrame)
flyButton.Size = UDim2.new(0,100,0,40)
flyButton.Position = UDim2.new(0,10,0,10)
flyButton.Text = "Fly"

local wallhackButton = Instance.new("TextButton", menuFrame)
wallhackButton.Size = UDim2.new(0,100,0,40)
wallhackButton.Position = UDim2.new(0,10,0,60)
wallhackButton.Text = "Wallhack"

modButton.MouseButton1Click:Connect(function()
    menuFrame.Visible = not menuFrame.Visible
end)

flyButton.MouseButton1Click:Connect(function()
    flying = not flying
end)

wallhackButton.MouseButton1Click:Connect(function()
    wallhack = not wallhack
    for _, part in pairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = not wallhack
        end
    end
end)

player.CharacterAdded:Connect(function(char)
    character = char
    humanoid = character:WaitForChild("Humanoid")
    root = character:WaitForChild("HumanoidRootPart")
    bv.Parent = root
end)

-- Fly movement loop
runService.RenderStepped:Connect(function(delta)
    if flying then
        local cam = workspace.CurrentCamera
        local direction = cam.CFrame.LookVector
        bv.Velocity = direction * 50 -- kecepatan bisa disesuaikan
    else
        bv.Velocity = Vector3.new(0,0,0)
    end
end)
