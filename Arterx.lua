-- MountBingung Mod Menu Final
local player = game.Players.LocalPlayer

-- ===== 1. Checkpoints (Urut) =====
local checkpoints = {
    {name="Basecamp", pos=Vector3.new(166.00293,14.9578,822.9834)},
    {name="Checkpoint 1", pos=Vector3.new(198.2381,10.1375,128.4232)},
    {name="Checkpoint 2", pos=Vector3.new(228.195,128.88,-211.1924)},
    {name="Checkpoint 3", pos=Vector3.new(231.818,146.7682,-558.7238)},
    {name="Checkpoint 4", pos=Vector3.new(340.0047,132.3195,-987.2444)},
    {name="Checkpoint 5", pos=Vector3.new(393.5821,119.6244,-1415.0847)},
    {name="Checkpoint 6", pos=Vector3.new(344.6827,190.3067,-2695.906)},
    {name="Checkpoint 7", pos=Vector3.new(353.3708,243.5645,-3065.3518)},
    {name="Checkpoint 8", pos=Vector3.new(-1.6286,259.3735,-3431.1587)},
    {name="Checkpoint 9", pos=Vector3.new(54.7402,373.0255,-3835.7363)},
    {name="Checkpoint 10", pos=Vector3.new(-347.4802,505.2303,-4970.2651)},
    {name="Checkpoint 11", pos=Vector3.new(-841.8184,506.0357,-4984.3662)},
    {name="Checkpoint 12", pos=Vector3.new(-825.1913,571.7791,-5727.793)},
    {name="Checkpoint 13", pos=Vector3.new(-831.6821,575.3008,-6424.2686)},
    {name="Checkpoint 14", pos=Vector3.new(-288.5205,661.584,-6804.1523)},
    {name="Checkpoint 15", pos=Vector3.new(675.5138,743.5107,-7249.335)},
    {name="Checkpoint 16", pos=Vector3.new(816.3118,833.6859,-7606.23)},
    {name="Checkpoint 17", pos=Vector3.new(805.2925,821.0106,-8516.9082)},
    {name="Checkpoint 18", pos=Vector3.new(473.5628,879.0635,-8585.4531)},
    {name="Checkpoint 19", pos=Vector3.new(268.8312,897.1082,-8576.4492)},
    {name="Checkpoint 20", pos=Vector3.new(285.3143,933.9547,-8983.9199)},
    {name="Puncak", pos=Vector3.new(107.1410,988.2626,-9015.2315)}
}

-- ===== 2. GUI Setup =====
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "MountBingungModMenu"

-- ScrollingFrame
local frame = Instance.new("ScrollingFrame", gui)
frame.Size = UDim2.new(0,300,0,400)
frame.Position = UDim2.new(0.05,0,0.1,0)
frame.BackgroundColor3 = Color3.fromRGB(50,0,50)
frame.CanvasSize = UDim2.new(0,0,0,1000)
frame.ScrollBarThickness = 10
frame.Active = true
frame.Draggable = true

local uiList = Instance.new("UIListLayout", frame)
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
hideBtn.BackgroundColor3 = Color3.fromRGB(100,0,100)
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
    local btn = Instance.new("TextButton", frame)
    btn.Text = cp.name
    btn.Size = UDim2.new(1,0,0,30)
    btn.BackgroundColor3 = Color3.fromRGB(100,0,100)
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.LayoutOrder = i
    btn.MouseButton1Click:Connect(function()
        if player.Character and player.Character.PrimaryPart then
            player.Character:SetPrimaryPartCFrame(CFrame.new(cp.pos))
        end
    end)
end

-- ===== 4. AutoSummit =====
local autoSummitActive = false
local autoBtn = Instance.new("TextButton", frame)
autoBtn.Text = "AutoSummit"
autoBtn.Size = UDim2.new(1,0,0,30)
autoBtn.BackgroundColor3 = Color3.fromRGB(0,100,0)
autoBtn.TextColor3 = Color3.fromRGB(255,255,255)
autoBtn.LayoutOrder = #checkpoints + 1
autoBtn.MouseButton1Click:Connect(function()
    autoSummitActive = not autoSummitActive
    autoBtn.BackgroundColor3 = autoSummitActive and Color3.fromRGB(0,255,0) or Color3.fromRGB(0,100,0)
    if autoSummitActive then
        spawn(function()
            for i = 1, #checkpoints do
                if not autoSummitActive then break end
                local cp = checkpoints[i]
                if player.Character and player.Character.PrimaryPart then
                    player.Character:SetPrimaryPartCFrame(CFrame.new(cp.pos))
                end
                wait(1) -- tunggu checkpoint injek
            end
            autoSummitActive = false
            autoBtn.BackgroundColor3 = Color3.fromRGB(0,100,0)
        end)
    end
end)

-- ===== 5. CanvasSize Auto =====
uiList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    frame.CanvasSize = UDim2.new(0,0,0,uiList.AbsoluteContentSize.Y)
end)
