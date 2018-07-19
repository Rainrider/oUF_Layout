local addonName, ns = ...

local oUFVersion = GetAddOnMetadata('oUF', 'version')
if(not oUFVersion:find('project%-version')) then
	local major, minor, rev = strsplit('.', oUFVersion)
	oUFVersion = major * 1000 + minor * 100 + rev

	assert(oUFVersion >= 8000, 'oUF Layout requires oUF version >= 8.0.0')
end

ns.Debug = function() end
if(AdiDebug) then
	ns.Debug = AdiDebug:Embed({}, addonName)
end

ns.playerClass = select(2, UnitClass('player'))

local ceil = math.ceil
local floor = math.floor
local format = string.format

function ns.FormatTime(seconds)
	local day, hour, minute = 86400, 3600, 60
	if (seconds >= day) then
		return format('%dd', floor(seconds/day + 0.5))
	elseif (seconds >= hour) then
		return format('%dh', floor(seconds/hour + 0.5))
	elseif (seconds >= minute) then
		if (seconds <= minute * 5) then
			return format('%d:%02d', floor(seconds/minute), seconds % minute)
		end
		return format('%dm', floor(seconds/minute + 0.5))
	else
		return format('%d', ceil(seconds))
	end
end

function ns.ShortenValue(value)
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

local handler = CreateFrame('Frame')
handler:SetScript('OnEvent', function(self, event, ...)
	self[event](self, ...)
end)

function handler:MODIFIER_STATE_CHANGED(key, state)
	if (key ~= 'RALT') then return end

	for _, object in next, oUF.objects do
		local unit = object.realUnit or object.unit
		if (unit == 'target') then
			local buffs = object.Buffs
			if (state == 1) then -- modifier key pressed
				buffs.CustomFilter = nil
			else
				buffs.CustomFilter = ns.config.filterBuffs:find('%f[%a]target%f[%A]') and ns.CustomBuffFilter.target
			end
			buffs:ForceUpdate()
			break
		end
	end
end

function handler:PLAYER_ENTERING_WORLD()
	self:RegisterEvent('PLAYER_REGEN_DISABLED')
	self:RegisterEvent('PLAYER_REGEN_ENABLED')
	if (InCombatLockdown()) then
		self:PLAYER_REGEN_DISABLED()
	else
		self:PLAYER_REGEN_ENABLED()
	end
end
handler:RegisterEvent('PLAYER_ENTERING_WORLD')

function handler:PLAYER_REGEN_DISABLED()
	self:UnregisterEvent('MODIFIER_STATE_CHANGED')
end

function handler:PLAYER_REGEN_ENABLED()
	self:RegisterEvent('MODIFIER_STATE_CHANGED')
end

function handler:PLAYER_TARGET_CHANGED()
	if (UnitExists('target')) then
		if (UnitIsEnemy('target', 'player')) then
			PlaySound(SOUNDKIT.IG_CREATURE_AGGRO_SELECT)
		elseif (UnitIsFriend('target', 'player')) then
			PlaySound(SOUNDKIT.IG_CHARACTER_NPC_SELECT)
		else
			PlaySound(SOUNDKIT.IG_CREATURE_NEUTRAL_SELECT)
		end
	else
		PlaySound(SOUNDKIT.INTERFACE_SOUND_LOST_TARGET_UNIT)
	end
end
handler:RegisterEvent('PLAYER_TARGET_CHANGED')
