local _, ns = ...

ns.config = {}
ns.colors = setmetatable({}, { __index = oUF.colors })
ns.assets = {
	GLOW = {
		edgeFile = [=[Interface\AddOns\oUF_Layout\assets\textures\glow]=],
		edgeSize = 2,
	},
	TEXTURE = [=[Interface\AddOns\oUF_Layout\assets\textures\texture]=],
}
