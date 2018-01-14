local _, ns = ...

local floor = math.floor
local format = string.format

local function FormatTime(seconds)
	local day, hour, minute = 86400, 3600, 60
	if (seconds >= day) then
		return format('%dd', floor(seconds/day + 0.5))
	elseif (seconds >= hour) then
		return format('%dh', floor(seconds/hour + 0.5))
	elseif (seconds >= minute) then
		return format('%dm', floor(seconds/minute + 0.5))
	else
		return format('%d', seconds)
	end
end

local function UpdateTimer(button, elapsed)
	local timeLeft = button.timeLeft - elapsed
	button.timer:SetText((timeLeft > 0) and FormatTime(timeLeft))
	button.timeLeft = timeLeft
end

local function PostUpdateDispel(dispel, _, _, _, duration, expiration)
	local button = dispel.dispelIcon
	if (duration and duration > 0) then
		button.timeLeft = expiration - GetTime()
		button:SetScript('OnUpdate', UpdateTimer)
	else
		button:SetScript('OnUpdate', nil)
		button.timer:SetText()
	end
end

function ns.AddDispel(self, unit)
	if (not IsAddOnLoaded('oUF_Dispelable')) then return end

	local dispelable = {}

	local texture = self.Health:CreateTexture(nil, 'OVERLAY')
	texture:SetTexture(ns.assets.HIGHLIGHT)
	texture:SetBlendMode('ADD')
	texture:SetAllPoints()
	dispelable.dispelTexture = texture

	if (unit == 'target') then
		local button = CreateFrame('Button', 'oUF_Layout_DispelButton', self.Overlay)
		button:SetPoint('CENTER')
		button:SetSize(22, 22)
		button:SetToplevel(true)
		dispelable.dispelIcon = button

		local icon = button:CreateTexture(nil, 'ARTWORK')
		icon:SetAllPoints()
		icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
		button.icon = icon

		local overlay = button:CreateTexture(nil, 'OVERLAY')
		overlay:SetTexture(ns.assets.BUTTONOVERLAY)
		overlay:SetPoint('TOPLEFT', -5, 5)
		overlay:SetPoint('BOTTOMRIGHT', 5, -5)
		button.overlay = overlay

		local timer = button:CreateFontString(nil, 'OVERLAY', 'LayoutFont_Shadow_Small', 1)
		timer:SetPoint('TOPLEFT', 1, 1)
		button.timer = timer

		local count = button:CreateFontString(nil, 'OVERLAY', 'LayoutFont_Shadow_Small', 1)
		count:SetPoint('BOTTOMRIGHT', -1, 1)
		button.count = count

		dispelable.PostUpdate = PostUpdateDispel
	end

	self.Dispelable = dispelable
end
