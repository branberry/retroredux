for _, classFile in pairs(file.Find(GM.FolderName .. '/gamemode/classes/*.lua', 'LUA')) do
  AddCSLuaFile('classes/' .. classFile)
end

AddCSLuaFile("shared.lua")
AddCSLuaFile("sh_globals.lua")
AddCSLuaFile("sh_register.lua")
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("vgui/class_select.lua")
AddCSLuaFile("vgui/spell_editor.lua")
function GM:ShowTeam(pl)
  print("F2 Pressed")
  pl:SendLua("DrawClassSelect()")
end

function GM:ShowSpare1(pl)
  pl:SendLua("CreateSpellMenu()")
end

function GM:PlayerSpawn(pl)
  pl:Give("weapon_magewand")
end

local function changeClass(sender, command, arguments)
  print("Change class")
  print(sender)
  sender:Spawn()
  sender:PrintMessage(HUD_PRINTTALK, "You are now a mage")
end

concommand.Add("cc_change_class", changeClass)