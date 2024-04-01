local PANEL = {}
function PANEL:Init()
  self:SetSize(100, 100)
  self:Center()
end

function PANEL:Paint()
  if not self:GetParent():IsVisible() then return end
end

vgui.Register("MyFirstPanel", PANEL, "Panel")
local frameClassSelect
function DrawClassSelect()
  frameClassSelect = vgui.Create("DFrame")
  frameClassSelect:SetPos(0, 0)
  frameClassSelect:SetSize(ScrW(), ScrH())
  frameClassSelect:SetTitle("")
  frameClassSelect:SetDeleteOnClose(true)
  frameClassSelect:SetVisible(true)
  frameClassSelect:SetDraggable(false)
  frameClassSelect:ShowCloseButton(true)
  frameClassSelect:MakePopup()
  print("Hello DrawClassSelect")
end