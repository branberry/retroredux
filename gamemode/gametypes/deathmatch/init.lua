AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")
function GAMEMODE:GameTypeInit()
local datatbl = gamemode.Call('GetPostMapData')
  if datatbl.ShouldHavePrepPeriod then
    SetGlobalFloat('EndTime', (CurTime() + self.PrepTime))
    gamemode.Call('SetRoundStatus', 0)
  else
    SetGlobalFloat('EndTime', (CurTime() + self.DefaultRoundDuration))
    gamemode.Call('SetRoundStatus', 1, true)
  end
end

local function DetermineWinners(allowdraw)
  local highest_teams = {}
  local teaminfos = GAMEMODE.TeamInfos

  for i, v in pairs(teaminfos) do
    local highest_score = highest_teams[table.GetWinningKey(highest_teams)]
    if highest_score then
      if highest_score < v.Score then 
        table.Empty(highest_teams)
        highest_teams[i] = v.Score
      
      elseif highest_score == v.Score then
        highest_teams[i] = v.Score
      end

    else
  
      highest_teams[i] = v.Score
    
    end
  end
  if allowdraw and #highest_teams > 1 then return highest_teams

  else return table.Random(highest_teams) end -- Select random currently, im thinking of changing this to instead just a tie, or the chance for a sudden death between the drawn teams.
end

function GAMEMODE:GameTypeThink()
  local endtime = GetGlobalFloat('EndTime', 64)

  local timeremaining = endtime - CurTime()

  if timeremaining <= 0 and self.RoundStatus != -1 then

    if self.RoundStatus == 0 then
      
      gamemode.Call('SetRoundStatus', 1, true) -- End Of Grace Period.
      SetGlobalFloat('EndTime', CurTime() + DM.RoundLength)

    elseif self.RoundStatus == 1 then

      local value, key = DetermineWinners(true)

      if istable(value) then -- If the game is tied, the 'value' variable is the table of teams.
        gamemode.Call('SetRoundStatus', 2, true) -- Round is then in Overtime
        SetGlobalFloat('EndTime', CurTime() + self.OverTime)
      else

      gamemode.Call('EndRound', key) -- Only one winner
      end
    end
  end
end
  
  function GAMEMODE:GameTypeDoPlayerDeath(pl, attacker, dmginfo)
  local targetscore = DM.KeyTarget
  local scorekey = DM.WinningKey

    pl.NextRespawn = CurTime() + 5
  
  
    if attacker:IsPlayer() and attacker:Team() != pl:Team() then
  
      local attackingteam = attacker:Team()
      local teaminfo = self.TeamInfos[attackingteam]
      teaminfo['Score'] = teaminfo['Score'] + 1
      self:TeamInfoUpdate(attackingteam, 'Score', teaminfo['Score'])
      if teaminfo.Score and teaminfo.Score >= targetscore then
        if pl:IsValid() then



          gamemode.Call('EndRound', attackingteam, {
            Enabled = true,
            Loc = pl:GetPos() + pl:GetViewOffset(),
            Rot = angle_zero,
            UsePlayerIncomingAngle = true,
            OrbitSpeed = 45,
            ArrivalTime = CurTime() + 2,
            Tolerance = 256
          })
        end
      end
    end
  end