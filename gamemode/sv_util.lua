function INC_SERVER()
  include('shared.lua')
  
  AddCSLuaFile('shared.lua')
  AddCSLuaFile('cl_init.lua')
end

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
