AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
function ENT:Initialize()
	self:DrawShadow(false)
	self.DeathTime = CurTime() + 10
end

function ENT:Think()
	local owner = self:GetOwner()
	local pos = self:GetPos()
	if self.DeathTime <= CurTime() or self:WaterLevel() > 0 then self:Remove() end
	for _, ent in pairs(ents.FindInSphere(pos, 10)) do
		if ent:IsPlayer() then
	 local st = ent:GetStatus("burn")
	 print(tostring(st))
		end
		if (ent:IsPlayer() and ent:Alive() and not ent:GetStatus("burn")) then ent:GiveStatus("burn", 2, owner) end
	end
end