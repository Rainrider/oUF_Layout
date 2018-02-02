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
