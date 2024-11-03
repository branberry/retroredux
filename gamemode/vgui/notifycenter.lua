PANEL = {}

local texGradRight = surface.GetTextureID("VGUI/gradient-r")
local centernotes = {}

function PANEL:Init()
    self:SetSize(ScrW(), ScrH())
    self:SetPos(0, 0)

end

function PANEL:Paint()

    for i, v in ipairs(centernotes) do
        local msg = v.message
        local msgcol = v.color
        local a = 0
        local ct = CurTime()

        if ct >= (v.dietime - 0.5) then
            a = math.min(1, v.dietime - ct)

        else
            a = math.min(1, v.starttime + ct)
        end

        msgcol.a = (a * 255)

        surface.SetFont('DefaultFontSmall')
        local w, h = surface.GetTextSize(msg)
        h = h + 16
        w = w + 32

        local x = (ScrW() / 2)
        local y = ScrH() - (i * h)

        
        surface.SetTexture(texGradRight)
        surface.SetDrawColor(10, 10, 10, a*160)

        surface.DrawTexturedRectRotated(x - w/2, y, w, h, 0)
        surface.DrawTexturedRectRotated(x + w/2, y, w, h, 180)
        draw.SimpleTextOutlined(msg, 'DefaultFontMed', x, y, msgcol, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0,0,0,a*255))

        if ct >= v.dietime then
            table.remove(centernotes, i)
        end
    end
end

function PANEL:CreateCenterNotice(str, color, dietime, soundfile)

    local tab = {
    ['message'] = str,
    ['color'] = color,
    ['starttime'] = CurTime(),
    ['dietime'] = CurTime() + dietime
    }

    table.insert(centernotes, tab)
    local uisound = 'sound/' .. soundfile
    surface.PlaySound(uisound)
end

vgui.Register('NotifyCenter', PANEL, 'Panel')