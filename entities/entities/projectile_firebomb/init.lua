AddCSLuaFile('shared.lua')
AddCSLuaFile('cl_init.lua')
include('shared.lua')

ENT.ExplosionTime = CurTime() + 3

function ENT:Initialize()
    self:SetModel('models/Combine_Helicopter/helicopter_bomb01.mdl')
    self:SetMaterial('models/shiny')
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
    local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:EnableDrag(false)
		phys:SetMass(5)
		phys:Wake()
		phys:SetMaterial('gmod_bouncy')
	end

	self:SetColor(team.GetColor(self:GetOwner():Team()))

	self.ExplosionTime = CurTime() + 2
end

function ENT:Think()
	if self.ExplosionTime <= CurTime() then
		self:Explode()
	end
end

function ENT:PhysicsCollide(data, phys)
	self:EmitSound("physics/metal/metal_canister_impact_hard"..math.random(1,3)..".wav", 80, math.random(137, 143))
	util.ScreenShake(self:GetPos(), 8, 1, 0.2, 512, true)
end

function ENT:Explode()
	util.ScreenShake(self:GetPos(), 555, 256, 0.1, 752, false)
	local effectdata = EffectData()
		effectdata:SetOrigin(self:GetPos())
	util.Effect("HelicopterMegaBomb", effectdata)
	local owner = self:GetOwner()

	local victims = CalculateAOE(self:GetPos(), 512, 'InSine')
	for i, v in pairs(victims) do
		local pl = Entity(v.ent:EntIndex())
		if v.ent:IsPlayer() and (v.ent:Team() != owner:Team() or v.ent == owner) then
			local dmg = 64 * v.fo
			local force = 10240 * v.fo
			v.ent:TakeSpecialDamage(dmg, DMG_GENERIC, owner, self, force, Vector(1, 0, 0))
			v.ent:GiveStatus(self:GetOwner(), 'STATUS_BLEED', 32, 1, 1)
		end
	end
	self:Remove()
end