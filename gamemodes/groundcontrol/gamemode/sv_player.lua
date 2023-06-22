GM.CashPerKill = 50
GM.ExpPerKill = 20

GM.CashPerAssist = 50 -- depends on damage dealt, if you dealt 99.9% damage, you'll get 50$
GM.ExpPerAssist = 40

GM.CashPerSave = 25 -- every time we "save" someone (aka we kill a target that was about to kill one of our guys), we get this much money
GM.ExpPerSave = 40

GM.CashPerMateHelp = 15 -- every time we "help a teammate" (aka we kill a target who was recently firing at our teammate), we get this much money
GM.ExpPerMateHelp = 30

GM.CashPerCloseCall = 15 -- every time we kill our assailant and have less or equal to MinHealthForCloseCall, we get this much money
GM.ExpPerCloseCall = 5

GM.CashPerHeadshot = 10
GM.ExpPerHeadshot = 5

GM.CashPerBandage = 20 -- we get this much money when we bandage our teammate
GM.ExpPerBandage = 25

GM.CashPerUncripple = 20
GM.ExpPerUncripple = 25

GM.CashPerHeal = 20
GM.ExpPerHeal = 40

GM.CashPerResupply = 5 -- we get this much money when we resupply someone's ammo
GM.ExpPerResupply = 15

GM.MinHealthForCloseCall = 15
GM.MinHealthForSave = 20
GM.SaveEventTimeWindow = 5

GM.CashPerOneManArmy = 15
GM.ExpPerOneManArmy = 5

GM.CashPerTeamKill = -200
GM.ExpPerTeamKill = -400

GM.defaultAFKTimerValue = 240 -- default amount of time to wait before kicking someone out for AFK
GM.warnAFKTimeout = 30 -- warn the palyer of AFK if he has this much time until he gets kicked for AFK

GM.jumpPower = 220
GM.jumpPowerMin = 190 -- jump power will not go lower than this much regardless of weight
GM.jumpPowerReductionPerKG = 1.5 -- reduce jump power by this much per each kilogram worth of weight
GM.jumpPowerWeightCutoff = 2 -- jump power will not be reduced until the amount of weight on us is less than this much

util.AddNetworkString("GC_KILLED_BY")
GM.SendCurrencyAmount = {cash = nil, exp = nil}

GM.defaultTeamDamageScale = 0.5

GM.alwaysDropWeapons = { -- weapon classes the presence of which in the player's inventory will always be dropped upon death
	cw_flash_grenade = true,
	cw_frag_grenade = true,
	cw_smoke_grenade = true
}

CreateConVar("gc_proximity_voicechat", 0, {FCVAR_ARCHIVE, FCVAR_NOTIFY}) -- if set to 1, nearby enemies will be able to hear other enemies speak
CreateConVar("gc_proximity_voicechat_distance", 256, {FCVAR_ARCHIVE, FCVAR_NOTIFY}) -- distance in source units within which players will hear other players
CreateConVar("gc_proximity_voicechat_global", 0, {FCVAR_ARCHIVE, FCVAR_NOTIFY}) -- if set to 1, everybody, including your team mates and your enemies, will only hear each other within the distance specified by gc_proximity_voicechat_distance
CreateConVar("gc_proximity_voicechat_directional", 0, {FCVAR_ARCHIVE, FCVAR_NOTIFY}) -- if set to 1, voice chat will be directional 3d sound (as described in the gmod wiki)
CreateConVar("gc_invincibility_time_period", 3, {FCVAR_ARCHIVE, FCVAR_NOTIFY}) -- how long should the player be invincible for after spawning (for anti spawn killing in gametypes like urban warfare)
CreateConVar("gc_team_damage", 1, {FCVAR_ARCHIVE, FCVAR_NOTIFY}) -- whether team damage is enabled
CreateConVar("gc_team_damage_scale", GM.defaultTeamDamageScale, {FCVAR_ARCHIVE, FCVAR_NOTIFY}) -- scale the same-team damage by this much
CreateConVar("gc_afk_timer", GM.defaultAFKTimerValue, {FCVAR_ARCHIVE, FCVAR_NOTIFY}) -- time in seconds that a player can remain without any input before we kick him out

GM:registerAutoUpdateConVar("gc_proximity_voicechat", function(cvarName, oldValue, newValue)
	newValue = tonumber(newValue)
	GAMEMODE.proximityVoiceChat = newValue >= 1
end)

GM:registerAutoUpdateConVar("gc_proximity_voicechat_distance", function(cvarName, oldValue, newValue)
	newValue = tonumber(newValue)
	GAMEMODE.proximityVoiceChatDistance = newValue
end)

GM:registerAutoUpdateConVar("gc_proximity_voicechat_global", function(cvarName, oldValue, newValue)
	newValue = tonumber(newValue)
	GAMEMODE.proximityVoiceChatGlobal = newValue >= 1
end)

GM:registerAutoUpdateConVar("gc_proximity_voicechat_directional", function(cvarName, oldValue, newValue)
	newValue = tonumber(newValue)
	GAMEMODE.proximityVoiceChatDirectional3D = newValue >= 1
end)

GM:registerAutoUpdateConVar("gc_invincibility_time_period", function(cvarName, oldValue, newValue)
	newValue = tonumber(newValue)
	GAMEMODE.postSpawnInvincibilityTimePeriod = newValue or 3
end)

GM:registerAutoUpdateConVar("gc_team_damage", function(cvarName, oldValue, newValue)
	newValue = tonumber(newValue)
	GAMEMODE.noTeamDamage = newValue <= 0
end)

GM:registerAutoUpdateConVar("gc_team_damage_scale", function(cvarName, oldValue, newValue)
	newValue = tonumber(newValue)
	
	GAMEMODE.teamDamageScale = newValue or GAMEMODE.defaultTeamDamageScale
end)

GM:registerAutoUpdateConVar("gc_afk_timer", function(cvarName, oldValue, newValue)
	newValue = tonumber(newValue) or GAMEMODE.defaultAFKTimerValue
	
	GAMEMODE.afkTime = newValue
end)

local PLAYER = FindMetaTable("Player")

function GM:PlayerInitialSpawn(ply)
	ply:resetSpawnData()

	ply:SetTeam(TEAM_SPECTATOR)
	ply:KillSilent()
	player_manager.SetPlayerClass(ply,"soldier")
	ply:resetSpectateData()

	ply:loadAttachments()
	ply:loadCash()
	ply:loadExperience()
	ply:loadUnlockedAttachmentSlots()
	ply:loadTraits()
	ply.lastDataRequest = 0
	ply.invincibilityPeriod = 0
	ply:SetNWInt("GC_SCORE", 0)
	ply:SetDTFloat(0, 1) -- movement speed multiplier
	ply:SetDTFloat(1, 0) -- delay for movement speed multiplier reset
	ply.attackedBy = {}
	ply.afkTimeout = self.afkTime
	
	ply:initLastKillData()
	
	self:checkVoteStatus(ply)
	self:sendTimeLimit(ply)
	ply:sendGameType()
	
	if self.curGametype.playerInitialSpawn then
		self.curGametype:playerInitialSpawn(ply)
	end
end

function GM:CanPlayerSuicide(ply)
	return not self.PreparationTime or CurTime() > self.PreparationTime
end

function GM:FinishMove(ply, moveData)
	-- ignore dead players
	if not ply:Alive() then
		return
	end
		
	if moveData:GetButtons() == 0 then
		ply.afkTimeout = ply.afkTimeout - FrameTime()
				
		if not ply.afkWarned and ply.afkTimeout <= self.warnAFKTimeout then
			ply:ChatPrint("You will be KICKED in " .. self.warnAFKTimeout .. " seconds if you do not move.")
			ply.afkWarned = true
		end
		
		if ply.afkTimeout <= 0 then
			ply:Kick("You were kicked for being AFK.")
		end
	else
		ply.afkTimeout = self.afkTime
		ply.afkWarned = false
	end
end

function GM:PlayerAuthed(ply, steamID, uniqueID)
	self:verifyPunishment(ply)
	GAMEMODE:updateCurrentPlayerList()
end

local ZeroVector = Vector(0, 0, 0)
local ZeroAng = Angle(0, 0, 0)

function GM:PlayerSpawn(ply)
	local team = ply:Team()
	
	if team == TEAM_SPECTATOR then
		ply:KillSilent()
		return false
	end
	ply:ResetClassInfo()
	
	ply:SetViewPunchAngles(ZeroAng)
	ply.currentTraits = ply.currentTraits and table.Empty(ply.currentTraits) or {}
	ply:UnSpectate()
	ply:sendAttachments()
	ply:SetHealth(ply.plclass.StartHealth)
	ply:SetMaxHealth(ply.plclass.MaxHealth)
	ply:AddEFlags(EFL_NO_DAMAGE_FORCES)
	ply:SetWalkSpeed(ply.plclass.WalkSpeed) --self.BaseWalkSpeed
	ply:SetRunSpeed(ply.plclass.RunSpeed) --self.BaseRunSpeed
	ply:resetSpectateData()
	ply:resetSpawnData()
	ply:resetBleedData()
	ply:resetHealData()
	ply:resetAdrenalineData()
	ply:resetStaminaData()
	ply:resetWeightData()
	ply:resetRadioData()
	ply:resetRecentVictimData()
	ply:resetArmorData()
	ply:resetHealthRegenData()
	ply:setBandages(ply:getDesiredBandageCount())
	ply:SetCanZoom(false)
	ply:resetLastKillData()
	ply:SetCrouchedWalkSpeed(self.CrouchedWalkSpeed)
	ply:SetVelocity(ZeroVector) -- fixes movement prediction issues since upon round start we're supposed to stand still
	ply.hasLanded = true
	ply.canPickupWeapon = true
	ply.crippledArm = false
	ply.sustainedArmDamage = 0 -- regardless of which arm was hit
	ply:setInvincibilityPeriod(self.postSpawnInvincibilityTimePeriod)
	table.clear(ply.attackedBy)
	ply:SetHullDuck(self.DuckHullMin, self.DuckHullMax)
	ply:SetViewOffset(self.ViewOffset)
	ply:SetViewOffsetDucked(self.ViewOffsetDucked)
	ply:resetStatusEffects()
	ply:abortClimb()
	ply:resetKillcountData()
	local desiredVoice = nil
	
	if self.curGametype.voiceOverride then
		desiredVoice = self.curGametype.voiceOverride[team]
	end
	
	if not desiredVoice then
		if not self:attemptSetMemeRadio(ply) then
			desiredVoice = ply:GetInfoNum("gc_desired_voice", 0)
			
			if not desiredVoice or desiredVoice == 0 then
				ply.voiceVariant = self.VisibleVoiceVariants[math.random(1, #self.VisibleVoiceVariants)].numId
			else
				local data = self.VoiceVariants[math.Clamp(desiredVoice, 1, #self.VoiceVariants)]
				
				if data.invisible then -- can't trick me :)
					ply.voiceVariant = self.VisibleVoiceVariants[1].numId
				else
					ply.voiceVariant = data.numId
				end
			end
		end
	else
		ply.voiceVariant = self.VoiceVariantsById[desiredVoice].numId
	end
	
	ply:SetModel(self:getVoiceModel(ply))
	
	self:positionPlayerOnMap(ply)
	
	ply:giveLoadout()
	self:sendTimeLimit(ply)
	
	if self.curGametype.playerSpawn then
		self.curGametype:playerSpawn(ply)
	end
	
	ply:updateJumpPower()
	ply:SetupHands()
	
	if not self.curGametype:getSuppressKnife(ply) then
		ply:Give(self.KnifeWeaponClass)
	end
	
	ply:sendTraits()
	
	return true
end

GM.FistsBaseModel = {model = "models/weapons/c_arms_cstrike.mdl", skin = 7, body = "10000000"}

function GM:PlayerSetHandsModel( ply, ent )
	local info = self.FistsBaseModel
	
	-- playermodel-based selection, disabled since we want model parity/consistency
	--[[local simplemodel = 
	local info = player_manager.TranslatePlayerHands(player_manager.TranslateToPlayerModelName(ply:GetModel()))]]
	
	if info then
		ent:SetModel(info.model)
		ent:SetSkin(info.skin)
		ent:SetBodyGroups(info.body)
	end
end

function GM:DoPlayerDeath(ply, attacker, dmgInfo)
	if ply != attacker and ply:Team() == attacker:Team() then
		if ply.Ability and ply.Ability.name == "Disquise" and ply.Ability.active then
			return
		end
		local role
		if ply.plclass and ply.plclass.DisplayName then
			rolestr = ply.plclass.DisplayName
		else 
			rolestr = "Unknown"
		end

		local nick = ply:Nick()

		net.Start("killnotification")
		net.WriteString(rolestr)
		net.WriteString(nick)
		net.Send(attacker)
	end
	
	ply:DeathAbility(false)
	local wep = ply:GetActiveWeapon()
	local nadeCntOffset = 0
	
	if IsValid(wep) and wep.liveGrenade then
		nadeCntOffset = -1
	end
	if wep.CW20Weapon then 
		ply:dropWeaponNicely(nil, VectorRand() * 20, VectorRand() * 200, true)
	end  -- drop the main weapon
	
	--  drop any matching weapons also
	for k, wep in ipairs(ply:GetWeapons()) do
		--[[if !wep.CW20Weapon then 
			ply:DropWeapon(wep)
		end 
		--]]
		if self.alwaysDropWeapons[wep:GetClass()] then
			ply:dropWeaponNicely(wep, VectorRand() * 20, VectorRand() * 200, true)-- drop the main weapon
		end
	end
	
	local frags = ply:GetAmmoCount("Frag Grenades") + nadeCntOffset
	
	-- also drop frag grenades if present	
	if frags > 0 then
		local pos = ply:EyePos()
		local ang = ply:EyeAngles()
	
		for i = 1, frags do
			local grenObj = ents.Create("cw_grenade_unthrown")
			grenObj:SetPos(pos + ang:Right() * 6 + ang:Forward() * 40 - ang:Up() * 5)
			grenObj:SetAngles(ang)
			grenObj:Spawn()
			grenObj:Activate()
			
			local physObj = grenObj:GetPhysicsObject()
			
			physObj:SetVelocity(VectorRand() * 20)
			physObj:AddAngleVelocity(VectorRand() * 200)
		end
	end
	
	ply:abortClimb()
	
	if IsValid(attacker) and attacker:IsPlayer() then
		if attacker:Team() ~= ply:Team() then
			attacker.lastKillData.position = ply:GetPos()
			attacker.lastKillData.time = CurTime() + 6
			table.insert(attacker.loggedKillDatas, {p = attacker.lastKillData.position, t = attacker.lastKillData.time})
			
			attacker:AddFrags(1)
			ply:AddDeaths(1)
			attacker:addCurrency(self.CashPerKill, self.ExpPerKill, "ENEMY_KILLED", ply)
			self:trackRoundMVP(attacker, "kills", 1)
			attacker:checkForTeammateSave(ply)
			attacker:increaseKillcount(ply)
			
			if ply:LastHitGroup() == HITGROUP_HEAD then
				attacker:addCurrency(self.CashPerHeadshot, self.ExpPerHeadshot, "HEADSHOT")
				self:trackRoundMVP(attacker, "headshots", 1)
			end
			
			if self:countLivingPlayers(attacker:Team()) == 1 then
				attacker:addCurrency(self.CashPerOneManArmy, self.ExpPerOneManArmy, "ONE_MAN_ARMY")
			end
		else
			if not self.RoundOver and ply ~= attacker then
				attacker:addCurrency(self.CashPerTeamKill, self.ExpPerTeamKill, "TEAMKILL", ply)
			end
		end
		
		local inflictor = dmgInfo:GetInflictor()
		
		if inflictor == attacker and inflictor ~= ply then -- if the inflictor matches the attacker, but it wasn't a suicide
			local wep = attacker:GetActiveWeapon()
			
			if IsValid(wep) then -- and the attacker has a valid weapon
				inflictor = wep -- we assume that the inflictor should be the weapon
			end
		end
				
		net.Start("GC_KILLED_BY")
			net.WriteEntity(attacker)
			net.WriteString(inflictor:GetClass())
		net.Send(ply)
		
		local markedSpots = self.MarkedSpots[attacker:Team()]
		
		if markedSpots then
			self:sanitiseMarkedSpots(attacker:Team())
			
			for key, data in pairs(markedSpots) do
				if data.radioData.onPlayerDeath then
					data.radioData:onPlayerDeath(ply, attacker, data)
				end
			end
		end
		
		if attacker:Team() ~= ply:Team() then -- don't hand out kill assists for team-kills done by the opposing team
			for obj, damageAmount in pairs(ply.attackedBy) do -- iterate over all players that attacked us and give them assist money
				if IsValid(obj) and ply ~= attacker and obj ~= attacker then
					local percentage = damageAmount / ply:GetMaxHealth()
					obj:addCurrency(math.ceil(percentage * self.CashPerAssist), math.ceil(percentage * self.ExpPerAssist), "KILL_ASSIST")
				end
			end
		end
	end
	
	if self.curGametype.playerDeath then
		self.curGametype:playerDeath(ply, attacker, dmginfo)
	end
	
	ply.spawnWait = CurTime() + 5
	
	ply:CreateRagdoll()
end

function GM:disableCustomizationMenu()
	for key, ply in ipairs(self.currentPlayerList) do
		local wep = ply:GetActiveWeapon()
		
		if IsValid(wep) and wep.CW20Weapon and wep.dt.State == CW_CUSTOMIZE then
			wep.dt.State = CW_IDLE
		end
	end
end

function GM:PlayerCanHearPlayersVoice(listener, talker)
	if listener == talker then -- if the talker is the listener they can always hear themselves, so don't run any extra logic in such cases
		return true
	end
	
	if self.RoundOver or GetConVarNumber("sv_alltalk") > 0 then
		return true
	end
	
	if listener:Alive() and not talker:Alive() then
		return false
	end
		
	local differentTeam = talker:Team() ~= listener:Team()
	local canUseDirectional = false
	
	if self.proximityVoiceChat then
		local tooFar = listener:GetPos():Distance(talker:GetPos()) > self.proximityVoiceChatDistance
		
		if self.proximityVoiceChatGlobal then -- if global proximity chat is on, we check whether we're close enough to anyone, and if we are too far - disable voice
			if tooFar then
				return false
			end
		else -- if it isn't on, we check for whether the talker is an enemy, and if he is, but he's too far - we can't hear them
			if differentTeam and tooFar then
				return false
			end
			
			if self.proximityVoiceChatDirectional3D then
				canUseDirectional = differentTeam -- directional sound should not be active if teammate players can hear each other across the whole map
			end
		end
	else
		if differentTeam then
			return false
		end
	end
	
	return true, canUseDirectional
end

function GM:PlayerCanSeePlayersChat(text, teamOnly, listener, talker)
	if not IsValid(talker) then
		return true
	end
	
	if self.RoundOver then
		return true
	end
	
	if listener:Alive() and not talker:Alive() then
		return false
	end
	
	if teamOnly then
		if listener:Team() ~= talker:Team() then
			return false
		end
	end
	
	return true
end

function GM:PostPlayerDeath(ply)
	--self:checkRoundOverPossibility()
	
	if ply:Team() ~= TEAM_SPECTATOR then
		if self.curGametype.postPlayerDeath then
			self.curGametype:postPlayerDeath(ply)
		end
	end
	
	ply:delaySpectate(self.DeadPeriodTime)
end

GM.HitgroupDamageModifiers = {[HITGROUP_HEAD] = 3,
	[HITGROUP_LEFTARM] = 0.75,
	[HITGROUP_RIGHTARM] = 0.75,
	[HITGROUP_LEFTLEG] = 0.85,
	[HITGROUP_RIGHTLEG] = 0.85}
	
GM.DropPrimaryHitgroup = { -- clear hitbox indexes in this table if you don't want players to drop their primary weapons when they get hit in their arms
	[HITGROUP_LEFTARM] = true,
	[HITGROUP_RIGHTARM] = true
}

GM.DropPrimarySustainedDamage = 40 -- how much arm damage the player has to sustain in order to drop the weapon

local Vec0 = Vector(0, 0, 0)
	
function GM:ScalePlayerDamage(ply, hitGroup, dmgInfo)
	local vel = ply:GetVelocity()
	
	local attacker = dmgInfo:GetAttacker()
	local damage = dmgInfo:GetDamage()
	local differentTeam = nil
	local attackerIsValid = IsValid(attacker)
	
	if attackerIsValid and attacker:IsPlayer() then
		differentTeam = attacker:Team() ~= ply:Team()
	end
	
	if attacker ~= ply and attacker:IsPlayer() then
		if CurTime() < ply.invincibilityPeriod then -- player is still invincible after spawning, remove any damage done and don't do anything
			dmgInfo:ScaleDamage(0)
			return
		end
	end
	
	if attackerIsValid and not differentTeam and attacker ~= ply then
		if self.noTeamDamage or self.RoundOver then  -- disable all team damage if the server is configged that way (or round is over)
			dmgInfo:ScaleDamage(0)
		else
			dmgInfo:ScaleDamage(self.teamDamageScale)
		end
				
		return
	end
	
	ply:setStamina(ply.stamina - damage)
	ply:suppress(4, 0.25)
	
	if IsValid(attacker) and attacker:IsPlayer() then
		local penValue = nil
		
		if ply.LAST_HIT_BY_PHYSBUL then -- support for physical bullets in CW 2.0
			penValue = ply.LAST_HIT_BY_PHYSBUL.penetrationValue
			ply.LAST_HIT_BY_PHYSBUL = nil
		else
			local wep = attacker:GetActiveWeapon()
			
			if wep then
				penValue = wep.penetrationValue
			end
		end
		
		if attacker:Team() ~= ply:Team() then
			dmgInfo:ScaleDamage(self.DamageMultiplier)
			attacker:storeRecentVictim(ply)
			ply:storeAttacker(attacker, dmgInfo)
			
			ply:processArmorDamage(dmgInfo, penValue, hitGroup, true)
		else
			ply:processArmorDamage(dmgInfo, penValue, hitGroup, false)
		end
	end
	
	local damageModifier = self.HitgroupDamageModifiers[hitGroup] 
	
	if damageModifier then
		dmgInfo:ScaleDamage(damageModifier)
	end
	
	if self.cripplingEnabled and self.DropPrimaryHitgroup[hitGroup] then
		local prevDamage = ply.sustainedArmDamage
		ply.sustainedArmDamage = ply.sustainedArmDamage + dmgInfo:GetDamage()
		
		if ply.sustainedArmDamage >= self.DropPrimarySustainedDamage then -- if we sustain enough damage, we force-drop the weapon, but only if it's primary
			if ply:crippleArm() and attacker:IsPlayer() then
				self:trackRoundMVP(attacker, "crippler", 1)
			end
		end
	end
	
	if differentTeam then
		self:trackRoundMVP(attacker, "damage", dmgInfo:GetDamage())
	end
	
	local traits = self.Traits
	
	for key, traitConfig in ipairs(ply.currentTraits) do
		local traitData = traits[traitConfig[1]][traitConfig[2]]
		
		if traitData.onTakeDamage then
			traitData:onTakeDamage(ply, dmgInfo, hitGroup)
		end
	end
end

function GM:PlayerSwitchFlashlight(ply)
	return true
end

function GM:SetupPlayerVisibility(ply, viewEnt)
	if IsValid(viewEnt) then
		AddOriginToPVS(viewEnt:GetShootPos())
	end
end

function GM:PlayerShouldTaunt(ply, act)
	return false
end

function GM:PlayerDeathThink(ply)
	local CT = CurTime()
	if not self.curGametype then
		return "a"
	end
	
	if self.curGametype.canSpawn then
		return self.curGametype:canSpawn(ply)
	else
		if #self.currentPlayerList < 2 then
			if ply:KeyPressed(IN_ATTACK) or ply:KeyPressed(IN_JUMP) then --self.curGametype.name != "ghettodrugbust"
				--print(#player.GetAll())
				ply:Spawn()
				return true
			end	
		end
		
		return self.canSpawn
	end
	
	--[[if CT > ply.spawnWait then
		if ply:KeyPressed(IN_ATTACK) or ply:KeyPressed(IN_JUMP) then
			ply:Spawn()
			return true
		end
	end
	
	return false]]--
end

function GM:updateCurrentPlayerList(exclude)
	self.currentPlayerList = player.GetAll()
	
	if exclude then
		table.Exclude(self.currentPlayerList, exclude)
	end	
end

function GM:PlayerDisconnected(ply)
	AbilityDebug(ply) -- experimental
	--self:checkRoundOverPossibility()
	if self.curGametype.playerDisconnected then
		self.curGametype:playerDisconnected(ply)
	end
	
	self:removePlayerObjectFromReportedDeadList(ply)
	
	for key, plyObj in pairs(team.GetPlayers(ply:Team())) do
		if plyObj.currentSpectateEntity == self then
			plyObj:attemptSpectate()
		end
	end
	
	self:updateCurrentPlayerList(ply)
end

function GM:PlayerAmmoChanged(ply, ammoID, oldCount, newCount)
	ply:setWeight(ply:calculateWeight())
end

function PLAYER:crippleArm()
	if self.crippledArm then
		return
	end
	
	local wepDropped = false
	
	-- iterate through all the weapons and make the person drop his primary wep when he gets creyoppled
	for key, wep in ipairs(self:GetWeapons()) do
		if IsValid(wep) and wep.CW20Weapon and wep.isPrimaryWeapon and not wep.dropsDisabled  then
			self:dropWeaponNicely(wep, VectorRand() * 20, VectorRand() * 200)
			wepDropped = true
		end
	end
	
	if wepDropped then
		self:sendTip("DROPPED_WEAPON")
	end
	
	self:setStatusEffect("crippled_arm", true)
	self.crippledArm = true
	self:setWeight(self:calculateWeight())
end

function PLAYER:uncrippleArm()
	if self.crippledArm then
		self.crippledArm = false
		self.sustainedArmDamage = GAMEMODE.DropPrimarySustainedDamage - 1
		self:setStatusEffect("crippled_arm", false)
		return true
	end
	
	return false
end

function PLAYER:changeSustainedArmDamage(chg)
	self.sustainedArmDamage = math.max(0, self.sustainedArmDamage + chg)
end

function PLAYER:dropWeaponNicely(wepObj, velocity, angleVelocity, stripAmmo) -- velocity and angleVelocity is optional
	wepObj = wepObj or self:GetActiveWeapon()
	
	if IsValid(wepObj) then
		if wepObj.dropsDisabled then
			return
		end
	end
	
	local pos = self:EyePos()
	local ang = self:EyeAngles()
	
	pos = pos + ang:Right() * 6 + ang:Forward() * 40 - ang:Up() * 5
	
	CustomizableWeaponry:dropWeapon(self, wepObj, velocity, angleVelocity, pos, ang)
	
	local ammoType = wepObj:GetPrimaryAmmoType()

	if ammoType ~= -1 and stripAmmo then
		self:SetAmmo(0, ammoType)
	end
	
	self:StripWeapon(wepObj:GetClass())
end

function PLAYER:storeAttacker(attacker, dmgInfo)
	local pastDamage = self.attackedBy[attacker] or 0
	pastDamage = math.Clamp(pastDamage + dmgInfo:GetDamage(), 0, self:GetMaxHealth())
	
	self.attackedBy[attacker] = pastDamage
end

function PLAYER:storeRecentVictim(victim)
	self.recentVictim.object = victim
	self.recentVictim.timeWindow = CurTime() + GAMEMODE.SaveEventTimeWindow
end

function PLAYER:resetRecentVictimData()
	self.recentVictim = self.recentVictim or {}
	self.recentVictim.object = nil
	self.recentVictim.timeWindow = nil
end

function PLAYER:initLastKillData()
	self.lastKillData = {position = nil, time = 0}
	self.loggedKillDatas = {}
end

function PLAYER:resetLastKillData()
	self.lastKillData.position = nil
	self.lastKillData.time = 0
	
	for key, data in ipairs(self.loggedKillDatas) do
		self.loggedKillDatas[key] = nil
	end
end

function PLAYER:checkForTeammateSave(victim)
	local recentVictim = victim.recentVictim
	local victimObj = recentVictim.object
	
	if IsValid(victimObj) then -- make sure the person was attacking someone and it weren't us
		if victimObj ~= self and victimObj:Health() > 0 then
			if CurTime() < recentVictim.timeWindow then
				if victimObj:Health() <= GAMEMODE.MinHealthForSave then
					self:addCurrency(GAMEMODE.CashPerSave, GAMEMODE.ExpPerSave, "TEAMMATE_SAVED")
				else
					self:addCurrency(GAMEMODE.CashPerMateHelp, GAMEMODE.ExpPerMateHelp, "TEAMMATE_HELPED")
				end
			end
		else
			if self:Health() <= GAMEMODE.MinHealthForCloseCall and self:Alive() then
				self:addCurrency(GAMEMODE.CashPerCloseCall, GAMEMODE.ExpPerCloseCall, "CLOSE_CALL")
			end
		end
	end
end

function PLAYER:updateJumpPower()
	if self.weight then
		--self:SetJumpPower(math.max(GAMEMODE.jumpPowerMin, math.min(GAMEMODE.jumpPower, GAMEMODE.jumpPower - GAMEMODE.jumpPowerReductionPerKG * math.max(0, (self.weight - GAMEMODE.jumpPowerWeightCutoff)))))
		self:SetJumpPower(math.max(GAMEMODE.jumpPowerMin, math.min(self.plclass.JumpPower, self.plclass.JumpPower - GAMEMODE.jumpPowerReductionPerKG * math.max(0, (self.weight - GAMEMODE.jumpPowerWeightCutoff)))))
	end
end

function PLAYER:addCurrency(cash, exp, event, entity)
	if exp and cash then
		self:addCash(cash)
		self:addExperience(exp)
		
		GAMEMODE.SendCurrencyAmount.exp = exp
		GAMEMODE.SendCurrencyAmount.cash = cash
		
		if entity then
			GAMEMODE.SendCurrencyAmount.entity = entity:EntIndex()
		else
			GAMEMODE.SendCurrencyAmount.entity = nil
		end
		
		GAMEMODE:sendEvent(self, event, GAMEMODE.SendCurrencyAmount)
		return
	end
	
	if exp then
		self:addExperience(exp, event)
	end
	
	if cash then
		self:addCash(cash, event)
	end
end

function PLAYER:restoreHealth(amount)
	self:SetHealth(math.min(self:Health() + amount, self:GetMaxHealth()))
end

function PLAYER:sendPlayerData()
	self:sendCash()
	self:sendExperience()
	self:sendAttachments()
	self:sendUnlockedAttachmentSlots()
	self:sendTraits()
end

function PLAYER:setSpawnPoint(vec)
	self.spawnPoint = vec
	
	if GAMEMODE.LoadoutSelectTime then
		if GAMEMODE.curGametype.canReceiveLoadout and not GAMEMODE.curGametype:canReceiveLoadout(self) then
			return
		end
		
		umsg.Start("GC_LOADOUTPOSITION", self)
			umsg.Vector(vec)
			umsg.Float(GAMEMODE.LoadoutSelectTime)
		umsg.End()
	end
end

function PLAYER:sendStatusEffect(id, state)
	net.Start("GC_STATUS_EFFECT")
		net.WriteString(id)
		net.WriteBool(state)
	net.Send(self)
	
	local statusEffect = GAMEMODE.StatusEffects[id]
	
	if not statusEffect.dontSend then
		-- I don't know whether the "send to players in list" not working bug was fixed yet, so I'll just iterate over the list and call net.Send individually
		for key, playerObject in ipairs(team.GetPlayers(self:Team())) do
			if playerObject ~= self then
				net.Start("GC_STATUS_EFFECT_ON_PLAYER")
					net.WriteEntity(self)
					net.WriteString(id)
					net.WriteBool(state)
				net.Send(playerObject)
			end
		end
	end
end

function PLAYER:setInvincibilityPeriod(time) -- used for anti-spawncamp systems
	self.invincibilityPeriod = CurTime() + time
end

concommand.Add("gc_request_data", function(ply, com, args)
	if CurTime() < ply.lastDataRequest then
		return
	end
	
	ply:sendPlayerData()
	
	ply.lastDataRequest = CurTime() + 1
end)

concommand.Add("assignbotstoteam", function(ply)
	for key, value in pairs(player.GetBots()) do
		value:SetTeam(math.random(TEAM_RED, TEAM_BLUE))
		value:Spawn()
	end
end)

hook.Add("CW20_PickedUpCW20Weapon", "GC_CW20_PickedUpCW20Weapon", function(ply, droppedWeaponObject, newWeaponObject) -- newWeaponObject is the :Give'n weapon object
	for key, wepObj in ipairs(ply:GetWeapons()) do -- drop any matching weapons that aren't this one (we can only carry 1 primary)
		if wepObj ~= newWeaponObject and wepObj.Slot == newWeaponObject.Slot then
			ply:dropWeaponNicely(wepObj)
			ply.canPickupWeapon = false -- prevent weapon pickups until we finish assigning attachments to the weapon
			ply:sendTip("PICKUP_WEAPON")
		end
	end
end)

hook.Add("CW20_FinishedPickingUpCW20Weapon", "GC_CW20_FinishedPickingUpCW20Weapon", function(ply, newWeaponObject)
	ply.canPickupWeapon = true -- we did it, now we can pick up weapons again
end)

hook.Add("CW20_PreventCWWeaponPickup", "GC_CW20_PreventCWWeaponPickup", function(wepObj, ply)
	return not ply.canPickupWeapon or (ply.crippledArm and weapons.GetStored(wepObj:GetWepClass()).isPrimaryWeapon)
end)

--[[hook.Add("PlayerCanPickupWeapon","CW20 Different",function(ply,weapon)
	return false 
end)
--]]