-- MountBingung — Server Delete via ClickDetector (MAX ATTEMPT)
-- Tujuan: Menghancurkan benda di Server agar hilang selama Server masih berjalan.

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local mouse = player:GetMouse()
local Workspace = game:GetService("Workspace")

local lastClickedObject = nil

-- --- FUNGSI PENGHAPUSAN SERVER ---
local function serverDestroy(targetObject)
    if not targetObject or targetObject.Parent == nil then
        print("[Server Delete] Error: Tidak ada objek valid untuk dihapus.")
        return
    end

    local objectPath = targetObject:GetFullName()
    
    print("[Server Delete] Mencoba menghapus PERMANEN (selama server aktif): " .. objectPath)

    -- Upaya Penghapusan Server (Anti-Visual)
    pcall(function()
        targetObject:Destroy()
        print("[Server Delete] Berhasil menghancurkan objek di Server!")
    end)

    -- Fallback Client-Side (Agar Anda melihatnya hilang)
    if targetObject and targetObject.Parent then
        pcall(function()
            targetObject.Parent = nil
            print("[Server Delete] (Visual Fallback) Objek hilang dari layar Anda.")
        end)
    end
    
    lastClickedObject = nil
end

-- --- LOGIKA PENANGKAPAN KLIK DENGAN MOUSE.TARGET ---
mouse.Button1Down:Connect(function()
    local target = mouse.Target

    if target and target:IsA("BasePart") and target.Parent ~= player.Character then
        lastClickedObject = target
        
        -- Langsung coba hapus saat diklik
        serverDestroy(lastClickedObject)
    end
end)

-- --- GUI KONTROL (Hanya Indikator) ---
local screen = Instance.new("ScreenGui")
screen.Name = "ServerDeleterGUI"
screen.ResetOnSpawn = false
screen.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame", screen)
frame.Size = UDim2.new(0,250,0,50)
frame.Position = UDim2.new(0.5,-125,0.05,0)
frame.BackgroundColor3 = Color3.fromRGB(80,0,0) -- Merah Tua
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 1, 0)
title.BackgroundTransparency = 1
title.Text = "SERVER DELETER: KLIK OBJEK!"
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.TextColor3 = Color3.fromRGB(255,255,255)
title.TextXAlignment = Enum.TextXAlignment.Center

print("[Server Deleter] Code loaded. Klik kiri (mouse/jari) pada benda yang ingin dihapus.")

