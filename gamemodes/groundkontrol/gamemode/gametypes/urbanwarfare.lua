local urbanwarfare = {}
urbanwarfare.name = "urbanwarfare"
urbanwarfare.id = 4
urbanwarfare.prettyName = "Urban Warfare"
urbanwarfare.timeLimit = 315
urbanwarfare.waveTimeLimit = 135
urbanwarfare.attackersPerDefenders = 3
urbanwarfare.objectiveCounter = 0
urbanwarfare.spawnDuringPreparation = true
urbanwarfare.objectiveEnts = {}
urbanwarfare.startingTickets = 100 -- the amount of tickets that a team starts with
urbanwarfare.ticketsPerPlayer = 2.5 -- amount of tickets to increase per each player on server
urbanwarfare.capturePoint = nil -- the entity responsible for a bulk of the gametype logic, the reference to it is assigned when it is initialized
urbanwarfare.waveWinReward = {cash = 50, exp = 50}
urbanwarfare.ClassGive = {[TEAM_BLUE] = false,[TEAM_RED] = false}
urbanwarfare.AbilityGive = {[TEAM_BLUE] = false,[TEAM_RED] = false}

if SERVER then
	urbanwarfare.mapRotation = GM:getMapRotation("urbanwarfare_maps")
	
	GM.StartingPoints.rp_downtown_v4c_v2 = {
		[TEAM_RED] = {
			urbanwarfare = {
				{position = Vector(690.0195, 3803.3743, -203.9687), viewAngles = Angle(13.09, -93.2347, 0)},
				{position = Vector(769.6985, 3802.8523, -203.9687), viewAngles = Angle(3.696, -90.4627, 0)},
				{position = Vector(841.5054, 3802.2739, -203.9687), viewAngles = Angle(3.696, -90.4627, 0)},
				{position = Vector(941.3118, 3801.4734, -203.9687), viewAngles = Angle(3.696, -90.4627, 0)},
				{position = Vector(1057.3527, 3800.5432, -203.9687), viewAngles = Angle(3.696, -90.4627, 0)},
				{position = Vector(1152.2914, 3799.7825, -203.9687), viewAngles = Angle(3.696, -90.4627, 0)},
				{position = Vector(1263.0477, 3798.8953, -203.9687), viewAngles = Angle(3.696, -90.4627, 0)},
				{position = Vector(1372.0547, 3798.0215, -203.9687), viewAngles = Angle(3.696, -90.4627, 0)},
				{position = Vector(1465.8802, 3797.2693, -203.9687), viewAngles = Angle(3.696, -90.4627, 0)},
				{position = Vector(1473.9479, 3876.8828, -203.9687), viewAngles = Angle(3.696, -90.4627, 0)},
				{position = Vector(1400.933, 3877.4688, -203.9687), viewAngles = Angle(3.696, -90.4627, 0)},
				{position = Vector(1297.2017, 3878.3005, -203.9687), viewAngles = Angle(3.696, -90.4627, 0)},
				{position = Vector(1196.9884, 3879.1033, -203.9687), viewAngles = Angle(3.696, -90.4627, 0)},
				{position = Vector(1096.7743, 3879.9063, -203.9687), viewAngles = Angle(3.696, -90.4627, 0)},
				{position = Vector(998.3176, 3880.6951, -203.9687), viewAngles = Angle(3.696, -90.4627, 0)},
				{position = Vector(901.6295, 3881.47, -203.9687), viewAngles = Angle(3.696, -90.4627, 0)},
				{position = Vector(799.6418, 3882.2871, -203.9687), viewAngles = Angle(3.696, -90.4627, 0)}
			}
		},
		
		[TEAM_BLUE] = {
			urbanwarfare = {
				{position = Vector(704.7042, 3883.0476, -203.9687), viewAngles = Angle(3.696, -90.4627, 0)},
				{position = Vector(608.0021, 3883.8225, -203.9687), viewAngles = Angle(3.696, -90.4627, 0)},
				{position = Vector(-670.2028, -4399.5659, -198.9687), viewAngles = Angle(4.004, 90.7955, 0)},
				{position = Vector(-746.2972, -4400.6152, -198.9688), viewAngles = Angle(4.004, 90.7955, 0)},
				{position = Vector(-857.0679, -4402.1406, -198.9687), viewAngles = Angle(4.004, 90.7955, 0)},
				{position = Vector(-951.9993, -4403.4482, -198.9687), viewAngles = Angle(4.004, 90.7955, 0)},
				{position = Vector(-1048.7062, -4404.7803, -198.9687), viewAngles = Angle(4.004, 90.7955, 0)},
				{position = Vector(-1140.1229, -4406.0396, -198.9687), viewAngles = Angle(4.004, 90.7955, 0)},
				{position = Vector(-1235.0531, -4407.3472, -198.9687), viewAngles = Angle(4.004, 90.7955, 0)},
				{position = Vector(-1337.0193, -4408.752, -198.9687), viewAngles = Angle(4.004, 90.7955, 0)},
				{position = Vector(-1433.7092, -4410.0825, -198.9687), viewAngles = Angle(4.004, 90.7955, 0)},
				{position = Vector(-1530.3984, -4411.415, -198.9687), viewAngles = Angle(4.004, 90.7955, 0)},
				{position = Vector(-1621.8171, -4412.6743, -198.9687), viewAngles = Angle(4.004, 90.7955, 0)},
				{position = Vector(-1718.4994, -4414.0054, -198.9687), viewAngles = Angle(4.004, 90.7955, 0)},
				{position = Vector(-1811.6622, -4415.2886, -198.9687), viewAngles = Angle(4.004, 90.7955, 0)},
				{position = Vector(-1906.6072, -4416.5967, -198.9687), viewAngles = Angle(4.004, 90.7955, 0)},
				{position = Vector(-1989.2278, -4417.7344, -198.9687), viewAngles = Angle(4.004, 90.7955, 0)},
				{position = Vector(-2084.1621, -4419.0415, -198.9687), viewAngles = Angle(4.004, 90.7955, 0)},
				{position = Vector(-2179.0879, -4420.3491, -198.9687), viewAngles = Angle(4.004, 90.7955, 0)}
			}
		}
	}
	
	GM.StartingPoints.ph_skyscraper_construct = {
		[TEAM_RED] = {
			urbanwarfare = {
				{position = Vector(774.0888, 983.2716, -127.9687), viewAngles = Angle(10.9339, -89.8191, 0)},
				{position = Vector(774.344, 902.5513, -127.9687), viewAngles = Angle(10.9339, -89.8191, 0)},
				{position = Vector(774.6385, 809.3679, -127.9687), viewAngles = Angle(10.9339, -89.8191, 0)},
				{position = Vector(774.9553, 709.1458, -127.9687), viewAngles = Angle(10.9339, -89.8191, 0)},
				{position = Vector(775.2556, 614.2077, -127.9687), viewAngles = Angle(10.9339, -89.8191, 0)},
				{position = Vector(775.5556, 519.2693, -127.9687), viewAngles = Angle(10.9339, -89.8191, 0)},
				{position = Vector(775.8668, 420.8229, -127.9687), viewAngles = Angle(10.9339, -89.8191, 0)},
				{position = Vector(776.1726, 324.1125, -127.9687), viewAngles = Angle(10.9339, -89.8191, 0)},
				{position = Vector(776.4672, 230.9174, -127.9687), viewAngles = Angle(10.9339, -89.8191, 0)},
				{position = Vector(776.7599, 138.3155, -127.9687), viewAngles = Angle(10.9339, -89.8191, 0)},
				{position = Vector(852.5703, 127.1812, -127.9687), viewAngles = Angle(10.9339, -89.8191, 0)},
				{position = Vector(852.3819, 186.7617, -127.9687), viewAngles = Angle(10.9339, -89.8191, 0)},
				{position = Vector(852.0763, 283.4687, -131.9687), viewAngles = Angle(10.9339, -89.8191, 0)},
				{position = Vector(851.7705, 380.1672, -127.9687), viewAngles = Angle(10.9339, -89.8191, 0)},
				{position = Vector(851.4926, 468.0828, -127.9687), viewAngles = Angle(10.9339, -89.8191, 0)},
				{position = Vector(851.217, 555.2672, -127.9687), viewAngles = Angle(10.9339, -89.8191, 0)},
				{position = Vector(851.1285, 626.7723, -127.9687), viewAngles = Angle(8.3159, 90.0529, 0)},
				{position = Vector(851.0486, 714.6813, -127.9687), viewAngles = Angle(8.3159, 90.0529, 0)},
				{position = Vector(850.9801, 790.283, -127.9687), viewAngles = Angle(8.3159, 90.0529, 0)},
				{position = Vector(850.9099, 867.6542, -127.9687), viewAngles = Angle(8.3159, 90.0529, 0)},
				{position = Vector(850.8647, 917.1987, -127.9687), viewAngles = Angle(8.3159, 90.0529, 0)}
			}
		},
			
		[TEAM_BLUE] = {
			urbanwarfare = {
				{position = Vector(-762.5663, -847.2106, -127.9687), viewAngles = Angle(2.0019, 90.0528, 0)},
				{position = Vector(-762.6284, -779.3649, -127.9687), viewAngles = Angle(2.0019, 90.0528, 0)},
				{position = Vector(-762.7089, -691.1991, -127.9687), viewAngles = Angle(2.0019, 90.0528, 0)},
				{position = Vector(-762.7861, -606.497, -127.9687), viewAngles = Angle(2.0019, 90.0528, 0)},
				{position = Vector(-762.8611, -523.8428, -127.9687), viewAngles = Angle(2.0019, 90.0528, 0)},
				{position = Vector(-762.9329, -444.7097, -127.9687), viewAngles = Angle(2.0019, 90.0528, 0)},
				{position = Vector(-762.9976, -373.6328, -127.9687), viewAngles = Angle(2.0019, 90.0528, 0)},
				{position = Vector(-763.1141, -245.7027, -127.9687), viewAngles = Angle(2.0019, 90.0528, 0)},
				{position = Vector(-763.1843, -168.337, -127.9687), viewAngles = Angle(2.0019, 90.0528, 0)},
				{position = Vector(-763.2594, -85.692, -127.9687), viewAngles = Angle(2.0019, 90.0528, 0)},
				{position = Vector(-823.4547, -44.4427, -127.9687), viewAngles = Angle(2.9259, -88.5871, 0)},
				{position = Vector(-821.9818, -104.148, -127.9687), viewAngles = Angle(2.9259, -88.5871, 0)},
				{position = Vector(-820.1603, -177.9798, -127.9687), viewAngles = Angle(2.9259, -88.5871, 0)},
				{position = Vector(-818.382, -250.0601, -127.9687), viewAngles = Angle(2.9259, -88.5871, 0)},
				{position = Vector(-815.1729, -380.1232, -127.9687), viewAngles = Angle(2.9259, -88.5871, 0)},
				{position = Vector(-813.395, -452.1877, -127.9687), viewAngles = Angle(2.9259, -88.5871, 0)},
				{position = Vector(-811.7037, -520.7379, -127.9687), viewAngles = Angle(2.9259, -88.5871, 0)},
				{position = Vector(-810.0989, -585.7841, -127.9687), viewAngles = Angle(2.9259, -88.5871, 0)},
				{position = Vector(-808.1475, -664.8785, -127.9687), viewAngles = Angle(2.9259, -88.5871, 0)},
				{position = Vector(-806.413, -735.1838, -127.9687), viewAngles = Angle(2.9259, -88.5871, 0)},
				{position = Vector(-804.3742, -817.8115, -127.9687), viewAngles = Angle(2.9259, -88.5871, 0)},
				{position = Vector(-802.6829, -886.3654, -127.9687), viewAngles = Angle(2.9259, -88.5871, 0)}
			}
		}
	}
end

function urbanwarfare:assignPointID(point)
	self.objectiveCounter = self.objectiveCounter + 1
	point.dt.PointID = self.objectiveCounter
end 

function urbanwarfare:getSuppressKnife(ply)
	return false
end

function urbanwarfare:endWave(capturer, noTicketDrainForWinners)
	self.waveEnded = true
	
	timer.Simple(0, function()
		for key, ent in ipairs(ents.FindByClass("cw_dropped_weapon")) do
			SafeRemoveEntity(ent)
		end
		
		GAMEMODE:balanceTeams(true)
		
		if capturer then	
			local opposingTeam = GAMEMODE.OpposingTeam[capturer]
			
			if self.capturePoint:getTeamTickets(opposingTeam) == 0 then
				GAMEMODE:endRound(capturer)
			end
		else
			self:checkEndWaveTickets(TEAM_RED)
			self:checkEndWaveTickets(TEAM_BLUE)
		end
		
		self:spawnPlayersNewWave(capturer, TEAM_RED, (capturer and (noTicketDrainForWinners and TEAM_RED == capturer)))
		self:spawnPlayersNewWave(capturer, TEAM_BLUE, (capturer and (noTicketDrainForWinners and TEAM_BLUE == capturer)))
		self.waveEnded = false
		
		GAMEMODE:resetAllKillcountData()
		GAMEMODE:sendAlivePlayerCount()
	end)
end

function urbanwarfare:checkEndWaveTickets(teamID)
	if self.capturePoint:getTeamTickets(teamID) == 0 then
		GAMEMODE:endRound(GAMEMODE.OpposingTeam[teamID])
	end
end

function urbanwarfare:spawnPlayersNewWave(capturer, teamID, isFree)
	local bypass = false
	local players = team.GetPlayers(teamID)
	
	if capturer and capturer ~= teamID then
		local alive = 0
		
		for key, ply in ipairs(players) do
			if ply:Alive() then
				alive = alive + 1
			end
		end
		
		-- if the enemy team captured the point and noone died on the loser team, then that teams will lose tickets equivalent to the amount of players in their team
		bypass = alive == #players
	end
	
	local lostTickets = 0
	
	for key, ply in ipairs(players) do
		if not isFree or bypass then
			self.capturePoint:drainTicket(teamID)
			lostTickets = lostTickets + 1
		end
			
		if not ply:Alive() then
			ply:Spawn()
		end
		
		if capturer == teamID then
			ply:addCurrency(self.waveWinReward.cash, self.waveWinReward.exp, "WAVE_WON")
		end
	end
	
	for key, ply in ipairs(players) do
		umsg.Start("GC_NEW_WAVE", ply)
			umsg.Short(lostTickets)
		umsg.End()
	end
end

function urbanwarfare:postPlayerDeath(ply) -- check for round over possibility
	self:checkTickets(ply:Team())
end

function urbanwarfare:playerDisconnected(ply)
	local hisTeam = ply:Team()
	
	timer.Simple(0, function() -- nothing fancy, just skip 1 frame and call postPlayerDeath, since 1 frame later the player won't be anywhere in the player tables
		self:checkTickets(hisTeam)
	end)
end

function urbanwarfare:checkTickets(teamID)
	if not IsValid(self.capturePoint) then
		return
	end
	
	if self.capturePoint:getTeamTickets(teamID) == 0 then
		GAMEMODE:checkRoundOverPossibility(teamID)
	else
		self:checkWaveOverPossibility(teamID)
	end
end

function urbanwarfare:checkWaveOverPossibility(teamID)
	local players = team.GetAlivePlayers(teamID)
	
	if players == 0 then
		self.capturePoint:endWave(GAMEMODE.OpposingTeam[teamID], true)
	end
end

function urbanwarfare:prepare()
	if CLIENT then
		RunConsoleCommand("gc_team_selection")
	else
		GAMEMODE.RoundsPerMap = 2
	end
end

function urbanwarfare:onRoundEnded(winTeam)
	self.objectiveCounter = 0
end

function urbanwarfare:playerJoinTeam(ply, teamId)
	GAMEMODE:checkRoundOverPossibility(nil, true)
	GAMEMODE:sendTimeLimit(ply)
	ply:reSpectate()
end

function urbanwarfare:playerInitialSpawn(ply)
	if GAMEMODE.RoundsPlayed == 0 then
		if #player.GetAll() >= 2 then
			GAMEMODE:endRound(nil)
			GAMEMODE.RoundsPlayed = 1
		end
	end
end

function urbanwarfare:roundStart()
	if SERVER then
		GAMEMODE:initializeGameTypeEntities(self)
	end
end

GM:registerNewGametype(urbanwarfare)

GM:addObjectivePositionToGametype("urbanwarfare", "rp_downtown_v4c_v2", Vector(-817.765076, -1202.352417, -195.968750), "gc_urban_warfare_capture_point", {capMin = Vector(-1022.9687, -952.0312, -196), capMax = Vector(-449.0312, -1511.9696, 68.0313)})

GM:addObjectivePositionToGametype("urbanwarfare", "ph_skyscraper_construct", Vector(2.9675, -558.3918, -511.9687), "gc_urban_warfare_capture_point", {capMin = Vector(-159.9687, -991.9687, -515), capMax = Vector(143.6555, -288.0312, -440)})

GM:addObjectivePositionToGametype("urbanwarfare", "de_desert_atrocity_v3", Vector(2424.1348, -920.4495, 120.0313), "gc_urban_warfare_capture_point", {capMin = Vector(2288.031250, -816.031250, 120.031250), capMax = Vector(2598.074951, -1092.377441, 200)})