--// BYNZZBPONJON FINAL CLEAN READY TO USE //--

local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- checkpoints
local checkpoints = {
    {name="Basecamp", pos=Vector3.new(-883.288,43.358,933.698)},
    {name="CP1", pos=Vector3.new(-473.240,49.167,624.194)},
    {name="CP2", pos=Vector3.new(-182.927,52.412,691.074)},
    {name="CP3", pos=Vector3.new(122.499,202.548,951.741)},
    {name="CP4", pos=Vector3.new(10.684,194.377,340.400)},
    {name="CP5", pos=Vector3.new(244.394,194.369,114.069)},
    {name="CP6", pos=Vector3.new(271.317,144.032,50.203)},
    {name="CP7", pos=Vector3.new(170.720,242.815,28.204)},
    {name="CP8", pos=Vector3.new(42.216,170.219,29.892)},
    {name="Fin", pos=Vector3.new(-104.843,132.289,313.375)},
}

-- variabel untuk mengaktifkan / menonaktifkan visibilitas bagian bawah
local hidden = false

-- Fungsi untuk toggle visibilitas bagian bawah
local function toggleVisibility()
    hidden = not hidden
    for _,v in pairs(main:GetChildren()) do
        if v ~= header then
            v.Visible = not hidden
        end
    end
    task.wait(0.3)
    hideBtn.Text = hidden and "Show" or "Hide"
end

-- Event klik tombol hide/show
local main = playerGui:WaitForChild("Main")
local header = main:WaitForChild("Header")
local hideBtn = main:WaitForChild("HideBtn")
hideBtn.MouseButton1Click:Connect(toggleVisibility)

-- Script utama lainnya (misalnya untuk tombol submit dan lainnya)
local submitBtn = main:WaitForChild("SubmitBtn")
submitBtn.MouseButton1Click:Connect(function()
    local inputText = main:WaitForChild("InputBox").Text
    -- proses lainnya sesuai script kamu
    -- misalnya menampilkan pesan, mengupdate GUI, dll.
end)

-- Tambahkan kode lain sesuai script
