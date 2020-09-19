local _, ns = ...

local tags = oUF.Tags.Methods
local tagEvents = oUF.Tags.Events
local tagSharedEvents = oUF.Tags.SharedEvents

local floor = math.floor
local format = string.format

local ShortenValue = ns.ShortenValue

local GHOST = GetLocale() == 'deDE' and 'Geist' or GetSpellInfo(8326)

local function GetColoredName(unit, realUnit)
	local colors = ns.colors
	local color
	if (UnitIsPlayer(unit)) then
		local _, class = UnitClass(realUnit or unit)
		if(class) then
			color = colors.class[class]
		end
	else
		local reaction = UnitReaction(realUnit or unit, 'player')
		color = colors.reaction[reaction or 4]
	end

	color = color or colors.disconnected

	return format('|cff%02x%02x%02x%s|r', color[1] * 255, color[2] * 255, color[3] * 255, UnitName(unit))
end

local function GetPvPStatus(unit)
	local level = UnitHonorLevel(unit)
	local status
	local color

	if (UnitIsPVPFreeForAll(unit)) then
		status = "FFA"
		color = ORANGE_FONT_COLOR_CODE
	elseif (UnitIsPVP(unit)) then
		status = "PvP"
		color = RED_FONT_COLOR_CODE
	end

	if (status) then
		if (level and level > 0) then
			status = format("%s %d", status, level)
		end

		return format("%s%s|r", color, status)
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

local function GetRoleColoredName(unit, realUnit)
	local status = GetUnitStatus(realUnit or unit)
	local color = ns.colors.role[UnitGroupRolesAssigned(realUnit or unit)] or ns.colors.role.NONE

	return format('|cff%02x%02x%02x%s|r', color[1] * 255, color[2] * 255, color[3] * 255, status or UnitName(unit))
end

local function LevelTag(unit)
	if (UnitClassification(unit) == 'worldboss') then return end

	local level
	if (UnitIsWildBattlePet(unit) or UnitIsBattlePetCompanion(unit)) then
		level = UnitBattlePetLevel(unit)
	else
		level = UnitEffectiveLevel(unit)
	end

	if (level == UnitEffectiveLevel('player')) then return end
	if (level < 0) then return '??' end
	return level
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

	local cur, max = UnitHealth(unit), UnitHealthMax(unit)
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

local function PowerTag(unit)
	if(not UnitIsConnected(unit) or UnitIsDeadOrGhost(unit)) then return end

	local cur, max = UnitPower(unit), UnitPowerMax(unit)
	if(max == 0) then return end

	local powerValue
	local powerType, powerName = UnitPowerType(unit)
	if(powerName == 'MANA' and cur ~= max) then
		powerValue = floor(cur / max * 100 + 0.5) .. '%'
	end

	if(unit == 'player') then
		if(powerValue) then -- player's mana not full
			powerValue = format('%s - %s', powerValue, ShortenValue(cur))
		else -- mana full or other power type
			powerValue = ShortenValue(cur)
		end
	elseif(not powerValue) then
		powerValue = ShortenValue(cur)
	end

	local colors = ns.colors.power
	local r, g, b = unpack(colors[powerName] or colors[powerType])
	return format('|cff%02x%02x%02x%s|r', r * 255, g * 255, b * 255, powerValue)
end

local function AltManaTag(unit)
	if (UnitPowerType(unit) == 0) then return end

	local cur, max = UnitPower(unit, 0), UnitPowerMax(unit, 0)

	if (cur == max) then return end

	local color = ns.colors.power.MANA
	local r, g, b = color[1] * 255, color[2] * 255, color[3] * 255
	return format("|cff%02x%02x%02x%d%%|r", r, g, b, floor(cur / max * 100 + 0.5))
end

tags['layout:health'] = NormalUnitHealthTag
tagEvents['layout:health'] = 'UNIT_CONNECTION UNIT_HEALTH UNIT_MAXHEALTH'
tags['layout:smallhealth'] = SmallUnitHealthTag
tagEvents['layout:smallhealth'] = 'UNIT_CONNECTION UNIT_HEALTH UNIT_MAXHEALTH'
tags['layout:power'] = PowerTag
tagEvents['layout:power'] = 'UNIT_POWER_FREQUENT UNIT_MAXPOWER UNIT_DISPLAYPOWER'
tags['layout:altmana'] = AltManaTag
tagEvents['layout:altmana'] = 'UNIT_POWER_FREQUENT UNIT_MAXPOWER UNIT_DISPLAYPOWER'
tags['layout:name'] = GetColoredName
tagEvents['layout:name'] = 'UNIT_NAME_UPDATE UNIT_FACTION'
tags['layout:level'] = LevelTag
tagEvents['layout:level'] = 'UNIT_LEVEL UNIT_CLASSIFICATION_CHANGED'
tags['layout:pvp'] = GetPvPStatus
tagEvents['layout:pvp'] = 'UNIT_FACTION HONOR_LEVEL_UPDATE'
tags['layout:raidname'] = GetRoleColoredName
tagEvents['layout:raidname'] = 'UNIT_NAME_UPDATE UNIT_CONNECTION UNIT_FLAGS UNIT_FACTION' -- flags should get roles and dead or ghost

function ns.AddHealthValue(self, unit)
	local healthValue
	if(unit == 'player' or unit == 'target') then
		healthValue = self.Health:CreateFontString(nil, 'OVERLAY', 'LayoutFont_Shadow')
		healthValue:SetPoint('TOPRIGHT', -3.5, -3.5)
		self:Tag(healthValue, '[layout:health]')
	else
		healthValue = self.Health:CreateFontString(nil, 'OVERLAY', 'LayoutFont_Shadow_Small')
		healthValue:SetPoint('RIGHT', -2, 0)
		self:Tag(healthValue, '[layout:smallhealth]')
	end
	self.Health.value = healthValue
end

function ns.AddInfoText(self, unit)
	local info
	local health = self.Health
	if (unit == 'target') then
		info = health:CreateFontString(nil, 'OVERLAY', 'LayoutFont_Shadow')
		info:SetPoint('LEFT', self.Power.value, 'RIGHT', 5, 0)
		info:SetPoint('TOP', 0, -3.5)
		self:Tag(info, '[layout:name][difficulty][ $>layout:level][ $>shortclassification]|r')
	else
		info = health:CreateFontString(nil, 'OVERLAY', 'LayoutFont_Shadow_Small')
		info:SetPoint('LEFT', 2, 0)
		if (unit == 'raid' or unit == 'party') then
			self:Tag(info, '[layout:raidname]')
		else
			self:Tag(info, '[layout:name]')
		end
	end
	if (unit == 'raid' or unit:find('^party')) then
		info:SetPoint('RIGHT', -2, 0)
	else
		info:SetPoint('RIGHT', health.value, 'LEFT', -5, 0)
	end
	info:SetJustifyH('LEFT')
	info:SetWordWrap(false)
end

function ns.AddPowerValue(self, unit)
	local health = self.Health
	local powerValue = health:CreateFontString(nil, 'OVERLAY', 'LayoutFont_Shadow')
	powerValue:SetPoint('TOPLEFT', 3.5, -3.5)
	if(unit == 'player') then
		self:Tag(powerValue, '[layout:power][ - $>layout:altmana]')
	else
		self:Tag(powerValue, '[layout:power]')
	end
	self.Power.value = powerValue
end

local GetPVPTimer = GetPVPTimer
local pvpElapsed = 0
local function UpdatePvPTimer(self, elapsed)
	pvpElapsed = pvpElapsed + elapsed
	if (pvpElapsed > 0.5) then
		pvpElapsed = 0
		local timer = GetPVPTimer() / 1000
		if (timer > 0 and timer < 300) then
			self.PvP:SetText(format("%d:%02d", floor(timer / 60), timer % 60))
		end
	end
end

function ns.AddPvPText(self, unit)
	local pvp = self.Portrait:CreateFontString(nil, 'OVERLAY', 'LayoutFont_Bold_Large_Outline')
	pvp:SetPoint('RIGHT', -2.5, 0)
	pvp:SetTextColor(0.69, 0.31, 0.31, 0.6)
	self.PvP = pvp
	self:Tag(pvp, '[layout:pvp]')

	if (unit == 'player') then
		self:HookScript('OnEnter', function()
			if (UnitIsPVP('player')) then
				self:SetScript('OnUpdate', UpdatePvPTimer)
			end
		end)
		self:HookScript('OnLeave', function()
			self:SetScript('OnUpdate', nil)
			pvp:UpdateTag()
		end)
	end
end