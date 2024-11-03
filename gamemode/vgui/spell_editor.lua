local PANEL = {}
function CreateSpellMenu()
  local pw = 480
  local ph = 600
  local window = vgui.Create("DFrame")
  window:SetSize(pw, ph)
  window:Center()
  window:SetTitle("Spell Selection Menu")
  window:SetVisible(true)
  window:SetDraggable(false)
  window:SetKeyboardInputEnabled(false)
  window:MakePopup()
end

function PANEL:Paint()
end