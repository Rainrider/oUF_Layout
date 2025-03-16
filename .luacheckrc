std = 'lua51'

quiet = 1 -- suppress report output for files without warnings

-- see https://luacheck.readthedocs.io/en/stable/warnings.html#list-of-warnings
-- and https://luacheck.readthedocs.io/en/stable/cli.html#patterns
ignore = {
	'212/self', -- unused argument self
	'212/event', -- unused argument event
	'212/unit', -- unused argument unit
	'212/.*_', -- unused argument with underscore suffix
}

read_globals = {
	'debugstack',
	'geterrorhandler',
	string = { fields = { 'join', 'split', 'trim' } },
	table = { fields = { 'removemulti', 'wipe' } },

	-- FrameXML
	'BackdropTemplateMixin',
	'GameTooltip',
	'PlayerBuffTimerManager',
	'TotemFrame',
	'UIParent',

	-- namespaces
	'Enum',
	'SOUNDKIT',

	-- API
	C_AddOns = { fields = { 'GetAddOnMetadata', 'IsAddOnLoaded' } },
	C_Spell = { fields = { 'GetSpellInfo', 'GetSpellName' } },
	'CreateFrame',
	'GetLocale',
	'GetThreatStatusColor',
	'GetTime',
	'GetTotemInfo',
	'GetUnitPowerBarInfo',
	'GetUnitPowerBarStringsByID',
	'HasLFGRestrictions',
	'InCombatLockdown',
	'IsResting',
	'Mixin',
	'PlaySound',
	'UnitBattlePetLevel',
	'UnitCanAttack',
	'UnitClass',
	'UnitClassification',
	'UnitEffectiveLevel',
	'UnitExists',
	'UnitGroupRolesAssigned',
	'UnitHasIncomingResurrection',
	'UnitHealth',
	'UnitHealthMax',
	'UnitHonorLevel',
	'UnitIsBattlePetCompanion',
	'UnitIsConnected',
	'UnitIsDead',
	'UnitIsDeadOrGhost',
	'UnitIsEnemy',
	'UnitIsFriend',
	'UnitIsGhost',
	'UnitIsGroupLeader',
	'UnitIsPVP',
	'UnitIsPlayer',
	'UnitIsPVPFreeForAll',
	'UnitIsTapDenied',
	'UnitIsUnconscious',
	'UnitIsUnit',
	'UnitIsWildBattlePet',
	'UnitName',
	'UnitPlayerControlled',
	'UnitPower',
	'UnitPowerBarTimerInfo',
	'UnitPowerMax',
	'UnitPowerType',
	'UnitReaction',
	'UnitThreatSituation',

	-- Global addons
	'AdiDebug',
	'BigWigsLoader',
	'ColorGradient',
	'oUF',
}
