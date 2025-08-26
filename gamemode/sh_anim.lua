if SERVER then
    util.AddNetworkString('nox_PlayerAtkDir')
end
function GM:ModelCache()
    if SERVER then
    end

    if CLIENT then
        local pm = ClientsideModel('models/retroteamplay/sh_rtp_anm.mdl')
        pm:SetModel('models/retroteamplay/sh_rtp_anm.mdl')
        pm:Spawn()
        timer.Simple(4, function() RunConsoleCommand('r_flushlod') end)
    end
  end


function GM:HandlePlayerJumping( pl, vel, plyTable)

	if ( !plyTable ) then plyTable = ply:GetTable() end

	if ( pl:GetMoveType() == MOVETYPE_NOCLIP ) then
		plyTable.m_bJumping = false
		return
	end

	-- airwalk more like hl2mp, we airwalk until we have 0 velocity, then it's the jump animation
	-- underwater we're alright we airwalking
	if ( !plyTable.m_bJumping && !pl:OnGround() && pl:WaterLevel() <= 0 ) then

		if ( !plyTable.m_fGroundTime ) then

			plyTable.m_fGroundTime = CurTime()

		elseif ( ( CurTime() - plyTable.m_fGroundTime ) > 0 && vel:Length2DSqr() < 0.25 ) then

			plyTable.m_bJumping = true
			plyTable.m_bFirstJumpFrame = false
			plyTable.m_flJumpStartTime = 0

		end
	end

	if ( plyTable.m_bJumping ) then

		if ( plyTable.m_bFirstJumpFrame ) then

			plyTable.m_bFirstJumpFrame = false
			pl:AnimRestartMainSequence()

		end

		if ( ( pl:WaterLevel() >= 2 ) || ( ( CurTime() - plyTable.m_flJumpStartTime ) > 0.2 && pl:OnGround() ) ) then

			plyTable.m_bJumping = false
			plyTable.m_fGroundTime = nil
			pl:AnimRestartMainSequence()

		end

		if ( plyTable.m_bJumping ) then
			plyTable.CalcIdeal = ACT_MP_JUMP
			return true
		end
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

function GM:UpdateAnimation(pl, vel, gspeed)
    if not pl.m_bJumping then
        local len = vel:Length()
        local movement = 1.0

        if (len > 0.2) then
            movement = (len / gspeed)
        end

        local rate = math.min(movement, 4)

        -- if we're under water we want to constantly be swimming..
        if (pl:WaterLevel() >= 2) then
            rate = math.max(rate, 0.5)
        elseif (!pl:IsOnGround() && len >= 1000) then
            rate = 0.1
        end

        pl:SetPlaybackRate(rate)

        local swep = pl:GetActiveWeapon()
        if swep.UpdateAnimation then
            swep:UpdateAnimation(pl, vel, gspeed)
        end
    else pl:SetPlaybackRate(2) end
end

if CLIENT then
    net.Receive('nox_PlayerAtkDir', function()
        local pl = net.ReadPlayer()
        local atkdir = net.ReadUInt(8)
        if pl and pl:IsValid() then
            pl:UpdateAttackDirection(atkdir)
        end
    end)
end