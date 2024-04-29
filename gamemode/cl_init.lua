include("shared.lua")
include("vgui/class_select.lua")
include("vgui/spell_editor.lua")
local hud_NBarX = CreateClientConVar("nox_hud_nbar_x", 0, true, false)
local hud_NBarY = CreateClientConVar("nox_hud_nbar_y", 1, true, false)
local background = surface.GetTextureID("noxctf/bar_background")
local health_back = surface.GetTextureID("noxctf/health_bar_back")
local health_bar = surface.GetTextureID("noxctf/health_bar")
local COLOR_HEALTH = Color(240, 60, 60, 255)
local function drawHealth(x, y, health, maxhealth)
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

local function drawHUD()
  local pl = LocalPlayer()
  if not pl:Alive() then drawDeadHUD() end
  local className = pl:GetNWString('PlayerClass')
  if not className then return end
  local classInfo = CLASSES[className]
  if not classInfo then return end
  drawHealth(0, 0, pl:Health(), classInfo.Health)
end

function GM:HUDPaint()
  drawHUD()
end

function GM:HUDShouldDraw(name)
  return name ~= "CHudCrosshair" and name ~= "CHudHealth" and name ~= "CHudBattery" and name ~= "CHudAmmo" and name ~= "CHudSecondaryAmmo" and name ~= "CHudDamageIndicator"
end