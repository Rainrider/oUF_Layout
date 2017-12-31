local addonName, ns = ...

local UnitSpecific = {
	player = function(self) end,
	target = function(self) end,
	pet = function(self) end,
	focus = function(self) end,
}

local function Shared(self, unit)
	self.colors = ns.colors
	self:SetBackdrop(ns.assets.GLOW)
	self:SetBackdropBorderColor(0, 0, 0)

	ns.AddHealthBar(self, unit)
	ns.AddPowerBar(self, unit)

	if (unit == 'player' or unit == 'target') then
		self:SetSize(240, 60)

		ns.AddPortrait(self, unit)
		ns.AddCastBar(self, unit)
	end

	if (UnitSpecific[unit]) then
		return UnitSpecific[unit](self)
	end
end

oUF:RegisterStyle(addonName, Shared)
oUF:Factory(function(self)
	self:SetActiveStyle(addonName)

	self:Spawn('player'):SetPoint('CENTER', -210, -215)
	self:Spawn('target'):SetPoint('CENTER', 210, -215)
end)
