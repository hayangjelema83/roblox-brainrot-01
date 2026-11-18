-- WaveService: the tsunami. Every few minutes the tower flashes a
-- warning, the wave sweeps the island, every uncollected conveyor
-- brainrot washes away, and players caught outside their base get
-- knocked back to spawn. Dash home when the siren sounds.

local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")

local BrainrotConfig = require(game:GetService("ReplicatedStorage").Shared.BrainrotConfig)

local WaveService = {}

local remotes
local secondsUntilWave = BrainrotConfig.WAVE_INTERVAL
local warningActive = false

function WaveService.getSecondsUntilWave(): number
	return secondsUntilWave
end

function WaveService.isWarningActive(): boolean
	return warningActive
end

local function flashTowerLight(on: boolean)
	local light = Workspace:FindFirstChild("TowerLight")
	if light and light:IsA("BasePart") then
		light.Color = on and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(120, 120, 120)
	end
end

local function sweepPlayersBackToSpawn()
	for _, player in ipairs(Players:GetPlayers()) do
		local character = player.Character
		local root = character and character:FindFirstChild("HumanoidRootPart")
		if root then
			root.CFrame = CFrame.new(0, 5, 45)
		end
	end
end

local function triggerTsunami(spawner)
	warningActive = false
	flashTowerLight(false)
	remotes.Notify:FireAllClients("🌊 TSUNAMI! The wave sweeps the island!")
	remotes.WaveEvent:FireAllClients("hit")
	spawner.washAwayAll()
	sweepPlayersBackToSpawn()
	secondsUntilWave = BrainrotConfig.WAVE_INTERVAL
end

local function warnPlayers()
	warningActive = true
	flashTowerLight(true)
	remotes.Notify:FireAllClients("⚠️ TSUNAMI WARNING! Get back to your base in " .. BrainrotConfig.WAVE_WARNING_SECONDS .. " seconds!")
	remotes.WaveEvent:FireAllClients("warning")
end

function WaveService.init(remoteFolder: Folder, spawner)
	remotes = remoteFolder
	task.spawn(function()
		while true do
			task.wait(1)
			secondsUntilWave -= 1
			remotes.WaveTimer:FireAllClients(secondsUntilWave, warningActive)
			if secondsUntilWave == BrainrotConfig.WAVE_WARNING_SECONDS then
				warnPlayers()
			elseif secondsUntilWave <= 0 then
				triggerTsunami(spawner)
			end
		end
	end)
end

return WaveService
