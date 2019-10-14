local _, ns = ...
local priorities = ns.playerClass == 'SHAMAN' and _G.SHAMAN_TOTEM_PRIORITIES or _G.STANDARD_TOTEM_PRIORITIES

local function UpdateTooltip(totem)
	local timeLeft = totem.timeLeft - totem.duration
	local fmt, value = SecondsToTimeAbbrev(timeLeft)
	local period = fmt:match('.$')
	local time

	if (period == 'm') then
		time = SPELL_TIME_REMAINING_MIN:format(value)
	else
		time = SPELL_TIME_REMAINING_SEC:format(timeLeft)
	end

	GameTooltip:SetText(totem.name)
	GameTooltip:AddLine(time, 1, 1, 1)
	GameTooltip:Show()
end

local function OnEnter(totem)
	if (not totem:IsVisible()) then return end

	totem.icon:Show()
	totem.overlay:Show()
	GameTooltip:SetOwner(totem, 'ANCHOR_BOTTOMRIGHT')
	totem:UpdateTooltip()
end

local function OnLeave(totem)
	totem.icon:Hide()
	totem.overlay:Hide()
	GameTooltip:Hide()
end

local function OnUpdate(totem, elapsed)
	local timeLeft = totem.timeLeft - elapsed
	if (timeLeft > totem.duration) then
		totem:SetValue(timeLeft)
		totem.timeLeft = timeLeft
	end
end

local function UpdateTotem(self, event, slot)
	local totem = self.CustomTotems[priorities[slot]]
	local _, name, start, duration, icon = GetTotemInfo(slot)

	if (duration > 0) then
		totem.icon:SetTexture(icon)
		totem:SetMinMaxValues(-duration, 0)
		totem.timeLeft = start - GetTime()
		totem.duration = -duration
		totem.name = name
		totem:Show()
	else
		totem:Hide()
	end
end

local function Update(self, event, slot)
	if (tonumber(slot)) then
		UpdateTotem(self, event, slot)
	else
		for slot = 1, #self.CustomTotems do
			UpdateTotem(self, event, slot)
		end
	end
end

local function ForceUpdate(element)
	return Update(element.__owner, 'ForceUpdate')
end

local function Enable(self)
	local totems = self.CustomTotems
	if (not totems) then return end

	totems.__owner = self
	totems.ForceUpdate = ForceUpdate

	for slot = 1, #totems do
		local totem = totems[priorities[slot]]
		totem:SetScript('OnUpdate', totems.OnUpdate or OnUpdate)
		if (totem:IsMouseEnabled()) then
			totem:SetScript('OnEnter', totems.OnEnter or OnEnter)
			totem:SetScript('OnLeave', totems.OnLeave or OnLeave)
			totem.UpdateTooltip = totems.UpdateTooltip or UpdateTooltip
		end
	end

	self:RegisterEvent('PLAYER_TOTEM_UPDATE', Update, true)

	return true
end

local function Disable(self)
	local totems = self.CustomTotems
	if (not totems) then return end

	for slot = 1, #totems do
		totems[slot]:Hide()
	end

	self:UnregisterEvent('PLAYER_TOTEM_UPDATE', Update)
end

oUF:AddElement('CustomTotems', Update, Enable, Disable)
