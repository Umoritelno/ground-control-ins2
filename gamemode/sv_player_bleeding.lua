include("sh_player_bleeding.lua")

GM.BleedTime = 5 -- we will lose BleedHealthLose health points this amount of seconds
GM.BleedHealthLose = 1 -- how much health should we lose per bleed tick
GM.BleedGradePerBleed = 1 -- change in our bleed grade every time we take damage that causes us to bleed
GM.MaxBleedGrade = 5 -- maximum bleed grade; a bleed grade indicates how much health we lose per each bleed tick, so bleed grade 1 = 1 hp lost; bleed grade of 3 = 3 hp lost
GM.BandageTime = 2.3

local PLAYER = FindMetaTable("Player")

function PLAYER:shouldBleed()
	return CurTime() >= self.bleedHealthDrainTime and not self.healing
end

function PLAYER:bleed(silentBleed)
	self:SetHealth(self:Health() - GAMEMODE.BleedHealthLose * self.bleedGrade)
	self:delayBleed()
	self:postBleed()
	
	if not silentBleed then
		self:EmitSound("GC_BLEED")
	end
end

function PLAYER:delayBleed(time)
	time = time or GAMEMODE.BleedTime
	self.bleedHealthDrainTime = CurTime() + time
end

function PLAYER:postBleed()
	if self:Health() <= 0 then -- if we have no health left after bleeding, we die
		self:Kill()
		
		if IsValid(self.bleedInflictor) then -- reward whoever caused us to bleed
			self.bleedInflictor:addCurrency(GAMEMODE.CashPerKill, GAMEMODE.ExpPerKill, "BLEED_OUT_KILL", ply)
			self.bleedInflictor = nil
		end
	end
end

function PLAYER:startBleeding(bleedInflictor)
	-- delay bleeding only if we're not bleeding yet here
	if not self.bleeding then
		self:delayBleed()
	end
	
	if bleedInflictor then
		self.bleedInflictor = bleedInflictor -- the person that caused us to bleed
	end
	
	self.bleedGrade = math.min(GAMEMODE.MaxBleedGrade, self.bleedGrade + GAMEMODE.BleedGradePerBleed)
	self:setBleeding(true, self.bleedGrade)
end

util.AddNetworkString("GC_BLEEDSTATE")

function PLAYER:sendBleedState()
	net.Start("GC_BLEEDSTATE")
		net.WriteEntity(self)
		net.WriteBool(self.bleeding)
		net.WriteUInt(self.bleedGrade, 8)
	net.Send(team.GetPlayers(self:Team()))
end

function PLAYER:attemptBandage()
	if not self:Alive() then
		return
	end
	
	local target = self:getBandageTarget()
	
	if self:canBandage(target) then
		target:bandage(self)
	end
end

function PLAYER:useBandage()
	self.bandages = self.bandages - 1
end

function PLAYER:bandage(bandagedBy)
	bandagedBy = bandagedBy or self
	
	bandagedBy:useBandage()
	bandagedBy:EmitSound("GC_BANDAGE")
	bandagedBy:sendBandages()
	bandagedBy:setWeight(bandagedBy:calculateWeight())
	
	local wep = bandagedBy:GetActiveWeapon()
	
	if IsValid(wep) and wep.CW20Weapon then
		wep:setGlobalDelay(GAMEMODE.BandageTime + 0.3, true, CW_ACTION, GAMEMODE.BandageTime)
	end
	
	local wasBleeding = self.bleeding
	
	self:setBleeding(false)

	if bandagedBy ~= self then
		if bandagedBy.canUncrippleLimbs and self:uncrippleArm() then
			bandagedBy:addCurrency(GAMEMODE.CashPerUncripple, GAMEMODE.ExpPerUncripple, "TEAMMATE_UNCRIPPLED")
		end
	
		bandagedBy:addCurrency(GAMEMODE.CashPerBandage, GAMEMODE.ExpPerBandage, "TEAMMATE_BANDAGED")
		GAMEMODE:trackRoundMVP(bandagedBy, "bandaging", 1)
		
		if wasBleeding then
			self:restoreHealth(bandagedBy.healAmountAlly)
		end
	else
		self:restoreHealth(bandagedBy.healAmount)
	end
end

function PLAYER:sendBandages()
	umsg.Start("GC_BANDAGES", self)
		umsg.Short(self.bandages)
	umsg.End()
end

umsg.PoolString("GC_BANDAGES")

--[[concommand.Add("gc_bandage", function(ply, com, args)
	ply:attemptBandage()
end)]]