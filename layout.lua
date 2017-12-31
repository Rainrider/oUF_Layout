local addonName, ns = ...

local UnitSpecific = {
	player = function(self) end,
	target = function(self) end,
	pet = function(self) end,
	focus = function(self) end,
}

local function Shared(self, unit)
	if (UnitSpecific[unit]) then
		return UnitSpecific[unit](self)
	end
end

oUF:RegisterStyle(addonName, Shared)
oUF:Factory(function(self)
	self:SetActiveStyle(addonName)
end)