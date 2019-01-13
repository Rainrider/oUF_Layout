local _, ns = ...

function ns.AddAssistantIndicator(self)
	local assistant = self:CreateTexture(nil, 'OVERLAY')
	assistant:SetSize(14, 14)
	assistant:SetPoint('BOTTOM', self.Health, 'TOPLEFT', 0, -3)

	self.AssistantIndicator = assistant
end

function ns.AddCombatIndicator(self)
	local combat = self.Health:CreateTexture(nil, 'OVERLAY')
	combat:SetSize(18, 18)
	combat:SetPoint('TOP')

	self.CombatIndicator = combat
end

function ns.AddLeaderIndicator(self)
	local leader = self:CreateTexture(nil, 'OVERLAY')
	leader:SetSize(14, 14)
	leader:SetPoint('BOTTOM', self.Health, 'TOPLEFT', 0, -3)

	self.LeaderIndicator = leader
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

function ns.AddRaidTargetIndicator(self)
	local raidIcon = self.Health:CreateTexture(nil, 'OVERLAY')
	raidIcon:SetTexture(ns.assets.RAIDICONS)
	raidIcon:SetSize(18, 18)
	raidIcon:SetPoint('CENTER', self.Health, 'TOP', 0, 0)
	self.RaidTargetIndicator = raidIcon
end

function ns.AddReadyCheckIndicator(self)
	local readyCheck = self.Health:CreateTexture(nil, 'OVERLAY')
	readyCheck:SetSize(16, 16)
	readyCheck:SetPoint('RIGHT', -5, 0)

	readyCheck.finishedTime = 5
	readyCheck.fadeTime = 3

	self.ReadyCheckIndicator = readyCheck
end

local function UpdateResurrectIndicator(self, _, unit)
	if (UnitHasIncomingResurrection(unit)) then
		self:SetBackdropBorderColor(0, 0.6, 0.8)
	else
		self:SetBackdropBorderColor(0, 0, 0)
	end
end

function ns.AddResurrectIndicator(self)
	self.ResurrectIndicator = {
		IsObjectType = function() end,
		Override = UpdateResurrectIndicator,
	}
end

local function UpdateRestingIndicator(self)
	if (IsResting()) then
		self.Overlay:SetBackdropBorderColor(0.98, 0.91, 0.62, 0.5)
	else
		self.Overlay:SetBackdropBorderColor(0, 0, 0, 0)
	end
end

function ns.AddRestingIndicator(self)
	self.RestingIndicator = {
		IsObjectType = function() end,
		Override = UpdateRestingIndicator,
	}
end

function ns.AddSummonIndicator(self)
	local indicator = self.Health:CreateTexture(nil, 'OVERLAY')
	indicator:SetSize(36, 36)
	indicator:SetPoint('CENTER', self, 'TOP')

	self.SummonIndicator = indicator
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
	self.ThreatIndicator = {
		IsObjectType = function() end,
		Override = UpdateThreat,
	}
end
