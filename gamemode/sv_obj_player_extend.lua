local meta = FindMetaTable('Player')

function meta:Think()
    if self.SpellCooldowns then
        for i, v in pairs(self.SpellCooldowns) do
            if v and v <= CurTime() then
                self.SpellCooldowns[i] = nil
            end
        end

        for i, v in pairs(self.SpellsActive) do 
            local spell = SPELLS[i]
            local spelltbl = spell.TABLE

            if spelltbl then
                local shouldkill = spelltbl:Think(self)
                    
                if shouldkill then
                    self.SpellsActive[i] = nil
                end
            else
                self.SpellsActive[i] = nil
            end
        end

        for i, v in pairs(self.StatusEffects) do
            local status = STATUS_EFFECTS[i]
            local statustbl = status.TABLE

            if statustbl.Think then

                local shouldkill = statustbl:Think(self)

                if shouldkill then
                    self.StatusEffects[i] = nil
                end
            end
        end
    end
end

function meta:InputThink()
    local swep = self:GetActiveWeapon()
    local cmd = GetPredictionPlayer():GetCurrentCommand()
    if cmd then
        if swep and swep:IsValid() and swep.InputThink then
            swep:InputThink(cmd)
        end
    end
end

function meta:GiveStatus(host, id, duration, effectiveness, frequency)

    local status = STATUS_EFFECTS[id]
    local statusvars = status.TABLEVARS
    local statustbl = status.TABLE
    local index = GetKeyIndexFromTable(STATUS_EFFECTS, id)
    net.Start('nox_GiveStatus')
        net.WriteEntity(self)
        net.WriteUInt(index, 8)
        net.WriteEntity(host)
        if statusvars['Duration'] and duration then net.WriteFloat(duration) end -- Only network what's necessary. The client will know which vars are neccessary on their end as well.
        if statusvars['Effectiveness'] and effectiveness then net.WriteFloat(effectiveness) end
        if statusvars['Frequency'] and frequency then net.WriteFloat(frequency) end
    net.Broadcast()

    if self:HasStatus(id) and statustbl.InitExists then
        statustbl:InitExists(self, host, {Duration = duration, Effectiveness = effectiveness, Frequency = frequency})
    elseif statustbl.Init then
        self.StatusEffects[id] = table.Copy(statusvars)
        statustbl:Init(self, host, {Duration = duration, Effectiveness = effectiveness, Frequency = frequency})
        
    end
end

function meta:CreatePropAtEyePos(propkey)
    local proptbl = GAMEMODE.BuildProps[propkey]
    if proptbl then

        if self.UnfinishedProp then
            self.UnfinishedProp:Remove()
            --pl.UnfinishedProp = nil
        end

        local prop = ents.Create(proptbl.Ent)
        prop:SetOwner(self)
        prop:SetProp(propkey)
        local propindex = GetKeyIndexFromTable(GAMEMODE.BuildProps, propkey)

        local tr = self:GetEyeTrace()
        local angle = Angle(0, 0, self:EyeAngles().r)
        angle:Add(Angle(0, 180, 0))
        prop:SetPos(tr.HitPos)
        prop:SetAngles(angle)
        --prop:Spawn()
        self['UnfinishedProp'] = prop
        timer.Simple(0.2, function()
        net.Start('nox_buildprop')
        net.WritePlayer(self)
        net.WriteUInt(propindex, 8)
        net.WriteEntity(prop)
        net.Broadcast()
        print('done') end)
    end
end