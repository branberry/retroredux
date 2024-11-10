SPELL = {
    Name = 'Fire Bomb',
    Desc = 'Creates a giant flaming ball. The ball explodes shortly after its first bounce.',
    RuneIcon = 'spellicons/starburst.png',
    Mana = 80,
    Cooldown = 6,
}

function SPELL:Init(pl)
    if SERVER then
        local firebomb = ents.Create('projectile_firebomb')
        local aimvect = pl:GetAimVector()

        firebomb:SetPos(pl:GetPos() + pl:GetViewOffset() + (aimvect * 64))
        firebomb:SetOwner(pl)
        firebomb:Spawn()
        
        print(pl:GetAimVector())
        local finalvect = aimvect * 800
        local phys = firebomb:GetPhysicsObject()

        phys:SetVelocityInstantaneous(pl:GetAimVector() * 1000)
    end
end

RegisterSpell('SPELL_FIREBOMB', SPELL)

