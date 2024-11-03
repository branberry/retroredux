AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
function ENT:Initialize()
	self:DrawShadow(false)
	self.DieTime = CurTime() + 2
	self.ThinkTime = 0.5
	self.Effector = self.Effector or nil
	self:SetStartTime(CurTime())
end

function ENT:GetDieTime()
	local dietime = self.DieTime
	if dietime then return dietime end
end

function ENT:SetDieTime(fTime)
	if fTime < 0 then
		self.DieTime = 99999
		self:SetDuration(99999)
	else
		local ftime = math.Clamp(fTime, 1, 10)
		self.DieTime = CurTime() + ftime
		self:SetDuration(ftime)
	end
end

function ENT:SESetPlayer(pl, exists, args)
	local class = self:GetClass()
	local burn = pl[class]
	if args then
		if args.dur then
			self:SetDuration(args.dur)
		else
			self:SetDuration(4)
		end
	else
		self:SetDuration(4)
	end

	if exists and burn:IsValid() then
		if self:GetDuration() >= 0 then
			burn:SetDieTime(burn:GetDuration() + self:GetDuration())
		else
			burn:SetDieTime(-1)
		end

		self.Additive = true
		self:SetOwner(pl)
		self:Remove()
	else
		self.Additive = false
		pl[class] = self
		self:SetOwner(pl)
		self:SetParent(pl)
	end
end

function ENT:Think()
	local owner = self:GetOwner()
	if owner:WaterLevel() < 0 or not owner:Alive() or (self.DieTime <= CurTime()) then
		self:Remove()
	else
		owner:TakeSpecialDamage(25, DMG_GENERIC, self.Effector, self)
		self:NextThink(self.ThinkTime)
	end
end

function ENT:OnRemove()
	local owner = self:GetOwner()
	if not self.Additive then owner[self:GetClass()] = nil end
end