local _, ns = ...

function ns.AddPowerPrediction(self)
	local powerPrediction = CreateFrame('StatusBar', nil, self.Power)
	powerPrediction:SetStatusBarTexture(ns.assets.TEXTURE)
	powerPrediction:SetStatusBarColor(0, 0, 1, 0.5)
	powerPrediction:SetReverseFill(true)
	powerPrediction:SetSize(230, 15)
	powerPrediction:SetPoint('RIGHT', self.Power:GetStatusBarTexture())

	self.PowerPrediction = powerPrediction
end
