local _, ns = ...

function ns.AddStagger(self)
	local stagger = CreateFrame('StatusBar', nil, self.Overlay)
	stagger:SetPoint('LEFT')
	stagger:SetPoint('RIGHT')
	stagger:SetPoint('BOTTOM', self.Overlay, 'TOP', 0, 0)
	stagger:SetHeight(3)
	stagger:SetStatusBarTexture(ns.assets.TEXTURE)

	self.Stagger = stagger
end