-- Mobile Fling Return versi ringan

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local function flingTarget(target)
    local char = LocalPlayer.Character
    local tChar = target.Character
    if not char or not tChar then return end

    local hrp = char:FindFirstChild("HumanoidRootPart")
    local thrp = tChar:FindFirstChild("HumanoidRootPart")
    if not hrp or not thrp then return end

    local originalCF = hrp.CFrame

    -- Teleport ke target
    hrp.CFrame = thrp.CFrame

    -- Spam velocity biar target mental
    for i = 1,20 do
        hrp.Velocity = Vector3.new(9999,9999,9999)
        task.wait(0.05)
    end

    -- Balik ke posisi awal
    hrp.CFrame = originalCF
end

-- contoh: isi nama target
local targetName = "IsiNamaTarget"
for _, p in pairs(Players:GetPlayers()) do
    if p ~= LocalPlayer and p.Name:lower():sub(1,#targetName) == targetName:lower() then
        flingTarget(p)
    end
end
