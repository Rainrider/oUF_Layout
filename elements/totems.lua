local _, ns = ...
local playerClass = ns.playerClass

function ns.AddTotems(self, width, height, spacing)
	local totems = {}
	local maxTotems = _G.MAX_TOTEMS
	local priorities = playerClass == 'SHAMAN' and SHAMAN_TOTEM_PRIORITIES or STANDARD_TOTEM_PRIORITIES

	width = (width - (maxTotems + 1) * spacing) / maxTotems
	spacing = width + spacing

	for i = 1, maxTotems do
		local slot = priorities[i]
		local totem = CreateFrame('StatusBar', nil, self.Overlay)
		local color = ns.colors.totems[i]
		local r, g, b = color[1], color[2], color[3]
		totem:SetStatusBarTexture(ns.assets.TEXTURE)
		totem:SetStatusBarColor(r, g, b)
		totem:SetSize(width, height)
		totem:SetPoint(playerClass == 'SHAMAN' and 'BOTTOMLEFT' or 'TOPLEFT', (slot - 1) * spacing + 1, 1)
		totem:EnableMouse(true)

		local bg = totem:CreateTexture(nil, 'BACKGROUND')
		bg:SetTexture(ns.assets.TEXTURE)
		bg:SetVertexColor(r * 0.5, g * 0.5, b * 0.5)
		bg:SetAllPoints()

		local icon = totem:CreateTexture(nil, 'ARTWORK')
		icon:SetSize(width - 5, width - 5)
		icon:SetPoint('BOTTOM', totem, 'TOP', 0, 2.5)
		icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
		icon:Hide()
		totem.icon = icon

		local overlay = totem:CreateTexture(nil, 'OVERLAY')
		overlay:SetTexture(ns.assets.BUTTONOVERLAY)
		overlay:SetPoint('TOPLEFT', icon, -5, 5)
		overlay:SetPoint('BOTTOMRIGHT', icon, 5, -5)
		overlay:SetVertexColor(r, g, b)
		overlay:Hide()
		totem.overlay = overlay

		totems[slot] = totem
	end

	self.CustomTotems = totems
end
