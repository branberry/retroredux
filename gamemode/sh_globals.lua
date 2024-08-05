 
GM.GameTypes = {
  ASLT = {
    GameTranslate = 'Assault', 
    Desc = 'Destroy the enemy core while protecting your own!'
  }, 
  BLTZ = {
    GameTranslate = 'Blitz', 
    Desc = 'One ball exists on the map. Bring it to the enemy goal to score!'
  }, 

  KOTH = {
    GameTranslate = 'King Of The Hill', 
    Desc = 'Control the alternating hill area the longest!'
  },

  DM = {
    GameTranslate = 'Deathmatch', 
    Desc = 'First team to reach the elimination goal wins!'
  },

  JUGG = {
    GameTranslate = 'Juggernaut', 
    Desc = 'One mighty foe against all. Killing the juggernaut grants you its title. Be the juggernaut by the end of the game to win!'
  }, 

  AREN = {
    GameTranslate = 'Arena', 
    Desc = 'Massive teams fight to the death in numerous rounds. Team to win the most rounds wins it all!'
  },

  BR = {
    GameTranslate = 'Battle Royale', 
    Desc = 'Every man for themselves in a massive open-map fight that narrows down to one winner.' -- only available with high player count. (like 30, 40 or greater.)
  },

  SIEG = {
    GameTranslate = 'Siege', 
    Desc = 'One team is assigned a tank to push into the base while the other must defend it throughout a period of time.'
  },

  ARCH = {
    GameTranslate = 'Anarchy', 
    Desc = 'Achieve the highest score against everyone else within a set time to win!'
  }
}
CC_CHANGE_CLASS = 'cc_change_class '
SPELLS = {
  Burn = {
    Func = burn,
    Icon = 'spellicons/burn.png',
    Cost = 10,
  }
}

CLASSES = {}

TEAMS = {
  {
    Name = 'Dun Mir', 
    Color = Color(255, 0, 0),
    Icon = '/noxctf/classicons/warrior',  -- Shows up on team selection screen
    Quote = 'Might makes right', 
    SpawnEnt = 'info_player_red' -- The spawn entity used by mappers to declare a spawnpoint for this team.
  }, 
  {
    Name = 'Galava', 
    Color = Color(0, 160, 255), 
    Icon = 'noxctf/classicons/wizard', 
    Quote = 'Knowledge is power', 
    SpawnEnt = 'info_player_blue'
  }, 
  {
    Name = 'Ix', 
    Color = Color(0, 255, 0), 
    Icon = 'noxctf/classicons/conjurer', 
    Quote = 'A balance in all things', 
    SpawnEnt = 'info_player_green'
  }, 
  {
    Name = 'Necromancers', 
    Color = Color(255, 255, 0), 
    Icon = 'noxctf/classicons/necromancer', 
    Quote = 'Death is the answer to everything', 
    SpawnEnt = 'info_player_yellow'
  }
}

TEAMS_PLAYING = {}

