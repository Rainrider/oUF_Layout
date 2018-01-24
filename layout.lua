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
