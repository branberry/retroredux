SPELL = {
    Name = 'Fire Bomb',
    Desc = 'Creates a giant flaming ball. The ball explodes shortly after its first bounce.',
    RuneIcon = 'spellicons/starburst.png',
    Mana = 80,
    Cooldown = 6,
    Words = "zo ru un in zo ru"
}

SPELLVARS = {}

function SPELL:Init(pl)

    if SERVER then 
        timer.Simple(0.5, function()
            local teamcol = team.GetColor(pl:Team())

            if pl:Alive() then
            local firebomb = ents.Create('projectile_firebomb')
            local aimvect = pl:GetAimVector()
    
            firebomb:SetPos(pl:GetPos() + pl:GetViewOffset() + (aimvect * 64))
            firebomb:SetOwner(pl)
            firebomb:Spawn()
            
            print(pl:GetAimVector())
            local finalvect = aimvect * 800
            local phys = firebomb:GetPhysicsObject()
    
            phys:SetVelocityInstantaneous(pl:GetAimVector() * 1000)
            util.SpriteTrail(firebomb, 0, teamcol, false, 48, 32, 1, 0.025, "Effects/fire_cloud2.vmt")
            end
        end)
    else
        timer.Simple(0.2, function()
            local attach = pl:LookupAttachment('anim_attachment_LH')
            local fakebomb = ClientsideModel("models/Combine_Helicopter/helicopter_bomb01.mdl", RENDERGROUP_OTHER)
            fakebomb:SetColor(GetTeamColor(pl:Team()))
            fakebomb:SetMaterial('models/shiny')
            fakebomb:SetParent(pl, attach)
            fakebomb:SetLocalPos(vector_origin)
            fakebomb:ManipulateBoneScale(0, Vector(0.5,0.5,0.5))

            timer.Simple(0.3, function()
            fakebomb:Remove()
            end)
        end)

        pl:AnimRestartGesture(0, ACT_SIGNAL_FORWARD, true)
        timer.Simple(0.2, function() 
            pl:AnimRestartGesture(1, ACT_GMOD_GESTURE_ITEM_THROW, true) 
            pl:AnimRestartGesture(2, ACT_GMOD_GESTURE_ITEM_THROW, true)
            pl:AnimRestartGesture(3, ACT_HL2MP_GESTURE_RANGE_ATTACK_FIST, true)
            pl:SetLayerPlaybackRate( 1, 1.5)
            pl:SetLayerPlaybackRate( 2, 1.5)
            pl:SetLayerPlaybackRate( 3, 0.5)
            pl:AnimSetGestureWeight(3, 1)
            EmitSound('ambient/energy/weld1.wav', pl:GetPos(), pl:EntIndex(), CHAN_AUTO, 1, 75, 0, math.random(120, 100))
         end )
end
end

function SPELL:Think(pl)
return true end

RegisterSpell('SPELL_FIREBOMB', SPELL, SPELLVARS)

