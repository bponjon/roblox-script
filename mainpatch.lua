-- =====================================================
-- MainmapPatched.lua
-- Patch Key Otomatis & Jalankan Skrip Utama
-- =====================================================

-- === Patch Key Otomatis ===
local CONFIG_KEY = "cobagratis"

-- Override fungsi f jika dipakai untuk bikin key
if f then
    local old_f = f
    f = function(...)
        return CONFIG_KEY
    end
end

-- Override table / lookup key jika skrip memakai B[p[...]] atau table lain
if B then
    setmetatable(B, {
        __index = function(_, k)
            return CONFIG_KEY
        end,
        __newindex = function(_, k, v)
            rawset(_, k, v)
        end
    })
end

-- Override fungsi checkKey / validasi (jika ada)
if checkKey then
    local oldCheckKey = checkKey
    checkKey = function(k)
        return k == CONFIG_KEY
    end
end

print("Patch key aktif: "..CONFIG_KEY)
-- === End Patch ===

-- === Jalankan Skrip Utama ===
loadstring(game:HttpGet("https://raw.githubusercontent.com/noirexe/pree/refs/heads/main/mainmap.lua"))()
