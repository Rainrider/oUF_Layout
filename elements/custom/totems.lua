local function UpdateTooltip(totem)
	GameTooltip:SetTotem(totem:GetID())
end

local function OnEnter(totem)
	if not totem:IsVisible() then
		return
	end

	totem.Icon:Show()
	GameTooltip:SetOwner(totem, 'ANCHOR_BOTTOMRIGHT')
	totem:UpdateTooltip()
end

local function OnLeave(totem)
	totem.Icon:Hide()
	GameTooltip:Hide()
end

local function UpdateTotem(self, event, slot)
	local totem = self.CustomTotems[slot]
	local hasTotem, _, _, _, icon = GetTotemInfo(slot)
	local duration = GetTotemDuration(slot)

	totem:SetAlphaFromBoolean(hasTotem, 1, 0)

	if duration then
		totem:SetTimerDuration(
			duration,
			Enum.StatusBarInterpolation.Immediate,
			Enum.StatusBarTimerDirection.RemainingTime
		)
		totem.Icon.Texture:SetTexture(icon)
	end
end

local function Update(self, event, slot)
	if tonumber(slot) then
		UpdateTotem(self, event, slot)
	else
		for slot_ = 1, #self.CustomTotems do
			UpdateTotem(self, event, slot_)
		end
	end
end

local function ForceUpdate(element)
	return Update(element.__owner, 'ForceUpdate')
end

local function Enable(self)
	local totems = self.CustomTotems
	if not totems then
		return
	end

	totems.__owner = self
	totems.ForceUpdate = ForceUpdate

	for slot = 1, #totems do
		local totem = totems[slot]
		totem:SetID(slot)

		if totem:IsMouseEnabled() then
			totem:SetScript('OnEnter', totems.OnEnter or OnEnter)
			totem:SetScript('OnLeave', totems.OnLeave or OnLeave)
			totem.UpdateTooltip = totems.UpdateTooltip or UpdateTooltip
		end

		totem:Show()
	end

	self:RegisterEvent('PLAYER_TOTEM_UPDATE', Update, true)

	TotemFrame:UnregisterEvent('PLAYER_ENTERING_WORLD')
	TotemFrame:UnregisterEvent('PLAYER_TALENT_UPDATE')
	TotemFrame:UnregisterEvent('PLAYER_TOTEM_UPDATE')
	TotemFrame:UnregisterEvent('UPDATE_SHAPESHIFT_FORM')

	return true
end

local function Disable(self)
	local totems = self.CustomTotems
	if not totems then
		return
	end

	for slot = 1, #totems do
		totems[slot]:Hide()
	end

	self:UnregisterEvent('PLAYER_TOTEM_UPDATE', Update)

	TotemFrame:RegisterEvent('PLAYER_ENTERING_WORLD')
	TotemFrame:RegisterEvent('PLAYER_TALENT_UPDATE')
	TotemFrame:RegisterEvent('PLAYER_TOTEM_UPDATE')
	TotemFrame:RegisterEvent('UPDATE_SHAPESHIFT_FORM')
end

oUF:AddElement('CustomTotems', Update, Enable, Disable)
