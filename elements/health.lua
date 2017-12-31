local _, ns = ...

local colors = ns.colors

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
	health:SetHeight((unit == 'player' or unit == 'target') and 30 or 15)
	health:SetPoint('TOPLEFT', 5, -5)
	health:SetPoint('TOPRIGHT', -5, -5)
	health.colorTapping = true
	health.colorDisconnected = true
	health.colorSmooth = true
	health.frequentUpdates = true

	local bg = health:CreateTexture(nil, 'BACKGROUND')
	bg:SetTexture(ns.assets.TEXTURE)
	bg:SetVertexColor(0.15, 0.15, 0.15)
	bg:SetAllPoints()

	health.UpdateColor = UpdateHealthColor
	self.Health = health
end
