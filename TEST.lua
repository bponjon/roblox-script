-- Skeleton GUI & Fitur
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local AutoSummitButton = Instance.new("TextButton")
local ManualCPButton = Instance.new("TextButton")
local DelayBox = Instance.new("TextBox")
local InfoLabel = Instance.new("TextLabel")

-- Setup Frame
MainFrame.Size = UDim2.new(0, 300, 0, 400)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(0,0,0)
MainFrame.Parent = ScreenGui

-- Auto Summit Button
AutoSummitButton.Text = "Auto Summit"
AutoSummitButton.BackgroundColor3 = Color3.fromRGB(50,50,50)
AutoSummitButton.Position = UDim2.new(0, 20, 0, 20)
AutoSummitButton.Size = UDim2.new(0, 260, 0, 50)
AutoSummitButton.Parent = MainFrame

-- Manual CP Button
ManualCPButton.Text = "CP Manual"
ManualCPButton.Position = UDim2.new(0, 20, 0, 80)
ManualCPButton.Size = UDim2.new(0, 260, 0, 50)
ManualCPButton.Parent = MainFrame

-- Delay Box
DelayBox.PlaceholderText = "Set Delay (s)"
DelayBox.Position = UDim2.new(0, 20, 0, 140)
DelayBox.Size = UDim2.new(0, 260, 0, 50)
DelayBox.Parent = MainFrame

-- Info Label
InfoLabel.Text = "BynzzBponjon"
InfoLabel.TextColor3 = Color3.fromRGB(255,255,255)
InfoLabel.Position = UDim2.new(0, 20, 0, 200)
InfoLabel.Size = UDim2.new(0, 260, 0, 50)
InfoLabel.Parent = MainFrame

ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
