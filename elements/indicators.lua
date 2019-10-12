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
