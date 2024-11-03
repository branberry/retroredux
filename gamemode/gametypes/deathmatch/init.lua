AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")
function GAMEMODE:GameTypeInit()
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