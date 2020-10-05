local _, ns = ...

local ALTERNATE_POWER_INDEX = Enum.PowerType.Alternate or 10

local function GetDisplayPower(element)
	local unit = element.__owner.unit
	local barInfo = GetUnitPowerBarInfo(unit)

	if barInfo then
		return ALTERNATE_POWER_INDEX, barInfo.minPower
	end
end

function ns.AddPowerBar(self, unit)
	local power = CreateFrame('StatusBar', nil, self)
	power:SetStatusBarTexture(ns.assets.TEXTURE)
	power:SetHeight((unit == 'player' or unit == 'target') and 15 or 5)
	power:SetPoint('BOTTOMLEFT', 5, 5)
	power:SetPoint('BOTTOMRIGHT', -5, 5)
	power.colorPower = unit == 'player' or unit == 'boss'
	power.colorClass = true
	power.colorSelection = unit == 'target'
	power.colorReaction = true
	power.frequentUpdates = unit == 'player' or unit == 'target'
	power.displayAltPower = unit == 'boss'

	local bg = power:CreateTexture(nil, 'BACKGROUND')
	bg:SetTexture(ns.assets.TEXTURE)
	bg:SetAllPoints()
	bg.multiplier = 1/3
	power.bg = bg

	power.GetDisplayPower = GetDisplayPower
	self.Power = power
end
