-- FULL GOD MODE (Anti-Fall + Anti-Dead)
-- Optimized for Delta Executor (mobile)
-- Auto aktif begitu dijalankan

local plr = game:GetService("Players").LocalPlayer
local RunService = game:GetService("RunService")

function fullGod(char)
    local hum = char:WaitForChild("Humanoid", 5)
    if not hum then return end

    -- Bikin selalu sehat
    hum.Health = hum.MaxHealth
    hum.MaxHealth = math.max(hum.MaxHealth, 100)

    -- Matikan semua state yang bisa bikin mati atau jatuh
    for _, state in ipairs(Enum.HumanoidStateType:GetEnumItems()) do
        if state == Enum.HumanoidStateType.Dead or state == Enum.HumanoidStateType.FallingDown or state == Enum.HumanoidStateType.PlatformStanding then
            pcall(function()
                hum:SetStateEnabled(state, false)
            end)
        end
    end

    -- Loop restore
    RunService.Heartbeat:Connect(function()
        if hum and hum.Parent then
            if hum.Health < hum.MaxHealth then
                hum.Health = hum.MaxHealth
            end
            if hum:GetState() == Enum.HumanoidStateType.Dead then
                hum:ChangeState(Enum.HumanoidStateType.Running)
                hum.Health = hum.MaxHealth
            end
        end
    end)
end

-- Saat respawn
plr.CharacterAdded:Connect(function(char)
    task.wait(1)
    fullGod(char)
end)

-- Kalau udah spawn
if plr.Character then
    fullGod(plr.Character)
end

print("✅ FULL GOD MODE aktif! Tidak bisa mati jatuh atau damage biasa.")
