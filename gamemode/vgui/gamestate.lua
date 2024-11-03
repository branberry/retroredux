local PANEL = {}


local function PaintText(w, h)
  local TimeLeft = GetGlobalFloat('EndTime', 0) - CurTime()
  local minutes = math.Clamp(math.Truncate(TimeLeft / 60), 0, 9999999)
  local seconds = math.abs(math.Clamp(((minutes * 60) - TimeLeft), -60, 0))
  local sectext = tostring(math.Truncate(seconds))
  local col = col or nil


  if TimeLeft <= 10 then
    local glow = math.sin(RealTime() * 4) * 125
    col = Color(255, glow, glow, 255)
    else
      col = Color(255, 255, 255, 255)
  end

  if #sectext < 2 then
    draw.SimpleText(tostring(minutes) .. ':0' .. tostring(math.Truncate(seconds)), 'DefaultFontMed', w/2, h/2, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    -- surface.DrawText(tostring(minutes) .. ':0' .. tostring(math.Truncate(seconds)))
    else
      draw.SimpleText(tostring(minutes) .. ':' .. tostring(math.Truncate(seconds)), 'DefaultFontMed', w/2, h/2, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
      -- surface.DrawText(tostring(minutes) .. ':' .. tostring(math.Truncate(seconds)))
  end
end 


local function BorderPaint(self, w, h)
  surface.SetDrawColor(0, 0, 0, 210)
  surface.DrawRect(0, 0, w, h)
  PaintText(w, h)

    return true
  end

function PANEL:Init()
  self:SetSize(ScrW(), ScrH())
  self:SetPos(0, 0)

    local timerborder = vgui.Create('DFrame')
    timerborder:SetSize(128, 64)
    timerborder:SetPos(ScrW()/2 - timerborder:GetWide()/2, 0)
    timerborder:ShowCloseButton(false)
    timerborder:SetSizable(false)
    timerborder:SetTitle('')
    timerborder.Paint = BorderPaint

  end

  vgui.Register('GameState', PANEL, 'DPanel')

  function PANEL:Paint(w, h)

  return true end