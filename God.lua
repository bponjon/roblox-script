-- GOD MODE + ANTI-FALL FIX (no stuck on jump)
-- Buat game kayak Mount Arunika
-- Aman lompat, cuma aktif kalo jatuh jauh banget

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

if not LocalPlayer then
	repeat task.wait() until Players.LocalPlayer
	LocalPlayer = Players.LocalPlayer
end

local function protectCharacter(char)
	local hum = char:WaitForChild("Humanoid", 5)
	local root = char:WaitForChild("HumanoidRootPart", 5)
	if not hum or not root then return end

	-- set darah tinggi
	hum.MaxHealth = 999999
	hum.Health = hum.MaxHealth

	local lastSafePos = root.Position
	local lastGroundTick = tick()

	RunService.Heartbeat:Connect(function()
		if not hum or not root then return end

		-- isi darah lagi tiap frame
		if hum.Health < hum.MaxHealth then
			hum.Health = hum.MaxHealth
		end

		-- update posisi aman cuma kalo bener2 nempel tanah
		if hum.FloorMaterial ~= Enum.Material.Air then
			lastSafePos = root.Position
			lastGroundTick = tick()
		end

		-- cek jatuh jauh banget (beda tinggi > 30 stud)
		local diffY = lastSafePos.Y - root.Position.Y
		if diffY > 30 and (tick() - lastGroundTick) > 1 then
			root.CFrame = CFrame.new(lastSafePos + Vector3.new(0, 5, 0))
			root.AssemblyLinearVelocity = Vector3.zero
		end

		-- kalau mati, langsung idup lagi
		if hum:GetState() == Enum.HumanoidStateType.Dead then
			hum:ChangeState(Enum.HumanoidStateType.GettingUp)
			hum.Health = hum.MaxHealth
		end
	end)
end

LocalPlayer.CharacterAdded:Connect(protectCharacter)
if LocalPlayer.Character then protectCharacter(LocalPlayer.Character) end

print("✅ God Mode aktif - lompat bebas, gak bakal nyangkut lagi.")
