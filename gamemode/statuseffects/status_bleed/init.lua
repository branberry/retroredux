AddCSLuaFile('shared.lua')
AddCSLuaFile('cl_init.lua')
include('shared.lua')

function STATUS:Init(pl, host, varargs)
    local status = pl.StatusEffects['STATUS_BLEED']

    if varargs.Duration then
        status.DieTime = CurTime() + varargs.Duration
        status.Duration = varargs.Duration
    else status.DieTime = CurTime() + 2 end

    if varargs.Effectiveness then
        status.Effectiveness = varargs.Effectiveness
    end

    if varargs.Frequency then
        status.Frequency = varargs.Frequency
    end

    varargs.NextHit = CurTime() + 1/status.Frequency
end

function STATUS:InitExists(pl, host, varargs)
    local status = pl.StatusEffects['STATUS_BLEED']
    
    if varargs.Duration then
        status.DieTime = status.DieTime + varargs.Duration/2
        status.Duration = status.Duration + varargs.Duration
    end

    if varargs.Frequency then
        status.Frequency = status.Frequency + varargs.Frequency
    end
    status.Host = host
end

function STATUS:Think(pl)
    local status = pl.StatusEffects['STATUS_BLEED']
    local ct = CurTime()

    if status.DieTime <= ct then
        return true
    elseif status.NextHit <= ct then
            pl:TakeDamage(status.Effectiveness, self, self)
            status.NextHit = CurTime() + 1/status.Frequency
            return false end
end
RegisterStatusEffect('STATUS_BLEED', STATUS, STATUSVARS)