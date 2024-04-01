AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("vgui/class_select.lua")
include("shared.lua")
function GM:ShowTeam(pl)
  print("F2 Pressed")
  pl:SendLua("DrawClassSelect()")
end