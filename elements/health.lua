local _, ns = ...

local colors = ns.colors

local height = {
	partypet = 10,
	pet      = 15, -- focus, focustarget, targettarget
	player   = 30,
	raid     = 24,
}
height.party       = height.raid
height.partytarget = height.partypet
height.target      = height.player

local function UpdateHealthColor(health, unit, cur, max)
	local r, g, b, t
	if(health.disconnected and health.colorDisconnected or UnitIsDeadOrGhost(unit)) then
		health:SetValue(max)
		t = colors.disconnected
	elseif(health.colorTapping and not UnitPlayerControlled(unit) and UnitIsTapDenied(unit)) then
		t = colors.tapped
	elseif(health.colorSmooth) then
		r, g, b = health.__owner.ColorGradient(cur, max, unpack(colors.smooth))
	else
		t = colors.health
	end

	if(t) then
		r, g, b = t[1], t[2], t[3]
	end

	if(b) then
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
	health.frequentUpdates = unit ~= 'raid'

	local bg = health:CreateTexture(nil, 'BACKGROUND')
	bg:SetTexture(ns.assets.TEXTURE)
	if (unit == 'raid') then
		bg:SetVertexColor(0.51, 0.45, 0.39)
	else
		bg:SetVertexColor(0.15, 0.15, 0.15)
	end
	bg:SetAllPoints()

	health.UpdateColor = UpdateHealthColor
	self.Health = health
end
