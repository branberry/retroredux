function GM:RegisterClasses()
  for _, class in pairs(file.Find(GM.FolderName .. '/gamemode/classes/*.lua', 'LUA')) do
    include('classes/' .. class)
    print('hello')
  end
end

GM:RegisterClasses()