PANEL = {}

local slotbarx = ScrW()/2
local slotbary = ScrH()/1.2

local slotsize = ScrW() / 48

local slots = {}
local currentclass = ''

local function SlotPaint(self, w, h)
    local x, y = self:GetPos()
    local myself = LocalPlayer()
    local myspellid = self.SpellID
    local spellcds = myself.SpellCooldowns
    local keybind = table.KeyFromValue(GAMEMODE.SPELLBINDS_DEFAULT, self.ID)

    local a = 255
    local text_a = 255
    local textcolor = Color(255, 255,255, 255)

    if SPELLS[myspellid] then 
        local spellruneicon = SPELLS[myspellid].TABLE.RuneIcon

        local runeiconid = surface.GetTextureID(spellruneicon)

        if not input.IsKeyDown(79) and self.ID < 0 then
            a = 127
            text_a = 80
            textcolor = Color(text_a, text_a, text_a, text_a)
        elseif input.IsKeyDown(79) and self.ID > 0 then
            a = 127
            text_a = 80
            textcolor = Color(text_a, text_a, text_a, text_a)
        end

        surface.SetDrawColor(255,255,255, a) 

        if spellcds and spellcds[myspellid] then
        surface.SetDrawColor(255,0,0, a)
        surface.SetTexture(runeiconid)
        surface.DrawTexturedRect(0,0, w, h)

        draw.SimpleTextOutlined(math.ceil(myself.SpellCooldowns[myspellid] - CurTime()), 'DefaultFontMed', w/2, h/2, textcolor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black)
        else

        surface.SetTexture(runeiconid)
        surface.DrawTexturedRect(0,0, w, h)
        end
    end

    if keybind then
        if self.ID < 0 then
            local bindwithoutunderscore = string.sub(keybind, 2, #keybind)
            draw.SimpleTextOutlined(bindwithoutunderscore, 'DefaultFontSmall', w/8, h/1.4, textcolor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black)
        else
            draw.SimpleTextOutlined(keybind, 'DefaultFontSmall', w/8, h/1.4, textcolor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black)
        end
    end

    surface.SetDrawColor(color_white)
    surface.DrawOutlinedRect(0, 0, w, h, 2)
end

function PANEL:Paint(w, h)
end

function PANEL:Init()
    local pl = LocalPlayer()
    local spells = GAMEMODE.SpellTables
    local slotcount = GAMEMODE.SpellSlots
    local slots_halved = math.ceil(slotcount / 2) -- Slot count split into two for NON-SHIFT spells, and SHIFT spells.
    local slots_quaded = math.ceil(slots_halved / 2)
    local slots_marginquad = ScrW()/48
    local slots_totalmargin_quad = slots_marginquad + (slotsize * slots_quaded)

    self:SetPos(slotbarx - slots_marginquad/2 - (slots_halved * slotsize/2), slotbary) 
    self:SetSize(slots_halved * slotsize + slots_marginquad, slotsize * 2)

    for i=1, slotcount do
        if CLASSES[currentclass] then
            local class_spelllayout = spells[currentclass]
                local slot = vgui.Create('DFrame', self)

                if class_spelllayout and class_spelllayout[i] then -- Does the player already have a preset available for this slot?
                slot.SpellID = class_spelllayout[i]
                else 
                    local classtbl = CLASSES[currentclass]
                    slot.SpellID = classtbl.DefSpellLayout[i] end

                if i <= slots_halved then
                    slots[i] = slot
                    slot.ID = i
                    slot:SetSize(slotsize, slotsize)
                    if i > slots_quaded then
                        slot:SetPos(((i - 1) * slotsize) + slots_marginquad, slotsize)
                    else
                        slot:SetPos((i - 1) * slotsize, slotsize)
                    end

                    slot:ShowCloseButton(false)
                    slot:SetTitle('')
                    slot.Paint = SlotPaint
                else
                    local inverted = (i * -1) + slots_halved -- It's a SHIFT spell so negate the index
                    local rebounded = i - slots_halved

                    slots[inverted] = slot
                    slot.ID = inverted

                    slot:ShowCloseButton(false)
                    slot:SetTitle('')

                    slot:SetSize(slotsize, slotsize)
                    if rebounded > slots_quaded then

                        slot:SetPos(((rebounded - 1) * slotsize) + slots_marginquad, 0)
                    else 
                        slot:SetPos((rebounded - 1) * slotsize, 0)
                    end
                    slot.Paint = SlotPaint
            end
            
        end
    end

end

function PANEL:GetCurrentClassLayout()
return currentclass end

function PANEL:ResetClassLayout(class)
    currentclass = class
    for i, v in pairs(slots) do
        v:Remove()
        slots[i] = nil
    end
    self:Init()
end

function PANEL:GetSpellFromSlot(slotid)
    local slot = slots[slotid]
    if slot then return slot.SpellID end
end
vgui.Register('spell_bar', PANEL, 'Panel')