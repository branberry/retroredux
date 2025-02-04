SWEP.DeployDelay = 4
SWEP.DeployAnim = util.GetActivityIDByName('')

SWEP.UseHands = true

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Ammo = "none"
SWEP.Primary.Automatic = true

SWEP.Secondary.ClipSize = 1
SWEP.Secondary.DefaultClip = 1
SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Automatic = true
SWEP.HoldType = 'slam'

function SWEP:Initialize()
end

function SWEP:Deploy()
    local pl = self:GetOwner()
    pl:AnimRestartGesture(1, self.DeployAnim, true)
    pl:SetLayerDuration(1, self.DeployDelay)

    local vm = pl:GetViewModel()
    self:SendWeaponAnim(ACT_VM_DEPLOY)
    local dur = vm:SequenceDuration()
    vm:SetPlaybackRate(GetSpeedByDuration(dur, self.DeployDelay))

    if CLIENT then
        self:PlayDeploySound()
    end
end

function SWEP:Think()
    self:SendWeaponAnim(ACT_VM_IDLE)
end

function SWEP:_SendWeaponAnim(act, dur)
    local vm = self:GetOwner():GetViewModel()
    if act != -1 and vm then
        self:SendWeaponAnim(act)
        dur2 = vm:SequenceDuration()
        vm:SetPlaybackRate(GetSpeedByDuration(dur2, dur))
        vm:SetCycle(0)
    end
end

function SWEP:PlayDeploySound()
end