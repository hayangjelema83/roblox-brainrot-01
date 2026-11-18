-- HUDController.client: the top bar of Brainrot Bay. Shows cash, income
-- per second, rebirth count and multiplier, plus the tsunami countdown
-- and the Lock Base and Rebirth buttons. Kept clear of the top-left
-- corner, where Roblox's own menu buttons sit.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local BrainrotConfig = require(ReplicatedStorage.Shared.BrainrotConfig)

local player = Players.LocalPlayer
local remotes = ReplicatedStorage:WaitForChild("Remotes")

local gui = Instance.new("ScreenGui")
gui.Name = "BrainrotBayHUD"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true

local bar = Instance.new("Frame")
bar.Name = "TopBar"
bar.AnchorPoint = Vector2.new(0.5, 0)
bar.Position = UDim2.new(0.5, 0, 0, 8)
bar.Size = UDim2.fromOffset(720, 52)
bar.BackgroundColor3 = Color3.fromRGB(10, 30, 60)
bar.BackgroundTransparency = 0.15
bar.BorderSizePixel = 0
bar.Parent = gui

local function makeStat(name: string, xOffset: number, width: number, color: Color3): TextLabel
	local label = Instance.new("TextLabel")
	label.Name = name
	label.Position = UDim2.fromOffset(xOffset, 6)
	label.Size = UDim2.fromOffset(width, 40)
	label.BackgroundTransparency = 1
	label.TextColor3 = color
	label.TextSize = 22
	label.Font = Enum.Font.GothamBold
	label.Text = ""
	label.Parent = bar
	return label
end

local cashLabel = makeStat("CashLabel", 12, 180, Color3.fromRGB(120, 255, 120))
local incomeLabel = makeStat("IncomeLabel", 200, 170, Color3.fromRGB(255, 220, 100))
local rebirthLabel = makeStat("RebirthLabel", 378, 150, Color3.fromRGB(200, 160, 255))
local waveLabel = makeStat("WaveLabel", 536, 172, Color3.fromRGB(120, 200, 255))

local lockButton = Instance.new("TextButton")
lockButton.Name = "LockButton"
lockButton.AnchorPoint = Vector2.new(1, 0)
lockButton.Position = UDim2.new(1, -12, 0, 68)
lockButton.Size = UDim2.fromOffset(150, 44)
lockButton.BackgroundColor3 = Color3.fromRGB(40, 120, 220)
lockButton.TextColor3 = Color3.fromRGB(255, 255, 255)
lockButton.TextSize = 18
lockButton.Font = Enum.Font.GothamBold
lockButton.Text = "🔒 Lock Base $500"
lockButton.Parent = gui

local rebirthButton = Instance.new("TextButton")
rebirthButton.Name = "RebirthButton"
rebirthButton.AnchorPoint = Vector2.new(1, 0)
rebirthButton.Position = UDim2.new(1, -12, 0, 120)
rebirthButton.Size = UDim2.fromOffset(150, 44)
rebirthButton.BackgroundColor3 = Color3.fromRGB(150, 60, 220)
rebirthButton.TextColor3 = Color3.fromRGB(255, 255, 255)
rebirthButton.TextSize = 18
rebirthButton.Font = Enum.Font.GothamBold
rebirthButton.Text = "✨ Rebirth"
rebirthButton.Parent = gui

local function refreshStats()
	local leaderstats = player:FindFirstChild("leaderstats")
	if not leaderstats then
		return
	end
	local cash = leaderstats:FindFirstChild("Cash")
	local income = leaderstats:FindFirstChild("IncomePerSec")
	local rebirths = leaderstats:FindFirstChild("Rebirths")
	if cash then
		cashLabel.Text = "💰 " .. BrainrotConfig.formatMoney(cash.Value)
	end
	if income then
		incomeLabel.Text = BrainrotConfig.formatMoney(income.Value) .. "/s"
	end
	if rebirths then
		rebirthLabel.Text = "🔄 Rebirths: " .. rebirths.Value
	end
end

local function refreshWaveTimer(secondsLeft: number, warning: boolean)
	if warning then
		waveLabel.Text = "🌊 WAVE IN " .. secondsLeft .. "s!"
		waveLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
	else
		local minutes = math.floor(secondsLeft / 60)
		local seconds = secondsLeft % 60
		waveLabel.Text = "🌊 " .. minutes .. ":" .. string.format("%02d", seconds)
		waveLabel.TextColor3 = Color3.fromRGB(120, 200, 255)
	end
end

lockButton.MouseButton1Click:Connect(function()
	remotes.LockRequest:FireServer()
end)

rebirthButton.MouseButton1Click:Connect(function()
	remotes.RebirthRequest:FireServer()
end)

remotes.WaveTimer.OnClientEvent:Connect(refreshWaveTimer)

player:WaitForChild("leaderstats")
local leaderstats = player.leaderstats
for _, child in ipairs(leaderstats:GetChildren()) do
	child:GetPropertyChangedSignal("Value"):Connect(refreshStats)
end
refreshStats()
gui.Parent = player:WaitForChild("PlayerGui")
