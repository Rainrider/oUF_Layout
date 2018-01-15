local _, ns = ...

local function ShortenValue(value)
	if(value >= 1e9) then
		return format('%.2fb', value / 1e9)
	elseif(value >= 1e6) then
		return format('%.2fm', value / 1e6)
	elseif(value >= 1e4) then
		return format('%.2fk', value / 1e3)
	else
		return value
	end
end

local function ShowArtifactPowerText(ap)
	ap.text:SetText(ShortenValue(ap.powerForNextTrait - ap.power))
end

local function PostUpdateArtifactPower(ap)
	-- hook OnEnter here or else oUF_Artifact won't set it
	ap:HookScript('OnEnter', ShowArtifactPowerText)
	ap.PostUpdate = nil
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
