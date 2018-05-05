local _, ns = ...

local function PostUpdateArtifactPower(ap, event, current, max)
	if (current and max) then
		local traits = ap.numTraitsLearnable
		local prefix = traits and traits > 0 and traits .. ' / ' or ''
		ap.text:SetText(prefix .. ns.ShortenValue(max - current))
	end
end

function ns.AddArtifactPower(self)
	if (not IsAddOnLoaded('oUF_ArtifactPower')) then return end

	local ap = CreateFrame('StatusBar', nil, self)
	ap:SetPoint('BOTTOMLEFT', self.Health, 'TOPLEFT', 0, 2.5)
	ap:SetPoint('BOTTOMRIGHT', self.Health, 'TOP', -2.5, 2.5)
	ap:SetHeight(5)
	ap:SetStatusBarTexture(ns.assets.TEXTURE)

	ap.offAlpha = 0
	ap.tooltipAnchor = 'ANCHOR_TOPRIGHT'
	ap:EnableMouse(true)

	local bg = ap:CreateTexture(nil, 'BACKGROUND')
	bg:SetTexture(ns.assets.TEXTURE)
	bg:SetVertexColor(0, 0, 0)
	bg:SetAllPoints()

	local text = ap:CreateFontString(nil, 'OVERLAY', 'LayoutFont_Bold_Small_Outline')
	text:SetPoint('CENTER')
	ap.text = text

	ap.PostUpdate = PostUpdateArtifactPower
	self.ArtifactPower = ap
end
