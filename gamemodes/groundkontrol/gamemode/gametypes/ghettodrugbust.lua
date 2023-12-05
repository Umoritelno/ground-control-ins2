local ghettoDrugBust = {}
ghettoDrugBust.name = "ghettodrugbust"
ghettoDrugBust.id = 3
ghettoDrugBust.prettyName = "Ghetto Drug Bust"
ghettoDrugBust.preventManualTeamJoining = true
ghettoDrugBust.loadoutTeam = TEAM_RED
ghettoDrugBust.regularTeam = TEAM_BLUE
ghettoDrugBust.timeLimit = 195
ghettoDrugBust.stopCountdown = true
ghettoDrugBust.noTeamBalance = true
ghettoDrugBust.magsToGive = 3
ghettoDrugBust.bandagesToGive = 4
ghettoDrugBust.objectiveEnts = {}
ghettoDrugBust.objectiveCounter = 0
ghettoDrugBust.roundTimeForDrugs = 60
ghettoDrugBust.blueGuyPer = 2.3 -- for every 3rd player, 1 will be a red dude
ghettoDrugBust.blueGuyPerFists = 4.5
ghettoDrugBust.chancePerTimesNotCop = 10 -- per every time someone was spawned in as a ghetto team member, their chance to spawn as a cop next round increases by this much %
ghettoDrugBust.ClassGive = {[ghettoDrugBust.regularTeam] = false,[ghettoDrugBust.loadoutTeam] = true}
ghettoDrugBust.AbilityGive = {[ghettoDrugBust.regularTeam] = false,[ghettoDrugBust.loadoutTeam] = true}
ghettoDrugBust.voiceOverride = {[ghettoDrugBust.regularTeam] = "ghetto"}
ghettoDrugBust.objectives = {}
ghettoDrugBust.teamTracking = {} -- table where object is player, value is amount of times said player was not on the loadout team
ghettoDrugBust.timeLimitMap = { -- where key is map name and value is the time limit
	cs_backalley2 = 60 * 4 + 15,
	cs_christalley = 60 * 4 + 15
}

ghettoDrugBust.cashPerDrugReturn = 50
ghettoDrugBust.expPerDrugReturn = 50

ghettoDrugBust.cashPerDrugCapture = 100
ghettoDrugBust.expPerDrugCapture = 100

ghettoDrugBust.cashPerDrugCarrierKill = 25
ghettoDrugBust.expPerDrugCarrierKill = 25

ghettoDrugBust.fistsWeaponClass = "gc_fists"
ghettoDrugBust.grenadeChance = 20 -- chance that a ghetto team player will receive a grenade upon spawn

ghettoDrugBust.invertedSpawnpoints = {
	de_chateau = true
}

ghettoDrugBust.redteamweaponslist = {
	["cw"] = {
		[1] = {weapon = "cw_ak74", chance = 3, mags = 1},
		[2] = {weapon = "cw_shorty", chance = 8, mags = 12},
		[3] = {weapon = "cw_mac11", chance = 10, mags = 1},
        [4] = {weapon = "cw_deagle", chance = 15, mags = 2},
		[5] = {weapon = "cw_mr96", chance = 17, mags = 3},
		[6] = {weapon = "cw_fiveseven", chance = 35, mags = 2},
		[7] = {weapon = "cw_m1911", chance = 40, mags = 4}, --
		[8] = {weapon = "cw_p99", chance = 66, mags = 3},
		[9] = {weapon = "cw_makarov", chance = 100, mags = 7},
		},
	["cwkk"] = {
		[1] = {weapon = "cw_kk_ins2_mosin",chance = 5,mags = 2},
		[2] = {weapon = "cw_kk_ins2_sks",chance = 7,mags = 2},
		[3] = {weapon = "cw_kk_ins2_rpk",chance = 2.5,mags = 1},
		[4] = {weapon = "cw_kk_ins2_revolver",chance = 31,mags = 3},
		[5] = {weapon = "cw_kk_ins2_m1911",chance = 50,mags = 3},
		[6] = {weapon = "cw_kk_ins2_m45",chance = 45,mags = 3},
		[7] = {weapon = "cw_kk_ins2_mp5k",chance = 25,mags = 2},

	},
	["tfa"] = {
		[1] = {weapon = "tfa_ins2_ak103",chance = 5,mags = 2,},
		[2] = {weapon = "tfa_ins2_colt_m45",chance = 50,mags = 2,},
		[3] = {weapon = "tfa_ins2_fnp45",chance = 45,mags = 2,},
		[4] = {weapon = "tfa_ins2_mr96",chance = 32,mags = 3,},
		[5] = {weapon = "tfa_ins2_sr2m_veresk",chance = 25,mags = 2,},
		[6] = {weapon = "tfa_ins2_ots_33_pernach",chance = 27.5,mags = 2,},
	},

		     
	--[[weapon = "cw_kk_ins2_toz", chance = 8, mags = 1,
	weapon = "cw_kk_ins2_cstm_mp7", chance = 10, mags = 1,
	weapon = "cw_kk_ins2_mosin", chance = 5, mags = 2,
	weapon = "cw_kk_ins2_revolver", chance = 25, mags = 2,
	weapon = "cw_kk_ins2_m45", chance = 30, mags = 3,
	weapon = "cw_kk_ins2_cstm_g19", chance = 35, mags = 2,
	weapon = "cw_kk_ins2_m1911", chance = 40, mags = 4},
	weapon = "cw_kk_ins2_m9", chance = 66, mags = 3,
	weapon = "cw_kk_ins2_makarov", chance = 100, mags = 7,
	--]]
}
ghettoDrugBust.redTeamWeapons = ghettoDrugBust.redteamweaponslist[GM.CurWepBase] or ghettoDrugBust.redteamweaponslist["cw"]

ghettoDrugBust.redTeamWeaponsWeight = 1

-- setup weapon weights
local wepList = ghettoDrugBust.redTeamWeapons

for i = 1, #wepList do
	local data = wepList[i]
	
	data.weight = {
		min = ghettoDrugBust.redTeamWeaponsWeight, 
		max = ghettoDrugBust.redTeamWeaponsWeight + data.chance
	}
	
	ghettoDrugBust.redTeamWeaponsWeight = ghettoDrugBust.redTeamWeaponsWeight + data.chance + 1
end

ghettoDrugBust.sidewaysHoldingWeapons = {
	cw_deagle = true,
	cw_mr96 = true,
	cw_fiveseven = true,
	cw_m1911 = true,
	cw_p99 = true,
	cw_makarov = true,
	cw_mac11 = true
}

ghettoDrugBust.sidewaysHoldingBoneOffsets = {
	cw_mr96 = {["Bip01 L UpperArm"] = {target = Vector(0, -30, 0), current = Vector(0, 0, 0)}},
	cw_m1911 = {["arm_controller_01"] = {target = Vector(0, 0, -30), current = Vector(0, 0, 0)}},
	cw_p99 = {["l_forearm"] = {target = Vector(0, 0, 30), current = Vector(0, 0, 0)}},
	cw_fiveseven = {["arm_controller_01"] = {target = Vector(0, 0, -30), current = Vector(0, 0, 0)}},
	cw_makarov = {["Left_U_Arm"] = {target = Vector(30, 0, 0), current = Vector(0, 0, 0)}},
	cw_deagle = {["arm_controller_01"] = {target = Vector(0, 0, -30), current = Vector(0, 0, 0)}},
	cw_mac11 = {["l_upperarm"] = {target = Vector(0, 0, -30), current = Vector(0, 0, 0)}},
}

if SERVER then
	ghettoDrugBust.mapRotation = GM:getMapRotation("ghetto_drug_bust_maps")
end

function ghettoDrugBust:getSuppressKnife(ply)
	return ply:Team() == self.regularTeam
end

function ghettoDrugBust:skipAttachmentGive(ply)
	return ply:Team() == self.regularTeam
end

function ghettoDrugBust:canHaveAttachments(ply)
	return true -- return ply:Team() == self.loadoutTeam
end

function ghettoDrugBust:modulateRoundEndMusic(winTeam)
	return winTeam ~= self.loadoutTeam and GAMEMODE.RoundEndMusicObjectsGhetto[1]
end

function ghettoDrugBust:modulateRoundStartMusic()
	return LocalPlayer():Team() ~= self.loadoutTeam and GAMEMODE.RoundStartMusicObjectsGhetto[1]
end

function ghettoDrugBust:canReceiveLoadout(ply)
	local loadoutTeam = ply:Team() == self.loadoutTeam
	
	if loadoutTeam then
		ply:Give(GAMEMODE.KnifeWeaponClass)
	end
	
	return loadoutTeam
end

function ghettoDrugBust:pickupDrugs(drugEnt, ply)
	local team = ply:Team()
	
	if team == self.loadoutTeam then
		if not ply.hasDrugs then
			self:giveDrugs(ply)
			return true
		end
	elseif team == self.regularTeam then
		if drugEnt.dt.Dropped and not ply.hasDrugs then
			self:giveDrugs(ply)
			GAMEMODE:startAnnouncement("ghetto", "return_drugs", CurTime(), nil, ply)
			return true
		end
	end
end

function ghettoDrugBust:playerDeath(ply, attacker, dmginfo)
	if ply.hasDrugs then
		if IsValid(attacker) and ply ~= attacker and attacker:IsPlayer() then
			local plyTeam = ply:Team()
			local attackerTeam = attacker:Team()
			
			if plyTeam ~= attackerTeam then -- we grant the killer a cash and exp bonus if they kill the drug carrier of the opposite team
				attacker:addCurrency(self.cashPerDrugCarrierKill, self.expPerDrugCarrierKill, "KILLED_DRUG_CARRIER")
			end
		end
		
		GAMEMODE:startAnnouncement("ghetto", "retrieve_drugs", CurTime(), self.regularTeam)
	
		ghettoDrugBust:dropDrugs(ply)
	end
end

function ghettoDrugBust:giveDrugs(ply)
	if ply:Team() == self.loadoutTeam then
		GAMEMODE:startAnnouncement("ghetto", "drugs_stolen", CurTime(), self.regularTeam)
	end
	
	if not self.drugTimeGranted then
		GAMEMODE:addTimeLimit(self.roundTimeForDrugs)
		self.drugTimeGranted = true
	end
	
	ply.hasDrugs = true
	SendUserMessage("GC_GOT_DRUGS", ply)
end

function ghettoDrugBust:dropDrugs(ply)
	local pos = ply:GetPos()
	pos.z = pos.z + 20
	
	local ent = ents.Create("gc_drug_package")
	ent:SetPos(pos)
	ent:SetAngles(AngleRand())
	ent:Spawn()
	ent:wakePhysics()
	ent.dt.Dropped = true
	
	ply.hasDrugs = false
end

function ghettoDrugBust:resetRoundData()
	if CLIENT then
		local list = GAMEMODE.ObjectiveEntities
		table.sanitiseObjectList(list)
		
		for key, obj in ipairs(list) do			
			if obj:GetClass() == "gc_drug_capture_point" then
				obj:resetDefendersText()
			end
		end
	end
	
	for key, ply in ipairs(player.GetAll()) do
		ply.hasDrugs = false
	end
end

function ghettoDrugBust:removeDrugs(ply)
	ply.hasDrugs = false
	SendUserMessage("GC_DRUGS_REMOVED", ply)
end

function ghettoDrugBust:verifyDefendersCapturePointText()	
	local list = GAMEMODE.ObjectiveEntities
	table.sanitiseObjectList(list)
	
	for key, obj in ipairs(list) do			
		if obj:GetClass() == "gc_drug_capture_point" then
			obj:verifyDefendersText()
		end
	end
end

function ghettoDrugBust:attemptReturnDrugs(player, host)
	local team = player:Team()
	
	if team == ghettoDrugBust.regularTeam and player.hasDrugs and not host.dt.HasDrugs then
		ghettoDrugBust:removeDrugs(player)
		
		host:createDrugPackageObject()
		player:addCurrency(self.cashPerDrugReturn, self.expPerDrugReturn, "RETURNED_DRUGS")
		GAMEMODE:startAnnouncement("ghetto", "drugs_retrieved", CurTime(), nil, player)
		GAMEMODE:startAnnouncement("ghetto", "drugs_retrieved_ex", CurTime(), self.regularTeam)
	end
end

function ghettoDrugBust:attemptCaptureDrugs(player, host)
	local team = player:Team()
	
	if team == ghettoDrugBust.loadoutTeam and player.hasDrugs then
		ghettoDrugBust:removeDrugs(player)
		
		player:addCurrency(self.cashPerDrugCapture, self.expPerDrugCapture, "SECURED_DRUGS")
		GAMEMODE:startAnnouncement("ghetto", "drugs_secured", CurTime(), self.regularTeam)
		return true
	end
end

function ghettoDrugBust:playerDisconnected(ply)
	if ply.hasDrugs then
		self:dropDrugs(ply)
	end
	
	local hisTeam = ply:Team()
	
	timer.Simple(0, function() -- nothing fancy, just skip 1 frame and call postPlayerDeath, since 1 frame later the player won't be anywhere in the player tables
		GAMEMODE:checkRoundOverPossibility(hisTeam, true)
	end)
end

function ghettoDrugBust:playerSpawn(ply)
	ply.hasDrugs = false
	
	if ply:Team() ~= self.loadoutTeam then
		CustomizableWeaponry:removeAllAttachments(ply)
		
		ply:StripWeapons()
		ply:RemoveAllAmmo()
		ply:resetGadgetData()
		ply:applyTraits()
	
		ply:resetArmorData()
		ply:sendArmor()
				
		if not self.fistsOnlyRound then
			local pickedWeapon = nil
			local rolledWeight = math.random(1, self.redTeamWeaponsWeight)
			
			for key, weaponData in ipairs(self.redTeamWeapons) do
				if rolledWeight >= weaponData.weight.min and rolledWeight <= weaponData.weight.max then
					pickedWeapon = weaponData
					break
				end
			end
			
			-- if for some reason the chance roll failed and no weapon was chosen, we pick one at random
			pickedWeapon = pickedWeapon or self.redTeamWeapons[math.random(1, #self.redTeamWeapons)]
			--print(pickedWeapon)
			
			local randIndex = self.redTeamWeapons[math.random(1, #self.redTeamWeapons)]
			local givenWeapon = ply:Give(pickedWeapon.weapon)
			
			ply:GiveAmmo(pickedWeapon.mags * givenWeapon:GetMaxClip1(), givenWeapon.Primary.Ammo) -- givenWeapon.Primary.ClipSize_Orig
			--print(givenWeapon.Primary.ClipSize_Orig)
			--[[if string.find(pickedWeapon.weapon.Base,"cw2") then 
			givenWeapon:maxOutWeaponAmmo(givenWeapon.Primary.ClipSize_Orig)
			end 
			--]]
			
			if math.random(1, 100) <= ghettoDrugBust.grenadeChance then
				if GAMEMODE.CurWepBase != "cw" then
					ply:Give("cw_kk_ins2_nade_m67",true)
				else 
					ply:GiveAmmo(1, "Frag Grenades")
				end
			end
		end
		
		if math.random(1, 100) <= GetConVar("gc_ghetto_knife_chance"):GetInt() then
			ply:Give(GAMEMODE.KnifeWeaponClass)
		else
			ply:Give(self.fistsWeaponClass)
		end
		
		ply:Give(GAMEMODE.MedkitClass)
		
		if math.random(1, 100) <= GetConVar("gc_ghetto_cum_chance"):GetInt() then
			ply:Give("gc_bukkake")
		end
		
	end
end

function ghettoDrugBust:getDesiredBandageCount(ply)
	if ply:Team() ~= self.loadoutTeam then
		return self.bandagesToGive
	end
	
	return nil
end

function ghettoDrugBust:think()
	if not self.stopCountdown then
		if GAMEMODE:hasTimeRunOut() then
			GAMEMODE:endRound(self.regularTeam)
		end
		
		local curTime = CurTime()
	end
end

function ghettoDrugBust:playerInitialSpawn(ply)
	if GAMEMODE.RoundsPlayed == 0 then
		if #player.GetAll() >= 2 then
			GAMEMODE:endRound(nil)
		end
	end
end

function ghettoDrugBust:postPlayerDeath(ply) -- check for round over possibility
	GAMEMODE:checkRoundOverPossibility(ply:Team())
end

if CLIENT then
	local handsMaterial = Material("models/weapons/v_models/hands/v_hands")
	
	function ghettoDrugBust:adjustHandTexture()
		local ply = LocalPlayer()
		local team = ply:Team()
		
		if team == self.regularTeam then
			ply:setHandTexture("models/weapons/v_models/gc_black_hands/v_hands")
		else
			ply:setHandTexture("models/weapons/v_models/hands/v_hands")
		end
	end
	
	function ghettoDrugBust:think()
		self:adjustHandTexture()
	end
end

ghettoDrugBust.backCompatTargetSpawnDE = "info_player_terrorist"
ghettoDrugBust.backCompatTargetSpawnCS = "info_player_counterterrorist"
ghettoDrugBust.backCompatDeliveryEntClass = "func_buyzone"
ghettoDrugBust.backCompatDrugEntClass = {{"func_bomb_target", true}, {"hostage_entity", false}}

function ghettoDrugBust:findClassTable(data)
	local entList = ents.FindByClass(data)
		
	if #entList > 0 then
		return entList
	end
	
	return nil
end

function ghettoDrugBust:attemptDoBackCompat()
	local map = string.lower(game.GetMap())
	
	if not self.objectives[map] then
		-- back compat
		local baseTargetSpawn = ents.FindByClass(self.backCompatTargetSpawnDE)[1] -- doesn't matter for this particular check
		
		if baseTargetSpawn then			
			local best, pickedDrugPoint = math.huge, nil
			local entList, entIsBrush
			
			for key, objClassData in ipairs(self.backCompatDrugEntClass) do
				entList = self:findClassTable(objClassData[1])
				
				if entList then
					entIsBrush = objClassData[2]
					break
				end
			end
			
			if not entList then
				return
			end
			
			local captureClassBase
		
			if entIsBrush then -- brush = DE_ map
				captureClassBase = self.backCompatTargetSpawnDE
			else -- not brush = CS_ map
				captureClassBase = self.backCompatTargetSpawnCS
			end
			
			baseTargetSpawn = ents.FindByClass(captureClassBase)[1]
			local baseTargetSpawnPos = baseTargetSpawn:GetPos()
			local best, pickedDelivery, bestDeliveryPos = math.huge, nil, nil
			
			for key, obj in ipairs(ents.FindByClass(self.backCompatDeliveryEntClass)) do
				local avgDeliveryPos = Vector(0, 0, 0)
				local planeCount = obj:GetBrushPlaneCount() - 1
				
				for i = 1, planeCount do
					local plane = obj:GetBrushPlane(i)
					avgDeliveryPos = avgDeliveryPos + plane
				end
				
				avgDeliveryPos = avgDeliveryPos / planeCount
				local thisDist = avgDeliveryPos:Distance(baseTargetSpawnPos)
				
				if thisDist < best then
					best = thisDist
					pickedDelivery = obj
					bestDeliveryPos = avgDeliveryPos
				end
			end
			
			if not pickedDelivery then
				return
			end
			
			if entIsBrush then
				-- brush? get center
				for key, obj in ipairs(entList) do
					local avgPos = Vector(0, 0, 0)
					local planeCount = obj:GetBrushPlaneCount() - 1
					
					for i = 1, planeCount do
						local plane = obj:GetBrushPlane(i)
						avgPos = avgPos + plane
					end
				
					local objEnt = ents.Create("gc_drug_point")
					objEnt:SetPos(avgPos / planeCount)
					objEnt:Spawn()
			
					GAMEMODE.entityInitializer:initEntity(objEnt, self, nil)
				end
			else
				-- point entity? ok, just grab position
				for key, obj in ipairs(entList) do
					local objEnt = ents.Create("gc_drug_point")
					objEnt:SetPos(obj:GetPos())
					objEnt:Spawn()
			
					GAMEMODE.entityInitializer:initEntity(objEnt, self, nil)
				end
			end
			
			local objEnt = ents.Create("gc_drug_capture_point")
			objEnt:SetPos(bestDeliveryPos)
			objEnt:Spawn()
	
			GAMEMODE.entityInitializer:initEntity(objEnt, self, nil)
						
			self.invertedSpawnpoints[map] = entIsBrush -- invert spawnpoints in such cases
		end
	end
end

function ghettoDrugBust:roundStart()
	if SERVER then
		self.drugTimeGranted = false
		
		local players = player.GetAll()
		local gearGuys
		self.fistsOnlyRound = false
		
		if math.random(1, 100) <= GetConVar("gc_ghetto_fists_only_chance"):GetInt() then
			self.fistsOnlyRound = true
			gearGuys = math.max(math.floor(#players / self.blueGuyPerFists), 1) -- less attackers during fists only round
		else
			gearGuys = math.max(math.floor(#players / self.blueGuyPer), 1)  -- aka the dudes who get the cool gear
		end
		
		if self.timeLimitMap[self.CurMap] then
			GAMEMODE:setTimeLimit(self.timeLimitMap[self.CurMap])
		else
			GAMEMODE:setTimeLimit(self.timeLimit)
		end
		
		self.stopCountdown = false
		
		-- before we pick out gear guys, we try to forcibly put players that haven't been cops in a while in the cop team
		local biasPickedPlayers = 0
		
		for ply, times in pairs(self.teamTracking) do
			if not IsValid(ply) then -- filter invalid objects
				self.teamTracking[ply] = nil
			else
				if math.random(1, 100) <= times * self.chancePerTimesNotCop then
					table.Exclude(players, ply)
					biasPickedPlayers = biasPickedPlayers + 1
					self.teamTracking[ply] = 0
					ply:SetTeam(self.loadoutTeam)
					
					if biasPickedPlayers >= gearGuys then -- prevent further picking
						gearGuys = 0
						break
					end
				end
			end
		end
		
		if gearGuys > 0 then
			for i = 1, gearGuys - biasPickedPlayers do
				local randomIndex = math.random(1, #players)
				local dude = players[randomIndex]
				
				if dude then
					dude:SetTeam(self.loadoutTeam)
				
					table.remove(players, randomIndex)
				end
			end
		end
		
		for key, ply in ipairs(players) do
			ply:SetTeam(self.regularTeam)
			self.teamTracking[ply] = (self.teamTracking[ply] or 0) + 1
		end
		
		GAMEMODE:initializeGameTypeEntities(self)
		self:attemptDoBackCompat()
	end
end

function ghettoDrugBust:onRoundEnded(winTeam)
	table.clear(self.objectiveEnts)
	self.stopCountdown = true
	self.objectiveCounter = 0
end

function ghettoDrugBust:deadDraw(w, h)
	if GAMEMODE:getActivePlayerAmount() < 2 then
		local lang = GetCurLanguage()
		draw.ShadowText(lang.round_players_require, GAMEMODE.SpectateFont, w * 0.5, _S(15), GAMEMODE.HUDColors.white, GAMEMODE.HUDColors.black, 1, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
end

function ghettoDrugBust:adjustSpawnpoint(ply, plyTeam)
	if self.invertedSpawnpoints[GAMEMODE.CurMap] then
		return GAMEMODE.OpposingTeam[plyTeam]
	end
	
	return nil
end

GM:registerNewGametype(ghettoDrugBust)

GM:addObjectivePositionToGametype("ghettodrugbust", "cs_assault", Vector(6794.2886, 3867.2642, -575.0213), "gc_drug_point")
GM:addObjectivePositionToGametype("ghettodrugbust", "cs_assault", Vector(4907.146, 6381.4331, -871.9687), "gc_drug_capture_point")

GM:addObjectivePositionToGametype("ghettodrugbust", "cs_compound", Vector(2303.8857, -710.6038, 31.016), "gc_drug_point")
GM:addObjectivePositionToGametype("ghettodrugbust", "cs_compound", Vector(2053.3057, -1677.0895, 56.0783), "gc_drug_point")
GM:addObjectivePositionToGametype("ghettodrugbust", "cs_compound", Vector(2119.7871, 2032.4009, 8.0313), "gc_drug_capture_point")

GM:addObjectivePositionToGametype("ghettodrugbust", "cs_havana", Vector(415.6184, 1283.9724, 281.7604), "gc_drug_point")
GM:addObjectivePositionToGametype("ghettodrugbust", "cs_havana", Vector(196.039, 807.587, 282.6608), "gc_drug_point")
GM:addObjectivePositionToGametype("ghettodrugbust", "cs_havana", Vector(-255.9446, -774.599, 0.0313), "gc_drug_capture_point")

GM:addObjectivePositionToGametype("ghettodrugbust", "cs_militia", Vector(171.7497, 754.8995, -115.9687), "gc_drug_point")
GM:addObjectivePositionToGametype("ghettodrugbust", "cs_militia", Vector(1287.92, 635.789, -120.620), "gc_drug_point")
GM:addObjectivePositionToGametype("ghettodrugbust", "cs_militia", Vector(489.6373, -2447.677, -169.529), "gc_drug_capture_point")

GM:addObjectivePositionToGametype("ghettodrugbust", "cs_italy", Vector(740.9838, 2303.0881, 168.4486), "gc_drug_point")
GM:addObjectivePositionToGametype("ghettodrugbust", "cs_italy", Vector(-382.8103, 1900.0341, -119.9687), "gc_drug_point")
GM:addObjectivePositionToGametype("ghettodrugbust", "cs_italy", Vector(-697.3092, -1622.7435, -239.9687), "gc_drug_capture_point")

GM:addObjectivePositionToGametype("ghettodrugbust", "de_chateau", Vector(99.3907, 919.5341, 24.0313), "gc_drug_point")
GM:addObjectivePositionToGametype("ghettodrugbust", "de_chateau", Vector(2081.2983, 1444.7068, 36.0313), "gc_drug_point")
GM:addObjectivePositionToGametype("ghettodrugbust", "de_chateau", Vector(1662.7606, -662.5977, -159.9687), "gc_drug_capture_point")

GM:addObjectivePositionToGametype("ghettodrugbust", "de_inferno", Vector(-572.666, -435.3488, 228.9928), "gc_drug_point")
GM:addObjectivePositionToGametype("ghettodrugbust", "de_inferno", Vector(-32.3297, 549.7234, 83.4212), "gc_drug_point")
GM:addObjectivePositionToGametype("ghettodrugbust", "de_inferno", Vector(2377.4863, 2517.3298, 131.9956), "gc_drug_capture_point")

GM:addObjectivePositionToGametype("ghettodrugbust", "de_shanty_v3_fix", Vector(497.7796, -1688.5574, 21.6237), "gc_drug_point")
GM:addObjectivePositionToGametype("ghettodrugbust", "de_shanty_v3_fix", Vector(-203.0704, -1800.5228, 165.4134), "gc_drug_point")
GM:addObjectivePositionToGametype("ghettodrugbust", "de_shanty_v3_fix", Vector(534.512, 19.6704, 6.9165), "gc_drug_capture_point")

GM:addObjectivePositionToGametype("ghettodrugbust", "de_christshanty", Vector(497.7796, -1688.5574, 21.6237), "gc_drug_point")
GM:addObjectivePositionToGametype("ghettodrugbust", "de_christshanty", Vector(-203.0704, -1800.5228, 165.4134), "gc_drug_point")
GM:addObjectivePositionToGametype("ghettodrugbust", "de_christshanty", Vector(534.512, 19.6704, 6.9165), "gc_drug_capture_point")

GM:addObjectivePositionToGametype("ghettodrugbust", "cs_backalley2", Vector(2059.864014, -1114.874878, -79.413551), "gc_drug_point")
GM:addObjectivePositionToGametype("ghettodrugbust", "cs_backalley2", Vector(2806.182373, -846.709045, 369.094177), "gc_drug_point")
GM:addObjectivePositionToGametype("ghettodrugbust", "cs_backalley2", Vector(1729.624390, 905.680908, 0.031250), "gc_drug_capture_point")

GM:addObjectivePositionToGametype("ghettodrugbust", "cs_christalley", Vector(2059.864014, -1114.874878, -79.413551), "gc_drug_point")
GM:addObjectivePositionToGametype("ghettodrugbust", "cs_christalley", Vector(2806.182373, -846.709045, 369.094177), "gc_drug_point")
GM:addObjectivePositionToGametype("ghettodrugbust", "cs_christalley", Vector(1729.624390, 905.680908, 0.031250), "gc_drug_capture_point")

GM:addObjectivePositionToGametype("ghettodrugbust", "cs_drugbust", Vector(797.227600, 1021.609314, 65.682472), "gc_drug_point")
GM:addObjectivePositionToGametype("ghettodrugbust", "cs_drugbust", Vector(968.099976, 662.791138, 212.031250), "gc_drug_point")
GM:addObjectivePositionToGametype("ghettodrugbust", "cs_drugbust", Vector(-2.121248, -561.990845, -7.968750), "gc_drug_capture_point")

GM:addObjectivePositionToGametype("ghettodrugbust", "cs_christbust", Vector(797.227600, 1021.609314, 65.682472), "gc_drug_point")
GM:addObjectivePositionToGametype("ghettodrugbust", "cs_christbust", Vector(968.099976, 662.791138, 212.031250), "gc_drug_point")
GM:addObjectivePositionToGametype("ghettodrugbust", "cs_christbust", Vector(-2.121248, -561.990845, -7.968750), "gc_drug_capture_point")