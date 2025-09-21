local player = game.Players.LocalPlayer
local runService = game:GetService("RunService")
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local root = character:WaitForChild("HumanoidRootPart")

-- Data FINALATIN asli
-- Ambil posisi pos 26 sampai puncak dari FINALATIN script
local pos26 = Vector3.new(10,50,20)  -- ganti dengan data FINALATIN asli
local puncak = Vector3.new(100,200,150) -- ganti dengan data FINALATIN asli

local autoSummitActive = false
local flying = false
local wallhack = false

-- Fungsi teleport instan Auto Summit
local function startAutoSummit()
    if autoSummitActive then return end
    autoSummitActive = true

    -- Pastikan karakter sudah spawn / respawn
    if not character.Parent then
        character = player.Character or player.CharacterAdded:Wait()
        humanoid = character:WaitForChild("Humanoid")
        root = character:WaitForChild("HumanoidRootPart")
    end

    -- Teleport instan ke pos 26
    root.CFrame = CFrame.new(pos26)
    task.wait(0.5) -- tunggu checkpoint deteksi

    -- Teleport instan ke puncak
    root.CFrame = CFrame.new(puncak)

    autoSummitActive = false
end

-- GUI Mod Menu
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
autoSummitButton.MouseButton1Click:Connect(startAutoSummit)

-- Toggle menu
modButton.MouseButton1Click:Connect(function()
    menuFrame.Visible = not menuFrame.Visible
end)

-- Toggle Fly
flyButton.MouseButton1Click:Connect(function()
    flying = not flying
    print("Fly toggled:", flying)
    -- implementasi bodyVelocity & animasi humanoid dari script coba13.lua bisa ditambah di sini
end)

-- Toggle Wallhack
wallhackButton.MouseButton1Click:Connect(function()
    wallhack = not wallhack
    for _, part in pairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = not wallhack
        end
    end
end)

-- Respawn handler → Auto Summit bisa dipakai lagi
player.CharacterAdded:Connect(function(char)
    character = char
    humanoid = char:WaitForChild("Humanoid")
    root = char:WaitForChild("HumanoidRootPart")
end)
