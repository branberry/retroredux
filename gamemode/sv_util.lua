function INC_SERVER()
  include('shared.lua')
  
  AddCSLuaFile('shared.lua')
  AddCSLuaFile('cl_init.lua')
end

GM.LerpTimeScale = {
  ShouldLerp = false,
  InitialScale = 0,
  TargetScale = 1,
  InitialTime = 0,
  FinishTime = 0
}

function CollectiveCameraLock(cameralockdata)
    local cld = cameralockdata
    if cld.Enabled then
      net.Start('nox_CameraLock')
        
      local loc = cld.Loc

    local x, y, z = loc:Unpack()

      local rot = cld.Rot
      local useincomingangle = cld.UsePlayerIncomingAngle
      local orbitspeed = cld.OrbitSpeed
      local arrivtime = cld.ArrivalTime
      local tol = cld.Tolerance
  
      net.WriteBool(true)
      -- net.WriteVector() imposes a possible imprecisision due to being 16-bits, so that might be an issue. Lets use net.WriteFloat.
      net.WriteFloat(x)
      net.WriteFloat(y)
      net.WriteFloat(z)

      net.WriteAngle(rot)
  
      net.WriteFloat(arrivtime)
      net.WriteFloat(orbitspeed)
      net.WriteBool(useincomingangle)
      net.WriteUInt(tol, 10)

      net.Broadcast()
    else
        net.Start('nox_CameraLock')
      net.WriteBool(false)
      net.Broadcast()
    end
  end

  function RetrievePostMapData()
    local data = file.Read('postmapdata.txt', false)
    datatbl = string.ToTable(data)
    return datatbl end

    function GM:TimeLerpTick() -- TODO: Move this to sv_util.lua. Fatass math-expressive piece of code.
      local lerptimeinfo = self.LerpTimeInfo
    
      local tf = lerptimeinfo["FinishTime"]
      local ti = lerptimeinfo["InitialTime"]
      local t = CurTime()
    
      local i = lerptimeinfo["InitialScale"]
      local o = lerptimeinfo["TargetScale"]
      local ponged = lerptimeinfo["Ponged"]
    
      if tf and ti and i and o then
        local timerange = tf - ti
        local timediff = t - ti
        local timeratio = math.min(1, timediff / timerange)
    
        local scalediff = o - i
    
        if timeratio < 1 then
          game.SetTimeScale((timeratio * scalediff) + i)
        else
          game.SetTimeScale(o)
    
          if ponged then
            game.SetTimeScale(1)
            table.Empty(self.LerpTimeInfo)
    
          elseif lerptimeinfo["HoldTime"] <= CurTime() then
    
            i = game.GetTimeScale()
            o = 1
            tf = CurTime() + 1
            ti = CurTime()
            ponged = true -- Brings the time scale back to normal, pardon the meaning "Pong".
    
            self.LerpTimeInfo = {
              ShouldLerp = true,
              InitialTime = ti,
              FinishTime = tf,
              InitialScale = i,
              TargetScale = o,
              Ponged = ponged
            }
          end
        end
      end
    
    end
