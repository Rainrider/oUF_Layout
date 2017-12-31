local _, ns = ...

ns.config = {}

ns.colors = setmetatable({
	disconnected = { 0.42, 0.37, 0.32 },
	health = { 0.17, 0.17, 0.24 },
	power = setmetatable({
		["MANA"] = { 0.31, 0.45, 0.63 },
		["RAGE"] = { 0.69, 0.31, 0.31 },
		["ENERGY"] = { 1, 0.87, 0.4 },
	}, { __index = oUF.colors.power }),
	smooth = setmetatable({
		0.69, 0.31, 0.31,
		0.71, 0.43, 0.27,
		0.17, 0.17, 0.24,
	}, { __index = oUF.colors.smooth }),
	tapped = { 0.42, 0.37, 0.32 },
}, { __index = oUF.colors })

ns.assets = {
	BUTTONOVERLAY = [=[Interface\AddOns\oUF_Layout\assets\textures\buttonoverlay]=],
	GLOW = {
		edgeFile = [=[Interface\AddOns\oUF_Layout\assets\textures\glow]=],
		edgeSize = 2,
	},
	SHADER = [=[Interface\AddOns\oUF_Layout\assets\textures\shader]=],
	TEXTURE = [=[Interface\AddOns\oUF_Layout\assets\textures\texture]=],
}
