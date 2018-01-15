local _, ns = ...

function ns.AddReputation(self)
	if (not IsAddOnLoaded('oUF_Reputation')) then return end

	local reputation = CreateFrame('StatusBar', nil, self)
	reputation:SetPoint('BOTTOMRIGHT', self.Health, 'TOPRIGHT', 0, 2.5)
	reputation:SetPoint('BOTTOMLEFT', self.Health, 'TOP', 2.5, 2.5)
	reputation:SetHeight(5)
	reputation:SetStatusBarTexture(ns.assets.TEXTURE)

	reputation.colorStanding = true
	reputation.outAlpha = 0
	reputation.tooltipAnchor = 'ANCHOR_TOPLEFT'
	reputation:EnableMouse(true)

	local bg = reputation:CreateTexture(nil, 'BACKGROUND')
	bg:SetTexture(ns.assets.TEXTURE)
	bg:SetVertexColor(0, 0, 0)
	bg:SetAllPoints()

	self.Reputation = reputation
end
