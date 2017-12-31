local _, ns = ...

local tags = oUF.Tags.Methods
local tagEvents = oUF.Tags.Events
local tagSharedEvents = oUF.Tags.SharedEvents
local ColorGradient = oUF.ColorGradient

local GHOST = GetLocale() == 'deDE' and 'Geist' or GetSpellInfo(8326)

local function ShortenValue(value)
	if(value >= 1e9) then
		return format('%.2fb', value / 1e9)
	elseif(value >= 1e6) then
		return format('%.2fm', value / 1e6)
	elseif(value >= 1e4) then
		return format('%.2fk', value / 1e3)
	else
		return value
	end
end

local function GetUnitStatus(unit)
	if(not UnitIsConnected(unit)) then
		return PLAYER_OFFLINE
	end
	if(UnitIsUnconscious(unit)) then
		return UNCONSCIOUS
	end
	if(UnitIsGhost(unit)) then
		return GHOST
	end
	if(UnitIsDead(unit)) then
		return DEAD
	end
end

local function SmallUnitHealthTag(unit)
	local status = GetUnitStatus(unit)
	if(status) then return status end

	local cur = UnitHealth(unit)
	local max = UnitHealthMax(unit)
	local r, g, b = ColorGradient(cur, max, 0.69, 0.31, 0.31, 0.65, 0.63, 0.35, 0.33, 0.59, 0.33)
	r, g, b = r * 255, g * 255, b * 255

	if(cur == max) then
		return format('|cff%02x%02x%02x%s|r', r, g, b, ShortenValue(max))
	elseif(unit ~= 'pet' and UnitIsFriend(unit, 'player')) then
		return format('|cff%02x%02x%02x-%s|r', r, g, b, ShortenValue(max - cur))
	else
		return format('|cff%02x%02x%02x%d%%|r', r, g, b, floor(cur / max * 100 + 0.5))
	end
end

local function NormalUnitHealthTag(unit)
	local status = GetUnitStatus(unit)
	if(status) then return status end

	local cur = UnitHealth(unit)
	local max = UnitHealthMax(unit)
	local r, g, b = ColorGradient(cur, max, 0.69, 0.31, 0.31, 0.65, 0.63, 0.35, 0.33, 0.59, 0.33)
	r, g, b = r * 255, g * 255, b * 255

	if(cur == max) then
		return format('|cff%02x%02x%02x%s|r', r, g, b, ShortenValue(max))
	elseif(UnitIsFriend(unit, 'player')) then
		return format('|cff%02x%02x%02x-%s - %d%%|r', r, g, b, ShortenValue(max - cur), floor(cur / max * 100 + 0.5))
	else
		return format('|cff%02x%02x%02x%s - %d%%|r', r, g, b, ShortenValue(cur), floor(cur / max * 100 + 0.5))
	end
end

tags['layout:health'] = NormalUnitHealthTag
tags['layout:smallhealth'] = SmallUnitHealthTag
tagEvents['layout:health'] = 'UNIT_CONNECTION UNIT_HEALTH_FREQUENT UNIT_MAXHEALTH'
tagEvents['layout:smallhealth'] = 'UNIT_CONNECTION UNIT_HEALTH_FREQUENT UNIT_MAXHEALTH'

function ns.AddHealthValue(self, unit)
	local healthValue
	if(unit == 'player' or unit == 'target') then
		healthValue = self.Health:CreateFontString(nil, 'OVERLAY', 'LayoutFont_Shadow')
		healthValue:SetPoint('TOPRIGHT', -3.5, -3.5)
		self:Tag(healthValue, '[layout:health]')
	else
		healthValue = self.Health:CreateFontString(nil, 'OVERLAY', 'LayoutFont_Shadow_Small')
		healthValue:SetPoint('TOPRIGHT', -2, -2)
		self:Tag(healthValue, '[layout:smallhealth]')
	end
	self.Health.value = healthValue
end