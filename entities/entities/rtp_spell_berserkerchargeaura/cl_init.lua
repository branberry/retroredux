ENT.Type = 'anim'

ENT.DieTime = CurTime() + 4
ENT.StartTime = CurTime()

function ENT:Initialize()
    self.StartTime = CurTime()
end

function ENT:SetUp(owner, dietime)
    self.DieTime = dietime
    print(dietime)
    self.AutomaticFrameAdvance = true
    self:SetModel("models/Combine_Helicopter/helicopter_bomb01.mdl")
	self:SetMaterial("models/shiny")
    if owner:IsPlayer() then
        local teamcol = owner:GetTeamColor()
        self:SetModelScale(owner:GetModelRadius()/24, 0)
        self:SetColor(Color(teamcol.r, teamcol.g, teamcol.b, 125))
        self:SetRenderMode(1)
        self:SetPos(owner:GetPos() + Vector(0,0, owner:GetModelRadius()/2))
        self:SetLocalAngles(angle_zero)
        self:SetParent(owner)
    end
end

function ENT:Think()
    local ang = self:GetAngles()
    ang:RotateAroundAxis(self:GetRight(), 8)
    self:SetAngles(ang)

    local delta = (CurTime() - self.StartTime) / (self.DieTime - self.StartTime)
    local curcolor = self:GetColor()

    print(delta)

    if delta < 0.4 then curcolor.a = math.min((delta*4) * 125, 125)

    elseif delta > 0.8 then curcolor.a = math.max((1 - (delta - .8)*4) * 125, 0) end
    self:SetColor(curcolor)




    if self.DieTime < CurTime() then
        self:Remove()
    end
    self:SetNextClientThink(0.1)
    return true
end