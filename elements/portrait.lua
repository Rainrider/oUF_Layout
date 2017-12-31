local _, ns = ...

function ns.AddPortrait(self, unit)
	local portrait = CreateFrame('PlayerModel', nil, self.Health)
	portrait:SetPoint('TOPLEFT', self.Health, 7.5, -20)
	portrait:SetPoint('BOTTOMRIGHT', self.Power, -7.5, 7.5)

	local bg = portrait:CreateTexture(nil, 'BACKGROUND')
	bg:SetTexture(ns.assets.TEXTURE)
	bg:SetVertexColor(0, 0, 0)
	bg:SetAllPoints()

	self.Portrait = portrait
end
