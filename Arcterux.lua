-- Script Final Mount Atin (Mod Menu + AutoSummit + Manual)
-- Mobile friendly, dragable GUI, tema ungu+hitam

-- 1. Table checkpoint (urut numerik)
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

-- 2. GUI setup
local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "MountAtinModMenu"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,300,0,400)
frame.Position = UDim2.new(0.05,0,0.1,0)
frame.BackgroundColor3 = Color3.fromRGB(50,0,50)
frame.Active = true
frame.Draggable = true

local uiList = Instance.new("UIListLayout", frame)
uiList.SortOrder = Enum.SortOrder.LayoutOrder

-- 3. Manual teleport buttons
for i = 1, #checkpoints do
    local cp = checkpoints[i]
    local btn = Instance.new("TextButton", frame)
    btn.Text = cp.name
    btn.Size = UDim2.new(1,0,0,30)
    btn.BackgroundColor3 = Color3.fromRGB(100,0,100)
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.MouseButton1Click:Connect(function()
        player.Character:SetPrimaryPartCFrame(CFrame.new(cp.pos))
    end)
end

-- 4. AutoSummit function
local autoSummitActive = false
local autoBtn = Instance.new("TextButton", frame)
autoBtn.Text = "AutoSummit"
autoBtn.Size = UDim2.new(1,0,0,30)
autoBtn.BackgroundColor3 = Color3.fromRGB(0,100,0)
autoBtn.TextColor3 = Color3.fromRGB(255,255,255)
autoBtn.MouseButton1Click:Connect(function()
    autoSummitActive = not autoSummitActive
    if autoSummitActive then
        autoBtn.BackgroundColor3 = Color3.fromRGB(0,255,0)
        for i = 1, #checkpoints do
            if not autoSummitActive then break end
            local cp = checkpoints[i]
            player.Character:SetPrimaryPartCFrame(CFrame.new(cp.pos))
            wait(1) -- nunggu injek checkpoint
        end
        autoSummitActive = false
        autoBtn.BackgroundColor3 = Color3.fromRGB(0,100,0)
    else
        autoBtn.BackgroundColor3 = Color3.fromRGB(0,100,0)
    end
end)
