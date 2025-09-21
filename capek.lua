local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local root = character:WaitForChild("HumanoidRootPart")
local runService = game:GetService("RunService")

-- Ambil path FINALATIN pos 26 sampai puncak (contoh hardcode, bisa diganti ambil dari FINALATIN)
local pathPoints = {
    Vector3.new(10,50,20), -- pos26
    Vector3.new(15,55,25),
    Vector3.new(20,60,30),
    Vector3.new(25,65,35), -- dst sampai puncak
}

local autoSummitActive = false
local flying = false
local wallhack = false

-- Fungsi Auto Summit
local function moveToPath()
    for i, pos in ipairs(pathPoints) do
        if not autoSummitActive then break end
        humanoid:MoveTo(pos)
        humanoid.MoveToFinished:Wait()
        task.wait(0.2)
    end
end

local function startAutoSummit()
    if autoSummitActive then return end
    autoSummitActive = true
    task.spawn(moveToPath)
end

local function stopAutoSummit()
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

-- Toggle menu
modButton.MouseButton1Click:Connect(function()
    menuFrame.Visible = not menuFrame.Visible
end)

-- Toggle Fly
flyButton.MouseButton1Click:Connect(function()
    flying = not flying
    print("Fly toggled:", flying)
    -- implementasi bodyVelocity & animasi bisa ditambah dari coba13.lua
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

-- Toggle Auto Summit
autoSummitButton.MouseButton1Click:Connect(function()
    if autoSummitActive then
        stopAutoSummit()
    else
        startAutoSummit()
    end
end)
