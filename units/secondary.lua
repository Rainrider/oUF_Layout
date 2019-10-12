local layoutName, ns = ...

local UnitSpecific = {
	pet = function(self)
		ns.AddAuras(self, 'pet')
		ns.AddRangeCheck(self)
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

	if (unit == 'pet') then
		-- ns.AddCastBar(self, unit)
		ns.AddDispel(self, unit)
	end

	if (UnitSpecific[unit]) then
		return UnitSpecific[unit](self)
	end
end

oUF:RegisterStyle(layoutName .. '_Secondary', Shared)
