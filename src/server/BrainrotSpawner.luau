-- BrainrotSpawner: runs the conveyor. Every few seconds a new brainrot
-- walks out of the cave and strolls down the lane; a player who walks up
-- to it and holds the buy prompt pays its price and it walks to their plot.
-- Unbought brainrots that reach the end of the lane wander off and despawn.

local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local BrainrotConfig = require(ReplicatedStorage.Shared.BrainrotConfig)
local BrainrotModelBuilder = require(ReplicatedStorage.Shared.BrainrotModelBuilder)
local DataService = require(script.Parent.DataService)
local PlotService = require(script.Parent.PlotService)

local BrainrotSpawner = {}

local activeBrainrots = {}
local remotes

local function broadcastConveyor()
	local list = {}
	for _, entry in ipairs(activeBrainrots) do
		table.insert(list, {
			name = entry.brainrot.name,
			rarity = entry.brainrot.rarity,
			moneyPerSecond = entry.brainrot.moneyPerSecond * entry.mutationMultiplier,
			price = entry.price,
			mutation = entry.mutationName,
		})
	end
	remotes.ConveyorUpdate:FireAllClients(list)
end

local function addBuyPrompt(model: Model, entry)
	local prompt = Instance.new("ProximityPrompt")
	prompt.ActionText = "Buy"
	prompt.ObjectText = entry.brainrot.name
	prompt.HoldDuration = 0.5
	prompt.MaxActivationDistance = 12
	prompt.Parent = model.PrimaryPart
	prompt.Triggered:Connect(function(player: Player)
		BrainrotSpawner.buyBrainrot(player, entry)
	end)
end

function BrainrotSpawner.spawnBrainrot()
	local brainrot = BrainrotConfig.pickRandomBrainrot()
	local mutationName, multiplier, mutationColor = BrainrotConfig.rollMutation()
	local price = brainrot.price * multiplier
	local model = BrainrotModelBuilder.buildBrainrotModel(brainrot, BrainrotConfig.CONVEYOR_START, mutationName, mutationColor)
	model.Parent = Workspace
	local entry = {
		brainrot = brainrot,
		mutationName = mutationName,
		mutationMultiplier = multiplier,
		price = price,
		model = model,
		position = BrainrotConfig.CONVEYOR_START,
	}
	addBuyPrompt(model, entry)
	table.insert(activeBrainrots, entry)
	broadcastConveyor()
	return entry
end

-- A player buys a conveyor brainrot: cash is checked server-side, the
-- model walks to the buyer's plot, and the shop list refreshes for everyone.
function BrainrotSpawner.buyBrainrot(player: Player, entry): boolean
	for index, active in ipairs(activeBrainrots) do
		if active == entry then
			if not DataService.spendCash(player, entry.price) then
				remotes.Notify:FireClient(player, "Not enough cash for " .. entry.brainrot.name .. "!")
				return false
			end
			table.remove(activeBrainrots, index)
			local slotIndex = PlotService.placeBrainrotOnPlot(player, entry.model, entry.brainrot, entry.mutationName)
			if not slotIndex then
				DataService.addCash(player, entry.price)
				entry.model:Destroy()
				remotes.Notify:FireClient(player, "Your base is full! Cash refunded.")
				return false
			end
			local prompt = entry.model.PrimaryPart:FindFirstChildOfClass("ProximityPrompt")
			if prompt then
				prompt:Destroy()
			end
			remotes.Notify:FireClient(player, "You bought " .. entry.brainrot.name .. " for " .. BrainrotConfig.formatMoney(entry.price) .. "!")
			broadcastConveyor()
			return true
		end
	end
	return false
end

-- Washes one conveyor brainrot away (tsunami) or despawns it at the lane end.
function BrainrotSpawner.removeBrainrot(entry, silent: boolean)
	for index, active in ipairs(activeBrainrots) do
		if active == entry then
			table.remove(activeBrainrots, index)
			active.model:Destroy()
			if not silent then
				broadcastConveyor()
			end
			return true
		end
	end
	return false
end

function BrainrotSpawner.getActiveBrainrots()
	return activeBrainrots
end

function BrainrotSpawner.washAwayAll()
	for index = #activeBrainrots, 1, -1 do
		activeBrainrots[index].model:Destroy()
		table.remove(activeBrainrots, index)
	end
	broadcastConveyor()
end

local function walkConveyor(dt: number)
	for index = #activeBrainrots, 1, -1 do
		local entry = activeBrainrots[index]
		local nextPosition = entry.position + Vector3.new(0, 0, BrainrotConfig.CONVEYOR_SPEED * dt)
		if nextPosition.Z >= BrainrotConfig.CONVEYOR_END.Z then
			entry.model:Destroy()
			table.remove(activeBrainrots, index)
			broadcastConveyor()
		else
			entry.position = nextPosition
			entry.model:PivotTo(CFrame.new(nextPosition))
		end
	end
end

function BrainrotSpawner.init(remoteFolder: Folder)
	remotes = remoteFolder
	task.spawn(function()
		while true do
			task.wait(BrainrotConfig.SPAWN_INTERVAL)
			BrainrotSpawner.spawnBrainrot()
		end
	end)
	game:GetService("RunService").Heartbeat:Connect(walkConveyor)
end

return BrainrotSpawner
