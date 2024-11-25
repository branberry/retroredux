PANEL = {}

function PANEL:Init()
    self:SetSize(ScrW()/8, ScrH()/16)
    self:SetPos()
end
function PANEL:Paint(w, h)

    local myself = LocalPlayer()
    local sevars = myself.StatusEffects
    if sevars then
        for k, v in pairs(sevars) do
            local se = STATUS_EFFECTS[k]
            local setbl = se.TABLE

            local i = GetKeyIndexFromTable(sevars, k)

            local diamond = {
                { x = ((w/32)*0) + w/32*i, y = ((h)*0.5)},
                { x = ((w/32)*0.5) + w/32*i, y = ((h)*1)},
                { x = ((w/32)*1) + w/32*i, y = ((h)*0.5)},
                { x = ((w/32)*0.5) + w/32*i, y = ((h)*0)},
            }

            surface.SetDrawColor(setbl.Color)
            surface.DrawPoly(diamond)
        end

    end
end

vgui.Register('SEList', PANEL, 'Panel')