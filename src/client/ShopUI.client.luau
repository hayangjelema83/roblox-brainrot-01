-- ShopUI.client: the conveyor shop panel on the left of the screen.
-- Lists every brainrot currently walking the conveyor with its name,
-- rarity colour, money per second, mutation and price, so the player
-- can spot the rare one and run to buy it before it walks away.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local BrainrotConfig = require(ReplicatedStorage.Shared.BrainrotConfig)

local player = Players.LocalPlayer
local remotes = ReplicatedStorage:WaitForChild("Remotes")

local gui = Instance.new("ScreenGui")
gui.Name = "ConveyorShop"
gui.ResetOnSpawn = false

local panel = Instance.new("Frame")
panel.Name = "ShopPanel"
panel.Position = UDim2.new(0, 12, 0, 140)
panel.Size = UDim2.fromOffset(260, 380)
panel.BackgroundColor3 = Color3.fromRGB(10, 30, 60)
panel.BackgroundTransparency = 0.15
panel.BorderSizePixel = 0
panel.Parent = gui

local title = Instance.new("TextLabel")
title.Name = "ShopTitle"
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 20
title.Font = Enum.Font.GothamBold
title.Text = "🛒 ON THE CONVEYOR"
title.Parent = panel

local list = Instance.new("ScrollingFrame")
list.Name = "BrainrotList"
list.Position = UDim2.new(0, 8, 0, 46)
list.Size = UDim2.new(1, -16, 1, -54)
list.BackgroundTransparency = 1
list.ScrollBarThickness = 6
list.CanvasSize = UDim2.new(0, 0, 0, 0)
list.Parent = panel

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 6)
layout.Parent = list

local function refreshConveyorList(entries)
	for _, child in ipairs(list:GetChildren()) do
		if child:IsA("TextLabel") then
			child:Destroy()
		end
	end
	if #entries == 0 then
		local empty = Instance.new("TextLabel")
		empty.Size = UDim2.new(1, 0, 0, 40)
		empty.BackgroundTransparency = 1
		empty.TextColor3 = Color3.fromRGB(200, 200, 200)
		empty.TextSize = 16
		empty.Font = Enum.Font.Gotham
		empty.Text = "The cave is quiet... wait for it!"
		empty.Parent = list
		return
	end
	for _, entry in ipairs(entries) do
		local row = Instance.new("TextLabel")
		row.Size = UDim2.new(1, 0, 0, 52)
		row.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		row.BackgroundTransparency = 0.85
		row.TextColor3 = Color3.fromRGB(255, 255, 255)
		row.TextSize = 16
		row.Font = Enum.Font.GothamBold
		row.TextXAlignment = Enum.TextXAlignment.Left
		local mutationText = ""
		if entry.mutation then
			mutationText = " [" .. entry.mutation .. "]"
		end
		row.Text = "  " .. entry.name .. mutationText .. "\n  " .. entry.rarity .. "  •  " .. BrainrotConfig.formatMoney(entry.moneyPerSecond) .. "/s  •  " .. BrainrotConfig.formatMoney(entry.price)
		row.Parent = list
	end
	list.CanvasSize = UDim2.new(0, 0, 0, #entries * 58)
end

remotes.ConveyorUpdate.OnClientEvent:Connect(refreshConveyorList)
gui.Parent = player:WaitForChild("PlayerGui")
