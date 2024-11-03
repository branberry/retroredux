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
      -- net.WriteVector() imposes a possible imprecisision that might be an issue. so lets use net.WriteFloat. We can revert this if it's too much.
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
