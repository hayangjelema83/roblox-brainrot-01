-- Notifications.client: the toast feed at the bottom of the screen.
-- Buy confirmations, steal alerts, tsunami warnings and rebirth news
-- all arrive here, newest on top, fading out after a few seconds.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local remotes = ReplicatedStorage:WaitForChild("Remotes")

local gui = Instance.new("ScreenGui")
gui.Name = "Notifications"
gui.ResetOnSpawn = false

local feed = Instance.new("Frame")
feed.Name = "ToastFeed"
feed.AnchorPoint = Vector2.new(0.5, 1)
feed.Position = UDim2.new(0.5, 0, 1, -16)
feed.Size = UDim2.fromOffset(560, 120)
feed.BackgroundTransparency = 1
feed.Parent = gui

local layout = Instance.new("UIListLayout")
layout.VerticalAlignment = Enum.VerticalAlignment.Bottom
layout.Padding = UDim.new(0, 6)
layout.Parent = feed

local function showNotification(message: string)
	local toast = Instance.new("TextLabel")
	toast.Name = "Toast"
	toast.Size = UDim2.new(1, 0, 0, 36)
	toast.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	toast.BackgroundTransparency = 0.3
	toast.TextColor3 = Color3.fromRGB(255, 255, 255)
	toast.TextSize = 17
	toast.Font = Enum.Font.GothamBold
	toast.Text = message
	toast.Parent = feed
	task.delay(6, function()
		toast:Destroy()
	end)
end

remotes.Notify.OnClientEvent:Connect(showNotification)

remotes.WaveEvent.OnClientEvent:Connect(function(kind: string)
	if kind == "warning" then
		showNotification("⚠️ TSUNAMI WARNING — run back to your base!")
	elseif kind == "hit" then
		showNotification("🌊 The wave swept the conveyor clean!")
	end
end)

gui.Parent = player:WaitForChild("PlayerGui")
