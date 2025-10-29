-- MountGemini AutoSummit 
local _0x1=game:GetService("Players").LocalPlayer
local _0x2=game:GetService("TeleportService")
local _0x3=game:GetService("HttpService")
local _0x4=_0x1:WaitForChild("PlayerGui")
local _0x5={{n="A",p=Vector3.new(1272.160,639.021,1792.852)},{n="B",p=Vector3.new(-6652.260,3151.055,-796.739)}}
local _0x6=0
local _0x7=false
local function _0x8()
	local _=_0x4:FindFirstChild("MGuiV") if _ then _.Parent=nil end
	local g=Instance.new("ScreenGui",_0x4)
	g.Name="MGuiV"
	g.ResetOnSpawn=false
	local f=Instance.new("Frame",g)
	f.Size=UDim2.new(0,280,0,300);f.Position=UDim2.new(0.05,0,0.1,0);f.BackgroundColor3=Color3.fromRGB(50,0,50);f.BorderSizePixel=0;f.Active=true;f.Draggable=true
	local x=Instance.new("TextButton",f);x.Text="X";x.Size=UDim2.new(0,30,0,30);x.Position=UDim2.new(1,-35,0,5);x.BackgroundColor3=Color3.fromRGB(150,0,0);x.TextColor3=Color3.fromRGB(255,255,255)
	x.MouseButton1Click:Connect(function() g.Enabled=false end)
	local h=Instance.new("TextButton",f);h.Text="Hide";h.Size=UDim2.new(0,60,0,30);h.Position=UDim2.new(0,5,0,5);h.BackgroundColor3=Color3.fromRGB(0,0,0);h.TextColor3=Color3.fromRGB(255,255,255)
	local L=Instance.new("ImageButton",g);L.Size=UDim2.new(0,50,0,50);L.Position=UDim2.new(0.9,0,0.1,0);L.Image="rbxassetid://YOUR_DRAGON_IMAGE_ID";L.Visible=false;L.Active=true;L.Draggable=true
	h.MouseButton1Click:Connect(function() f.Visible=false;L.Visible=true end)
	L.MouseButton1Click:Connect(function() f.Visible=true;L.Visible=false end)
	local b=Instance.new("TextButton",f);b.Text="Teleport Basecamp";b.Size=UDim2.new(1,-10,0,30);b.Position=UDim2.new(0,5,0,50);b.BackgroundColor3=Color3.fromRGB(30,0,30);b.TextColor3=Color3.fromRGB(255,255,255)
	b.MouseButton1Click:Connect(function() if _0x1.Character and _0x1.Character.PrimaryPart then _0x1.Character:SetPrimaryPartCFrame(CFrame.new(_0x5[1].p)) end end)
	local p=Instance.new("TextButton",f);p.Text="Teleport Puncak";p.Size=UDim2.new(1,-10,0,30);p.Position=UDim2.new(0,5,0,90);p.BackgroundColor3=Color3.fromRGB(30,0,30);p.TextColor3=Color3.fromRGB(255,255,255)
	p.MouseButton1Click:Connect(function() if _0x1.Character and _0x1.Character.PrimaryPart then _0x1.Character:SetPrimaryPartCFrame(CFrame.new(_0x5[2].p)) end end)
	local a=Instance.new("TextButton",f);a.Text="Auto Summit";a.Size=UDim2.new(0.5,-5,0,30);a.Position=UDim2.new(0,5,1,-40);a.BackgroundColor3=Color3.fromRGB(80,0,80);a.TextColor3=Color3.fromRGB(255,255,255)
	local s=Instance.new("TextButton",f);s.Text="Stop";s.Size=UDim2.new(0.5,-5,0,30);s.Position=UDim2.new(0.5,0,1,-40);s.BackgroundColor3=Color3.fromRGB(100,0,0);s.TextColor3=Color3.fromRGB(255,255,255)
	local sh=Instance.new("TextButton",f);sh.Text="Server Hop";sh.Size=UDim2.new(1,-10,0,30);sh.Position=UDim2.new(0,5,0,130);sh.BackgroundColor3=Color3.fromRGB(0,0,100);sh.TextColor3=Color3.fromRGB(255,255,255)
	local function _()
		local t={}
		local ok,raw=pcall(function() return game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100") end)
		if not ok or not raw then return end
		local ok2,dec=pcall(function() return _0x3:JSONDecode(raw) end)
		if not ok2 or type(dec)~="table" or not dec.data then return end
		for _,v in pairs(dec.data) do
			if v.playing and v.maxPlayers and v.playing < v.maxPlayers then table.insert(t,v.id) end
		end
		if #t>0 then pcall(function() _0x2:TeleportToPlaceInstance(game.PlaceId,t[math.random(1,#t)],_0x1) end) end
	end
	sh.MouseButton1Click:Connect(_)
	a.MouseButton1Click:Connect(function() if not _0x7 then _0x7=true;spawn(function()
		while _0x7 do
			if _0x1.Character and _0x1.Character.PrimaryPart then _0x1.Character:SetPrimaryPartCFrame(CFrame.new(_0x5[1].p)) end
			task.wait(3) -- delay 3 detik setelah teleport basecamp
			if _0x1.Character and _0x1.Character.PrimaryPart then _0x1.Character:SetPrimaryPartCFrame(CFrame.new(_0x5[2].p)) end
			task.wait(3) -- delay 3 detik di puncak sebelum mati
			if _0x1.Character then pcall(function() _0x1.Character:BreakJoints() end) end
			_0x1.CharacterAdded:Wait()
			_0x6=_0x6+1
			-- automatic server hop after 10 removed (previously: if _0x6>=10 then _0x6=0;_() end)
		end
	end) end end)
	s.MouseButton1Click:Connect(function() _0x7=false end)
end
pcall(_0x8)
