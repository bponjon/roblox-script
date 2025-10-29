--// GUI Library
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/your-library-url"))()
local Window = Library:CreateWindow("Auto Summit Final")

--// Tabs
local MainTab = Window:AddTab("Main")
local SettingsTab = Window:AddTab("Settings")
local InfoTab = Window:AddTab("Info")
local ServerTab = Window:AddTab("Server Hop")

--// Checkpoints asli
local checkpoints = {
    Basecamp = Vector3.new(-883.288, 43.358, 933.698),
    CP1 = Vector3.new(-473.240, 49.167, 624.194),
    CP2 = Vector3.new(-182.927, 52.412, 691.074),
    CP3 = Vector3.new(122.499, 202.548, 951.741),
    CP4 = Vector3.new(10.684, 194.377, 340.400),
    CP5 = Vector3.new(244.394, 194.369, 805.065),
    CP6 = Vector3.new(660.531, 210.886, 749.360),
    CP7 = Vector3.new(660.649, 202.965, 368.070),
    CP8 = Vector3.new(520.852, 214.338, 281.842),
    CP9 = Vector3.new(523.730, 214.369, -333.936),
    CP10 = Vector3.new(561.610, 211.787, -559.470),
    CP11 = Vector3.new(566.837, 282.541, -924.107),
    CP12 = Vector3.new(115.198, 286.309, -655.635),
    CP13 = Vector3.new(-308.343, 410.144, -612.031),
    CP14 = Vector3.new(-487.722, 522.666, -663.426),
    CP15 = Vector3.new(-679.093, 482.701, -971.988),
    CP16 = Vector3.new(-559.058, 258.369, -1318.780),
    CP17 = Vector3.new(-426.353, 374.369, -1512.621),
    CP18 = Vector3.new(-984.797, 635.003, -1621.875),
    CP19 = Vector3.new(-1394.228, 797.455, -1563.855),
    Puncak = Vector3.new(-1534.938, 933.116, -2176.096),
}

--// Variables
local AutoSummitEnabled = false
local AutoDeathEnabled = false
local ServerHopEnabled = false
local DelayTime = 1
local Speed = 16

--// Main Tab Features
MainTab:AddToggle("Auto Summit", function(value)
    AutoSummitEnabled = value
    if value then
        while AutoSummitEnabled do
            for name, pos in pairs(checkpoints) do
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(pos)
                wait(DelayTime)
            end
            if AutoDeathEnabled then
                game.Players.LocalPlayer.Character.Humanoid.Health = 0
            end
        end
    end
end)

MainTab:AddToggle("Auto Death", function(value)
    AutoDeathEnabled = value
end)

--// Settings
SettingsTab:AddSlider("Delay", 1, 10, function(value)
    DelayTime = value
end)

SettingsTab:AddSlider("Speed", 1, 100, function(value)
    Speed = value
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Speed
end)

--// Info Tab
InfoTab:AddLabel("Auto Summit Script vFinal")
InfoTab:AddLabel("All checkpoints included")
InfoTab:AddLabel("GUI movable, hideable, closeable")

--// Server Hop
ServerTab:AddToggle("Enable Server Hop", function(value)
    ServerHopEnabled = value
end)

--// GUI Hide & Close
Window:AddButton("Hide GUI", function()
    Window:ToggleVisibility() -- hanya nama GUI & hide/close yg kelihatan
end)

Window:AddButton("Close GUI", function()
    Library:Close()
end)

print("✅ Auto Summit Final Loaded with Checkpoints!")
