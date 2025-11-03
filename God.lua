-- FULL GOD MODE (AGGRESSIVE, final)
-- Untuk executor (Delta/mobile). Auto-aktif saat dijalankan.
-- WARNING: server-side death / anti-cheat masih bisa ngejadiin kematian. Gunakan risiko sendiri.

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

if not LocalPlayer then
    repeat task.wait() until Players.LocalPlayer
    LocalPlayer = Players.LocalPlayer
end

local active = true -- set ke false buat matikan sementara
local conns = {}
local safePos = nil

local function clearConns()
    for _, c in ipairs(conns) do
        pcall(function() c:Disconnect() end)
    end
    conns = {}
end

local function isOnGround(hum)
    local st = hum:GetState()
    return st == Enum.HumanoidStateType.Running
        or st == Enum.HumanoidStateType.Landed
        or st == Enum.HumanoidStateType.RunningNoPhysics
        or st == Enum.HumanoidStateType.GettingUp
        or st == Enum.HumanoidStateType.Climbing
        or st == Enum.HumanoidStateType.Seated
end

local function protectCharacter(char)
    if not char or not char.Parent then return end
    clearConns()

    local hum = char:FindFirstChildOfClass("Humanoid") or char:WaitForChild("Humanoid", 5)
    local root = char:FindFirstChild("HumanoidRootPart") or char:WaitForChild("HumanoidRootPart", 5)
    if not hum or not root then return end

    -- Naikkan MaxHealth client-side dan isi darah
    pcall(function()
        hum.MaxHealth = math.max(tonumber(hum.MaxHealth) or 0, 100000)
        hum.Health = hum.MaxHealth
    end)

    -- Disable beberapa state berbahaya client-side (best-effort)
    pcall(function()
        local unsafe = {
            Enum.HumanoidStateType.Dead,
            Enum.HumanoidStateType.FallingDown,
            Enum.HumanoidStateType.Freefall,
            Enum.HumanoidStateType.PlatformStanding,
            Enum.HumanoidStateType.Ragdoll
        }
        for _, s in ipairs(unsafe) do
            pcall(function() hum:SetStateEnabled(s, false) end)
        end
    end)

    -- Inisialisasi safePos
    safePos = root.Position

    -- Heartbeat: restore health, update safePos, anti-fall
    table.insert(conns, RunService.Heartbeat:Connect(function()
        if not active then return end
        if not hum or not root or not root.Parent then return end

        -- Restore health tiap frame
        pcall(function()
            if hum.Health < hum.MaxHealth then
                hum.Health = hum.MaxHealth
            end
        end)

        -- Update safePos bila di ground
        pcall(function()
            if isOnGround(hum) or hum.FloorMaterial ~= Enum.Material.Air then
                safePos = root.Position
            end
        end)

        -- Deteksi jatuh & koreksi
        local vel = (root.AssemblyLinearVelocity and root.AssemblyLinearVelocity.Y) or 0
        local fallSpeedThreshold = -55 -- jika turun lebih cepat dari ini -> koreksi
        local fallYOffset = 14 -- jika Y lebih rendah dari safePos sebanyak ini -> koreksi

        local fellFast = vel < fallSpeedThreshold
        local fellFar = safePos and (root.Position.Y < (safePos.Y - fallYOffset))

        if fellFast or fellFar then
            pcall(function()
                if root and root:IsA("BasePart") then
                    root.AssemblyLinearVelocity = Vector3.new(0,0,0)
                end
                if safePos then
                    root.CFrame = CFrame.new(safePos + Vector3.new(0, 6, 0))
                else
                    -- fallback: teleport ke respawn location jika ada
                    local resp = LocalPlayer.RespawnLocation
                    if resp and resp.Position then
                        root.CFrame = CFrame.new(resp.Position + Vector3.new(0,6,0))
                    end
                end
            end)
        end

        -- Jika client-side Dead, coba ubah state & restore
        pcall(function()
            if hum:GetState() == Enum.HumanoidStateType.Dead then
                hum:ChangeState(Enum.HumanoidStateType.GettingUp)
                hum.Health = hum.MaxHealth
            end
        end)
    end))

    -- Health change: restore cepat
    table.insert(conns, hum:GetPropertyChangedSignal("Health"):Connect(function()
        if not active then return end
        pcall(function()
            if hum.Health < hum.MaxHealth then
                hum.Health = hum.MaxHealth
            end
        end)
    end))

    -- State changed: kalau server paksa Dead, coba koreksi cepat
    table.insert(conns, hum.StateChanged:Connect(function(_, new)
        if not active then return end
        if new == Enum.HumanoidStateType.Dead then
            pcall(function()
                hum:ChangeState(Enum.HumanoidStateType.GettingUp)
                hum.Health = hum.MaxHealth
                if safePos then
                    for i=1,3 do
                        root.CFrame = CFrame.new(safePos + Vector3.new(0,6+i,0))
                        task.wait(0.03)
                    end
                else
                    pcall(function() LocalPlayer:LoadCharacter() end)
                end
            end)
        end
    end))

    -- Clear jika char hilang
    table.insert(conns, char.AncestryChanged:Connect(function(_, parent)
        if not parent then clearConns() end
    end))
end

-- Auto aktif setelah spawn (tunggu 1 detik)
LocalPlayer.CharacterAdded:Connect(function(c)
    task.wait(1)
    pcall(function() protectCharacter(c) end)
end)

if LocalPlayer.Character then
    pcall(function() protectCharacter(LocalPlayer.Character) end)
end

print("✅ FULL GOD MODE (AGGRESSIVE final) aktif. Matikan dengan mengubah `active = false` di script.")
