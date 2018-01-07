local _, ns = ...

function ns.AddPowerPrediction(self)
	local mainBar = CreateFrame('StatusBar', nil, self.Power)
	mainBar:SetStatusBarTexture(ns.assets.TEXTURE)
	mainBar:SetStatusBarColor(0, 0, 1, 0.5)
	mainBar:SetReverseFill(true)
	mainBar:SetSize(230, 15)
	mainBar:SetPoint('RIGHT', self.Power:GetStatusBarTexture())

	self.PowerPrediction = {
		mainBar = mainBar,
	}
end
