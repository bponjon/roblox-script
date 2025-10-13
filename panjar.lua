-- MountBingung Final v8
local player = game.Players.LocalPlayer

-- ===== 1. Checkpoints Lengkap =====
local checkpoints = {
    {name="Basecamp", pos=Vector3.new(166.00293,14.9578,822.9834)},
    {name="Checkpoint 1", pos=Vector3.new(198.238098,10.1375217,128.423187)},
    {name="Checkpoint 2", pos=Vector3.new(228.194977,128.879974,-211.192383)},
    {name="Checkpoint 3", pos=Vector3.new(231.817947,146.768204,-558.723816)},
    {name="Checkpoint 4", pos=Vector3.new(340.004669,132.319489,-987.244446)},
    {name="Checkpoint 5", pos=Vector3.new(393.582062,119.624352,-1415.08472)},
    {name="Checkpoint 6", pos=Vector3.new(344.682739,190.306702,-2695.90625)},
    {name="Checkpoint 7", pos=Vector3.new(353.37085,243.564514,-3065.35181)},
    {name="Checkpoint 8", pos=Vector3.new(-1.62862873,259.373474,-3431.15869)},
    {name="Checkpoint 9", pos=Vector3.new(54.7402382,373.025543,-3835.73633)},
    {name="Checkpoint 10", pos=Vector3.new(-347.480225,505.230347,-4970.26514)},
    {name="Checkpoint 11", pos=Vector3.new(-841.818359,506.035736,-4984.36621)},
    {name="Checkpoint 12", pos=Vector3.new(-825.191345,571.779053,-5727.79297)},
    {name="Checkpoint 13", pos=Vector3.new(-831.682068,575.300842,-6424.26855)},
    {name="Checkpoint 14", pos=Vector3.new(-288.520508,661.583984,-6804.15234)},
    {name="Checkpoint 15", pos=Vector3.new(675.513794,743.510742,-7249.33496)},
    {name="Checkpoint 16", pos=Vector3.new(816.311768,833.685852,-7606.22998)},
    {name="Checkpoint 17", pos=Vector3.new(805.29248,821.01062,-8516.9082)},
    {name="Checkpoint 18", pos=Vector3.new(473.562775,879.063538,-8585.45312)},
    {name="Checkpoint 19", pos=Vector3.new(268.831238,897.108215,-8576.44922)},
    {name="Checkpoint 20", pos=Vector3.new(285.314331,933.954651,-8983.91992)},
    {name="Puncak", pos=Vector3.new(107.141029,988.262573,-9015.23145)}
}

-- ===== 2. GUI Setup =====
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "MountBingungModMenu"

-- Main Frame
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,280,0,400)
frame.Position = UDim2.new(0.05,0,0.1,0)
frame.BackgroundColor3 = Color3.fromRGB(50,0,50) -- Ungu tua
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

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

-- ===== 3. ScrollingFrame for Checkpoints =====
local scrollFrame = Instance.new("ScrollingFrame", frame)
scrollFrame.Size = UDim2.new(1,0,1,-110)
scrollFrame.Position = UDim2.new(0,0,0,40)
scrollFrame.BackgroundTransparency = 1
scrollFrame.CanvasSize = UDim2.new(0,0,0,1000)
scrollFrame.ScrollBarThickness = 10

local uiList = Instance.new("UIListLayout", scrollFrame)
uiList.SortOrder = Enum.SortOrder.LayoutOrder
uiList.Padding = UDim.new(0,5)

-- ===== 4. Checkpoint Buttons =====
for i = 1, #checkpoints do
    local cp = checkpoints[i]
    local btn = Instance.new("TextButton", scrollFrame)
    btn.Text = cp.name
    btn.Size = UDim2.new(1,0,0,30)
    btn.BackgroundColor3 = Color3.fromRGB(80,0,80)
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.LayoutOrder = i
    btn.MouseButton1Click:Connect(function()
        if player.Character and player.Character.PrimaryPart then
            player.Character:SetPrimaryPartCFrame(CFrame.new(cp.pos))
        end
    end)
end

-- ===== 5. AutoSummit + Stop Buttons (di bawah hide/close) =====
local autoBtn = Instance.new("TextButton", frame)
autoBtn.Text = "AutoSummit"
autoBtn.Size = UDim2.new(0.5, -5,0,30)
autoBtn.Position = UDim2.new(0,0,1,-50)
autoBtn.BackgroundColor3 = Color3.fromRGB(50,0,50)
autoBtn.TextColor3 = Color3.fromRGB(255,255,255)

local stopBtn = Instance.new("TextButton", frame)
stopBtn.Text = "Stop"
stopBtn.Size = UDim2.new(0.5, -5,0,30)
stopBtn.Position = UDim2.new(0.5,5,1,-50)
stopBtn.BackgroundColor3 = Color3.fromRGB(100,0,0)
stopBtn.TextColor3 = Color3.fromRGB(255,255,255)

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

-- ===== 6. CanvasSize Auto =====
uiList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    scrollFrame.CanvasSize = UDim2.new(0,0,0,uiList.AbsoluteContentSize.Y)
end)
