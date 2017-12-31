local _, ns = ...

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

	local text = castbar:CreateFontString(nil, 'OVERLAY', 'LayoutFont_Shadow')
	text:SetPoint('LEFT', 3.5, 3)
	text:SetPoint('RIGHT', time, 'LEFT', -3.5, 0)
	text:SetTextColor(0.84, 0.75, 0.65)
	text:SetJustifyH('LEFT')
	text:SetWordWrap(false)
	castbar.Text = text

	self.Castbar = castbar
end
