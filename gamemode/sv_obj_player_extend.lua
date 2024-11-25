local meta = FindMetaTable('Player')

function meta:Think()
    for i, v in pairs(self.SpellCooldowns) do
        if v <= CurTime() then
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