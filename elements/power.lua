local _, ns = ...

function ns.AddPowerBar(self, unit)
	local power = CreateFrame('StatusBar', nil, self)
	power:SetStatusBarTexture(ns.assets.TEXTURE)
	power:SetHeight(15)
	power:SetPoint('BOTTOMLEFT', 5, 5)
	power:SetPoint('BOTTOMRIGHT', -5, 5)
	power.colorPower = unit == 'player'
	power.colorClass = true
	power.colorReaction = true
	power.frequentUpdates = unit == 'player' or unit == 'target'

	local bg = power:CreateTexture(nil, 'BACKGROUND')
	bg:SetTexture(ns.assets.TEXTURE)
	bg:SetAllPoints()
	bg.multiplier = 1/3

	power.bg = bg
	self.Power = power
end
