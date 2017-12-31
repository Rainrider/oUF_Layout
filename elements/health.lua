local _, ns = ...

function ns.AddHealthBar(self, unit)
	local health = CreateFrame('StatusBar', nil, self)
	health:SetStatusBarTexture(ns.assets.TEXTURE)
	health:SetHeight(30)
	health:SetPoint('TOPLEFT', 5, -5)
	health:SetPoint('TOPRIGHT', -5, -5)
	health.colorTapping = true
	health.colorDisconnected = true
	health.colorSmooth = true
	health.frequentUpdates = true

	local bg = health:CreateTexture(nil, 'BACKGROUND')
	bg:SetTexture(ns.assets.TEXTURE)
	bg:SetVertexColor(0.15, 0.15, 0.15)
	bg:SetAllPoints()

	self.Health = health
end
