-- Final Yahayuk Kw
-- GUI + AutoSummit + Manual Summit
-- Warna: Ungu Tua + Hitam, draggable, Hide/Logo

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local Root = Character:WaitForChild("HumanoidRootPart")

-- Checkpoints
local Checkpoints = {
    ["Basecamp"] = CFrame.new(-16.8994255, 292.997986, -438.799927),
    ["CP1"] = CFrame.new(18.6971245, 342.034637, -18.864109),
    ["CP2"] = CFrame.new(129.73764, 402.06366, 5.28063631),
    ["CP3"] = CFrame.new(135.903488, 357.782928, 266.350739),
    ["CP4"] = CFrame.new(227.096115, 397.939697, 326.06488),
    ["CP5"] = CFrame.new(861.573914, 370.61972, 79.1034851),
    ["Puncak"] = CFrame.new(1337.34399, 905.997986, -803.872925)
}

-- GUI Setup
local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
ScreenGui.Name = "FinalYahayukKwGUI"

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 250, 0, 400)
Frame.Position = UDim2.new(0.05,0,0.2,0)
Frame.BackgroundColor3 = Color3.fromRGB(64, 0, 64) -- Ungu Tua
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true

-- Hide/Logo Button
local HideBtn = Instance.new("TextButton", Frame)
HideBtn.Size = UDim2.new(0, 30, 0, 30)
HideBtn.Position = UDim2.new(1, -35, 0, 5)
HideBtn.Text = "H"
HideBtn.BackgroundColor3 = Color3.fromRGB(0,0,0)
HideBtn.TextColor3 = Color3.fromRGB(255,255,255)

local LogoBtn = Instance.new("TextButton", ScreenGui)
LogoBtn.Size = UDim2.new(0,50,0,50)
LogoBtn.Position = UDim2.new(0.05,0,0.2,0)
LogoBtn.Text = "🀄" -- Placeholder, bisa ganti nanti
LogoBtn.BackgroundColor3 = Color3.fromRGB(64,0,64)
LogoBtn.Visible = false
LogoBtn.Active = true
LogoBtn.Draggable = true

HideBtn.MouseButton1Click:Connect(function()
    Frame.Visible = false
    LogoBtn.Visible = true
end)

LogoBtn.MouseButton1Click:Connect(function()
    Frame.Visible = true
    LogoBtn.Visible = false
end)

-- AutoSummit Variables
local AutoSummitActive = false
local StopSummit = false

-- Buttons
local AutoBtn = Instance.new("TextButton", Frame)
AutoBtn.Size = UDim2.new(1, -10, 0, 50)
AutoBtn.Position = UDim2.new(0,5,0,50)
AutoBtn.Text = "Auto Summit"
AutoBtn.BackgroundColor3 = Color3.fromRGB(0,0,0)
AutoBtn.TextColor3 = Color3.fromRGB(255,255,255)

local StopBtn = Instance.new("TextButton", Frame)
StopBtn.Size = UDim2.new(1, -10, 0, 50)
StopBtn.Position = UDim2.new(0,5,0,110)
StopBtn.Text = "Stop"
StopBtn.BackgroundColor3 = Color3.fromRGB(255,0,0)
StopBtn.TextColor3 = Color3.fromRGB(255,255,255)

-- Manual Summit Dropdown
local ManualDropdown = Instance.new("Frame", Frame)
ManualDropdown.Size = UDim2.new(1, -10, 0, 250)
ManualDropdown.Position = UDim2.new(0,5,0,170)
ManualDropdown.BackgroundTransparency = 1

for i, name in pairs({"Basecamp","CP1","CP2","CP3","CP4","CP5","Puncak"}) do
    local btn = Instance.new("TextButton", ManualDropdown)
    btn.Size = UDim2.new(1, 0, 0, 30)
    btn.Position = UDim2.new(0,0,0,(i-1)*35)
    btn.Text = name
    btn.BackgroundColor3 = Color3.fromRGB(0,0,0)
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.MouseButton1Click:Connect(function()
        Root.CFrame = Checkpoints[name]
    end)
end

-- AutoSummit Function
local function AutoSummit()
    AutoSummitActive = true
    StopSummit = false
    spawn(function()
        while AutoSummitActive and not StopSummit do
            -- Teleport Basecamp -> CP1 -> ... -> Puncak
            for _, name in ipairs({"Basecamp","CP1","CP2","CP3","CP4","CP5","Puncak"}) do
                if StopSummit then break end
                Root.CFrame = Checkpoints[name]
                if name ~= "Puncak" then
                    wait(4)
                else
                    wait(10) -- Waktu di puncak sebelum mati
                    -- Mati otomatis karakter di puncak
                    if not StopSummit then
                        Humanoid.Health = 0
                    end
                end
            end
        end
        AutoSummitActive = false
    end)
end

AutoBtn.MouseButton1Click:Connect(function()
    if not AutoSummitActive then
        AutoSummit()
    end
end)

StopBtn.MouseButton1Click:Connect(function()
    StopSummit = true
end)
