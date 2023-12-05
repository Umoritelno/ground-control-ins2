local assault = {}
assault.name = "assault"
assault.id = 1
assault.prettyName = "Assault"
assault.attackerTeam = TEAM_RED
assault.defenderTeam = TEAM_BLUE
assault.timeLimit = 315
assault.stopCountdown = true
assault.attackersPerDefenders = 3
assault.objectiveCounter = 0
assault.spawnDuringPreparation = true
assault.ClassGive = {[assault.defenderTeam] = true,[assault.attackerTeam] = true}
assault.AbilityGive = {[assault.defenderTeam] = true,[assault.attackerTeam] = true}
assault.objectiveEnts = {}

if SERVER then
	assault.mapRotation = GM:getMapRotation("assault_maps")
	
	GM.StartingPoints.rp_downtown_v2 = {
		[TEAM_BLUE] = {
			assault = {
				{position = Vector(1229.6053, 1217.8403, -195.9687), viewAngles = Angle(1.0781, -89.2518, 0)},
				{position = Vector(1129.8442, 1216.5354, -203.9687), viewAngles = Angle(1.0781, -89.2518, 0)},
				{position = Vector(1054.2517, 1215.5464, -203.9687), viewAngles = Angle(1.0781, -89.2518, 0)},
				{position = Vector(968.0956, 1214.4189, -195.9687), viewAngles = Angle(1.0781, -89.2518, 0)},
				{position = Vector(930.4415, 1278.582, -195.9687), viewAngles = Angle(1.0781, -89.2518, 0)},
				{position = Vector(929.465, 1362.9808, -195.9687), viewAngles = Angle(1.0781, -89.2518, 0)},
				{position = Vector(1027.2296, 1333.2775, -200.7752), viewAngles = Angle(1.0781, -89.2518, 0)},
				{position = Vector(1123.923, 1334.3507, -203.9687), viewAngles = Angle(1.0781, -89.2518, 0)},
				{position = Vector(1213.5834, 1335.5228, -195.9687), viewAngles = Angle(1.0781, -89.2518, 0)},
				{position = Vector(1235.2239, 1416.9071, -195.9687), viewAngles = Angle(1.0781, -89.2518, 0)},
				{position = Vector(1175.3423, 1454.0934, -195.9687), viewAngles = Angle(1.0781, -89.2518, 0)},
				{position = Vector(1096.2295, 1453.2295, -203.9687), viewAngles = Angle(1.0781, -89.2518, 0)},
				{position = Vector(1020.6302, 1452.2424, -199.1253), viewAngles = Angle(1.0781, -89.2518, 0)},
				{position = Vector(953.8265, 1451.3683, -195.9687), viewAngles = Angle(1.0781, -89.2518, 0)},
				{position = Vector(927.4063, 1525.8455, -195.9687), viewAngles = Angle(1.0781, -89.2518, 0)},
				{position = Vector(1008.4684, 1551.7803, -196.1028), viewAngles = Angle(1.0781, -89.2518, 0)},
				{position = Vector(1087.5789, 1552.8534, -203.9687), viewAngles = Angle(1.0781, -89.2518, 0)},
				{position = Vector(1166.6895, 1553.8884, -196.2973), viewAngles = Angle(1.0781, -89.2518, 0)},
				{position = Vector(1232.5876, 1554.7507, -195.9687), viewAngles = Angle(1.0781, -89.2518, 0)},
				{position = Vector(1257.8757, 1623.142, -195.9687), viewAngles = Angle(1.0781, -89.2518, 0)},
				{position = Vector(1194.9629, 1657.7408, -195.9687), viewAngles = Angle(1.0781, -89.2518, 0)},
				{position = Vector(1105.3007, 1656.7305, -203.9687), viewAngles = Angle(1.0781, -89.2518, 0)},
				{position = Vector(1022.6866, 1655.651, -199.6394), viewAngles = Angle(1.0781, -89.2518, 0)},
				{position = Vector(931.2745, 1654.4548, -195.9687), viewAngles = Angle(1.0781, -89.2518, 0)},
				{position = Vector(924.8574, 1733.795, -195.9687), viewAngles = Angle(1.0781, -89.2518, 0)},
				{position = Vector(999.5837, 1763.2145, -195.9687), viewAngles = Angle(1.0781, -89.2518, 0)},
				{position = Vector(1083.9647, 1764.38, -203.9687), viewAngles = Angle(1.0781, -89.2518, 0)},
				{position = Vector(1173.6332, 1765.5533, -195.9687), viewAngles = Angle(1.0781, -89.2518, 0)},
				{position = Vector(1243.9458, 1766.4733, -195.9687), viewAngles = Angle(1.0781, -89.2518, 0)}
			}
		},
		
		[TEAM_RED] = { 
			assault = {
				{position = Vector(-1729.4055, -2125.4785, -195.9687), viewAngles = Angle(3.08, 89.542, 0)},
				{position = Vector(-1641.4254, -2126.1833, -195.9687), viewAngles = Angle(3.08, 89.542, 0)},
				{position = Vector(-1513.0774, -2127.2119, -195.9687), viewAngles = Angle(3.08, 89.542, 0)},
				{position = Vector(-1395.2834, -2128.1558, -195.9687), viewAngles = Angle(3.08, 89.542, 0)},
				{position = Vector(-1282.7672, -2129.0574, -203.9688), viewAngles = Angle(3.08, 89.542, 0)},
				{position = Vector(-1189.568, -2129.8042, -203.9687), viewAngles = Angle(3.08, 89.542, 0)},
				{position = Vector(-1110.4552, -2130.4382, -195.9687), viewAngles = Angle(3.08, 89.542, 0)},
				{position = Vector(-1092.9962, -2224.7693, -195.9687), viewAngles = Angle(3.08, 89.542, 0)},
				{position = Vector(-1165.8156, -2267.3735, -195.9687), viewAngles = Angle(3.08, 89.542, 0)},
				{position = Vector(-1271.885, -2266.6086, -203.9687), viewAngles = Angle(3.08, 89.542, 0)},
				{position = Vector(-1373.8727, -2265.7913, -203.9687), viewAngles = Angle(3.08, 89.542, 0)},
				{position = Vector(-1482.8696, -2264.9177, -203.9687), viewAngles = Angle(3.08, 89.542, 0)},
				{position = Vector(-1591.8787, -2264.0442, -203.9687), viewAngles = Angle(3.08, 89.542, 0)},
				{position = Vector(-1686.8107, -2263.2839, -203.9687), viewAngles = Angle(3.08, 89.542, 0)},
				{position = Vector(-1778.226, -2262.5513, -203.9687), viewAngles = Angle(3.08, 89.542, 0)},
				{position = Vector(-1788.5939, -2359.5466, -195.9687), viewAngles = Angle(3.08, 89.542, 0)},
				{position = Vector(-1714.2246, -2360.1423, -195.9687), viewAngles = Angle(3.08, 89.542, 0)},
				{position = Vector(-1606.9722, -2361.002, -195.9688), viewAngles = Angle(3.08, 89.542, 0)},
				{position = Vector(-1501.4767, -2361.8472, -195.9687), viewAngles = Angle(3.08, 89.542, 0)},
				{position = Vector(-1392.4775, -2362.7207, -195.9688), viewAngles = Angle(3.08, 89.542, 0)},
				{position = Vector(-1294.0206, -2363.5098, -195.9687), viewAngles = Angle(3.08, 89.542, 0)},
				{position = Vector(-1195.5615, -2364.2986, -195.9687), viewAngles = Angle(3.08, 89.542, 0)},
				{position = Vector(-1107.6656, -2365.0027, -195.9687), viewAngles = Angle(3.08, 89.542, 0)}
			}
		}
	}
end

function assault:assignPointID(point)
	self.objectiveCounter = self.objectiveCounter + 1
	point.dt.PointID = self.objectiveCounter
end

function assault:arePointsFree()
	local curTime = CurTime()
	
	for key, obj in ipairs(self.objectiveEnts) do
		if obj.winDelay and obj.winDelay > curTime then
			return false
		end
	end
	
	return true
end

function assault:prepare()
	if CLIENT then
		RunConsoleCommand("gc_team_selection")
	end
	
	--[[if SERVER then
		local map = string.lower(game.GetMap())
		local startPoints = self.spawnPoints[map]
		
		if startPoints then
			GAMEMODE:setupStartingPoints(TEAM_RED, nil, startPoints[TEAM_RED])
			GAMEMODE:setupStartingPoints(TEAM_BLUE, nil, startPoints[TEAM_BLUE])
		end
	end]]--
end

function assault:getSuppressKnife(ply)
	return false
end

function assault:think()
	if not self.stopCountdown then
		if GAMEMODE:hasTimeRunOut() and self:arePointsFree() then
			GAMEMODE:endRound(self.defenderTeam)
		end
	end
end

function assault:playerInitialSpawn(ply)
	if GAMEMODE.RoundsPlayed == 0 then
		if #player.GetAll() >= 2 then
			GAMEMODE:endRound(nil)
		end
	end
end

function assault:postPlayerDeath(ply) -- check for round over possibility
	GAMEMODE:checkRoundOverPossibility(ply:Team())
end

function assault:playerDisconnected(ply)
	local hisTeam = ply:Team()
	
	timer.Simple(0, function() -- nothing fancy, just skip 1 frame and call postPlayerDeath, since 1 frame later the player won't be anywhere in the player tables
		GAMEMODE:checkRoundOverPossibility(hisTeam, true)
	end)
end

function assault.teamSwapCallback(player)
	umsg.Start("GC_NEW_TEAM", player)
		umsg.Short(player:Team())
	umsg.End()
end

function assault:roundStart()
	if SERVER then
		GAMEMODE:swapTeams(self.attackerTeam, self.defenderTeam, assault.teamSwapCallback, assault.teamSwapCallback) -- swap teams on every round start
		
		GAMEMODE:setTimeLimit(self.timeLimit)
		
		self.realAttackerTeam = self.attackerTeam
		self.realDefenderTeam = self.defenderTeam
		
		table.clear(self.objectiveEnts)
		self.stopCountdown = false
		
		GAMEMODE:initializeGameTypeEntities(self)
	end
end

function assault:onRoundEnded(winTeam)
	table.clear(self.objectiveEnts)
	self.stopCountdown = true
	self.objectiveCounter = 0
end

function assault:playerJoinTeam(ply, teamId)
	GAMEMODE:checkRoundOverPossibility(nil, true)
	GAMEMODE:sendTimeLimit(ply)
	ply:reSpectate()
end

function assault:deadDraw(w, h)
	if GAMEMODE:getActivePlayerAmount() < 2 then
		local lang = GetCurLanguage()
		draw.ShadowText(lang.round_players_require, GAMEMODE.SpectateFont, w * 0.5, _S(15), GAMEMODE.HUDColors.white, GAMEMODE.HUDColors.black, 1, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
end

GM:registerNewGametype(assault)

GM:addObjectivePositionToGametype("assault", "cs_jungle", Vector(560.8469, 334.9528, -127.9688), "gc_capture_point", {captureDistance = 200, capturerTeam = assault.attackerTeam, defenderTeam = assault.defenderTeam})
GM:addObjectivePositionToGametype("assault", "cs_jungle", Vector(1962.2684, 425.7988, -95.9687), "gc_capture_point", {captureDistance = 200, capturerTeam = assault.attackerTeam, defenderTeam = assault.defenderTeam})
GM:addObjectivePositionToGametype("assault", "cs_jungle", Vector(1442.923218, 489.496857, -127.968758), "gc_offlimits_area", {distance = 2048, targetTeam = assault.defenderTeam, inverseFunctioning = true})

GM:addObjectivePositionToGametype("assault", "cs_siege_2010", Vector(3164.2295, -1348.2546, -143.9687), "gc_capture_point", {captureDistance = 200, capturerTeam = assault.attackerTeam, defenderTeam = assault.defenderTeam})
GM:addObjectivePositionToGametype("assault", "cs_siege_2010", Vector(2063.8115234375, 12.88623046875, -78.426498413086), "gc_capture_point", {captureDistance = 200, capturerTeam = assault.attackerTeam, defenderTeam = assault.defenderTeam})
GM:addObjectivePositionToGametype("assault", "cs_siege_2010", Vector(3878.5757, -1108.7665, -143.9687), "gc_offlimits_area", {distance = 3500, targetTeam = assault.defenderTeam, inverseFunctioning = true})

GM:addObjectivePositionToGametype("assault", "cs_siege_pcs", Vector(1365.873413, 243.053009, -63.968750), "gc_capture_point", {captureDistance = 200, capturerTeam = assault.attackerTeam, defenderTeam = assault.defenderTeam})

GM:addObjectivePositionToGametype("assault", "cs_siege_pcs", Vector(1183.726685, -798.071350, 0.031250), "gc_capture_point", {captureDistance = 200, capturerTeam = assault.attackerTeam, defenderTeam = assault.defenderTeam})
GM:addObjectivePositionToGametype("assault", "cs_siege_pcs", Vector(1149.441162, -394.156891, 96.031250), "gc_offlimits_area", {distance = 2500, targetTeam = assault.defenderTeam, inverseFunctioning = true})

GM:addObjectivePositionToGametype("assault", "cs_siege_pcs", Vector(1365.873413, 243.053009, -63.968750), "gc_capture_point", {captureDistance = 200, capturerTeam = assault.attackerTeam, defenderTeam = assault.defenderTeam})

GM:addObjectivePositionToGametype("assault", "cs_siege_pcs", Vector(1183.726685, -798.071350, 0.031250), "gc_capture_point", {captureDistance = 200, capturerTeam = assault.attackerTeam, defenderTeam = assault.defenderTeam})
GM:addObjectivePositionToGametype("assault", "cs_siege_pcs", Vector(1149.441162, -394.156891, 96.031250), "gc_offlimits_area", {distance = 2500, targetTeam = assault.defenderTeam, inverseFunctioning = true})

GM:addObjectivePositionToGametype("assault", "gc_outpost", Vector(4718.394, 1762.6437, 0.0313), "gc_capture_point", {captureDistance = 200, capturerTeam = assault.attackerTeam, defenderTeam = assault.defenderTeam})
GM:addObjectivePositionToGametype("assault", "gc_outpost", Vector(3947.8335, 2541.6055, 0.0313), "gc_capture_point", {captureDistance = 200, capturerTeam = assault.attackerTeam, defenderTeam = assault.defenderTeam})
GM:addObjectivePositionToGametype("assault", "gc_outpost", Vector(3147.9561, 1540.1907, -8.068), "gc_offlimits_area", {distance = 2048, targetTeam = assault.defenderTeam, inverseFunctioning = true})

GM:addObjectivePositionToGametype("assault", "rp_downtown_v2", Vector(686.9936, 1363.9843, -195.9687), "gc_capture_point", {captureDistance = 200, capturerTeam = assault.attackerTeam, defenderTeam = assault.defenderTeam})
GM:addObjectivePositionToGametype("assault", "rp_downtown_v2", Vector(-144.8516, 1471.2026, -195.9687), "gc_capture_point", {captureDistance = 200, capturerTeam = assault.attackerTeam, defenderTeam = assault.defenderTeam})
GM:addObjectivePositionToGametype("assault", "rp_downtown_v2", Vector(816.7338, 847.4449, -195.9687), "gc_offlimits_area", {distance = 1400, targetTeam = assault.defenderTeam, inverseFunctioning = true})

GM:addObjectivePositionToGametype("assault", "de_desert_atrocity_v3", Vector(384.5167, -1567.5787, -2.5376), "gc_capture_point", {captureDistance = 200, capturerTeam = assault.defenderTeam, defenderTeam = assault.attackerTeam})
GM:addObjectivePositionToGametype("assault", "de_desert_atrocity_v3", Vector(3832.3855, -2022.0819, 248.0313), "gc_capture_point", {captureDistance = 200, capturerTeam = assault.defenderTeam, defenderTeam = assault.attackerTeam})
GM:addObjectivePositionToGametype("assault", "de_desert_atrocity_v3", Vector(1898.58, -1590.46, 136.0313), "gc_offlimits_area", {distance = 2000, targetTeam = assault.attackerTeam, inverseFunctioning = true})

GM:addObjectivePositionToGametype("assault", "gc_depot_b2", Vector(-5565.1865, 832.9864, 128.0313), "gc_capture_point", {captureDistance = 150, capturerTeam = assault.defenderTeam, defenderTeam = assault.attackerTeam})
GM:addObjectivePositionToGametype("assault", "gc_depot_b2", Vector(-7676.4849, -597.2024, -351.9687), "gc_capture_point", {captureDistance = 150, capturerTeam = assault.defenderTeam, defenderTeam = assault.attackerTeam})
GM:addObjectivePositionToGametype("assault", "gc_depot_b2", Vector(-5108.8721, -1509.1794, -933.2501), "gc_offlimits_area_aabb", {distance = 2000, targetTeam = assault.attackerTeam, min = Vector(-5108.8721, -1509.1794, -933.2501), max = Vector(930.1258, 5336.1563, 686.4084)})