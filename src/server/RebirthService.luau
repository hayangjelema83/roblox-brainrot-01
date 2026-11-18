-- RebirthService: the long ladder. At the rebirth altar a player trades
-- all their cash and every brainrot on their plot for a permanent x2
-- income multiplier. Each rebirth costs more than the last.

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local BrainrotConfig = require(ReplicatedStorage.Shared.BrainrotConfig)
local DataService = require(script.Parent.DataService)
local PlotService = require(script.Parent.PlotService)

local RebirthService = {}

local remotes
local BASE_REBIRTH_COST = 10000

function RebirthService.getRebirthCost(player: Player): number
	return BASE_REBIRTH_COST * (DataService.getRebirths(player) + 1)
end

-- Performs a rebirth: wipes cash and plot, doubles the income multiplier.
function RebirthService.rebirthPlayer(player: Player): boolean
	local cost = RebirthService.getRebirthCost(player)
	if not DataService.spendCash(player, cost) then
		remotes.Notify:FireClient(player, "Rebirth costs " .. BrainrotConfig.formatMoney(cost) .. " — keep earning!")
		return false
	end
	PlotService.clearPlot(player)
	local newMultiplier = DataService.getIncomeMultiplier(player) * 2
	DataService.applyRebirth(player, newMultiplier)
	remotes.Notify:FireClient(player, "✨ REBIRTH! Your income is now x" .. newMultiplier .. " forever!")
	return true
end

function RebirthService.init(remoteFolder: Folder)
	remotes = remoteFolder
	remotes.RebirthRequest.OnServerEvent:Connect(function(player: Player)
		RebirthService.rebirthPlayer(player)
	end)
end

return RebirthService
