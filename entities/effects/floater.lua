EFFECT.LifeTime = 2

function EFFECT:Init(data)
    self:SetRenderBounds(Vector(-64, -64, -64), Vector(64, 64, 64))
    self.Pos = data:GetOrigin()
    self.Ent = data:GetEntity()
    self.Type = data:GetFlags()
    self.Amount = math.Round(data:GetMagnitude(), 2)
    self:SetPos(self.Ent:NearestPoint(EyePos()))
    self.DeathTime = CurTime() + self.LifeTime
end

function EFFECT:Think()
    return self.DeathTime > CurTime()
end

function EFFECT:Render()
    local ang = EyeAngles()
    local dt = self.DeathTime
    local delta = ((dt - CurTime()) / self.LifeTime)
    local scale = math.ease.OutElastic(math.Clamp((1 - delta) * 5, 0, 1))
    local a = delta * 255
    local pos = self:GetPos() + Vector(0,0, math.ease.InOutSine(1 - delta)*64)

    cam.IgnoreZ(true)
    ang:RotateAroundAxis(ang:Up(), 270)
	ang:RotateAroundAxis(ang:Forward(), 90)
cam.Start3D2D(pos, ang, scale *.1)
draw.SimpleTextOutlined(self.Amount, 'DefaultFontLarge', 0, 0, Color(255, 0, 0, a), TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER, 1, Color(0,0,0, a))
cam.End3D2D()
end