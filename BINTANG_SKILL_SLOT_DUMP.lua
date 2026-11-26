--[[
  Bintang — Killer Skill Slot Dumper (S1 / S2)
  1) Tekan skill 1 atau 2
  2) Console kasih label S1/S2 + AnimationId
]]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local LP = Players.LocalPlayer

-- key yang biasa skill (PC). Mobile: pakai tombol UI skill tetap ke-detect via anim+timing
local S1_KEYS = {
    [Enum.KeyCode.Q] = true,
    [Enum.KeyCode.One] = true,
    [Enum.KeyCode.KeypadOne] = true,
}
local S2_KEYS = {
    [Enum.KeyCode.E] = true,
    [Enum.KeyCode.Two] = true,
    [Enum.KeyCode.KeypadTwo] = true,
}

local pendingSlot = nil -- "S1" / "S2"
local pendingUntil = 0
local slots = { S1 = {}, S2 = {}, Other = {} }

local SKIP = {
    idle = true, walk = true, run = true, jump = true, fall = true,
    climb = true, swim = true, sit = true, land = true,
}

local function shouldSkip(name)
    local n = string.lower(tostring(name or ""))
    for k in pairs(SKIP) do
        if n:find(k, 1, true) then return true end
    end
    return false
end

local function normalizeId(id)
    if not id then return nil end
    local num = tostring(id):match("(%d+)")
    return num and ("rbxassetid://" .. num) or tostring(id)
end

local function printSlots()
    print("======== SKILL SLOTS ========")
    for _, slot in ipairs({"S1", "S2", "Other"}) do
        print("-- " .. slot)
        for id, info in pairs(slots[slot]) do
            print(string.format('  ["%s"] = "%s", -- %s', id, info.name, info.note or ""))
        end
    end
    print("local S1_IDS = {")
    for id, info in pairs(slots.S1) do
        print(string.format('    ["%s"] = true, -- %s', id, info.name))
    end
    print("}")
    print("local S2_IDS = {")
    for id, info in pairs(slots.S2) do
        print(string.format('    ["%s"] = true, -- %s', id, info.name))
    end
    print("}")
    print("==============================")
end

local function guessFromName(name)
    local n = string.lower(tostring(name or ""))
    if n:find("throw") or n:find("chain") or n:find("spear") or n:find("veil") or n:find("projectile") then
        return "ranged-throw"
    end
    if n:find("lunge") or n:find("leap") or n:find("dash") or n:find("rush") then
        return "lunge/leap"
    end
    if n:find("frenzy") then return "frenzy" end
    if n:find("wipe") or n:find("machete") then return "wipe" end
    if n:find("trap") or n:find("tendon") or n:find("plant") then return "trap/plant" end
    if n:find("attack") or n:find("swing") or n:find("slash") then return "attack" end
    if n:find("mark") or n:find("stalk") or n:find("hidden") then return "mark/stealth" end
    return "?"
end

local function logAnim(track)
    local anim = track.Animation
    local id = normalizeId(anim and anim.AnimationId)
    if not id then return end
    local name = (anim and anim.Name) or track.Name or "?"
    if shouldSkip(name) or shouldSkip(track.Name) then return end

    local slot = "Other"
    local note = ""
    if pendingSlot and os.clock() < pendingUntil then
        slot = pendingSlot
        note = "key→" .. pendingSlot
        -- consume once so spam anim tidak semua ke slot yang sama
        -- keep window open briefly for multi-part skill
    end

    local g = guessFromName(name) .. "/" .. guessFromName(track.Name)
    if not slots[slot][id] then
        slots[slot][id] = { name = name, note = note .. " " .. g, length = track.Length }
        print(string.format(
            "[%s] %s | %s | len=%.2f | %s",
            slot, id, name, track.Length or 0, note ~= "" and note or g
        ))
        printSlots()
    end
end

-- key → pending slot (1.2s window)
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if S1_KEYS[input.KeyCode] then
        pendingSlot = "S1"
        pendingUntil = os.clock() + 1.25
        print("[Bintang] Pending slot → S1 (1.25s) — pakai skill SEKARANG")
    elseif S2_KEYS[input.KeyCode] then
        pendingSlot = "S2"
        pendingUntil = os.clock() + 1.25
        print("[Bintang] Pending slot → S2 (1.25s) — pakai skill SEKARANG")
    end
end)

-- mobile: chat / manual mark via number keys already; also offer touch-friendly
-- when tool equipped, soft-hint
local function hookChar(char)
    task.spawn(function()
        local hum = char:WaitForChild("Humanoid", 8)
        if not hum then return end
        local animator = hum:FindFirstChildOfClass("Animator") or hum:WaitForChild("Animator", 5)
        if not animator then
            warn("[Bintang] No Animator")
            return
        end
        animator.AnimationPlayed:Connect(function(track)
            pcall(logAnim, track)
        end)
        char.ChildAdded:Connect(function(c)
            if c:IsA("Tool") then
                print("[Tool]", c.Name)
            end
        end)
        print("[Bintang] Skill slot dump hooked")
    end)
end

if LP.Character then hookChar(LP.Character) end
LP.CharacterAdded:Connect(hookChar)

print("========================================")
print(" Bintang Skill Slot Dump (S1 / S2)")
print(" PC: Q / 1 = tandai S1, lalu skill")
print("     E / 2 = tandai S2, lalu skill")
print(" HP: ketik di executor sebelum skill:")
print("   getgenv()._B_SLOT='S1'  atau 'S2'")
print(" Lalu pakai skill dalam ~1 detik")
print("========================================")

-- mobile helper
getgenv().MarkS1 = function()
    pendingSlot = "S1"
    pendingUntil = os.clock() + 1.5
    print("[Bintang] MarkS1 — pakai skill 1 sekarang")
end
getgenv().MarkS2 = function()
    pendingSlot = "S2"
    pendingUntil = os.clock() + 1.5
    print("[Bintang] MarkS2 — pakai skill 2 sekarang")
end

-- poll getgenv slot
task.spawn(function()
    while true do
        task.wait(0.1)
        local s = getgenv()._B_SLOT
        if s == "S1" or s == "S2" then
            pendingSlot = s
            pendingUntil = os.clock() + 1.5
            getgenv()._B_SLOT = nil
            print("[Bintang] Pending from _B_SLOT →", s)
        end
    end
end)
