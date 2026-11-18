-- BrainrotConfig: the single source of truth for Brainrot Bay's cast.
-- Every brainrot has a name, a rarity ladder rung, money per second,
-- a buy price, and the colors its 3D model is built from.
-- The server (spawner, money, plots) and the client (shop UI) both read it.

local BrainrotConfig = {}

BrainrotConfig.RARITY_ORDER = { "Common", "Rare", "Epic", "Legendary", "Mythic", "Secret" }

BrainrotConfig.RARITY_COLORS = {
	Common = Color3.fromRGB(200, 200, 200),
	Rare = Color3.fromRGB(70, 160, 255),
	Epic = Color3.fromRGB(180, 90, 255),
	Legendary = Color3.fromRGB(255, 180, 30),
	Mythic = Color3.fromRGB(255, 60, 90),
	Secret = Color3.fromRGB(255, 215, 0),
}

-- Roster: 12 brainrots, two per rarity, cheapest first.
BrainrotConfig.BRAINROTS = {
	{
		id = "noodle_ned",
		name = "Noodle Ned",
		rarity = "Common",
		moneyPerSecond = 2,
		price = 25,
		bodyColor = Color3.fromRGB(245, 210, 110),
		headColor = Color3.fromRGB(250, 230, 160),
		accessory = "NoodleHat",
		blurb = "A noodle who achieved sentience and immediately regretted it.",
	},
	{
		id = "pickle_pete",
		name = "Pickle Pete",
		rarity = "Common",
		moneyPerSecond = 3,
		price = 50,
		bodyColor = Color3.fromRGB(90, 180, 70),
		headColor = Color3.fromRGB(120, 210, 90),
		accessory = "PickleCap",
		blurb = "Brined, bold, and somehow always in a jar.",
	},
	{
		id = "dj_turnip",
		name = "DJ Turnip",
		rarity = "Rare",
		moneyPerSecond = 8,
		price = 150,
		bodyColor = Color3.fromRGB(220, 220, 240),
		headColor = Color3.fromRGB(180, 120, 255),
		accessory = "Headphones",
		blurb = "Drops beets. Literally. He is a beet.",
	},
	{
		id = "captain_crumb",
		name = "Captain Crumb",
		rarity = "Rare",
		moneyPerSecond = 10,
		price = 250,
		bodyColor = Color3.fromRGB(160, 110, 60),
		headColor = Color3.fromRGB(200, 150, 80),
		accessory = "PirateHat",
		blurb = "Sailed seven seas looking for a bigger biscuit.",
	},
	{
		id = "sir_toaster",
		name = "Sir Reginald Toaster",
		rarity = "Epic",
		moneyPerSecond = 25,
		price = 700,
		bodyColor = Color3.fromRGB(180, 180, 190),
		headColor = Color3.fromRGB(220, 220, 230),
		accessory = "TopHat",
		blurb = "Knighted for services to breakfast. Burns everything.",
	},
	{
		id = "disco_duck",
		name = "Disco Duck",
		rarity = "Epic",
		moneyPerSecond = 30,
		price = 1000,
		bodyColor = Color3.fromRGB(255, 230, 90),
		headColor = Color3.fromRGB(255, 200, 40),
		accessory = "DiscoBall",
		blurb = "Quacks on the beat. Never leaves the dance floor.",
	},
	{
		id = "prof_bubblegum",
		name = "Professor Bubblegum",
		rarity = "Legendary",
		moneyPerSecond = 70,
		price = 2500,
		bodyColor = Color3.fromRGB(255, 130, 200),
		headColor = Color3.fromRGB(255, 170, 220),
		accessory = "Glasses",
		blurb = "Holds three PhDs in chewing. Pops with authority.",
	},
	{
		id = "sardine_samurai",
		name = "Sardine Samurai",
		rarity = "Legendary",
		moneyPerSecond = 90,
		price = 4000,
		bodyColor = Color3.fromRGB(140, 170, 200),
		headColor = Color3.fromRGB(180, 200, 220),
		accessory = "Katana",
		blurb = "A tiny fish with a big sword and bigger honour.",
	},
	{
		id = "waffle_wizard",
		name = "Waffle Wizard",
		rarity = "Mythic",
		moneyPerSecond = 200,
		price = 10000,
		bodyColor = Color3.fromRGB(200, 150, 80),
		headColor = Color3.fromRGB(230, 180, 110),
		accessory = "WizardHat",
		blurb = "Casts syrup. His spells are delicious and sticky.",
	},
	{
		id = "turbo_turnip",
		name = "Turbo Turnip Prime",
		rarity = "Mythic",
		moneyPerSecond = 250,
		price = 15000,
		bodyColor = Color3.fromRGB(255, 120, 60),
		headColor = Color3.fromRGB(255, 160, 90),
		accessory = "TurboFlame",
		blurb = "The fastest root vegetable ever grown. Zero to salad in 0.2s.",
	},
	{
		id = "golden_gondola",
		name = "The Golden Gondola",
		rarity = "Secret",
		moneyPerSecond = 600,
		price = 50000,
		bodyColor = Color3.fromRGB(255, 215, 0),
		headColor = Color3.fromRGB(255, 235, 120),
		accessory = "GoldCrown",
		blurb = "A boat that refused to float and became rich instead.",
	},
	{
		id = "ceo_naps",
		name = "CEO of Naps",
		rarity = "Secret",
		moneyPerSecond = 800,
		price = 75000,
		bodyColor = Color3.fromRGB(120, 110, 200),
		headColor = Color3.fromRGB(160, 150, 230),
		accessory = "SleepMask",
		blurb = "Runs a billion-dollar company from under a blanket.",
	},
}

-- Mutations: rolled when a brainrot spawns on the conveyor.
-- Rarer mutations multiply the money per second.
BrainrotConfig.MUTATIONS = {
	{ name = "Golden", multiplier = 2, chance = 0.12, color = Color3.fromRGB(255, 215, 0) },
	{ name = "Diamond", multiplier = 5, chance = 0.05, color = Color3.fromRGB(170, 230, 255) },
	{ name = "Rainbow", multiplier = 10, chance = 0.015, color = Color3.fromRGB(255, 100, 200) },
	{ name = "Lava", multiplier = 4, chance = 0.03, color = Color3.fromRGB(255, 80, 20) },
}

-- Rarity weights for the conveyor: commons walk out often, secrets almost never.
BrainrotConfig.RARITY_WEIGHTS = {
	Common = 45,
	Rare = 25,
	Epic = 15,
	Legendary = 9,
	Mythic = 4.5,
	Secret = 1.5,
}

BrainrotConfig.SPAWN_INTERVAL = 4
BrainrotConfig.CONVEYOR_START = Vector3.new(0, 2, -95)
BrainrotConfig.CONVEYOR_END = Vector3.new(0, 2, 70)
BrainrotConfig.CONVEYOR_SPEED = 6
BrainrotConfig.PLOT_SLOTS = 6
BrainrotConfig.PLOT_LOCK_COST = 500
BrainrotConfig.PLOT_LOCK_SECONDS = 60
BrainrotConfig.WAVE_INTERVAL = 180
BrainrotConfig.WAVE_WARNING_SECONDS = 20

function BrainrotConfig.getById(id: string)
	for _, brainrot in ipairs(BrainrotConfig.BRAINROTS) do
		if brainrot.id == id then
			return brainrot
		end
	end
	return nil
end

function BrainrotConfig.rollMutation(): (string?, number, Color3?)
	local roll = math.random()
	local cumulative = 0
	for _, mutation in ipairs(BrainrotConfig.MUTATIONS) do
		cumulative += mutation.chance
		if roll <= cumulative then
			return mutation.name, mutation.multiplier, mutation.color
		end
	end
	return nil, 1, nil
end

function BrainrotConfig.pickRandomBrainrot()
	local total = 0
	for _, weight in pairs(BrainrotConfig.RARITY_WEIGHTS) do
		total += weight
	end
	local roll = math.random() * total
	local running = 0
	local pickedRarity = "Common"
	for _, rarity in ipairs(BrainrotConfig.RARITY_ORDER) do
		running += BrainrotConfig.RARITY_WEIGHTS[rarity]
		if roll <= running then
			pickedRarity = rarity
			break
		end
	end
	local pool = {}
	for _, brainrot in ipairs(BrainrotConfig.BRAINROTS) do
		if brainrot.rarity == pickedRarity then
			table.insert(pool, brainrot)
		end
	end
	return pool[math.random(1, #pool)]
end

function BrainrotConfig.formatMoney(amount: number): string
	if amount >= 1000000 then
		return string.format("$%.1fM", amount / 1000000)
	elseif amount >= 1000 then
		return string.format("$%.1fK", amount / 1000)
	else
		return string.format("$%d", math.floor(amount))
	end
end

return BrainrotConfig
