surface.CreateFont('DefaultFontMini', {font = 'Arial', extended = true, size = 14})
surface.CreateFont('DefaultFontSmall', {font = 'Arial', extended = true, size = 18})
surface.CreateFont('DefaultFontMed', {font = 'Arial', extended = true, size = 32})
surface.CreateFont('DefaultFontLarge', {font = 'Arial', extended = true, size = 64})
surface.CreateFont('DefaultFontVeryLarge', {font = 'Arial', extended = true, size = 92})

local hud_NBarX = CreateClientConVar('nox_hud_nbar_x', 0, true, false)
local hud_NBarY = CreateClientConVar('nox_hud_nbar_y', 1, true, false)
local hud_SpellMenuX = CreateClientConVar('nox_hud_spellmenu_x', 0.85, true, false)
local hud_SpellMenuY = CreateClientConVar('nox_hud_spellmenu_y', 0.7, true, false)

local background = surface.GetTextureID('noxctf/bar_background')
local health_back = surface.GetTextureID('noxctf/health_bar_back')
local health_bar = surface.GetTextureID('noxctf/health_bar')
local mana_back = surface.GetTextureID('noxctf/mana_bar_back')
local mana_bar = surface.GetTextureID('noxctf/mana_bar')
local COLOR_HEALTH = Color(240, 60, 60, 255)
local COLOR_MANA = Color(144, 210, 248, 255)

GM.CrossHairType = 'MELEE'

local function drawDeadHUD()

end

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

local hud_ch_color = CreateClientConVar('nox_ch_color', '255 255 255 255', true, false)
local didstartswing = false
local melee_mystartswing = CurTime()

local function MeleeCrossHair(w, h, pl)

  local wep = pl:GetActiveWeapon()
  if wep.Base == 'weapon_rtp_meleebase' then

  local str = hud_ch_color:GetString()
  local col = string.ToColor(str)

  local final_w = wep.MeleeRange
  local final_h = wep.MeleeSize + 0.5
  local final_x = w/2
  local final_y = h/2
  local swingratio = 0
  local rot = math.NormalizeAngle(math.Remap(pl:GetPoseParameter('atk_dir'), 0, 1, -180, 180) - 90)

  local final_rot = rot
  local slope = math.tan(math.rad(final_rot))
  local final_col = col
  local enemycol = Color(255,0, 0, 255)
  local friendcol = Color(0,255, 0, 255)
  local frametime = CurTime() --+ RealFrameTime()
    if wep.SwingStage == 1 then

      if not didstartswing then
        melee_mystartswing = CurTime()
        didstartswing = true
      end

      swingratio = (CurTime() - melee_mystartswing) / (wep.NextSwingStage - melee_mystartswing)
      final_x = final_x + (swingratio * wep.MeleeRange)
      final_y = final_y - ((swingratio * wep.MeleeRange) * slope)
    elseif wep.SwingStage == 2 and wep:GetNextPrimaryFire() <= CurTime() + 0.1 then -- If the player holds
        didstartswing = false

    elseif wep.SwingStage == 2 then
      swingratio = math.EaseInOut(math.Clamp((frametime - (melee_mystartswing + wep.AttackCooldown)) / (wep.NextSwingStage - (melee_mystartswing + wep.AttackCooldown)), 0, 1))
      if swingratio < 0.5 then
      final_x = final_x + wep.MeleeRange - (swingratio * (wep.MeleeRange * 4))
      final_y = final_y - ((final_x - (w/2)) * slope)
      final_h = final_h + (swingratio * 16)
      else 
        final_x = final_x - wep.MeleeRange*2 + (swingratio * (wep.MeleeRange * 2))
        final_y = final_y - (final_x - (w/2)) * slope
        final_h = final_h + (16 - ((swingratio)*16))
      end
    end

  local eyetrace = pl:GetEyeTrace()
  local ent = eyetrace.Entity
  if ent and ent:IsValid() then
    local dist = pl:GetPos():DistToSqr(ent:GetPos())
    if dist <= wep.MeleeRange^2 then
    if ent:IsPlayer() then

        if ent:Team() != pl:Team() then
          final_col = enemycol
        else final_col = friendcol end
        end
    end
  end


  --draw.NoTexture()
  local texid = surface.GetTextureID('gui/center_gradient.vtf')
  surface.SetTexture(texid)
  surface.SetDrawColor(final_col)
  surface.DrawTexturedRectRotated(final_x, final_y, final_w, final_h, final_rot)
  surface.DrawCircle(w/2, h/2, wep.MeleeRange/2, final_col)
  end
end

local function drawCrossHair(w, h, pl)
    MeleeCrossHair(w, h, pl)
end

local function drawHUD()
    local pl = LocalPlayer()
    local w, h = ScrW(), ScrH()
    if not pl:Alive() then drawDeadHUD() end
    local className = pl:GetPlayerClass()
    if not className or className == '' then return end
    local classInfo = CLASSES[className]
    drawHealth(pl:Health(), classInfo.Health)
    if classInfo.Mana then drawMana(pl:GetMana(), classInfo.Mana) end
    drawCrossHair(w, h, pl)
  end

function GM:HUDPaint()
    drawHUD()
end

--cvars.AddChangeCallback( string name, function callback, string identifier = nil )