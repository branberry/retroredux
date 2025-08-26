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
  if SERVER and pl.InputThink then
    pl:InputThink()
  end
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

function GM:StartCommand(pl, cmd)
local swep = pl:GetActiveWeapon()
  if swep and swep:IsValid() and swep.StartCommand then
    swep:StartCommand(cmd)
  end
end
