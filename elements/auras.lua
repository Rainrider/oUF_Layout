local _, ns = ...

local playerClass = ns.playerClass

local CustomBuffFilter = {
	player = function(_, _, aura)
		local duration = aura.duration
		return not aura.isFromPlayerOrPlayerPet
			or duration and duration > 0 and duration <= 300 and aura.isPlayerAura
	end,
	target = function(_, unit, aura)
		if UnitIsFriend(unit, 'player') then
			return aura.isPlayerAura or not aura.isFromPlayerOrPlayerPet
		else
			return true
		end
	end,
}
ns.CustomBuffFilter = CustomBuffFilter

local CustomDebuffFilter = {
	target = function(_, unit, aura)
		if not UnitIsFriend(unit, 'player') then
			return aura.isPlayerAura or not aura.isFromPlayerOrPlayerPet or aura.isBossAura
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

local function UpdateAuraTooltip(aura)
	if GameTooltip:IsForbidden() then
		return
	end

	GameTooltip:SetUnitAuraByAuraInstanceID(aura:GetParent().__owner.unit, aura.auraInstanceID)
end

local function PostUpdateAura(element, aura, unit, data)
	local color = C_UnitAuras.GetAuraDispelTypeColor(unit, data.auraInstanceID, element.dispelColorCurve)

	if (data.isHarmfulAura) then
		aura.Border:SetVertexColor(color:GetRGB())
	else
		aura.Stealable:SetVertexColor(color:GetRGB())
		aura.Border:SetAlphaFromBoolean(data.isStealable, 0, 1)
	end
end

local function PostUpdateGapAura(_, unit, aura)
	aura.Border:SetAlpha(0)
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

	local cd = CreateFrame('Cooldown', '$parentCooldown', button, 'CooldownFrameTemplate')
	cd:SetUseAuraDisplayTime(true)
	cd:SetDrawEdge(false)
	cd:SetDrawSwipe(false)
	cd:SetCountdownFont('LayoutFont_Bold_Small_Outline')
	cd:SetAllPoints()

	local timerText = cd:GetRegions()
	timerText:ClearAllPoints()
	timerText:SetPoint('TOPLEFT', 0, 0)

	button.Cooldown = cd

	local border = button:CreateTexture(nil, 'ARTWORK')
	border:SetTexture(ns.assets.BUTTONOVERLAY)
	border:SetPoint('TOPLEFT', -4, 4)
	border:SetPoint('BOTTOMRIGHT', 4, -4)
	border:SetVertexColor(0.17, 0.17, 0.24)
	button.Border = border

	local steable = button:CreateTexture(nil, 'ARTWORK')
	steable:SetTexture(ns.assets.BUTTONOVERLAY)
	steable:SetPoint('TOPLEFT', -4, 4)
	steable:SetPoint('BOTTOMRIGHT', 4, -4)
	button.Stealable = steable

	local count = button:CreateFontString(nil, 'OVERLAY', 'LayoutFont_Bold_Small_Outline')
	count:SetPoint('BOTTOMRIGHT', 0, 0)
	button.Count = count

	button.UpdateTooltip = UpdateAuraTooltip
	button:SetScript('OnEnter', AuraOnEnter)
	button:SetScript('OnLeave', AuraOnLeave)

	return button
end

function ns.AddAuras(self, unit)
	local auras = CreateFrame('Frame', self:GetName() .. '_Auras', self)
	auras.spacing = 7
	auras.size = (230 - 7 * auras.spacing) / 8
	auras.numBuffs = 3
	auras.numDebuffs = 4
	auras.gap = true
	auras:SetSize(7 * (auras.size + auras.spacing), auras.size + auras.spacing)
	auras:SetPoint('RIGHT', self, 'LEFT', -5, 0)
	auras.growthX = 'LEFT'
	auras.initialAnchor = 'RIGHT'
	auras.CreateButton = CreateAura
	auras.PostUpdateButton = PostUpdateAura
	auras.PostUpdateGapButton = PostUpdateGapAura

	self.Auras = auras
end

function ns.AddBuffs(self, unit)
	local buffs = CreateFrame('Frame', self:GetName() .. '_Buffs', self)
	buffs.spacing = 7
	buffs.size = (230 - 7 * buffs.spacing) / 8
	if unit ~= 'boss' then
		buffs:SetSize(8 * (buffs.size + buffs.spacing), 4 * (buffs.size + buffs.spacing))
	else
		buffs.num = 6
		buffs:SetSize(buffs.num * (buffs.size + buffs.spacing), buffs.size + buffs.spacing)
	end
	buffs.growthY = 'DOWN'
	buffs.showStealableBuffs = true

	-- local unitCondition = '%f[%a]' .. unit .. '%f[%A]'
	-- buffs.FilterAura = ns.config.filterBuffs:find(unitCondition) and CustomBuffFilter[unit]
	-- buffs.SortAuras = ns.config.sortBuffs:find(unitCondition) and SortAuras
	buffs.CreateButton = CreateAura
	buffs.PostUpdateButton = PostUpdateAura

	if unit == 'player' then
		buffs:SetPoint('TOPRIGHT', self, 'TOPLEFT', -5, -3.5)
		buffs.initialAnchor = 'TOPRIGHT'
		buffs.growthX = 'LEFT'
	elseif unit == 'boss' then
		buffs:SetPoint('RIGHT', self, 'LEFT', -5, 0)
		buffs.initialAnchor = 'RIGHT'
		buffs.growthX = 'LEFT'
	else
		buffs:SetPoint('TOPLEFT', self, 'TOPRIGHT', 5, -3.5)
		buffs.initialAnchor = 'TOPLEFT'
		buffs.growthX = 'RIGHT'
	end

	self.Buffs = buffs
end

function ns.AddDebuffs(self, unit)
	local debuffs = CreateFrame('Frame', self:GetName() .. '_Debuffs', self)
	debuffs.spacing = 7
	debuffs.size = (230 - 7 * debuffs.spacing) / 8

	-- local unitCondition = '%f[%a]' .. unit .. '%f[%A]'
	-- debuffs.FilterAura = ns.config.filterDebuffs:find(unitCondition) and CustomDebuffFilter[unit]
	-- debuffs.SortAuras = ns.config.sortDebuffs:find(unitCondition) and SortAuras
	debuffs.CreateButton = CreateAura
	debuffs.PostUpdateButton = PostUpdateAura

	if unit == 'player' or unit == 'target' then
		debuffs:SetPoint('TOPLEFT', self, 'BOTTOMLEFT', 3.5, -5)
		debuffs:SetPoint('TOPRIGHT', self, 'BOTTOMRIGHT', -3.5, -5)
		debuffs:SetHeight(5 * (debuffs.size + debuffs.spacing))
		debuffs.initialAnchor = 'TOPLEFT'
		debuffs.growthX = 'RIGHT'
		debuffs.growthY = 'DOWN'
	else
		debuffs:SetPoint('BOTTOMRIGHT', self, 'TOPRIGHT', -3.5, 0)
		debuffs.num = 6
		debuffs:SetSize(debuffs.num * (debuffs.size + debuffs.spacing), debuffs.size + debuffs.spacing)
		debuffs.initialAnchor = 'RIGHT'
		debuffs.growthX = 'LEFT'
	end

	self.Debuffs = debuffs
end
