PANEL = {}

PANEL.SelectedCategory = nil

function PANEL:Open()
    if not self:IsVisible() then
        self:Show()
        self:MakePopup()
        self:SetMouseInputEnabled(true)
        self:SetKeyboardInputEnabled(false)
    else 
        self:Hide()
        self:SetMouseInputEnabled(false)
    self:SetKeyboardInputEnabled(false) end
end

function PANEL:Close()
    if self:IsVisible() then
        self:Hide()
        self:SetMouseInputEnabled(false)
    end
end

local function PaintBuildItemButton(self, w, h)
    if self:IsDown() then 
        surface.SetDrawColor(Color(0, 89, 255, 125))
    elseif self:IsHovered() then
        surface.SetDrawColor(Color(64, 109, 255, 125))
    else
        surface.SetDrawColor(Color(25, 25, 25, 125))
    end
    surface.DrawRect(0, 0, w, h)
    local bproptbl = GAMEMODE.BuildProps[self.BProp]
    draw.SimpleTextOutlined(bproptbl.Name, 'DefaultFontMed', w/16, h/2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, color_black)
end

local function TabPaint(self, w, h)
    if self.TabTable.Tab:IsActive() then
        draw.RoundedBox(2, 0, 0, w, h, Color(self.Color.r*0.5, self.Color.g*0.5, self.Color.b*0.5))
        surface.SetTexture(surface.GetTextureID('gui/center_gradient'))
        surface.SetDrawColor(self.Color)
        surface.DrawTexturedRect(0, 0, w, h)
    elseif self:IsDown() then
        draw.RoundedBox(2, 0, 0, w, h, Color(self.Color.r*0.8, self.Color.g*0.8, self.Color.b*0.8))
    elseif self:IsHovered() then
        draw.RoundedBox(2, 0, 0, w, h, Color(self.Color.r*0.5, self.Color.g*0.5, self.Color.b*0.5))
    else
        draw.RoundedBox(2, 0, 0, w, h, Color(25, 25, 25, 125))
    end
    draw.RoundedBox(2, 0, 0, 4, h, self.Color)
    surface.SetMaterial(self.Icon)
    surface.SetDrawColor(255, 255, 255, 50)
    surface.DrawTexturedRect(w*0.7, h*0.2, 86, 86)
    local brightercol = Color(self.Color.r * 1.2, self.Color.g * 1.2, self.Color.b * 1.2)
    draw.SimpleTextOutlined(self.Name, 'DefaultFontLarge', w/16, h/2, brightercol, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, color_black)
end

function PANEL:CreateCategories()
    local pl = LocalPlayer()
    self.CategoryList = vgui.Create('DPropertySheet', self.frame)
    self.CategoryList:SetSize(self:GetWide()/2, self:GetTall()  - (self.frame:GetTall() * 0.1)) -- DPropertySheet is just there for the function of switching.

    local catbuttonlayout = vgui.Create('DHorizontalScroller', self.frame)
    catbuttonlayout:SetSize(self:GetWide(), self:GetTall()/8)
    
    for catindex, cat in pairs(GAMEMODE.BuildMenuCategories) do
        

        local vpanel = vgui.Create('DScrollPanel', self.frame)
        local canvas = vpanel:GetCanvas()
        local nexttabx = 0
        self.CategoryList:SetPos(0, self.frame:GetTall() * 0.1)
        vpanel:SetSize(self.frame:GetWide()*0.3, self.CategoryList:GetTall())
        
        canvas:InvalidateChildren()

        for i, v in pairs(GAMEMODE.BuildProps) do
            if v.Category == catindex then
                
                local item = vgui.Create('DButton')
                item.Index = #canvas:GetChildren()
                item:SetSize(vpanel:GetWide(), ScrH()/16)
                item:SetPos(0, (ScrH()/14 * item.Index))
                item:SetText('')
                item.BProp = i
                vpanel:AddItem(item)
                item.Paint = PaintBuildItemButton

                item.DoClick = function()
                    local classtbl = CLASSES[pl:GetPlayerClass()]
                    local propindex = GetKeyIndexFromTable(GAMEMODE.BuildProps, item.BProp)
                    if classtbl.CanBuild then
                        net.Start('nox_BuildProp')
                        net.WriteUInt(propindex, 8)
                        net.SendToServer()
                    end
                    print('fuck')
                end

                local sicon = vgui.Create('SpawnIcon', item)
                sicon:SetPos(vpanel:GetWide() * 0.7, -1*(sicon:GetTall()*0.3))
                sicon:SetSize(vpanel:GetWide()*0.2, vpanel:GetTall()*0.2)
                sicon:SetModel(v.Mdl)
                item.SpawnIcon = sicon
            end
        end

        local tabtbl = self.CategoryList:AddSheet('', vpanel)
        tabtbl.Tab:SetVisible(false)
        tabtbl.Tab:SetText('')
        self.CategoryList:SetActiveTab(tabtbl.Tab)

        local tabbutton = vgui.Create('DButton') --[[ The DButtons are what's actually being used for the user interface. It "represents" it's associated DPropertySheet's Tab.
                                                The purpose of this was to make buttons that actually fit the UI since the DTab's bounds cannot be resized.]]--
        local tabstepx = #catbuttonlayout:GetChildren()

        local TabWide = #cat.Name*32
        tabbutton:SetSize(TabWide + self:GetWide()/16, self:GetTall()/8)
        tabbutton:SetPos(nexttabx + tabbutton:GetWide(), 0)
        nexttabx = nexttabx + tabbutton:GetWide() + 128
        tabbutton:SetText('')
        catbuttonlayout:AddPanel(tabbutton)

        tabbutton.Name = cat.Name
        tabbutton.Icon = Material(cat.Icon)
        tabbutton.Color = cat.Color
        tabbutton.Paint = DTabPaint
        tabbutton.TabTable = tabtbl
        tabbutton.Paint = TabPaint
        tabbutton.DoClick = function()
            self.CategoryList:SetActiveTab(tabbutton.TabTable.Tab)
        end
    end
end

local function FramePaint(self, w, h)
    surface.SetDrawColor(46, 46, 46, 222)
    surface.DrawRect(0, 0, w, h)
end

function PANEL:Init()
    local w, h = ScrW(), ScrH()
    self:SetSize(w/2, h/2)
    self:Center()

    local frame = vgui.Create('DFrame', self)
    frame:SetTitle('')
    frame:ShowCloseButton(false)
    frame:SetSize(self:GetSize())
    frame:SetDraggable(false)
    self.frame = frame
    frame.Paint = FramePaint

    self:MakePopup()
    self:SetMouseInputEnabled(true)
    self:SetKeyboardInputEnabled(false)

    self:CreateCategories()
end

vgui.Register('DBuildMenu', PANEL, Panel)