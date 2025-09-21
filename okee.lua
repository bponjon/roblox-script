local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local root = character:WaitForChild("HumanoidRootPart")

-- Path pos 26 sampai puncak
local pos26 = Vector3.new(10,50,20)  -- ganti sesuai FINALATIN
local puncak = Vector3.new(100,200,150) -- ganti sesuai FINALATIN

local autoSummitActive = false

-- Fungsi Auto Summit
local function startAutoSummit()
    if autoSummitActive then return end
    autoSummitActive = true

    -- Langsung teleport ke pos 26
    root.CFrame = CFrame.new(pos26)
    task.wait(0.5) -- tunggu checkpoint pos 26

    -- Langsung teleport ke puncak
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
menuFrame.Size = UDim2.new(0,300,0,150)
menuFrame.Position = UDim2.new(0,10,0,70)
menuFrame.BackgroundColor3 = Color3.fromRGB(30,30,30)
menuFrame.BackgroundTransparency = 0.4
menuFrame.Visible = false

-- Buttons
local autoSummitButton = Instance.new("TextButton", menuFrame)
autoSummitButton.Size = UDim2.new(0,120,0,40)
autoSummitButton.Position = UDim2.new(0,10,0,10)
autoSummitButton.Text = "Auto Summit"
autoSummitButton.MouseButton1Click:Connect(startAutoSummit)

modButton.MouseButton1Click:Connect(function()
    menuFrame.Visible = not menuFrame.Visible
end)
