local texGradRight = surface.GetTextureID('VGUI/gradient-r')
PANEL = {}

function PANEL:Init()
    self:SetSize(ScrW(), ScrH())
    self:SetPos(0, 0)
    self.Children = {}
end

local function FramePaint(self, w, h)
    local teamid = self.TeamID
    local teamplayingid = TEAMS_PLAYING[self.TeamID]
    local teamtbl = TEAMS[teamid]
    local teaminfo = GAMEMODE.TeamInfos[teamid]
    local framecol = Color(0, 0, 0, 210)
    local teamcol_dimmed = Color(teamtbl.Color.r * 0.7, teamtbl.Color.g * 0.7, teamtbl.Color.b * 0.7,teamtbl.Color.a * 0.8)
    surface.SetDrawColor(framecol)
    surface.SetTexture(texGradRight)
    surface.DrawTexturedRect(0, 0, w, h)

    surface.SetDrawColor(teamtbl.Color)
    surface.DrawTexturedRect(0, 0, w, (h/32))
    surface.DrawRect(w - w/64 + 1, 0, w/64, h)
    surface.DrawTexturedRect(0, h - (h/32) + 1, w, (h/32))
    draw.SimpleTextOutlined(team.NumPlayers(teamplayingid), 'DefaultFontMed', w/4, h/2, teamcol_dimmed, TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM, 1, color_black)



    if self.Score then
        local col = teamtbl['Color']
        local score = self.Score
        local x = 0 + (self:GetWide() - 64)
        local y = 0 + (self:GetTall()/2)
        draw.SimpleTextOutlined(score, 'DefaultFontLarge', x, y, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black)
    end
end

local function CreateTeamInfo(self, teamplayingid)
    local infoid = TEAMS_PLAYING[teamplayingid]

    local w, h = ScrW()/12, ScrH()/18
    local teamprofile = TEAMS[infoid]
    local teaminfo = GAMEMODE.TeamInfos[teamplayingid]
    local i = table.KeyFromValue(GAMEMODE.TeamInfos, teaminfo)
    local frame = vgui.Create('DFrame', self)
    frame:SetSize(w, h)
    frame:SetPos(0, h * teamplayingid)
    frame:SetTitle('')
    frame:SetSizable(false)
    frame:ShowCloseButton(false)
    frame.TeamID = infoid
    frame.TeamPlaying = teamplayingid
    frame.Paint = FramePaint

    table.insert(self.Children, teamplayingid, frame)

    local tbl = frame:GetTable()
    for key, value in pairs(teaminfo) do
        tbl[key] = value
    end

    local csent = ClientsideModel(teamprofile.Captain, RENDERGROUP_OPAQUE)
    local mdl = vgui.Create('DModelPanel', frame)
    mdl:SetEntity(csent)

    mdl:SetSize(w/2, h)
    mdl:SetPos(w/8, 0)
    mdl:SetModel(teamprofile.Captain)
    if teamprofile.Captain_ColorOverall then
        mdl:SetColor(teamprofile.Color)
        else mdl.Entity.GetPlayerColor = function() return teamprofile.Color:ToVector() end 
    end
    mdl.Entity:SetPlaybackRate(0)
    mdl:SetCamPos(Vector(12, -12, 64))
    mdl:SetLookAt(mdl.Entity:GetBonePosition(mdl.Entity:LookupBone("ValveBiped.Bip01_Head1")))
    mdl.LayoutEntity = function(ent)
        --ent:RunAnimation() 
    end
end

function PANEL:UpdateTeamInfo(teamplayingid, key, value)
    local infoid = TEAMS_PLAYING[teamplayingid]
    local children = self.Children
    if children[teamplayingid] then
        local child = children[teamplayingid]
        child[key] = value
        children[teamplayingid] = child
    else
        CreateTeamInfo(self, teamplayingid)
    end


end



vgui.Register('DM_TeamScore', PANEL, 'Panel')