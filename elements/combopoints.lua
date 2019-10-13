local _, ns = ...

function ns.AddComboPoints(self, width, height, spacing)
	local comboPoints = {}

	local maxComboPoints = _G.MAX_COMBO_POINTS
	width = (width - (maxComboPoints + 1) * spacing) / maxComboPoints
	spacing = width + spacing

	local color = self.colors.power['COMBO_POINTS']
	local r, g, b = color[1], color[2], color[3]

	for i = 1, maxComboPoints do
		local cpoint = self.Overlay:CreateTexture(nil, 'OVERLAY')
		cpoint:SetTexture(ns.assets.TEXTURE)
		cpoint:SetVertexColor(r, g, b)

		cpoint:SetSize(width, height)
		cpoint:SetPoint('BOTTOMLEFT', ((i - 1) % maxComboPoints) * spacing + 1, 1)

		comboPoints[i] = cpoint
	end

	self.ComboPoints = comboPoints
end