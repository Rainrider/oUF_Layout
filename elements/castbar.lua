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

local function PostCastFailedOrInterrupted(castbar, unit, name, castID)
	castbar:SetStatusBarColor(0.69, 0.31, 0.31)
	castbar:SetValue(castbar.max)

	local time = castbar.Time
	if(time) then
		time:SetText(name)
	end
end

local function PostUpdateCast(castbar, unit, name)
	if(castbar.notInterruptible and UnitCanAttack('player', unit)) then
		castbar:SetStatusBarColor(0.69, 0.31, 0.31)
	else
		castbar:SetStatusBarColor(0.55, 0.57, 0.61)
	end
end

function ns.AddCastBar(self, unit)
	local castbar = CreateFrame('StatusBar', nil, self.Portrait)
	castbar:SetStatusBarTexture(ns.assets.TEXTURE)
	castbar:SetStatusBarColor(0.55, 0.57, 0.61)
	castbar:SetAlpha(0.75)
	castbar:SetAllPoints(self.Overlay)

	if(unit == 'player') then
		local safeZone = castbar:CreateTexture(nil, 'OVERLAY')
		safeZone:SetTexture(ns.assets.TEXTURE)
		safeZone:SetVertexColor(0.69, 0.31, 0.31)
		castbar.SafeZone = safeZone
	end

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

	castbar.timeToHold = 1
	castbar.PostCastStart = PostUpdateCast
	castbar.PostChannelStart = PostUpdateCast
	castbar.PostCastInterruptible = PostUpdateCast
	castbar.PostCastNotInterruptible = PostUpdateCast
	castbar.PostCastFailed = PostCastFailedOrInterrupted
	castbar.PostCastInterrupted = PostCastFailedOrInterrupted

	self.Castbar = castbar
end
