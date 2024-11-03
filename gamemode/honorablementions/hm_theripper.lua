local function hm_func_theripper()
    local plys = player.GetAll()
    local highestplayer = nil
    local highestvalue = 0
    for i, pl in pairs(plys) do
        
        local roundstats = pl.RoundStats
        if roundstats.MeleeKills and (roundstats.MeleeKills > highestvalue or highestplayer == nil) then

            highestplayer = pl
            highestvalue = roundstats.MeleeKills
        end
    end

    return {Player = highestplayer, Value = highestvalue} end
HONORABLE_MENTIONS_FUNCS['hm_func_theripper'] = hm_func_theripper