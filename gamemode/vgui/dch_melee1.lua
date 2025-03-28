local PANEL = {}
local sizex = GetConVar("rtp_ch_sizex"):GetFloat()
local sizey = GetConVar("rtp_ch_sizey"):GetFloat()
local myself = LocalPlayer()


function PANEL:Init()
    self:SetSize(sizex*128, sizey*128)
    self:Center()
end

function PANEL:PaintOver(w, h)
    if myself and myself:IsValid() then
        local myswep = myself:GetActiveWeapon()
        if myswep and myswep:IsValid() and myswep.Base == 'weapon_rtp_meleebase' then
            local finalw = myswep.MeleeSize / 4
            local finalh = myswep.MeleeRange / 6
            draw.NoTexture()
            surface.SetDrawColor(255,0,0,255)
            surface.DrawTexturedRectRotated(w/2, h/2, finalw, finalh, 0)
        end
    end
end

vgui.Register('dch_melee1', PANEL, 'Panel')