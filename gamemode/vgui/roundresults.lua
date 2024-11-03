PANEL = {}

local winner = 0
local winnerinfo = TEAMS[TEAMS_PLAYING[winner]]

local function BorderPaint(self, w, h)
    local x, y  = self:GetPos()
    if winner and winnerinfo then
         local winnername = winnerinfo.Name
         local winnercolor = winnerinfo.Color
         surface.SetDrawColor(0, 0, 0, 210)
         surface.DrawRect(x, y, w, h)
            draw.SimpleTextOutlined(string.upper(winnername) .. ' WINS', 'DefaultFontVeryLarge', x + w/2, y + h/6, winnercolor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, color_black)
    end
end

local function CloseButtonPaint(self)
    local w, h = self:GetSize()
    local parx, pary = self:GetParent()

    surface.SetDrawColor(204, 16, 16, 255)
    surface.DrawRect(0, 0, w, h)
    draw.SimpleTextOutlined('Close', 'DefaultFontMed', w/2, h/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, color_black)

end

local function PlayModelPanelSequence(self, seq, defaultseq)
    local modelpanel = self.MdlPanel
    local ent = modelpanel:GetEntity()
    if ent then
        local seqid, seqdur = ent:LookupSequence(seq)
        local defaultseqid = ent:LookupSequence(defaultseq)

        timer.Create('RoundResults_ModelPanel_Sequence', 0.1, 1, function() -- Sequences cannot play if a model is being initialized in the exact same tick. Adding a small delay fixes it.

                    ent:SetSequence(seqid)
                    ent:ResetSequenceInfo()
                    print(seq, defaultseq)

            timer.Create('RoundResults_ModelPanel_DefaultSequence', seqdur - 0.4, 1, function() -- the default sequence to return to. A little margin is left since layered sequences will typically end with a t-pose which is undesirable.
                if ent and ent:IsValid() then
                    ent:SetSequence(defaultseqid)
                end
            end)
        end)
    end
end

local function SetupModelPanel(self, entity)

    if entity then
    -- TODO: Make it so that hovering over a player's honorable mention shows their model using this space.

    else -- Setup when a team captain should draw instead of a player.

        local mp = self.MdlPanel

        if mp and mp:IsValid() then
            mp:SetModel(winnerinfo.Captain)
            local ent = mp:GetEntity()
            if ent and ent:IsValid() then

                local anims = winnerinfo['Captain_Anims']
                if anims then 
                    local idle_anims = anims['Idle']
                    local taunt_anims = anims['Taunt']
            
            
                    local tauntanim =  table.Random(taunt_anims)
                    local idleanim =  table.Random(idle_anims)
            
                    PlayModelPanelSequence(self, tauntanim, idleanim)
                end
                if winnerinfo.Captain_ColorOverall then
                    mp:SetColor(winnerinfo.Color)
            
                else
                    ent.GetPlayerColor = function()
                return winnerinfo.Color:ToVector() end
                end
            end
        end
    end

end

function PANEL:Setup(WinningTeam)
    winner = WinningTeam
    winnerinfo = TEAMS[TEAMS_PLAYING[winner]]

    SetupModelPanel(self)
end

function PANEL:Paint()
-- Empty
end

function ScrollPanelPaint(self)

    local x, y, w, h = self:GetBounds()
    surface.SetDrawColor(27, 27, 27)
    surface.DrawRect(x, y, w, h)
end

function PANEL:Hide()
    self:SetVisible(false)
    self:SetMouseInputEnabled(false)

end

local function VBarPaint(self)

    local x, y = self:GetX(), self:GetY()
    local w, h = self:GetWide(), self:GetTall()
    surface.SetDrawColor(133, 133, 133)
    surface.DrawRect(x, y, w, h)

end

local function BottomFramePaint(self)

    local w, h = self:GetSize()

    surface.SetDrawColor(0,0,0, 210)
    surface.DrawRect(0, 0, w, h)

    surface.SetDrawColor(22,22,22, 210)
    surface.DrawOutlinedRect(0, 0, w, h, 1)

end

local function HMItemPaint(self)
    local x, y, w, h = self:GetBounds()

    local pl = self.Pl
    local value = self.Value
    local mentionindex = self.MentionIndex
    local mentiontbl = HONORABLE_MENTIONS[mentionindex]
    local teamid = self.TeamID
    local teamtbl = TEAMS[TEAMS_PLAYING[teamid]]
    local starttime = self.StartTime
    local white = Color(255,255,255,255)

    local opacity = (((CurTime() - starttime)/ 0.2) * 255)


    local canvas = self:GetParent()
    local hmscroll = canvas:GetParent()

    local hmsw, hmsh = hmscroll:GetSize()

    local index = self.Index

    if hmscroll then
        surface.SetDrawColor(22, 22, 22, opacity)
        surface.DrawRect(0, 0, w, h)
    end
    if teamtbl then
        surface.SetDrawColor(teamtbl.Color.r, teamtbl.Color.g, teamtbl.Color.b, opacity)

        -- Overall Item Border Outline
        surface.DrawOutlinedRect(hmsw/512, hmsh/512, w - w/256, h - h/256 - 2, 2)

        -- AvatarImage Duel Outline
        surface.DrawOutlinedRect(w/16, h/8, 66, 66, 2)

        surface.SetDrawColor(teamtbl.Color.r / 2, teamtbl.Color.g / 2, teamtbl.Color.b / 2, opacity)
        surface.DrawOutlinedRect(w/16 - 2, h/8 - 2, 66, 66, 2)
    end

    local formattedmessage = translate.Format(mentiontbl['Subtitle'], pl:Nick(), value)
    
    draw.SimpleTextOutlined(formattedmessage, 'DefaultFontSmall', w/5, h - h/4, white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 2, color_black)
    draw.SimpleTextOutlined(mentiontbl.Title, 'DefaultFontMed', w/5, h - h/1.5, white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 2, color_black)
end

function PANEL:Init()

    local w, h = ScrW(), ScrH()
    local x, y = self:GetPos()

    self:SetPos(0, 0)
    self:SetSize(w, h)
    self:MakePopup()

    local frame = vgui.Create('DFrame', self)
    frame:SetSize(w/2, h - h/16)
    frame:ShowCloseButton(false)
    frame:SetDraggable(false)
    frame:SetTitle('')
    frame:SetPaintBorderEnabled(false)
    frame.Paint = BorderPaint

    local bottomframe = vgui.Create('DFrame', self)
    bottomframe:SetDraggable(false)
    bottomframe:ShowCloseButton(false)
    bottomframe:SetSize(w, h/16)
    bottomframe:SetPos(0, h - h/16)
    bottomframe:SetTitle('')
    bottomframe.Paint = BottomFramePaint


    local closebutton = vgui.Create('DButton', bottomframe)
    local bw, bh = bottomframe:GetWide(), bottomframe:GetTall()
    closebutton:SetSize(bw/16, bh/2)
    closebutton:SetPos(bw - bw/14,   bh - bh/1.5)
    closebutton:SetText('')
    closebutton.Paint = CloseButtonPaint
    closebutton.DoClick = function()
        self:Hide()
    end

    local modelpanel = vgui.Create('DModelPanel', self)
    self.MdlPanel = modelpanel
    modelpanel:SetSize(w/2, h - h/16)
    modelpanel:SetPos(w/2, 0)
    modelpanel.CurTime = CurTime()
    modelpanel.LayoutEntity = function()
        modelpanel:RunAnimation()
    end
    modelpanel:SetModel('models/player/kleiner.mdl')
    local headpos = modelpanel.Entity:GetBonePosition(modelpanel.Entity:LookupBone("ValveBiped.Bip01_Head1"))
    modelpanel:SetCamPos(headpos + Vector(45,45,-25))
    modelpanel:SetLookAt(headpos)

    local hmframe = vgui.Create('DFrame', frame)
    local w, h = frame:GetSize()
    hmframe:SetSize(w/2, h/2)
    local myw, myh = hmframe:GetSize()
    hmframe:SetPos(w/2 - myw/2, h/2 - myh/2)

    local hmscroll = vgui.Create('DScrollPanel', hmframe)
    self['HMScroll'] = hmscroll
    local bar = hmscroll:GetVBar()
    local x, y, w, h = hmframe:GetBounds()
    hmscroll:SetPos(0, 0)
    hmscroll:SetSize(w, h)
    hmscroll.Paint = VBarPaint
end

function PANEL:AddHonorableMention(pl, mentionindex, value)
    local hmscroll = self.HMScroll
    if hmscroll and hmscroll:IsValid() then
        local hmsx, hmsy, hmsw, hmsh = hmscroll:GetBounds()
        local canvas = hmscroll:GetCanvas()
        local childcount = #canvas:GetChildren()


        local  hmframeitem = vgui.Create('DFrame')
        hmframeitem:SetPos(0, hmsh/8 * childcount)
        hmframeitem:SetSize(hmsw, hmsh/8)
        hmframeitem:SetDraggable(false)
        hmframeitem:ShowCloseButton(false)
        hmframeitem:SetTitle('')
        hmframeitem.TeamID = pl:Team()
        hmframeitem.Paint = HMItemPaint
        hmframeitem.Pl = pl
        hmframeitem.MentionIndex = mentionindex
        hmframeitem.Value = value
        hmframeitem.Index = childcount
        hmframeitem.StartTime = CurTime()

        local hmpfp = vgui.Create('AvatarImage', hmframeitem)
        hmpfp:SetSize(64, 64)
        hmpfp:SetPos(hmframeitem:GetWide() / 16, hmframeitem:GetTall() / 8)
        hmpfp:SetPlayer(pl, 64)

        hmscroll:AddItem(hmframeitem)
    end
end

vgui.Register('RoundResults', PANEL, 'DPanel')