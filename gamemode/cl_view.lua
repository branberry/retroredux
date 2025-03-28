function GM:CalcView(pl, origin, angles, fov)
    local cld = self.CameraLockData
    local angle_calc = angles
    local origin_calc = origin
    local fov_calc = fov
  
    if cld.Enabled then
    viewtbl = self:CameraLockCalcView()    
    origin_calc = viewtbl.origin
    angle_calc = viewtbl.angles
    fov_calc = viewtbl.fov
    end
  
    local teamselectoverride = self.TeamSelectOverrideView -- Team select overridden cinematic
    if self.PanelTeamSelect and self.PanelTeamSelect:IsValid() then
      if self.teamselectoverride then 
        local pos = teamselectoverride:GetPos()
        local rot = teamselectoverride:GetAngles()
        origin_calc = pos + (pos - original_calc)
        angle_calc = Add(rot + angle_calc)
  
      else 
        local pos = Vector(0, 0, 0)
        origin_calc = pos
        angle_calc = angle_zero
      end
    end
  
  return {origin = origin_calc, angles = angle_calc, fov = fov_calc, znear = 1, zfar = 50000, true} end
  
  function GM:CameraLockCalcView()
    local cld = self.CameraLockData
      local finalvect = vector_origin
      local finalangle = angle_zero
  
      if not cld.Orbiting then
        local loc = cld.Loc
        local iniloc = cld.IniLoc
        local rot = cld.Rot
        local inirot = cld.IniRot
  
        local direction = CalculateDirection3D(iniloc, loc)
  
        local initialtime = cld.InitialTime
        local arrivaltime = cld.ArrivalTime
        local tol = cld.Tolerance
        local diff = arrivaltime - initialtime
        local rat = math.min(1, (CurTime() - initialtime) / diff)
        finalangle = EaseDirection(inirot, direction, rat, 'InOutBack')
        finalvect = EaseVector(iniloc, loc, rat, 'InOutBack')
  
        if finalvect:Distance(loc) <= tol then
          cld['Orbiting'] = true
          cld['OrbitingRadius'] = tol
          cld['OrbitAngle'] = GetOrbitingAngle(finalvect, loc)
          --cld['OrbitAngle'] = 0
          cld['IniRot'] = finalangle
  
          self.CameraLockData = cld
        end
      else 
        local loc = cld.Loc
        local tol = cld.Tolerance
        local orbitang = cld['OrbitAngle']
        
        finalvect, finalangle = Orbit(loc, orbitang, tol)
        finalangle = finalangle
        orbitang = orbitang + (0.5 * game.GetTimeScale())
        cld['OrbitAngle'] = orbitang
        self.CameraLockData = cld
      end
      return {origin = finalvect, angles = finalangle, fov = 90} end

      function GM:HandleCameraLockData(camlockdata)
        local myself = LocalPlayer()
          self.CameraLockData = {
      
            Enabled = camlockdata.Enabled,
            Loc = camlockdata.Loc,
            IniLoc = myself:GetPos() + myself:GetViewOffset(),
            Rot = camlockdata.Rot,
            IniRot = myself:GetAngles(),
            EaseTime = 2,
            InitialTime = CurTime(),
            ArrivalTime = camlockdata.ArrivalTime,
            Tolerance = camlockdata.Tolerance
      
          }
      end

      local function HandleCameraLockWrap()
        local enabled = net.ReadBool()
        local CamLockData = {}
        if enabled then
          local x = net.ReadFloat()
          local y = net.ReadFloat()
          local z = net.ReadFloat()
          local angle = net.ReadAngle()
      
          local arrivtime = net.ReadFloat()
          local orbspeed = net.ReadFloat()
          local useincomingangle = net.ReadBool()
          local tol = net.ReadUInt(10)
          CamLockData = {
            Enabled = true,
            Loc = Vector(x, y, z),
            Rot = angle,
            ArrivalTime = arrivtime,
            OrbitSpeed = orbspeed,
            Tolerance = tol
          }
            if useincomingangle then
            
              local myself = LocalPlayer()
              CamLockData.Rot = CalculateDirection3D(myself:GetPos(), CamLockData.Loc)
            end
          else
            CamLockData = { -- Leave empty. if it isn't enabled, no value gets read.
            } 
          end
          gamemode.Call("HandleCameraLockData", CamLockData)
      end

      net.Receive('nox_CameraLock', HandleCameraLockWrap)