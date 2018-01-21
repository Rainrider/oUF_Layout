local _, ns = ...

local function PostUpdateRune(_, rune, _, _, _, isReady)
	if (isReady) then
		rune:SetAlpha(1)
	else
		rune:SetAlpha(0.5)
	end
end

function ns.AddRunes(self, width, height, spacing)
	local runes = {}
	local maxRunes = 6

	width = (width - (maxRunes + 1) * spacing) / maxRunes
	spacing = width + spacing

	for i = 1, maxRunes do
		local rune = CreateFrame('StatusBar', nil, self.Overlay)
		rune:SetSize(width, height)
		rune:SetPoint('BOTTOMLEFT', (i - 1) * spacing + 1, 0)
		rune:SetStatusBarTexture(ns.assets.TEXTURE)

		local bg = rune:CreateTexture(nil, 'BACKGROUND')
		bg:SetTexture(ns.assets.TEXTURE)
		bg:SetAllPoints()
		bg.multiplier = 1/3

		rune.bg = bg
		runes[i] = rune
	end

	runes.colorSpec = true
	runes.PostUpdate = PostUpdateRune
	self.Runes = runes
end
