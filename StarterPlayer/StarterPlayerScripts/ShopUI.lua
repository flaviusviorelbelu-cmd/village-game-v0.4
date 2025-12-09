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
	
	-- Main Frame - LARGER to accommodate all items
	local mainFrame = Instance.new("Frame")
	mainFrame.Name = "MainFrame"
	mainFrame.Size = UDim2.new(0, 700, 0, 550)  -- Increased height from 400 to 550
	mainFrame.Position = UDim2.new(0.5, -350, 0.5, -275)  -- Centered
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
	
	-- Items Container (ScrollingFrame) - TALLER
	local itemsScroll = Instance.new("ScrollingFrame")
	itemsScroll.Name = "ItemsScroll"
	itemsScroll.Size = UDim2.new(1, -20, 1, -130)  -- Full width minus padding, height minus title and button
	itemsScroll.Position = UDim2.new(0, 10, 0, 60)  -- Below title
	itemsScroll.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
	itemsScroll.BorderSizePixel = 0
	itemsScroll.ScrollBarThickness = 10
	itemsScroll.TopImage = ""
	itemsScroll.BottomImage = ""
	itemsScroll.MidImage = ""
	itemsScroll.CanvasSize = UDim2.new(0, 0, 0, 0)  -- Will be calculated
	itemsScroll.Parent = mainFrame
	
	local itemLayout = Instance.new("UIListLayout")
	itemLayout.SortOrder = Enum.SortOrder.LayoutOrder
	itemLayout.Padding = UDim.new(0, 8)  -- Smaller padding
	itemLayout.FillDirection = Enum.FillDirection.Vertical
	itemLayout.Parent = itemsScroll
	
	-- Add items
	local items = SHOP_ITEMS[shopName] or {}
	for index, item in ipairs(items) do
		local itemFrame = Instance.new("Frame")
		itemFrame.Name = item.name
		itemFrame.Size = UDim2.new(1, -16, 0, 80)  -- Fixed height for each item
		itemFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
		itemFrame.BorderSizePixel = 0
		itemFrame.LayoutOrder = index
		itemFrame.Parent = itemsScroll
		
		-- Add padding/margin
		local itemPadding = Instance.new("UIPadding")
		itemPadding.PaddingLeft = UDim.new(0, 12)
		itemPadding.PaddingRight = UDim.new(0, 12)
		itemPadding.PaddingTop = UDim.new(0, 8)
		itemPadding.PaddingBottom = UDim.new(0, 8)
		itemPadding.Parent = itemFrame
		
		-- Left side: Item info (name + description)
		local infoFrame = Instance.new("Frame")
		infoFrame.Name = "InfoFrame"
		infoFrame.Size = UDim2.new(0.55, -6, 1, 0)  -- 55% of width
		infoFrame.Position = UDim2.new(0, 0, 0, 0)
		infoFrame.BackgroundTransparency = 1
		infoFrame.BorderSizePixel = 0
		infoFrame.Parent = itemFrame
		
		-- Item name
		local itemNameLabel = Instance.new("TextLabel")
		itemNameLabel.Name = "ItemName"
		itemNameLabel.Size = UDim2.new(1, 0, 0.5, 0)
		itemNameLabel.Position = UDim2.new(0, 0, 0, 0)
		itemNameLabel.BackgroundTransparency = 1
		itemNameLabel.Text = item.name
		itemNameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
		itemNameLabel.TextSize = 16
		itemNameLabel.Font = Enum.Font.GothamBold
		itemNameLabel.TextXAlignment = Enum.TextXAlignment.Left
		itemNameLabel.TextYAlignment = Enum.TextYAlignment.Top
		itemNameLabel.Parent = infoFrame
		
		-- Description
		local descLabel = Instance.new("TextLabel")
		descLabel.Name = "Description"
		descLabel.Size = UDim2.new(1, 0, 0.5, 0)
		descLabel.Position = UDim2.new(0, 0, 0.5, 0)
		descLabel.BackgroundTransparency = 1
		descLabel.Text = item.description
		descLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
		descLabel.TextSize = 12
		descLabel.Font = Enum.Font.Gotham
		descLabel.TextXAlignment = Enum.TextXAlignment.Left
		descLabel.TextYAlignment = Enum.TextYAlignment.Top
		descLabel.Parent = infoFrame
		
		-- Right side: Price and Buy button
		local actionFrame = Instance.new("Frame")
		actionFrame.Name = "ActionFrame"
		actionFrame.Size = UDim2.new(0.45, -6, 1, 0)  -- 45% of width
		actionFrame.Position = UDim2.new(0.55, 6, 0, 0)
		actionFrame.BackgroundTransparency = 1
		actionFrame.BorderSizePixel = 0
		actionFrame.Parent = itemFrame
		
		-- Price label (fully visible, centered top)
		local priceLabel = Instance.new("TextLabel")
		priceLabel.Name = "Price"
		priceLabel.Size = UDim2.new(1, 0, 0.4, 0)
		priceLabel.Position = UDim2.new(0, 0, 0, 0)
		priceLabel.BackgroundTransparency = 1
		priceLabel.Text = "💰 " .. item.price
		priceLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
		priceLabel.TextSize = 18
		priceLabel.Font = Enum.Font.GothamBold
		priceLabel.TextXAlignment = Enum.TextXAlignment.Center
		priceLabel.TextYAlignment = Enum.TextYAlignment.Center
		priceLabel.Parent = actionFrame
		
		-- Buy button (below price, not overlapping)
		local buyButton = Instance.new("TextButton")
		buyButton.Name = "BuyButton"
		buyButton.Size = UDim2.new(0.8, 0, 0.45, 0)
		buyButton.Position = UDim2.new(0.1, 0, 0.5, 0)
		buyButton.BackgroundColor3 = Color3.fromRGB(50, 180, 100)
		buyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
		buyButton.TextSize = 14
		buyButton.Font = Enum.Font.GothamBold
		buyButton.Text = "BUY"
		buyButton.ZIndex = 2
		buyButton.Parent = actionFrame
		
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
	
	-- Calculate canvas size for scrolling
	local itemHeight = 80 + 8  -- Item height + padding
	local totalHeight = (#items * itemHeight) + (8 * (#items - 1))  -- Total items + gaps
	itemsScroll.CanvasSize = UDim2.new(0, 0, 0, totalHeight + 20)
	
	-- Close Button (at bottom)
	local closeButton = Instance.new("TextButton")
	closeButton.Name = "CloseButton"
	closeButton.Size = UDim2.new(0, 120, 0, 45)
	closeButton.Position = UDim2.new(0.5, -60, 1, -55)
	closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
	closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	closeButton.TextSize = 16
	closeButton.Font = Enum.Font.GothamBold
	closeButton.Text = "CLOSE"
	closeButton.ZIndex = 3
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
