-- ============================================
-- GAME INITIALIZATION SEQUENCE
-- This script runs FIRST and loads all systems in the correct order
-- ============================================

print("\n" .. string.rep("=", 50))
print("🚀 VILLAGE GAME v0.4 - INITIALIZATION START")
print(string.rep("=", 50) .. "\n")

local initStartTime = tick()

-- ============================================
-- STEP 1: BASE GAME SETUP (World creation)
-- ============================================
print("📍 STEP 1/4: Setting up base game world...")
require(script.Parent:WaitForChild("BaseGame"))
print("✅ Base game ready in " .. string.format("%.2f", tick() - initStartTime) .. "s\n")

wait(0.3)

-- ============================================
-- STEP 2: ECONOMY SYSTEM (Currency & RemoteEvents)
-- ============================================
print("📍 STEP 2/4: Initializing economy system...")
require(script.Parent:WaitForChild("EconomySystem"))
print("✅ Economy system ready in " .. string.format("%.2f", tick() - initStartTime) .. "s\n")

wait(0.3)

-- ============================================
-- STEP 3: GAME MANAGER (Villages, houses, shops)
-- ============================================
print("📍 STEP 3/4: Building villages and game content...")
require(script.Parent:WaitForChild("GameManager"))
print("✅ Game manager ready in " .. string.format("%.2f", tick() - initStartTime) .. "s\n")

wait(0.3)

-- ============================================
-- STEP 4: ADDITIONAL SYSTEMS (NPCs, Houses, etc)
-- ============================================
print("📍 STEP 4/4: Loading additional systems...")
require(script.Parent:WaitForChild("HouseInteriorManager"))
require(script.Parent:WaitForChild("NPCSystem"))
print("✅ All systems ready in " .. string.format("%.2f", tick() - initStartTime) .. "s\n")

-- ============================================
-- INITIALIZATION COMPLETE
-- ============================================
print(string.rep("=", 50))
print("✨ GAME FULLY INITIALIZED AND READY TO PLAY!")
print(string.rep("=", 50) .. "\n")

print("📊 Total initialization time: " .. string.format("%.2f", tick() - initStartTime) .. " seconds")
print("🎮 Waiting for players...\n")
