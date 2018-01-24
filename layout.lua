local addonName, ns = ...

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
	end,
	pet = function(self)
		ns.AddAuras(self, 'pet')
		ns.AddAlternativePower(self) -- needed when the player is in a vehicle
	end,
	focus = function(self)
		ns.AddDebuffs(self, 'focus')
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
	self:SetBackdropBorderColor(0, 0, 0)

	ns.AddHealthBar(self, unit)
	ns.AddPowerBar(self, unit)
	ns.AddHealthValue(self, unit)

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
	end

	if (unit ~= 'player' and unit ~= 'target') then
		self:SetSize(120, 32)

		ns.AddInfoText(self, unit)

		if (unit == 'pet' or unit == 'focus') then
			ns.AddCastBar(self, unit)
			ns.AddThreatIndicator(self)
			ns.AddDispel(self, unit)
			ns.AddHealthPrediction(self, unit)
		end
	end

	if (UnitSpecific[unit]) then
		return UnitSpecific[unit](self)
	end
end

oUF:RegisterStyle(addonName, Shared)
oUF:Factory(function(self)
	self:SetActiveStyle(addonName)

	local player = self:Spawn('player')
	player:SetPoint('CENTER', -210, -215)
	local target = self:Spawn('target')
	target:SetPoint('CENTER', 210, -215)
	self:Spawn('pet'):SetPoint('BOTTOMLEFT', player, 'TOPLEFT', 0, 0)
	self:Spawn('focus'):SetPoint('BOTTOMRIGHT', player, 'TOPRIGHT', 0, 0)
	self:Spawn('focustarget'):SetPoint('BOTTOMLEFT', target, 'TOPLEFT', 0, 0)
	self:Spawn('targettarget'):SetPoint('BOTTOMRIGHT', target, 'TOPRIGHT', 0, 0)

	local boss = {}
	for i = 1, MAX_BOSS_FRAMES do
		boss[i] = self:Spawn('boss' .. i)

		if (i == 1) then
			boss[i]:SetPoint('TOP', UIParent, 'TOP', 0, -25)
		else
			boss[i]:SetPoint('TOP', boss[i - 1], 'BOTTOM', 0, 0)
		end
	end

	self:SetActiveStyle('oUF_Layout_GroupUnits')

	local party = self:SpawnHeader(
		nil, nil, 'party',
		'showParty', true,
		'maxColumns', 4,
		'unitsPerColumn', 1,
		'columnAnchorPoint', 'LEFT',
		'columnSpacing', 0,
		'oUF-initialConfigFunction', [[
			self:SetWidth(120)
			self:SetHeight(32)
		]]
	)
	party:SetPoint('LEFT', UIParent, 'BOTTOM', -240, 130)

	local partyPets = self:SpawnHeader(
		nil, nil, 'party',
		'showParty', true,
		'maxColumns', 4,
		'unitsPerColumn', 1,
		'columnAnchorPoint', 'LEFT',
		'columnSpacing', 0,
		'oUF-initialConfigFunction', [[
			self:SetWidth(120)
			self:SetHeight(20)
			self:SetAttribute('unitsuffix', 'pet')
		]]
	)
	partyPets:SetPoint('TOPLEFT', party, 'BOTTOMLEFT')

	local raid = {}
	for group = 1, NUM_RAID_GROUPS do
		raid[group] = self:SpawnHeader(
			nil, nil, 'raid',
			'showRaid', true,
			'maxColumns', 5,
			'unitsPerColumn', 1,
			'columnAnchorPoint', 'LEFT',
			'groupFilter', group,
			'oUF-initialConfigFunction', [[
				self:SetWidth(80)
				self:SetHeight(40)
			]]
		)

		if (group == 1) then
			raid[group]:SetPoint('TOPLEFT', UIParent, 15, -15)
		else
			raid[group]:SetPoint('TOPLEFT', raid[group - 1], 'BOTTOMLEFT')
		end
	end
end)
