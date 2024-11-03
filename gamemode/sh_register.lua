function GM:RegisterClasses()
  for _, classFile in pairs(file.Find(GM.FolderName .. '/gamemode/classes/*.lua', 'LUA')) do
    include('classes/' .. classFile)
    print(classFile)
  end

  CLASSES['WARRIOR'] = WARRIOR
  CLASSES['MAGE'] = MAGE
  print('Classes registered')
end

function GM:RegisterGameTypeConfigs()
  for _, config in pairs(file.Find(GM.FolderName .. '/gamemode/gametypes/*_config.lua', 'LUA')) do -- Loading only the config files. The config files are there to let the gamemode know things like the gametype names and descriptions without actually loading the whole gametype's behavior.
    include('gametypes/' .. config)
    AddCSLuaFile('gametypes/' .. config)
    print(config)
  end

  GAMETYPES["DM"] = DM
  GAMETYPES["CTF"] = CTF
  GAMETYPES["ASLT"] = ASLT
  GAMETYPES["BLTZ"] = BLTZ
  GAMETYPES["KOTH"] = KOTH
  GAMETYPES["JUGG"] = JUGG
  GAMETYPES["SIEG"] = SIEG
  GAMETYPES["AREN"] = AREN
  GAMETYPES["BR"] = BR
  GAMETYPES["ARCH"] = ARCH
  print("GameType Configs Registed")
end

GM:RegisterClasses()
GM:RegisterGameTypeConfigs()