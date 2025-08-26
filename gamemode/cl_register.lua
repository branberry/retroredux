GM.SpellTables = {}
GM.MusicDirs = {}

function GM:RegisterSpellTables()
    local dirs = file.Find('spelltables.txt', 'DATA')
    if dirs[1] then
        local data = file.Read(dirs[1])
        local tbl = util.KeyValuesToTable(data)

        self.SpellTables = tbl
    end
end

GM:RegisterSpellTables()

function GM:RegisterMusicDirs()
local dirs = file.Find('sound/retroteamplay/music/*', 'GAME')
    self.MusicDirs = dirs
end