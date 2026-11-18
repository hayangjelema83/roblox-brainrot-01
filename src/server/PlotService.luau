-- PlotService: owns the 8 player plots around the island. Each joining
-- player claims the next free plot; each plot holds up to 6 brainrots on
-- slot pads it builds itself. Stealing reads the lock from here.

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local BrainrotConfig = require(game:GetService("ReplicatedStorage").Shared.BrainrotConfig)

local PlotService = {}

local plots = {}
local playerPlots = {}

local SLOT_OFFSETS = {
	Vector3.new(-7, 0, -7),
	Vector3.new(0, 0, -7),
	Vector3.new(7, 0, -7),
	Vector3.new(-7, 0, 7),
	Vector3.new(0, 0, 7),
	Vector3.new(7, 0, 7),
}

function PlotService.getPlotForPlayer(player: Player)
	return playerPlots[player]
end

function PlotService.isPlotLocked(plot): boolean
	return plot.lockUntil > os.clock()
end

function PlotService.lockPlot(player: Player, seconds: number)
	local plot = playerPlots[player]
	if plot then
		plot.lockUntil = os.clock() + seconds
		return true
	end
	return false
end

function PlotService.findFreeSlot(plot)
	for index, slot in ipairs(plot.slots) do
		if slot.brainrot == nil then
			return index, slot
		end
	end
	return nil, nil
end

-- Places an already-built brainrot model on the owner's next free slot.
-- Returns the slot index, or nil when the plot is full.
function PlotService.placeBrainrotOnPlot(player: Player, model: Model, brainrot, mutationName: string?): number?
	local plot = playerPlots[player]
	if not plot then
		return nil
	end
	local index, slot = PlotService.findFreeSlot(plot)
	if not slot then
		return nil
	end
	model:PivotTo(CFrame.new(slot.position + Vector3.new(0, 0.5, 0)))
	model.Parent = plot.folder
	slot.brainrot = {
		model = model,
		brainrot = brainrot,
		mutationName = mutationName,
	}
	return index
end

-- Removes a brainrot from a slot (steal or rebirth wipe) and returns its record.
function PlotService.removeBrainrotFromSlot(plot, slotIndex: number)
	local slot = plot.slots[slotIndex]
	if not slot then
		return nil
	end
	local record = slot.brainrot
	slot.brainrot = nil
	return record
end

function PlotService.getPlacedBrainrots(player: Player)
	local plot = playerPlots[player]
	local placed = {}
	if not plot then
		return placed
	end
	for _, slot in ipairs(plot.slots) do
		if slot.brainrot then
			table.insert(placed, slot.brainrot)
		end
	end
	return placed
end

function PlotService.clearPlot(player: Player)
	local plot = playerPlots[player]
	if not plot then
		return
	end
	for _, slot in ipairs(plot.slots) do
		if slot.brainrot then
			slot.brainrot.model:Destroy()
			slot.brainrot = nil
		end
	end
end

local function buildSlotPads(plot)
	local platform = plot.platform
	for index, offset in ipairs(SLOT_OFFSETS) do
		local pad = Instance.new("Part")
		pad.Name = "Slot" .. index
		pad.Size = Vector3.new(6, 0.4, 6)
		pad.Color = Color3.fromRGB(255, 255, 255)
		pad.Material = Enum.Material.Neon
		pad.Anchored = true
		pad.Position = platform.Position + offset + Vector3.new(0, 0.7, 0)
		pad.Parent = plot.folder
		table.insert(plot.slots, {
			position = pad.Position,
			pad = pad,
			brainrot = nil,
		})
	end
end

local function claimPlot(player: Player)
	for _, plot in ipairs(plots) do
		if plot.owner == nil then
			plot.owner = player
			playerPlots[player] = plot
			plot.sign.Text = player.DisplayName .. "'s Base"
			return plot
		end
	end
	return nil
end

local function releasePlot(player: Player)
	local plot = playerPlots[player]
	if not plot then
		return
	end
	PlotService.clearPlot(player)
	plot.owner = nil
	plot.lockUntil = 0
	plot.sign.Text = "Empty Base"
	playerPlots[player] = nil
end

function PlotService.init()
	local folder = Instance.new("Folder")
	folder.Name = "Plots"
	folder.Parent = Workspace
	for index = 1, 8 do
		local platform = Workspace:FindFirstChild("Plot" .. index)
		if platform and platform:IsA("BasePart") then
			local plotFolder = Instance.new("Folder")
			plotFolder.Name = "Plot" .. index
			plotFolder.Parent = folder
			local signGui = Instance.new("BillboardGui")
			signGui.Name = "PlotSign"
			signGui.Size = UDim2.fromOffset(160, 40)
			signGui.StudsOffset = Vector3.new(0, 6, 0)
			signGui.AlwaysOnTop = true
			local signLabel = Instance.new("TextLabel")
			signLabel.Size = UDim2.fromScale(1, 1)
			signLabel.BackgroundTransparency = 0.4
			signLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
			signLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
			signLabel.TextScaled = true
			signLabel.Font = Enum.Font.GothamBold
			signLabel.Text = "Empty Base"
			signLabel.Parent = signGui
			signGui.Parent = platform
			local plot = {
				index = index,
				platform = platform,
				folder = plotFolder,
				sign = signLabel,
				owner = nil,
				lockUntil = 0,
				slots = {},
			}
			buildSlotPads(plot)
			table.insert(plots, plot)
		end
	end
	Players.PlayerAdded:Connect(claimPlot)
	Players.PlayerRemoving:Connect(releasePlot)
	for _, player in ipairs(Players:GetPlayers()) do
		claimPlot(player)
	end
end

return PlotService
