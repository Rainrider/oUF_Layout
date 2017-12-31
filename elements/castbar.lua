local _, ns = ...

function ns.AddCastBar(self, unit)
	local castbar = CreateFrame('StatusBar', nil, self.Portrait)
	castbar:SetStatusBarTexture(ns.assets.TEXTURE)
	castbar:SetStatusBarColor(0.55, 0.57, 0.61)
	castbar:SetAlpha(0.75)
	castbar:SetAllPoints(self.Overlay)

	if(unit == 'player') then
		local safeZone = castbar:CreateTexture(nil, 'OVERLAY')
		safeZone:SetTexture(ns.assets.TEXTURE)
		safeZone:SetVertexColor(0.69, 0.31, 0.31)
		castbar.SafeZone = safeZone
	end

	self.Castbar = castbar
end
