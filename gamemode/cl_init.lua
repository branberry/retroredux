include("shared.lua")
include("vgui/class_select.lua")
include("vgui/spell_editor.lua")
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

function GM:HUDShouldDraw(name)
  return name ~= "CHudCrosshair" and name ~= "CHudHealth" and name ~= "CHudBattery" and name ~= "CHudAmmo" and name ~= "CHudSecondaryAmmo" and name ~= "CHudDamageIndicator"
end

surface.CreateFont("Teamplay", {font = "Arial", size = 10, weight = 0, antialias = false})