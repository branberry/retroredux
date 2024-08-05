PANEL = {}

function PANEL:Init()
    self:SetSize(ScrW(), ScrH())
    self:SetPos(0, 0)
    self.Children = {}
end

local function FramePaint(self, w, h)
    local teamid = self.TeamID
    local teamtbl = TEAMS[teamid]
    local teaminfo = TeamInfos[teamid]
    local framecol = Color(0, 0, 0, 210)
    surface.SetDrawColor(framecol)
    surface.DrawRect(0, 0, w, h)
    if self.score then
        local col = teamtbl["Color"]
        local score = self.score
        local x = 0 + (self:GetWide() / 2)
        local y = 0 + (self:GetTall() / 2)
        draw.SimpleTextOutlined(score, "DefaultFontMed", x, y, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black)
    end
end

local function CreateTeamInfo(self, teamid)

    local w, h = ScrW()/12, ScrH()/18
    local teamprofile = TEAMS[teamid]
    local teaminfo = TeamInfos[teamid]
    local i = table.KeyFromValue(TeamInfos, teaminfo)
    local frame = vgui.Create("DFrame", self)
    frame:SetSize(w, h)
    frame:SetPos(0, h * i)
    frame:SetTitle("")
    frame:SetSizable(false)
    frame:ShowCloseButton(false)
    frame.TeamID = teamid
    frame.Paint = FramePaint
    table.insert(self.Children, teamid, frame)

    local tbl = frame:GetTable()
    for key, value in pairs(teaminfo) do
        tbl[key] = value
    end

end

function PANEL:UpdateTeamInfo(teamid, key, value)
    local children = self.Children
    if children[teamid] then
        local child = children[teamid]
        child[key] = value
        children[teamid] = child
    else
        CreateTeamInfo(self, teamid)
    end


end



vgui.Register("DM_TeamScore", PANEL, "Panel")