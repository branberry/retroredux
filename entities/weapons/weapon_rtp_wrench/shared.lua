SWEP.Base = 'weapon_rtp_meleebase'
SWEP.PrintName = "Wrench"
SWEP.WorldModel = 'models/weapons/w_spanner.mdl'
SWEP.ViewModel = 'models/weapons/v_spanner/v_spanner.mdl'

SWEP.HoldType = "melee"

SWEP.MeleeDamage = 18
SWEP.MeleeRange = 38
SWEP.MeleeSize = 1
SWEP.SwingDelay = 0.15
SWEP.MeleeKB = 25
SWEP.MeleeImpact = 8
SWEP.AttackCooldown = 0.5
SWEP.RepairRate = 64

SWEP.HeavySwingListen = 0.1
SWEP.HeavySwingDelay = 0.1 -- Additive to SWEP.Primary.Delay 

SWEP.HeadshotMulti = 1.5
SWEP.DeployDelay = 0.2

if CLIENT then
    function SWEP:ButtonDown(pl, button)
        if button == 27 then -- Q
            gamemode.Call('OpenBuildMenu')
        end
    end
end

function SWEP:EntityMeleeAttack(ent, amount, type, trace)
    local owner = self:GetOwner()
    if ent and ent:IsPlayer() then
        local finalforce = (self.MeleeKB * trace.Normal) * 128
        ent:TakeSpecialDamage(amount, type, owner, self, finalforce, trace.HitBox)
        if CLIENT then
            self:PlayFleshHitSound()
        end
    elseif ent and ent:IsValid() and (ent.Base == 'prop_prop' or ent:GetClass() == 'prop_prop') then
        print(ent.TeamID)
        if ent.TeamID == owner:Team() then
            ent:Repair(self.RepairRate)
            print('success')
        end
    end
    self:PlaySwingSound()
    self:PostHitUtil(ent, trace)
end