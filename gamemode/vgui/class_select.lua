local PANEL = {}
function PANEL:Init()
  self:SetSize(100, 100)
  self:Center()
end

function PANEL:Paint()
  if not self:GetParent():IsVisible() then return end
  print("Panel")
  local rating = self.Rating or 1
  local wid, hei = self:GetSize()
  surface.SetDrawColor(0, 0, 0, 210)
  -- TODO: Add this material
  -- surface.SetTexture(matBarBack)
  surface.DrawTexturedRect(0, 0, wid, hei)
end

local function DrawClassRows()
  local row_color = Color(100, 220, 240, 200)
  surface.SetDrawColor(row_color)
end

vgui.Register("MyFirstPanel", PANEL, "Panel")
local frameClassSelect
function DrawClassSelect()
  if frameClassSelect and frameClassSelect:IsValid() then frameClassSelect:Remove() end
  frameClassSelect = vgui.Create("DFrame")
  frameClassSelect:SetPos(0, 0)
  frameClassSelect:SetSize(ScrW(), ScrH())
  frameClassSelect:SetTitle("")
  frameClassSelect:SetDeleteOnClose(true)
  frameClassSelect:SetVisible(true)
  frameClassSelect:SetDraggable(false)
  frameClassSelect:ShowCloseButton(true)
  frameClassSelect:MakePopup()
  -- Add class detail panel. Child of frameClassSelect DFrame
  local panelClassDetail = vgui.Create("DPanel", frameClassSelect)
  local centx, centy = ScrW() / 2, ScrH() / 2
  local screens = math.min(1, ((ScrW() / 3840) + 0.5) ^ 2)
  local wid, hei = 512 * screens, 1024 * screens
  local x = 530 * screens + centx
  local y = centy
  print("Add panel details")
  panelClassDetail:SetPos(x - (wid / 2), y - (hei / 2))
  panelClassDetail:SetSize(wid, hei)
  panelClassDetail:SetVisible(false)
  frameClassSelect.Paint = DrawClassRows
end