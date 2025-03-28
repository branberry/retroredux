GM.SpellTables = {}

function GM:RegisterSpellTables()
    local dirs = file.Find('spelltables.txt', 'DATA')
    if dirs[1] then
        local data = file.Read(dirs[1])
        local tbl = util.KeyValuesToTable(data)

        self.SpellTables = tbl
    end
end

GM:RegisterSpellTables()