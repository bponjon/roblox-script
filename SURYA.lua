-- Mountbingung VFinal Loadstring
-- GUI + Manual Teleport + Auto Summit + Stop
-- Warna: Ungu Tua + Hitam

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local TweenService = game:GetService("TweenService")

-- Posisi CP
local checkpoints = {
    {name = "Basecamp", pos = Vector3.new(-16.8994255, 292.997986, -438.799927)},
    {name = "Checkpoint 1", pos = Vector3.new(18.6971245, 342.034637, -18.864109)},
    {name = "Checkpoint 2", pos = Vector3.new(129.73764, 402.06366, 5.28063631)},
    {name = "Checkpoint 3", pos = Vector3.new(135.903488, 357.782928, 266.350739)},
    {name = "Checkpoint 4", pos = Vector3.new(227.096115, 397.939697, 326.06488)},
    {name = "Checkpoint 5", pos = Vector3.new(861.573914, 370.61972, 79.1034851)},
    {name = "Puncak", pos = Vector3.new(1338.89172, 902.435425, -778.335144)}
}

-- GUI
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "MountbingungVFinal"

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 300, 0, 400)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(50,0,50) -- Ungu tua
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true

local UIListLayout = Instance.new("UIListLayout", MainFrame)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0,5)

-- Hide & Close Buttons
local HideButton = Instance.new("TextButton", MainFrame)
HideButton.Text = "Hide"
HideButton.Size = UDim2.new(0, 50, 0, 30)
HideButton.BackgroundColor3 = Color3.fromRGB(20,0,20)
HideButton.TextColor3 = Color3.fromRGB(255,255,255)

local CloseButton = Instance.new("TextButton", MainFrame)
CloseButton.Text = "Close"
CloseButton.Size = UDim2.new(0, 50, 0, 30)
CloseButton.BackgroundColor3 = Color3.fromRGB(20,0,20)
CloseButton.TextColor3 = Color3.fromRGB(255,255,255)

HideButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
end)

CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Scrollable list for teleport buttons
local ScrollingFrame = Instance.new("ScrollingFrame", MainFrame)
ScrollingFrame.Size = UDim2.new(1, -10, 1, -70)
ScrollingFrame.Position = UDim2.new(0,5,0,35)
ScrollingFrame.BackgroundTransparency = 1
ScrollingFrame.CanvasSize = UDim2.new(0,0,0,#checkpoints*40)
ScrollingFrame.ScrollBarThickness = 6

-- Manual teleport buttons
for i, cp in ipairs(checkpoints) do
    local btn = Instance.new("TextButton", ScrollingFrame)
    btn.Size = UDim2.new(1, -10, 0, 35)
    btn.Position = UDim2.new(0,5,0,(i-1)*40)
    btn.Text = cp.name
    btn.BackgroundColor3 = Color3.fromRGB(50,0,50)
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.MouseButton1Click:Connect(function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(cp.pos)
        end
    end)
end

-- Auto Summit
local AutoSummit = false
local AutoButton = Instance.new("TextButton", MainFrame)
AutoButton.Text = "Auto Summit"
AutoButton.Size = UDim2.new(0, 100, 0, 30)
AutoButton.BackgroundColor3 = Color3.fromRGB(50,0,50)
AutoButton.TextColor3 = Color3.fromRGB(255,255,255)
AutoButton.Position = UDim2.new(0,10,1,-35)

local StopButton = Instance.new("TextButton", MainFrame)
StopButton.Text = "Stop"
StopButton.Size = UDim2.new(0, 50, 0, 30)
StopButton.BackgroundColor3 = Color3.fromRGB(50,0,50)
StopButton.TextColor3 = Color3.fromRGB(255,255,255)
StopButton.Position = UDim2.new(0,120,1,-35)

AutoButton.MouseButton1Click:Connect(function()
    AutoSummit = true
end)

StopButton.MouseButton1Click:Connect(function()
    AutoSummit = false
end)

-- Auto Summit Loop
spawn(function()
    while true do
        wait(0.1)
        if AutoSummit and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            for i, cp in ipairs(checkpoints) do
                if not AutoSummit then break end
                LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(cp.pos)
                wait(4)
                -- Jika sampai Puncak
                if i == #checkpoints then
                    wait(10)
                    if AutoSummit then
                        -- Matikan karakter
                        if LocalPlayer.Character:FindFirstChild("Humanoid") then
                            LocalPlayer.Character.Humanoid.Health = 0
                        end
                        wait(1)
                    end
                end
            end
        end
    end
end)
