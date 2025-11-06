-- ALL-IN-ONE HELPER
print("=== GAME ANALYSIS ===")
print("PlaceId:", game.PlaceId)
print("")

-- Count parts
local partCount = 0
local anchoredCount = 0
local unanchoredCount = 0
local partNames = {}

for _, obj in pairs(game.Workspace:GetDescendants()) do
    if obj:IsA("BasePart") then
        partCount = partCount + 1
        if obj.Anchored then
            anchoredCount = anchoredCount + 1
        else
            unanchoredCount = unanchoredCount + 1
        end
        
        local name = obj.Name
        partNames[name] = (partNames[name] or 0) + 1
    end
end

print("Total Parts:", partCount)
print("Anchored:", anchoredCount)
print("Unanchored:", unanchoredCount)
print("")

-- Top part names
print("=== TOP 20 PART NAMES ===")
local sorted = {}
for name, count in pairs(partNames) do
    table.insert(sorted, {name = name, count = count})
end
table.sort(sorted, function(a, b) return a.count > b.count end)

for i, data in ipairs(sorted) do
    if i <= 20 then
        print(i .. ".", data.name, "(" .. data.count .. "x)")
    end
end

print("")

-- Remotes
local remoteCount = 0
for _, service in pairs(game:GetChildren()) do
    for _, obj in pairs(service:GetDescendants()) do
        if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
            remoteCount = remoteCount + 1
        end
    end
end

print("Total Remotes:", remoteCount)
print("=======================")

-- Notify
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Analysis Done";
    Text = "Check F9 Console!";
    Duration = 3;
})
