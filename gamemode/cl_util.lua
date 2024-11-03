function GetRandomBonePos(ent)

    local count = ent:GetBoneCount()

    local pos = ent:GetBonePosition(math.random(0, count - 1))
    return pos
end

function CSRagdollMimickCSRagdoll(rag, mime)

    local physcount = rag:GetPhysicsObjectCount()

    for i=0, physcount - 1 do
        local phys = rag:GetPhysicsObjectNum(i)
        local otherphys = mime:GetPhysicsObjectNum(i)

        local mimeplayercolor = mime.GetPlayerColor
        local pos, rot, vel, angvel, color = otherphys:GetPos(), otherphys:GetAngles(), otherphys:GetVelocity(), otherphys:GetAngleVelocity(), mime:GetColor()

        rag.GetPlayerColor = function() return mimeplayercolor end
        phys:SetPos(pos)
        phys:SetAngles(rot)
        phys:SetVelocity(vel)
        phys:SetAngleVelocity(angvel)
        rag:SetColor(color)
    end
end