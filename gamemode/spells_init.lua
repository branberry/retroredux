local function burn(pl)
  local ent = ents.Create('projectile_burn')
  if ent:IsValid() then
    ent:SetOwner(pl)
    ent:SetPos(pl:GetShootPos())
    ent:Spawn()
    local phys = ent:GetPhysicsObject()
    if phys:IsValid() then phys:SetVelocityInstantaneous(pl:GetAimVector() * 2000) end
  end
end

SPELLS.Burn = {
  Func = burn,
  Icon = 'spellicons/burn.png',
}