-- Mobile Fling GUI (Delta Support Version)
-- by ChatGPT

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- cari target (username atau displayname, case insensitive, partial match)
local function findTargetByPartial(name)
    if not name or name == "" then return nil end
    local lname = name:lower()

    if lname == "random" then
        local list = {}
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then
                table.insert(list, p)
            end
        end
        if #list > 0 then
            return list[math.random(1, #list)]
        else
            return nil
        end
    elseif lname == "all" then
        return "all"
    end

    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            local uname = p.Name:lower()
            local dname = (p.DisplayName or ""):lower()
            if uname:sub(1, #lname) == lname or dname:sub(1, #lname) == lname then
                return p
            end
        end
    end
    return nil
end

-- fling sekali
local function flingOnce(target)
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local hrp = char.HumanoidRootPart
    local originalCF = hrp.CFrame

    local function flingAt(thrp)
        if not thrp then return end
        hrp.CFrame = thrp.CFrame
        for i = 1, 20 do
            hrp.Velocity = Vector3.new(9999,9999,9999)
            task.wait(0.05)
        end
        hrp.CFrame = originalCF
    end

    if target == "all" then
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                flingAt(p.Character.HumanoidRootPart)
            end
        end
    elseif target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        flingAt(target.Character.HumanoidRootPart)
    else
        game.StarterGui:SetCore("SendNotification", {
            Title = "Fling",
            Text = "Target not found",
            Duration = 3
        })
    end
end

-- simple GUI
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Frame = Instance.new("Frame", ScreenGui)
local TextBox = Instance.new("TextBox", Frame)
local Button = Instance.new("TextButton", Frame)

Frame.Size = UDim2.new(0,200,0,100)
Frame.Position = UDim2.new(0.5,-100,0.2,0)
Frame.BackgroundColor3 = Color3.fromRGB(30,30,30)

TextBox.Size = UDim2.new(1,-10,0,30)
TextBox.Position = UDim2.new(0,5,0,5)
TextBox.Text = ""
TextBox.PlaceholderText = "Target name (all/random)"

Button.Size = UDim2.new(1,-10,0,40)
Button.Position = UDim2.new(0,5,0,50)
Button.Text = "FLING"
Button.BackgroundColor3 = Color3.fromRGB(50,150,50)

Button.MouseButton1Click:Connect(function()
    local name = TextBox.Text
    local target = findTargetByPartial(name)
    flingOnce(target)
end)
