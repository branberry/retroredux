function CreateCSRagdoll(ply) -- Using Player:CreateRagdoll() is serversided and would not work well with clientside settings. Lets use this so we can have further control as well as performance options.
    local owner = ply
    local ShouldRag = false
    if nox_maxcsrags and CS_RAGS and owner then 
        if #CS_RAGS < nox_maxcsrags:GetInt() then
            ShouldRag = true
        elseif ply == LocalPlayer() then  -- Assuming your game can handle atleast one ragdoll that will always be relevant.
            ShouldRag = true
        else

            local len = CS_RAGS[#CS_RAGS]
            len:Remove()
            table.remove(CS_RAGS, #CS_RAGS)
            ShouldRag = true
            
        end
    end

    if ShouldRag then
        local rag = ClientsideRagdoll(ply:GetModel(), RENDERGROUP_OPAQUE)
        rag:InvalidateBoneCache()
        local pcolor = owner:GetPlayerColor()
        local class = CLASSES[owner:GetPlayerClass()]

        rag:SetupBones()
        
        if class and not class.ColorOverall then
        rag.GetPlayerColor = function() return pcolor end

        else
        pcolor = ply:GetColor()
        rag:SetColor(pcolor)
        end
        local physcount = rag:GetPhysicsObjectCount()
        local vel = owner:GetVelocity()

        for i=0, physcount - 1 do

            local phys = rag:GetPhysicsObjectNum(i)
            local bone = rag:TranslatePhysBoneToBone(i)

            local bonepos = owner:GetBonePosition(bone)
            local bonemat = owner:GetBoneMatrix(bone)
            local boneang = bonemat:GetAngles(bone)

            phys:SetPos(bonepos)
            phys:SetAngles(boneang)
            phys:SetVelocity(vel)

            rag:SetNoDraw( false )
            rag:DrawShadow( true )

        end
        table.insert(CS_RAGS, 0, rag)
    return rag end
end

function GetRandomBonePos(ent)

    local count = ent:GetBoneCount()

    local pos = ent:GetBonePosition(math.random(0, count - 1))
    return pos
end