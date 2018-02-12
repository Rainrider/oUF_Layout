local _, ns = ...

local function OnShow(altpower)
	local experience = altpower.__owner.Experience --_G.oUF_Layout_Experience
	if (experience) then
		experience:Hide()
		experience.Show = experience.Hide
	end
end

local function OnHide(altpower)
	local experience = altpower.__owner.Experience -- _G.oUF_Layout_Experience
	if (experience) then
		experience.Show = nil
		experience:ForceUpdate('AltPower OnHide')
	end
end

local function OnEnter(altpower)
	if (not altpower:IsVisible()) then return end

	GameTooltip:SetOwner(altpower, 'ANCHOR_BOTTOMRIGHT')
	altpower:UpdateTooltip()
end

local function UpdateTooltip(altpower)
	local value = altpower:GetValue()
	local min, max = altpower:GetMinMaxValues()
	GameTooltip:SetText(altpower.powerName, 1, 1, 1)
	GameTooltip:AddLine(altpower.powerTooltip, nil, nil, nil, true)
	GameTooltip:AddLine(format('\n%d (%d%%)', value, (value - min) / (max - min) * 100), 1, 1, 1)
	GameTooltip:Show()
end

function ns.AddAlternativePower(self)
	local altpower = CreateFrame('StatusBar', nil, self)
	altpower:SetPoint('TOPLEFT', _G.oUF_Layout_SingleUnitsPlayer.Power, 'BOTTOMLEFT', 0, -1)
	altpower:SetPoint('TOPRIGHT', _G.oUF_Layout_SingleUnitsPlayer.Power, 'BOTTOMRIGHT', 0, -1)
	altpower:SetHeight(3)
	altpower:SetStatusBarTexture(ns.assets.TEXTURE)
	altpower:SetStatusBarColor(0, 0.5, 1)
	altpower:EnableMouse(true)
	altpower.UpdateTooltip = UpdateTooltip
	altpower:SetScript('OnEnter', OnEnter)

	local bg = altpower:CreateTexture(nil, 'BACKGROUND')
	bg:SetTexture(ns.assets.TEXTURE)
	bg:SetVertexColor(0, 0, 0)
	bg:SetAllPoints()

	altpower:SetScript('OnShow', OnShow)
	altpower:SetScript('OnHide', OnHide)

	self.AlternativePower = altpower
end
