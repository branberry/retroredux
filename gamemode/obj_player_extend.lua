-- This file contains custom methods for the Player metatable (or 'class')
local meta = FindMetaTable('Player')
if not meta then return end
function meta:SetPlayerClass(className)
  self:SetNWString('PlayerClass', className)
end

function meta:GetPlayerClass()
  if not self then return end
  return self:GetNWString('PlayerClass')
end

function meta:SetMana(mana)
  self:SetNWInt('Mana', mana)
end

function meta:GetMana()
  return self:GetNWInt('Mana', 0)
end

function meta:SetMaxMana(maxMana)
  self:SetNWInt('MaxMana', maxMana)
end

function meta:GetMaxMana()
  return self:GetNWInt('MaxMana', 0)
end