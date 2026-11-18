-- MoneyService: pays every placed brainrot's money per second into its
-- owner's cash, once a second, with the owner's rebirth multiplier applied.
-- Recomputes each owner's income from their plot so the HUD stays honest.

local Players = game:GetService("Players")

local DataService = require(script.Parent.DataService)
local PlotService = require(script.Parent.PlotService)

local MoneyService = {}

local function computeIncomePerSecond(player: Player): number
	local total = 0
	for _, record in ipairs(PlotService.getPlacedBrainrots(player)) do
		total += record.brainrot.moneyPerSecond
	end
	return total * DataService.getIncomeMultiplier(player)
end

function MoneyService.payOutOneSecond()
	for _, player in ipairs(Players:GetPlayers()) do
		local income = computeIncomePerSecond(player)
		DataService.setIncomePerSecond(player, income)
		if income > 0 then
			DataService.addCash(player, income)
		end
	end
end

function MoneyService.init()
	task.spawn(function()
		while true do
			task.wait(1)
			MoneyService.payOutOneSecond()
		end
	end)
end

return MoneyService
