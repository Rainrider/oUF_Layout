local _, ns = ...

ns.config = {
	filterBuffs = 'player target',
	filterDebuffs = 'target focus party',
	sortBuffs = '',
	sortDebuffs = 'target',
	showParty = true,
	showPartyPets = true,
	showPartyTargets = true,
	showRaid = true,
	showMTA = true,
	showMTATargets = true,
	clickSpell = {
		SHAMAN = 77130, -- Purify Spirit
	},
}

ns.colors = setmetatable({
	disconnected = oUF:CreateColor(0.42, 0.37, 0.32),
	health = oUF:CreateColor(0.17, 0.17, 0.24),
	power = setmetatable({
		MANA = oUF:CreateColor(0.31, 0.45, 0.63),
		RAGE = oUF:CreateColor(0.69, 0.31, 0.31),
		ENERGY = oUF:CreateColor(1, 0.87, 0.4),
	}, { __index = oUF.colors.power }),
	reaction = setmetatable({
		oUF:CreateColor(204 / 255, 77 / 255, 56 / 255), -- HATED
		oUF:CreateColor(204 / 255, 77 / 255, 56 / 255), -- HOSTILE
		oUF:CreateColor(230 / 255, 148 / 255, 28 / 255), -- UNFRIENDLY
		oUF:CreateColor(255 / 255, 222 / 255, 0 / 255), -- NEUTRAL
		oUF:CreateColor(64 / 255, 170 / 255, 0 / 255), -- FRIENDLY
		oUF:CreateColor(64 / 255, 170 / 255, 0 / 255), -- HONORED
		oUF:CreateColor(64 / 255, 170 / 255, 0 / 255), -- REVERED
		oUF:CreateColor(64 / 255, 170 / 255, 0 / 255), -- EXALTED
	}, { __index = oUF.colors.reaction }),
	role = {
		NONE = oUF:CreateColor(0.5, 0.5, 0.5),
		TANK = oUF:CreateColor(0.78, 0.61, 0.43),
		HEALER = oUF:CreateColor(0.25, 0.78, 0.92),
		DAMAGER = oUF:CreateColor(0.77, 0.12, 0.23),
	},
	selection = setmetatable({
		[0] = oUF:CreateColor(204 / 255, 77 / 255, 56 / 255), -- HOSTILE
		[1] = oUF:CreateColor(230 / 255, 148 / 255, 28 / 255), -- UNFRIENDLY
		[2] = oUF:CreateColor(255 / 255, 222 / 255, 0 / 255), -- NEUTRAL
		[3] = oUF:CreateColor(64 / 255, 204 / 255, 0 / 255), -- FRIENDLY
		[4] = oUF:CreateColor(0 / 255, 0 / 255, 255 / 255), -- PLAYER_SIMPLE
		[5] = oUF:CreateColor(96 / 255, 96 / 255, 255 / 255), -- PLAYER_EXTENDED
		[6] = oUF:CreateColor(170 / 255, 170 / 255, 255 / 255), -- PARTY
		[7] = oUF:CreateColor(170 / 255, 255 / 255, 170 / 255), -- PARTY_PVP
		[8] = oUF:CreateColor(83 / 255, 201 / 255, 255 / 255), -- FRIEND
		[9] = oUF:CreateColor(128 / 255, 128 / 255, 128 / 255), -- DEAD
		-- [10] = {}, -- COMMENTATOR_TEAM_1, unavailable to players
		-- [11] = {}, -- COMMENTATOR_TEAM_2, unavailable to players
		-- [12] = oUF:CreateColor(255 / 255, 255 / 255, 139 / 255), -- SELF, buggy
		[13] = oUF:CreateColor(0 / 255, 153 / 255, 0 / 255), -- BATTLEGROUND_FRIENDLY_PVP
	}, { __index = oUF.colors.selection }),
	smooth = setmetatable({ 0.69, 0.31, 0.31, 0.71, 0.43, 0.27, 0.17, 0.17, 0.24 }, { __index = oUF.colors.smooth }),
	tapped = oUF:CreateColor(0.42, 0.37, 0.32),
	totems = {
		oUF:CreateColor(0.71, 0.29, 0.13), -- red    181 /  73 /  33
		oUF:CreateColor(0.26, 0.71, 0.13), -- green   67 / 181 /  33
		oUF:CreateColor(0.13, 0.55, 0.71), -- blue    33 / 141 / 181
		oUF:CreateColor(0.58, 0.13, 0.71), -- violet 147 /  33 / 181
		oUF:CreateColor(0.71, 0.58, 0.13), -- yellow 181 / 147 /  33
	},
}, { __index = oUF.colors })

ns.colors.power[0] = ns.colors.power.MANA
ns.colors.power[1] = ns.colors.power.RAGE
ns.colors.power[3] = ns.colors.power.ENERGY

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
