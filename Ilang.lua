-- MountBingung — Object Deleter by Mouse Target (Full Execute)
-- Bertujuan menghapus benda yang ditunjuk kursor/jari Anda saat tombol ditekan.

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local Workspace = game:GetService("Workspace")

local mouse = player:GetMouse()
local lastTarget = nil -- Menyimpan benda terakhir yang ditunjuk/disentuh

-- --- FUNGSI PENGHAPUSAN (Attempt Server Delete) ---
local function destroyTarget(targetObject)
    if not targetObject or targetObject.Parent == nil then
        print("[Delete] Error: Tidak ada objek valid yang ditunjuk/disentuh.")
        return
    end

    local objectName = targetObject.Name
    local parentName = targetObject.Parent.Name

    -- Logika Penghapusan:
    -- Mencoba menghancurkan objek di Server (Anti-Visual Attempt)
    pcall(function()
        targetObject:Destroy()
        print("[Delete] Berhasil menghancurkan objek: " .. objectName .. " (di " .. parentName .. ")")
    end)
    
    -- JIKA PENGHANCURAN SERVER GAGAL, objek mungkin masih ada di memori Anda (Client Fallback)
    if targetObject and targetObject.Parent then
        pcall(function()
            targetObject.Parent = nil 
            print("[Delete] (Client Fallback) Objek dilepaskan dari Parent di sisi klien Anda.")
        end)
    end
    
    -- Setelah berhasil dihapus, bersihkan target
    lastTarget = nil
end

-- --- LOGIKA PELACAKAN TARGET (Menggunakan Mouse.Target) ---
-- Mouse.Target adalah cara tercepat untuk mengetahui benda yang Anda tunjuk.
local function updateTarget()
    local target = mouse.Target
    
    -- Pastikan target adalah part/model di Workspace dan bukan Character Anda sendiri
    if target and target:IsA("BasePart") and target.Parent ~= player.Character then
        lastTarget = target
    end
end

-- Jalankan pelacakan setiap frame agar responsif
game:GetService("RunService").RenderStepped:Connect(updateTarget)


-- --- GUI KONTROL ---
local screen = Instance.new("ScreenGui")
screen.Name = "AutoDeleterGUI"
screen.ResetOnSpawn = false
screen.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame", screen)
frame.Size = UDim2.new(0,300,0,100)
frame.Position = UDim2.new(0.05,0,0.2,0)
frame.BackgroundColor3 = Color3.fromRGB(30,15,15) -- Merah gelap
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.AnchorPoint = Vector2.new(0,0)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 28)
title.Position = UDim2.new(0, 0, 0, 6)
title.BackgroundTransparency = 1
title.Text = "Targeted Destroyer (Sentuh & Hapus)"
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.TextColor3 = Color3.fromRGB(255,200,200)
title.TextXAlignment = Enum.TextXAlignment.Center

local targetLabel = Instance.new("TextLabel", frame)
targetLabel.Size = UDim2.new(1, -20, 0, 20)
targetLabel.Position = UDim2.new(0, 10, 0, 34)
targetLabel.BackgroundTransparency = 1
targetLabel.Font = Enum.Font.SourceSans
targetLabel.TextSize = 12
targetLabel.TextColor3 = Color3.fromRGB(255,255,255)
targetLabel.TextXAlignment = Enum.TextXAlignment.Left

local btnApply = Instance.new("TextButton", frame)
btnApply.Size = UDim2.new(1, -20, 0, 26)
btnApply.Position = UDim2.new(0, 10, 1, -30)
btnApply.Text = "DESTROY LAST TARGET"
btnApply.Font = Enum.Font.GothamBold
btnApply.TextSize = 14
btnApply.BackgroundColor3 = Color3.fromRGB(255, 0, 0) -- Merah Murni
btnApply.TextColor3 = Color3.fromRGB(0,0,0)

-- --- KONEKSI EVENT ---
local function executeDelete()
    destroyTarget(lastTarget)
end

btnApply.MouseButton1Click:Connect(executeDelete)

-- Update status label di GUI
game:GetService("RunService").Heartbeat:Connect(function()
    if lastTarget and lastTarget.Parent then
        targetLabel.Text = "Target: " .. lastTarget.Name .. " (Parent: " .. lastTarget.Parent.Name .. ")"
    else
        targetLabel.Text = "Target: Tidak ada benda valid yang ditunjuk."
    end
end)

print("[Target Destroyer] Code loaded. Arahkan kursor/jari ke benda dan tekan tombol.")
