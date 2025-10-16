-- ===== Yahyuk Teleport vFinal (Delay 20s, No Auto-Death) =====
local player = game.Players.LocalPlayer

-- ===== Checkpoints =====
local checkpoints = {
    {name="Basecamp", pos=Vector3.new(-953.328, 171.144, 881.428)},
    {name="Checkpoint 1", pos=Vector3.new(-417.413, 248.723, 786.200)},
    {name="Checkpoint 2", pos=Vector3.new(-328.026, 388.645, 528.597)},
    {name="Checkpoint 3", pos=Vector3.new(293.615, 431.350, 494.099)},
    {name="Checkpoint 4", pos=Vector3.new(324.074, 487.911, 363.436)},
    {name="Checkpoint 5", pos=Vector3.new(232.235, 315.224, -143.314)},
    {name="Puncak", pos=Vector3.new(-621.401, 905.156, -501.597)} -- posisi baru
}

-- ===== GUI Setup =====
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "YahyukTeleportMenu"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,280,0,400)
frame.Position = UDim2.new(0.05,0,0.1,0)
frame.BackgroundColor3 = Color3.fromRGB(50,0,50)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel", frame)
title.Text = "🌋 Yahyuk Teleport"
title.Size = UDim2.new(1, -10, 0, 30)
title.Position = UDim2.new(0,5,0,5)
title.BackgroundColor3 = Color3.fromRGB(80,0,80)
title.TextColor3 = Color3.fromRGB(255,255,255)
title.Font = Enum.Font.GothamBold
title.TextSize = 18

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
hideBtn.Position = UDim2.new(0,5,0,40)
hideBtn.BackgroundColor3 = Color3.fromRGB(0,0,0)
hideBtn.TextColor3 = Color3.fromRGB(255,255,255)

local logo = Instance.new("ImageButton", gui)
logo.Size = UDim2.new(0,50,0,50)
logo.Position = UDim2.new(0.9,0,0.1,0)
logo.Image = "rbxassetid://14590308879"
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

-- Scrollable Buttons (Manual Teleport)
local scrollFrame = Instance.new("ScrollingFrame", frame)
scrollFrame.Size = UDim2.new(1,0,1,-110)
scrollFrame.Position = UDim2.new(0,0,0,80)
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

-- ===== AutoSummit + Stop =====
local autoBtn = Instance.new("TextButton", frame)
autoBtn.Text = "Auto Yahyuk"
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

local autoActive = false

local function startAutoYahyuk()
	autoActive = true
	spawn(function()
		while autoActive do
			for i, cp in ipairs(checkpoints) do
				if not autoActive then break end
				if player.Character and player.Character.PrimaryPart then
					player.Character:SetPrimaryPartCFrame(CFrame.new(cp.pos))
				end
				if cp.name == "Puncak" then
					break
				else
					wait(20)
				end
			end
		end
	end)
end

autoBtn.MouseButton1Click:Connect(startAutoYahyuk)
stopBtn.MouseButton1Click:Connect(function()
	autoActive = false
end)
