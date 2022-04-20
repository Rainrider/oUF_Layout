local layoutName, ns = ...
local config = ns.config

oUF:Factory(function(self)
	self:SetActiveStyle(layoutName .. '_Primary')

	local player = self:Spawn('player')
	player:SetPoint('CENTER', -210, -215)
	local target = self:Spawn('target')
	target:SetPoint('CENTER', 210, -215)

	self:SetActiveStyle(layoutName .. '_Secondary')

	self:Spawn('pet'):SetPoint('BOTTOMLEFT', player, 'TOPLEFT', 0, 0)
	self:Spawn('focus'):SetPoint('BOTTOMRIGHT', player, 'TOPRIGHT', 0, 0)
	self:Spawn('focustarget'):SetPoint('BOTTOMLEFT', target, 'TOPLEFT', 0, 0)
	self:Spawn('targettarget'):SetPoint('BOTTOMRIGHT', target, 'TOPRIGHT', 0, 0)

	local boss = {}
	for i = 1, _G.MAX_BOSS_FRAMES do
		boss[i] = self:Spawn('boss' .. i)

		if i == 1 then
			boss[i]:SetPoint('TOP', UIParent, 'TOP', 0, -25)
		else
			boss[i]:SetPoint('TOP', boss[i - 1], 'BOTTOM', 0, 0)
		end
	end

	if config.showMTA then
		-- stylua: ignore start
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
		-- stylua: ignore end
		mainTanksAndAssists:SetPoint('BOTTOMLEFT', UIParent, 'LEFT', 150, -245)

		if config.showMTATargets then
			-- stylua: ignore start
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
			-- stylua: ignore end
			mainTanksAndAssistsTargets:SetPoint('TOPLEFT', mainTanksAndAssists, 'TOPRIGHT')
		end
	end

	self:SetActiveStyle(layoutName .. '_Group')

	if config.showParty then
		-- stylua: ignore start
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
		-- stylua: ignore end
		party:SetPoint('LEFT', UIParent, 'BOTTOM', -160, 130)

		if config.showPartyPets then
			-- stylua: ignore start
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
			-- stylua: ignore end
			partyPets:SetPoint('TOPLEFT', party, 'BOTTOMLEFT')
		end

		if config.showPartyTargets then
			-- stylua: ignore start
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
			-- stylua: ignore end
			partyTargets:SetPoint('TOPLEFT', party, 'BOTTOMLEFT', 0, -20)
		end
	end

	if config.showRaid then
		local raid = {}
		for group = 1, _G.NUM_RAID_GROUPS do
			-- stylua: ignore start
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
			-- stylua: ignore end

			if group == 1 then
				raid[group]:SetPoint('TOPLEFT', UIParent, 15, -15)
			else
				raid[group]:SetPoint('TOPLEFT', raid[group - 1], 'BOTTOMLEFT')
			end
		end
	end
end)
