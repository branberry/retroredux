function GM:RegisterGameType()
    local data = file.Read("postmapdata.lua", "DATA")
    local tbl = {}
    if data then
      tbl = util.JSONToTable(data, false, true)
    else

    local keys = table.GetKeys(GAMETYPES)

    tbl["gametype"] = keys[1]
    end
  
    if tbl["gametype"] then
  
      local gt = tbl["gametype"]
      local gtinfo = GAMETYPES[gt]
      local folder = GAMETYPES[gt]["Folder"]
      local name = gtinfo["GameTranslate"]
  
      self.GameType = gt

      include("retroredux/gamemode/gametypes/" .. folder .. "/init.lua")
      print("GameType " .. name .. " was selected and initiated.")
    end
  end

  function GM:RegisterHonorableMentionFunctions()
    for _, hm in pairs(file.Find(GM.FolderName .. '/gamemode/honorablementions/hm_*.lua', 'LUA')) do -- Honorable Mention functions
      include('honorablementions/' .. hm)
      print('honorablementions/' .. hm)
    end
  end

  GM:RegisterHonorableMentionFunctions()