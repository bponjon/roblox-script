-- BynzzBponjon GUI v1.0
-- Konsep: hitam-putih, tombol merah aktif, compact, scrollable checkpoint

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- Main Screen GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BynzzBponjonGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

-- Background Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 300, 0, 400)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(0,0,0)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

-- Title
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Text = "BynzzBponjon"
Title.Size = UDim2.new(1,0,0,50)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(255,255,255)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 24
Title.Parent = MainFrame

-- Auto Summit Button
local AutoButton = Instance.new("TextButton")
AutoButton.Name = "AutoSummit"
AutoButton.Size = UDim2.new(0.9,0,0,40)
AutoButton.Position = UDim2.new(0.05,0,0,60)
AutoButton.Text = "Auto Summit"
AutoButton.BackgroundColor3 = Color3.fromRGB(255,0,0)
AutoButton.TextColor3 = Color3.fromRGB(255,255,255)
AutoButton.Font = Enum.Font.SourceSansBold
AutoButton.TextSize = 20
AutoButton.Parent = MainFrame

-- CP Manual Scroll Frame
local CPFrame = Instance.new("ScrollingFrame")
CPFrame.Name = "CPFrame"
CPFrame.Size = UDim2.new(0.9,0,0,200)
CPFrame.Position = UDim2.new(0.05,0,0,110)
CPFrame.BackgroundColor3 = Color3.fromRGB(30,30,30)
CPFrame.BorderSizePixel = 0
CPFrame.CanvasSize = UDim2.new(0,0,0,0)
CPFrame.ScrollBarThickness = 6
CPFrame.Parent = MainFrame

-- UIListLayout for CP Buttons
local ListLayout = Instance.new("UIListLayout")
ListLayout.Parent = CPFrame
ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
ListLayout.Padding = UDim.new(0,5)

-- Function to add CP buttons
local function addCPButton(name)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1,0,0,30)
    btn.Text = name
    btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 18
    btn.Parent = CPFrame
    CPFrame.CanvasSize = UDim2.new(0,0,0,ListLayout.AbsoluteContentSize.Y)
    return btn
end

-- Example CP buttons
for i=1,19 do
    addCPButton("Checkpoint "..i)
end

-- Notification Frame
local Notification = Instance.new("TextLabel")
Notification.Size = UDim2.new(0,300,0,50)
Notification.Position = UDim2.new(0.5,-150,0,50)
Notification.BackgroundColor3 = Color3.fromRGB(255,0,0)
Notification.TextColor3 = Color3.fromRGB(255,255,255)
Notification.Font = Enum.Font.SourceSansBold
Notification.TextSize = 20
Notification.Text = ""
Notification.Visible = false
Notification.Parent = ScreenGui

-- Function to show notification
local function showNotification(msg, duration)
    Notification.Text = msg
    Notification.Visible = true
    task.delay(duration or 3, function()
        Notification.Visible = false
    end)
end

-- Example: Click Auto Summit
AutoButton.MouseButton1Click:Connect(function()
    showNotification("Auto Summit Started!",2)
end)

-- Example: Click CP buttons
for _,btn in pairs(CPFrame:GetChildren()) do
    if btn:IsA("TextButton") then
        btn.MouseButton1Click:Connect(function()
            showNotification(btn.Text.." Selected!",2)
        end)
    end
end
