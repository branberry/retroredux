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