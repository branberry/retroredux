PANEL = {}

function PANEL:Init()
    self:SetSize(ScrW()/4, ScrH()/14)
    self:SetPos(0, ScrH()/1.15)
end
function PANEL:Paint(w, h)

    local myself = LocalPlayer()
    local sevars = myself.StatusEffects
    if sevars then
        for k, v in pairs(sevars) do
            local se = STATUS_EFFECTS[k]
            local setbl = se.TABLE

            local i = GetKeyIndexFromTable(sevars, k)
            local size = 56
            local col = setbl.Color
            local lightcol = Color(col.r + 175, col.g + 175, col.b + 175)
            local darkcol = Color(col.r * 0.5, col.g * 0.5, col.b * 0.5)

            local white = surface.GetTextureID('vgui/white.vmt')

            surface.SetTexture(white)

            surface.SetDrawColor(col.r * 0.8, col.g * 0.8, col.b * 0.8, 164)
            surface.DrawTexturedRectRotated(i * size, 48, size, size, 45)
            --surface.DrawPoly(diamond)
            local dur = v.Duration
            local die = v.DieTime
            local countdown = die - CurTime()
            local perc = function(add) return math.Clamp((countdown - (dur * add)) / (dur * 0.25), 0, 1) end

            surface.SetDrawColor(col.r + 90, col.g + 90, col.b + 90, 255)
                surface.DrawTexturedRectRotated((i * size) - ((size/3) + size/3 * (1 - perc(0))), 48 - ((size/3) - size/3 * (1 - perc(0))), (perc(0) * size), 4, 45)
                surface.DrawTexturedRectRotated((i * size) + ((size/3) - size/3 * (1 - perc(0.25))), 48 - ((size/3) + size/3 * (1 - perc(0.25))), (perc(0.25) * size), 4, 135)
                surface.DrawTexturedRectRotated((i * size) + ((size/3) + size/3 * (1 - perc(0.50))), 48 + ((size/3) - size/3 * (1 - perc(0.50))), (perc(0.5) * size), 4, 225)
                surface.DrawTexturedRectRotated((i * size) - ((size/3) - size/3 * (1 - perc(0.75))), 48 + ((size/3) + size/3 * (1 - perc(0.75))), (perc(0.75) * size), 4, 315)

            local icon = surface.GetTextureID(setbl.Icon)
            surface.SetDrawColor(col.r + 70, col.g + 70, col.b + 70, 255)
            surface.SetTexture(icon)
            surface.DrawTexturedRect((i - 1) * size + size/2, size*0.25, size, size)
            draw.SimpleTextOutlined(setbl.Abrev, 'DefaultFontSmall', (i * size), size * 1.6, lightcol, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, darkcol)
            draw.SimpleTextOutlined(math.ceil(countdown), 'DefaultFontMed', (i * size), size * 1.25, lightcol, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, darkcol)
        end
    end
end

vgui.Register('SEList', PANEL, 'Panel')