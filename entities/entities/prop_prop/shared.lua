ENT.Type = 'anim'

ENT.Prop = nil
ENT.IsConstructed = false
ENT.TeamID = -1
function ENT:Initialize()
    self.CreatedTime = CurTime()
end

function ENT:SetTeam(teamid)
    self.TeamID = teamid
end

function ENT:SetProp(index)
    local owner = self:GetOwner()
    self.Prop = index
    self.CreatedTime = CurTime()
    self.IsConstructed = false

    if CLIENT then
        local ratio = self:Health() / self:GetMaxHealth()
        self:SetColor(Color(255,255,255, math.max(125, ratio * 255)))
        self:SetRenderMode(RENDERMODE_TRANSCOLOR)
    end

    if owner and owner:IsValid() then
        self:SetTeam(owner:Team())
        print(owner:GetCollisionGroup())
    end
    local proptbl = GAMEMODE.BuildProps[index]
    if SERVER then
        self:SetMaxHealth(proptbl.HP)
        self:SetHealth(55)
        self:SetModel(proptbl.Mdl)
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
    end
end

function ENT:FinishConstruction()
    self:SetRenderMode(RENDERMODE_NORMAL)
    self:SetHealth(self:GetMaxHealth())
    self.IsConstructed = true
end

function ENT:Repair(amount)
    self:SetHealth(self:Health() + amount)
    local ratio = self:Health() / self:GetMaxHealth()
    local proptbl = GAMEMODE.BuildProps[self.Prop]
    if not self.IsConstructed then
        if CLIENT then
            self:SetColor(Color(255,255,255, math.max(125, ratio * 255)))
            if ratio >= 1 then
                self:FinishConstruction()
            end
        end

        if SERVER then
            if self:Health() >= self:GetMaxHealth() then
                self:FinishConstruction()
            end
        end

    end
end

--[[function ENT:Think()
        if self.CreatedTime and CurTime() < (self.CreatedTime + 0.8) then

            local ratio = math.Clamp((CurTime() - self.CreatedTime) / 0.7, 0, 1)
            local vmat = Matrix()

            if CLIENT then
                vmat:SetScale(Vector(math.ease.OutBack(ratio), math.ease.OutElastic(ratio), math.ease.OutSine(ratio)))
                vmat:SetTranslation(Vector(0,0,0))
                self:EnableMatrix('RenderMultiply', vmat)
            end
        end
end--]]