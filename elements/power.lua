local _, ns = ...

function ns.AddPowerBar(self, unit)
	local power = CreateFrame('StatusBar', nil, self)
	power:SetStatusBarTexture(ns.assets.TEXTURE)
	power:SetHeight((unit == 'player' or unit == 'target') and 15 or 5)
	power:SetPoint('BOTTOMLEFT', 5, 5)
	power:SetPoint('BOTTOMRIGHT', -5, 5)
	power.colorPower = unit == 'player' or unit == 'boss'
	power.colorClass = true
	power.colorReaction = true
	power.frequentUpdates = unit == 'player' or unit == 'target'
	power.displayAltPower = unit == 'boss'
	power.altPowerColor = { 0, 0.5, 1 }

	local bg = power:CreateTexture(nil, 'BACKGROUND')
	bg:SetTexture(ns.assets.TEXTURE)
	bg:SetAllPoints()
	bg.multiplier = 1/3

	power.bg = bg
	self.Power = power
end
