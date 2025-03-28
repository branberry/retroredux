GM.Name = 'Retro Redux'
GM.Author = 'Bran, Peter'
GM.Email = 'N/A'
GM.Website = 'N/A'
include('obj_entity_extend.lua')
include('obj_player_extend.lua')
include('sh_colors.lua')
include('sh_globals.lua')
include('sh_register.lua')
include('sh_util.lua')
include('sh_translate.lua')
include('sh_anim.lua')

GM.GameType = 'DM'
GM.DisabledSpells = {}
GM.DisabledClasses = {}

function GM:Initialize()
end


function GM:Move(pl, mv)
  local shouldoverride = false
  if pl.SpellsActive then
  for i, v in pairs(pl.SpellsActive) do
    local spellclass = SPELLS[i]
    local spelltbl = spellclass.TABLE
    if spelltbl.PreMove then
        shouldoverride = spelltbl:PreMove(pl, mv)
    end

    if spelltbl.PostMove then
      shouldoverride = spelltbl:PostMove(pl, mv)
    end
  return shouldoverride
  end
end
end
