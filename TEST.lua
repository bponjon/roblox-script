-- ✅ FINAL GUI VERSION - FULL FUNCTIONAL + TRUE HIDE SYSTEM

-- Buat ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SummitGUI"
ScreenGui.Parent = game.CoreGui

-- Frame utama
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 370, 0, 420)
MainFrame.Position = UDim2.new(0.5, -185, 0.5, -210)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-- Header bar (atas)
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 35)
Header.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Header.Parent = MainFrame

-- Nama GUI
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0.7, 0, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Auto Summit Panel"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

-- Tombol Hide
local HideButton = Instance.new("TextButton")
HideButton.Size = UDim2.new(0, 60, 0, 25)
HideButton.Position = UDim2.new(1, -130, 0.5, -12)
HideButton.BackgroundColor3 = Color3.fromRGB(90, 90, 90)
HideButton.Text = "Hide"
HideButton.TextColor3 = Color3.fromRGB(255, 255, 255)
HideButton.Font = Enum.Font.GothamBold
HideButton.TextSize = 14
HideButton.Parent = Header

-- Tombol Close
local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 60, 0, 25)
CloseButton.Position = UDim2.new(1, -65, 0.5, -12)
CloseButton.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
CloseButton.Text = "Close"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextSize = 14
CloseButton.Parent = Header

-- Kontainer isi GUI (yang bisa di-hide)
local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, -20, 1, -55)
ContentFrame.Position = UDim2.new(0, 10, 0, 45)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

-- Contoh isi tombol (biar kelihatan)
local Example = Instance.new("TextLabel")
Example.Size = UDim2.new(1, 0, 0, 30)
Example.Text = "Semua fitur aktif di sini"
Example.TextColor3 = Color3.new(1, 1, 1)
Example.Font = Enum.Font.Gotham
Example.TextSize = 14
Example.BackgroundTransparency = 1
Example.Parent = ContentFrame

-- Tombol contoh fitur (biar jelas fungsinya)
for i = 1, 6 do
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, 0, 0, 30)
	btn.Position = UDim2.new(0, 0, 0, 40 + (i * 35))
	btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	btn.Text = "Fitur " .. i
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 14
	btn.Parent = ContentFrame
end

-- Status hide
local isHidden = false

-- Fungsi tombol hide
HideButton.MouseButton1Click:Connect(function()
	isHidden = not isHidden
	if isHidden then
		for _, obj in ipairs(ContentFrame:GetChildren()) do
			obj.Visible = false
		end
		ContentFrame.Visible = false
		MainFrame.Size = UDim2.new(0, 370, 0, 35)
		HideButton.Text = "Show"
	else
		ContentFrame.Visible = true
		for _, obj in ipairs(ContentFrame:GetChildren()) do
			obj.Visible = true
		end
		MainFrame.Size = UDim2.new(0, 370, 0, 420)
		HideButton.Text = "Hide"
	end
end)

-- Fungsi tombol close
CloseButton.MouseButton1Click:Connect(function()
	ScreenGui:Destroy()
end)
