--[[ Key is the actual KEY code that is pressed, the Value indicates the SLOT index in the spell bar or wheel. 
NOTE: An underscore behind it means the spell needs to be casted with the SHIFT down, and SHIFT slots have a negative index (e.g. "[-1], [-2]").
 These together respectively tell the game to recognize what requires shift and what slot is a SHIFT slot.
 --]]
GM.SPELLBINDS_DEFAULT = {
    ['e'] = 1,
    ['r'] = 2,
    ['q'] = 3,
    ['f'] = 4,
    ['g'] = 5,
    ['v'] = 6,
    ['b'] = 7,
    ['c'] = 8,
    -- Shift Binds
    ['_e'] = -1,
    ['_r'] = -2,
    ['_q'] = -3,
    ['_f'] = -4,
    ['_g'] = -5,
    ['_v'] = -6,
    ['_b'] = -7,
    ['_c'] = -8,
}

GM.SPELLWORDS = {

    ['cha'] = 'nox/cha2.ogg',
    ['du'] = 'nox/du2.ogg',
    ['et'] = 'nox/et2.ogg',
    ['in'] = 'nox/in2.ogg',
    ['ka'] = 'nox/ka2.ogg',
    ['ru'] = 'nox/ru2.ogg',
    ['un'] = 'nox/un2.ogg',
    ['zo'] = 'nox/zo2.ogg',
}
--Crosshair Parameters
CreateClientConVar('rtp_ch_sizeX', 1, true, false, 'crosshair size', 0.5, 2)
CreateClientConVar('rtp_ch_sizeY', 1, true, false, 'crosshair size', 0.5, 2)

GM.BuildMenuCategories = {
    ['APPLIANCES'] = {Name = 'Appliances', Icon = 'materials/icon16/wrench.png', Color = Color(48, 106, 214, 255)},
    ['PROPS'] = {Name = 'Props', Icon = 'materials/icon16/bricks.png', Color = Color(153, 153, 153)}
}