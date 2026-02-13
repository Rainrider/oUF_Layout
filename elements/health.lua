local _, ns = ...

local colors = ns.colors

local WIDTH = {
	pet = 110,
	player = 230,
	raid = 70,
}
WIDTH.party = WIDTH.raid
WIDTH.target = WIDTH.player

local HEIGHT = {
	partypet = 10,
	pet = 15, -- focus, focustarget, targettarget
	player = 30,
	raid = 24,
}
HEIGHT.party = HEIGHT.raid
HEIGHT.partytarget = HEIGHT.partypet
HEIGHT.target = HEIGHT.player

local function AddHealthPrediction(health, unit)
	local width = WIDTH[unit] or WIDTH['pet']

	local healAbsorbBar = CreateFrame('StatusBar', nil, health)
	healAbsorbBar:SetPoint('TOPRIGHT', health:GetStatusBarTexture())
	healAbsorbBar:SetPoint('BOTTOMRIGHT', health:GetStatusBarTexture())
	healAbsorbBar:SetWidth(width)
	healAbsorbBar:SetReverseFill(true)
	healAbsorbBar:SetStatusBarTexture(ns.assets.TEXTURE)
	healAbsorbBar:SetStatusBarColor(0.75, 0.75, 0, 0.5)
	health.HealAbsorb = healAbsorbBar

	local overHealAbsorb = health:CreateTexture(nil, 'OVERLAY')
	overHealAbsorb:SetWidth(5)
	overHealAbsorb:SetPoint('TOPRIGHT', health, 'TOPLEFT')
	overHealAbsorb:SetPoint('BOTTOMRIGHT', health, 'BOTTOMLEFT')
	health.OverHealAbsorbIndicator = overHealAbsorb

	local myBar = CreateFrame('StatusBar', nil, health)
	myBar:SetPoint('TOPLEFT', health:GetStatusBarTexture(), 'TOPRIGHT')
	myBar:SetPoint('BOTTOMLEFT', health:GetStatusBarTexture(), 'BOTTOMRIGHT')
	myBar:SetWidth(width)
	myBar:SetStatusBarTexture(ns.assets.TEXTURE)
	myBar:SetStatusBarColor(0, 0.5, 0.5, 0.5)
	health.HealingPlayer = myBar

	local otherBar = CreateFrame('StatusBar', nil, health)
	otherBar:SetPoint('TOPLEFT', myBar:GetStatusBarTexture(), 'TOPRIGHT')
	otherBar:SetPoint('BOTTOMLEFT', myBar:GetStatusBarTexture(), 'BOTTOMRIGHT')
	otherBar:SetWidth(width)
	otherBar:SetStatusBarTexture(ns.assets.TEXTURE)
	otherBar:SetStatusBarColor(0, 1, 0, 0.5)
	health.HealingOther = otherBar

	local absorbBar = CreateFrame('StatusBar', nil, health)
	absorbBar:SetPoint('TOPLEFT', otherBar:GetStatusBarTexture(), 'TOPRIGHT')
	absorbBar:SetPoint('BOTTOMLEFT', otherBar:GetStatusBarTexture(), 'BOTTOMRIGHT')
	absorbBar:SetWidth(width)
	absorbBar:SetStatusBarTexture(ns.assets.TEXTURE)
	absorbBar:SetStatusBarColor(1, 1, 1, 0.5)
	health.DamageAbsorb = absorbBar

	local overAbsorb = health:CreateTexture(nil, 'OVERLAY')
	overAbsorb:SetWidth(5)
	overAbsorb:SetPoint('TOPLEFT', health, 'TOPRIGHT')
	overAbsorb:SetPoint('BOTTOMLEFT', health, 'BOTTOMRIGHT')
	health.OverDamageAbsorbIndicator = overAbsorb
end

local function UpdateColor(self, _, unit)
	local health, color = self.Health

	if health.colorDisconnected and (not UnitIsConnected(unit) or UnitIsDeadOrGhost(unit)) then
		color = colors.disconnected
	elseif health.colorTapping and not UnitPlayerControlled(unit) and UnitIsTapDenied(unit) then
		color = colors.tapped
	elseif health.colorSmooth then
		color = health.values:EvaluateCurrentHealthPercent(colors.health:GetCurve())
	else
		color = colors.health
	end

	health:GetStatusBarTexture():SetVertexColor(color:GetRGB())
end

function ns.AddHealthBar(self, unit, withHealthPrediction)
	local health = CreateFrame('StatusBar', nil, self)
	health:SetStatusBarTexture(ns.assets.TEXTURE)
	health:SetHeight(HEIGHT[unit] or HEIGHT['pet'])
	health:SetPoint('TOPLEFT', 5, -5)
	health:SetPoint('TOPRIGHT', -5, -5)
	health.colorTapping = unit ~= 'raid'
	health.colorDisconnected = true
	health.colorSmooth = unit ~= 'raid'

	local bg = health:CreateTexture(nil, 'BACKGROUND')
	bg:SetTexture(ns.assets.TEXTURE)
	if unit == 'raid' then
		bg:SetVertexColor(0.51, 0.45, 0.39)
	else
		bg:SetVertexColor(0.15, 0.15, 0.15)
	end
	bg:SetAllPoints()

	health.UpdateColor = UpdateColor

	if (withHealthPrediction) then
		AddHealthPrediction(health, unit)
	end

	self.Health = health
end
