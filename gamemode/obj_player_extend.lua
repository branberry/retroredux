-- This file contains custom methods for the Player metatable (or 'class')
local meta = FindMetaTable('Player')
if not meta then return end
function meta:SetPlayerClass(className)
  self:SetNWString('PlayerClass', className)
end

function meta:GetPlayerClass()
  return self:GetNWString('PlayerClass')
end

function meta:SetMana(mana)
  self.PreviousMana = mana
  self:SetNWInt('Mana', mana)
end

function meta:GetMana()
  local ct = CurTime()
  if not self.RegenTime then self.RegenTime = ct + 2 end
  if self.RegenTime < CurTime() then
    self.RegenTime = CurTime() + 2
    self.PreviousMana = self.PreviousMana + self:GetManaRegeneration()
    print(self.PreviousMana)
    if self.PreviousMana >= self:GetMaxMana() then
      self.PreviousMana = self:GetMaxMana()
      return self.PreviousMana
    end
    return self.PreviousMana
  end
  return self:GetNWInt('Mana')
end

function meta:SetMaxMana(maxMana)
  self:SetNWInt('MaxMana', maxMana)
end

function meta:GetMaxMana()
  return self:GetNWInt('MaxMana', 0)
end

function meta:SetManaRegeneration(manaRegen)
  self:SetNWInt('ManaRegeneration', manaRegen)
end

function meta:GetManaRegeneration()
  return self:GetNWInt('ManaRegeneration', 0)
end