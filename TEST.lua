-- GUI Script: BynzzBponjon local Players = game:GetService("Players") local player = Players.LocalPlayer local PlayerGui = player:WaitForChild("PlayerGui")

-- Main GUI local ScreenGui = Instance.new("ScreenGui") ScreenGui.Name = "BynzzBponjonGUI" ScreenGui.Parent = PlayerGui

-- Main Frame local MainFrame = Instance.new("Frame") MainFrame.Name = "MainFrame" MainFrame.Size = UDim2.new(0, 350, 0, 400) MainFrame.Position = UDim2.new(0.3, 0, 0.2, 0) MainFrame.BackgroundColor3 = Color3.fromRGB(0,0,0) MainFrame.BorderSizePixel = 0 MainFrame.Active = true MainFrame.Draggable = true MainFrame.Parent = ScreenGui

-- Top bar with name & hide/close buttons local TopBar = Instance.new("Frame") TopBar.Size = UDim2.new(1,0,0,30) TopBar.BackgroundColor3 = Color3.fromRGB(20,20,20) TopBar.Parent = MainFrame

local Title = Instance.new("TextLabel") Title.Text = "BynzzBponjon" Title.Size = UDim2.new(0.6,0,1,0) Title.BackgroundTransparency = 1 Title.TextColor3 = Color3.fromRGB(255,255,255) Title.TextScaled = true Title.Font = Enum.Font.SourceSansBold Title.Parent = TopBar

local HideButton = Instance.new("TextButton") HideButton.Text = "Hide" HideButton.Size = UDim2.new(0.2,0,1,0) HideButton.Position = UDim2.new(0.6,0,0,0) HideButton.BackgroundColor3 = Color3.fromRGB(255,0,0) HideButton.TextColor3 = Color3.fromRGB(255,255,255) HideButton.Font = Enum.Font.SourceSansBold HideButton.TextScaled = true HideButton.Parent = TopBar

local CloseButton = Instance.new("TextButton") CloseButton.Text = "X" CloseButton.Size = UDim2.new(0.2,0,1,0) CloseButton.Position = UDim2.new(0.8,0,0,0) CloseButton.BackgroundColor3 = Color3.fromRGB(255,0,0) CloseButton.TextColor3 = Color3.fromRGB(255,255,255) CloseButton.Font = Enum.Font.SourceSansBold CloseButton.TextScaled = true CloseButton.Parent = TopBar

-- Panels local FeaturePanel = Instance.new("Frame") FeaturePanel.Size = UDim2.new(0.4,0,1,-30) FeaturePanel.Position = UDim2.new(0,0,0,30) FeaturePanel.BackgroundColor3 = Color3.fromRGB(30,30,30) FeaturePanel.Parent = MainFrame

local ActionPanel = Instance.new("Frame") ActionPanel.Size = UDim2.new(0.6,0,1,-30) ActionPanel.Position = UDim2.new(0
