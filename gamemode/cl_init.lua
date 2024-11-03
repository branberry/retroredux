include("shared.lua")
include("vgui/class_select.lua")
include("vgui/team_select.lua")
include("vgui/spell_editor.lua")
include("vgui/gamestate.lua")
local SPELL_SLOTS = {}
local hud_NBarX = CreateClientConVar('nox_hud_nbar_x', 0, true, false)
local hud_NBarY = CreateClientConVar('nox_hud_nbar_y', 1, true, false)
local background = surface.GetTextureID('noxctf/bar_background')
local health_back = surface.GetTextureID('noxctf/health_bar_back')
local health_bar = surface.GetTextureID('noxctf/health_bar')
local mana_back = surface.GetTextureID('noxctf/mana_bar_back')
local mana_bar = surface.GetTextureID('noxctf/mana_bar')
local hud_SpellMenuX = CreateClientConVar('nox_hud_spellmenu_x', 0.85, true, false)
local hud_SpellMenuY = CreateClientConVar('nox_hud_spellmenu_y', 0.7, true, false)
local COLOR_HEALTH = Color(240, 60, 60, 255)
local COLOR_MANA = Color(144, 210, 248, 255)
surface.CreateFont("DefaultFontSmall", {
  font = "Arial",
  extended = true,
  size = 14
})

surface.CreateFont("DefaultFontMed", {
  font = "Arial",
  extended = true,
  size = 32
})

local function drawMana(mana, maxMana)
  local w, h = ScrW(), ScrH()
  local curX = hud_NBarX:GetFloat() * w
  local curY = hud_NBarY:GetFloat() * h
  local screens = math.min(1, ((w / 3640) + 0.5) ^ 2) --BetterScreenScale()
  local imagesizey = 128 * screens
  local imagesizex = 512 * screens
  surface.SetDrawColor(255, 255, 255, 255)
  surface.SetTexture(mana_back)
  surface.DrawTexturedRect(curX, curY - imagesizey, imagesizex, imagesizey)
  surface.SetTexture(mana_bar)
  if mana < maxMana * 0.25 then
    COLOR_HEALTH.a = 255 - math.abs(math.sin(RealTime() * 4)) * 160
    surface.SetDrawColor(COLOR_HEALTH)
  end

  surface.DrawTexturedRectUV(curX + (imagesizex / 8), curY - imagesizey, curX + (imagesizex / 1.45868945869) * (mana / maxMana), imagesizey, 0.125, 0, 0.125 + 0.685546875 * (mana / maxMana), 1)
  draw.SimpleTextOutlined(math.floor(mana), 'CloseCaption_Bold', 25 * screens + curX, curY - 68 * screens, COLOR_MANA, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0, 0, 0, 255))
end

local function drawHealth(health, maxhealth)
  local w, h = ScrW(), ScrH()
  local curX = hud_NBarX:GetFloat() * w
  local curY = hud_NBarY:GetFloat() * h
  local screens = math.min(1, ((w / 3640) + 0.5) ^ 2) --BetterScreenScale()
  local imagesizey = 128 * screens
  local imagesizex = 512 * screens
  surface.SetDrawColor(255, 255, 255, 255)
  surface.SetTexture(background)
  surface.DrawTexturedRect(curX, curY - imagesizey, imagesizex, imagesizey)
  surface.SetTexture(health_back)
  surface.DrawTexturedRect(curX, curY - imagesizey, imagesizex, imagesizey)
  if health < maxhealth * 0.25 then
    COLOR_HEALTH.a = 255 - math.abs(math.sin(RealTime() * 4)) * 160
    surface.SetDrawColor(COLOR_HEALTH)
  end

  surface.SetTexture(health_bar)
  surface.DrawTexturedRectUV(curX + (imagesizex * 0.185546875), curY - imagesizey, curX + (imagesizex / 1.38378378378) * (health / maxhealth), imagesizey, 0.185546875, 0, 0.185546875 + 0.72265625 * (health / maxhealth), 1)
  draw.SimpleTextOutlined(health, 'CloseCaption_Bold', 43 * screens + curX, curY - 33 * screens, COLOR_HEALTH, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0, 0, 0, 255))
end

local function drawDeadHUD()
end

hook.Add('PlayerBindPress', 'handle_key_press', function(ply, bind, pressed, code)
  if code == KEY_1 then
    local spellName = SPELL_SLOTS[code]
    RunConsoleCommand('cast', spellName)
  end
end)

local function drawSpells(classSpells)
  local w, h = ScrW(), ScrH()
  for i = 1, #classSpells do
    -- Key codes are sequential, and for key number 1, the code is 2 (and for key number 2, the code is 3 etc.)
    -- This is A temporary solution
    -- probably could create list with all valid keycodes at some point e.g. codes = {KEY_1, KEY_2, etc}
    local spellName = classSpells[i]
    local spellInfo = SPELLS[spellName]
    if not spellInfo then return end
    local keyCode = i + 1
    SPELL_SLOTS[keyCode] = spellName
    local size = ScreenScale(16)
    local dX = w * hud_SpellMenuX:GetFloat()
    local dY = h * hud_SpellMenuY:GetFloat()
    surface.SetDrawColor(255, 255, 255, 255)
    surface.SetMaterial(Material(spellInfo.Icon), 'smooth')
    surface.DrawTexturedRect(dX, dY, size, size)
    draw.SimpleTextOutlined(i, 'CloseCaption_Bold', dX, dY, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0, 0, 0, 255))
  end
end

local function drawHUD()
  local pl = LocalPlayer()
  if not pl:Alive() then drawDeadHUD() end
  local className = pl:GetPlayerClass()
  if not className or className == '' then return end
  local classInfo = CLASSES[className]
  if classInfo.Spells then drawSpells(classInfo.Spells) end
  if not classInfo then return end
  drawHealth(pl:Health(), classInfo.Health)
  if classInfo.Mana then drawMana(pl:GetMana(), classInfo.Mana) end
end

function GM:HUDPaint()
  drawHUD()
end

function GM:CreateVGUI()
  if not GameStatePanel then self.GameStatePanel = vgui.Create('GameState') end
end

local function CreateTeamSelect()
  DrawTeamSelect()
end

local function CreateTeamSelect()
  DrawTeamSelect()
end

function GM:HUDShouldDraw(name)
  return name ~= 'CHudCrosshair' and name ~= 'CHudHealth' and name ~= 'CHudBattery' and name ~= 'CHudAmmo' and name ~= 'CHudSecondaryAmmo' and name ~= 'CHudDamageIndicator'
end

function GM:CreateConCommands()
end

concommand.Add('nox_openteamselect', DrawTeamSelect)
net.Receive('NOX_TeamUpdate', function()
  local teamid = net.ReadUInt(4)
  local key = net.ReadString()
  local value = net.ReadInt(32)
  if TeamInfos[teamid] then
    TeamInfos[teamid][key] = value
  else
    table.insert(TeamInfos, teamid, {
      [key] = value
    })
  end

  if gt_ScoreUI then gt_ScoreUI:UpdateTeamInfo(teamid, key, value) end
end)

local function SetupCVars()
end

local function SetupVariables()
  CS_RAGS = {} -- clientside ragdolls using ClientsideRagdoll() must be referenced anyway or else we can't get rid of them.
  TeamInfos = {}
end

local function HandlePlayerDeath()
  local pl = net.ReadPlayer()
  local attacker = net.ReadEntity()
  gamemode.Call('HandlePlayerDeath', pl, attacker)
end

local function HandlePlayerSpawn()
  local pl = net.ReadEntity()
  local csrag = pl.CSRag
  if csrag and csrag:IsValid() then
    csrag:Remove()
    csrag = nil
  elseif not csrag then
    csrag = nil
  end

  pl.CSRag = csrag
  local myself = LocalPlayer()
end

function GM:CalcView(pl, origin, angles, fov)
  local cld = self.CameraLockData
  local angle_calc = angles
  local origin_calc = origin
  local fov_calc = fov
  if cld.Enabled then
    viewtbl = self:CameraLockCalcView()
    origin_calc = viewtbl.origin
    angle_calc = viewtbl.angles
    fov_calc = viewtbl.fov
  end
  return {
    origin = origin_calc,
    angles = angle_calc,
    fov = fov_calc,
    znear = 1,
    zfar = 50000,
    true
  }
end

function GM:CameraLockCalcView()
  local cld = self.CameraLockData
  local finalvect = vector_origin
  local finalangle = angle_zero
  if not cld.Orbiting then
    local loc = cld.Loc
    local iniloc = cld.IniLoc
    local rot = cld.Rot
    local inirot = cld.IniRot
    local direction = CalculateDirection3D(iniloc, loc)
    local initialtime = cld.InitialTime
    local arrivaltime = cld.ArrivalTime
    local tol = cld.Tolerance
    local diff = arrivaltime - initialtime
    local rat = math.min(1, (CurTime() - initialtime) / diff)
    finalangle = EaseDirection(inirot, direction, rat, 'InOutBack')
    finalvect = EaseVector(iniloc, loc, rat, 'InOutBack')
    if finalvect:Distance(loc) <= tol then
      cld['Orbiting'] = true
      cld['OrbitingRadius'] = tol
      cld['OrbitAngle'] = GetOrbitingAngle(finalvect, loc)
      --cld['OrbitAngle'] = 0
      cld['IniRot'] = finalangle
      self.CameraLockData = cld
    end
  else
    local loc = cld.Loc
    local tol = cld.Tolerance
    local orbitang = cld['OrbitAngle']
    finalvect, finalangle = Orbit(loc, orbitang, tol)
    finalangle = finalangle
    orbitang = orbitang + (0.5 * game.GetTimeScale())
    cld['OrbitAngle'] = orbitang
    self.CameraLockData = cld
  end
  return {
    origin = finalvect,
    angles = finalangle,
    fov = 90
  }
end

function GM:Initialize()
  self:CreateConCommands()
  SetupCVars()
  SetupVariables()
  self:SendCenterNotify('Test Test One', color_white, 4, '')
  self:SendCenterNotify('Test Test Two', color_white, 4, '')
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

function GM:HandleCameraLockData(camlockdata)
  local myself = LocalPlayer()
  self.CameraLockData = {
    Enabled = camlockdata.Enabled,
    Loc = camlockdata.Loc,
    IniLoc = myself:GetPos() + myself:GetViewOffset(),
    Rot = camlockdata.Rot,
    IniRot = myself:GetAngles(),
    EaseTime = 2,
    InitialTime = CurTime(),
    ArrivalTime = camlockdata.ArrivalTime,
    Tolerance = camlockdata.Tolerance
  }
end

local function HandleCameraLockWrap()
  local enabled = net.ReadBool()
  local CamLockData = {}
  if enabled then
    local x = net.ReadFloat()
    local y = net.ReadFloat()
    local z = net.ReadFloat()
    local angle = net.ReadAngle()
    local arrivtime = net.ReadFloat()
    local orbspeed = net.ReadFloat()
    local useincomingangle = net.ReadBool()
    local tol = net.ReadUInt(10)
    CamLockData = {
      Enabled = true,
      Loc = Vector(x, y, z),
      Rot = angle,
      ArrivalTime = arrivtime,
      OrbitSpeed = orbspeed,
      Tolerance = tol
    }

    if useincomingangle then
      local myself = LocalPlayer()
      CamLockData.Rot = CalculateDirection3D(myself:GetPos(), CamLockData.Loc)
    end
  else
    CamLockData = {} -- Leave empty. if it isn't enabled, no value gets read.
  end

  gamemode.Call("HandleCameraLockData", CamLockData)
end

function GM:CreateRoundResults()
  if not vgui_RoundResults then
    vgui_RoundResults = vgui.Create('RoundResults')
    vgui_RoundResults:Setup(self.RoundEndResults["Winner"])
  else
    vgui_RoundResults:Hide()
  end
end

function GM:SendCenterNotify(str, col, dietime, soundf)
  if not vgui_NotifyCenter then
    vgui_NotifyCenter = vgui.Create('NotifyCenter')
    vgui_NotifyCenter:CreateCenterNotice(str, col, dietime, soundf)
  else
    vgui_NotifyCenter:CreateCenterNotice(str, col, dietime, soundf)
  end
end

function GM:RecieveRoundResults(winner)
  self.RoundEndResults["Winner"] = winner
  self:CreateRoundResults()
end

local function RecieveRoundResults()
  local winner = net.ReadUInt(7)
  print(winner)
  gamemode.Call('RecieveRoundResults', winner)
end

function GM:RecieveHonorableMention()
  local mention = net.ReadUInt(6)
  local pl = net.ReadPlayer()
  local value = net.ReadInt(32)
  if vgui_RoundResults and vgui_RoundResults:IsValid() and pl and pl:IsValid() then vgui_RoundResults:AddHonorableMention(pl, mention, value) end
end

net.Receive('nox_CameraLock', HandleCameraLockWrap)
net.Receive('nox_GameTypeInit', InitGameType)
net.Receive('nox_Death', HandlePlayerDeath)
net.Receive('nox_Spawn', HandlePlayerSpawn)
net.Receive('nox_PostResults', RecieveRoundResults)
net.Receive('nox_PostHonorableMention', GM.RecieveHonorableMention)