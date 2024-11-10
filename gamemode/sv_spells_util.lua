function CalculateAOE(pos, radius, fallofffunc) -- Quicker way to do areal effects without intrusive math for every entity/projectile.
    local effect = {}

    for i, v in pairs(ents.FindInSphere(pos, radius)) do
        local distsqr = v:DistToSqr(pos)
        local radsqr = radius^2

        local ratio = 1 - (distsqr / radsqr)
        local falloff = math.ease[fallofffunc](ratio)
        table.insert(effect, {ent = v, fo = falloff})
    end
    return effect end