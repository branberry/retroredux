-- This file contains custom methods for the Player metatable (or 'class')
local meta = FindMetaTable('Player')
if not meta then return end
if SERVER then util.AddNetworkString('regen_mana') end
function meta:SetPlayerClass(className)
  self:SetNWString('PlayerClass', className)
end

function meta:GetPlayerClass()
  return self:GetNWString('PlayerClass')
end

function meta:SetMana(mana)
  self:SetNWInt('Mana', mana)
end

function meta:GetMana()
  local updatedMana = self:GetNWInt('Mana')
  local ct = CurTime()
  if not self.ManaRegenTime then self.ManaRegenTime = ct + 5 end
  if self.ManaRegenTime < ct then
    self.ManaRegenTime = ct + 5
    updatedMana = math.Clamp(updatedMana + self:GetManaRegeneration(), 0, self:GetMaxMana())
    print('manaregenTime', self.ManaRegenTime)
    print('curTime', ct)
    print('regen mana size', self:GetManaRegeneration())
    -- we want to send an update to the server
    -- so that the updated value sticks
    if CLIENT then
      net.Start('regen_mana')
      print(updatedMana)
      net.WriteUInt(updatedMana, 9)
      net.SendToServer()
      return self:GetNWInt('Mana')
    end
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

net.Receive('regen_mana', function(len, ply)
  local mana = net.ReadUInt(9)
  ply:SetMana(mana)
end)

function meta:GetStatus(type)
  local ent = self["status_" .. type]
  if ent and ent:IsValid() and ent:GetOwner() == self then return ent end
end

function meta:GiveStatus(Name, Effector, Args)
  local ent = ents.Create("status_" .. Name)
  local existingEnt = self:GetStatus(Name)
  if ent:IsValid() then
    ent:Spawn()
    if Effector then ent:setEffector(Effector) end
    if existingEnt and existingEnt:IsValid() then
      ent:SetPlayer(self, true)
    else
      ent:SetPlayer(self, false)
    end
  end
end

function meta:TakeSpecialDamage(amount, type, attacker, inflictor, damageForce)
  local d = DamageInfo()
  d:SetDamage(amount)
  if type then d:SetDamageType(type) end
  d:SetInflictor(inflictor)
  if attacker and attacker:IsValid() then
    d:SetAttacker(attacker)
  else
    d:SetAttacker(self)
  end

  local d = DamageInfo()
  d:SetDamage(amount)
  d:SetDamageType(type)
  d:SetInflictor(inflictor)
  if attacker then
    d:SetAttacker(attacker)
  else
    d:SetAttacker(self)
  end

  local d = DamageInfo()
  d:SetDamage(amount)
  d:SetDamageType(type)
  d:SetInflictor(inflictor)
  if attacker then
    d:SetAttacker(attacker)
  else
    d:SetAttacker(self)
  end

  if damageForce then d:SetDamageForce(damageForce) end
  self:TakeDamageInfo(d)
end