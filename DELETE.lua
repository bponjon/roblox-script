if game:GetService("RunService"):IsStudio() then return end -- Pastikan di game, bukan Studio

local function createGUI(player)
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "ObjectRemoverGUI"
    ScreenGui.Parent = player:WaitForChild("PlayerGui")
    
    local toggleButton = Instance.new("TextButton")
    toggleButton.Parent = ScreenGui
    toggleButton.Position = UDim2.new(0.5, -50, 0.9, -25)
    toggleButton.Size = UDim2.new(0, 100, 0, 50)
    toggleButton.Text = "Aktifkan Mode"
    toggleButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    toggleButton.TextColor3 = Color3.new(1,1,1)
    toggleButton.Font = Enum.Font.SourceSansBold
    toggleButton.TextSize = 20
    
    local aktif = false
    
    toggleButton.MouseButton1Click:Connect(function()
        aktif = not aktif
        if aktif then
            toggleButton.Text = "Matikan Mode"
            toggleButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        else
            toggleButton.Text = "Aktifkan Mode"
            toggleButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        end
    end)
    
    local UserInputService = game:GetService("UserInputService")
    local mouse = player:GetMouse()
    
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not aktif then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local target = mouse.Target
            if target and target:IsDescendantOf(workspace) then
                target:Destroy()
            end
        end
    end)
end

game.Players.PlayerAdded:Connect(function(player)
    -- Tunggu PlayerGui siap
    player.CharacterAdded:Wait()
    createGUI(player)
end)

-- Jika ada pemain yang sudah ada
for _, player in pairs(game.Players:GetPlayers()) do
    if player.Character then
        createGUI(player)
    end
end
