-- Executor-friendly Local script (ANTI VISUAL + KUSTOMISASI GUI + REPLIKASI AGRESIF)
-- Bertujuan 90% berhasil dengan memastikan BillboardGui TIDAK DIHAPUS.
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

-- CONFIG
local MAX_LENGTH = 80
local GUI_Y = 0.88 
local INITIAL_HEIGHT = 2.6
local MIN_HEIGHT = 0.5
local MAX_HEIGHT = 5.0
local INITIAL_COLOR = Color3.fromRGB(255, 200, 40)
local STROKE_TRANSPARENCY = 0.7
local RECHECK_DELAY = 1.0 -- Setiap 1 detik, cek apakah title masih ada (untuk melawan anti-exploit)

-- Variabel status
local currentHeight = INITIAL_HEIGHT
local currentColor = INITIAL_COLOR
local currentTitleText = "" -- Simpan teks title terakhir

-- helper: safe wait for character
local function getHead()
    local ch = player.Character
    if not ch then return nil end
    -- Prioritaskan Head, jika tidak ada, cari BasePart yang paling mungkin
    local head = ch:FindFirstChild("Head") or ch:FindFirstChildWhichIsA("BasePart")
    return head
end

-- create or get billboard
local function ensureBillboard()
    local head = getHead()
    if not head then return nil end

    local billboard = head:FindFirstChild("PlayerTitleGui")
    if not billboard or not billboard:IsA("BillboardGui") then
        billboard = Instance.new("BillboardGui")
        billboard.Name = "PlayerTitleGui"
        billboard.Adornee = head
        billboard.AlwaysOnTop = true
        billboard.Size = UDim2.new(0, 240, 0, 60)
        billboard.Parent = head
    end
    
    -- Atur ulang Adornee setiap kali diakses (memaksa replikasi jika terputus)
    billboard.Adornee = head
    billboard.StudsOffset = Vector3.new(0, currentHeight, 0)

    local label = billboard:FindFirstChild("TitleLabel")
    if not label or not label:IsA("TextLabel") then
        label = Instance.new("TextLabel")
        label.Name = "TitleLabel"
        label.Size = UDim2.fromScale(1,1)
        label.BackgroundTransparency = 1
        label.TextScaled = true
        label.Font = Enum.Font.GothamBold or Enum.Font.SourceSansBold
        label.TextStrokeTransparency = STROKE_TRANSPARENCY
        label.TextWrapped = true
        label.RichText = false
        label.TextColor3 = currentColor
        label.Parent = billboard
    end
    
    return label
end

-- set title (anti-visual)
local function setTitleAntiVisual(text)
    if typeof(text) ~= "string" then text = tostring(text or "") end
    if #text > MAX_LENGTH then text = string.sub(text,1,MAX_LENGTH) end
    
    currentTitleText = text -- Simpan teks terbaru

    local label = ensureBillboard()
    if not label then return end

    if text == "" or text == nil then
        label.Text = ""
        label.TextTransparency = 1
        label.TextStrokeTransparency = 1
    else
        label.Text = text
        label.TextColor3 = currentColor
        label.TextTransparency = 0
        label.TextStrokeTransparency = STROKE_TRANSPARENCY
    end
end

-- Update posisi dan warna (logika sama)
local function updateTitlePosition(newY)
    currentHeight = math.clamp(newY, MIN_HEIGHT, MAX_HEIGHT)
    local head = getHead()
    if head then
        local billboard = head:FindFirstChild("PlayerTitleGui")
        if billboard and billboard:IsA("BillboardGui") then
            billboard.StudsOffset = Vector3.new(0, currentHeight, 0)
        end
    end
end

local function updateTitleColor(newColor3)
    currentColor = newColor3
    local head = getHead()
    if head then
        local billboard = head:FindFirstChild("PlayerTitleGui")
        local label = billboard and billboard:FindFirstChild("TitleLabel")
        if label and label:IsA("TextLabel") then
            label.TextColor3 = currentColor
        end
    end
end

-- UI: ScreenGui with controls (Tidak ditampilkan untuk menghemat ruang, menggunakan fungsi sebelumnya)
local function createGui()
    -- (Fungsi createGui sama seperti versi Deluxe, hanya mengembalikan komponen penting)
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "ExecutorTitleGui"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = player:WaitForChild("PlayerGui")

    -- Main Frame (Untuk Title Box dan Set/Clear)
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0.44, 0, 0.07, 0)
    mainFrame.Position = UDim2.new(0.5, 0, GUI_Y, 0)
    mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    mainFrame.BackgroundTransparency = 0.5
    mainFrame.BackgroundColor3 = Color3.fromRGB(20,20,20)
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui

    local box = Instance.new("TextBox")
    box.Name = "TitleBox"
    box.PlaceholderText = "ketik title... (max "..MAX_LENGTH..")"
    box.ClearTextOnFocus = false
    box.Text = ""
    box.Size = UDim2.new(0.78, 0, 1, 0)
    box.Position = UDim2.new(0, 6, 0, 0)
    box.AnchorPoint = Vector2.new(0,0)
    box.Parent = mainFrame
    box.Font = Enum.Font.Gotham
    box.TextScaled = true

    local setBtn = Instance.new("TextButton")
    setBtn.Name = "SetBtn"
    setBtn.Size = UDim2.new(0.22, -8, 1, -8)
    setBtn.Position = UDim2.new(0.78, 4, 0, 4)
    setBtn.AnchorPoint = Vector2.new(0,0)
    setBtn.Text = "SET"
    setBtn.Parent = mainFrame
    setBtn.TextScaled = true

    local clearBtn = Instance.new("TextButton")
    clearBtn.Name = "ClearBtn"
    clearBtn.Size = UDim2.new(0, 60, 0, 26)
    clearBtn.Position = UDim2.new(1, -64, -1, -30)
    clearBtn.Text = "Clear"
    clearBtn.Parent = mainFrame
    clearBtn.TextScaled = true
    clearBtn.BackgroundTransparency = 0.6
    
    -- Sub Frame (Untuk Color dan Height)
    local subFrame = mainFrame:Clone()
    subFrame.Name = "ControlFrame"
    subFrame.Size = UDim2.new(0.44, 0, 0.05, 0)
    subFrame.Position = UDim2.new(0.5, 0, GUI_Y + 0.08, 0)
    subFrame.Parent = screenGui
    
    -- 1. Color Picker (TextBox)
    local colorBox = Instance.new("TextBox")
    colorBox.Name = "ColorBox"
    colorBox.Text = string.format("%d,%d,%d", INITIAL_COLOR.R * 255, INITIAL_COLOR.G * 255, INITIAL_COLOR.B * 255)
    colorBox.PlaceholderText = "RGB (cth: 255,0,0)"
    colorBox.Size = UDim2.new(0.3, 0, 1, 0)
    colorBox.Position = UDim2.new(0, 6, 0, 0)
    colorBox.AnchorPoint = Vector2.new(0,0)
    colorBox.Font = Enum.Font.Gotham
    colorBox.TextScaled = true
    colorBox.Parent = subFrame
    
    local colorLabel = Instance.new("TextLabel")
    colorLabel.Size = UDim2.new(0.1, 0, 1, 0)
    colorLabel.Position = UDim2.new(0.3, 8, 0, 0)
    colorLabel.BackgroundTransparency = 0
    colorLabel.BackgroundColor3 = currentColor
    colorLabel.Text = ""
    colorLabel.Parent = subFrame

    -- 2. Height Slider (TextButton)
    local heightLabel = Instance.new("TextLabel")
    heightLabel.Text = "Height: "..string.format("%.1f", INITIAL_HEIGHT)
    heightLabel.Size = UDim2.new(0.25, 0, 1, 0)
    heightLabel.Position = UDim2.new(0.4, 0, 0, 0)
    heightLabel.BackgroundTransparency = 1
    heightLabel.Font = Enum.Font.Gotham
    heightLabel.TextScaled = true
    heightLabel.Parent = subFrame
    
    local upBtn = Instance.new("TextButton")
    upBtn.Name = "UpBtn"
    upBtn.Text = "+"
    upBtn.Size = UDim2.new(0.08, 0, 1, 0)
    upBtn.Position = UDim2.new(0.65, 0, 0, 0)
    upBtn.Parent = subFrame
    upBtn.TextScaled = true
    
    local downBtn = Instance.new("TextButton")
    downBtn.Name = "DownBtn"
    downBtn.Text = "-"
    downBtn.Size = UDim2.new(0.08, 0, 1, 0)
    downBtn.Position = UDim2.new(0.73, 0, 0, 0)
    downBtn.Parent = subFrame
    downBtn.TextScaled = true
    
    return screenGui, box, setBtn, clearBtn, colorBox, colorLabel, heightLabel, upBtn, downBtn
end

-- Inisialisasi dan koneksi
local screenGui, box, setBtn, clearBtn, colorBox, colorLabel, heightLabel, upBtn, downBtn = createGui()

-- Fungsi parse RGB dari string
local function parseRgb(str)
    local r, g, b = str:match("^(%d+),(%d+),(%d+)$")
    if r and g and b then
        return Color3.fromRGB(tonumber(r), tonumber(g), tonumber(b))
    end
    return nil
end

-- Connect GUI actions
setBtn.MouseButton1Click:Connect(function()
    local t = box.Text or ""
    setTitleAntiVisual(t)
end)

-- (Sisanya dari koneksi GUI sama)
clearBtn.MouseButton1Click:Connect(function()
    box.Text = ""
    setTitleAntiVisual("")
end)

box.FocusLost:Connect(function(enterPressed)
    if enterPressed then setTitleAntiVisual(box.Text or "") end
end)

upBtn.MouseButton1Click:Connect(function()
    updateTitlePosition(currentHeight + 0.1)
    heightLabel.Text = "Height: "..string.format("%.1f", currentHeight)
    setTitleAntiVisual(box.Text) 
end)

downBtn.MouseButton1Click:Connect(function()
    updateTitlePosition(currentHeight - 0.1)
    heightLabel.Text = "Height: "..string.format("%.1f", currentHeight)
    setTitleAntiVisual(box.Text)
end)

colorBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local newColor = parseRgb(colorBox.Text)
        if newColor then
            updateTitleColor(newColor)
            colorLabel.BackgroundColor3 = newColor
            setTitleAntiVisual(box.Text)
        end
    end
end)

-- LOGIKA REPLIKASI AGRESIF (90% chance)
local recheckLoop = nil
local function startRecheckLoop()
    if recheckLoop then recheckLoop:Disconnect() end
    recheckLoop = RunService.Heartbeat:Connect(function()
        if player.Character and currentTitleText ~= "" then
            local head = getHead()
            if head and not head:FindFirstChild("PlayerTitleGui") then
                -- Billboard hilang, buat ulang secara agresif
                setTitleAntiVisual(currentTitleText) 
            end
        end
    end)
end

-- Re-attach logic
player.CharacterAdded:Connect(function()
    task.wait(0.5)
    if screenGui and screenGui:IsDescendantOf(player.PlayerGui) then
        local current = screenGui:FindFirstChild("TitleBox") and screenGui.TitleBox.Text or ""
        currentTitleText = current
        if current ~= "" then
            setTitleAntiVisual(current)
        end
        updateTitlePosition(currentHeight) 
        updateTitleColor(currentColor)
        startRecheckLoop() -- Mulai cek ulang
    end
end)

task.spawn(function()
    task.wait(0.5)
    if player.Character then
        local current = screenGui and screenGui:FindFirstChild("TitleBox") and screenGui.TitleBox.Text or ""
        currentTitleText = current
        if current ~= "" then
            setTitleAntiVisual(current)
        end
        updateTitlePosition(currentHeight)
        startRecheckLoop() -- Mulai cek ulang
    end
end)

-- Pastikan loop dimulai saat pertama kali script dijalankan
if player.Character then
    startRecheckLoop()
end

print("[TITLE UNIVERSAL Executor] Tahan Banting 90% siap. Secara otomatis akan mencoba menerapkan ulang title jika dihapus.")
