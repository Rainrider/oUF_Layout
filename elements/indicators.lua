local _, ns = ...

function ns.AddCombatIndicator(self)
	local combat = self.Health:CreateTexture(nil, 'OVERLAY')
	combat:SetSize(18, 18)
	combat:SetPoint('TOP')

	self.CombatIndicator = combat
end

function ns.AddPhaseIndicator(self)
	local phase = self:CreateTexture(nil, 'OVERLAY')
	phase:SetSize(18, 18)
	phase:SetPoint('TOPRIGHT', 7, 7)

	self.PhaseIndicator = phase
end

function ns.AddQuestIndicator(self)
	local quest = self.Overlay:CreateTexture(nil, 'OVERLAY')
	quest:SetSize(16, 16)
	quest:SetPoint('RIGHT', 8, 0)

	self.QuestIndicator = quest
end

local function UpdateThreat(self, event, unit)
	if(self.unit ~= unit) then return end

	local status = UnitThreatSituation(unit)
	if(status and status > 0) then
		local r, g, b = GetThreatStatusColor(status)
		self:SetBackdropBorderColor(r, g, b)
	else
		self:SetBackdropBorderColor(0, 0, 0)
	end
end

function ns.AddThreatIndicator(self)
	local threat = {}
	threat.IsObjectType = function() end
	threat.Override = UpdateThreat

	self.ThreatIndicator = threat
end
