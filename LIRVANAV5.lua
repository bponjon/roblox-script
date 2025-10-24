-- ===== MountLirvana AutoSummit v5 (Auto Repeat) =====
local player = game.Players.LocalPlayer

-- ===== Checkpoints =====
local checkpoints = {
    {name="Checkpoint 0", pos=Vector3.new(-33.023, 86.149, 7.025)},
    {name="Checkpoint 1", pos=Vector3.new(35.501, 200.700, -559.027)},
    {name="Checkpoint 2", pos=Vector3.new(-381.037, 316.700, -560.712)},
    {name="Checkpoint 3", pos=Vector3.new(-401.126, 456.700, -1014.478)},
    {name="Checkpoint 4", pos=Vector3.new(-35.014, 548.700, -1028.476)},
    {name="Checkpoint 5", pos=Vector3.new(-50.832, 542.149, -1371.412)},
    {name="Checkpoint 6", pos=Vector3.new(-68.830, 582.149, -1615.556)},
    {name="Checkpoint 7", pos=Vector3.new(262.292, 610.149, -1647.285)},
    {name="Checkpoint 8", pos=Vector3.new(270.919, 678.149, -1378.510)},
    {name="Checkpoint 9", pos=Vector3.new(278.914, 622.149, -1025.756)},
    {name="Checkpoint 10", pos=Vector3.new(292.020, 638.149, -676.378)},
    {name="Checkpoint 11", pos=Vector3.new(601.175, 678.149, -680.490)},
    {name="Checkpoint 12", pos=Vector3.new(617.442, 626.149, -1028.689)},
    {name="Checkpoint 13", pos=Vector3.new(600.942, 678.149, -1370.222)},
    {name="Checkpoint 14", pos=Vector3.new(594.054, 670.149, -1626.474)},
    {name="Checkpoint 15", pos=Vector3.new(917.511, 690.149, -1644.750)},
    {name="Checkpoint 16", pos=Vector3.new(899.131, 702.149, -1362.030)},
    {name="Checkpoint 17", pos=Vector3.new(971.016, 674.149, -941.262)},
    {name="Checkpoint 18", pos=Vector3.new(880.015, 710.149, -675.175)},
    {name="Checkpoint 19", pos=Vector3.new(1187.287, 694.149, -661.098)},
    {name="Checkpoint 20", pos=Vector3.new(1187.453, 718.149, -332.297)},
    {name="Checkpoint 21", pos=Vector3.new(799.696, 1001.949, 207.303)}
}

-- ===== GUI Setup =====
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "MountLirvanaModMenu"
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
closeBtn.TextColor3 = Color3.fromRGB(255,255,255)
closeBtn.MouseButton1Click:Connect(function() gui.Enabled = false end)

local hideBtn = Instance.new("TextButton", frame)
hideBtn.Text = "Hide"
hideBtn.Size = UDim2.new(0,60,0,30)
hideBtn.Position = UDim2.new(0,5,0,5)
hideBtn.BackgroundColor3 = Color3.fromRGB(0,0,0)
hideBtn.TextColor3 = Color3.fromRGB(255,255,255)

local logo = Instance.new("TextButton", gui)
logo.Size = UDim2.new(0,50,0,50)
logo.Position = UDim2.new(0.9,0,0.1,0)
logo.Text = "🚀"
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

-- ===== Scrollable Buttons =====
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
	btn.TextColor3 = Color3.fromRGB(255,255,255)
	btn.LayoutOrder = i
	btn.MouseButton1Click:Connect(function()
		if player.Character and player.Character.PrimaryPart then
			player.Character:SetPrimaryPartCFrame(CFrame.new(cp.pos))
		end
	end)
end

uiList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	scrollFrame.CanvasSize = UDim2.new(0,0,0,uiList.AbsoluteContentSize.Y)
end)

-- ===== AutoSummit + Stop (Auto Repeat) =====
local autoBtn = Instance.new("TextButton", frame)
autoBtn.Text = "AutoSummit"
autoBtn.Size = UDim2.new(0.5,-5,0,30)
autoBtn.Position = UDim2.new(0,0,1,-50)
autoBtn.BackgroundColor3 = Color3.fromRGB(50,0,50)
autoBtn.TextColor3 = Color3.fromRGB(255,255,255)

local stopBtn = Instance.new("TextButton", frame)
stopBtn.Text = "Stop"
stopBtn.Size = UDim2.new(0.5,-5,0,30)
stopBtn.Position = UDim2.new(0.5,5,1,-50)
stopBtn.BackgroundColor3 = Color3.fromRGB(100,0,0)
stopBtn.TextColor3 = Color3.fromRGB(255,255,255)

local autoSummitActive = false

local function startAutoSummit()
	autoSummitActive = true
	spawn(function()
		while autoSummitActive do
			for i, cp in ipairs(checkpoints) do
				if not autoSummitActive then break end
				if player.Character and player.Character.PrimaryPart then
					player.Character:SetPrimaryPartCFrame(CFrame.new(cp.pos))
				end
				wait(4)
			end
			-- langsung ulang ke CP0 (tanpa delay)
			if autoSummitActive then
				print("🔁 Auto repeat aktif: kembali ke Checkpoint 0!")
			end
		end
	end)
end

autoBtn.MouseButton1Click:Connect(startAutoSummit)
stopBtn.MouseButton1Click:Connect(function()
	autoSummitActive = false
	print("⛔ AutoSummit dihentikan.")
end)
