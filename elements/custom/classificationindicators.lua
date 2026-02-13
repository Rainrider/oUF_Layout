local _, ns = ...
local oUF = ns.oUF or oUF

local function Update(self, _, unit)
    local element, condition = self.ClassificationIndicators

    local classification = UnitClassification(unit)
    if element.BossIndicator then
        condition = classification == 'worldboss' or UnitIsBossMob(unit)
        element.BossIndicator:SetAlphaFromBoolean(condition, 1, 0)
    end

    if element.EliteIndicator then
        condition = not condition and (classification == 'elite' or classification == 'rareelite')
        element.EliteIndicator:SetAlphaFromBoolean(condition, 1, 0)
    end

    if element.RareIndicator then
        condition = classification == 'rare' or classification == 'rareelite'
        element.RareIndicator:SetAlphaFromBoolean(condition, 1, 0)
    end

    if element.MinionIndicator then
        condition = classification == 'minus' or classification == 'trivial'
        element.MinionIndicator:SetAlphaFromBoolean(condition, 1, 0)
    end
end

local function ForceUpdate(element)
    Update(element.__owner, 'ForceUpdate', element.__owner.unit)
end

local function Enable(self)
    local element = self.ClassificationIndicators

    if not element then
        return
    end

    element.__owner = self
    element.ForceUpdate = ForceUpdate

    self:RegisterEvent('UNIT_CLASSIFICATION_CHANGED', Update)

    return true
end

local function Disable(self)
    local element = self.ClassificationIndicators

    if element then
        self:UnregisterEvent('UNIT_CLASSIFICATION_CHANGED', Update)

        if element.BossIndicator then
            element.BossIndicator:SetAlpha(0)
        end

        if element.EliteIndicator then
            element.EliteIndicator:SetAlpha(0)
        end

        if element.RareIndicator then
            element.RareIndicator:SetAlpha(0)
        end

        if element.MinionIndicator then
            element.MinionIndicator:SetAlpha(0)
        end
    end
end

oUF:AddElement('ClassificationIndicators', Update, Enable, Disable)