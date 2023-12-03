AddCSLuaFile()

GM.MinBandages = 1
GM.MaxBandages = 10 -- maximum bandages a player can carry
GM.DefaultBandages = 2 -- how many bandages we should start out with when we first join the server
GM.BandageWeight = 0.1 -- how much each individual bandage weighs
GM.BandageDistance = 50 -- distance between us and another player to bandage them

if CLIENT then
	CreateClientConVar("gc_bandages", GM.DefaultBandages, true, true)
end

if SERVER then
	util.AddNetworkString("GC_HEALSTATE")
end

local PLAYER = FindMetaTable("Player")

local traceData = {}

function PLAYER:getBandageTarget()
	if self.bleeding then -- first and foremost we must take care of our own wounds
		return self
	end
	
	local target = nil
	
	traceData.start = self:GetShootPos()
	traceData.endpos = traceData.start + self:GetAimVector() * GAMEMODE.BandageDistance
	traceData.filter = self
	
	local trace = util.TraceLine(traceData)
	local ent = trace.Entity
	
	if IsValid(ent) and ent:IsPlayer() then
		if self:canBandage(ent) then
			target = ent
		end
	end
	
	return target
end

function PLAYER:canBandage(target)
	if not IsValid(target) or not self:Alive() or target:Team() ~= self:Team() or self.bandages <= 0 then
		return false
	end
	
	local wep = self:GetActiveWeapon()
	
	if IsValid(wep) and (wep.CW20Weapon and CurTime() < wep.GlobalDelay) then
		return false
	end
	
	if SERVER then
		if not target.bleeding and not target.crippledArm then
			return false
		end
	elseif CLIENT then
		if not target:hasStatusEffect("bleeding") and not target:hasStatusEffect("crippled_arm") then
			return false
		end
	end
	
	return true
end

function PLAYER:setBleeding(bleeding, bleedGrade)
	self.bleeding = bleeding
	self.bleedGrade = bleedGrade or 0
	
	if SERVER then
		self:sendBleedState()
		
		if not bleeding and (self.regenPool and self.regenPool > 0) then
			self:sendStatusEffect("healing", true)
		end
		
		if not bleeding then
			self.bleedInflictor = nil
		end
	else
		self:setStatusEffect("bleeding", bleeding)
	end
end

function PLAYER:setBandages(bandages)
	bandages = bandages or GAMEMODE.DefaultBandages
	
	self.bandages = bandages
	
	if SERVER then
		self:sendBandages()
	end
end

function PLAYER:resetBleedData()
	self.bleedGrade = 0
	self:setBleeding(false)
	self.bleedInflictor = nil
	self.bleedHealthDrainTime = 0
	self.healAmount = 0
	self.healAmountAlly = 0
end

-- for when you need to network
function PLAYER:setHealGrade(grade)
	self.healGrade = grade
	
	if SERVER then
		self:sendHealGrade()
	end

	self:setStatusEffect("healed", grade > 0)
end

function PLAYER:sendHealGrade()
	net.Start("GC_HEALSTATE")
		net.WriteEntity(self)
		net.WriteUInt(self.healGrade, 8)
	net.Send(team.GetPlayers(self:Team()))
end

function PLAYER:getHealGrade()
	return self.healGrade or 0
end

function PLAYER:resetHealData()
	self.healGrade = 0
end

function PLAYER:getDesiredBandageCount()
	if GAMEMODE.curGametype.getDesiredBandageCount then
		local count = GAMEMODE.curGametype:getDesiredBandageCount(self)
		
		if count then
			return count
		end
	end
	
	return math.Clamp(self:GetInfoNum("gc_bandages", GAMEMODE.DefaultBandages), GAMEMODE.MinBandages, GAMEMODE.MaxBandages)
end

function GM:getBandageWeight(bandageCount)
	return bandageCount * self.BandageWeight
end

if CLIENT then
	concommand.Add("gc_bandage", function(ply, com, args)
		local SWEAPOM = ply:GetWeapon(GAMEMODE.MedkitClass)
		
		if IsValid(SWEAPOM) then
			local bandageTarget = ply:getBandageTarget()
			
			if IsValid(bandageTarget) then
				input.SelectWeapon(SWEAPOM)
			end
		end
	end)
end