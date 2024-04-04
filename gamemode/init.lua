AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("vgui/class_select.lua")
AddCSLuaFile("sh_globals.lua")
function GM:ShowTeam(pl)
  print("F2 Pressed")
  pl:SendLua("DrawClassSelect()")
end

local function changeClass(sender, command, arguments)
  print("Change class")
  print(sender)
  sender:PrintMessage(HUD_PRINTTALK, "You are now a mage")
end

concommand.Add("cc_change_class", changeClass)