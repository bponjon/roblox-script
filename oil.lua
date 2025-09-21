-- ==== Paste seluruh script FINALATIN asli di sini ====
-- Auto Summit, path pos1 → puncak, teleport, checkpoint, animasi asli tetap utuh

-- ==== Tambahan Mod Menu Fly + Wallhack + Auto Summit manual ====
local player = game.Players.LocalPlayer
local runService = game:GetService("RunService")
local uis = game:GetService("UserInputService")

local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local root = character:WaitForChild("HumanoidRootPart")

-- States
local flying = false
local wallhack = false
local autoSummitManual = false

-- BodyVelocity untuk Fly
local bv = Instance.new("BodyVelocity")
bv.MaxForce = Vector3.new(1e5,1e5,1e5)
bv.Velocity = Vector3.new(0,0,0)
bv.Parent = root

-- Mod Menu GUI persis FINALATIN
local screenGui = Instance.new("ScreenGui", player.PlayerGui)
screenGui.ResetOnSpawn = false

local modButton = Instance.new("TextButton", screenGui)
modButton.Size = UDim2.new(0,100,0,50)
modButton.Position = UDim2.new(0,10,0,10)
modButton.Text = "Mod Menu"

local menuFrame = Instance.new("Frame", screenGui)
menuFrame.Size = UDim2.new(0,250,0,200)
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

-- Auto Summit manual (pos26 → puncak, sesuai permintaan)
autoSummitButton.MouseButton1Click:Connect(function()
    if autoSummitManual then return end
    autoSummitManual = true

    character = player.Character or player.CharacterAdded:Wait()
    humanoid = character:WaitForChild("Humanoid")
    root = character:WaitForChild("HumanoidRootPart")

    -- Loop path FINALATIN pos26 → puncak
    for i, pos in ipairs(FINALATINPathManual) do
        root.CFrame = CFrame.new(pos)
        task.wait(0.5) -- tunggu checkpoint
    end

    autoSummitManual = false
end)

-- Respawn handler
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
        bv.Velocity = direction * 50 -- bisa disesuaikan kecepatan
    else
        bv.Velocity = Vector3.new(0,0,0)
    end
end)

-- ==== Efek visual kaki (trail/particle) bisa ditambahkan di sini ====
