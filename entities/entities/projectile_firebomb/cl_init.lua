include('shared.lua')

function ENT:Draw()
    self:DrawModel()

end

function ENT:Initialize()
end

function ENT:OnRemove()
    self:EmitSound('^weapons/explode5.wav', 100, 100, 1, CHAN_WEAPON)
end