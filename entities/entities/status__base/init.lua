AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
function ENT:Initialize()
    self:DrawShadow(false)
    self.DieTime = self.DieTime or nil
end

function ENT:SetPlayer(pl, exists)
    local valid = pl and pl:IsValid()
    if valid then
        if exists then
            self:SESetPlayer(pl, exists) -- SESetPlayer in any status effect is how we differentiate how status effects handle player behavior, while SetPlayer is used in status__base for behavior that would apply for any status effect.
        else
            self:SetPos(pl:GetPos())
            self:SetOwner(pl)
            self:SetParent(pl)
            self:SESetPlayer(pl)
        end
    end
end

function ENT:setEffector(pl)
    self.Effector = pl
end

function ENT:Think() -- Let this Think be placeholder for Status Effects. It might be better this way for stability reasons.
    if self.DieTime <= CurTime() then self:Remove() end
end