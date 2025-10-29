-- GUI Script: BynzzBponjon local Players = game:GetService("Players") local player = Players.LocalPlayer local PlayerGui = player:WaitForChild("PlayerGui")

-- Main GUI local ScreenGui = Instance.new("ScreenGui") ScreenGui.Name = "BynzzBponjonGUI" ScreenGui.Parent = PlayerGui

-- Main Frame local MainFrame = Instance.new("Frame") MainFrame.Name = "MainFrame" MainFrame.Size = UDim2.new(0, 350, 0, 400) MainFrame.Position = UDim2.new(0.3, 0, 0.2, 0) MainFrame.BackgroundColor3 = Color3.fromRGB(0,0,0) MainFrame.BorderSizePixel = 0 MainFrame.Active = true MainFrame.Draggable = true MainFrame.Parent = ScreenGui

-- Top bar with name & hide/close buttons local TopBar = Instance.new("Frame") TopBar.Size = UDim2.new(1,0,0,30) TopBar.BackgroundColor3 = Color3.fromRGB(20,20,20) TopBar.Parent = MainFrame

local Title = Instance.new("TextLabel") Title.Text = "BynzzBponjon" Title.Size = UDim2.new(0.6,0,1,0) Title.BackgroundTransparency = 1 Title.TextColor3 = Color3.fromRGB(255,255,255) Title.TextScaled = true Title.Font = Enum.Font.SourceSansBold Title.Parent = TopBar

local HideButton = Instance.new("TextButton") HideButton.Text = "Hide" HideButton.Size = UDim2.new(0.2,0,1,0) HideButton.Position = UDim2.new(0.6,0,0,0) HideButton.BackgroundColor3 = Color3.fromRGB(255,0,0) HideButton.TextColor3 = Color3.fromRGB(255,255,255) HideButton.Font = Enum.Font.SourceSansBold HideButton.TextScaled = true HideButton.Parent = TopBar

local CloseButton = Instance.new("TextButton") CloseButton.Text = "X" CloseButton.Size = UDim2.new(0.2,0,1,0) CloseButton.Position = UDim2.new(0.8,0,0,0) CloseButton.BackgroundColor3 = Color3.fromRGB(255,0,0) CloseButton.TextColor3 = Color3.fromRGB(255,255,255) CloseButton.Font = Enum.Font.SourceSansBold CloseButton.TextScaled = true CloseButton.Parent = TopBar

-- Panels local FeaturePanel = Instance.new("Frame") FeaturePanel.Size = UDim2.new(0.4,0,1,-30) FeaturePanel.Position = UDim2.new(0,0,0,30) FeaturePanel.BackgroundColor3 = Color3.fromRGB(30,30,30) FeaturePanel.Parent = MainFrame

local ActionPanel = Instance.new("Frame") ActionPanel.Size = UDim2.new(0.6,0,1,-30) ActionPanel.Position = UDim2.new(0.4,0,0,30) ActionPanel.BackgroundColor3 = Color3.fromRGB(40,40,40) ActionPanel.Parent = MainFrame

-- Example Features local features = {"Auto Summit","Server Hop","Settings","Info"}

for i, feat in ipairs(features) do local btn = Instance.new("TextButton") btn.Text = feat btn.Size = UDim2.new(1,0,0,50) btn.Position = UDim2.new(0,0,0,(i-1)*50) btn.BackgroundColor3 = Color3.fromRGB(50,50,50) btn.TextColor3 = Color3.fromRGB(255,255,255) btn.Font = Enum.Font.SourceSansBold btn.TextScaled = true btn.Parent = FeaturePanel

local subPanel = Instance.new("Frame")
subPanel.Size = UDim2.new(1,0,1,0)
subPanel.Position = UDim2.new(0,0,0,0)
subPanel.BackgroundColor3 = Color3.fromRGB(60,60,60)
subPanel.Visible = false
subPanel.Parent = ActionPanel

local subBtn1 = Instance.new("TextButton")
subBtn1.Text = feat.." Sub 1"
subBtn1.Size = UDim2.new(1,0,0,50)
subBtn1.Position = UDim2.new(0,0,0,0)
subBtn1.BackgroundColor3 = Color3.fromRGB(80,80,80)
subBtn1.TextColor3 = Color3.fromRGB(255,255,255)
subBtn1.Font = Enum.Font.SourceSansBold
subBtn1.TextScaled = true
subBtn1.Parent = subPanel

local subBtn2 = Instance.new("TextButton")
subBtn2.Text = feat.." Sub 2"
subBtn2.Size = UDim2.new(1,0,0,50)
subBtn2.Position = UDim2.new(0,0,0,50)
subBtn2.BackgroundColor3 = Color3.fromRGB(80,80,80)
subBtn2.TextColor3 = Color3.fromRGB(255,255,255)
subBtn2.Font = Enum.Font.SourceSansBold
subBtn2.TextScaled = true
subBtn2.Parent = subPanel

btn.MouseButton1Click:Connect(function()
    -- Toggle subpanel visibility
    subPanel.Visible = not subPanel.Visible
    -- Hide others
    for _, other in ipairs(ActionPanel:GetChildren()) do
        if other:IsA("Frame") and other ~= subPanel then
            other.Visible = false
        end
    end
end)

end

-- Close & Hide logic CloseButton.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

local hidden = false HideButton.MouseButton1Click:Connect(function() hidden = not hidden if hidden then MainFrame.Size = UDim2.new(0, 350, 0, 30) for _, child in ipairs(MainFrame:GetChildren()) do if child ~= TopBar then child.Visible = false end end else MainFrame.Size = UDim2.new(0, 350, 0, 400) for _, child in ipairs(MainFrame:GetChildren()) do if child ~= TopBar then child.Visible = true end end end end)
