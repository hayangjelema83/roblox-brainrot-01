-- BrainrotModelBuilder: builds a brainrot's 3D character out of Parts.
-- One job: given a roster entry (and an optional mutation), return a Model
-- the spawner can drop on the conveyor or a plot can hold on a slot.
-- Body, head, eyes and one accessory per character, driven by BrainrotConfig.

local BrainrotModelBuilder = {}

local function makePart(name: string, size: Vector3, color: Color3, material: Enum.Material): Part
	local part = Instance.new("Part")
	part.Name = name
	part.Size = size
	part.Color = color
	part.Material = material
	part.Anchored = true
	part.CanCollide = false
	part.TopSurface = Enum.SurfaceType.Smooth
	part.BottomSurface = Enum.SurfaceType.Smooth
	return part
end

local function addEyes(head: Part, parent: Model)
	for _, side in ipairs({ -1, 1 }) do
		local eye = makePart("Eye", Vector3.new(0.35, 0.5, 0.2), Color3.fromRGB(20, 20, 20), Enum.Material.SmoothPlastic)
		eye.Position = head.Position + Vector3.new(0.45 * side, 0.25, head.Size.Z / 2 + 0.05)
		eye.Parent = parent
	end
end

local function addAccessory(accessory: string, head: Part, body: Part, parent: Model, accent: Color3)
	if accessory == "NoodleHat" then
		local hat = makePart("NoodleHat", Vector3.new(2.4, 0.5, 2.4), Color3.fromRGB(250, 220, 120), Enum.Material.SmoothPlastic)
		hat.Position = head.Position + Vector3.new(0, 1.1, 0)
		hat.Parent = parent
	elseif accessory == "PickleCap" then
		local cap = makePart("PickleCap", Vector3.new(2, 0.6, 2), Color3.fromRGB(60, 140, 50), Enum.Material.SmoothPlastic)
		cap.Position = head.Position + Vector3.new(0, 1, 0)
		cap.Parent = parent
	elseif accessory == "Headphones" then
		for _, side in ipairs({ -1, 1 }) do
			local cup = makePart("Headphone", Vector3.new(0.4, 0.9, 0.9), Color3.fromRGB(30, 30, 40), Enum.Material.SmoothPlastic)
			cup.Position = head.Position + Vector3.new(1.15 * side, 0.1, 0)
			cup.Parent = parent
		end
		local band = makePart("HeadphoneBand", Vector3.new(2.4, 0.3, 0.4), Color3.fromRGB(30, 30, 40), Enum.Material.SmoothPlastic)
		band.Position = head.Position + Vector3.new(0, 1.05, 0)
		band.Parent = parent
	elseif accessory == "PirateHat" then
		local hat = makePart("PirateHat", Vector3.new(2.6, 0.4, 2.2), Color3.fromRGB(25, 25, 30), Enum.Material.SmoothPlastic)
		hat.Position = head.Position + Vector3.new(0, 1, 0)
		hat.Parent = parent
	elseif accessory == "TopHat" then
		local hat = makePart("TopHat", Vector3.new(1.4, 1.4, 1.4), Color3.fromRGB(20, 20, 25), Enum.Material.SmoothPlastic)
		hat.Position = head.Position + Vector3.new(0, 1.4, 0)
		hat.Parent = parent
	elseif accessory == "DiscoBall" then
		local ball = makePart("DiscoBall", Vector3.new(1.1, 1.1, 1.1), Color3.fromRGB(220, 230, 255), Enum.Material.Metal)
		ball.Shape = Enum.PartType.Ball
		ball.Position = head.Position + Vector3.new(0, 1.6, 0)
		ball.Parent = parent
	elseif accessory == "Glasses" then
		for _, side in ipairs({ -1, 1 }) do
			local lens = makePart("GlassesLens", Vector3.new(0.8, 0.8, 0.15), Color3.fromRGB(180, 220, 255), Enum.Material.Glass)
			lens.Position = head.Position + Vector3.new(0.5 * side, 0.2, head.Size.Z / 2 + 0.08)
			lens.Parent = parent
		end
	elseif accessory == "Katana" then
		local blade = makePart("Katana", Vector3.new(0.25, 0.25, 3), Color3.fromRGB(220, 230, 240), Enum.Material.Metal)
		blade.Position = body.Position + Vector3.new(1.6, 0.5, 0.5)
		blade.Parent = parent
	elseif accessory == "WizardHat" then
		local cone = makePart("WizardHat", Vector3.new(2, 2.2, 2), Color3.fromRGB(90, 50, 160), Enum.Material.SmoothPlastic)
		cone.Position = head.Position + Vector3.new(0, 1.8, 0)
		cone.Parent = parent
	elseif accessory == "TurboFlame" then
		local flame = makePart("TurboFlame", Vector3.new(1.2, 1.2, 1.2), Color3.fromRGB(255, 120, 20), Enum.Material.Neon)
		flame.Shape = Enum.PartType.Ball
		flame.Position = body.Position + Vector3.new(0, 0, -1.4)
		flame.Parent = parent
	elseif accessory == "GoldCrown" then
		local crown = makePart("GoldCrown", Vector3.new(1.8, 0.6, 1.8), Color3.fromRGB(255, 215, 0), Enum.Material.Metal)
		crown.Position = head.Position + Vector3.new(0, 1.1, 0)
		crown.Parent = parent
	elseif accessory == "SleepMask" then
		local mask = makePart("SleepMask", Vector3.new(1.9, 0.5, 0.3), Color3.fromRGB(60, 50, 120), Enum.Material.SmoothPlastic)
		mask.Position = head.Position + Vector3.new(0, 0.25, head.Size.Z / 2 + 0.05)
		mask.Parent = parent
	end
end

-- Builds the model at the given position, facing +Z. Returns the Model.
function BrainrotModelBuilder.buildBrainrotModel(brainrot, position: Vector3, mutationName: string?, mutationColor: Color3?): Model
	local model = Instance.new("Model")
	model.Name = brainrot.name

	local bodyColor = brainrot.bodyColor
	local headColor = brainrot.headColor
	if mutationColor then
		bodyColor = mutationColor
	end

	local body = makePart("Body", Vector3.new(2.2, 2, 1.6), bodyColor, Enum.Material.SmoothPlastic)
	body.Position = position + Vector3.new(0, 1, 0)
	body.Parent = model

	local head = makePart("Head", Vector3.new(2, 1.8, 1.8), headColor, Enum.Material.SmoothPlastic)
	head.Position = position + Vector3.new(0, 2.9, 0)
	head.Parent = model

	addEyes(head, model)
	addAccessory(brainrot.accessory, head, body, model, bodyColor)

	-- Feet so it reads as a little walking character on the conveyor.
	for _, side in ipairs({ -1, 1 }) do
		local foot = makePart("Foot", Vector3.new(0.8, 0.4, 1), Color3.fromRGB(40, 40, 45), Enum.Material.SmoothPlastic)
		foot.Position = position + Vector3.new(0.6 * side, 0.2, 0)
		foot.Parent = model
	end

	-- A floating name tag above the head, readable from across the island.
	local tag = Instance.new("BillboardGui")
	tag.Name = "NameTag"
	tag.Size = UDim2.fromOffset(120, 44)
	tag.StudsOffset = Vector3.new(0, 4.6, 0)
	tag.AlwaysOnTop = true
	local label = Instance.new("TextLabel")
	label.Name = "NameLabel"
	label.Size = UDim2.fromScale(1, 1)
	label.BackgroundTransparency = 0.4
	label.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	label.TextColor3 = Color3.fromRGB(255, 255, 255)
	label.TextScaled = true
	label.Font = Enum.Font.GothamBold
	local mutationText = ""
	if mutationName then
		mutationText = " " .. mutationName
	end
	label.Text = brainrot.name .. mutationText .. "\n" .. brainrot.rarity .. "  $" .. brainrot.moneyPerSecond .. "/s"
	label.Parent = tag
	tag.Parent = model

	model.PrimaryPart = body
	return model
end

return BrainrotModelBuilder
