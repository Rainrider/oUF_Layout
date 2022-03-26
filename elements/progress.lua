local _, ns = ...

function ns.AddProgress(self)
	if (not IsAddOnLoaded('oUF_Progress')) then return end

	local progress = CreateFrame('StatusBar', nil, self)
	progress:SetPoint('TOPLEFT', self.Power, 'BOTTOMLEFT', 0, -2.5)
	progress:SetPoint('TOPRIGHT', self.Power, 'BOTTOMRIGHT', 0, -2.5)
	progress:SetHeight(5)
	progress:SetStatusBarTexture(ns.assets.TEXTURE)

	progress.outAlpha = 1
	progress:EnableMouse(true)

	local bg = progress:CreateTexture(nil, 'BACKGROUND')
	bg:SetTexture(ns.assets.TEXTURE)
	bg:SetVertexColor(0, 0, 0)
	bg:SetAllPoints()

	local infoText = progress:CreateFontString(nil, 'OVERLAY', 'LayoutFont_Shadow_Small')
	infoText:SetPoint('CENTER')
	progress.infoText = infoText

	self.Progress = progress
end
