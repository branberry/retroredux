local PANEL = {}

function PANEL:Init()
    self:SetSize(128, 64)
    self:SetPos(ScrW()/2 - self:GetWide()/2, 0)
  end

  function PANEL:Paint(w, h)
  surface.SetDrawColor(0, 0, 0, 210)
  surface.DrawRect(0, 0, w, h)
  PANEL:PaintText(w, h)

    return true
  end
  vgui.Register("GameState", PANEL, "DPanel")

  function PANEL:PaintText(w, h)
    local TimeLeft = GetGlobalFloat("EndTime", 0) - CurTime()
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


    -- surface.SetTextColor(col)
    -- surface.SetFont("DefaultFontMed")
    -- surface.SetTextPos(w/2 - 32, 0)

    if #sectext < 2 then
      draw.SimpleText(tostring(minutes) .. ":0" .. tostring(math.Truncate(seconds)), "DefaultFontMed", w/2, h/2, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
      -- surface.DrawText(tostring(minutes) .. ":0" .. tostring(math.Truncate(seconds)))
      else
        draw.SimpleText(tostring(minutes) .. ":" .. tostring(math.Truncate(seconds)), "DefaultFontMed", w/2, h/2, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        -- surface.DrawText(tostring(minutes) .. ":" .. tostring(math.Truncate(seconds)))
    end
  end 