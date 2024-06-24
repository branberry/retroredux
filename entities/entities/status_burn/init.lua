AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
function ENT:Initialize()
	self:DrawShadow(false)
	self.DeathTime = CurTime() + 4
	self.TickTime = 0.5
end

function ENT:Think()
	local owner = self:GetOwner()

	

	if (owner:WaterLevel() < 0 or not owner:Alive()) then self:Remove() return end

		owner:TakeSpecialDamage(1,DMG_BURN, Effector, self)
end

-- later we can make the duration and effectiveness of the burn vary depending on spells and such through SetDTFloat, which is an alternative to networkvar.