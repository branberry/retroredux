ENT.Type = "anim"
ENT.Base = "base_entity"
ENT.IsStatus = true

function ENT:Initialize()
    self:DrawShadow(false)
end

function ENT:setEffector(Effector)
    ENT.Effector = Effector
end