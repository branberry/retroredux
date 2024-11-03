CC_CHANGE_CLASS = 'cc_change_class '
SPELLS = {
  Burn = {
    Func = burn,
    Icon = 'spellicons/burn.png',
    Cost = 10,
  }
}

GAMETYPES = {}
CLASSES = {}
TEAMS = {
  {
    Name = 'Dun Mir',
    Color = Color(255, 0, 0),
    Icon = '/noxctf/classicons/warrior', -- Shows up on team selection screen.
    Quote = 'Might makes right',
    SpawnEnt = 'info_player_red', -- The spawn entity used by mappers to declare a spawnpoint for this team.
    Captain = 'models/player/soldier_stripped.mdl', -- Used in DModelPanels and such
    Captain_ColorOverall = true,
    Captain_Anims = {
      ['Idle'] = {'idle_melee_angry', 'idle_all_angry', 'idle_fist', 'idle_suitcase'},
      ['Taunt'] = {'gesture_salute', 'taunt_cheer', 'taunt_dance', 'taunt_laugh', 'gesture_becon_base_layer', 'seq_baton_swing'}
    }
  },
  {
    Name = 'Galava',
    Color = Color(0, 160, 255),
    Icon = 'noxctf/classicons/wizard',
    Quote = 'Knowledge is power',
    Captain = 'models/player/breen.mdl',
    SpawnEnt = 'info_player_blue',
    Captain_Anims = {
      ['Idle'] = {'menu_gman', 'idle_magic'},
      ['Taunt'] = {'menu_gman', 'gesture_wave_original'}
    }
  },
  {
    Name = 'Ix',
    Color = Color(0, 255, 0),
    Icon = 'noxctf/classicons/conjurer',
    Quote = 'A balance in all things',
    Captain = 'models/player/alyx.mdl',
    SpawnEnt = 'info_player_green',
    Captain_Anims = {
      ['Idle'] = {'pose_standing_02', 'pose_standing_03', 'idle_suitcase'},
      ['Taunt'] = {'taunt_persistence', 'gesture_signal_group', 'gesture_item_drop'}
    }
  },
  {
    Name = 'Necromancers',
    Color = Color(255, 255, 0),
    Icon = 'noxctf/classicons/necromancer',
    Captain = 'models/player/corpse1.mdl',
    Quote = 'Death is the answer to everything',
    SpawnEnt = 'info_player_yellow',
    Captain_Anims = {
      ['Idle'] = {'idle_all_scared', 'idle_knife', 'zombie_idle_01', 'zombie_run', 'zombie_walk_06'},
      ['Taunt'] = {'zombie_climb_end', 'taunt_zombie_original', 'menu_zombie1', 'zombie_attack_03', 'taunt_zombie_pelvis_layer', 'zombie_attack_frenzy', 'death_01', 'death_02', 'death_03', 'death_04'}
    }
  }
}

TEAMS_PLAYING = {}
HONORABLE_MENTIONS = {
  {
    Title = 'Killer Kapitalist',
    Subtitle = 'hm_killerkapitalist_sub' -- Translation ID
  },
  {
    Title = 'Marxist',
    Subtitle = 'hm_marxist_sub'
  },
  {
    Title = 'Healer',
    Subtitle = 'hm_healer_sub'
  },
  {
    Title = 'Handy Man',
    Subtitle = 'hm_handyman_sub'
  },
  {
    Title = 'Builder',
    Subtitle = 'hm_builder_sub'
  },
  {
    Title = 'Obliterator',
    Subtitle = 'hm_obliterator_sub'
  },
  {
    Title = 'Unibomber',
    Subtitle = 'hm_unibomber_sub'
  },
  {
    Title = 'Magician',
    Subtitle = 'hm_magician_sub'
  },
  {
    Title = 'The Ripper',
    Subtitle = 'hm_ripper_sub',
    Func = 'hm_func_theripper'
  },
  {
    Title = 'Dispenser',
    Subtitle = 'hm_dispenser_sub',
  },
  {
    Title = 'Gaben',
    Subtitle = 'hm_gaben_sub',
  },
  {
    Title = 'Rider',
    Subtitle = 'hm_rider_sub',
  }
}

GM.HonorableMentions = {}
GM.RoundEndResults = {}
GM.RoundStatus = 0