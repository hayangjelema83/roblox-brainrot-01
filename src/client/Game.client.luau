-- Game.client: the player's feet in Brainrot Bay. Sets the camera to a
-- wide view of the island, adds a run key (LeftShift) for the dash home
-- when the tsunami siren sounds, and shows the welcome tip on join.

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer

local RUN_SPEED = 32
local WALK_SPEED = 16

local function applyRunSpeed()
	local character = player.Character
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")
	if not humanoid then
		return
	end
	if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) or UserInputService:IsKeyDown(Enum.KeyCode.RightShift) then
		humanoid.WalkSpeed = RUN_SPEED
	else
		humanoid.WalkSpeed = WALK_SPEED
	end
end

local function setupCamera()
	local camera = Workspace.CurrentCamera
	if camera then
		camera.FieldOfView = 70
	end
end

local function showWelcomeTip()
	local gui = Instance.new("ScreenGui")
	gui.Name = "WelcomeGui"
	gui.ResetOnSpawn = false
	local tip = Instance.new("TextLabel")
	tip.Name = "WelcomeTip"
	tip.AnchorPoint = Vector2.new(0.5, 0)
	tip.Position = UDim2.new(0.5, 0, 0, 70)
	tip.Size = UDim2.fromOffset(560, 44)
	tip.BackgroundTransparency = 0.3
	tip.BackgroundColor3 = Color3.fromRGB(0, 40, 80)
	tip.TextColor3 = Color3.fromRGB(255, 255, 255)
	tip.TextSize = 20
	tip.Font = Enum.Font.GothamBold
	tip.Text = "Welcome to Brainrot Bay! Buy brainrots off the conveyor, fill your base!"
	tip.Parent = gui
	gui.Parent = player:WaitForChild("PlayerGui")
	task.delay(8, function()
		gui:Destroy()
	end)
end

player.CharacterAdded:Connect(function()
	task.wait(0.5)
	setupCamera()
	applyRunSpeed()
end)

UserInputService.InputBegan:Connect(function(input, processed)
	if processed then
		return
	end
	if input.KeyCode == Enum.KeyCode.LeftShift or input.KeyCode == Enum.KeyCode.RightShift then
		applyRunSpeed()
	end
end)

UserInputService.InputEnded:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.LeftShift or input.KeyCode == Enum.KeyCode.RightShift then
		applyRunSpeed()
	end
end)

setupCamera()
showWelcomeTip()
