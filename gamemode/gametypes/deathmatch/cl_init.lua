include("shared.lua")

function GAMEMODE:GameTypeInit()
    gamemode.Call("CreateVGUI")
end

function GAMEMODE:CreateVGUI()
    if !GameStatePanel then
      GameStatePanel = vgui.Create('GameState')
    end
  
    if !gt_ScoreUI then
      gt_ScoreUI = vgui.Create('DM_TeamScore')
    end
  end