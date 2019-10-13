local layoutName, ns = ...

local playerClass = ns.playerClass

local function Shared(self, unit)
	self:RegisterForClicks('AnyUp')
	self:SetScript('OnEnter', UnitFrame_OnEnter)
	self:SetScript('OnLeave', UnitFrame_OnLeave)

	self.colors = ns.colors
	self:SetBackdrop(ns.assets.GLOW)
	self:SetBackdropColor(0, 0, 0, 0)
	self:SetBackdropBorderColor(0, 0, 0)

	self:SetSize(240, 60)

	ns.AddHealthBar(self, unit)
	ns.AddPowerBar(self, unit)
	ns.AddHealthValue(self, unit)
	ns.AddPowerValue(self, unit)
	ns.AddPortrait(self, unit)
	ns.AddBuffs(self, unit)
	ns.AddDebuffs(self, unit)
	ns.AddDispel(self, unit)

	ns.AddPvPText(self, unit)
	ns.AddRaidTargetIndicator(self)

	if (unit == 'player') then
		ns.player = self

		ns.AddCastBar(self, unit)
		-- ns.AddPowerPrediction(self)
		-- ns.AddTotems(self, 217, 5, 1)

		ns.AddReputation(self)
		ns.AddExperience(self)

		ns.AddAssistantIndicator(self)
		ns.AddCombatIndicator(self)
		ns.AddLeaderIndicator(self)
		ns.AddRestingIndicator(self)
	end

	if (unit == 'target') then
		ns.AddComboPoints(self, 217, 5, 1)
		ns.AddInfoText(self, 'target')
		ns.AddRangeCheck(self)
	end
end

oUF:RegisterStyle(layoutName .. '_Primary', Shared)
