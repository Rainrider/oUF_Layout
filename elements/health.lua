local _, ns = ...

local colors = ns.colors

local height = {
	partypet = 10,
	pet = 15, -- focus, focustarget, targettarget
	player = 30,
	raid = 24,
}
height.party = height.raid
height.partytarget = height.partypet
height.target = height.player

local function UpdateColor(self, _, unit)
	local r, g, b, color
	local health = self.Health
	local cur, max = health.cur or 1, health.max or 1
	if health.colorDisconnected and not UnitIsConnected(unit) or UnitIsDeadOrGhost(unit) then
		health:SetValue(max)
		color = colors.disconnected
	elseif health.colorTapping and not UnitPlayerControlled(unit) and UnitIsTapDenied(unit) then
		color = colors.tapped
	elseif health.colorSmooth then
		r, g, b = self:ColorGradient(cur, max, unpack(colors.smooth))
	else
		color = colors.health
	end

	if color then
		r, g, b = color.r, color.g, color.b
	end

	if b then
		health:SetStatusBarColor(r, g, b)
	end
end

function ns.AddHealthBar(self, unit)
	local health = CreateFrame('StatusBar', nil, self)
	health:SetStatusBarTexture(ns.assets.TEXTURE)
	health:SetHeight(height[unit] or height['pet'])
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
	self.Health = health
end
