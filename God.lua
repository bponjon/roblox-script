-- GOD MODE SCRIPT for Delta Executor
-- Dibuat ringan & stabil untuk mobile executor
-- Aktif otomatis, menjaga health agar gak pernah habis

local plr = game.Players.LocalPlayer

function ActivateGodMode(char)
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end

    hum.Health = hum.MaxHealth

    -- Loop pengaman
    task.spawn(function()
        while hum and hum.Parent and hum.Health > 0 do
            task.wait(0.1)
            if hum.Health < hum.MaxHealth then
                hum.Health = hum.MaxHealth
            end
        end
    end)
end

-- Saat karakter spawn ulang
plr.CharacterAdded:Connect(function(char)
    task.wait(1)
    ActivateGodMode(char)
end)

-- Jika karakter sudah ada
if plr.Character then
    ActivateGodMode(plr.Character)
end

print("✅ God Mode Aktif! Health tidak akan berkurang.")
