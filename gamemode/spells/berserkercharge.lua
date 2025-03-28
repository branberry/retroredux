SPELL = {
    Name = 'Berserker Charge',
    Desc = 'Charge head long in to battle, toppling anyone in your way.',
    RuneIcon = 'spellicons/berserkercharge.png',
    Mana = 80,
    Cooldown = 12,
    Words = ""
}

SPELLVARS = {
    DieTime = CurTime() + 3,
    Aura = nil
}


function SPELL:Think(pl)
    local dietime = pl.SpellsActive.SPELL_BERSERKERCHARGE['DieTime']
    if dietime < CurTime() then
    return true end

    local pos1 = pl:GetPos()
    if SERVER then
        for i, v in pairs(ents.FindInSphere(pos1, pl:BoundingRadius())) do
            if v:IsPlayer() and not (v == pl) and (v:Team() != pl:Team()) then
                local pos2 = v:GetPos()
                local kb = NormalBetween(pos1, pos2) + Vector(0, 0, 125)
                v:TakeSpecialDamage(27, DMG_CRUSH, pl, pl, kb)
                return true
            end
        end
    end
end

function SPELL:Init(pl)
pl:EmitSound("nox/berserkercharge.ogg")
    pl.SpellsActive.SPELL_BERSERKERCHARGE['DieTime'] = CurTime() + 3.5
    local dietime = pl.SpellsActive.SPELL_BERSERKERCHARGE['DieTime']
    if CLIENT then
        
        local aura = ents.CreateClientside('rtp_spell_berserkerchargeaura')
        pl.SpellsActive.SPELL_BERSERKERCHARGE['Aura'] = aura
        aura:SetUp(pl, dietime)
        aura:Spawn()
    end
end

function SPELL:PostMove(pl, mv)
    mv:SetMaxSpeed(mv:GetMaxSpeed() + 200)
	mv:SetMaxClientSpeed(mv:GetMaxClientSpeed() + 200)
	mv:SetForwardSpeed(10000)
	mv:SetSideSpeed(0)
    return false
end

function SPELL:PreMove(pl, mv)
    mv:SetMaxSpeed(mv:GetMaxSpeed() + 200)
	mv:SetMaxClientSpeed(mv:GetMaxClientSpeed() + 200)
	mv:SetForwardSpeed(10000)
	mv:SetSideSpeed(0)
    return false
end

function SPELL:CalcMainActivity(pl, vel)
    return ACT_HL2MP_RUN_CHARGING, -1
end

function SPELL:OnRemove(pl)
    local aura = pl.SpellsActive.SPELL_BERSERKERCHARGE['Aura']
    aura:Remove()
end

RegisterSpell('SPELL_BERSERKERCHARGE', SPELL, SPELLVARS)