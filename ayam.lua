-- MountYahYuk Final Script

-- CONFIG
local autoSummitTimer = 4         -- detik antar CP
local peakTimer = 10              -- detik di Puncak
local guiColor = Color3.fromRGB(85,0,127) -- ungu tua
local guiAccent = Color3.fromRGB(0,0,0)   -- hitam

-- POSISI BASECAMP & CHECKPOINTS
local checkpoints = {
    Basecamp = CFrame.new(-16.8994255,292.997986,-438.799927),
    CP1 = CFrame.new(18.6971245,342.034637,-18.864109),
    CP2 = CFrame.new(129.73764,402.06366,5.28063631),
    CP3 = CFrame.new(135.903488,357.782928,266.350739),
    CP4 = CFrame.new(227.096115,397.939697,326.06488),
    CP5 = CFrame.new(861.573914,370.61972,79.1034851),
    Puncak = CFrame.new(1338.89172,902.435425,-778.335144)
}

-- VARIABLES
local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer
local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")
local autosummitActive = false
local manualTeleportActive = false

-- GUI SETUP
local screenGui = Instance.new("ScreenGui",game:GetService("CoreGui"))
screenGui.Name = "MountYahYukGUI"

local mainFrame = Instance.new("Frame",screenGui)
mainFrame.Size = UDim2.new(0,300,0,400)
mainFrame.Position = UDim2.new(0.05,0,0.1,0)
mainFrame.BackgroundColor3 = guiColor
mainFrame.Active = true
mainFrame.Draggable = true

local hideBtn = Instance.new("TextButton",mainFrame)
hideBtn.Size = UDim2.new(0,30,0,30)
hideBtn.Position = UDim2.new(1,-65,0,5)
hideBtn.Text = "H"
hideBtn.BackgroundColor3 = guiAccent

local closeBtn = Instance.new("TextButton",mainFrame)
closeBtn.Size = UDim2.new(0,30,0,30)
closeBtn.Position = UDim2.new(1,-30,0,5)
closeBtn.Text = "X"
closeBtn.BackgroundColor3 = guiAccent

-- Logo saat hide
local logoBtn = Instance.new("ImageButton",screenGui)
logoBtn.Size = UDim2.new(0,50,0,50)
logoBtn.Position = UDim2.new(0.05,0,0.05,0)
logoBtn.Image = "rbxassetid://<GANTI_ID_ANIME_LOGO>"
logoBtn.Visible = false
logoBtn.Active = true
logoBtn.Draggable = true

-- Tombol Auto Summit & Stop
local autoSummitBtn = Instance.new("TextButton",mainFrame)
autoSummitBtn.Size = UDim2.new(0,100,0,30)
autoSummitBtn.Position = UDim2.new(0,10,0,50)
autoSummitBtn.Text = "Auto Summit"
autoSummitBtn.BackgroundColor3 = guiAccent

local stopBtn = Instance.new("TextButton",mainFrame)
stopBtn.Size = UDim2.new(0,100,0,30)
stopBtn.Position = UDim2.new(0,120,0,50)
stopBtn.Text = "Stop"
stopBtn.BackgroundColor3 = guiAccent

-- Manual teleport buttons (Basecamp → Puncak)
local yPos = 90
for name,_ in pairs(checkpoints) do
    local btn = Instance.new("TextButton",mainFrame)
    btn.Size = UDim2.new(0,280,0,25)
    btn.Position = UDim2.new(0,10,0,yPos)
    btn.Text = name
    btn.BackgroundColor3 = guiAccent
    yPos = yPos + 30
    btn.MouseButton1Click:Connect(function()
        hrp.CFrame = checkpoints[name]
    end)
end

-- FUNCTIONS
local function safeTeleport(toCFrame)
    hrp.CFrame = toCFrame
    task.wait(0.1) -- delay aman sebelum lanjut
end

local function autoSummit()
    autosummitActive = true
    while autosummitActive do
        for _,cf in pairs(checkpoints) do
            if not autosummitActive then break end
            safeTeleport(cf)
            task.wait(autoSummitTimer)
        end
        -- Di Puncak
        task.wait(peakTimer)
        -- matiin karakter
        if autosummitActive then
            if character and character:FindFirstChild("Humanoid") then
                character.Humanoid.Health = 0
            end
        end
    end
end

-- EVENTS
autoSummitBtn.MouseButton1Click:Connect(function()
    if not autosummitActive then
        task.spawn(autoSummit)
    end
end)

stopBtn.MouseButton1Click:Connect(function()
    autosummitActive = false
end)

hideBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    logoBtn.Visible = true
end)

logoBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = true
    logoBtn.Visible = false
end)

closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)
