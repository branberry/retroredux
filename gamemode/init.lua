for _, classFile in pairs(file.Find(GM.FolderName .. '/gamemode/classes/*.lua', 'LUA')) do
  AddCSLuaFile('classes/' .. classFile)
end

AddCSLuaFile('shared.lua')
AddCSLuaFile('sh_colors.lua')
AddCSLuaFile('sh_globals.lua')
AddCSLuaFile('sh_register.lua')
AddCSLuaFile('sh_util.lua')
AddCSLuaFile('obj_player_extend.lua')
AddCSLuaFile('spells_init.lua')
AddCSLuaFile('cl_globals.lua')
AddCSLuaFile('cl_util.lua')
AddCSLuaFile('cl_init.lua')
AddCSLuaFile('cl_options.lua')
AddCSLuaFile('vgui/class_select.lua')
AddCSLuaFile('vgui/team_select.lua')
AddCSLuaFile('vgui/gamestate.lua')
AddCSLuaFile('vgui/spell_editor.lua')
AddCSLuaFile('vgui/dm_teamscore.lua')
AddCSLuaFile('vgui/roundresults.lua')
AddCSLuaFile('vgui/notifycenter.lua')
include('shared.lua')
include('sv_globals.lua')
include('sv_register.lua')
include('sv_util.lua')
util.AddNetworkString('nox_TeamUpdate')
util.AddNetworkString('nox_RoundStatus')
util.AddNetworkString('nox_GameTypeInit')
util.AddNetworkString('nox_EndRound')
util.AddNetworkString('nox_PostResults')
util.AddNetworkString('nox_CameraLock')
util.AddNetworkString('nox_PostHonorableMention')
util.AddNetworkString('nox_Death')
util.AddNetworkString('nox_Spawn')
GM.LerpTimeScale = {
  ShouldLerp = false,
  InitialScale = 0,
  TargetScale = 1,
  InitialTime = 0,
  FinishTime = 0
}

function GM:Initialize()
  self:SetupVars()
  gamemode.Call('EndRound', 1, {})
end

function GM:SetupVars()
  SetGlobalFloat('EndTime', CurTime() + DefaultRoundDuration)
end

function GM:SetupPlayerVars(pl)
  pl.RoundStats = {}
end

function GM:InitPostEntity()
  self.Spawns = {}
  self.TeamInfos = {}
  for i, v in pairs(TEAMS) do
    local validation = IsValid(TEAMS)
    local spawns = ents.FindByClass(v.SpawnEnt)
    if not table.IsEmpty(spawns) then
      local teamindex = table.insert(TEAMS_PLAYING, i)
      team.SetUp(table.KeyFromValue(TEAMS_PLAYING, i), v.Name, v.Color)
      self.Spawns[teamindex] = spawns
      table.insert(self.TeamInfos, teamindex, {
        Score = 0
      })

      print('team ' .. v.Name .. ' successfully added!')
    end
  end
end

function GM:PlayerSelectSpawn(ply)
  local teamid = ply:Team()
  if GAMEMODE.Spawns[teamid] then
    local count = #GAMEMODE.Spawns[teamid]
    for i = 0, 15 do
      local chosenspawnpoint = GAMEMODE.Spawns[teamid][math.random(1, count)]
      if chosenspawnpoint and IsValid(chosenspawnpoint) and chosenspawnpoint:IsInWorld() then
        local blocked = false
        for i, ent in pairs(ents.FindInBox(chosenspawnpoint:GetPos() + Vector(-48, -48, 0), chosenspawnpoint:GetPos() + Vector(48, 48, 60))) do
          if ent:IsPlayer() or string.find(ent:GetClass(), 'prop_') then
            blocked = true
            break
          end
        end

        if not blocked then return chosenspawnpoint end
      end

      if i == 15 then return ChosenSpawnPoint end
      return ply
    end
  end
end

local function TeamSelected(pl, cmd, tabargs, args)
  local ans = tabargs[1]
  local int = util.StringToType(ans, 'int')
  if team.Valid(int) then
    pl:SetTeam(int)
    pl:Spawn()
  end
end

function GM:FullGameUpdate(pl)
  pl:SendLua('TEAMS_PLAYING = {' .. table.concat(TEAMS_PLAYING, ',') .. '}')
  net.Start("nox_GameTypeInit")
  net.WriteString(self.GameType)
  net.Send(pl)
  for i, v in pairs(TEAMS_PLAYING) do
    for key, value in pairs(self.TeamInfos[i]) do
      net.Start('nox_TeamUpdate')
      net.WriteUInt(i, 4)
      net.WriteString(key)
      net.WriteInt(value, 32)
      net.Send(pl)
    end
  end

  local teams = team.GetAllTeams()
  if not pl:IsBot() then
    pl:ConCommand('nox_openteamselect')
  else
    TeamSelected(pl, 'nox_teamswitch', {'' .. math.random(1, #teams)})
    pl:SetPlayerClass(table.Random(table.GetKeys(CLASSES)))
  end
end

function GM:RoundRestart()
end

function GM:PlayerDeathThink(pl)
  local nextrespawn = pl.NextRespawn
  if not pl:IsBot() and nextrespawn and nextrespawn <= CurTime() and pl:KeyDown(IN_ATTACK) then
    pl:Spawn()
  elseif pl:IsBot() and nextrespawn and nextrespawn <= CurTime() then
    pl:Spawn()
  end
end

function GM:TeamInfoUpdate(teamid, key, value)
  net.Start('nox_TeamUpdate')
  net.WriteUInt(teamid, 4)
  net.WriteString(key)
  net.WriteInt(value, 32)
  net.Broadcast()
end

function GM:Think()
  if self.RoundStatus == -1 then self:EndRoundThink() end
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
  self:SetupPlayerVars(pl)
end

function GM:PlayerSpawn(pl)
  print('player spawned')
  pl.NextRespawn = nil
  if pl:GetPlayerClass() == 'MAGE' then pl:Give('weapon_magewand') end
  local classtbl = CLASSES[pl:GetPlayerClass()]
  if classtbl then pl:SetModel(classtbl['Model']) end
  local teamid = TEAMS_PLAYING[pl:Team()]
  local teaminfo = TEAMS[teamid]
  if teamid and teaminfo then
    local teamcolor = teaminfo['Color']
    if teamcolor then
      if classtbl and not classtbl.ColorOverall then
        pl:SetColor(color_white)
        pl:SetPlayerColor(Vector(teamcolor.r / 255, teamcolor.g / 255, teamcolor.b / 255))
      else
        pl:SetColor(teamcolor)
      end
    end
  end

  net.Start('Nox_Spawn')
  net.WriteEntity(pl)
  net.Broadcast()
end

function GM:EndRound(WinningIndex, CameraLockdata)
  self.RoundEndResults = {
    EndTime = CurTime(),
    CameraLockEnd = CurTime() + 5,
    Winner = WinningIndex
  }

  self.LerpTimeInfo = {
    ShouldLerp = true,
    InitialTime = CurTime(),
    FinishTime = CurTime() + 1,
    InitialScale = game.GetTimeScale(),
    TargetScale = 0.1,
    HoldTime = CurTime() + 1.4,
    Ponged = false
  }

  self.RoundStatus = -1 -- Indicates the round has ended.
  CollectiveCameraLock(CameraLockdata)
end

function GM:TimeLerpTick() -- TODO: Move this to sv_util.lua. Fatass math-expressive piece of code.
  local lerptimeinfo = self.LerpTimeInfo
  local tf = lerptimeinfo["FinishTime"]
  local ti = lerptimeinfo["InitialTime"]
  local t = CurTime()
  local i = lerptimeinfo["InitialScale"]
  local o = lerptimeinfo["TargetScale"]
  local ponged = lerptimeinfo["Ponged"]
  if tf and ti and i and o then
    local timerange = tf - ti
    local timediff = t - ti
    local timeratio = math.min(1, timediff / timerange)
    local scalediff = o - i
    if timeratio < 1 then
      game.SetTimeScale((timeratio * scalediff) + i)
    else
      game.SetTimeScale(o)
      if ponged then
        game.SetTimeScale(1)
        table.Empty(self.LerpTimeInfo)
      elseif lerptimeinfo["HoldTime"] <= CurTime() then
        i = game.GetTimeScale()
        o = 1
        tf = CurTime() + 1
        ti = CurTime()
        ponged = true -- Brings the time scale back to normal, pardon the meaning "Pong".
        self.LerpTimeInfo = {
          ShouldLerp = true,
          InitialTime = ti,
          FinishTime = tf,
          InitialScale = i,
          TargetScale = o,
          Ponged = ponged
        }
      end
    end
  end
end

function GM:PostEndResults()
  local results = self.RoundEndResults
  net.Start('nox_PostResults')
  net.WriteUInt(results.Winner, 7)
  net.Broadcast()
  self:ProcessHonorableMentions()
end

function GM:ProcessHonorableMentions()
  self.ValidHMs = {}
  for i, v in pairs(HONORABLE_MENTIONS) do
    if v.Func then
      local hmtbl = HONORABLE_MENTIONS_FUNCS[v.Func]() -- Calls the function which determines the outcome of the honorable mention.
      if hmtbl then
        hmtbl['MentionIndex'] = i
        self.HonorableMentions[i] = hmtbl
        table.insert(self.ValidHMs, i)
      end
    end
  end

  self.CurrentHM = 1
  self.NextHM = CurTime()
  self.SendingHMs = true
end

function GM:PostHonorableMention()
  local validhm = self.CurrentHM
  local hms = self.ValidHMs
  local hmindex = hms[validhm]
  if hmindex then
    local hmtbl = self.HonorableMentions[hmindex]
    local pl = hmtbl.Player
    local mention = hmtbl.MentionIndex
    local value = hmtbl.Value
    net.Start('nox_PostHonorableMention')
    net.WriteUInt(mention, 6)
    net.WritePlayer(pl)
    net.WriteInt(value, 32) -- Honorable mentions are typically measurable in some way, so in theory it should only depend on a single number that we can send. We'll keep these set of vars constant for now.
    net.Broadcast()
    self.CurrentHM = self.CurrentHM + 1 -- Prevents a Net Buffer Overflow (which is rare) by only sending a couple honorable mentions within a second, incase we add lots of potential honorable mentions. Also adds a bit of life to the UI.
    self.NextHM = CurTime() + 0.5
  else
    self.SendingHMs = false
  end
end

function GM:EndRoundThink()
  local roundresult = self.RoundEndResults
  local cameralockend = roundresult['CameraLockEnd']
  if self.LerpTimeInfo['ShouldLerp'] then self:TimeLerpTick() end
  if self.SendingHMs and self.NextHM < CurTime() then self:PostHonorableMention() end
  if cameralockend and cameralockend <= CurTime() then
    net.Start('nox_CameraLock')
    net.WriteBool(false)
    net.Broadcast()
    roundresult['CameraLockEnd'] = nil
    self.RoundEndResult = roundresult
    self:PostEndResults()
  end
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
function GM:GameTypeInit()
end

function GM:GameTypeThink()
end

function GM:GameTypeDoPlayerDeath()
end

function GM:DoPlayerDeath(pl, attacker, dmginfo)
  pl:CreateRagdoll()
  net.Start('nox_Death')
  net.WritePlayer(pl)
  net.WriteEntity(attacker)
  net.Broadcast()
  local roundstats = attacker.RoundStats
  local kills = roundstats['MeleeKills']
  if kills then
    kills = kills + 1
  else
    attacker.RoundStats['MeleeKills'] = 1
  end

  print(attacker['MeleeKills'])
  self:GameTypeDoPlayerDeath(pl, attacker, dmginfo)
end

function GM:OnGamemodeLoaded()
  self:RegisterGameType()
  self:GameTypeInit()
  net.Start("nox_GameTypeInit")
  net.WriteString(GAMEMODE.GameType)
  net.Broadcast() --Incase players join before the gamemode was loaded
end

function GM:PlayerNoClip(pl, state)
  --if pl:IsAdmin() then -- REMOVE COMMENT WHEN NO LONGER DEBUGGING
  return true
  --else return false end
end