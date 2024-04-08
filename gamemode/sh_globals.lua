CC_CHANGE_CLASS = 'cc_change_class'
CLASSES = {}
print(#file.Find(GM.FolderName .. '/gamemode/classes/*.lua', 'LUA'))
for _, classFile in pairs(file.Find(GM.FolderName .. '/gamemode/*.lua', 'LUA')) do
  print(classFile)
  -- local class = require('classes/' .. classFile)
  -- print(class)
end