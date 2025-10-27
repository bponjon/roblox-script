if game:GetService("RunService"):IsStudio() then return end -- Pastikan di game, bukan Studio

local function createGUI(player)
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "ObjectRemoverGUI"
    ScreenGui.Parent = player:WaitForChild("PlayerGui")
    ScreenGui.ResetOnSpawn = false -- agar GUI tetap ada saat spawn ulang
    
    -- Membuat frame utama yang bisa digeser
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0, 120, 0, 70)
    Frame.Position = UDim2.new(0.5, -60, 0.8, -35)
    Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Frame.BackgroundTransparency = 0.3
    Frame.BorderSizePixel = 0
    Frame.Parent = ScreenGui
    
    -- Membuat tombol toggle
    local toggleButton = Instance.new("TextButton")
    toggleButton.Parent = Frame
    toggleButton.Size = UDim2.new(1, 0, 1, 0)
    toggleButton.Position = UDim2.new(0, 0, 0, 0)
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
    
    -- Buat fungsi drag
    local dragging = false
    local dragInput, dragStart, startPos
    
    Frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = Frame.Position
            input.Changed:Connect(function(change)
                if change == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    Frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
            local delta = input.Position - dragStart
            Frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    -- Menghapus objek saat klik
    local UserInputService = game:GetService("UserInputService")
    local mouse = player:GetMouse()
    
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not aktif then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local target = mouse.Target
            if target and target:IsDescendantOf(workspace) then
                -- Hapus objek secara permanen dari workspace
                target:Destroy()
            end
        end
    end)
end

game.Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Wait()
    createGUI(player)
end)

for _, player in pairs(game.Players:GetPlayers()) do
    if player.Character then
        createGUI(player)
    end
end
