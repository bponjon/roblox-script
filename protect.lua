-- Anti Exploit Protection Mod Menu (Mobile Friendly)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- GUI Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 150, 0, 100)
Frame.Position = UDim2.new(0, 20, 0, 200)
Frame.BackgroundTransparency = 0.3
Frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Frame.Parent = ScreenGui

-- Tombol Proteksi
local ProtectBtn = Instance.new("TextButton")
ProtectBtn.Size = UDim2.new(1, -20, 0, 40)
ProtectBtn.Position = UDim2.new(0, 10, 0, 10)
ProtectBtn.Font = Enum.Font.SourceSansBold
ProtectBtn.TextSize = 18
ProtectBtn.TextColor3 = Color3.new(1,1,1)
ProtectBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0) -- Merah default (OFF)
ProtectBtn.Text = "Protect: OFF"
ProtectBtn.Parent = Frame

-- Tombol Repair
local RepairBtn = Instance.new("TextButton")
RepairBtn.Size = UDim2.new(1, -20, 0, 40)
RepairBtn.Position = UDim2.new(0, 10, 0, 55)
RepairBtn.Font = Enum.Font.SourceSansBold
RepairBtn.TextSize = 18
RepairBtn.TextColor3 = Color3.new(1,1,1)
RepairBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 200)
RepairBtn.Text = "Repair Now"
RepairBtn.Parent = Frame

-- Logic Proteksi
local safeCFrame = nil
local isProtected = false

ProtectBtn.MouseButton1Click:Connect(function()
    isProtected = not isProtected
    if isProtected then
        ProtectBtn.Text = "Protect: ON"
        ProtectBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0) -- Hijau
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            safeCFrame = LocalPlayer.Character.HumanoidRootPart.CFrame
        end
    else
        ProtectBtn.Text = "Protect: OFF"
        ProtectBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0) -- Merah
    end
end)

RepairBtn.MouseButton1Click:Connect(function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        char.HumanoidRootPart.CFrame = safeCFrame or CFrame.new(0, 10, 0)
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Anchored = false
            end
        end
        if char:FindFirstChild("Humanoid") then
            char.Humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
        end
    end
end)

RunService.Stepped:Connect(function()
    if isProtected and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = LocalPlayer.Character.HumanoidRootPart
        if safeCFrame and (hrp.Position - safeCFrame.Position).Magnitude > 25 then
            hrp.CFrame = safeCFrame
        else
            safeCFrame = hrp.CFrame
        end
    end
end)
