local _, ns = ...

ns.config = {
	filterBuffs = 'player target',
	filterDebuffs = 'target focus',
	sortBuffs = '',
	sortDebuffs = 'target',
	showParty = true,
	showPartyPets = true,
	showPartyTargets = true,
	showRaid = true,
	showMTA = true,
	showMTATargets = true,
}

ns.colors = setmetatable({
	disconnected = { 0.42, 0.37, 0.32 },
	health = { 0.17, 0.17, 0.24 },
	power = setmetatable({
		["MANA"] = { 0.31, 0.45, 0.63 },
		["RAGE"] = { 0.69, 0.31, 0.31 },
		["ENERGY"] = { 1, 0.87, 0.4 },
	}, { __index = oUF.colors.power }),
	role = {
		NONE = { 0.5, 0.5, 0.5 },
		TANK = { 0.78, 0.61, 0.43 },
		HEALER = { 0.25, 0.78, 0.92 },
		DAMAGER = { 0.77, 0.12, 0.23 },
	},
	smooth = setmetatable({
		0.69, 0.31, 0.31,
		0.71, 0.43, 0.27,
		0.17, 0.17, 0.24,
	}, { __index = oUF.colors.smooth }),
	tapped = { 0.42, 0.37, 0.32 },
	totems = {
		{ 0.71, 0.29, 0.13 }, -- red    181 /  73 /  33
		{ 0.26, 0.71, 0.13 }, -- green   67 / 181 /  33
		{ 0.13, 0.55, 0.71 }, -- blue    33 / 141 / 181
		{ 0.58, 0.13, 0.71 }, -- violet 147 /  33 / 181
		{ 0.71, 0.58, 0.13 }, -- yellow 181 / 147 /  33
	},
}, { __index = oUF.colors })

ns.assets = {
	BUTTONOVERLAY = [=[Interface\AddOns\oUF_Layout\assets\textures\buttonoverlay]=],
	GLOW = {
		edgeFile = [=[Interface\AddOns\oUF_Layout\assets\textures\glow]=],
		edgeSize = 2,
		bgFile = [=[Interface\ChatFrame\ChatFrameBackground]=],
		insets = { top = 4, bottom = 4, left = 4, right = 4 },
	},
	HIGHLIGHT = [=[Interface\AddOns\oUF_Layout\assets\textures\highlight]=],
	RAIDICONS = [=[Interface\AddOns\oUF_Layout\assets\textures\raidicons]=],
	SHADER = [=[Interface\AddOns\oUF_Layout\assets\textures\shader]=],
	TEXTURE = [=[Interface\AddOns\oUF_Layout\assets\textures\texture]=],
}
