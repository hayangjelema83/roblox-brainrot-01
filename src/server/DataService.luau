-- DataService: one place for player state. Owns leaderstats (Cash,
-- IncomePerSec, Rebirths), the income multiplier, and the cash ledger.
-- Every other server module asks DataService, never touches leaderstats itself.

local Players = game:GetService("Players")

local DataService = {}

local START_CASH = 100
local playerData = {}

function DataService.getPlayerData(player: Player)
	return playerData[player]
end

function DataService.getCash(player: Player): number
	local data = playerData[player]
	if data then
		return data.cash
	end
	return 0
end

function DataService.getIncomeMultiplier(player: Player): number
	local data = playerData[player]
	if data then
		return data.multiplier
	end
	return 1
end

function DataService.getRebirths(player: Player): number
	local data = playerData[player]
	if data then
		return data.rebirths
	end
	return 0
end

function DataService.addCash(player: Player, amount: number)
	local data = playerData[player]
	if not data then
		return
	end
	data.cash = math.max(0, data.cash + amount)
	data.leaderstats.Cash.Value = math.floor(data.cash)
end

function DataService.spendCash(player: Player, amount: number): boolean
	local data = playerData[player]
	if not data or data.cash < amount then
		return false
	end
	data.cash -= amount
	data.leaderstats.Cash.Value = math.floor(data.cash)
	return true
end

function DataService.setIncomePerSecond(player: Player, income: number)
	local data = playerData[player]
	if not data then
		return
	end
	data.incomePerSecond = income
	data.leaderstats.IncomePerSec.Value = math.floor(income)
end

function DataService.getIncomePerSecond(player: Player): number
	local data = playerData[player]
	if data then
		return data.incomePerSecond
	end
	return 0
end

function DataService.applyRebirth(player: Player, newMultiplier: number)
	local data = playerData[player]
	if not data then
		return
	end
	data.rebirths += 1
	data.multiplier = newMultiplier
	data.cash = START_CASH
	data.leaderstats.Cash.Value = START_CASH
	data.leaderstats.Rebirths.Value = data.rebirths
end

local function setupPlayer(player: Player)
	local leaderstats = Instance.new("Folder")
	leaderstats.Name = "leaderstats"
	leaderstats.Parent = player

	local cash = Instance.new("IntValue")
	cash.Name = "Cash"
	cash.Value = START_CASH
	cash.Parent = leaderstats

	local income = Instance.new("IntValue")
	income.Name = "IncomePerSec"
	income.Value = 0
	income.Parent = leaderstats

	local rebirths = Instance.new("IntValue")
	rebirths.Name = "Rebirths"
	rebirths.Value = 0
	rebirths.Parent = leaderstats

	playerData[player] = {
		cash = START_CASH,
		incomePerSecond = 0,
		rebirths = 0,
		multiplier = 1,
		leaderstats = leaderstats,
	}
end

local function removePlayer(player: Player)
	playerData[player] = nil
end

function DataService.init()
	Players.PlayerAdded:Connect(setupPlayer)
	Players.PlayerRemoving:Connect(removePlayer)
	for _, player in ipairs(Players:GetPlayers()) do
		setupPlayer(player)
	end
end

return DataService
