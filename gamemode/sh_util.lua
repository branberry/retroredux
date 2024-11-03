function CalculateDirection3D(Vector1, Vector2)

local x1, y1, z1 = Vector1:Unpack()
local x2, y2, z2 = Vector2:Unpack()

local yaw_rad = math.atan2(y1 - y2, x2 - x1)
local yaw_deg = math.deg(yaw_rad)
local pitch_rad = math.atan2(z1 - z2, x2 - x1)
local pitch_deg = math.deg(pitch_rad)

return Angle(0, yaw_deg - 90, 0) end

function EaseDirection(Angle, TargetAngle, Ratio, Func)

    local diff = Angle - TargetAngle
    local newangle = Angle + (diff * math.ease[Func](Ratio))

return newangle end

function EaseVector(Vector, TargetVector, Ratio, Func)

    local diff = TargetVector - Vector
    local newvector = Vector + (diff * math.ease[Func](Ratio))

return newvector end


function Orbit(Origin, angle, Radius)
    local ang = math.rad(angle)
    local y = math.sin(ang) * Radius
    local x = math.cos(ang) * Radius

    local newvect = Vector(Origin.x + x, Origin.y + y, Origin.z)
    local newdir = GetOrbitingAngle(Origin, newvect)

return newvect, Angle(0, newdir, 0) end

function GetOrbitingAngle(Pos, Origin)

    local x1, y1 = Pos:Unpack()
    local x2, y2 = Origin:Unpack()

    local pitch_rad = math.atan2(y1 - y2, x1 - x2)
    local pitch_deg = math.deg(pitch_rad)

    return pitch_deg end

function GetKeyIndexFromTable(tbl, key)

local keys = table.GetKeys(tbl)
local index = table.KeyFromValue(keys, key)
return index end

function GetSpeedAtNormal(Vel, Norm)
local normalvect = Vel * Norm
local x, y, z = normalvect:Unpack()

return math.max(x, y, z) end

function BounceVelocityByNormal(Vel, Norm, Damping)

local bouncedvelnorm = (1/(1 + Damping)) * (Vel * (Norm * -1))
return bouncedvelnorm end