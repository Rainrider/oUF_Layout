local _, ns = ...

local ALTERNATE_POWER_INDEX = Enum.PowerType.Alternate or 10

local function GetDisplayPower(element)
	local unit = element.__owner.unit
	local barInfo = GetUnitPowerBarInfo(unit)

	if barInfo then
		return ALTERNATE_POWER_INDEX, barInfo.minPower
	end
end

local function PostUpdateColor(element, unit, color, r, g, b)
	local bg = element.bg
	local mu = bg.multiplier

	if (not r and (issecretvalue(color) or not color)) then
		color = _G.CreateColor(1, 1, 1)
	end

	if (not r) then
		r, g, b = color:GetRGB()
	end

	bg:SetVertexColor(r * mu, g * mu, b * mu)
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
	bg.multiplier = 1 / 3
	power.bg = bg

	if (unit == 'player') then
		local costPrediction = CreateFrame('StatusBar', nil, power)
		costPrediction:SetStatusBarTexture(ns.assets.TEXTURE)
		costPrediction:SetStatusBarColor(0, 0, 1, 0.5)
		costPrediction:SetReverseFill(true)
		costPrediction:SetSize(230, 15)
		costPrediction:SetPoint('RIGHT', power:GetStatusBarTexture())
		power.CostPrediction = costPrediction
	end

	power.GetDisplayPower = GetDisplayPower
	power.PostUpdateColor = PostUpdateColor
	self.Power = power
end
