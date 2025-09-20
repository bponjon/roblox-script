-- Simple Fly Script
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local mouse = player:GetMouse()
local flying = false
local speed = 50
local bodyGyro
local bodyVelocity

mouse.KeyDown:Connect(function(key)
    if key == "f" then -- tekan tombol F buat toggle fly
        flying = not flying
        if flying then
            local char = player.Character
            local root = char:WaitForChild("HumanoidRootPart")

            bodyGyro = Instance.new("BodyGyro")
            bodyGyro.P = 9e4
            bodyGyro.Parent = root
            bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
            bodyGyro.CFrame = root.CFrame

            bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.Parent = root
            bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
            bodyVelocity.Velocity = Vector3.new(0,0,0)

            game:GetService("RunService").RenderStepped:Connect(function()
                if flying then
                    bodyGyro.CFrame = workspace.CurrentCamera.CFrame
                    local direction = Vector3.new()
                    if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.W) then
                        direction = direction + workspace.CurrentCamera.CFrame.LookVector
                    end
                    if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.S) then
                        direction = direction - workspace.CurrentCamera.CFrame.LookVector
                    end
                    if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.A) then
                        direction = direction - workspace.CurrentCamera.CFrame.RightVector
                    end
                    if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.D) then
                        direction = direction + workspace.CurrentCamera.CFrame.RightVector
                    end
                    bodyVelocity.Velocity = direction * speed
                end
            end)
        else
            if bodyGyro then bodyGyro:Destroy() end
            if bodyVelocity then bodyVelocity:Destroy() end
        end
    end
end)

print("Fly Script Loaded! Tekan tombol F untuk toggle Fly 🚀")
