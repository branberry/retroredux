local PANEL = {}
-- Temporarily hardcoding classes for testing purposes
function PANEL:Init()
  self:SetSize(100, 100)
  self:Center()
end

function PANEL:Paint()
  if not self:GetParent():IsVisible() then return end
  print('Panel')
  local wid, hei = self:GetSize()
  local matBarBack = surface.GetTextureID('noxctf/classselect_bar_back')
  local matBar = surface.GetTextureID('noxctf/classselect_bar')
  local drawColor = HSVToColor(rating * 12, 1, 1)
  surface.SetDrawColor(0, 0, 0, 210)
  -- TODO: Add this material
  surface.SetTexture(matBarBack)
  surface.DrawTexturedRect(0, 0, wid, hei)
  surface.SetDrawColor(drawColor.r, drawColor.g, drawColor.b, 255)
  surface.SetTexture(matBar)
end

local function DrawClassRows()
  local row_color = Color(100, 220, 240, 200)
  surface.SetDrawColor(row_color)
end

vgui.Register('MyFirstPanel', PANEL, 'Panel')
local function drawClasses(frameClassSelect, screens, centx, centy)
  local row = centy + (360 * screens)
  local column = (centx - (832 * screens)) + (.5 * (1024 * screens))
  for _, class in pairs(CLASSES) do
    local button = vgui.Create('DImageButton', frameClassSelect)
    local b = 0.666667 * screens
    button:SetMaterial(class.Image)
    button:SetSize(256 * b, 512 * b)
    button:SetPos(column - (128 * b), row - (256 * b))
    button:SetDrawBorder(false)
    button:SetText('')
    button.DoClick = function(btn)
      local player = LocalPlayer()
      player:ConCommand(CC_CHANGE_CLASS .. class.Name)
      frameClassSelect:Close()
    end

    column = column + 200
  end
end

local frameClassSelect
function DrawClassSelect()
  if frameClassSelect and frameClassSelect:IsValid() then frameClassSelect:Remove() end
  frameClassSelect = vgui.Create('DFrame')
  frameClassSelect:SetPos(0, 0)
  frameClassSelect:SetSize(ScrW(), ScrH())
  frameClassSelect:SetTitle('')
  frameClassSelect:SetDeleteOnClose(true)
  frameClassSelect:SetVisible(true)
  frameClassSelect:SetDraggable(false)
  frameClassSelect:ShowCloseButton(true)
  frameClassSelect:MakePopup()
  -- Add class detail panel. Child of frameClassSelect DFrame
  local panelClassDetail = vgui.Create('DPanel', frameClassSelect)
  local centx, centy = ScrW() / 2, ScrH() / 2
  local screens = math.min(1, ((ScrW() / 3840) + 0.5) ^ 2)
  local wid, hei = 512 * screens, 1024 * screens
  local x = 530 * screens + centx
  local y = centy
  panelClassDetail:SetPos(x - (wid / 2), y - (hei / 2))
  panelClassDetail:SetSize(wid, hei)
  panelClassDetail:SetVisible(false)
  drawClasses(frameClassSelect, screens, centx, centy)
  frameClassSelect.Paint = DrawClassRows
end