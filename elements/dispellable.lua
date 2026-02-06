local _, ns = ...

function ns.AddDispel(self, unit)
	if not C_AddOns.IsAddOnLoaded('oUF_Dispellable') then
		return
	end

	local dispellable = {}

	local texture = self.Health:CreateTexture(nil, 'OVERLAY')
	texture:SetTexture(ns.assets.HIGHLIGHT)
	texture:SetBlendMode('ADD')
	texture:SetAllPoints()
	dispellable.dispelTexture = texture

	if unit == 'target' then
		local button = CreateFrame('Button', 'oUF_Layout_DispelButton', self.Overlay)
		button:SetPoint('CENTER')
		button:SetSize(22, 22)
		button:SetToplevel(true)

		local icon = button:CreateTexture(nil, 'ARTWORK')
		icon:SetAllPoints()
		icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
		button.icon = icon

		local cd = CreateFrame('Cooldown', '$parentCooldown', button, 'CooldownFrameTemplate')
		cd:SetUseAuraDisplayTime(true)
		cd:SetDrawEdge(false)
		cd:SetDrawSwipe(false)
		cd:SetCountdownFont('LayoutFont_Bold_Small_Outline')
		cd:SetAllPoints()
		button.cd = cd

		local timerText = cd:GetRegions()
		timerText:ClearAllPoints()
		timerText:SetPoint('TOPLEFT', 0, 0)

		local overlay = button:CreateTexture(nil, 'OVERLAY')
		overlay:SetTexture(ns.assets.BUTTONOVERLAY)
		overlay:SetPoint('TOPLEFT', -5, 5)
		overlay:SetPoint('BOTTOMRIGHT', 5, -5)
		button.overlay = overlay

		local count = button:CreateFontString(nil, 'OVERLAY', 'LayoutFont_Shadow_Small', 1)
		count:SetPoint('BOTTOMRIGHT', -1, 1)
		button.count = count

		dispellable.dispelIcon = button
	end

	self.Dispellable = dispellable
end
