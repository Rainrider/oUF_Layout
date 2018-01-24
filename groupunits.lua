local _, ns = ...

local function Shared(self, unit)
	unit = unit:match('^(%a-)%d+') or unit

	self:RegisterForClicks('AnyUp')
	self:SetScript('OnEnter', UnitFrame_OnEnter)
	self:SetScript('OnLeave', UnitFrame_OnLeave)

	self.colors = ns.colors
	self:SetBackdrop(ns.assets.GLOW)
	self:SetBackdropBorderColor(0, 0, 0)

	ns.AddHealthBar(self, unit)
	ns.AddInfoText(self, unit)

	if (unit ~= 'partypet') then
		ns.AddPowerBar(self, unit)
		ns.AddHealthPrediction(self, unit)
		ns.AddAssistantIndicator(self)
		ns.AddLeaderIndicator(self)
		ns.AddMasterLooterIndicator(self)
		ns.AddPhaseIndicator(self)
	end

	ns.AddDispel(self, unit)
	ns.AddThreatIndicator(self, unit)
end

oUF:RegisterStyle('oUF_Layout_GroupUnits', Shared)
