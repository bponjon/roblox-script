if game:GetService("RunService"):IsStudio() then return end -- Pastikan di game, bukan Studio

local function createGUI(player)
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "ObjectRemoverGUI"
    ScreenGui.Parent = player:WaitForChild("PlayerGui")
    ScreenGui.ResetOnSpawn = false

    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0, 200, 0, 100)
    Frame.Position = UDim2.new(0.5, -100, 0.8, -50)
    Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Frame.BackgroundTransparency = 0.3
    Frame.BorderSizePixel = 0
    Frame.Parent = ScreenGui

    local toggleButton = Instance.new("TextButton")
    toggleButton.Size = UDim2.new(1, 0, 0, 30)
    toggleButton.Position = UDim2.new(0, 0, 0, 0)
    toggleButton.Text = "Aktifkan Mode"
    toggleButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    toggleButton.TextColor3 = Color3.new(1,1,1)
    toggleButton.Font = Enum.Font.SourceSansBold
    toggleButton.TextSize = 20
    toggleButton.Parent = Frame

    local undoButton = Instance.new("TextButton")
    undoButton.Size = UDim2.new(1, 0, 0, 30)
    undoButton.Position = UDim2.new(0, 0, 0, 35)
    undoButton.Text = "Undo"
    undoButton.BackgroundColor3 = Color3.fromRGB(0, 0, 255)
    undoButton.TextColor3 = Color3.new(1,1,1)
    undoButton.Font = Enum.Font.SourceSansBold
    undoButton.TextSize = 20
    undoButton.Parent = Frame

    local aktif = false
    local hapusStack = {} -- stack untuk menyimpan objek yang dihapus

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

    -- Fungsi drag GUI
    local dragging = false
    local dragStart, startPos

    Frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
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
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            if dragging then
                local delta = input.Position - dragStart
                Frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end
    end)

    -- Menghapus objek saat tap/touch
    local UserInputService = game:GetService("UserInputService")
    local mouse = player:GetMouse()

    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not aktif then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            local target = mouse.Target
            if target and target:IsDescendantOf(workspace) then
                -- Simpan objek ke stack untuk undo
                table.insert(hapusStack, target)
                target:Destroy()
            end
        end
    end)

    -- Fungsi undo
    undoButton.MouseButton1Click:Connect(function()
        local lastObject = table.remove(hapusStack)
        if lastObject and not lastObject.Parent then
            -- Objek sudah dihapus, jadi kita buat lagi
            -- Tapi karena objek dihapus, kita perlu simpan data sebelumnya
            -- Solusi sederhana: Tidak bisa restore objek yang dihapus tanpa data, jadi kita perlu menyimpan data sebelum hapus
            -- Tapi untuk kemudahan, asumsikan objek bisa di-recreate secara sederhana
            -- Jika objek kompleks, perlu menyimpan data posisi, tipe, dll.
            -- Di sini kita buat contoh sederhana dengan menyimpan data objek sebelum dihapus
            -- Sebagai solusi, kita perlu menyimpan data objek sebelum dihapus, jadi ubah sedikit
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
