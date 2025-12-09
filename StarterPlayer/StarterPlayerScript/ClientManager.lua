-- CLIENT MANAGER
-- Manages client-side initialization and main GUI
print("?? Client Manager starting...")

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Wait for MainGui with timeout
local mainGui = playerGui:WaitForChild("MainGui", 5)
if not mainGui then
	print("?? MainGui not found, creating placeholder...")
	mainGui = Instance.new("ScreenGui")
	mainGui.Name = "MainGui"
	mainGui.Parent = playerGui
end

print("? Client Manager Ready!")