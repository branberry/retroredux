-- This file contains custom methods for the Player metatable (or 'class')
local meta = FindMetaTable('Player')
if not meta then return end
local PTeam = meta.Team

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

function meta:SetUpTable()
  self.RoundStats = {}
  self.SpellCooldowns = {}
  self.SpellsActive = {}
  self.SpellVars = {} -- Instead of doing table.Copy direclty on the spell table, We let spells define the variables that actually need to be per-instance.
  self.StatusEffects = {}  
end

function meta:GetMana()
  local updatedMana = self:GetNWInt('Mana')
  local ct = CurTime()
  if not self.ManaRegenTime then self.ManaRegenTime = ct + 5 end
  if self.ManaRegenTime < ct then
    self.ManaRegenTime = ct + 5
    updatedMana = math.Clamp(updatedMana + self:GetManaRegeneration(), 0, self:GetMaxMana())
    print('manaregenTime', self.ManaRegenTime)
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

function meta:TakeSpecialDamage(amount, type, attacker, inflictor, damageForce, HB)

  if CLIENT and HB then 
    local hb = self:GetHitBoxHitGroup(HB, 0)
    local data = {
      HitGroup = hb,
      Weight = 1 - (self:Health() / self:GetMaxHealth())
    }
    
    self:DamageImpact(data)
  return end
  local d = DamageInfo()
  d:SetDamage(amount)
    if type then
  d:SetDamageType(type)
    end
  if attacker and attacker:IsValid() then
    d:SetAttacker(attacker)
  else d:SetAttacker(self) end

  if inflictor then
    d:SetInflictor(inflictor)
    else d:SetInflictor(game.GetWorld()) end

local d = DamageInfo()

d:SetDamage(amount)
d:SetDamageType(type)

if attacker then
  d:SetAttacker(attacker)
else
d:SetAttacker(self)
end

if damageForce then
  d:SetDamageForce(damageForce)
end
  self:TakeDamageInfo(d)

  gamemode.Call('FloatingScore', attacker, self, 0, amount)
end

function meta:Reset()
if SERVER then
self.RoundStats = {}
self:SetTeam(0)
end
end

function meta:AddSpellCooldown(spellid, duration)
  self.SpellCooldowns[spellid] = self.SpellCooldowns[spellid] + duration
end

function meta:SetSpellCooldown(spellid, duration)
  self.SpellCooldowns[spellid] = CurTime() + duration
end

function meta:HasStatus(id)
  if self.StatusEffects[id] then
  return true else return end
end

local temp_attacker = NULL
local temp_attacker_team = -1

local function MeleeTraceFilter(ent)
  if ent:IsPlayer() and not (PTeam(ent) == PTeam(temp_attacker)) then
    return true 
  else return false end
end

function meta:MeleeTrace(range, size)
	local start = start or self:GetShootPos()
	local dir = dir or self:GetAimVector()

  temp_attacker = self

  meleetrace = {
    start = start,
    endpos = start + dir * range,
    mins = Vector(-size, -size, -size),
    maxs = Vector(size, size, size),
    filter = MeleeTraceFilter,
    mask = MASK_SOLID}


  local tl = util.TraceLine(meleetrace) -- Do traceline incase hull isn't necessary.

  if tl.Hit then
    return tl
  end
    
  return util.TraceHull(meleetrace) end

function meta:DamageImpact(data)
  local act = GAMEMODE.FlinchGestures[data.HitGroup]
  self:AnimRestartGesture(4, act, true)
  self:SetLayerWeight(4, data.Weight)
end