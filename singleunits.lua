local _, ns = ...

local playerClass = ns.playerClass

local UnitSpecific = {
	player = function(self)
		ns.AddClassPower(self, 217, 5, 1)
		ns.AddTotems(self, 217, 5, 1)
		ns.AddPowerPrediction(self)
		ns.AddAlternativePower(self)
		ns.AddArtifactPower(self)
		ns.AddReputation(self)
		ns.AddExperience(self)
		ns.AddAssistantIndicator(self)
		ns.AddCombatIndicator(self)
		ns.AddLeaderIndicator(self)
		ns.AddMasterLooterIndicator(self)
		ns.AddRestingIndicator(self)

		if (playerClass == 'DEATHKNIGHT') then
			ns.AddRunes(self, 217, 5, 1)
		elseif (playerClass == 'MONK') then
			ns.AddStagger(self)
		end
	end,
	target = function(self)
		ns.AddInfoText(self, 'target')
		ns.AddQuestIndicator(self)
		ns.AddPhaseIndicator(self)
		ns.AddRangeCheck(self)
	end,
	pet = function(self)
		ns.AddAuras(self, 'pet')
		ns.AddAlternativePower(self) -- needed when the player is in a vehicle
		ns.AddRangeCheck(self)
	end,
	focus = function(self)
		ns.AddDebuffs(self, 'focus')
		ns.AddRangeCheck(self)
	end,
	boss = function(self)
		ns.AddBuffs(self, 'boss')
		ns.AddCastBar(self, 'boss')
	end,
}

local function Shared(self, unit)
	unit = unit:match('^(%a-)%d+') or unit

	self:RegisterForClicks('AnyUp')
	self:SetScript('OnEnter', UnitFrame_OnEnter)
	self:SetScript('OnLeave', UnitFrame_OnLeave)

	self.colors = ns.colors
	self:SetBackdrop(ns.assets.GLOW)
	self:SetBackdropColor(0, 0, 0, 0)
	self:SetBackdropBorderColor(0, 0, 0)

	ns.AddHealthBar(self, unit)
	ns.AddPowerBar(self, unit)
	ns.AddHealthValue(self, unit)
	ns.AddRaidTargetIndicator(self)

	if (unit == 'player' or unit == 'target') then
		self:SetSize(240, 60)

		ns.AddPowerValue(self, unit)
		ns.AddPortrait(self, unit)
		ns.AddCastBar(self, unit)
		ns.AddThreatIndicator(self)
		ns.AddBuffs(self, unit)
		ns.AddDebuffs(self, unit)
		ns.AddDispel(self, unit)
		ns.AddPvPText(self, unit)
		ns.AddHealthPrediction(self, unit)
		ns.AddResurrectIndicator(self)
	end

	if (unit ~= 'player' and unit ~= 'target') then
		self:SetSize(120, 32)

		ns.AddInfoText(self, unit)

		if (unit == 'pet' or unit == 'focus') then
			ns.AddCastBar(self, unit)
			ns.AddThreatIndicator(self)
			ns.AddDispel(self, unit)
			ns.AddHealthPrediction(self, unit)
			ns.AddResurrectIndicator(self)
		end
	end

	if (UnitSpecific[unit]) then
		return UnitSpecific[unit](self)
	end
end

oUF:RegisterStyle('oUF_Layout_SingleUnits', Shared)
