ACTS_CUSTOM = {
'ACT_HL2MP_ATKDIR_PRERANGE1_MELEE2',
'ACT_HL2MP_ATKDIR_RANGE1_MELEE2',
'ACT_HL2MP_ATKDIR_RUN_MELEE2',
'ACT_HL2MP_ATKDIR_RUN_MELEE2'
}

function GM:ModelCache()
    if SERVER then
    end

    if CLIENT then
        local ent = ents.CreateClientside("anm_dummy")
        ent:SetPos(Vector(16,16,16))
        ent:SetModel('models/retroteamplay/sh_rtp_melee_anm.mdl')
        ent:Spawn()
        RunConsoleCommand('r_flushlod')
        SafeRemoveEntityDelayed(ent, 0)
    end
  end


function GM:HandlePlayerJumping( pl, vel, plyTable)
    if plyTable.m_bjumping then
        plyTable.CalcIdeal = ACT_MP_JUMP
        return true
    end
    return false
end

function GM:HandlePlayerDucking(pl, vel, plyTable)
        if pl:Crouching() then 
            plyTable.CalcIdeal = ACT_MP_CROUCHWALK 
            return true
        end
    return false
end

function GM:CalcMainActivity(pl, vel, maxgspeed)
    local plyTable = pl:GetTable()
    plyTable.CalcIdeal = ACT_MP_STAND_IDLE
	plyTable.CalcSeqOverride = -1 

    if !(self:HandlePlayerJumping(pl, vel, plyTable) ||
        self:HandlePlayerDucking(pl, vel, plyTable)) then

            local len2d = vel:Length2DSqr()
            if ( len2d > 22500 ) then plyTable.CalcIdeal = ACT_MP_RUN elseif ( len2d > 0.25 ) then plyTable.CalcIdeal = ACT_MP_WALK end
    end

    local playerspells = pl.SpellsActive
    if playerspells then
        for i, v in pairs(playerspells) do
            local spelltbl = SPELLS[i].TABLE
            if spelltbl.CalcMainActivity then
                plyTable.CalcIdeal, plyTable.CalcSeqOverride = spelltbl:CalcMainActivity(pl, vel, maxgspeed)
            end
        end
    end

return plyTable.CalcIdeal, plyTable.CalcSeqOverride end

local IdleActivity = ACT_HL2MP_IDLE
local IdleActivityTranslate = {}
IdleActivityTranslate[ ACT_MP_STAND_IDLE ]					= IdleActivity
IdleActivityTranslate[ ACT_MP_WALK ]						= IdleActivity + 1
IdleActivityTranslate[ ACT_MP_RUN ]							= IdleActivity + 2
IdleActivityTranslate[ ACT_MP_CROUCH_IDLE ]					= IdleActivity + 3
IdleActivityTranslate[ ACT_MP_CROUCHWALK ]					= IdleActivity + 4
IdleActivityTranslate[ ACT_MP_ATTACK_STAND_PRIMARYFIRE ]	= IdleActivity + 5
IdleActivityTranslate[ ACT_MP_ATTACK_CROUCH_PRIMARYFIRE ]	= IdleActivity + 5
IdleActivityTranslate[ ACT_MP_RELOAD_STAND ]				= IdleActivity + 6
IdleActivityTranslate[ ACT_MP_RELOAD_CROUCH ]				= IdleActivity + 6
IdleActivityTranslate[ ACT_MP_JUMP ]						= ACT_HL2MP_JUMP_SLAM
IdleActivityTranslate[ ACT_MP_SWIM ]						= IdleActivity + 9
IdleActivityTranslate[ ACT_LAND ]							= ACT_LAND

function GM:TranslateActivity(pl, act)
    local newact = pl:TranslateWeaponActivity(act)
	if ( act == newact ) then
		return IdleActivityTranslate[ act ]
	end

	return newact

end