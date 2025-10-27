-- ===== MountGemini AutoSummit (Basecamp + Puncak only) =====
local player = game.Players.LocalPlayer

-- ===== Checkpoints (hanya Basecamp & Puncak) =====
local checkpoints = {
    {name="Basecamp", pos=Vector3.new(1272.160, 639.021, 1792.852)},
    {name="Puncak",  pos=Vector3.new(-6652.260, 3151.055, -796.739)}
}

-- ===== GUI Setup =====
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "YahyukTeleport" -- atau nama yang lo mau
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,260,0,160)
frame.Position = UDim2.new(0.05,0,0.12,0)
frame.BackgroundColor3 = Color3.fromRGB(50,0,50) -- ungu tua
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, -10, 0, 28)
title.Position = UDim2.new(0,5,0,6)
title.BackgroundTransparency = 1
title.Text = "Yahyuk Teleport"
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextColor3 = Color3.fromRGB(240,240,240)
title.TextXAlignment = Enum.TextXAlignment.Left

local closeBtn = Instance.new("TextButton", frame)
closeBtn.Text = "X"
closeBtn.Size = UDim2.new(0,32,0,28)
closeBtn.Position = UDim2.new(1,-38,0,6)
closeBtn.BackgroundColor3 = Color3.fromRGB(150,0,0)
closeBtn.TextColor3 = Color3.fromRGB(255,255,255)
closeBtn.MouseButton1Click:Connect(function() gui.Enabled = false end)

local hideBtn = Instance.new("TextButton", frame)
hideBtn.Text = "Hide"
hideBtn.Size = UDim2.new(0,56,0,26)
hideBtn.Position = UDim2.new(0,6,0,38)
hideBtn.BackgroundColor3 = Color3.fromRGB(20,20,20)
hideBtn.TextColor3 = Color3.fromRGB(255,255,255)

local logo = Instance.new("TextButton", gui)
logo.Size = UDim2.new(0,46,0,46)
logo.Position = UDim2.new(0.9,0,0.12,0)
logo.Text = "🚀"
logo.Font = Enum.Font.SourceSans
logo.Visible = false
logo.Active = true
logo.Draggable = true

hideBtn.MouseButton1Click:Connect(function()
    frame.Visible = false
    logo.Visible = true
end)
logo.MouseButton1Click:Connect(function()
    frame.Visible = true
    logo.Visible = false
end)

-- Buttons: Basecamp + Puncak (manual)
local baseBtn = Instance.new("TextButton", frame)
baseBtn.Size = UDim2.new(0.45, -6, 0, 36)
baseBtn.Position = UDim2.new(0.02, 0, 0, 72)
baseBtn.Text = "Basecamp"
baseBtn.BackgroundColor3 = Color3.fromRGB(30,0,30)
baseBtn.TextColor3 = Color3.fromRGB(255,255,255)

local puncakBtn = Instance.new("TextButton", frame)
puncakBtn.Size = UDim2.new(0.45, -6, 0, 36)
puncakBtn.Position = UDim2.new(0.53, 0, 0, 72)
puncakBtn.Text = "Puncak"
puncakBtn.BackgroundColor3 = Color3.fromRGB(30,0,30)
puncakBtn.TextColor3 = Color3.fromRGB(255,255,255)

-- AutoSummit + Stop
local autoBtn = Instance.new("TextButton", frame)
autoBtn.Size = UDim2.new(0.65, 0, 0, 34)
autoBtn.Position = UDim2.new(0.02, 0, 0, 114)
autoBtn.Text = "AutoSummit"
autoBtn.BackgroundColor3 = Color3.fromRGB(60,0,60)
autoBtn.TextColor3 = Color3.fromRGB(255,255,255)

local stopBtn = Instance.new("TextButton", frame)
stopBtn.Size = UDim2.new(0.31, 0, 0, 34)
stopBtn.Position = UDim2.new(0.67, 0, 0, 114)
stopBtn.Text = "Stop"
stopBtn.BackgroundColor3 = Color3.fromRGB(120,0,0)
stopBtn.TextColor3 = Color3.fromRGB(255,255,255)

-- Teleport functions
local function tpTo(pos)
    if player.Character and player.Character.PrimaryPart then
        pcall(function() player.Character:SetPrimaryPartCFrame(CFrame.new(pos)) end)
    end
end

baseBtn.MouseButton1Click:Connect(function() tpTo(checkpoints[1].pos) end)
puncakBtn.MouseButton1Click:Connect(function() tpTo(checkpoints[2].pos) end)

-- AutoSummit behavior: langsung mati saat sampai Puncak
local autoSummitActive = false
local function startAutoSummit()
    if autoSummitActive then return end
    autoSummitActive = true
    spawn(function()
        while autoSummitActive do
            for i = 1, #checkpoints do
                if not autoSummitActive then break end
                local cp = checkpoints[i]
                tpTo(cp.pos)
                -- sedikit tunda kecil supaya server/klien sempat proses posisi
                wait(0.6)
                -- jika ini puncak -> mati otomatis dan hentikan loop (atau tunggu respawn loop lagi)
                if cp.name == "Puncak" then
                    if player.Character then
                        pcall(function() player.Character:BreakJoints() end)
                    end
                    -- tunggu respawn agar loop bisa dijalankan lagi bila autoSummitActive masih true
                    player.CharacterAdded:Wait()
                    -- jika masih aktif, loop akan lanjut dari awal (basecamp)
                    break
                end
            end
            -- jika masih aktif, loop akan ulang (tele ke Basecamp lalu Puncak lagi)
        end
    end)
end

autoBtn.MouseButton1Click:Connect(startAutoSummit)
stopBtn.MouseButton1Click:Connect(function() autoSummitActive = false end)

-- safety print
print("[YahyukTeleport] siap. Hanya Basecamp & Puncak aktif. AutoSummit akan mati otomatis saat mencapai Puncak.")
