local _, ns = ...

function ns.AddExperience(self)
	if (not IsAddOnLoaded('oUF_Experience')) then return end

	local experience = CreateFrame('StatusBar', nil, self)
	experience:SetPoint('TOPLEFT', self.Power, 'BOTTOMLEFT', 0, -2.5)
	experience:SetPoint('TOPRIGHT', self.Power, 'BOTTOMRIGHT', 0, -2.5)
	experience:SetHeight(5)
	experience:SetStatusBarTexture(ns.assets.TEXTURE)

	experience.restedAlpha = 0.5
	experience.outAlpha = 0
	experience:EnableMouse(true)

	local rested = CreateFrame('StatusBar', nil, experience)
	rested:SetAllPoints()
	rested:SetStatusBarTexture(ns.assets.TEXTURE)
	experience.Rested = rested

	local bg = rested:CreateTexture(nil, 'BACKGROUND')
	bg:SetTexture(ns.assets.TEXTURE)
	bg:SetVertexColor(0, 0, 0)
	bg:SetAllPoints()

	self.Experience = experience
end
