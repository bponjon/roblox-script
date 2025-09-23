-- Teleport Fling Return (Fix supaya target mental, bukan kita)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local function flingOnce(target)
    local char = LocalPlayer.Character
    local tChar = target and target.Character
    if not char or not tChar then return end

    local hrp = char:FindFirstChild("HumanoidRootPart")
    local thrp = tChar:FindFirstChild("HumanoidRootPart")
    if not hrp or not thrp then return end

    local originalCF = hrp.CFrame

    -- Teleport ke target
    hrp.CFrame = thrp.CFrame

    -- Anchor biar kita gak ikut mental
    hrp.Anchored = true

    -- Fling dengan BodyAngularVelocity
    local bv = Instance.new("BodyAngularVelocity")
    bv.MaxTorque = Vector3.new(9e9,9e9,9e9)
    bv.AngularVelocity = Vector3.new(0,9e9,0)
    bv.P = 1e5
    bv.Parent = hrp

    task.wait(0.3)

    bv:Destroy()
    hrp.Anchored = false

    -- Balik ke posisi awal
    hrp.CFrame = originalCF
end

-- contoh pakai: fling target dengan nama sebagian
local targetName = "IsiNamaTarget"
for _, p in pairs(Players:GetPlayers()) do
    if p ~= LocalPlayer and p.Name:lower():sub(1,#targetName) == targetName:lower() then
        flingOnce(p)
    end
end
