local meta = FindMetaTable('Player')

function meta:GetTeamColor() -- team.GetColor does not work for some reason, so just use this shared fabric that deciphered the team colors.
    local teamid = self:Team()
    local teamtbl = TEAMS[TEAMS_PLAYING[teamid]]
    if teamtbl then
    return teamtbl.Color end end

function meta:ExclaimSpellWords(spellid, wps)
    local spelltbl = SPELLS[spellid].TABLE
    if spelltbl then

        local words = string.Split(spelltbl.Words, ' ')

        for i, v in ipairs(words) do
            local sound = GAMEMODE.SPELLWORDS[v]
            timer.Simple((i - 1) / wps, function()
                if sound then
                    self:EmitSound(sound, 75, math.random(95, 110), 1, CHAN_USER_BASE)
                end
            end)
        end
    end

end

function meta:Think()
    if not self.SpellCooldowns then
        self:SetUpTable() --[[ By doing this as quickly as we can, we ensure that the player has these table keys for the gamemode to utilize and not create errors in the future. 
        On the clientside, it does not appear possible to setup tables instantaneously via event (as the player may turn up NULL) --]]
    end
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

function meta:OnRemove()
    local vm = self:GetViewModel()
    if self.hands then
        self.hands:Remove()
    end
    if vm and vm.hands then
        vm.hands:Remove()
    end

end

function meta:FloatingScore(type, amount)
    local eff = EffectData()
    eff:SetFlags(type)
    eff:SetMagnitude(amount)
    eff:SetEntity(self)
    
    util.Effect('floater', eff)
end