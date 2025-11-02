-- SCRIPT FINAL UNIVERSAL MOUNT/GUI ROBLOX

-- MAP CONFIG
local MAP_CONFIG = {
    ["94261028489288"] = {name="MOUNT KOHARU (21 CP)", checkpoints = {
        {name="Basecamp", pos=Vector3.new(-883.288,43.358,933.698)},
        {name="CP1", pos=Vector3.new(-473.240,49.167,624.194)},
        {name="CP2", pos=Vector3.new(-182.927,52.412,691.074)},
        {name="CP3", pos=Vector3.new(122.499,202.548,951.741)},
        {name="CP4", pos=Vector3.new(10.684,194.377,340.400)},
        {name="CP5", pos=Vector3.new(244.394,194.369,805.065)},
        {name="CP6", pos=Vector3.new(660.531,210.886,749.360)},
        {name="CP7", pos=Vector3.new(660.649,202.965,368.070)},
        {name="CP8", pos=Vector3.new(520.852,214.338,281.842)},
        {name="CP9", pos=Vector3.new(523.730,214.369,-333.936)},
        {name="CP10", pos=Vector3.new(561.610,211.787,-559.470)},
        {name="CP11", pos=Vector3.new(566.837,282.541,-924.107)},
        {name="CP12", pos=Vector3.new(115.198,286.309,-655.635)},
        {name="CP13", pos=Vector3.new(-308.343,410.144,-612.031)},
        {name="CP14", pos=Vector3.new(-487.722,522.666,-663.426)},
        {name="CP15", pos=Vector3.new(-679.093,482.701,-971.988)},
        {name="CP16", pos=Vector3.new(-559.058,258.369,-1318.780)},
        {name="CP17", pos=Vector3.new(-426.353,374.369,-1512.621)},
        {name="CP18", pos=Vector3.new(-984.797,635.003,-1621.875)},
        {name="CP19", pos=Vector3.new(-1394.228,797.455,-1563.855)},
        {name="Puncak", pos=Vector3.new(-1534.938,933.116,-2176.096)}
    }},
    ["140014177882408"] = {name="MOUNT GEMI (2 CP)", checkpoints = {
        {name="Basecamp", pos=Vector3.new(1269.030, 639.076, 1793.997)},
        {name="Puncak", pos=Vector3.new(-6665.046, 3151.532, -799.116)}
    }},
    ["127557455707420"] = {name="MOUNT JALUR TAKDIR (7 CP)", checkpoints = {
        {name="Basecamp", pos=Vector3.new(-942.227, 14.021, -954.444)},
        {name="CP1", pos=Vector3.new(-451.266, 78.021, -662.000)},
        {name="CP2", pos=Vector3.new(-484.121, 78.015, 119.971)},
        {name="CP3", pos=Vector3.new(576.478, 242.021, 852.784)},
        {name="CP4", pos=Vector3.new(779.530, 606.021, -898.384)},
        {name="CP5", pos=Vector3.new(-363.401, 1086.021, 705.354)},
        {name="Puncak", pos=Vector3.new(292.418, 1274.021, 374.069)}
    }},
    ["79272087242323"] = {name="MOUNT LIRVANA (22 CP)", checkpoints = {
        {name="CP0", pos=Vector3.new(-33.023, 86.149, 7.025)},
        {name="CP1", pos=Vector3.new(35.501, 200.700, -559.027)},
        {name="CP2", pos=Vector3.new(-381.037, 316.700, -560.712)},
        {name="CP3", pos=Vector3.new(-401.126, 456.700, -1014.478)},
        {name="CP4", pos=Vector3.new(-35.014, 548.700, -1028.476)},
        {name="CP5", pos=Vector3.new(-50.832, 542.149, -1371.412)},
        {name="CP6", pos=Vector3.new(-68.830, 582.149, -1615.556)},
        {name="CP7", pos=Vector3.new(262.292, 610.149, -1647.285)},
        {name="CP8", pos=Vector3.new(270.919, 678.149, -1378.510)},
        {name="CP9", pos=Vector3.new(278.914, 622.149, -1025.756)},
        {name="CP10", pos=Vector3.new(292.020, 638.149, -676.378)},
        {name="CP11", pos=Vector3.new(601.175, 678.149, -680.490)},
        {name="CP12", pos=Vector3.new(617.442, 626.149, -1028.689)},
        {name="CP13", pos=Vector3.new(600.942, 678.149, -1370.222)},
        {name="CP14", pos=Vector3.new(594.054, 670.149, -1626.474)},
        {name="CP15", pos=Vector3.new(917.511, 690.149, -1644.750)},
        {name="CP16", pos=Vector3.new(899.131, 702.149, -1362.030)},
        {name="CP17", pos=Vector3.new(971.016, 674.149, -941.262)},
        {name="CP18", pos=Vector3.new(880.015, 710.149, -675.175)},
        {name="CP19", pos=Vector3.new(1187.287, 694.149, -661.098)},
        {name="CP20", pos=Vector3.new(1187.453, 718.149, -332.297)},
        {name="Puncak", pos=Vector3.new(799.696, 1001.949, 207.303)}
    }},
    ["129916920179384"] = {name="MOUNT AHPAYAH (12 CP)", checkpoints = {
        {name="Basecamp", pos=Vector3.new(-405.208, 46.021, -540.538)},
        {name="CP1", pos=Vector3.new(-397.862, 46.386, -225.315)},
        {name="CP2", pos=Vector3.new(446.973, 310.386, -454.457)},
        {name="CP3", pos=Vector3.new(389.741, 415.219, -38.504)},
        {name="CP4", pos=Vector3.new(228.787, 358.386, 420.735)},
        {name="CP5", pos=Vector3.new(-248.196, 546.015, 537.969)},
        {name="CP6", pos=Vector3.new(-707.398, 478.386, 471.019)},
        {name="CP7", pos=Vector3.new(-823.563, 598.903, -193.940)},
        {name="CP8", pos=Vector3.new(-1539.058, 682.267, -643.505)},
        {name="CP9", pos=Vector3.new(-1581.844, 650.396, 448.762)},
        {name="CP10", pos=Vector3.new(-2566.289, 662.396, 450.378)},
        {name="Puncak", pos=Vector3.new(-2921.433, 844.065, 18.757)}
    }},
    ["111417482709154"] = {name="MOUNT BINGUNG (22 CP)", checkpoints = {
        {name="Basecamp", pos=Vector3.new(166.003,14.958,822.983)},
        {name="CP1", pos=Vector3.new(198.238,10.138,128.423)},
        {name="CP2", pos=Vector3.new(228.195,128.880,-211.192)},
        {name="CP3", pos=Vector3.new(231.818,146.768,-558.724)},
        {name="CP4", pos=Vector3.new(340.005,132.319,-987.244)},
        {name="CP5", pos=Vector3.new(393.582,119.624,-1415.085)},
        {name="CP6", pos=Vector3.new(344.683,190.307,-2695.906)},
        {name="CP7", pos=Vector3.new(353.371,243.565,-3065.352)},
        {name="CP8", pos=Vector3.new(-1.629,259.373,-3431.159)},
        {name="CP9", pos=Vector3.new(54.740,373.026,-3835.736)},
        {name="CP10", pos=Vector3.new(-347.480,505.230,-4970.265)},
        {name="CP11", pos=Vector3.new(-841.818,506.036,-4984.366)},
        {name="CP12", pos=Vector3.new(-825.191,571.779,-5727.793)},
        {name="CP13", pos=Vector3.new(-831.682,575.301,-6424.269)},
        {name="CP14", pos=Vector3.new(-288.521,661.584,-6804.152)},
        {name="CP15", pos=Vector3.new(675.514,743.511,-7249.335)},
        {name="CP16", pos=Vector3.new(816.312,833.686,-7606.230)},
        {name="CP17", pos=Vector3.new(805.293,821.011,-8516.908)},
        {name="CP18", pos=Vector3.new(473.563,879.064,-8585.453)},
        {name="CP19", pos=Vector3.new(268.831,897.108,-8576.449)},
        {name="CP20", pos=Vector3.new(285.314,933.955,-8983.920)},
        {name="Puncak", pos=Vector3.new(107.141,988.263,-9015.231)}
    }},
    ["76084648389385"] = {name="MOUNT TENERIE (6 CP)", checkpoints = {
        {name="Basecamp", pos=Vector3.new(24.996, 163.296, 319.838)},
        {name="CP1", pos=Vector3.new(24.996, 163.296, 319.838)},
        {name="CP2", pos=Vector3.new(-830.715, 239.184, 887.750)},
        {name="CP3", pos=Vector3.new(-1081.016, 400.153, 1662.579)},
        {name="CP4", pos=Vector3.new(-638.603, 659.233, 3034.486)},
        {name="CP5", pos=Vector3.new(339.759, 820.852, 3891.180)},
        {name="Puncak", pos=Vector3.new(878.573, 1019.189, 4704.508)}
    }},
}

-- GUI SETUP
local Player = game.Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local ScreenGui = Instance.new("ScreenGui", PlayerGui)
ScreenGui.Name = "UniversalMountGUI"

local function createButton(name, position, color)
    local btn = Instance.new("TextButton")
    btn.Name = name
    btn.Size = UDim2.new(0,150,0,35)
    btn.Position = position
    btn.BackgroundColor3 = color
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.Text = name
    btn.AutoButtonColor = true
    btn.TextScaled = true
    btn.ClipsDescendants = true
    btn.BackgroundTransparency = 0
    btn.BorderSizePixel = 0
    btn.Rounding = UDim.new(0,8)
    btn.Parent = ScreenGui
    return btn
end

-- Contoh tombol multiwarna
local btnTeleport = createButton("Teleport", UDim2.new(0,20,0,20), Color3.fromRGB(0,150,255))
local btnDeath = createButton("Manual Death", UDim2.new(0,180,0,20), Color3.fromRGB(255,0,0))
local btnServerHop = createButton("Server Hop", UDim2.new(0,340,0,20), Color3.fromRGB(0,150,255))
local btnHide = createButton("Hide", UDim2.new(0,500,0,20), Color3.fromRGB(100,100,100))
local btnClose = createButton("Close", UDim2.new(0,660,0,20), Color3.fromRGB(255,0,0))

-- Slider Transparansi bebas geser
local transparencySlider = Instance.new("Frame", ScreenGui)
transparencySlider.Position = UDim2.new(0,20,0,70)
transparencySlider.Size = UDim2.new(0,300,0,30)
transparencySlider.BackgroundColor3 = Color3.fromRGB(50,50,50)
transparencySlider.BorderSizePixel = 0
local slideBar = Instance.new("Frame", transparencySlider)
slideBar.Size = UDim2.new(0,0,1,0)
slideBar.BackgroundColor3 = Color3.fromRGB(200,200,200)
slideBar.BorderSizePixel = 0

slideBar.Active = true
slideBar.Draggable = true
slideBar.MouseButton1Down:Connect(function()
    slideBar.MouseButton1Down = true
end)

-- DETEKSI MAP
local currentMapId = tostring(game.PlaceId)
local currentMap = MAP_CONFIG[currentMapId]

if currentMap then
    print("Loaded map: "..currentMap.name)
    for i,cp in ipairs(currentMap.checkpoints) do
        print("Checkpoint "..i..": "..cp.name.." @ "..tostring(cp.pos))
    end
else
    print("Map not recognized.")
end

-- Fitur Tombol
btnTeleport.MouseButton1Click:Connect(function()
    if currentMap and currentMap.checkpoints[1] then
        Player.Character:SetPrimaryPartCFrame(CFrame.new(currentMap.checkpoints[1].pos))
    end
end)
btnDeath.MouseButton1Click:Connect(function()
    Player.Character.Humanoid.Health = 0
end)
btnServerHop.MouseButton1Click:Connect(function()
    game:GetService("TeleportService"):Teleport(game.PlaceId)
end)
btnHide.MouseButton1Click:Connect(function()
    ScreenGui.Enabled = false
end)
btnClose.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- END OF SCRIPT
