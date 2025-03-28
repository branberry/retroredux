ENT.Type = 'anim'

function ENT:Initialize()
    print(util.GetActivityIDByName('ACT_HL2MP_ATKDIR_RUN_MELEE2'))
    print(util.GetActivityIDByName('ACT_HL2MP_ATKDIR_CWALK_MELEE2'))
    print(util.GetActivityIDByName('ACT_HL2MP_ATKDIR_IDLE_MELEE2'))
end