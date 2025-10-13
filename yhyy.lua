-- Final Yahayuk KW
-- GUI + Auto Summit + Manual Teleport
-- Warna: Ungu tua + Hitam

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local humanoid = char:WaitForChild("Humanoid")

-- Checkpoints
local Checkpoints = {
    {Name="Basecamp", CFrame=CFrame.new(-16.8994255,292.997986,-438.799927)},
    {Name="CP1", CFrame=CFrame.new(18.6971245,342.034637,-18.864109)},
    {Name="CP2", CFrame=CFrame.new(129.73764,402.06366,5.28063631)},
    {Name="CP3", CFrame=CFrame.new(135.903488,357.782928,266.350739)},
    {Name="CP4", CFrame=CFrame.new(227.096115,397.939697,326.06488)},
    {Name="CP5", CFrame=CFrame.new(861.573914,370.61972,79.1034851)},
    {Name="Puncak", CFrame=CFrame.new(1337.34399,905.997986,-803.872925)}
}

-- GUI Setup
local ScreenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0,300,0,400)
Frame.Position = UDim2.new(0.5,-150,0.2,0)
Frame.BackgroundColor3 = Color3.fromRGB(60,0,60) -- Ungu tua
Frame.Active = true
Frame.Draggable = true

local UIListLayout = Instance.new("UIListLayout", Frame)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0,5)

-- Auto Summit Control
local AutoSummitActive = false
local AutoSummitStop = false

local function tweenTo(pos)
    if humanoid.Health <= 0 then return end
    local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Linear)
    local goal = {CFrame=pos}
    local tween = TweenService:Create(hrp, tweenInfo, goal)
    tween:Play()
    tween.Completed:Wait()
end

local function AutoSummit()
    AutoSummitStop = false
    AutoSummitActive = true
    for i,cp in ipairs(Checkpoints) do
        if AutoSummitStop then break end
        tweenTo(cp.CFrame)
        wait(4) -- Delay 4 detik tiap CP
        if cp.Name == "Puncak" then
            wait(10) -- Delay 10 detik di Puncak
            humanoid.Health = 0 -- Mati otomatis
            wait(1) -- Tunggu respawn
            char = player.Character or player.CharacterAdded:Wait()
            hrp = char:WaitForChild("HumanoidRootPart")
            humanoid = char:WaitForChild("Humanoid")
        end
    end
    AutoSummitActive = false
end

-- GUI Buttons
for i,cp in ipairs(Checkpoints) do
    local btn = Instance.new("TextButton", Frame)
    btn.Size = UDim2.new(1,0,0,30)
    btn.Text = cp.Name
    btn.BackgroundColor3 = Color3.fromRGB(20,0,20)
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.MouseButton1Click:Connect(function()
        tweenTo(cp.CFrame)
    end)
end

-- Auto Summit Button
local autoBtn = Instance.new("TextButton", Frame)
autoBtn.Size = UDim2.new(1,0,0,30)
autoBtn.Text = "Auto Summit"
autoBtn.BackgroundColor3 = Color3.fromRGB(20,0,20)
autoBtn.TextColor3 = Color3.fromRGB(255,255,255)
autoBtn.MouseButton1Click:Connect(function()
    if not AutoSummitActive then
        spawn(AutoSummit)
    end
end)

-- Stop Button
local stopBtn = Instance.new("TextButton", Frame)
stopBtn.Size = UDim2.new(1,0,0,30)
stopBtn.Text = "Stop"
stopBtn.BackgroundColor3 = Color3.fromRGB(120,0,0)
stopBtn.TextColor3 = Color3.fromRGB(255,255,255)
stopBtn.MouseButton1Click:Connect(function()
    AutoSummitStop = true
end)

-- Hide Button
local hideBtn = Instance.new("TextButton", Frame)
hideBtn.Size = UDim2.new(0,30,0,30)
hideBtn.Position = UDim2.new(1,-35,0,5)
hideBtn.Text = "X"
hideBtn.BackgroundColor3 = Color3.fromRGB(0,0,0)
hideBtn.TextColor3 = Color3.fromRGB(255,0,255)
hideBtn.MouseButton1Click:Connect(function()
    Frame.Visible = false
    -- Bisa ditambah logo muncul lagi
end)
