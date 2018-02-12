local layoutName, ns = ...

local UnitSpecific = {
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

	self:SetSize(120, 32)

	ns.AddHealthBar(self, unit)
	ns.AddPowerBar(self, unit)
	ns.AddHealthValue(self, unit)
	ns.AddRaidTargetIndicator(self)
	ns.AddInfoText(self, unit)

	if (unit == 'pet' or unit == 'focus') then
		ns.AddCastBar(self, unit)
		ns.AddThreatIndicator(self)
		ns.AddDispel(self, unit)
		ns.AddHealthPrediction(self, unit)
		ns.AddResurrectIndicator(self)
	end

	if (UnitSpecific[unit]) then
		return UnitSpecific[unit](self)
	end
end

oUF:RegisterStyle(layoutName .. '_Secondary', Shared)
