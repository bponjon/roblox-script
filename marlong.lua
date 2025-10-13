-- MountYahayuk KW
-- GUI Setup
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

-- Checkpoints (contoh, ganti sesuai map)
local checkpoints = {
    {name="Basecamp", pos=CFrame.new(-16.8994,292.998,-438.800)},
    {name="CP1", pos=CFrame.new(18.6971,342.035,-18.8641)},
    {name="CP2", pos=CFrame.new(129.738,402.064,5.2806)},
    {name="CP3", pos=CFrame.new(135.903,357.783,266.351)},
    {name="CP4", pos=CFrame.new(227.096,397.940,326.065)},
    {name="CP5", pos=CFrame.new(861.574,370.620,79.103)},
    {name="Puncak", pos=CFrame.new(1338.892,902.435,-778.335)}
}

-- GUI
local screenGui = Instance.new("ScreenGui", PlayerGui)
screenGui.Name = "MountYahayukGUI"

local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0,250,0,300)
frame.Position = UDim2.new(0,50,0,50)
frame.BackgroundColor3 = Color3.fromRGB(64,0,64) -- ungu tua
frame.BorderSizePixel = 0

-- Title
local title = Instance.new("TextLabel", frame)
title.Text = "MountYahayuk KW"
title.Size = UDim2.new(1,0,0,30)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(255,255,255)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 20

-- Close Button
local closeBtn = Instance.new("TextButton", frame)
closeBtn.Text = "X"
closeBtn.Size = UDim2.new(0,30,0,30)
closeBtn.Position = UDim2.new(1,-30,0,0)
closeBtn.BackgroundColor3 = Color3.fromRGB(255,0,0)
closeBtn.TextColor3 = Color3.fromRGB(255,255,255)
closeBtn.MouseButton1Click:Connect(function()
    screenGui.Enabled = false
end)

-- Hide Button
local hideBtn = Instance.new("TextButton", frame)
hideBtn.Text = "_"
hideBtn.Size = UDim2.new(0,30,0,30)
hideBtn.Position = UDim2.new(1,-60,0,0)
hideBtn.BackgroundColor3 = Color3.fromRGB(0,0,0)
hideBtn.TextColor3 = Color3.fromRGB(255,255,255)
local logo
hideBtn.MouseButton1Click:Connect(function()
    screenGui.Enabled = false
    if not logo then
        logo = Instance.new("ImageButton", PlayerGui)
        logo.Size = UDim2.new(0,50,0,50)
        logo.Position = UDim2.new(0,10,0,10)
        logo.Image = "rbxassetid://YOUR_LOGO_ID"
        logo.BackgroundTransparency = 0.5
        logo.Draggable = true
        logo.MouseButton1Click:Connect(function()
            screenGui.Enabled = true
            logo:Destroy()
            logo = nil
        end)
    end
end)

-- Auto Summit & Stop
local autoBtn = Instance.new("TextButton", frame)
autoBtn.Text = "Auto Summit"
autoBtn.Size = UDim2.new(1, -20, 0, 40)
autoBtn.Position = UDim2.new(0,10,0,50)
autoBtn.BackgroundColor3 = Color3.fromRGB(128,0,128)
local stopBtn = Instance.new("TextButton", frame)
stopBtn.Text = "Stop"
stopBtn.Size = UDim2.new(1, -20, 0, 40)
stopBtn.Position = UDim2.new(0,10,0,100)
stopBtn.BackgroundColor3 = Color3.fromRGB(128,0,0)

local autoActive = false

autoBtn.MouseButton1Click:Connect(function()
    if autoActive then return end
    autoActive = true
    spawn(function()
        while autoActive do
            for i, cp in ipairs(checkpoints) do
                -- teleport bertahap
                player.Character.HumanoidRootPart.CFrame = cp.pos
                wait(4) -- delay tiap checkpoint
                -- cek Puncak
                if cp.name == "Puncak" then
                    wait(10)
                    if autoActive then
                        player.Character.Humanoid.Health = 0
                    end
                end
            end
        end
    end)
end)

stopBtn.MouseButton1Click:Connect(function()
    autoActive = false
end)

-- Drag Frame
local dragging = false
local dragInput, mousePos, framePos

frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        mousePos = input.Position
        framePos = frame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

frame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

RunService.RenderStepped:Connect(function()
    if dragging and dragInput then
        local delta = dragInput.Position - mousePos
        frame.Position = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X, framePos.Y.Scale, framePos.Y.Offset + delta.Y)
    end
end)
