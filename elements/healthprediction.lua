local _, ns = ...

local width = {
	pet    = 110,
	player = 230,
	raid   = 70,
}
width.party  = width.raid
width.target = width.player

function ns.AddHealthPrediction(self, unit)
	local health = self.Health
	local width = width[unit] or width['pet']

	local healAbsorbBar = CreateFrame('StatusBar', nil, health)
	healAbsorbBar:SetPoint('TOPRIGHT', health:GetStatusBarTexture())
	healAbsorbBar:SetPoint('BOTTOMRIGHT', health:GetStatusBarTexture())
	healAbsorbBar:SetWidth(width)
	healAbsorbBar:SetReverseFill(true)
	healAbsorbBar:SetStatusBarTexture(ns.assets.TEXTURE)
	healAbsorbBar:SetStatusBarColor(0.75, 0.75, 0, 0.5)

	local overHealAbsorb = health:CreateTexture(nil, 'OVERLAY')
	overHealAbsorb:SetWidth(5)
	overHealAbsorb:SetPoint('TOPRIGHT', health, 'TOPLEFT')
	overHealAbsorb:SetPoint('BOTTOMRIGHT', health, 'BOTTOMLEFT')

	local myBar = CreateFrame('StatusBar', nil, health)
	myBar:SetPoint('TOPLEFT', health:GetStatusBarTexture(), 'TOPRIGHT')
	myBar:SetPoint('BOTTOMLEFT', health:GetStatusBarTexture(), 'BOTTOMRIGHT')
	myBar:SetWidth(width)
	myBar:SetStatusBarTexture(ns.assets.TEXTURE)
	myBar:SetStatusBarColor(0, 0.5, 0.5, 0.5)

	local otherBar = CreateFrame('StatusBar', nil, health)
	otherBar:SetPoint('TOPLEFT', myBar:GetStatusBarTexture(), 'TOPRIGHT')
	otherBar:SetPoint('BOTTOMLEFT', myBar:GetStatusBarTexture(), 'BOTTOMRIGHT')
	otherBar:SetWidth(width)
	otherBar:SetStatusBarTexture(ns.assets.TEXTURE)
	otherBar:SetStatusBarColor(0, 1, 0, 0.5)

	local absorbBar = CreateFrame('StatusBar', nil, health)
	absorbBar:SetPoint('TOPLEFT', otherBar:GetStatusBarTexture(), 'TOPRIGHT')
	absorbBar:SetPoint('BOTTOMLEFT', otherBar:GetStatusBarTexture(), 'BOTTOMRIGHT')
	absorbBar:SetWidth(width)
	absorbBar:SetStatusBarTexture(ns.assets.TEXTURE)
	absorbBar:SetStatusBarColor(1, 1, 1, 0.5)

	local overAbsorb = health:CreateTexture(nil, 'OVERLAY')
	overAbsorb:SetWidth(5)
	overAbsorb:SetPoint('TOPLEFT', health, 'TOPRIGHT')
	overAbsorb:SetPoint('BOTTOMLEFT', health, 'BOTTOMRIGHT')

	self.HealthPrediction = {
		healAbsorbBar = healAbsorbBar,
		myBar = myBar,
		otherBar = otherBar,
		absorbBar = absorbBar,
		overAbsorb = overAbsorb,
		overHealAbsorb = overHealAbsorb,
		frequentUpdates = health.frequentUpdates,
	}
end