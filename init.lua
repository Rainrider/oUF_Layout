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
