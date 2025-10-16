-- ===== MountBingung AutoSummit vFinal (Updated Checkpoints) =====
local player = game.Players.LocalPlayer

-- ===== Checkpoints (Baru) =====
local checkpoints = {
    {name="Checkpoint 1", pos=CFrame.new(24.996, 163.296, 319.838, -0.997991, 0.024712, -0.058331, -0.000000, 0.920780, 0.390083, 0.063350, 0.389299, -0.918930)},
    {name="Checkpoint 2", pos=CFrame.new(-830.715, 239.184, 887.750, -0.972382, -0.073546, 0.221503, -0.000009, 0.949065, 0.315080, -0.233393, 0.306376, -0.922855)},
    {name="Checkpoint 3", pos=CFrame.new(-1081.016, 400.153, 1662.579, -0.685627, 0.345798, -0.640578, 0.000000, 0.879971, 0.475027, 0.727953, 0.325691, -0.603332)},
    {name="Checkpoint 4", pos=CFrame.new(-638.603, 659.233, 3034.486, -0.840349, 0.156491, -0.518964, -0.000000, 0.957418, 0.288705, 0.542045, 0.242613, -0.804566)},
    {name="Checkpoint 5", pos=CFrame.new(339.759, 820.852, 3891.180, 0.120165, 0.220135, -0.968040, -0.000000, 0.975105, 0.221742, 0.992754, -0.026646, 0.117173)},
    {name="Puncak", pos=CFrame.new(878.573, 1019.189, 4704.508, 0.005409, 0.375075, -0.926979, 0.000348, 0.926992, 0.375082, 0.999985, -0.002352, 0.004884)}
}

-- ===== GUI Setup =====
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "MountBingungModMenu"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,280,0,400)
frame.Position = UDim2.new(0.05,0,0.1,0)
frame.BackgroundColor3 = Color3.fromRGB(50,0,50)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

local closeBtn = Instance.new("TextButton", frame)
closeBtn.Text = "X"
closeBtn.Size = UDim2.new(0,30,0,30)
closeBtn.Position = UDim2.new(1,-35,0,5)
closeBtn.BackgroundColor3 = Color3.fromRGB(150,0,0)
closeBtn.TextColor3 = Color3.new(1,1,1)
closeBtn.MouseButton1Click:Connect(function() gui.Enabled = false end)

local hideBtn = Instance.new("TextButton", frame)
hideBtn.Text = "Hide"
hideBtn.Size = UDim2.new(0,60,0,30)
hideBtn.Position = UDim2.new(0,5,0,5)
hideBtn.BackgroundColor3 = Color3.fromRGB(0,0,0)
hideBtn.TextColor3 = Color3.new(1,1,1)

local logo = Instance.new("ImageButton", gui)
logo.Size = UDim2.new(0,50,0,50)
logo.Position = UDim2.new(0.9,0,0.1,0)
logo.Image = "rbxassetid://YOUR_DRAGON_IMAGE_ID" -- ganti sesuai id logo lo
logo.Visible = false
logo.Active = true
logo.Draggable = true

hideBtn.MouseButton1Click:Connect(function()
    frame.Visible = false
    logo.Visible = true
end)
logo.MouseButton1Click:Connect(function()
    frame.Visible = true
    logo.Visible = false
end)

-- ===== ScrollFrame =====
local scrollFrame = Instance.new("ScrollingFrame", frame)
scrollFrame.Size = UDim2.new(1,0,1,-110)
scrollFrame.Position = UDim2.new(0,0,0,40)
scrollFrame.BackgroundTransparency = 1
scrollFrame.CanvasSize = UDim2.new(0,0,0,1000)
scrollFrame.ScrollBarThickness = 10

local uiList = Instance.new("UIListLayout", scrollFrame)
uiList.SortOrder = Enum.SortOrder.LayoutOrder
uiList.Padding = UDim.new(0,5)

for i, cp in ipairs(checkpoints) do
    local btn = Instance.new("TextButton", scrollFrame)
    btn.Text = cp.name
    btn.Size = UDim2.new(1,0,0,30)
    btn.BackgroundColor3 = Color3.fromRGB(30,0,30)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.LayoutOrder = i
    btn.MouseButton1Click:Connect(function()
        if player.Character and player.Character.PrimaryPart then
            player.Character:PivotTo(cp.pos)
        end
    end)
end

uiList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    scrollFrame.CanvasSize = UDim2.new(0,0,0,uiList.AbsoluteContentSize.Y)
end)

-- ===== AutoSummit =====
local autoBtn = Instance.new("TextButton", frame)
autoBtn.Text = "AutoSummit"
autoBtn.Size = UDim2.new(0.5,-5,0,30)
autoBtn.Position = UDim2.new(0,0,1,-50)
autoBtn.BackgroundColor3 = Color3.fromRGB(50,0,50)
autoBtn.TextColor3 = Color3.new(1,1,1)

local stopBtn = Instance.new("TextButton", frame)
stopBtn.Text = "Stop"
stopBtn.Size = UDim2.new(0.5,-5,0,30)
stopBtn.Position = UDim2.new(0.5,5,1,-50)
stopBtn.BackgroundColor3 = Color3.fromRGB(100,0,0)
stopBtn.TextColor3 = Color3.new(1,1,1)

local autoSummitActive = false

local function startAutoSummit()
    if autoSummitActive then return end
    autoSummitActive = true

    task.spawn(function()
        while autoSummitActive do
            for _, cp in ipairs(checkpoints) do
                if not autoSummitActive then break end
                local character = player.Character
                if character and character.PrimaryPart then
                    character:PivotTo(cp.pos)
                end
                task.wait(4)
                if cp.name == "Puncak" then
                    task.wait(10)
                    if character then
                        character:BreakJoints()
                    end
                    break
                end
            end
            player.CharacterAdded:Wait()
        end
    end)
end

autoBtn.MouseButton1Click:Connect(startAutoSummit)
stopBtn.MouseButton1Click:Connect(function()
    autoSummitActive = false
end)
