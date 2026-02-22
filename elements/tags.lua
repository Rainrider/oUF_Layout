local _, ns = ...

--luacheck: globals oUF.Tags
local tags = oUF.Tags.Methods
local tagEvents = oUF.Tags.Events
local tagSharedEvents = oUF.Tags.SharedEvents --luacheck: no unused
local playerClass = ns.playerClass

local floor = math.floor
local format = string.format

local ScaleTo100 = _G.CurveConstants.ScaleTo100

local GHOST = GetLocale() == 'deDE' and 'Geist' or C_Spell.GetSpellName(8326)

local function GetColoredName(unit, realUnit)
	local colors = ns.colors
	local color
	if UnitIsPlayer(unit) then
		local class = UnitClassBase(realUnit or unit)
		if class then
			color = colors.class[class]
		end
	else
		local reaction = UnitReaction(realUnit or unit, 'player')
		color = colors.reaction[reaction or 4]
	end

	color = color or colors.disconnected

	return color:WrapTextInColorCode(UnitName(unit) or '')
end

local function GetPvPStatus(unit)
	local level = UnitHonorLevel(unit)
	local status
	local color

	if UnitIsPVPFreeForAll(unit) then
		status = 'FFA'
		color = _G.ORANGE_FONT_COLOR_CODE
	elseif UnitIsPVP(unit) then
		status = 'PvP'
		color = _G.RED_FONT_COLOR_CODE
	end

	if status then
		if level and level > 0 then
			status = format('%s %d', status, level)
		end

		return format('%s%s|r', color, status)
	end
end

local function GetUnitStatus(unit)
	if not UnitIsConnected(unit) then
		return _G.PLAYER_OFFLINE
	end
	if UnitIsUnconscious(unit) then
		return _G.UNCONSCIOUS
	end
	if UnitIsGhost(unit) then
		return GHOST
	end
	if UnitIsDead(unit) then
		return _G.DEAD
	end
end

local function GetRoleColoredName(unit, realUnit)
	local status = GetUnitStatus(realUnit or unit)
	local color = ns.colors.role[UnitGroupRolesAssigned(realUnit or unit)] or ns.colors.role.NONE

	return color:WrapTextInColorCode(status or UnitName(unit))
end

local function LevelTag(unit)
	if UnitClassification(unit) == 'worldboss' then
		return
	end

	local level
	if UnitIsWildBattlePet(unit) or UnitIsBattlePetCompanion(unit) then
		level = UnitBattlePetLevel(unit)
	else
		level = UnitEffectiveLevel(unit)
	end

	if level == UnitEffectiveLevel('player') then
		return
	end
	if level < 0 then
		return '??'
	end
	return level
end

local healthTextCurve = C_CurveUtil.CreateColorCurve()
healthTextCurve:AddPoint(0.0, CreateColor(0.69, 0.31, 0.31))
healthTextCurve:AddPoint(0.5, CreateColor(0.65, 0.63, 0.35))
healthTextCurve:AddPoint(1.0, CreateColor(0.33, 0.59, 0.33))

local function SmallUnitHealthTag(unit)
	local status = GetUnitStatus(unit)
	if status then
		return status
	end

	local color = UnitHealthPercent(unit, true, healthTextCurve)

	-- TODO: show max when cur == max
	if unit ~= 'pet' and UnitIsFriend(unit, 'player') then
		local missing = AbbreviateNumbers(UnitHealthMissing(unit))

		return color:WrapTextInColorCode(format('-%s', missing))
	else
		local percent = UnitHealthPercent(unit, true, ScaleTo100)

		return color:WrapTextInColorCode(format('%d%%', percent))
	end
end

local function NormalUnitHealthTag(unit)
	local status = GetUnitStatus(unit)
	if status then
		return status
	end

	local percent = UnitHealthPercent(unit, true, ScaleTo100)
	local color = UnitHealthPercent(unit, true, healthTextCurve)

	-- TODO: show max when cur == max
	if UnitIsFriend(unit, 'player') then
		local missing = AbbreviateNumbers(UnitHealthMissing(unit))

		return color:WrapTextInColorCode(format('-%s - %d%%', missing, percent))
	else
		local current = AbbreviateNumbers(UnitHealth(unit))

		return color:WrapTextInColorCode(format('%s - %d%%', current, percent))
	end
end

local function PowerTag(unit)
	if not UnitIsConnected(unit) or UnitIsDeadOrGhost(unit) then
		return
	end

	local powerValue = AbbreviateNumbers(UnitPower(unit))
	local powerType, powerName = UnitPowerType(unit)
	local colors = ns.colors.power
	local color = colors[powerName] or colors[powerType]

	return color:WrapTextInColorCode(powerValue)
end

local function AltManaTag(unit)
	if UnitPowerType(unit) == 0 or not _G.ALT_POWER_BAR_PAIR_DISPLAY_INFO[playerClass] then
		return
	end

	local percent = UnitPowerPercent(unit, 0, false, ScaleTo100)
	local color = ns.colors.power.MANA

	return color:WrapTextInColorCode(format('%d%%', percent))
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
-- flags should get roles and dead or ghost
tagEvents['layout:raidname'] = 'UNIT_NAME_UPDATE UNIT_CONNECTION UNIT_FLAGS UNIT_FACTION'

function ns.AddHealthValue(self, unit)
	local healthValue
	if unit == 'player' or unit == 'target' then
		healthValue = self.Health:CreateFontString(nil, 'OVERLAY', 'LayoutFont_Shadow')
		healthValue:SetPoint('TOPRIGHT', self, -8.5, -8.5)
		self:Tag(healthValue, '[layout:health]')
	else
		healthValue = self.Health:CreateFontString(nil, 'OVERLAY', 'LayoutFont_Shadow_Small')
		healthValue:SetPoint('RIGHT', self, -7, 3.5)
		self:Tag(healthValue, '[layout:smallhealth]')
	end
	self.Health.value = healthValue
end

function ns.AddInfoText(self, unit)
	local info
	local health = self.Health

	if unit == 'target' then
		info = health:CreateFontString(nil, 'OVERLAY', 'LayoutFont_Shadow')
		info:SetPoint('LEFT', self.Power.value, 'RIGHT', 5, 0)
		info:SetPoint('TOP', 0, -3.5)
		self:Tag(info, '[layout:name][difficulty][ $>layout:level]|r')
	else
		info = health:CreateFontString(nil, 'OVERLAY', 'LayoutFont_Shadow_Small')
		info:SetPoint('LEFT', 2, 0)
		if unit == 'raid' or unit == 'party' then
			self:Tag(info, '[layout:raidname]')
		else
			self:Tag(info, '[layout:name]')
		end
	end

	if unit == 'raid' or unit:find('^party') then
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

	if unit == 'player' then
		self:Tag(powerValue, '[layout:power][ - $>layout:altmana]')
	else
		self:Tag(powerValue, '[layout:power]')
	end

	self.Power.value = powerValue
end

local GetPVPTimer = _G.GetPVPTimer
local pvpElapsed = 0
local function UpdatePvPTimer(self, elapsed)
	pvpElapsed = pvpElapsed + elapsed
	if pvpElapsed > 0.5 then
		pvpElapsed = 0
		local timer = GetPVPTimer() / 1000
		if timer > 0 and timer < 300 then
			self.PvP:SetText(format('%d:%02d', floor(timer / 60), timer % 60))
		end
	end
end

function ns.AddPvPText(self, unit)
	local pvp = self.Portrait:CreateFontString(nil, 'OVERLAY', 'LayoutFont_Bold_Large_Outline')
	pvp:SetPoint('RIGHT', -2.5, 0)
	pvp:SetTextColor(0.69, 0.31, 0.31, 0.6)
	self.PvP = pvp
	self:Tag(pvp, '[layout:pvp]')

	if unit == 'player' then
		self:HookScript('OnEnter', function()
			if UnitIsPVP('player') then
				self:SetScript('OnUpdate', UpdatePvPTimer)
			end
		end)
		self:HookScript('OnLeave', function()
			self:SetScript('OnUpdate', nil)
			pvp:UpdateTag()
		end)
	end
end
