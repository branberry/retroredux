PANEL = {}

local slotbarx = ScrW()/2
local slotbary = ScrH()/1.2

local slotsize = ScrW() / 48

local slots = {}

local function SlotPaint(self, w, h)
local x, y = self:GetPos()

    if SPELLS[self.SpellID] then 
        local spellruneicon = SPELLS[self.SpellID].RuneIcon

        local runeiconid = surface.GetTextureID(spellruneicon)

        surface.SetTexture(runeiconid)
        surface.DrawTexturedRect(0,0, w, h)
    end

    surface.SetDrawColor(color_white)
    surface.DrawOutlinedRect(0, 0, w, h, 2)
end

function PANEL:Paint(w, h)
    local x, y = self:GetPos()
    surface.SetDrawColor(color_white)
    --surface.DrawOutlinedRect(0, 0, w, h, 2)
end

function PANEL:Init()
    local spells = GAMEMODE.SpellTables
    local slotcount = GAMEMODE.SpellSlots
    local slots_halved = math.ceil(slotcount / 2) -- Slot count split into two for NON-SHIFT spells, and SHIFT spells.\
    local slots_quaded = math.ceil(slots_halved / 2)
    local slots_marginquad = ScrW()/48
    local slots_totalmargin_quad = slots_marginquad + (slotsize * slots_quaded)

    self:SetPos(slotbarx - slots_marginquad/2 - (slots_halved * slotsize/2), slotbary) 
    self:SetSize(slots_halved * slotsize + slots_marginquad, slotsize * 2)

    for i=1, slotcount do
        local slot = vgui.Create('DFrame', self)
        slot.SpellID = 'SPELL_FIREBOMB' -- Placeholder variable to be replaced later.

        if i <= slots_halved then
            slots[i] = slot
            print(i)
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
            print(rebounded)

            slots[inverted] = slot

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

function PANEL:GetSpellFromSlot(slotid)
    local slot = slots[slotid]
return slot.SpellID end
vgui.Register('spell_bar', PANEL, 'Panel')