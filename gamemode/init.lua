for _, classFile in pairs(file.Find(GM.FolderName .. '/gamemode/classes/*.lua', 'LUA')) do
  AddCSLuaFile('classes/' .. classFile)
end

AddCSLuaFile('shared.lua')
AddCSLuaFile('sh_globals.lua')
AddCSLuaFile('sh_register.lua')
AddCSLuaFile('obj_player_extend.lua')
AddCSLuaFile('vgui/class_select.lua')
AddCSLuaFile('vgui/spell_editor.lua')
AddCSLuaFile("spells_init.lua")
AddCSLuaFile('cl_init.lua')
include('shared.lua')
function GM:ShowTeam(pl)
  print('F2 Pressed')
  pl:SendLua('DrawClassSelect()')
end

function GM:ShowSpare1(pl)
  pl:SendLua('CreateSpellMenu()')
end

function GM:PlayerInitialSpawn(pl)
  pl:SetNWString('PlayerClass', '')
end

function GM:PlayerSpawn(pl)
  print('player spawned')
  if pl:GetPlayerClass() == 'MAGE' then pl:Give('weapon_magewand') end
end

local function changeClass(sender, command, arguments)
  print('Change class')
  local className = string.upper(arguments[1])
  local classInfo = CLASSES[className]
  sender:SetPlayerClass(className)
  sender:RemoveAllItems()
  sender:Spawn()
  sender:SetHealth(classInfo.Health)
  print(classInfo.Mana)
  sender:SetMana(classInfo.Mana)
  sender:SetMaxMana(classInfo.Mana)
  sender:SetManaRegeneration(classInfo.ManaRegeneration)
  local class = arguments[1]
  sender:PrintMessage(HUD_PRINTTALK, 'You are now a ' .. class)
end

local function cast(sender, command, arguments)
  local spellName = arguments[1]
  if not spellName then return end
  if not sender:Alive() then return end
  if sender:IsFrozen() then return end
  print('casting spell... ' .. spellName)
  local spellInfo = SPELLS[spellName]
  local spellFunction = spellInfo.Func
  local curMana = sender:GetMana()
  print('cur curMana', curMana)
  print('cost', spellInfo.Cost)
  if spellInfo.Cost > curMana then
    print('out of mana')
    return
  end

  sender:SetMana(curMana - spellInfo.Cost)
  spellFunction(sender)
end

concommand.Add('cc_change_class', changeClass)
concommand.Add('cast', cast)