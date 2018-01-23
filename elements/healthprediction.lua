local _, ns = ...

function ns.AddHealthPrediction(self, unit)
	local health = self.Health
	local width = (unit == 'player' or unit == 'target') and 230 or unit == 'raid' and 70 or 110

	local healAbsorbBar = CreateFrame('StatusBar', nil, health)
	healAbsorbBar:SetPoint('TOP')
	healAbsorbBar:SetPoint('BOTTOM')
	healAbsorbBar:SetPoint('RIGHT', health:GetStatusBarTexture())
	healAbsorbBar:SetWidth(width)
	healAbsorbBar:SetReverseFill(true)
	healAbsorbBar:SetStatusBarTexture(ns.assets.TEXTURE)
	healAbsorbBar:SetStatusBarColor(0.75, 0.75, 0, 0.5)

	local overHealAbsorb = health:CreateTexture(nil, 'OVERLAY')
	overHealAbsorb:SetWidth(5)
	overHealAbsorb:SetPoint('TOP')
	overHealAbsorb:SetPoint('BOTTOM')
	overHealAbsorb:SetPoint('RIGHT', health, 'LEFT')

	local myBar = CreateFrame('StatusBar', nil, health)
	myBar:SetPoint('TOP')
	myBar:SetPoint('BOTTOM')
	myBar:SetPoint('LEFT', health:GetStatusBarTexture(), 'RIGHT')
	myBar:SetWidth(width)
	myBar:SetStatusBarTexture(ns.assets.TEXTURE)
	myBar:SetStatusBarColor(0, 0.5, 0.5, 0.5)

	local otherBar = CreateFrame('StatusBar', nil, health)
	otherBar:SetPoint('TOP')
	otherBar:SetPoint('BOTTOM')
	otherBar:SetPoint('LEFT', myBar:GetStatusBarTexture(), 'RIGHT')
	otherBar:SetWidth(width)
	otherBar:SetStatusBarTexture(ns.assets.TEXTURE)
	otherBar:SetStatusBarColor(0, 1, 0, 0.5)

	local absorbBar = CreateFrame('StatusBar', nil, health)
	absorbBar:SetPoint('TOP')
	absorbBar:SetPoint('BOTTOM')
	absorbBar:SetPoint('LEFT', otherBar:GetStatusBarTexture(), 'RIGHT')
	absorbBar:SetWidth(width)
	absorbBar:SetStatusBarTexture(ns.assets.TEXTURE)
	absorbBar:SetStatusBarColor(1, 1, 1, 0.5)

	local overAbsorb = health:CreateTexture(nil, 'OVERLAY')
	overAbsorb:SetWidth(5)
	overAbsorb:SetPoint('TOP')
	overAbsorb:SetPoint('BOTTOM')
	overAbsorb:SetPoint('LEFT', health, 'RIGHT')

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