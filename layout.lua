local _, ns = ...
local config = ns.config

oUF:Factory(function(self)
	self:SetActiveStyle('oUF_Layout_SingleUnits')

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

	if (config.showMTA) then
		local mainTanksAndAssists = self:SpawnHeader(
			nil, nil, 'raid',
			'showRaid', true,
			'groupFilter', 'MAINTANK,MAINASSIST',
			'groupBy', 'ROLE',
			'groupingOrder', 'MAINTANK,MAINASSIST',
			'oUF-initialConfigFunction', [[
				self:SetWidth(120)
				self:SetHeight(32)
			]]
		)
		mainTanksAndAssists:SetPoint('TOPLEFT', UIParent, 'LEFT', 150, -215)

		if (config.showMTATargets) then
			local mainTanksAndAssistsTargets = self:SpawnHeader(
				nil, nil, 'raid',
				'showRaid', true,
				'groupFilter', 'MAINTANK,MAINASSIST',
				'groupBy', 'ROLE',
				'groupingOrder', 'MAINTANK,MAINASSIST',
				'oUF-initialConfigFunction', [[
					self:SetWidth(120)
					self:SetHeight(32)
					self:SetAttribute('unitsuffix', 'target')
				]]
			)
			mainTanksAndAssistsTargets:SetPoint('TOPLEFT', mainTanksAndAssists, 'TOPRIGHT')
		end
	end

	self:SetActiveStyle('oUF_Layout_GroupUnits')

	if (config.showParty) then
		local party = self:SpawnHeader(
			nil, nil, 'party',
			'showParty', true,
			'maxColumns', 4,
			'unitsPerColumn', 1,
			'columnAnchorPoint', 'LEFT',
			'oUF-initialConfigFunction', [[
				self:SetWidth(80)
				self:SetHeight(40)
			]]
		)
		party:SetPoint('LEFT', UIParent, 'BOTTOM', -240, 130)

		if (config.showPartyPets) then
			local partyPets = self:SpawnHeader(
				nil, nil, 'party',
				'showParty', true,
				'maxColumns', 4,
				'unitsPerColumn', 1,
				'columnAnchorPoint', 'LEFT',
				'oUF-initialConfigFunction', [[
					self:SetWidth(80)
					self:SetHeight(20)
					self:SetAttribute('unitsuffix', 'pet')
				]]
			)
			partyPets:SetPoint('TOPLEFT', party, 'BOTTOMLEFT')
		end

		if (config.showPartyTargets) then
			local partyTargets = self:SpawnHeader(
				nil, nil, 'party',
				'showParty', true,
				'maxColumns', 4,
				'unitsPerColumn', 1,
				'columnAnchorPoint', 'LEFT',
				'oUF-initialConfigFunction', [[
					self:SetWidth(80)
					self:SetHeight(20)
					self:SetAttribute('unitsuffix', 'target')
				]]
			)
			partyTargets:SetPoint('TOPLEFT', party, 'BOTTOMLEFT', 0, -20)
		end
	end

	if (config.showRaid) then
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
	end
end)
