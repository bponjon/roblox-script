-- REMOTE SCANNER - ANALISA GAME
-- Scan semua RemoteEvent untuk cari celah
-- BAHASA INDONESIA

task.wait(2)

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui", 10)

if not playerGui then return end

if playerGui:FindFirstChild("ScannerGUI") then
    playerGui.ScannerGUI:Destroy()
    task.wait(0.5)
end

-- ============================================
-- NOTIFICATION
-- ============================================
local function notif(msg)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Scanner";
            Text = msg;
            Duration = 3;
        })
    end)
    print("[Scanner]", msg)
end

-- ============================================
-- SCAN FUNCTION
-- ============================================
local allRemotes = {}
local categorizedRemotes = {
    VIP = {},
    Purchase = {},
    Shop = {},
    Gamepass = {},
    Reward = {},
    Admin = {},
    Player = {},
    Other = {}
}

local function scanRemotes()
    allRemotes = {}
    categorizedRemotes = {
        VIP = {},
        Purchase = {},
        Shop = {},
        Gamepass = {},
        Reward = {},
        Admin = {},
        Player = {},
        Other = {}
    }
    
    notif("🔍 Scanning remotes...")
    
    -- Scan ReplicatedStorage
    for _, obj in pairs(ReplicatedStorage:GetDescendants()) do
        if obj:IsA("RemoteEvent") then
            table.insert(allRemotes, obj)
            
            -- Categorize
            local name = obj.Name:lower()
            local path = obj:GetFullName()
            
            if name:find("vip") or name:find("premium") then
                table.insert(categorizedRemotes.VIP, path)
            elseif name:find("gamepass") or name:find("pass") then
                table.insert(categorizedRemotes.Gamepass, path)
            elseif name:find("purchase") or name:find("buy") or name:find("shop") then
                table.insert(categorizedRemotes.Purchase, path)
            elseif name:find("shop") or name:find("store") then
                table.insert(categorizedRemotes.Shop, path)
            elseif name:find("reward") or name:find("claim") or name:find("daily") then
                table.insert(categorizedRemotes.Reward, path)
            elseif name:find("admin") or name:find("command") then
                table.insert(categorizedRemotes.Admin, path)
            elseif name:find("player") or name:find("character") then
                table.insert(categorizedRemotes.Player, path)
            else
                table.insert(categorizedRemotes.Other, path)
            end
        end
    end
    
    -- Scan Workspace
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("RemoteEvent") then
            table.insert(allRemotes, obj)
            table.insert(categorizedRemotes.Other, obj:GetFullName())
        end
    end
    
    -- Print results
    print("\n" .. string.rep("=", 50))
    print("REMOTE SCANNER RESULTS")
    print(string.rep("=", 50))
    print("Game:", game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name)
    print("PlaceId:", game.PlaceId)
    print("Total Remotes Found:", #allRemotes)
    print(string.rep("=", 50))
    
    -- Print by category
    for category, remotes in pairs(categorizedRemotes) do
        if #remotes > 0 then
            print("\n[" .. category .. "] - " .. #remotes .. " remotes:")
            for i, path in ipairs(remotes) do
                print("  " .. i .. ". " .. path)
            end
        end
    end
    
    print("\n" .. string.rep("=", 50))
    print("ALL REMOTES (Full List):")
    print(string.rep("=", 50))
    for i, remote in ipairs(allRemotes) do
        print(i .. ". " .. remote:GetFullName())
    end
    print(string.rep("=", 50) .. "\n")
    
    -- Summary
    local summary = string.format([[
📊 SCAN SUMMARY:
━━━━━━━━━━━━━━━━━━━━━
Total: %d remotes
VIP/Premium: %d
Gamepass: %d
Purchase/Shop: %d
Reward/Claim: %d
Admin: %d
━━━━━━━━━━━━━━━━━━━━━

✅ Scan selesai!
📋 Lihat console (F9) untuk detail
]], #allRemotes, #categorizedRemotes.VIP, #categorizedRemotes.Gamepass, 
    #categorizedRemotes.Purchase + #categorizedRemotes.Shop, 
    #categorizedRemotes.Reward, #categorizedRemotes.Admin)
    
    print(summary)
    notif("Found " .. #allRemotes .. " remotes! Check F9")
    
    return #allRemotes
end

-- ============================================
-- ANALYSIS FUNCTION
-- ============================================
local function analyzeForVIP()
    print("\n" .. string.rep("=", 50))
    print("VIP/GAMEPASS ANALYSIS")
    print(string.rep("=", 50))
    
    local vipRemotes = {}
    
    -- Check VIP category
    if #categorizedRemotes.VIP > 0 then
        print("\n✅ FOUND VIP REMOTES:")
        for _, path in ipairs(categorizedRemotes.VIP) do
            print("  → " .. path)
            table.insert(vipRemotes, path)
        end
    end
    
    -- Check Gamepass category
    if #categorizedRemotes.Gamepass > 0 then
        print("\n✅ FOUND GAMEPASS REMOTES:")
        for _, path in ipairs(categorizedRemotes.Gamepass) do
            print("  → " .. path)
            table.insert(vipRemotes, path)
        end
    end
    
    -- Check Purchase/Shop
    if #categorizedRemotes.Purchase > 0 or #categorizedRemotes.Shop > 0 then
        print("\n💰 PURCHASE/SHOP REMOTES:")
        for _, path in ipairs(categorizedRemotes.Purchase) do
            print("  → " .. path)
        end
        for _, path in ipairs(categorizedRemotes.Shop) do
            print("  → " .. path)
        end
    end
    
    if #vipRemotes > 0 then
        print("\n" .. string.rep("=", 50))
        print("🎯 POTENTIAL VIP BYPASS TARGETS:")
        print(string.rep("=", 50))
        for i, path in ipairs(vipRemotes) do
            print(i .. ". " .. path)
        end
        print(string.rep("=", 50))
        notif("Found " .. #vipRemotes .. " VIP targets!")
    else
        print("\n❌ No obvious VIP/Gamepass remotes found")
        print("Check 'Other' category or full list")
        notif("No VIP remotes found - check full list")
    end
    
    print("\n")
end

-- ============================================
-- EXPORT FUNCTION
-- ============================================
local function exportToClipboard()
    local export = "=== REMOTE EXPORT ===\n"
    export = export .. "Game: " .. game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name .. "\n"
    export = export .. "PlaceId: " .. game.PlaceId .. "\n"
    export = export .. "Total: " .. #allRemotes .. " remotes\n\n"
    
    for category, remotes in pairs(categorizedRemotes) do
        if #remotes > 0 then
            export = export .. "[" .. category .. "]:\n"
            for i, path in ipairs(remotes) do
                export = export .. i .. ". " .. path .. "\n"
            end
            export = export .. "\n"
        end
    end
    
    -- Copy to clipboard (if supported)
    pcall(function()
        setclipboard(export)
        notif("✅ Copied to clipboard!")
    end)
    
    print(export)
end

-- ============================================
-- CREATE GUI
-- ============================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ScannerGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = playerGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 350, 0, 380)
MainFrame.Position = UDim2.new(0.5, -175, 0.5, -190)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 12)
Corner.Parent = MainFrame

-- Header
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 50)
Header.BackgroundColor3 = Color3.fromRGB(0, 120, 200)
Header.BorderSizePixel = 0
Header.Parent = MainFrame

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 12)
HeaderCorner.Parent = Header

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -60, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "🔍 REMOTE SCANNER"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 45, 0, 45)
CloseBtn.Position = UDim2.new(1, -48, 0, 2.5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 20
CloseBtn.Parent = Header

local CloseBtnCorner = Instance.new("UICorner")
CloseBtnCorner.CornerRadius = UDim.new(0, 8)
CloseBtnCorner.Parent = CloseBtn

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Content
local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -30, 1, -65)
Content.Position = UDim2.new(0, 15, 0, 55)
Content.BackgroundTransparency = 1
Content.Parent = MainFrame

-- Scan Button
local ScanBtn = Instance.new("TextButton")
ScanBtn.Size = UDim2.new(1, 0, 0, 60)
ScanBtn.Position = UDim2.new(0, 0, 0, 0)
ScanBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 200)
ScanBtn.Text = "🔍 SCAN REMOTES"
ScanBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ScanBtn.Font = Enum.Font.GothamBold
ScanBtn.TextSize = 20
ScanBtn.Parent = Content

local ScanBtnCorner = Instance.new("UICorner")
ScanBtnCorner.CornerRadius = UDim.new(0, 10)
ScanBtnCorner.Parent = ScanBtn

ScanBtn.MouseButton1Click:Connect(function()
    scanRemotes()
end)

-- Analyze VIP Button
local AnalyzeBtn = Instance.new("TextButton")
AnalyzeBtn.Size = UDim2.new(1, 0, 0, 55)
AnalyzeBtn.Position = UDim2.new(0, 0, 0, 70)
AnalyzeBtn.BackgroundColor3 = Color3.fromRGB(150, 100, 200)
AnalyzeBtn.Text = "🎯 ANALYZE FOR VIP"
AnalyzeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
AnalyzeBtn.Font = Enum.Font.GothamBold
AnalyzeBtn.TextSize = 18
AnalyzeBtn.Parent = Content

local AnalyzeBtnCorner = Instance.new("UICorner")
AnalyzeBtnCorner.CornerRadius = UDim.new(0, 10)
AnalyzeBtnCorner.Parent = AnalyzeBtn

AnalyzeBtn.MouseButton1Click:Connect(function()
    if #allRemotes == 0 then
        notif("Scan dulu!")
    else
        analyzeForVIP()
    end
end)

-- Export Button
local ExportBtn = Instance.new("TextButton")
ExportBtn.Size = UDim2.new(1, 0, 0, 50)
ExportBtn.Position = UDim2.new(0, 0, 0, 135)
ExportBtn.BackgroundColor3 = Color3.fromRGB(100, 150, 100)
ExportBtn.Text = "📋 COPY TO CLIPBOARD"
ExportBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ExportBtn.Font = Enum.Font.GothamBold
ExportBtn.TextSize = 16
ExportBtn.Parent = Content

local ExportBtnCorner = Instance.new("UICorner")
ExportBtnCorner.CornerRadius = UDim.new(0, 10)
ExportBtnCorner.Parent = ExportBtn

ExportBtn.MouseButton1Click:Connect(function()
    if #allRemotes == 0 then
        notif("Scan dulu!")
    else
        exportToClipboard()
    end
end)

-- Info
local Info = Instance.new("TextLabel")
Info.Size = UDim2.new(1, 0, 0, 120)
Info.Position = UDim2.new(0, 0, 1, -120)
Info.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Info.TextColor3 = Color3.fromRGB(200, 200, 200)
Info.Font = Enum.Font.Gotham
Info.TextSize = 12
Info.TextWrapped = true
Info.TextYAlignment = Enum.TextYAlignment.Top
Info.Text = [[🔍 REMOTE SCANNER

Cara pakai:
1. Klik "SCAN REMOTES"
2. Klik "ANALYZE FOR VIP"
3. Buka console (F9)
4. Copy list remotes
5. Kirim ke chat

Otomatis categorize:
• VIP/Premium
• Gamepass
• Purchase/Shop
• Reward/Claim
• Admin remotes]]
Info.Parent = Content

local InfoPadding = Instance.new("UIPadding")
InfoPadding.PaddingTop = UDim.new(0, 8)
InfoPadding.PaddingLeft = UDim.new(0, 8)
InfoPadding.PaddingRight = UDim.new(0, 8)
InfoPadding.Parent = Info

local InfoCorner = Instance.new("UICorner")
InfoCorner.CornerRadius = UDim.new(0, 8)
InfoCorner.Parent = Info

notif("🔍 Scanner ready!")
print("================================")
print("REMOTE SCANNER")
print("Klik 'SCAN REMOTES' untuk mulai")
print("================================")
