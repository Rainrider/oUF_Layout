local _, ns = ...

ns.config = {}

ns.colors = setmetatable({
	disconnected = { 0.42, 0.37, 0.32 },
	smooth = setmetatable({
		0.69, 0.31, 0.31,
		0.71, 0.43, 0.27,
		0.17, 0.17, 0.24,
	}, { __index = oUF.colors.smooth }),
	tapped = { 0.42, 0.37, 0.32 },
}, { __index = oUF.colors })

ns.assets = {
	GLOW = {
		edgeFile = [=[Interface\AddOns\oUF_Layout\assets\textures\glow]=],
		edgeSize = 2,
	},
	TEXTURE = [=[Interface\AddOns\oUF_Layout\assets\textures\texture]=],
}
