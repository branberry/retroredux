include("shared.lua")
include("cl_util.lua")

include("vgui/class_select.lua")
include("vgui/team_select.lua")
include("vgui/spell_editor.lua")
include("vgui/gamestate.lua")
include("vgui/dm_teamscore.lua")

TeamInfos = {}

local SPELL_SLOTS = {}
local hud_NBarX = CreateClientConVar("nox_hud_nbar_x", 0, true, false)
local hud_NBarY = CreateClientConVar("nox_hud_nbar_y", 1, true, false)
local background = surface.GetTextureID("noxctf/bar_background")
local health_back = surface.GetTextureID("noxctf/health_bar_back")
local health_bar = surface.GetTextureID("noxctf/health_bar")
local mana_back = surface.GetTextureID("noxctf/mana_bar_back")
local mana_bar = surface.GetTextureID("noxctf/mana_bar")
local hud_SpellMenuX = CreateClientConVar("nox_hud_spellmenu_x", 0.85, true, false)
local hud_SpellMenuY = CreateClientConVar("nox_hud_spellmenu_y", 0.7, true, false)
local COLOR_HEALTH = Color(240, 60, 60, 255)
local COLOR_MANA = Color(144, 210, 248, 255)
surface.CreateFont("DefaultFontSmall", {font = "Arial", extended = true, size = 14})
surface.CreateFont("DefaultFontMed", {font = "Arial", extended = true, size = 32})
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
  draw.SimpleTextOutlined(math.floor(mana), "CloseCaption_Bold", 25 * screens + curX, curY - 68 * screens, COLOR_MANA, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0, 0, 0, 255))
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
  draw.SimpleTextOutlined(health, "CloseCaption_Bold", 43 * screens + curX, curY - 33 * screens, COLOR_HEALTH, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0, 0, 0, 255))
end


local function drawDeadHUD()
end

hook.Add("PlayerBindPress", "handle_key_press", function(ply, bind, pressed, code)
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
  if !GameStatePanel then
    GameStatePanel = vgui.Create('GameState')
  end

  if !gt_ScoreUI then
    gt_ScoreUI = vgui.Create('DM_TeamScore')
  end
end

 local function CreateTeamSelect()
  DrawTeamSelect()
end

function GM:HUDShouldDraw(name)
  return name ~= "CHudCrosshair" and name ~= "CHudHealth" and name ~= "CHudBattery" and name ~= "CHudAmmo" and name ~= "CHudSecondaryAmmo" and name ~= "CHudDamageIndicator"
end

function GM:CreateConCommands()
end

concommand.Add("nox_openteamselect", DrawTeamSelect)

net.Receive("NOX_TeamUpdate", function()
  local teamid = net.ReadUInt(4)
  local key = net.ReadString()
  local value = net.ReadInt(32)

  if TeamInfos[teamid] then
  TeamInfos[teamid][key] = value
  else
    table.insert(TeamInfos, teamid, {[key] = value})
  end
  if gt_ScoreUI then
    gt_ScoreUI:UpdateTeamInfo(teamid, key, value)
  end
end)

local function SetupCVars()
  nox_maxcsrags = CreateClientConVar( "nox_maxcsrags", 8, true, false, "How many clientside ragdolls can be generated at once. Does not include your ragdoll.", 2, 127)
  

end

local function SetupVariables()
  CS_RAGS = {} -- clientside ragdolls using ClientsideRagdoll() must be referenced anyway or else we can't get rid of them.
  TeamInfos = {}
end

local function HandlePlayerDeath()
  local pl = net.ReadEntity()
  local attacker = net.ReadEntity()
  local dmginfo = net.ReadEntity()
  if pl and pl:IsValid() then

    if pl.CSRag and not pl.CSRag:IsValid() then

        local rag = CreateCSRagdoll(pl)

    elseif not pl.CSRag then

      local rag = CreateCSRagdoll(pl)
    end
  end

pl.CSRag = rag
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

end



function GM:Initialize()
  self:CreateVGUI()
  self:CreateConCommands()
  
  SetupCVars()
  SetupVariables()
  end  

  net.Receive("nox_Death", HandlePlayerDeath)
  net.Receive("nox_Spawn", HandlePlayerSpawn)
