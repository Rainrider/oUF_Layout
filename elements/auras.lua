local _, ns = ...

local playerClass = ns.playerClass

local floor = math.floor
local format = string.format

local ImportantBuffs = {
	[  1022] = true, -- Hand of Protection
	[  2825] = true, -- Bloodlust
	[ 20707] = true, -- Soulstone
	[ 32182] = true, -- Heroism
	[ 80353] = true, -- Time Warp
	[ 90355] = true, -- Ancient Hysteria
	[178207] = true, -- Drums of Fury
	[230935] = true, -- Drums of the Mountain
}

local ImportantDebuffs = {
	[  6788] = playerClass == "PRIEST", -- Weakened Soul
	[ 25771] = playerClass == "PALADIN", -- Forbearance
	[212570] = true, -- Surrendered Soul
}

local CustomBuffFilter = {
	player = function(_, _, aura, _, _, _, _, _, duration, _, caster, _, _, spellID, _, _, casterIsPlayer)
		return not casterIsPlayer or
			duration and duration > 0 and duration <= 300 and (aura.isPlayer or caster == 'pet') or
			ImportantBuffs[spellID]
	end,
	target = function(_, unit, aura, _, _, _, _, _, _, _, caster, _, _, _, _, _, casterIsPlayer)
		if(UnitIsFriend(unit, 'player')) then
			return aura.isPlayer or caster == 'pet' or not casterIsPlayer
		else
			return true
		end
	end,
}

local CustomDebuffFilter = {
	target = function(_, unit, aura, _, _, _, _, _, _, _, caster, _, _, spellID, _, isBossDebuff, casterIsPlayer)
		if (not UnitIsFriend(unit, 'player')) then
			return aura.isPlayer or caster == 'pet' or not casterIsPlayer or isBossDebuff or ImportantDebuffs[spellID]
		else
			return true
		end
	end,
}
CustomDebuffFilter.focus = CustomDebuffFilter.target

local function AuraOnEnter(aura)
	if (not aura:IsVisible()) then return end

	GameTooltip:SetOwner(aura, 'ANCHOR_BOTTOMRIGHT')
	aura:UpdateTooltip()
end

local function AuraOnLeave(aura)
	GameTooltip:Hide()
end

local function FormatTime(seconds)
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
		return format('%d', seconds)
	end
end

local function UpdateAuraTimer(aura, elapsed)
	local timeLeft = aura.timeLeft - elapsed
	aura.timer:SetText((timeLeft > 0) and FormatTime(timeLeft))
	aura.timeLeft = timeLeft
end

local function UpdateAuraTooltip(aura)
	GameTooltip:SetUnitAura(aura:GetParent().__owner.unit, aura:GetID(), aura.filter)
end

local function PostUpdateAura(auras, unit, aura, index, offset)
	local _, _, _, _, dispelType, duration, expiration, _, canStealOrPurge = UnitAura(unit, index, aura.filter)

	if (duration and duration > 0) then
		aura.timeLeft = expiration - GetTime()
		aura:SetScript('OnUpdate', UpdateAuraTimer)
	else
		aura:SetScript('OnUpdate', nil)
		aura.timer:SetText()
	end

	if (not aura.isDebuff) then
		if (canStealOrPurge) then
			local color = DebuffTypeColor[dispelType or 'none']
			aura.overlay:SetVertexColor(color.r, color.g, color.b)
		else
			aura.overlay:SetVertexColor(0, 0, 0)
		end
	end
end

local function PostUpdateGapAura(_, _, aura)
	aura:SetScript('OnUpdate', nil)
	aura.timer:SetText()
end

local function CreateAura(auras, index)
	local button = CreateFrame('Button', auras:GetName() .. index, auras)

	local icon = button:CreateTexture(nil, 'BORDER')
	icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
	icon:SetAllPoints()
	button.icon = icon

	local overlay = button:CreateTexture(nil, 'ARTWORK')
	overlay:SetTexture(ns.assets.BUTTONOVERLAY)
	overlay:SetTexCoord(0.08, 0.92, 0.08, 0.92)
	overlay:SetAllPoints()
	button.overlay = overlay

	local count = button:CreateFontString(nil, 'OVERLAY', 'LayoutFont_Shadow_Small')
	count:SetPoint('BOTTOMRIGHT', -1, 1)
	button.count = count

	local timer = button:CreateFontString(nil, 'OVERLAY', 'LAyoutFont_Shadow_Small')
	timer:SetPoint('TOPLEFT', 1, -1)
	button.timer = timer

	button.UpdateTooltip = UpdateAuraTooltip
	button:SetScript('OnEnter', AuraOnEnter)
	button:SetScript('OnLeave', AuraOnLeave)

	return button
end

function ns.AddAuras(self, unit)
	local auras = CreateFrame('Frame', self:GetName() .. '_Auras', self)
	auras.spacing = 2.5
	auras.size = (230 - 7 * auras.spacing) / 8
	auras.numBuffs = 3
	auras.numDebuffs = 3
	auras.gap = true
	auras:SetSize(7 * (auras.size + auras.spacing), auras.size + auras.spacing)
	auras:SetPoint('RIGHT', self, 'LEFT', -2.5, 0)
	auras['growth-x'] = 'LEFT'
	auras.initialAnchor = 'TOPRIGHT'
	auras.showType = true
	auras.CreateIcon = CreateAura
	auras.PostUpdateIcon = PostUpdateAura
	auras.PostUpdateGapIcon = PostUpdateGapAura

	self.Auras = auras
end

function ns.AddBuffs(self, unit)
	local buffs = CreateFrame('Frame', self:GetName() .. '_Buffs', self)
	buffs.spacing = 2.5
	buffs.size = (230 - 7 * buffs.spacing) / 8
	buffs:SetSize(8 * (buffs.size + buffs.spacing), 4 * (buffs.size + buffs.spacing))
	buffs['growth-y'] = 'DOWN'
	buffs.showBuffType = true
	buffs.CustomFilter = ns.config.filterBuffs:find('%f[%a]' .. unit .. '%f[%A]') and CustomBuffFilter[unit]
	buffs.CreateIcon = CreateAura
	buffs.PostUpdateIcon = PostUpdateAura

	if(unit == 'player') then
		buffs:SetPoint('TOPRIGHT', self, 'TOPLEFT', -2.5, -5)
		buffs.initialAnchor = 'TOPRIGHT'
		buffs['growth-x'] = 'LEFT'
	else
		buffs:SetPoint('TOPLEFT', self, 'TOPRIGHT', 2.5, -5)
		buffs.initialAnchor = 'TOPLEFT'
		buffs['growth-x'] = 'RIGHT'
	end

	self.Buffs = buffs
end

function ns.AddDebuffs(self, unit)
	local debuffs = CreateFrame('Frame', self:GetName() .. '_Debuffs', self)
	debuffs.spacing = 2.5
	debuffs.size = (230 - 7 * debuffs.spacing) / 8
	debuffs.showDebuffType = true
	debuffs.CustomFilter = ns.config.filterDebuffs:find('%f[%a]' .. unit .. '%f[%A]') and CustomDebuffFilter[unit]
	debuffs.CreateIcon = CreateAura
	debuffs.PostUpdateIcon = PostUpdateAura

	if (unit == 'player' or unit == 'target') then
		debuffs:SetPoint('TOPLEFT', self, 'BOTTOMLEFT', 5, -2.5)
		debuffs:SetPoint('TOPRIGHT', self, 'BOTTOMRIGHT', -5, -2.5)
		debuffs:SetHeight(5 * (debuffs.size + debuffs.spacing))
		debuffs.initialAnchor = 'TOPLEFT'
		debuffs['growth-x'] = 'RIGHT'
		debuffs['growth-y'] = 'DOWN'
	else
		debuffs:SetPoint('BOTTOMRIGHT', self, 'TOPRIGHT', -5, 2.5)
		debuffs.num = 6
		debuffs:SetSize(debuffs.num * (debuffs.size + debuffs.spacing), debuffs.size + debuffs.spacing)
		debuffs.initialAnchor = 'RIGHT'
		debuffs['growth-x'] = 'LEFT'
	end

	self.Debuffs = debuffs
end
