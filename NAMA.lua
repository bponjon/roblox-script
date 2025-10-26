-- MountBingung — Server-Sided Mimic Name dengan GUI (FULL EXECUTE)
-- Kode ini HANYA perlu dijalankan di executor Anda.
-- Tujuannya agar nama samaran terlihat oleh semua pemain (jika game rentan).

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer

-- --- 1. SETUP KOMUNIKASI SERVER ---
local EVENT_NAME = "GlobalNameMimicEvent"
local MIMIC_EVENT = ReplicatedStorage:FindFirstChild(EVENT_NAME)
if not MIMIC_EVENT then
    MIMIC_EVENT = Instance.new("RemoteEvent")
    MIMIC_EVENT.Name = EVENT_NAME
    MIMIC_EVENT.Parent = ReplicatedStorage
    print("RemoteEvent '"..EVENT_NAME.."' created.")
end

-- --- 2. FUNGSI INJEKSI SERVER SCRIPT (Hanya Dijalankan Saat Execute) ---

local function createServerScript()
    local serverScript = Instance.new("Script")
    serverScript.Name = "GlobalMimicNameServerLogic"
    serverScript.Source = [[
        local Players = game:GetService("Players")
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local MIMIC_EVENT = ReplicatedStorage:WaitForChild("GlobalNameMimicEvent")

        -- Config Tag Nama (Dilihat Semua Orang)
        local TEXT_COLOR = Color3.fromRGB(150, 255, 150)
        local TEXT_SIZE = 22
        local OFFSET = Vector3.new(0, 2.4, 0)
        local TAG_NAME = "CustomGlobalNameTag"
        
        local function cleanDefaultTag(head)
            local defaultTag = head:FindFirstChild("Name")
            if defaultTag and defaultTag:IsA("BillboardGui") then
                defaultTag:Destroy()
            end
        end

        local function createGlobalNameBillboard(char, text)
            if not char or not char:FindFirstChild("Head") then return end
            local head = char.Head

            local existing = head:FindFirstChild(TAG_NAME)
            if existing then existing:Destroy() end
            
            cleanDefaultTag(head)

            if not text or text == "" then return end

            local billboard = Instance.new("BillboardGui")
            billboard.Name = TAG_NAME
            billboard.Adornee = head
            billboard.AlwaysOnTop = true
            billboard.Size = UDim2.new(0,200,0,50)
            billboard.StudsOffset = OFFSET
            billboard.Parent = head

            local label = Instance.new("TextLabel", billboard)
            label.Size = UDim2.new(1,0,1,0)
            label.BackgroundTransparency = 1
            label.Text = text
            label.Font = Enum.Font.GothamBold
            label.TextSize = TEXT_SIZE
            label.TextWrapped = true
            label.TextYAlignment = Enum.TextYAlignment.Center
            label.TextXAlignment = Enum.TextXAlignment.Center
            label.TextColor3 = TEXT_COLOR
            label.RichText = false
        end

        MIMIC_EVENT.OnServerEvent:Connect(function(requester, text)
            if requester and requester.Character then
                createGlobalNameBillboard(requester.Character, text)
            end
        end)
        
        Players.PlayerAdded:Connect(function(newPlayer)
            newPlayer.CharacterAdded:Connect(function(char)
                local head = char:FindFirstChild("Head")
                if head then
                    cleanDefaultTag(head)
                end
            end)
        end)

        print("[Server Logic] Global Mimic Name Logic berjalan.")
    ]]

    -- Injeksi skrip server melalui Client-Executor
    local ServerScriptService = game:GetService("ServerScriptService")
    serverScript.Parent = ServerScriptService
    print("Server Script 'GlobalMimicNameServerLogic' diinjeksikan.")
end

createServerScript()

-- --- 3. KODE KLIEN (Fungsi dan GUI) ---
local currentText = player.Name
local function applyMimic(text)
    currentText = text
    -- Kirim permintaan ke Server via RemoteEvent
    MIMIC_EVENT:FireServer(currentText)
    print("[Client] Mengirim permintaan nama samaran: " .. currentText)
end

local function disableMimic()
    currentText = ""
    MIMIC_EVENT:FireServer("") 
    print("[Client] Mengirim permintaan menonaktifkan Tag Nama.")
end

-- --- GUI ---
local screen = Instance.new("ScreenGui")
screen.Name = "GlobalMimicNameGUI"
screen.ResetOnSpawn = false
screen.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame", screen)
frame.Size = UDim2.new(0,300,0,120)
frame.Position = UDim2.new(0.05,0,0.2,0)
frame.BackgroundColor3 = Color3.fromRGB(30,4,40)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.AnchorPoint = Vector2.new(0,0)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, -40, 0, 28)
title.Position = UDim2.new(0, 10, 0, 6)
title.BackgroundTransparency = 1
title.Text = "Mimic Name (GLOBAL ATTEMPT)"
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.TextColor3 = Color3.fromRGB(230,230,255)
title.TextXAlignment = Enum.TextXAlignment.Left

local closeBtn = Instance.new("TextButton", frame)
closeBtn.Size = UDim2.new(0,32,0,28)
closeBtn.Position = UDim2.new(1,-38,0,6)
closeBtn.Text = "X"
closeBtn.Font = Enum.Font.SourceSansBold
closeBtn.TextSize = 14
closeBtn.BackgroundColor3 = Color3.fromRGB(130,10,10)
closeBtn.TextColor3 = Color3.fromRGB(255,255,255)
closeBtn.MouseButton1Click:Connect(function()
    disableMimic() 
    screen:Destroy() 
end)

local inputBox = Instance.new("TextBox", frame)
inputBox.Size = UDim2.new(1, -20, 0, 40)
inputBox.Position = UDim2.new(0, 10, 0, 42)
inputBox.PlaceholderText = "Nama samaran dilihat semua orang..."
inputBox.ClearTextOnFocus = false
inputBox.Text = ""
inputBox.Font = Enum.Font.SourceSans
inputBox.TextSize = 14
inputBox.TextColor3 = Color3.fromRGB(240,240,240)
inputBox.BackgroundColor3 = Color3.fromRGB(20,10,25)
inputBox.BorderSizePixel = 0

local btnApply = Instance.new("TextButton", frame)
btnApply.Size = UDim2.new(0.48, -8, 0, 26)
btnApply.Position = UDim2.new(0, 10, 1, -36)
btnApply.Text = "Apply Global"
btnApply.Font = Enum.Font.GothamBold
btnApply.TextSize = 14
btnApply.BackgroundColor3 = Color3.fromRGB(0, 95, 0)
btnApply.TextColor3 = Color3.fromRGB(255,255,255)

local btnDisable = Instance.new("TextButton", frame)
btnDisable.Size = UDim2.new(0.48, -8, 0, 26)
btnDisable.Position = UDim2.new(0.52, 0, 1, -36)
btnDisable.Text = "Disable"
btnDisable.Font = Enum.Font.GothamBold
btnDisable.TextSize = 14
btnDisable.BackgroundColor3 = Color3.fromRGB(90,10,10)
btnDisable.TextColor3 = Color3.fromRGB(255,255,255)

-- Koneksi Event
btnApply.MouseButton1Click:Connect(function()
    local text = tostring(inputBox.Text):gsub("\n","")
    if text == "" then
        text = player.Name
    end
    applyMimic(text)
end)

btnDisable.MouseButton1Click:Connect(function()
    disableMimic()
end)

inputBox.FocusLost:Connect(function(enter)
    if enter then
        local text = tostring(inputBox.Text):gsub("\n","")
        if text == "" then text = player.Name end
        applyMimic(text)
    end
end)

print("[MimicName Global/GUI] Semua kode telah dimuat. Cek apakah injeksi berhasil.")
