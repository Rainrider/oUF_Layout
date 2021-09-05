local layoutName, ns = ...

local function HighlightSelectedUnit(self)
	if (UnitIsUnit(self.unit, 'target')) then
		self:SetBackdropColor(1, 1, 0, 0.5)
	else
		self:SetBackdropColor(0, 0, 0, 0)
	end
end

local function Shared(self, unit)
	unit = unit:match('^(%a-)%d+') or unit

	self:RegisterForClicks('AnyUp')
	self:SetScript('OnEnter', _G.UnitFrame_OnEnter)
	self:SetScript('OnLeave', _G.UnitFrame_OnLeave)

	Mixin(self, BackdropTemplateMixin)
	self.colors = ns.colors
	self:SetBackdrop(ns.assets.GLOW)
	self:SetBackdropColor(0, 0, 0, 0)
	self:SetBackdropBorderColor(0, 0, 0)

	ns.AddHealthBar(self, unit)
	ns.AddInfoText(self, unit)
	ns.AddRaidTargetIndicator(self)

	if (unit ~= 'partypet' and unit ~= 'partytarget') then
		ns.AddPowerBar(self, unit)
		ns.AddHealthPrediction(self, unit)
		ns.AddAssistantIndicator(self)
		ns.AddLeaderIndicator(self)
		ns.AddPhaseIndicator(self)
		ns.AddRangeCheck(self)
		ns.AddReadyCheckIndicator(self)
		ns.AddResurrectIndicator(self)
		ns.AddSummonIndicator(self)
	end

	if (unit == 'party') then
		ns.AddAlternativePower(self, unit)
		ns.AddDebuffs(self, unit)
	end

	if (unit ~= 'partytarget') then
		ns.AddDispel(self, unit)
		ns.AddThreatIndicator(self, unit)

		self:RegisterEvent('PLAYER_TARGET_CHANGED', HighlightSelectedUnit, true)
	end
end

oUF:RegisterStyle(layoutName .. '_Group', Shared)
