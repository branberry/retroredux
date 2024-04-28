function GM:RegisterClasses()
  for _, classFile in pairs(file.Find(GM.FolderName .. '/gamemode/classes/*.lua', 'LUA')) do
    include('classes/' .. classFile)
  end

  table.insert(CLASSES, WARRIOR)
  table.insert(CLASSES, MAGE)
  print('Classes registered')
end

GM:RegisterClasses()