include("shared.lua")

function ENT:Initialize()
	self:DrawShadow(false)

	local owner = self:GetOwner()
	if owner:IsValid() then
		owner[self:GetClass()] = self
	end
end