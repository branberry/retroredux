ENT.Type = 'anim'

function ENT:GetTeamID()
return self:GetOwner():Team() end