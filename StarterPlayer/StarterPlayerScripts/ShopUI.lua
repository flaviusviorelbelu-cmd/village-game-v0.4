-- SHOP UI - CLIENT SIDE
-- Displays shop interface when player clicks a shop
print("🛍️ Initializing Shop UI...")

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Wait for RemoteEvents
local remoteEventsFolder = ReplicatedStorage:WaitForChild("RemoteEvents", 5)
if not remoteEventsFolder then
	warn("❌ RemoteEvents not found!")
	return
end

local shopInteractionEvent = remoteEventsFolder:WaitForChild("ShopInteraction", 5)
local purchaseItemEvent = remoteEventsFolder:FindFirstChild("PurchaseItem")
local showShopEvent = remoteEventsFolder:FindFirstChild("ShowShop")
local updateCurrencyEvent = remoteEventsFolder:FindFirstChild("UpdateCurrency")
local showMessageEvent = remoteEventsFolder:FindFirstChild("ShowMessage")

print("✅ Connected to RemoteEvents")

-- Shop item data
local SHOP_ITEMS = {
	GeneralStore = {
		{name = "Wooden Pickaxe", price = 50, description = "Basic mining tool"},
		{name = "Health Potion", price = 25, description = "Restores 50 HP"},
		{name = "Rope", price = 15, description = "Useful for climbing"},
		{name = "Lantern", price = 30, description = "Lights up dark areas"}
	},
	WeaponShop = {
		{name = "Iron Sword", price = 150, description = "Sharp iron blade"},
		{name = "Wooden Shield", price = 100, description = "Basic protection"},
		{name = "Steel Dagger", price = 75, description = "Fast attack weapon"},
		{name = "Bow", price = 120, description = "Ranged weapon"}
	},
	FoodStore = {
		{name = "Bread", price = 10, description = "Restores hunger"},
		{name = "Apple", price = 5, description = "Fresh fruit"},
		{name = "Cooked Fish", price = 20, description = "Nutritious meal"},
		{name = "Water Bottle", price = 8, description = "Quenches thirst"}
	},
	ClothingShop = {
		{name = "Leather Boots", price = 60, description = "Comfortable footwear"},
		{name = "Cotton Shirt", price = 40, description = "Basic clothing"},
		{name = "Wool Cloak", price = 80, description = "Warm outerwear"},
		{name = "Leather Gloves", price = 35, description = "Hand protection"}
	}
}

-- ============================================
-- SHOP UI CREATION
-- ============================================
local function createShopUI(shopName)
	print("🏪 Creating UI for " .. shopName)
	
	-- Remove old shop GUI if it exists
	if playerGui:FindFirstChild("ShopGui") then
		playerGui:FindFirstChild("ShopGui"):Destroy()
	end
	
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "ShopGui"
	screenGui.ResetOnSpawn = false
	screenGui.Parent = playerGui
	
	-- Main Frame
	local mainFrame = Instance.new("Frame")
	mainFrame.Name = "MainFrame"
	mainFrame.Size = UDim2.new(0, 600, 0, 400)
	mainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
	mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
	mainFrame.BorderSizePixel = 0
	mainFrame.Parent = screenGui
	
	-- Add corner radius
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 12)
	corner.Parent = mainFrame
	
	-- Title
	local titleLabel = Instance.new("TextLabel")
	titleLabel.Name = "Title"
	titleLabel.Size = UDim2.new(1, 0, 0, 50)
	titleLabel.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
	titleLabel.BorderSizePixel = 0
	titleLabel.Text = shopName
	titleLabel.TextColor3 = Color3.fromRGB(255, 255, 100)
	titleLabel.TextSize = 28
	titleLabel.Font = Enum.Font.GothamBold
	titleLabel.Parent = mainFrame
	
	-- Items Container (ScrollingFrame)
	local itemsScroll = Instance.new("ScrollingFrame")
	itemsScroll.Name = "ItemsScroll"
	itemsScroll.Size = UDim2.new(1, -20, 1, -130)
	itemsScroll.Position = UDim2.new(0, 10, 0, 60)
	itemsScroll.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
	itemsScroll.BorderSizePixel = 0
	itemsScroll.ScrollBarThickness = 8
	itemsScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
	itemsScroll.Parent = mainFrame
	
	local itemLayout = Instance.new("UIListLayout")
	itemLayout.SortOrder = Enum.SortOrder.LayoutOrder
	itemLayout.Padding = UDim.new(0, 10)
	itemLayout.Parent = itemsScroll
	
	-- Add items
	local items = SHOP_ITEMS[shopName] or {}
	for index, item in ipairs(items) do
		local itemFrame = Instance.new("Frame")
		itemFrame.Name = item.name
		itemFrame.Size = UDim2.new(1, -20, 0, 70)
		itemFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
		itemFrame.BorderSizePixel = 0
		itemFrame.LayoutOrder = index
		itemFrame.Parent = itemsScroll
		
		-- Item name
		local itemNameLabel = Instance.new("TextLabel")
		itemNameLabel.Name = "ItemName"
		itemNameLabel.Size = UDim2.new(0.6, 0, 0.5, 0)
		itemNameLabel.Position = UDim2.new(0, 10, 0, 5)
		itemNameLabel.BackgroundTransparency = 1
		itemNameLabel.Text = item.name
		itemNameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
		itemNameLabel.TextSize = 16
		itemNameLabel.Font = Enum.Font.GothamBold
		itemNameLabel.TextXAlignment = Enum.TextXAlignment.Left
		itemNameLabel.Parent = itemFrame
		
		-- Description
		local descLabel = Instance.new("TextLabel")
		descLabel.Name = "Description"
		descLabel.Size = UDim2.new(0.6, 0, 0.5, 0)
		descLabel.Position = UDim2.new(0, 10, 0.5, 0)
		descLabel.BackgroundTransparency = 1
		descLabel.Text = item.description
		descLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
		descLabel.TextSize = 12
		descLabel.Font = Enum.Font.Gotham
		descLabel.TextXAlignment = Enum.TextXAlignment.Left
		descLabel.Parent = itemFrame
		
		-- Price label
		local priceLabel = Instance.new("TextLabel")
		priceLabel.Name = "Price"
		priceLabel.Size = UDim2.new(0.3, -10, 1, 0)
		priceLabel.Position = UDim2.new(0.6, 10, 0, 0)
		priceLabel.BackgroundTransparency = 1
		priceLabel.Text = "💰 " .. item.price
		priceLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
		priceLabel.TextSize = 16
		priceLabel.Font = Enum.Font.GothamBold
		priceLabel.TextXAlignment = Enum.TextXAlignment.Right
		priceLabel.Parent = itemFrame
		
		-- Buy button
		local buyButton = Instance.new("TextButton")
		buyButton.Name = "BuyButton"
		buyButton.Size = UDim2.new(0, 60, 0.7, 0)
		buyButton.Position = UDim2.new(1, -70, 0.15, 0)
		buyButton.BackgroundColor3 = Color3.fromRGB(50, 180, 100)
		buyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
		buyButton.TextSize = 12
		buyButton.Font = Enum.Font.GothamBold
		buyButton.Text = "BUY"
		buyButton.Parent = itemFrame
		
		local btnCorner = Instance.new("UICorner")
		btnCorner.CornerRadius = UDim.new(0, 6)
		btnCorner.Parent = buyButton
		
		-- Buy button click
		buyButton.MouseButton1Click:Connect(function()
			print("🛍️ " .. player.Name .. " buying " .. item.name .. " from " .. shopName)
			if purchaseItemEvent then
				purchaseItemEvent:FireServer(shopName, item.name)
				print("✅ Purchase request sent")
			end
		end)
		
		-- Hover effects
		buyButton.MouseEnter:Connect(function()
			buyButton.BackgroundColor3 = Color3.fromRGB(70, 200, 120)
		end)
		buyButton.MouseLeave:Connect(function()
			buyButton.BackgroundColor3 = Color3.fromRGB(50, 180, 100)
		end)
	end
	
	-- Close Button
	local closeButton = Instance.new("TextButton")
	closeButton.Name = "CloseButton"
	closeButton.Size = UDim2.new(0, 100, 0, 40)
	closeButton.Position = UDim2.new(0.5, -50, 1, -50)
	closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
	closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	closeButton.TextSize = 16
	closeButton.Font = Enum.Font.GothamBold
	closeButton.Text = "CLOSE"
	closeButton.Parent = mainFrame
	
	local closeCorner = Instance.new("UICorner")
	closeCorner.CornerRadius = UDim.new(0, 8)
	closeCorner.Parent = closeButton
	
	closeButton.MouseButton1Click:Connect(function()
		screenGui:Destroy()
		print("🛍️ Shop closed")
	end)
	
	-- Hover effects
	closeButton.MouseEnter:Connect(function()
		closeButton.BackgroundColor3 = Color3.fromRGB(220, 70, 70)
	end)
	closeButton.MouseLeave:Connect(function()
		closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
	end)
	
	print("✅ Shop UI created for " .. shopName)
end

-- ============================================
-- EVENT HANDLERS
-- ============================================

-- Listen for shop interaction events
shopInteractionEvent.OnClientEvent:Connect(function(shopName)
	print("🛍️ ShopInteraction event received: " .. shopName)
	createShopUI(shopName)
end)

-- Listen for messages from server
if showMessageEvent then
	showMessageEvent.OnClientEvent:Connect(function(message)
		print("📤 Message: " .. message)
		-- TODO: Display toast notification
	end)
end

-- Listen for currency updates
if updateCurrencyEvent then
	updateCurrencyEvent.OnClientEvent:Connect(function(wallet)
		print("💰 Wallet updated: Gold=" .. wallet.gold .. " Silver=" .. wallet.silver)
		-- TODO: Update wallet UI
	end)
end

print("✅ Shop UI System Ready!")
