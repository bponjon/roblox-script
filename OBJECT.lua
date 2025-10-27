local objectName = "NamaObject" -- Ganti dengan nama objek yang mau dihapus
local parentName = "Workspace" -- Biasanya objek di Workspace, bisa disesuaikan

local parent = game:FindFirstChild(parentName)
if parent then
    local obj = parent:FindFirstChild(objectName)
    if obj then
        obj:Destroy()
        print(objectName .. " telah dihapus")
    else
        print("Objek tidak ditemukan")
    end
else
    print("Parent tidak ditemukan")
end
