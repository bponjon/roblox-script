-- MountBingung Final v6
local player = game.Players.LocalPlayer

-- ===== 1. Checkpoints =====
local checkpoints = {
    {name="Basecamp", pos=Vector3.new(166.00293,14.9578,822.9834)},
    -- Tambahkan checkpoint lainnya sesuai urutan
    {name="Puncak", pos=Vector3.new(107.1410,988.2626,-9015.2315)}
}

-- ===== 2. GUI Setup =====
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "MountBingungModMenu"

-- Main Frame
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,280,0,400)
frame.Position = UDim2.new(0.05,0,0.1,0)
frame.BackgroundColor3 = Color3.fromRGB(70,0,70) -- Ungu tua
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

-- AutoSummit + Stop Buttons
local autoBtn = Instance.new("TextButton", frame)
autoBtn.Text = "AutoSummit"
autoBtn.Size = UDim2.new(0.5, -5,0,30)
autoBtn.Position = UDim2.new(0,0,0,5)
autoBtn.BackgroundColor3 = Color3.fromRGB(50,0,50)
autoBtn.TextColor3 = Color3.fromRGB(255,255,255)

local stopBtn = Instance.new("TextButton", frame)
stopBtn.Text = "Stop"
stopBtn.Size = UDim2.new(0.5, -5,0,30)
stopBtn.Position = UDim2.new(0.5,5,0,5)
stopBtn.BackgroundColor3 = Color3.fromRGB(100,0,0)
stopBtn.TextColor3 = Color3.fromRGB(255,255,255)

-- ScrollingFrame for checkpoints
local scrollFrame = Instance.new("ScrollingFrame", frame)
scrollFrame.Size = UDim2.new(1,0,1,-40-35)
scrollFrame.Position = UDim2.new(0,0,0,40)
scrollFrame.BackgroundTransparency = 1
scrollFrame.CanvasSize = UDim2.new(0,0,0,1000)
scrollFrame.ScrollBarThickness = 10

local uiList = Instance.new("UIListLayout", scrollFrame)
uiList.SortOrder = Enum.SortOrder.LayoutOrder
uiList.Padding = UDim.new(0,5)

-- Close Button
local closeBtn = Instance.new("TextButton", frame)
closeBtn.Text = "X"
closeBtn.Size = UDim2.new(0,30,0,30)
closeBtn.Position = UDim2.new(1,-35,0,5)
closeBtn.BackgroundColor3 = Color3.fromRGB(150,0,0)
closeBtn.TextColor3 = Color3.fromRGB(255,255,255)
closeBtn.MouseButton1Click:Connect(function()
    gui.Enabled = false
end)

-- Hide Button
local hideBtn = Instance.new("TextButton", frame)
hideBtn.Text = "Hide"
hideBtn.Size = UDim2.new(0,60,0,30)
hideBtn.Position = UDim2.new(0,5,0,5)
hideBtn.BackgroundColor3 = Color3.fromRGB(30,0,30)
hideBtn.TextColor3 = Color3.fromRGB(255,255,255)

-- Logo (muncul pas hide)
local logo = Instance.new("ImageButton", gui)
logo.Size = UDim2.new(0,50,0,50)
logo.Position = UDim2.new(0.9,0,0.1,0)
logo.Image = "rbxassetid://YOUR_DRAGON_IMAGE_ID" -- ganti nanti
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

-- ===== 3. Manual Teleport Buttons =====
for i = 1, #checkpoints do
    local cp = checkpoints[i]
    local btn = Instance.new("TextButton", scrollFrame)
    btn.Text = cp.name
    btn.Size = UDim2.new(1,0,0,30)
    btn.BackgroundColor3 = Color3.fromRGB(90,0,90)
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.LayoutOrder = i
    btn.MouseButton1Click:Connect(function()
        if player.Character and player.Character.PrimaryPart then
            player.Character:SetPrimaryPartCFrame(CFrame.new(cp.pos))
        end
    end)
end

-- ===== 4. AutoSummit Functionality =====
local autoSummitActive = false
autoBtn.MouseButton1Click:Connect(function()
    autoSummitActive = true
    for i = 1,#checkpoints do
        if not autoSummitActive then break end
        local cp = checkpoints[i]
        if player.Character and player.Character.PrimaryPart then
            player.Character:SetPrimaryPartCFrame(CFrame.new(cp.pos))
        end
        wait(7) -- timer tiap checkpoint
    end
    autoSummitActive = false
end)

stopBtn.MouseButton1Click:Connect(function()
    autoSummitActive = false
end)

-- ===== 5. CanvasSize Auto =====
uiList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    scrollFrame.CanvasSize = UDim2.new(0,0,0,uiList.AbsoluteContentSize.Y)
end)
