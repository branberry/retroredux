for _, classFile in pairs(file.Find(GM.FolderName .. '/gamemode/classes/*.lua', 'LUA')) do
  AddCSLuaFile('classes/' .. classFile)
end

AddCSLuaFile('shared.lua')
AddCSLuaFile('sh_colors.lua')
AddCSLuaFile('sh_globals.lua')
AddCSLuaFile('sh_register.lua')
AddCSLuaFile('obj_player_extend.lua')
AddCSLuaFile('vgui/class_select.lua')
AddCSLuaFile('vgui/team_select.lua')
AddCSLuaFile('vgui/gamestate.lua')
AddCSLuaFile('vgui/spell_editor.lua')
AddCSLuaFile("spells_init.lua")
AddCSLuaFile('cl_init.lua')


include('shared.lua')
include('sv_globals.lua')


function GM:Initialize()
self:SetupVars()
end

function GM:SetupVars()
SetGlobalFloat("EndTime", (CurTime() + DefaultRoundDuration))
end

function GM:InitPostEntity()
  self.Spawns = {}
  for i, v in pairs(TEAMS) do
  local validation = IsValid(TEAMS)
  local spawns = ents.FindByClass(v.SpawnEnt)
   if not table.IsEmpty(spawns) then

      table.insert(TEAMS_PLAYING, i)
      team.SetUp(table.KeyFromValue(TEAMS_PLAYING, i), v.Name, v.Color)
      self.Spawns[i] = spawns
      print("team " .. v.Name .. " successfully added!")
    end
  end
end

function GM:PlayerSelectSpawn(ply)
local teamid = ply:Team()
  if GAMEMODE.Spawns[teamid]  then
    local count = #GAMEMODE.Spawns[teamid] 
    for i=0, 15 do
  
    local chosenspawnpoint = GAMEMODE.Spawns[teamid][math.random(1, count)]
    if chosenspawnpoint and IsValid(chosenspawnpoint) and chosenspawnpoint:IsInWorld() then
      local blocked = false
      for i, ent in pairs(ents.FindInBox(chosenspawnpoint:GetPos() + Vector(-48, -48, 0), chosenspawnpoint:GetPos() + Vector(48, 48, 60))) do
        if ent:IsPlayer() or string.find(ent:GetClass(), "prop_") then
          blocked = true
          break
      end
    end
    if not blocked then
      return chosenspawnpoint
    end
  end
  if i == 15 then return ChosenSpawnPoint end
  return ply
  end
end
end

function GM:FullGameUpdate(pl) 
  pl:SendLua('TEAMS_PLAYING = {' .. table.concat(TEAMS_PLAYING, ',') .. '}')
  pl:ConCommand('nox_openteamselect')
end

local function TeamSelected(pl, cmd, tabargs, args)
local ans = tabargs[1]
print(ans)
pl:SetTeam(util.StringToType(ans, "int"))
pl:Spawn()
-- pl:Spawn()
end

function GM:RoundRestart()
end

function GM:ShowTeam(pl)
  print('F2 Pressed')
  pl:SendLua('DrawClassSelect()')
end

function GM:ShowSpare1(pl)
  pl:SendLua('CreateSpellMenu()')
end

function GM:PlayerInitialSpawn(pl)
  pl:SetNWString('PlayerClass', '')
  self:FullGameUpdate(pl)
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
concommand.Add('nox_teamswitch', TeamSelected)