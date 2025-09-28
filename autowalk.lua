-- Auto Walk Universal
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local humanoid = char:WaitForChild("Humanoid")

local walking = false
local direction = Vector3.new(0,0,-1) -- maju (ubah kalau mau ke arah lain)

-- Toggle dengan tombol "T"
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.T then
        walking = not walking
        print("Auto walk:", walking)
        while walking do
            if humanoid and humanoid.Parent then
                humanoid:Move(direction, true)
            end
            task.wait()
        end
    end
end)
