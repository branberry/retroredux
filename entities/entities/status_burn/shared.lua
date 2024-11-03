ENT.Type = "anim"
ENT.Base = "status__base"
function ENT:SetupDataTables()
    self:NetworkVar('Float', 0, 'Duration')
    self:NetworkVar('Float', 1, 'StartTime')
end