include("shared.lua")

function GAMEMODE:GameTypeInit()
    gamemode.Call("CreateVGUI")
end

function GAMEMODE:CreateVGUI()
    if !GAMEMODE.GameStatePanel then
      GAMEMODE.GameStatePanel = vgui.Create('GameState')
    end
  
    if !gt_ScoreUI then
      gt_ScoreUI = vgui.Create('DM_TeamScore')
    end
  end

function GAMEMODE:GameTypeHandleRoundStatusUpdate(status, instant)
  if GAMEMODE.GameStatePanel then
    if status == 0 then
      GAMEMODE.GameStatePanel:SetObjText('Grace Period')

    elseif status == 1 then

      GAMEMODE.GameStatePanel:SetObjText('Round Time')

      if instant then
        gamemode.Call('SendCenterNotify', 'And The Grace Period Has ENDED!', 'DefaultFontMed', Color(255,255,255), 5, 'nox/nflagdrop.ogg')
        gamemode.Call('SendCenterNotify', 'THE ROUND HAS BEGUN!', 'DefaultFontLarge', Color(255, 0, 0), 5, '', {icon = 'killicon/warhammer.vmt', color = Color(255, 0, 0), size = 128})
        LocalPlayer():ViewPunch(Angle(5,0,0))
      end
    elseif status == 2 then

      GAMEMODE.GameStatePanel:SetObjText('Overtime')
      gamemode.Call('SendCenterNotify', 'An extra 5 minutes was granted to the round!', 'DefaultFontMed', Color(255,255,255), 5, '')
      gamemode.Call('SendCenterNotify', 'OVERTIME', 'DefaultFontLarge', Color(255, 255, 0), 5, 'nox/forceofnature_start.ogg', {icon = 'killicon/warhammer.vmt', color = Color(255, 255, 0), size = 128})
      util.ScreenShake(LocalPlayer():GetPos(), 6, 1, 1, 256, true)
      
    end
  end

end