local addonName, ns = ...

local oUFVersion = GetAddOnMetadata('oUF', 'version')
if(not oUFVersion:find('project%-version')) then
	local major, minor, rev = strsplit('.', oUFVersion)
	oUFVersion = major * 1000 + minor * 100 + rev

	assert(oUFVersion >= 7000, 'oUF Layout requires oUF version >= 7.0.0')
end

ns.Debug = function() end
if(AdiDebug) then
	ns.Debug = AdiDebug:Embed({}, addonName)
end

ns.playerClass = select(2, UnitClass('player'))

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
