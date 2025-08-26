include('shared.lua')
include('cl_obj_player_extend.lua')

include('cl_globals.lua')
include('cl_util.lua')
include('cl_options.lua')

include('obj_player_extend.lua')
include('cl_spells_util.lua')
include('cl_register.lua')
include('cl_view.lua')
include('cl_music.lua')

include('vgui/class_select.lua')
include('vgui/team_select.lua')
include('vgui/spell_editor.lua')
include('vgui/buildmenu.lua')

include('vgui/spell_bar.lua')
include('vgui/spell_wheel.lua')
include('vgui/gamestate.lua')
include('vgui/dm_teamscore.lua')
include('vgui/roundresults.lua')
include('vgui/notifycenter.lua')
include('vgui/dch_melee1.lua')

include('cl_hud.lua')

include('vgui/statuseffectslayout.lua')

local SPELL_SLOTS = {}
model2 = nil
GM.TeamInfos = {}
GM.TeamSelectViewOverride = ents.FindByName('Map_CinematicCamera')

GM.GameType = ''

GM.SpellCooldowns = {}
function GM:Think()
  self:PlayerThink()
  --MUSIC:Tick()
end

function GM:PlayerThink()
  for i, v in ipairs(player.GetAll()) do
    v:Think()
  end
end

local function drawDeadHUD()

end

function GM:InitPostEntity()
  local myself = LocalPlayer()
  self.vgui_SpellLayout = vgui.Create('spell_bar')
end

 local function CreateTeamSelect()
  DrawTeamSelect()
end

function GM:SetupVGuiLayout()
  self.vgui_SELayout = vgui.Create('SEList')
end

function GM:HUDShouldDraw(name)
  return name ~= 'CHudCrosshair' and name ~= 'CHudHealth' and name ~= 'CHudBattery' and name ~= 'CHudAmmo' and name ~= 'CHudSecondaryAmmo' and name ~= 'CHudDamageIndicator'
end

function GM:CreateConCommands()
  concommand.Add('nox_openteamselect', DrawTeamSelect)
end

local function RecieveNoxTeamUpdate()
  local teamid = net.ReadUInt(4)
  local key = net.ReadString()
  local value = net.ReadInt(32)

  if GAMEMODE.TeamInfos[teamid] then
  GAMEMODE.TeamInfos[teamid][key] = value
  else
    table.insert(GAMEMODE.TeamInfos, teamid, {[key] = value})
    gamemode.Call('FixTeamColors')
  end
  if gt_ScoreUI then
    gt_ScoreUI:UpdateTeamInfo(teamid, key, value)
  end
end

net.Receive('NOX_TeamUpdate', RecieveNoxTeamUpdate)

local function HandlePlayerDeath()
  local pl = net.ReadPlayer()
  local attacker = net.ReadEntity()
  gamemode.Call('HandlePlayerDeath', pl, attacker)
end

local function HandleTeamPlayerSetup()
  local pl = net.ReadPlayer()
  if pl == LocalPlayer() then
    local pl = LocalPlayer()
    local teamid = TEAMS_PLAYING[pl:Team() + 1]
    local teamtbl = TEAMS[teamid]
    if teamtbl and teamtbl.DefMusic then
      --MUSIC:SetMusic(teamtbl['DefMusic'], 2)
    end
  end
end

function GM:PostDrawViewModel( vm, ply, weapon )

	if ( weapon.UseHands || !weapon:IsScripted() ) then

		local hands = LocalPlayer():GetHands()
		if ( IsValid( hands ) ) then hands:DrawModel() end

	end

end

function GM:Initialize()
  self:CreateConCommands()
  self:SetupVGuiLayout()
  timer.Simple(1, function()
  self:ModelCache() end)
end 

function GM:GameTypeInit()
end

function GM:InitializeGameType()

  local name = net.ReadString()
  self.GameType = name
  local gtinfo = GAMETYPES[name]
  local folder = gtinfo['Folder']

  include('retroredux/gamemode/gametypes/' .. folder .. '/cl_init.lua')
  self:GameTypeInit()
end

local function InitGameType() -- I have no idea why, but the self constant is lost when it's table (GM) is put in front of a function callback directly in the net library. Adding a local wrapper appears to fix this.
gamemode.Call("InitializeGameType")

end

function GM:ResetClassUI(args)
  local pl = LocalPlayer()
  if args['class'] then
    GAMEMODE.vgui_SpellLayout:ResetClassLayout(args['class'])
  end
end

local function HandleFloatingScore()
  local ent = net.ReadEntity()
  local type = net.ReadUInt(2)
  local amount = net.ReadUInt(16)

  if ent and ent:IsValid() then
    ent:FloatingScore(type, amount)
  end
end

function GM:CreateRoundResults()
  if not GAMEMODE.vgui_RoundResults then
  GAMEMODE.vgui_RoundResults = vgui.Create('RoundResults')
  GAMEMODE.vgui_RoundResults:Setup(self.RoundEndResults["Winner"])

  if self.RoundEndResults['Winner'] == LocalPlayer():Team() then
    gamemode.Call('SendCenterNotify', 'Your team has won!', 'DefaultFontMed', Color(0, 255, 0), 5, 'nox/flagcaptured.ogg', {})
  else
    gamemode.Call('SendCenterNotify', 'Your team has lost.', 'DefaultFontMed', Color(255, 0, 0), 5, 'nox/summonstart.ogg', {})
  end
  else
  GAMEMODE.vgui_RoundResults:Hide()
  end
end

function GM:SendCenterNotify(str, font, col, dietime, soundf, icontbl)
    CreateCenterNotice(str, font, col, dietime, soundf, icontbl)
end

function GM:RecieveRoundResults(winner)
self.RoundEndResults["Winner"] = winner
self:CreateRoundResults()
end

local function RecieveRoundResults()
local winner = net.ReadUInt(7)
gamemode.Call('RecieveRoundResults', winner)

end

function GM:GameTypeHandleRoundStatusUpdate(status, instant)
end

function GM:HandleRoundStatusUpdate()
  local status = net.ReadInt(8)
  local isinstant = net.ReadBool(instant)
  gamemode.Call('GameTypeHandleRoundStatusUpdate', status, isinstant)

  if status == -1 then
    if GAMEMODE.GameStatePanel then
      GAMEMODE.GameStatePanel:SetObjText('Ending Map...')
    end
  end
end

function GM:RecieveHonorableMention()
local mention = net.ReadUInt(6)
local pl = net.ReadPlayer()
local value = net.ReadInt(32)

  if GAMEMODE.vgui_RoundResults and GAMEMODE.vgui_RoundResults:IsValid() and pl and pl:IsValid() then
    GAMEMODE.vgui_RoundResults:AddHonorableMention(pl, mention, value)
  end
end
local function HandleSpellCast()
  local pl = net.ReadPlayer()
  local tbl = pl:GetTable()
  local spellindex = net.ReadUInt(8)

  local spellid = GetKeyFromIndex(SPELLS, spellindex)
  local spell = SPELLS[spellid]
  local spelltbl = SPELLS[spellid].TABLE

  pl:ExclaimSpellWords(spellid, 6)
    pl.SpellsActive[spellid] = table.Copy(spell['TABLEVARS'])
  if pl == LocalPlayer() then
    pl:SetSpellCooldown(spellid, spelltbl.Cooldown)
  end

  spelltbl:Init(pl)
end

function GM:OpenBuildMenu()
  if self.BuildMenu then
      self.BuildMenu:Open()
  else self.BuildMenu = vgui.Create('DBuildMenu') end
  end

local function HandleBuiltProp()
  local pl = net.ReadPlayer()
  local propindex = net.ReadUInt(8)
  local prop = net.ReadEntity()
  if pl == LocalPlayer() then
    surface.PlaySound("buttons/button14.wav")
  end
  if prop and prop:IsValid() then
    pl['UnfinishedProp'] = prop
    local propkey = GetKeyFromIndex(GAMEMODE.BuildProps, propindex)
    prop:SetProp(propkey)
    prop:Spawn()
  end
end


local function HandleStatusEffect()
  local pl = net.ReadEntity()
  local statusindex = net.ReadUInt(8)
  local host = net.ReadEntity()

  local key = GetKeyFromIndex(STATUS_EFFECTS, statusindex)
  local status = STATUS_EFFECTS[key]
  local statustbl = status.TABLE
  local statusvars = status.TABLEVARS

  local vartbl = {}

  if statusvars['Duration'] then 
    vartbl['Duration'] = net.ReadFloat() 
  end
  
  if statusvars['Effectiveness'] then 
    vartbl['Effectiveness'] = net.ReadFloat()
  end

  if statusvars['Frequency'] then 
    vartbl['Frequency'] = net.ReadFloat()
  end

  if pl:HasStatus(key) and statustbl.InitExists then

    statustbl:InitExists(pl, host, vartbl)
  elseif statustbl.Init then
    pl.StatusEffects[key] = table.Copy(statusvars)
    statustbl:Init(pl, host, vartbl)
  end
end

local function HandleClassChange()
  local newclass = net.ReadString()
  gamemode.Call('ResetClassUI', {class = newclass})
end

function GM:SetCrosshairMode(mode)
  crosshair:SwitchCrosshair(mode)
end

function GM:PlayerButtonDown(pl, button)
  local keyname = input.GetKeyName(button)
  if input.IsKeyDown(79) then 
    local keyname = '_' .. keyname
  end
  if GAMEMODE.SPELLBINDS_DEFAULT[keyname] then

    local slot = GAMEMODE.SPELLBINDS_DEFAULT[keyname]
    local spell = GAMEMODE.vgui_SpellLayout:GetSpellFromSlot(slot)
    local spellindex = GetKeyIndexFromTable(SPELLS, spell)

    if spellindex then
      local spellinfo = SPELLS[spell]
      local cooldown = pl.SpellCooldowns[spell]

      if not cooldown then
        net.Start('nox_CastSpell')
        net.WriteUInt(spellindex, 8)
        net.SendToServer()
      end
    end
  end
  local swep = pl:GetActiveWeapon()
  if swep and swep.ButtonDown then
    swep:ButtonDown(pl, button)
  end
end

  net.Receive('nox_GameTypeInit', InitGameType)

  net.Receive('nox_Death', HandlePlayerDeath)
  net.Receive('nox_PostResults', RecieveRoundResults)
  net.Receive('nox_PostHonorableMention', GM.RecieveHonorableMention)
  net.Receive('nox_RoundStatus', GM.HandleRoundStatusUpdate)

  net.Receive('nox_CastSpell', HandleSpellCast)

  net.Receive('nox_GiveStatus', HandleStatusEffect)

  net.Receive('FloatingScore', HandleFloatingScore)
  net.Receive('nox_ClassUpdate', HandleClassChange)
  net.Receive('nox_PlayerTeamSetup', HandleTeamPlayerSetup)
  net.Receive('nox_BuildProp', HandleBuiltProp)