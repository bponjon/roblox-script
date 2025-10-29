-- BynzzBponjon GUI
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BynzzBponjon"
ScreenGui.Parent = PlayerGui

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 200, 0, 50)
MainFrame.Position = UDim2.new(0.5, -100, 0.1, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(0,0,0)
MainFrame.Parent = ScreenGui

-- Auto Summit Button
local AutoSummitBtn = Instance.new("TextButton")
AutoSummitBtn.Size = UDim2.new(1, 0, 1, 0)
AutoSummitBtn.BackgroundColor3 = Color3.fromRGB(0,0,0)
AutoSummitBtn.TextColor3 = Color3.fromRGB(255,255,255)
AutoSummitBtn.Text = "Auto Summit"
AutoSummitBtn.Parent = MainFrame

-- Sub Menu Frame
local SubMenu = Instance.new("Frame")
SubMenu.Size = UDim2.new(1, 0, 0, 120)
SubMenu.Position = UDim2.new(0, 0, 1, 5)
SubMenu.BackgroundColor3 = Color3.fromRGB(25,25,25)
SubMenu.Visible = false
SubMenu.Parent = MainFrame

-- Scrolling Frame
local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Size = UDim2.new(1,0,1,0)
ScrollFrame.CanvasSize = UDim2.new(0,0,0,200)
ScrollFrame.ScrollBarThickness = 6
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.Parent = SubMenu

-- Function to create buttons in submenu
local function createButton(name)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 30)
    btn.Position = UDim2.new(0,5,0, (#ScrollFrame:GetChildren()-1)*35)
    btn.BackgroundColor3 = Color3.fromRGB(0,0,0)
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.Text = name
    btn.Parent = ScrollFrame

    btn.MouseButton1Click:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(255,0,0)
        wait(0.2)
        btn.BackgroundColor3 = Color3.fromRGB(0,0,0)
        -- Tambahkan logic fitur di sini
    end)
end

createButton("CP Manual")
createButton("Server Hop")
createButton("Auto Death")

-- Toggle submenu
AutoSummitBtn.MouseButton1Click:Connect(function()
    SubMenu.Visible = not SubMenu.Visible
end)

-- Notification Function
local function showNotification(msg)
    local notif = Instance.new("Frame")
    notif.Size = UDim2.new(0,200,0,50)
    notif.Position = UDim2.new(0.5,-100,0.05,0)
    notif.BackgroundColor3 = Color3.fromRGB(255,0,0)
    notif.Parent = ScreenGui

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1,0,1,0)
    label.BackgroundTransparency = 1
    label.Text = msg
    label.TextColor3 = Color3.fromRGB(255,255,255)
    label.Parent = notif

    task.delay(3, function()
        notif:Destroy()
    end)
end

-- Contoh penggunaan notif
-- showNotification("Auto Summit Dimulai!")
