-- FULL GOD MODE (ANTI-FALL FIXED VERSION)
-- Aman lompat tinggi, gak nyangkut di tanah.
-- Masih auto restore health & anti-dead.

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

if not LocalPlayer then
    repeat task.wait() until Players.LocalPlayer
    LocalPlayer = Players.LocalPlayer
end

local active = true
local conns = {}
local safePos = nil
local lastSafeTick = tick()
local lastTeleport = 0

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

    local hum = char:WaitForChild("Humanoid", 5)
    local root = char:WaitForChild("HumanoidRootPart", 5)
    if not hum or not root then return end

    pcall(function()
        hum.MaxHealth = math.max(tonumber(hum.MaxHealth) or 0, 100000)
        hum.Health = hum.MaxHealth
    end)

    for _, s in ipairs({
        Enum.HumanoidStateType.Dead,
        Enum.HumanoidStateType.FallingDown,
        Enum.HumanoidStateType.PlatformStanding,
        Enum.HumanoidStateType.Ragdoll
    }) do
        pcall(function() hum:SetStateEnabled(s, false) end)
    end

    safePos = root.Position
    lastSafeTick = tick()

    table.insert(conns, RunService.Heartbeat:Connect(function()
        if not active or not hum or not root or not root.Parent then return end

        -- Restore health
        if hum.Health < hum.MaxHealth then
            pcall(function() hum.Health = hum.MaxHealth end)
        end

        -- Update posisi aman saat di tanah
        if isOnGround(hum) or hum.FloorMaterial ~= Enum.Material.Air then
            safePos = root.Position
            lastSafeTick = tick()
        end

        -- Anti-fall hanya aktif kalau jatuh lama banget (lebih dari 0.8 detik sejak di tanah)
        local timeSinceSafe = tick() - lastSafeTick
        local vel = root.AssemblyLinearVelocity.Y
        local fallSpeedThreshold = -90
        local fallYOffset = 25
        local cooldown = 1.2

        if timeSinceSafe > 0.8 then
            if (vel < fallSpeedThreshold or root.Position.Y < (safePos.Y - fallYOffset)) and (tick() - lastTeleport > cooldown) then
                pcall(function()
                    root.AssemblyLinearVelocity = Vector3.new(0,0,0)
                    root.CFrame = CFrame.new(safePos + Vector3.new(0, 8, 0))
                    lastTeleport = tick()
                end)
            end
        end

        -- Cegah state mati
        if hum:GetState() == Enum.HumanoidStateType.Dead then
            pcall(function()
                hum:ChangeState(Enum.HumanoidStateType.GettingUp)
                hum.Health = hum.MaxHealth
            end)
        end
    end))
end

LocalPlayer.CharacterAdded:Connect(function(c)
    task.wait(1)
    pcall(function() protectCharacter(c) end)
end)

if LocalPlayer.Character then
    pcall(function() protectCharacter(LocalPlayer.Character) end)
end

print("✅ FULL GOD MODE aktif (versi fix anti-fall, aman buat lompat).")
