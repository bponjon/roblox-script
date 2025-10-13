-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer

-- RemoteEvent
local magnetEvent = ReplicatedStorage:FindFirstChild("MagnetEvent")
if not magnetEvent then
    magnetEvent = Instance.new("RemoteEvent")
    magnetEvent.Name = "MagnetEvent"
    magnetEvent.Parent = ReplicatedStorage
end

-- Variables
local magnetActive = false
local magnetRadius = 20

-- GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MagnetGUI"
ScreenGui.Parent = player:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0,200,0,120)
Frame.Position = UDim2.new(0,50,0,50)
Frame.BackgroundColor3 = Color3.fromRGB(50,0,50)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true
Frame.Parent = ScreenGui

local StartButton = Instance.new("TextButton")
StartButton.Size = UDim2.new(1,-20,0,30)
StartButton.Position = UDim2.new(0,10,0,10)
StartButton.Text = "Start Magnet"
StartButton.BackgroundColor3 = Color3.fromRGB(75,0,130)
StartButton.Parent = Frame

local StopButton = Instance.new("TextButton")
StopButton.Size = UDim2.new(1,-20,0,30)
StopButton.Position = UDim2.new(0,10,0,45)
StopButton.Text = "Stop Magnet"
StopButton.BackgroundColor3 = Color3.fromRGB(75,0,130)
StopButton.Parent = Frame

local RadiusSlider = Instance.new("TextBox")
RadiusSlider.Size = UDim2.new(1,-20,0,20)
RadiusSlider.Position = UDim2.new(0,10,0,80)
RadiusSlider.PlaceholderText = "Radius: 20"
RadiusSlider.BackgroundColor3 = Color3.fromRGB(100,0,100)
RadiusSlider.TextColor3 = Color3.fromRGB(255,255,255)
RadiusSlider.Parent = Frame

local HideButton = Instance.new("TextButton")
HideButton.Size = UDim2.new(0,30,0,30)
HideButton.Position = UDim2.new(1,-35,0,5)
HideButton.Text = "X"
HideButton.BackgroundColor3 = Color3.fromRGB(120,0,120)
HideButton.Parent = Frame

-- Icon for hidden GUI
local Icon = Instance.new("TextButton")
Icon.Size = UDim2.new(0,50,0,50)
Icon.Position = UDim2.new(0,10,0,50)
Icon.Text = "🧲"
Icon.BackgroundColor3 = Color3.fromRGB(75,0,130)
Icon.Visible = false
Icon.Parent = ScreenGui
Icon.Active = true
Icon.Draggable = true

-- Button functions
StartButton.MouseButton1Click:Connect(function()
    magnetActive = true
    magnetEvent:FireServer(true, magnetRadius)
end)

StopButton.MouseButton1Click:Connect(function()
    magnetActive = false
    magnetEvent:FireServer(false, magnetRadius)
end)

RadiusSlider.FocusLost:Connect(function(enter)
    local val = tonumber(RadiusSlider.Text)
    if val then
        magnetRadius = val
        RadiusSlider.PlaceholderText = "Radius: "..val
    end
end)

HideButton.MouseButton1Click:Connect(function()
    Frame.Visible = false
    Icon.Visible = true
end)

Icon.MouseButton1Click:Connect(function()
    Frame.Visible = true
    Icon.Visible = false
end)

-- Server-side loop
if RunService:IsServer() then
    local magnetPlayers = {}
    magnetEvent.OnServerEvent:Connect(function(player, active, radius)
        magnetPlayers[player] = {active = active, radius = radius}
    end)

    RunService.Heartbeat:Connect(function(dt)
        for player, data in pairs(magnetPlayers) do
            if data.active and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local hrp = player.Character.HumanoidRootPart
                for _, obj in pairs(Workspace:GetChildren()) do
                    if obj:IsA("BasePart") and (obj.Position - hrp.Position).Magnitude <= data.radius then
                        obj.Position = obj.Position:Lerp(hrp.Position, dt*10)
                    end
                end
            end
        end
    end)

    magnetEvent.OnServerEvent:Connect(function(player, active, radius)
        if not active and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = player.Character.HumanoidRootPart
            for _, obj in pairs(Workspace:GetChildren()) do
                if obj:IsA("BasePart") and (obj.Position - hrp.Position).Magnitude <= radius then
                    obj:Destroy()
                end
            end
        end
    end)
end
