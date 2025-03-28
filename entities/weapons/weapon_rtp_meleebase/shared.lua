SWEP.Base = 'weapon_rtp_base'

SWEP.ShowViewModel = false
SWEP.ShowWorldModel = false
SWEP.UseHands = true

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Ammo = "none"
SWEP.Primary.Automatic = true

SWEP.Secondary.ClipSize = 1
SWEP.Secondary.DefaultClip = 1
SWEP.Secondary.Ammo = "dummy"
SWEP.Secondary.Automatic = true

SWEP.IsMelee = true
SWEP.MeleeRange = 64
SWEP.MeleeSize = 1.5
SWEP.MeleeDamage = 24
SWEP.MeleeDamageHeavy = 32
SWEP.MeleeRecoil = 1
SWEP.weight = 4
SWEP.HeadshotMulti = 1.2
SWEP.MeleeKB = 50
SWEP.MeleeKBHeavy = 1.5
SWEP.MeleeImpact = 1
SWEP.MeleeImpactHeavy = 1.5
SWEP.DamageType = DMG_SLASH
SWEP.DeployDelay = 0.5

SWEP.HeavySwingListen = 0.2
SWEP.HeavySwingDelay = 0.1 -- Additive to SWEP.Primary.Delay 
SWEP.SwingDelay = 0.4

SWEP.AttackCooldown = 0.5

SWEP.HoldType = 'melee2'

SWEP.HitAnim = ACT_VM_HITCENTER
SWEP.MissAnim = ACT_VM_MISSCENTER
SWEP.InOmniAttack = true

SWEP.StartSwing = 0
SWEP.SwingStage = 0
SWEP.NextSwingStage = 0 -- 0 = not attacking, 1 = preparing/winding-up, 2 = attacking
SWEP.IsHeavyAttack = false

function SWEP:Initialize()
    self:SetWeaponHoldType(self.HoldType)
end

function SWEP:PlayPreSwingAnim()
end
function SWEP:PlaySwingAnim()
end

function SWEP:PrepareSwing()
    local pl = self:GetOwner()
    self.IsHeavyAttack = false
    self.SwingStage = 1
    self:SwingStateChanged(1)
    self.NextSwingStage = CurTime() + self.SwingDelay
    self:SetNextPrimaryFire(CurTime() + self.HeavySwingListen)
    self.StartSwing = CurTime()
    local act = util.GetActivityIDByName('ACT_VM_PRESWING_01_N90') 
    self:_SendWeaponAnim(act, self.SwingDelay)
    pl:AnimRestartGesture(1, util.GetActivityIDByName('ACT_HL2MP_ATKDIR_PRERANGE1_MELEE2'), false)
    pl:SetLayerDuration(1, self.SwingDelay + 0.1)
    if CLIENT then
        self:PlayPrepSwingSound()
    end
end

function SWEP:CanPrimaryAttack()
return true
end


function SWEP:PrepareHeavyAttack()
    local swingstage = self.SwingStage
    local nextswingstage = self.NextSwingStage
    local heavyattack = self.IsHeavyAttack

    self.IsHeavyAttack = true
    self.NextSwingStage = nextswingstage + self.HeavySwingDelay
     self:SetNextPrimaryFire(self.NextSwingStage + self.AttackCooldown)

     local vm = self:GetOwner():GetViewModel()

     dur2 = vm:SequenceDuration()
     vm:SetPlaybackRate(GetSpeedByDuration(dur2, 1))
     vm:SetCycle(0.5)
end


function SWEP:PrimaryAttack()
    local pl = self:GetOwner()
    local swingstage = self.SwingStage
    local nextswingstage = self.NextSwingStage
    local heavyattack = self.IsHeavyAttack

    if swingstage == 0 then
        self:PrepareSwing()
    

    elseif swingstage == 1 and !heavyattack then
        self:PrepareHeavyAttack()
    end
end

function SWEP:Reload()
end

function SWEP:Think()
    local pl = self:GetOwner()
    local swingstage = self.SwingStage
    local nextswingstage = self.NextSwingStage
    local heavyattack = self.IsHeavyAttack

    if swingstage == 1 and (nextswingstage <= CurTime()) then 
        self:MeleeSwing()

    elseif swingstage == 2 and (nextswingstage <= CurTime()) then
    self.SwingStage = 0
    self:SwingStateChanged(0)
    self.IsHeavyAttack = false
    end
end

function SWEP:MeleeSwing()
    local pl = self:GetOwner()
    local recoil = self.MeleeRecoil
    local act = util.GetActivityIDByName('ACT_VM_SWING_01_N90')
    local worldact = util.GetActivityIDByName('ACT_VM_SWING_01_N90')
    self:_SendWeaponAnim(ACT_VM_PRIMARYATTACK, self.AttackCooldown)
    pl:ViewPunch(Angle(recoil, recoil, recoil))
    self:SetNextPrimaryFire(self.NextSwingStage + self.AttackCooldown)
    self.SwingStage = 2
    self:SwingStateChanged(2)
    pl:AnimRestartGesture(1, util.GetActivityIDByName('ACT_HL2MP_ATKDIR_RANGE1_MELEE2'), true)
    pl:SetLayerDuration(1, self.AttackCooldown)

    self.NextSwingStage = CurTime() + self.AttackCooldown
    
    local tr = pl:MeleeTrace(self.MeleeRange, self.MeleeSize)

        if tr.Entity then
            self:EntityMeleeAttack(tr.Entity, self.MeleeDamage, self.DamageType, tr)
        end

    if CLIENT then
        self:PlaySwingSound()
    end
end

function SWEP:EntityMeleeAttack(ent, amount, type, trace)
    if ent and ent:IsPlayer() then
        local finalforce = (self.MeleeKB * trace.Normal) * 128
        ent:TakeSpecialDamage(amount, type, self:GetOwner(), self, finalforce, trace.HitBox)
        
        if CLIENT then
            self:PlayFleshHitSound()
        end
    end
    self:PlaySwingSound()
    self:PostHitUtil(ent, trace)
end

function SWEP:PostHitUtil(hitent, tr)
	if not tr.HitSky then
        local effectdata = EffectData()
        if hitent:IsValid() then
            effectdata:SetSurfaceProp(tr.SurfaceProps)
            effectdata:SetDamageType(self.DamageType)
            effectdata:SetOrigin(tr.HitPos)
            effectdata:SetEntity(hitent)
            effectdata:SetHitBox(tr.HitBox)
            util.Effect("Impact", effectdata)
            if hitent:IsPlayer() then
                effectdata:SetColor(0)
                effectdata:SetScale(6)
                effectdata:SetFlags(3)
                util.Effect("bloodspray", effectdata)
                util.Effect("BloodImpact", effectdata)
                util.Decal('Impact.Flesh', tr.StartPos, tr.HitPos)
            end
        end
	end
end

function SWEP:TranslateActivity(act)
    local actstring = util.GetActivityNameByID(act)
    local actnum = act
    if ( self.ActivityTranslate[ act ] != nil ) then
        actnum = self.ActivityTranslate[act]
        actstring = util.GetActivityNameByID(actnum)
    else return act end

    if self.InOmniAttack then
        actstring = 'ACT_HL2MP_ATKDIR_' .. string.sub(actstring, 11)
    end
    

    actnum = util.GetActivityIDByName(actstring)
    if CLIENT then
    end
	return actnum

end

function SWEP:SwingStateChanged(state)
end

function SWEP:PlayPrepSwingSound()
end

function SWEP:PlaySwingSound()
    self:EmitSound('nox/sword_miss.ogg', 80, math.random(80, 120), 70, CHAN_WEAPON)
end

function SWEP:PlayHitSound()
    self:EmitSound('nox/sword_hit.ogg', 80, math.random(80, 120), 70, CHAN_WEAPON)
end

function SWEP:PlayFleshHitSound()
    self:EmitSound('nox/sword_hit.ogg', 80, math.random(80, 120), 70, CHAN_WEAPON)
end