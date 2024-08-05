PANEL = {}

function PANEL:Init()
    self:SetPos(0, 0)
    self:SetSize(ScrW(), ScrH())
    self:MakePopup()
end

function PANEL:Paint()
Derma_DrawBackgroundBlur(self)
draw.SimpleText('SELECT YOUR TEAM', 'DefaultFontMed', ScrW()/2, ScrH()/4, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

vgui.Register('TeamSelect', PANEL, 'DPanel')


local function FramePaint()

end

local function ButtonPaint(self)
    local TeamInfo = TEAMS[self.teamid]
    local plys = team.GetPlayers(self.teamid)
    local texquad = {
        texture = surface.GetTextureID(TeamInfo.Icon),
        color   = Color( 255, 255, 255),
        x 	= self:GetWide() * 0.1,
        y 	= self:GetTall() * 0.1,
        w 	= self:GetWide() * 0.8,
        h 	= self:GetTall() * 0.8
    }


    if self:IsDown() then
        surface.SetDrawColor(TeamInfo.Color.r - 160, TeamInfo.Color.g - 160, TeamInfo.Color.b - 160, 255)
        
        else if self:IsHovered() then
            surface.SetDrawColor(TeamInfo.Color.r + 64, TeamInfo.Color.g + 64, TeamInfo.Color.b + 64, 255)
        else
        surface.SetDrawColor(TeamInfo.Color.r - 96, TeamInfo.Color.g - 96, TeamInfo.Color.b - 96, 255)
    
        end
    end
    surface.DrawRect(0, 0, self:GetWide(), self:GetTall())
    surface.SetDrawColor(TeamInfo.Color)
    surface.DrawOutlinedRect(4,4, self:GetWide() - 8, self:GetTall() - 8, 4)
    draw.TexturedQuad(texquad)
    draw.SimpleText(TeamInfo.Name, 'DefaultFontMed', self:GetWide() / 2, self:GetTall() / 8, Color(TeamInfo.Color.r + 180, TeamInfo.Color.g + 180, TeamInfo.Color.b + 180), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    draw.SimpleText(#plys .. ' / ' .. math.Round(game.MaxPlayers()/#TEAMS_PLAYING), 'DefaultFontMed', self:GetWide() / 2, self:GetTall() * 0.8, Color(TeamInfo.Color.r + 180, TeamInfo.Color.g + 180, TeamInfo.Color.b + 180), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end


function RemoveTeamSelect()
    panelteamselect:Remove()
end

local function ButtonDoClickEvent(self)
    RunConsoleCommand('nox_teamswitch', tostring(self.teamid))
    RemoveTeamSelect()
end

local function DrawTeams(panelteamselect, screens, centx, centy)

local teamscount = #TEAMS_PLAYING
local b = 0.6 * screens
local w, h = (1024 * b) / teamscount, (2048 * b) / teamscount
local margin = w/8

local column = centx - ((w/2 * teamscount) + margin/2)

    for i, teamid in pairs(TEAMS_PLAYING) do


        local button = vgui.Create('DButton', panelteamselect)
        button:SetSize(w, h)
        button:SetPos(column, (centy - h/2))
        button:SetText('')
        button.teamid = teamid
        button.DoClick = ButtonDoClickEvent
        button.Paint = ButtonPaint

        column = column + (w + margin)
    end
end

function DrawTeamSelect()
    if panelteamselect and panelteamselect:IsValid() then RemoveTeamSelect()
    else

        panelteamselect = vgui.Create('TeamSelect')
        panelteamselect:MakePopup()

        local screens = math.min(1, ((ScrW() / 3840) + 0.5) ^ 2)
        local centx, centy = ScrW()/2, ScrH()/2
        DrawTeams(panelteamselect, screens, centx, centy)



    end
end