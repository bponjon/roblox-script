-- Yahyuk Teleport GUI
-- by lu sendiri 😎

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hum = char:WaitForChild("HumanoidRootPart")

-- daftar posisi checkpoint
local checkpoints = {
    basecamp = CFrame.new(-953.328, 171.144, 881.428, 0.552187, 0.370696, -0.746775, 0.000000, 0.895715, 0.444629, 0.833720, -0.245519, 0.494602),
    cp1 = CFrame.new(-417.413, 248.723, 786.200, 0.684616, -0.404214, 0.606558, 0.000000, 0.832151, 0.554550, -0.728904, -0.379654, 0.569704),
    cp2 = CFrame.new(-328.026, 388.645, 528.597, 0.317166, 0.364875, -0.875370, 0.000000, 0.923025, 0.384739, 0.948370, -0.122026, 0.292753),
    cp3 = CFrame.new(293.615, 431.350, 494.099, 0.161014, 0.417901, -0.894110, 0.000000, 0.905931, 0.423426, 0.986952, -0.068177, 0.145867),
    cp4 = CFrame.new(324.074, 487.911, 363.436, 0.999615, 0.006939, -0.026857, 0.000000, 0.968204, 0.250163, 0.027739, -0.250067, 0.967831),
    cp5 = CFrame.new(232.235, 315.224, -143.314, 0.851438, -0.115206, 0.511645, -0.000000, 0.975575, 0.219668, -0.524455, -0.187034, 0.830641),
    puncak = CFrame.new(-622.600, 911.505, -493.331, 0.300955, 0.487357, -0.819701, 0.000000, 0.859551, 0.511050, 0.953638, -0.153803, 0.258686)
}

-- buat GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "YahyukTeleportGui"
ScreenGui.Parent = game.CoreGui

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 240, 0, 320)
Frame.Position = UDim2.new(0.02, 0, 0.3, 0)
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Frame.BackgroundTransparency = 0.2
Frame.Parent = ScreenGui

local title = Instance.new("TextLabel")
title.Text = "🌋 Yahyuk Teleport"
title.Size = UDim2.new(1, 0, 0, 35)
title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.Parent = Frame

-- fungsi teleport
local function teleportTo(cf)
    hum.CFrame = cf
end

-- tombol manual tiap cp
local yPos = 40
for name, cf in pairs(checkpoints) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 30)
    btn.Position = UDim2.new(0, 5, 0, yPos)
    btn.Text = "Teleport ke " .. name
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    btn.MouseButton1Click:Connect(function()
        teleportTo(cf)
    end)
    btn.Parent = Frame
    yPos += 35
end

-- tombol auto
local auto = Instance.new("TextButton")
auto.Size = UDim2.new(1, -10, 0, 40)
auto.Position = UDim2.new(0, 5, 0, yPos + 10)
auto.Text = "🚀 Auto Yahyuk"
auto.BackgroundColor3 = Color3.fromRGB(90, 60, 120)
auto.TextColor3 = Color3.fromRGB(255, 255, 255)
auto.Font = Enum.Font.GothamBold
auto.TextSize = 16
auto.Parent = Frame

auto.MouseButton1Click:Connect(function()
    for i, cf in pairs(checkpoints) do
        teleportTo(cf)
        game.StarterGui:SetCore("SendNotification", {
            Title = "Yahyuk Teleport",
            Text = "Pindah ke " .. tostring(i),
            Duration = 3
        })
        wait(20)
    end
    game.StarterGui:SetCore("SendNotification", {
        Title = "Yahyuk Teleport",
        Text = "Sampai di Puncak!",
        Duration = 5
    })
end)
