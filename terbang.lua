-- Fly Universal Script
-- Controls: F = Toggle Fly, W/A/S/D = Gerak, Space = Naik, LeftShift = Turun

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local hrp = player.Character and player.Character:WaitForChild("HumanoidRootPart")

local flying = false
local bv, bg
local speed = 80
local ascendSpeed = 55
local damping = 0.92
local keys = {W=false, A=false, S=false, D=false, Space=false, Shift=false}

local function createFly(hrp)
    bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(1e5,1e5,1e5)
    bv.P = 1e4
    bv.Velocity = Vector3.zero
    bv.Parent = hrp

    bg = Instance.new("BodyGyro")
    bg.MaxTorque = Vector3.new(1e5,1e5,1e5)
    bg.P = 1e4
    bg.CFrame = hrp.CFrame
    bg.Parent = hrp
end

local function removeFly()
    if bv then bv:Destroy() bv = nil end
    if bg then bg:Destroy() bg = nil end
end

local function computeVel()
    local cam = workspace.CurrentCamera
    local look = cam.CFrame.LookVector
    local right = cam.CFrame.RightVector

    local forward = Vector3.new(look.X,0,look.Z).Unit
    local rightFlat = Vector3.new(right.X,0,right.Z).Unit

    local move = Vector3.zero
    if keys.W then move += forward end
    if keys.S then move -= forward end
    if keys.D then move += rightFlat end
    if keys.A then move -= rightFlat end

    local vertical = 0
    if keys.Space then vertical += 1 end
    if keys.Shift then vertical -= 1 end

    local horiz = move.Magnitude > 0 and move.Unit * speed or Vector3.zero
    local vert = Vector3.new(0, vertical * ascendSpeed, 0)

    return horiz + vert
end

local function startFly()
    if flying then return end
    hrp = player.Character and player.Character:WaitForChild("HumanoidRootPart")
    if not hrp then return end

    flying = true
    createFly(hrp)

    RunService.RenderStepped:Connect(function()
        if flying and hrp and bv and bg then
            bg.CFrame = CFrame.new(hrp.Position, hrp.Position + workspace.CurrentCamera.CFrame.LookVector)
            local target = computeVel()
            bv.Velocity = bv.Velocity * damping + target * (1 - damping)
        end
    end)
end

local function stopFly()
    flying = false
    removeFly()
end

UserInputService.InputBegan:Connect(function(input,gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.F then
        if flying then stopFly() else startFly() end
    elseif input.KeyCode == Enum.KeyCode.W then keys.W = true
    elseif input.KeyCode == Enum.KeyCode.A then keys.A = true
    elseif input.KeyCode == Enum.KeyCode.S then keys.S = true
    elseif input.KeyCode == Enum.KeyCode.D then keys.D = true
    elseif input.KeyCode == Enum.KeyCode.Space then keys.Space = true
    elseif input.KeyCode == Enum.KeyCode.LeftShift then keys.Shift = true
    end
end)

UserInputService.InputEnded:Connect(function(input,gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.W then keys.W = false
    elseif input.KeyCode == Enum.KeyCode.A then keys.A = false
    elseif input.KeyCode == Enum.KeyCode.S then keys.S = false
    elseif input.KeyCode == Enum.KeyCode.D then keys.D = false
    elseif input.KeyCode == Enum.KeyCode.Space then keys.Space = false
    elseif input.KeyCode == Enum.KeyCode.LeftShift then keys.Shift = false
    end
end)

player.CharacterAdded:Connect(function()
    stopFly()
end)
