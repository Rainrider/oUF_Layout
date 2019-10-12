local _, ns = ...

ns.config = {
	filterBuffs = 'player target',
	filterDebuffs = 'target',
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
		MANA   = { 0.31, 0.45, 0.63 },
		RAGE   = { 0.69, 0.31, 0.31 },
		ENERGY = { 1, 0.87, 0.4 },
	}, { __index = oUF.colors.power }),
	reaction = setmetatable({
		{ 204 / 255,  77 / 255,  56 / 255 }, -- HATED
		{ 204 / 255,  77 / 255,  56 / 255 }, -- HOSTILE
		{ 230 / 255, 148 / 255,  28 / 255 }, -- UNFRIENDLY
		{ 255 / 255, 222 / 255,   0 / 255 }, -- NEUTRAL
		{  64 / 255, 170 / 255,   0 / 255 }, -- FRIENDLY
		{  64 / 255, 170 / 255,   0 / 255 }, -- HONORED
		{  64 / 255, 170 / 255,   0 / 255 }, -- REVERED
		{  64 / 255, 170 / 255,   0 / 255 }, -- EXALTED
	}, { __index = oUF.colors.reaction }),
	role = {
		NONE = { 0.5, 0.5, 0.5 },
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
