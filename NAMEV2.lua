-- MountBingung — Maximum Global Client Attempt (Membutuhkan Executor Kuat)
-- Tujuan: Mengubah DisplayName Anda di semua klien pemain lain.

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local originalDisplayName = player.DisplayName
local spoofedName = originalDisplayName

local function setSpoofedDisplayName(name)
    spoofedName = tostring(name or ""):gsub("[\n\t\r]",""):sub(1, 30) -- Batasan karakter

    -- 1. Terapkan pada klien Anda sendiri (Penting agar Anda juga melihatnya)
    player.DisplayName = spoofedName
    
    -- 2. Terapkan pada klien SEMUA pemain lain
    for _, targetPlayer in ipairs(Players:GetPlayers()) do
        if targetPlayer ~= player then
            -- Ini adalah bagian yang SANGAT TIDAK MUNGKIN berfungsi di game aman.
            -- Script mencoba memanipulasi properti di klien pemain lain.
            pcall(function()
                targetPlayer.DisplayName = spoofedName 
            end)
            
            -- Jika properti DisplayName tidak bisa diubah langsung,
            -- coba buat Tag Nama Kustom *pada klien pemain lain*
            pcall(function()
                local char = targetPlayer.Character
                if char and char:FindFirstChild("Head") then
                    local head = char.Head
                    
                    -- Hilangkan Tag Nama Kustom sebelumnya (jika ada)
                    local existing = head:FindFirstChild("GlobalSpoofNameTag")
                    if existing then existing:Destroy() end

                    -- Buat Tag Nama Kustom di klien pemain lain (jika injeksi universal berhasil)
                    if spoofedName ~= "" then
                        local billboard = Instance.new("BillboardGui")
                        billboard.Name = "GlobalSpoofNameTag"
                        billboard.Adornee = head
                        billboard.AlwaysOnTop = true
                        billboard.Size = UDim2.new(0,200,0,50)
                        billboard.StudsOffset = Vector3.new(0, 2.4, 0)
                        billboard.Parent = head

                        local label = Instance.new("TextLabel", billboard)
                        label.Size = UDim2.new(1,0,1,0)
                        label.BackgroundTransparency = 1
                        label.Text = spoofedName
                        label.Font = Enum.Font.GothamBold
                        label.TextSize = 22
                        label.TextColor3 = Color3.fromRGB(255,100,255) -- Magenta
                        label.RichText = false
                    end
                end
            end)
        end
    end
    
    print("[Global Spoof] Mengirim nama ke klien lain: " .. spoofedName)
end

local function resetDisplayName()
    -- Reset nama ke nama asli
    player.DisplayName = originalDisplayName
    
    -- Reset di klien pemain lain (jika injeksi universal berhasil)
    for _, targetPlayer in ipairs(Players:GetPlayers()) do
        if targetPlayer ~= player then
            pcall(function()
                targetPlayer.DisplayName = originalDisplayName
                local tag = targetPlayer.Character and targetPlayer.Character:FindFirstChild("Head"):FindFirstChild("GlobalSpoofNameTag")
                if tag then tag:Destroy() end
            end)
        end
    end
    print("[Global Spoof] Nama direset ke asli: " .. originalDisplayName)
end

-- --- GUI KONTROL ---
local screen = Instance.new("ScreenGui")
screen.Name = "SpoofNameGUI"
screen.ResetOnSpawn = false
screen.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame", screen)
frame.Size = UDim2.new(0,300,0,120)
frame.Position = UDim2.new(0.05,0,0.2,0)
frame.BackgroundColor3 = Color3.fromRGB(40,4,40) -- Ungu Tua
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.AnchorPoint = Vector2.new(0,0)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, -40, 0, 28)
title.Position = UDim2.new(0, 10, 0, 6)
title.BackgroundTransparency = 1
title.Text = "DisplayName Spoof (MAX ATTEMPT)"
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.TextColor3 = Color3.fromRGB(255,255,255)
title.TextXAlignment = Enum.TextXAlignment.Left

local closeBtn = Instance.new("TextButton", frame)
closeBtn.Size = UDim2.new(0,32,0,28)
closeBtn.Position = UDim2.new(1,-38,0,6)
closeBtn.Text = "X"
closeBtn.Font = Enum.Font.SourceSansBold
closeBtn.TextSize = 14
closeBtn.BackgroundColor3 = Color3.fromRGB(150,10,10)
closeBtn.TextColor3 = Color3.fromRGB(255,255,255)
closeBtn.MouseButton1Click:Connect(function()
    resetDisplayName()
    screen:Destroy() 
end)

local inputBox = Instance.new("TextBox", frame)
inputBox.Size = UDim2.new(1, -20, 0, 40)
inputBox.Position = UDim2.new(0, 10, 0, 42)
inputBox.PlaceholderText = "Nama samaran untuk seluruh server..."
inputBox.ClearTextOnFocus = false
inputBox.Text = ""
inputBox.Font = Enum.Font.SourceSans
inputBox.TextSize = 14
inputBox.TextColor3 = Color3.fromRGB(240,240,240)
inputBox.BackgroundColor3 = Color3.fromRGB(25,10,30)
inputBox.BorderSizePixel = 0

local btnApply = Instance.new("TextButton", frame)
btnApply.Size = UDim2.new(0.48, -8, 0, 26)
btnApply.Position = UDim2.new(0, 10, 1, -36)
btnApply.Text = "Apply Spoof"
btnApply.Font = Enum.Font.GothamBold
btnApply.TextSize = 14
btnApply.BackgroundColor3 = Color3.fromRGB(120,0,150)
btnApply.TextColor3 = Color3.fromRGB(255,255,255)

local btnReset = Instance.new("TextButton", frame)
btnReset.Size = UDim2.new(0.48, -8, 0, 26)
btnReset.Position = UDim2.new(0.52, 0, 1, -36)
btnReset.Text = "Reset Name"
btnReset.Font = Enum.Font.GothamBold
btnReset.TextSize = 14
btnReset.BackgroundColor3 = Color3.fromRGB(100,50,50)
btnReset.TextColor3 = Color3.fromRGB(255,255,255)

-- Koneksi Event
btnApply.MouseButton1Click:Connect(function()
    local text = tostring(inputBox.Text):gsub("\n","")
    if text == "" then
        text = originalDisplayName
    end
    setSpoofedDisplayName(text)
end)

btnReset.MouseButton1Click:Connect(function()
    resetDisplayName()
end)

inputBox.FocusLost:Connect(function(enter)
    if enter then
        local text = tostring(inputBox.Text):gsub("\n","")
        if text == "" then text = originalDisplayName end
        setSpoofedDisplayName(text)
    end
end)

print("[MAX SPOOF ATTEMPT] Code loaded. Keberhasilan tergantung kemampuan executor Anda.")
