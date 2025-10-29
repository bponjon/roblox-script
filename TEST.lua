-- GUI utama
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BynzzBponjonGUI"
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- Frame utama
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 350, 0, 400)
MainFrame.Position = UDim2.new(0.5, -175, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(0,0,0)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui
MainFrame.Draggable = true
MainFrame.Active = true

-- Title
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1,0,0,30)
Title.BackgroundColor3 = Color3.fromRGB(0,0,0)
Title.TextColor3 = Color3.fromRGB(255,255,255)
Title.Text = "BynzzBponjon"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20
Title.Parent = MainFrame

-- Menu Buttons (Auto Summit, CP Manual, Server Hop, Settings, Info)
local menus = {"Auto Summit","CP Manual","Server Hop","Settings","Info"}
local MenuFrame = Instance.new("Frame")
MenuFrame.Size = UDim2.new(1,0,0,30*#menus)
MenuFrame.Position = UDim2.new(0,0,0,30)
MenuFrame.BackgroundColor3 = Color3.fromRGB(30,30,30)
MenuFrame.Parent = MainFrame

for i, name in ipairs(menus) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1,0,0,30)
    btn.Position = UDim2.new(0,0,0,(i-1)*30)
    btn.BackgroundColor3 = Color3.fromRGB(0,0,0)
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.Text = name
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 18
    btn.Parent = MenuFrame
    
    btn.MouseButton1Click:Connect(function()
        btn.TextColor3 = Color3.fromRGB(255,0,0) -- highlight merah saat aktif
        print(name.." clicked") -- nanti diganti fungsinya
    end)
end

-- ScrollFrame untuk CP Manual / banyak item
local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Size = UDim2.new(1, -10, 0, 200)
ScrollFrame.Position = UDim2.new(0,5,0,30 + 30*#menus + 5)
ScrollFrame.CanvasSize = UDim2.new(0,0,2,0) -- contoh bisa di-scroll
ScrollFrame.BackgroundColor3 = Color3.fromRGB(15,15,15)
ScrollFrame.BorderSizePixel = 0
ScrollFrame.Parent = MainFrame

-- Contoh isi scroll
for i=1,20 do
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1,0,0,20)
    lbl.Position = UDim2.new(0,0,0,(i-1)*22)
    lbl.BackgroundTransparency = 1
    lbl.TextColor3 = Color3.fromRGB(255,255,255)
    lbl.Text = "Checkpoint "..i
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 16
    lbl.Parent = ScrollFrame
end

-- Notifikasi contoh
local Notification = Instance.new("TextLabel")
Notification.Size = UDim2.new(0, 250, 0, 40)
Notification.Position = UDim2.new(0.5, -125, 0, 50)
Notification.BackgroundColor3 = Color3.fromRGB(255,0,0)
Notification.TextColor3 = Color3.fromRGB(255,255,255)
Notification.Text = "Auto Summit Started"
Notification.Font = Enum.Font.GothamBold
Notification.TextSize = 18
Notification.Visible = false
Notification.Parent = ScreenGui

-- Function to show notification
local function showNotification(text)
    Notification.Text = text
    Notification.Visible = true
    delay(2.5, function()
        Notification.Visible = false
    end)
end

-- contoh trigger
-- showNotification("Auto Summit Started")
