local texGradRight = surface.GetTextureID("VGUI/gradient-r")
local centernotes = {}

local function CenterNoticePaint()

    for i, v in ipairs(centernotes) do
        local msg = v.message
        local msgcol = v.color
        local font = v.font
        local a = 0
        local ct = CurTime()

        if ct >= (v.dietime - 0.5) then
            a = math.min(1, v.dietime - ct)

        else
            a = math.min(1, (ct - v.starttime) * 4)
        end

        msgcol.a = (a * 255)

        surface.SetFont(font)
        local w, h = surface.GetTextSize(msg)
        h = h + 16
        w = w + 32

        local x = (ScrW() / 2)
        local y = ScrH() - (i * h) - 180

        
        surface.SetTexture(texGradRight)
        surface.SetDrawColor(10, 10, 10, a*160)

        surface.DrawTexturedRectRotated(x - w/2, y, w, h, 0)
        surface.DrawTexturedRectRotated(x + w/2, y, w, h, 180)
        draw.SimpleTextOutlined(msg, font, x, y, msgcol, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0,0,0,a*255))

        if v.icontbl and v.icontbl.icon then

            local icontbl = v.icontbl
            local iconsize = 64
            if icontbl.color then
                surface.SetDrawColor(icontbl.color.r, icontbl.color.g, icontbl.color.b, a * icontbl.color.a)
            end

            if icontbl.size then
                iconsize = icontbl.size
            end
            surface.SetTexture(surface.GetTextureID(icontbl.icon))
            surface.DrawTexturedRect(x - (w/2 + 32) - iconsize, y - iconsize/2, iconsize, iconsize)
            surface.DrawTexturedRect(x + (w/2 - 32) + iconsize/2, y - iconsize/2, iconsize, iconsize)
        end

        if ct >= v.dietime then
            table.remove(centernotes, i)
        end
    end
end

    function CreateCenterNotice(str, font, color, dietime, soundfile, icontbl)

    local tab = {
    ['message'] = str,
    ['font'] = font,
    ['color'] = color,
    ['starttime'] = CurTime(),
    ['dietime'] = CurTime() + dietime
    }

    if icontbl then
        tab.icontbl = icontbl
    end

    table.insert(centernotes, tab)
    surface.PlaySound(soundfile)
end

local panel = vgui.Create('DPanel')
    panel:SetSize(ScrW(), ScrH())
    panel:SetPos(0, 0)
    panel.Paint = CenterNoticePaint