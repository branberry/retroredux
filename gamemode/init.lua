AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("vgui/class_select.lua")
include("shared.lua")
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