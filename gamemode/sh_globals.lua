CC_CHANGE_CLASS = 'cc_change_class '

GAMETYPES = {}

CLASSES = {}

SPELLS = {}

STATUS_EFFECTS = {}

TEAMS = {
  {
    Name = 'Dun Mir', 
    Color = Color(255, 0, 0),
    Icon = '/noxctf/classicons/warrior',  -- Shows up on team selection screen.
    Quote = 'Might makes right', 
    SpawnEnt = 'info_player_red', -- The spawn entity used by mappers to declare a spawnpoint for this team.
    DefMusic = 'castawaylili',

    Captain = 'models/player/soldier_stripped.mdl', -- Used in DModelPanels and such
    Captain_ColorOverall = true,

    Captain_Anims = {
    ['Idle'] = {'idle_melee_angry', 'idle_all_angry', 'idle_fist', 'idle_suitcase'},
    ['Taunt'] = {'gesture_salute', 'taunt_cheer', 'taunt_dance', 'taunt_laugh', 'gesture_becon_base_layer', 'seq_baton_swing'}}
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
    ['Taunt'] = {'menu_gman', 'gesture_wave_original'}}
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
    ['Taunt'] = {'taunt_persistence', 'gesture_signal_group', 'gesture_item_drop'}}
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
      ['Taunt'] = {'zombie_climb_end', 'taunt_zombie_original', 'menu_zombie1', 'zombie_attack_03', 'taunt_zombie_pelvis_layer', 'zombie_attack_frenzy', 'death_01', 'death_02', 'death_03', 'death_04'}}
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

GM.SpellSlots = 16

GM.FlinchGestures = { -- Key is Enum HITGROUP, value is Enum ACT
  [0] = ACT_FLINCH,
  [1] = ACT_FLINCH_CHEST,
  [2] = ACT_FLINCH_HEAD,
  [3] = ACT_FLINCH_STOMACH,
  [4] = ACT_FLINCH_LEFTARM,
  [5] = ACT_FLINCH_RIGHTARM,
  [6] = ACT_FLINCH_LEFTLEG,
  [7] = ACT_FLINCH_LEFTLEG
}



GM.BuildProps = {}

function GM:RegisterBuildProp(id, tbl)
self.BuildProps[id] = tbl
end

GM:RegisterBuildProp('BPROP_SLIMWALL',
  {
    Name = 'Slim Wall',
    Desc = 'A small brittle metal wall. Good for closing small exposed gaps.',
    Category = 'PROPS',
    SubCategory = 'Walls',
    Ent = 'prop_prop',
    Mdl = 'models/props_lab/blastdoor001b.mdl',
    HP = 600,
    DefaultMat = 'METAL',
  })

  GM:RegisterBuildProp('BPROP_WIDEWALL',
  {
    Name = 'Wide Wall',
    Desc = 'A brittle wall, nothing pretty but protective.',
    Category = 'PROPS',
    SubCategory = 'Walls',
    Ent = 'prop_prop',
    Mdl = 'models/props_lab/blastdoor001c.mdl',
    HP = 750,
    DefaultMat = 'METAL',
  })

  GM:RegisterBuildProp('BPROP_FENCE',
  {
    Name = 'Fence',
    Desc = 'A double wooden box designed for primitive structures.',
    Category = 'PROPS',
    SubCategory = 'Walls',
    Ent = 'prop_prop',
    Mdl = 'models/props_wasteland/wood_fence01a.mdl',
    HP = 600,
    DefaultMat = 'WOOD',
  })

  GM:RegisterBuildProp('BPROP_4X4BOX',
  {
    Name = '4x4 Box',
    Desc = 'A wooden box designed for primitive structures.',
    Category = 'PROPS',
    SubCategory = 'Misc',
    Ent = 'prop_prop',
    Mdl = 'models/props_junk/wood_crate001a.mdl',
    HP = 250,
    DefaultMat = 'WOOD',
  })

  GM:RegisterBuildProp('BPROP_4X8BOX',
  {
    Name = '4x8 Box',
    Desc = 'A double wooden box designed for primitive structures.',
    Category = 'PROPS',
    SubCategory = 'Misc',
    Ent = 'prop_prop',
    Mdl = 'models/props_junk/wood_crate001a.mdl',
    HP = 250,
    DefaultMat = 'WOOD',
  })

  GM:RegisterBuildProp('BPROP_SMALLPOLE',
  {
    Name = 'Small Pole',
    Desc = 'A short stick handy for holding structures together.',
    Category = 'PROPS',
    SubCategory = 'Misc',
    Ent = 'prop_prop',
    Mdl = 'models/props_docks/dock01_pole01a_128.mdl',
    HP = 500,
    DefaultMat = 'WOOD',
  })

  GM:RegisterBuildProp('BPROP_PALLET',
  {
    Name = 'PALLET',
    Desc = 'A Wooden pallet normally used to put crates on.',
    Category = 'PROPS',
    SubCategory = 'Misc',
    Ent = 'prop_prop',
    Mdl = 'models/props_junk/wood_pallet001a.mdl',
    HP = 500,
    DefaultMat = 'WOOD',
  })

  GM:RegisterBuildProp('BPROP_OILDRUM',
  {
    Name = 'Oil Drum',
    Desc = 'A metal Drum previous used to store oil and other volatile fluids.',
    Category = 'PROPS',
    SubCategory = 'Misc',
    Ent = 'prop_prop',
    Mdl = 'models/props_c17/oildrum001.mdl',
    HP = 450,
    DefaultMat = 'METAL',
  })

  GM:RegisterBuildProp('BPROP_SHORTPANEL',
  {
    Name = 'Short Panel',
    Desc = 'A short strip of metal. Clunky but also damp.',
    Category = 'PROPS',
    SubCategory = 'Misc',
    Ent = 'prop_prop',
    Mdl = 'models/props_debris/metal_panel02a.mdl',
    HP = 400,
    DefaultMat = 'METAL',
  })

  GM:RegisterBuildProp('BPROP_LONGPANEL',
  {
    Name = 'Long Panel',
    Desc = "A long strip of metal. Meant to be protective, or shoved into someone's forehead.",
    Category = 'PROPS',
    SubCategory = 'Misc',
    Ent = 'prop_prop',
    Mdl = 'models/props_debris/metal_panel01a.mdl',
    HP = 600,
    DefaultMat = 'METAL',
  })

  GM:RegisterBuildProp('BPROP_SHIELDBARRICADE',
  {
    Name = 'Shielded Barricade',
    Desc = 'A design copied off a mysterious army which were briefly mentioned in history but sworn mythological. Nontheless very protective.',
    Category = 'PROPS',
    SubCategory = 'Walls',
    Ent = 'prop_prop',
    Mdl = 'models/props_combine/combine_barricade_short01a.mdl',
    HP = 600,
    DefaultMat = 'METAL',
  })

  GM:RegisterBuildProp('BPROP_BARS',
  {
    Name = 'Bars',
    Desc = 'Metal bars designed to keep people in or out.',
    Category = 'PROPS',
    SubCategory = 'Walls',
    Ent = 'prop_prop',
    Mdl = 'models/props_wasteland/prison_gate001b.mdl',
    HP = 800,
    DefaultMat = 'METAL',
  })

  GM:RegisterBuildProp('BPROP_BARRIER',
  {
    Name = 'Barrier',
    Desc = 'A barrier that was once a defensive hazard acknowledgement, now an offensive one.',
    Category = 'PROPS',
    SubCategory = 'Walls',
    Ent = 'prop_prop',
    Mdl = 'models/props_c17/concrete_barrier001a.mdl',
    HP = 650,
    DefaultMat = 'METAL',
  })

  GM:RegisterBuildProp('BPROP_WIDEFORTRESSWALL',
  {
    Name = 'Wide Fortress Wall',
    Desc = 'A design copied off a mysterious army which were briefly mentioned in history but sworn mythological. Nontheless very protective.',
    Category = 'PROPS',
    SubCategory = 'Walls',
    Ent = 'prop_prop',
    Mdl = 'models/props_combine/combine_barricade_med03b.mdl',
    HP = 850,
    DefaultMat = 'METAL',
  })

  GM:RegisterBuildProp('BPROP_SHORTFORTRESSWALL',
  {
    Name = 'Short Fortress Wall',
    Desc = 'A design copied off a mysterious army which were briefly mentioned in history but sworn mythological. Nontheless very protective.',
    Category = 'PROPS',
    SubCategory = 'Walls',
    Ent = 'prop_prop',
    Mdl = 'models/props_combine/combine_barricade_med01a.mdl',
    HP = 800,
    DefaultMat = 'METAL',
  })

  GM:RegisterBuildProp('BPROP_TALLFORTRESSWALL',
  {
    Name = 'Tall Fortress Wall',
    Desc = 'A design copied off a mysterious army which were briefly mentioned in history but sworn mythological. Nontheless very protective.',
    Category = 'PROPS',
    SubCategory = 'Walls',
    Ent = 'prop_prop',
    Mdl = 'models/props_combine/combine_barricade_tall01a.mdl',
    HP = 800,
    DefaultMat = 'METAL',
  })

  GM:RegisterBuildProp('BPROP_SLOTTEDFORTRESSWALL',
  {
    Name = 'Slotted Fortress Wall',
    Desc = 'A design copied off a mysterious army which were briefly mentioned in history but sworn mythological. Nontheless very protective.',
    Category = 'PROPS',
    SubCategory = 'Walls',
    Ent = 'prop_prop',
    Mdl = 'models/props_combine/combine_barricade_med02b.mdl',
    HP = 800,
    DefaultMat = 'METAL',
  })
