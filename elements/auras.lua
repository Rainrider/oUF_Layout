local _, ns = ...

local playerClass = ns.playerClass
local FormatTime = ns.FormatTime

local ImportantBuffs = {
	[17] = playerClass == 'PRIEST', -- Power Word: Shield
	[1022] = true, -- Hand of Protection
	[2825] = true, -- Bloodlust
	[20707] = true, -- Soulstone
	[32182] = true, -- Heroism
	[80353] = true, -- Time Warp
	[90355] = true, -- Ancient Hysteria
	[178207] = true, -- Drums of Fury
	[230935] = true, -- Drums of the Mountain
}

local ImportantDebuffs = {
	[6788] = playerClass == 'PRIEST', -- Weakened Soul
	[25771] = playerClass == 'PALADIN', -- Forbearance
	[212570] = true, -- Surrendered Soul
}

local EncounterDebuffs = {}

if BigWigsLoader then
	BigWigsLoader.RegisterMessage(EncounterDebuffs, 'BigWigs_OnBossLog', function(_, bossMod, event, ...)
		if event:find('^SPELL_AURA_') then
			for i = 1, select('#', ...) do
				local id = select(i, ...)
				EncounterDebuffs[id] = bossMod
			end
		end
	end)

	BigWigsLoader.RegisterMessage(EncounterDebuffs, 'BigWigs_OnBossDisable', function(_, bossMod)
		for id, mod in next, EncounterDebuffs do
			if mod == bossMod then
				EncounterDebuffs[id] = nil
			end
		end
	end)
end

local CustomBuffFilter = {
	player = function(_, _, aura)
		local duration = aura.duration
		return not aura.isFromPlayerOrPlayerPet
			or duration and duration > 0 and duration <= 300 and aura.isPlayerAura
			or ImportantBuffs[aura.spellId]
	end,
	target = function(_, unit, aura)
		if UnitIsFriend(unit, 'player') then
			return aura.isPlayerAura or not aura.isFromPlayerOrPlayerPet or ImportantBuffs[aura.spellId]
		else
			return true
		end
	end,
}
ns.CustomBuffFilter = CustomBuffFilter

local CustomDebuffFilter = {
	target = function(_, unit, aura)
		if not UnitIsFriend(unit, 'player') then
			return aura.isPlayerAura or not aura.isFromPlayerOrPlayerPet or aura.isBossAura or ImportantDebuffs[aura.spellId]
		else
			return true
		end
	end,
	party = function(_, _, aura)
		return not not EncounterDebuffs[aura.spellId]
	end,
}
CustomDebuffFilter.focus = CustomDebuffFilter.target

local function AuraOnEnter(aura)
	if GameTooltip:IsForbidden() or not aura:IsVisible() then
		return
	end

	-- Avoid parenting GameTooltip to frames with anchoring restrictions,
	-- otherwise it'll inherit said restrictions which will cause issues with
	-- its further positioning, clamping, etc
	GameTooltip:SetOwner(aura, aura:GetParent().__restricted and 'ANCHOR_CURSOR' or aura:GetParent().tooltipAnchor)
	aura:UpdateTooltip()
end

local function AuraOnLeave()
	if GameTooltip:IsForbidden() then
		return
	end

	GameTooltip:Hide()
end

local function UpdateAuraTimer(aura, elapsed)
	local timeLeft = aura.timeLeft - elapsed
	aura.Timer:SetText((timeLeft > 0) and FormatTime(timeLeft) or '')
	aura.timeLeft = timeLeft
end

local function UpdateAuraTooltip(aura)
	if GameTooltip:IsForbidden() then
		return
	end

	if aura.isHarmful then
		GameTooltip:SetUnitDebuffByAuraInstanceID(aura:GetParent().__owner.unit, aura.auraInstanceID)
	else
		GameTooltip:SetUnitBuffByAuraInstanceID(aura:GetParent().__owner.unit, aura.auraInstanceID)
	end
end

local function PostUpdateAura(_, aura, _, data)
	if data.duration and data.duration > 0 then
		aura.timeLeft = data.expirationTime - GetTime()
		aura:SetScript('OnUpdate', UpdateAuraTimer)
	else
		aura:SetScript('OnUpdate', nil)
		aura.Timer:SetText('')
	end

	if not aura.isHarmful then
		if data.isStealable then
			local color = ns.colors.debuff[data.dispelName or 'none']
			aura.Overlay:SetVertexColor(color.r, color.g, color.b)
		else
			aura.Overlay:SetVertexColor(0, 0, 0)
		end
	end
end

local function PostUpdateGapAura(_, _, aura)
	aura:SetScript('OnUpdate', nil)
	aura.Timer:SetText('')
end

local function SortAuras(a, b)
	if a.duration ~= b.duration then
		return a.duration == 0 or b.duration ~= 0 and a.expirationTime > b.expirationTime
	end

	return a.auraInstanceID < b.auraInstanceID
end

local function CreateAura(auras, index)
	local button = CreateFrame('Button', auras:GetName() .. index, auras)

	local icon = button:CreateTexture(nil, 'BORDER')
	icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
	icon:SetAllPoints()
	button.Icon = icon

	local overlay = button:CreateTexture(nil, 'ARTWORK')
	overlay:SetTexture(ns.assets.BUTTONOVERLAY)
	overlay:SetPoint('TOPLEFT', -2.5, 2.5)
	overlay:SetPoint('BOTTOMRIGHT', 2.5, -2.5)
	button.Overlay = overlay

	local count = button:CreateFontString(nil, 'OVERLAY', 'LayoutFont_Bold_Small_Outline')
	count:SetPoint('BOTTOMRIGHT', 0, 0)
	button.Count = count

	local timer = button:CreateFontString(nil, 'OVERLAY', 'LayoutFont_Bold_Small_Outline')
	timer:SetPoint('TOPLEFT', 0, 0)
	button.Timer = timer

	button.UpdateTooltip = UpdateAuraTooltip
	button:SetScript('OnEnter', AuraOnEnter)
	button:SetScript('OnLeave', AuraOnLeave)

	return button
end

function ns.AddAuras(self, unit)
	local auras = CreateFrame('Frame', self:GetName() .. '_Auras', self)
	auras.spacing = 5
	auras.size = (230 - 7 * auras.spacing) / 8
	auras.numBuffs = 3
	auras.numDebuffs = 4
	auras.gap = true
	auras:SetSize(7 * (auras.size + auras.spacing), auras.size + auras.spacing)
	auras:SetPoint('RIGHT', self, 'LEFT', -2.5, 0)
	auras['growth-x'] = 'LEFT'
	auras.initialAnchor = 'RIGHT'
	auras.showType = true
	auras.CreateButton = CreateAura
	auras.PostUpdateButton = PostUpdateAura
	auras.PostUpdateGapButton = PostUpdateGapAura

	self.Auras = auras
end

function ns.AddBuffs(self, unit)
	local buffs = CreateFrame('Frame', self:GetName() .. '_Buffs', self)
	buffs.spacing = 5
	buffs.size = (230 - 7 * buffs.spacing) / 8
	if unit ~= 'boss' then
		buffs:SetSize(8 * (buffs.size + buffs.spacing), 4 * (buffs.size + buffs.spacing))
	else
		buffs.num = 6
		buffs:SetSize(buffs.num * (buffs.size + buffs.spacing), buffs.size + buffs.spacing)
	end
	buffs['growth-y'] = 'DOWN'
	buffs.showBuffType = true

	local unitCondition = '%f[%a]' .. unit .. '%f[%A]'
	buffs.FilterAura = ns.config.filterBuffs:find(unitCondition) and CustomBuffFilter[unit]
	buffs.SortAuras = ns.config.sortBuffs:find(unitCondition) and SortAuras
	buffs.CreateButton = CreateAura
	buffs.PostUpdateButton = PostUpdateAura

	if unit == 'player' then
		buffs:SetPoint('TOPRIGHT', self, 'TOPLEFT', -2.5, -3.5)
		buffs.initialAnchor = 'TOPRIGHT'
		buffs['growth-x'] = 'LEFT'
	elseif unit == 'boss' then
		buffs:SetPoint('RIGHT', self, 'LEFT', -2.5, 0)
		buffs.initialAnchor = 'RIGHT'
		buffs['growth-x'] = 'LEFT'
	else
		buffs:SetPoint('TOPLEFT', self, 'TOPRIGHT', 2.5, -3.5)
		buffs.initialAnchor = 'TOPLEFT'
		buffs['growth-x'] = 'RIGHT'
	end

	self.Buffs = buffs
end

function ns.AddDebuffs(self, unit)
	local debuffs = CreateFrame('Frame', self:GetName() .. '_Debuffs', self)
	debuffs.spacing = 5
	debuffs.size = (230 - 7 * debuffs.spacing) / 8
	debuffs.showDebuffType = true

	local unitCondition = '%f[%a]' .. unit .. '%f[%A]'
	debuffs.FilterAura = ns.config.filterDebuffs:find(unitCondition) and CustomDebuffFilter[unit]
	debuffs.SortAuras = ns.config.sortDebuffs:find(unitCondition) and SortAuras
	debuffs.CreateButton = CreateAura
	debuffs.PostUpdateButton = PostUpdateAura

	if unit == 'player' or unit == 'target' then
		debuffs:SetPoint('TOPLEFT', self, 'BOTTOMLEFT', 5, -2.5)
		debuffs:SetPoint('TOPRIGHT', self, 'BOTTOMRIGHT', -5, -2.5)
		debuffs:SetHeight(5 * (debuffs.size + debuffs.spacing))
		debuffs.initialAnchor = 'TOPLEFT'
		debuffs['growth-x'] = 'RIGHT'
		debuffs['growth-y'] = 'DOWN'
	else
		debuffs:SetPoint('BOTTOMRIGHT', self, 'TOPRIGHT', -5, 0)
		debuffs.num = 6
		debuffs:SetSize(debuffs.num * (debuffs.size + debuffs.spacing), debuffs.size + debuffs.spacing)
		debuffs.initialAnchor = 'RIGHT'
		debuffs['growth-x'] = 'LEFT'
	end

	self.Debuffs = debuffs
end
