-- This file contains custom methods for the Player metatable (or 'class')
local meta = FindMetaTable("Player")
if not meta then return end
function meta:SetupDataTables()
  self:NetworkVar("String", 0, "CurrClass")
end

function meta:GetPlayerClass()
  self:SetCurrClass("mage")
  return self:GetCurrClass()
end