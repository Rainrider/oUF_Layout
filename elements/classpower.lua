local _, ns = ...

local playerClass = ns.playerClass

local function PostUpdateClassPower(classPower, power, maxPower, maxPowerChanged)
	if(not maxPower or not maxPowerChanged) then return end

	local maxIndex = maxPower ~= 10 and maxPower or 5
	local height = classPower.height
	local spacing = classPower.spacing
	local width = (classPower.width - (maxIndex + 1) * spacing) / maxIndex
	spacing = width + spacing

	for i = 1, maxPower do
		classPower[i]:SetSize(width, height)
		classPower[i]:SetPoint('BOTTOMLEFT', ((i - 1) % maxIndex) * spacing + 1, 1)
	end
end

local function UpdateClassPowerColor(classPower, powerType)
	local color = classPower.__owner.colors.power[powerType]
	local r, g, b = color[1], color[2], color[3]

	local isAnticipationRogue = playerClass == 'ROGUE' and UnitPowerMax('player', SPELL_POWER_COMBO_POINTS) == 10

	for i = 1, #classPower do
		if(i > 5 and isAnticipationRogue) then
			r, g, b = 1, 0, 0
		end

		local bar = classPower[i]
		bar:SetStatusBarColor(r, g, b)

		local bg = bar.bg
		if(bg) then
			local mu = bg.multiplier or 1
			bg:SetVertexColor(r * mu, g * mu, b * mu)
		end
	end
end

function ns.AddClassPower(self, width, height, spacing)
	local classPower = {}

	classPower.width = width
	classPower.height = height
	classPower.spacing = spacing

	-- rogues with the anticipation talent have max 10 combo points
	-- create one extra to force __max to be different from UnitPowerMax
	-- needed for sizing and positioning in PostUpdate
	local maxPower = 11

	for i = 1, maxPower do
		local bar = CreateFrame('StatusBar', nil, self.Overlay)
		bar:SetStatusBarTexture(ns.assets.TEXTURE)

		-- 6-10 will be stacked on top of 1-5 for rogues with the anticipation talent
		if(i > 5) then
			bar:SetFrameLevel(bar:GetFrameLevel() + 1)
		end

		local bg = bar:CreateTexture(nil, 'BACKGROUND')
		bg:SetTexture(ns.assets.TEXTURE)
		bg:SetAllPoints()
		bg.multiplier = 0.5
		bar.bg = bg

		classPower[i] = bar
	end

	classPower.PostUpdate = PostUpdateClassPower
	classPower.UpdateColor = UpdateClassPowerColor

	self.ClassPower = classPower
end
