local _, ns = ...

local function CustomCastDelayText(castbar, duration)
	castbar.Time:SetFormattedText('%.1f |cffaf5050%s %.1f|r',
		castbar.channeling and duration or castbar.max - duration,
		castbar.channeling and "- " or "+",
		castbar.delay
	)
end

local function CustomCastTimeText(castbar, duration)
	castbar.Time:SetFormattedText('%.1f / %.2f',
		castbar.channeling and duration or castbar.max - duration,
		castbar.max
	)
end

local function PostCastFailedOrInterrupted(castbar, unit)
	castbar:SetStatusBarColor(0.69, 0.31, 0.31)
	castbar:SetValue(castbar.max)

	local time = castbar.Time
	if(time) then
		time:SetText(castbar.name)
	end
end

local function PostUpdateCast(castbar, unit, name)
	-- only Post*Start have name information
	if (name) then
		castbar.name = name
	end

	if(castbar.notInterruptible and UnitCanAttack('player', unit)) then
		castbar:SetStatusBarColor(0.69, 0.31, 0.31)
	else
		castbar:SetStatusBarColor(0.55, 0.57, 0.61)
	end
end

function ns.AddCastBar(self, unit)
	if (unit ~= 'player' and unit ~= 'pet') then return end

	local parent = unit == 'player' and self.Portrait or self.Power
	local castbar = CreateFrame('StatusBar', nil, parent)
	castbar:SetStatusBarTexture(ns.assets.TEXTURE)
	castbar:SetStatusBarColor(0.55, 0.57, 0.61)
	castbar:SetAlpha(0.75)
	castbar:SetAllPoints(parent == self.Portrait and self.Overlay or self.Power)

	if(unit == 'player') then
		local safeZone = castbar:CreateTexture(nil, 'OVERLAY')
		safeZone:SetTexture(ns.assets.TEXTURE)
		safeZone:SetVertexColor(0.69, 0.31, 0.31)
		castbar.SafeZone = safeZone

		local time = castbar:CreateFontString(nil, 'OVERLAY', 'LayoutFont_Shadow')
		time:SetPoint('RIGHT', -3.5, 3)
		time:SetTextColor(0.84, 0.75, 0.65)
		time:SetJustifyH('RIGHT')
		castbar.Time = time

		castbar.CustomTimeText = CustomCastTimeText
		castbar.CustomDelayText = CustomCastDelayText

		local text = castbar:CreateFontString(nil, 'OVERLAY', 'LayoutFont_Shadow')
		text:SetPoint('LEFT', 3.5, 3)
		text:SetPoint('RIGHT', time, 'LEFT', -3.5, 0)
		text:SetTextColor(0.84, 0.75, 0.65)
		text:SetJustifyH('LEFT')
		text:SetWordWrap(false)
		castbar.Text = text
	end

	local icon = castbar:CreateTexture(nil, 'ARTWORK')
	icon:SetSize(25, 25)
	icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
	if (unit == 'player') then
		icon:SetPoint('LEFT', castbar, 'RIGHT', 15, 0)
	else
		icon:SetPoint('LEFT', self, 'RIGHT', 3.5, 0)
	end

	local iconOverlay = castbar:CreateTexture(nil, 'OVERLAY')
	iconOverlay:SetTexture(ns.assets.BUTTONOVERLAY)
	iconOverlay:SetVertexColor(0.84, 0.75, 0.65)
	iconOverlay:SetPoint('TOPLEFT', icon, -5, 5)
	iconOverlay:SetPoint('BOTTOMRIGHT', icon, 5, -5)

	castbar.Icon = icon

	castbar.timeToHold = 1
	castbar.PostCastStart = PostUpdateCast
	castbar.PostChannelStart = PostUpdateCast
	castbar.PostCastFailed = PostCastFailedOrInterrupted
	castbar.PostCastInterrupted = PostCastFailedOrInterrupted

	self.Castbar = castbar
end
