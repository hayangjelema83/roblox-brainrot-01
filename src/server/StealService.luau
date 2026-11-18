-- StealService: the risk half of Brainrot Bay. A player can steal a
-- brainrot off another player's plot while that plot's lock is down;
-- the victim gets an alert, the thief's plot must have a free slot,
-- and the owner can buy a 60-second lock for cash to shut it down.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local BrainrotConfig = require(ReplicatedStorage.Shared.BrainrotConfig)
local DataService = require(script.Parent.DataService)
local PlotService = require(script.Parent.PlotService)

local StealService = {}

local remotes

-- Attempts a steal: the thief takes the brainrot from the victim's slot
-- and it lands on the thief's own plot. Returns true when it worked.
function StealService.stealBrainrot(thief: Player, victim: Player, slotIndex: number): boolean
	local victimPlot = PlotService.getPlotForPlayer(victim)
	local thiefPlot = PlotService.getPlotForPlayer(thief)
	if not victimPlot or not thiefPlot then
		return false
	end
	if thief == victim then
		return false
	end
	if PlotService.isPlotLocked(victimPlot) then
		remotes.Notify:FireClient(thief, victim.DisplayName .. "'s base is locked!")
		return false
	end
	local _, freeSlot = PlotService.findFreeSlot(thiefPlot)
	if not freeSlot then
		remotes.Notify:FireClient(thief, "Your base is full — no room to steal!")
		return false
	end
	local record = PlotService.removeBrainrotFromSlot(victimPlot, slotIndex)
	if not record then
		return false
	end
	local placedIndex = PlotService.placeBrainrotOnPlot(thief, record.model, record.brainrot, record.mutationName)
	if not placedIndex then
		PlotService.placeBrainrotOnPlot(victim, record.model, record.brainrot, record.mutationName)
		return false
	end
	remotes.Notify:FireClient(thief, "You stole " .. record.brainrot.name .. " from " .. victim.DisplayName .. "!")
	remotes.Notify:FireClient(victim, "ALERT: " .. thief.DisplayName .. " stole your " .. record.brainrot.name .. "! Lock your base!")
	return true
end

-- Buys a plot lock: 60 seconds where nobody can steal from this plot.
function StealService.buyPlotLock(player: Player): boolean
	if not DataService.spendCash(player, BrainrotConfig.PLOT_LOCK_COST) then
		remotes.Notify:FireClient(player, "Lock costs " .. BrainrotConfig.formatMoney(BrainrotConfig.PLOT_LOCK_COST) .. " — not enough cash!")
		return false
	end
	PlotService.lockPlot(player, BrainrotConfig.PLOT_LOCK_SECONDS)
	remotes.Notify:FireClient(player, "Base locked for " .. BrainrotConfig.PLOT_LOCK_SECONDS .. " seconds!")
	return true
end

function StealService.init(remoteFolder: Folder)
	remotes = remoteFolder
	remotes.StealRequest.OnServerEvent:Connect(function(thief: Player, victimName: string, slotIndex: number)
		local victim = Players:FindFirstChild(victimName)
		if victim and typeof(slotIndex) == "number" then
			StealService.stealBrainrot(thief, victim, slotIndex)
		end
	end)
	remotes.LockRequest.OnServerEvent:Connect(function(player: Player)
		StealService.buyPlotLock(player)
	end)
end

return StealService
