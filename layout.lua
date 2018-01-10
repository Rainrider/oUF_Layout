local addonName, ns = ...

local playerClass = ns.playerClass

local UnitSpecific = {
	player = function(self)
		ns.AddClassPower(self, 217, 5, 1)
		ns.AddTotems(self, 217, 5, 1)
		ns.AddPowerPrediction(self)
		ns.AddAlternativePower(self)
		if (playerClass == 'DEATHKNIGHT') then
			ns.AddRunes(self, 217, 5, 1)
		elseif (playerClass == 'MONK') then
			ns.AddStagger(self)
		end
	end,
	target = function(self)
		ns.AddInfoText(self, 'target')
	end,
	pet = function(self)
		ns.AddAuras(self, 'pet')
		ns.AddAlternativePower(self) -- needed when the player is in a vehicle
	end,
	focus = function(self)
		ns.AddDebuffs(self, 'focus')
	end,
}

local function Shared(self, unit)
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
	end

	if (unit ~= 'player' and unit ~= 'target') then
		self:SetSize(120, 32)
		ns.AddInfoText(self, unit)

		if (unit == 'pet' or unit == 'focus') then
			ns.AddCastBar(self, unit)
			ns.AddThreatIndicator(self)
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
end)
