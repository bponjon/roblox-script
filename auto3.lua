local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local root = character:WaitForChild("HumanoidRootPart")
local pathPoints = {} -- ambil dari FINALATIN script, pos 26 sampai puncak

-- Contoh: pathPoints = {Vector3.new(x1,y1,z1), Vector3.new(x2,y2,z2), ...}
-- Bisa diisi manual sesuai data FINALATIN atau diambil otomatis jika FINALATIN expose posisi

local autoSummitActive = false

-- Fungsi move ke point satu per satu
local function moveToPath()
    for i, pos in ipairs(pathPoints) do
        if not autoSummitActive then break end
        humanoid:MoveTo(pos)
        humanoid.MoveToFinished:Wait() -- tunggu sampai sampai pos
        task.wait(0.2) -- delay biar stabil di HP
    end
end

-- Fungsi cek tinggi, langsung ke pos 26 kalo pendek
local function checkHeightAndStart()
    if root.Position.Y < pathPoints[1].Y then
        humanoid:MoveTo(pathPoints[1])
        humanoid.MoveToFinished:Wait()
        task.wait(0.2)
    end
    moveToPath()
end

-- Toggle Auto Summit via Mod Menu
local function toggleAutoSummit()
    autoSummitActive = not autoSummitActive
    if autoSummitActive then
        task.spawn(checkHeightAndStart)
    end
end

-- Contoh integrasi di Mod Menu
-- autoSummitButton.MouseButton1Click:Connect(toggleAutoSummit)
