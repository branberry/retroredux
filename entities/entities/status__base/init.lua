AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
    self:DrawShadow(false)
end

function ENT:SetPlayer(pl)

    if (pl and IsValid(pl)) then
    self:SetPos(pl:GetPos())
    self:SetOwner(pl)
	self:SetParent(pl)
    end
end

function ENT:Think()
        if self.DieTime <= CurTime() then
            self:Remove()
        end
end
