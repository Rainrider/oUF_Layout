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
	ns.AddCastBar(self, unit)
	ns.AddBuffs(self, unit)
	ns.AddDebuffs(self, unit)
	ns.AddDispel(self, unit)
	ns.AddHealthPrediction(self, unit)

	ns.AddPvPText(self, unit)
	ns.AddRaidTargetIndicator(self)
	ns.AddResurrectIndicator(self)
	ns.AddSummonIndicator(self)
	ns.AddThreatIndicator(self)

	if (unit == 'player') then
		ns.player = self

		ns.AddAlternativePower(self, unit)
		ns.AddClassPower(self, 217, 5, 1)
		ns.AddPowerPrediction(self)
		ns.AddPlayerBuffTimers(self)
		ns.AddTotems(self, 217, 5, 1)

		ns.AddArtifactPower(self)
		ns.AddReputation(self)
		ns.AddExperience(self)

		ns.AddAssistantIndicator(self)
		ns.AddCombatIndicator(self)
		ns.AddLeaderIndicator(self)
		ns.AddRestingIndicator(self)

		if (playerClass == 'DEATHKNIGHT') then
			ns.AddRunes(self, 217, 5, 1)
		elseif (playerClass == 'MONK') then
			ns.AddStagger(self)
		end
	end

	if (unit == 'target') then
		ns.AddInfoText(self, 'target')
		ns.AddPhaseIndicator(self)
		ns.AddQuestIndicator(self)
		ns.AddRangeCheck(self)
	end
end

oUF:RegisterStyle(layoutName .. '_Primary', Shared)
