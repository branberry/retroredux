function GM:RegisterClasses()
  for _, classFile in pairs(file.Find(GM.FolderName .. '/gamemode/classes/*.lua', 'LUA')) do
    include('classes/' .. classFile)
  end

  CLASSES['WARRIOR'] = WARRIOR
  CLASSES['MAGE'] = MAGE
  print('Classes registered')
end

GM:RegisterClasses()