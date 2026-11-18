-- init.server: wires Brainrot Bay together. Creates the RemoteEvents the
-- client talks to, then starts each server service in dependency order:
-- data first, then plots, spawner, money, stealing, waves and rebirths.

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local remotes = ReplicatedStorage:WaitForChild("Remotes")

local function createRemote(name: string, className: string)
	local existing = remotes:FindFirstChild(name)
	if existing then
		return existing
	end
	local remote = Instance.new(className)
	remote.Name = name
	remote.Parent = remotes
	return remote
end

createRemote("ConveyorUpdate", "RemoteEvent")
createRemote("Notify", "RemoteEvent")
createRemote("WaveTimer", "RemoteEvent")
createRemote("WaveEvent", "RemoteEvent")
createRemote("StealRequest", "RemoteEvent")
createRemote("LockRequest", "RemoteEvent")
createRemote("RebirthRequest", "RemoteEvent")

local DataService = require(script.DataService)
local PlotService = require(script.PlotService)
local BrainrotSpawner = require(script.BrainrotSpawner)
local MoneyService = require(script.MoneyService)
local StealService = require(script.StealService)
local WaveService = require(script.WaveService)
local RebirthService = require(script.RebirthService)

DataService.init()
PlotService.init()
BrainrotSpawner.init(remotes)
MoneyService.init()
StealService.init(remotes)
WaveService.init(remotes, BrainrotSpawner)
RebirthService.init(remotes)

print("Brainrot Bay is live: conveyor, plots, money, stealing, waves and rebirths running.")
