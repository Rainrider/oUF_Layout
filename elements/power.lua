local _, ns = ...

local function UpdateColor(power, unit)
	local r, g, b, t
	if (power.colorTapping and power.tapped) then
		t = ns.colors.tapped
	elseif (power.colorDisconnected and power.disconnected) then
		t = ns.colors.disconnected
	elseif (power.colorPower) then
		local ptype, ptoken, altR, altG, altB = UnitPowerType(unit)
		t = ns.colors.power[ptoken]

		if (not t) then
			if (altR) then
				-- BUG: As of 7.0.3, altR, altG, altB may be in 0-1 or 0-255 range.
				if (altR > 1 or altG > 1 or altB > 1) then
					altR, altG, altB = altR / 255, altG / 255, altB / 255
				end
				r, g, b = altR, altG, altB
			else
				t = ns.colors.power[ptype]
			end
		end
	elseif (power.colorClass and UnitIsPlayer(unit)) then
		local _, class = UnitClass(unit)
		t = ns.colors.class[class]
	elseif (power.colorReaction and UnitReaction(unit, 'player')) then
		t = ns.colors.reaction[UnitReaction(unit, 'player')]
	end

	if (t) then
		r, g, b = t[1], t[2], t[3]
	end

	if (b) then
		power:SetStatusBarColor(r, g, b)
		local bg = power.bg
		if (bg) then
			local mu = bg.multiplier or 1
			bg:SetVertexColor(r * mu, g * mu, b * mu)
		end
	end
end

function ns.AddPowerBar(self, unit)
	local power = CreateFrame('StatusBar', nil, self)
	power:SetStatusBarTexture(ns.assets.TEXTURE)
	power:SetHeight((unit == 'player' or unit == 'target') and 15 or 5)
	power:SetPoint('BOTTOMLEFT', 5, 5)
	power:SetPoint('BOTTOMRIGHT', -5, 5)
	power.colorPower = unit == 'player' or unit == 'boss'
	power.colorClass = true
	power.colorReaction = true
	power.frequentUpdates = unit == 'player' or unit == 'target'

	local bg = power:CreateTexture(nil, 'BACKGROUND')
	bg:SetTexture(ns.assets.TEXTURE)
	bg:SetAllPoints()
	bg.multiplier = 1/3
	power.bg = bg

	power.UpdateColor = UpdateColor
	self.Power = power
end
