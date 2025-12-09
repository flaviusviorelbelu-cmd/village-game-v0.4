-- ============================================
-- GAME INITIALIZATION SEQUENCE
-- This script monitors other systems and ensures proper initialization order
-- ============================================

print("\n" .. string.rep("=", 50))
print("🚀 VILLAGE GAME v0.4 - INITIALIZATION START")
print(string.rep("=", 50) .. "\n")

local initStartTime = tick()

-- Wait for RemoteEvents to be created by EconomySystem
print("📍 STEP 1/2: Waiting for RemoteEvents...")
local remoteEventsFolder = game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents", 10)
if not remoteEventsFolder then
	warn("❌ RemoteEvents folder not found after 10 seconds!")
else
	print("✅ RemoteEvents ready")
end

wait(1)

-- Wait for Village to be created by GameManager
print("📍 STEP 2/2: Waiting for Village...")
local village = workspace:WaitForChild("Village", 10)
if not village then
	warn("❌ Village folder not found after 10 seconds!")
else
	print("✅ Village ready")
end

-- ============================================
-- SETUP SHOP CLICK HANDLERS
-- ============================================
print("\n📍 Setting up shop interactions...")

local shopInteractionEvent = remoteEventsFolder and remoteEventsFolder:FindFirstChild("ShopInteraction")
if not shopInteractionEvent then
	warn("⚠️  ShopInteraction event not found")
else
	print("✅ Found ShopInteraction event")
end

-- Wait for Village to exist, then find shops
if village then
	local shopNames = {"GeneralStore", "WeaponShop", "FoodStore", "ClothingShop"}
	for _, shopName in ipairs(shopNames) do
		local shop = village:FindFirstChild(shopName)
		if shop and shop:FindFirstChild("ClickDetector") then
			shop.ClickDetector.MouseClick:Connect(function(player)
				print("🛍️  Player " .. player.Name .. " clicked " .. shopName)
				if shopInteractionEvent then
					shopInteractionEvent:FireClient(player, shopName)
					print("📤 Sent ShopInteraction event to " .. player.Name)
				else
					warn("❌ ShopInteraction event not found!")
				end
			end)
			print("✅ Added click handler for " .. shopName)
		end
	end
end

-- ============================================
-- INITIALIZATION COMPLETE
-- ============================================
print(string.rep("=", 50))
print("✨ GAME FULLY INITIALIZED AND READY TO PLAY!")
print(string.rep("=", 50) .. "\n")

print("📊 Total initialization time: " .. string.format("%.2f", tick() - initStartTime) .. " seconds")
print("🎮 Waiting for players...\n")
