local _, ns = ...

local function OnShow(altpower)
	local progress = altpower.__owner.Progress
	if progress then
		progress:Hide()
		progress.Show = progress.Hide
	end
end

local function OnHide(altpower)
	local progress = altpower.__owner.Progress
	if progress and progress.ForceUpdate then
		progress.Show = nil
		progress:ForceUpdate()
	end
end

local function OnEnter(altpower)
	if not altpower:IsVisible() then
		return
	end

	GameTooltip:SetOwner(altpower, 'ANCHOR_BOTTOMRIGHT')
	altpower:UpdateTooltip()
end

local function UpdateTooltip(altpower)
	local value = altpower:GetValue()
	local min, max = altpower:GetMinMaxValues()
	local name, tooltip = GetUnitPowerBarStringsByID(altpower.__barID)
	GameTooltip:SetText(name, 1, 1, 1)
	GameTooltip:AddLine(tooltip, nil, nil, nil, true)
	GameTooltip:AddLine(string.format('\n%d (%d%%)', value, (value - min) / (max - min) * 100), 1, 1, 1)
	GameTooltip:Show()
end

function ns.AddAlternativePower(self, unit)
	local anchor = ((unit == 'player' or unit == 'pet') and ns.player or self).Power
	local altpower = CreateFrame('StatusBar', nil, self)
	altpower:SetPoint('TOPLEFT', anchor, 'BOTTOMLEFT', 0, -1)
	altpower:SetPoint('TOPRIGHT', anchor, 'BOTTOMRIGHT', 0, -1)
	altpower:SetHeight(3)
	altpower:SetStatusBarTexture(ns.assets.TEXTURE)
	altpower:SetStatusBarColor(self.colors.power.ALTERNATE:GetRGB())
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
