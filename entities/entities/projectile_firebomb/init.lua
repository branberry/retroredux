AddCSLuaFile('shared.lua')
AddCSLuaFile('cl_init.lua')
include('shared.lua')

ENT.ExplosionTime = CurTime() + 3

function ENT:Initialize()
    self:SetModel("models/Combine_Helicopter/helicopter_bomb01.mdl")
    self:SetMaterial("models/shiny")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
    local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:EnableDrag(false)
		phys:SetMass(5)
		phys:Wake()
	end

	self.ExplosionTime = CurTime() + 2
end

function ENT:Think()
	if self.ExplosionTime <= CurTime() then
		self:Explode()
	end


end

function ENT:Explode()
	util.ScreenShake(self:GetPos(), 4, 1, 0.5, 752, false)
	local effectdata = EffectData()
		effectdata:SetOrigin(self:GetPos())
	util.Effect("HelicopterMegaBomb", effectdata)
	self:Remove()
end