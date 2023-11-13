local oneSideRush = {} -- one side rush because you only need to cap 1 point as the attacker
oneSideRush.name = "onesiderush"
oneSideRush.id = 2
oneSideRush.prettyName = "Rush"
oneSideRush.objectiveEnts = {}
oneSideRush.attackerTeam = TEAM_BLUE
oneSideRush.defenderTeam = TEAM_RED
oneSideRush.swappedTeams = false
oneSideRush.timeLimit = 195
oneSideRush.stopCountdown = true
oneSideRush.objectiveCounter = 0
oneSideRush.spawnDuringPreparation = true
oneSideRush.ClassGive = {[oneSideRush.attackerTeam] = true,[oneSideRush.defenderTeam] = true}
oneSideRush.AbilityGive = {[oneSideRush.attackerTeam] = true,[oneSideRush.defenderTeam] = true}

if SERVER then
	oneSideRush.mapRotation = GM:getMapRotation("one_side_rush")
end

function oneSideRush:getSuppressKnife(ply)
	return false
end

function oneSideRush:assignPointID(point)
	self.objectiveCounter = self.objectiveCounter + 1
	point.dt.PointID = self.objectiveCounter
end

function oneSideRush:prepare()
	if CLIENT then
		RunConsoleCommand("gc_team_selection")
	end
end

function oneSideRush:arePointsFree()
	local curTime = CurTime()
	
	for key, obj in ipairs(self.objectiveEnts) do
		if obj.winDelay > curTime then
			return false
		end
	end
	
	return true
end

function oneSideRush.teamSwapCallback(player)
	umsg.Start("GC_NEW_TEAM", player)
		umsg.Short(player:Team())
	umsg.End()
end

function oneSideRush:roundStart()
	if SERVER then
		if not self.swappedTeams then
			if GAMEMODE.RoundsPlayed >= GAMEMODE.RoundsPerMap * 0.5 then
				GAMEMODE:swapTeams(self.attackerTeam, self.defenderTeam, oneSideRush.teamSwapCallback, oneSideRush.teamSwapCallback)
				self.swappedTeams = true
			end
		end
		
		GAMEMODE:setTimeLimit(self.timeLimit)
		
		self.realAttackerTeam = self.attackerTeam
		self.realDefenderTeam = self.defenderTeam
		table.clear(self.objectiveEnts)
		self.stopCountdown = false
		
		GAMEMODE:initializeGameTypeEntities(self)
	end
end

function oneSideRush:think()
	if not self.stopCountdown then
		if GAMEMODE:hasTimeRunOut() and self:arePointsFree() then
			GAMEMODE:endRound(self.realDefenderTeam)
		end
	end
end

function oneSideRush:onTimeRanOut()
	GAMEMODE:endRound(self.defenderTeam)
end

function oneSideRush:onRoundEnded(winTeam)
	table.clear(self.objectiveEnts)
	self.stopCountdown = true
	self.objectiveCounter = 0
end

function oneSideRush:postPlayerDeath(ply) -- check for round over possibility
	GAMEMODE:checkRoundOverPossibility(ply:Team())
end

function oneSideRush:playerDisconnected(ply)
	local hisTeam = ply:Team()
	
	timer.Simple(0, function() -- nothing fancy, just skip 1 frame and call postPlayerDeath, since 1 frame later the player won't be anywhere in the player tables
		GAMEMODE:checkRoundOverPossibility(hisTeam, true)
	end)
end

function oneSideRush:playerJoinTeam(ply, teamId)
	--print(ply)
	GAMEMODE:checkRoundOverPossibility(nil, true)
	GAMEMODE:sendTimeLimit(ply)
	ply:reSpectate()
end

GM:registerNewGametype(oneSideRush)

GM:addObjectivePositionToGametype("onesiderush", "de_dust2", Vector(1147.345093, 2437.071045, 96.031250), "gc_capture_point")
GM:addObjectivePositionToGametype("onesiderush", "de_dust2", Vector(-1546.877197, 2657.465332, 1.431068), "gc_capture_point")

GM:addObjectivePositionToGametype("onesiderush", "de_port", Vector(-3131.584473, -2.002135, 640.031250), "gc_capture_point", {captureDistance = 256})
GM:addObjectivePositionToGametype("onesiderush", "de_port", Vector(1712.789551, 347.170563, 690.031250), "gc_capture_point", {captureDistance = 300})

GM:addObjectivePositionToGametype("onesiderush", "cs_compound", Vector(1934.429321, -1240.472046, 0.584229), "gc_capture_point", {captureDistance = 256, capturerTeam = TEAM_RED, defenderTeam = TEAM_BLUE})
GM:addObjectivePositionToGametype("onesiderush", "cs_compound", Vector(1772.234375, 623.238525, 0.031250), "gc_capture_point", {captureDistance = 256, capturerTeam = TEAM_RED, defenderTeam = TEAM_BLUE})

GM:addObjectivePositionToGametype("onesiderush", "cs_havana", Vector(890.551331, 652.600220, 256.031250), "gc_capture_point", {captureDistance = 256, capturerTeam = TEAM_RED, defenderTeam = TEAM_BLUE})
GM:addObjectivePositionToGametype("onesiderush", "cs_havana", Vector(93.409294, 2024.913696, 16.031250), "gc_capture_point", {captureDistance = 256, capturerTeam = TEAM_RED, defenderTeam = TEAM_BLUE})

GM:addObjectivePositionToGametype("onesiderush", "de_aztec", Vector(-290.273560, -1489.696289, -226.568970), "gc_capture_point", {captureDistance = 256})
GM:addObjectivePositionToGametype("onesiderush", "de_aztec", Vector(-1846.402222, 1074.247803, -221.927124), "gc_capture_point", {captureDistance = 256})

GM:addObjectivePositionToGametype("onesiderush", "de_cbble", Vector(-2751.983643, -1788.725342, 48.025673), "gc_capture_point", {captureDistance = 256})
GM:addObjectivePositionToGametype("onesiderush", "de_cbble", Vector(824.860535, -977.904724, -127.968750), "gc_capture_point", {captureDistance = 256})

GM:addObjectivePositionToGametype("onesiderush", "de_chateau", Vector(137.296066, 999.551453, 0.031250), "gc_capture_point", {captureDistance = 256})
GM:addObjectivePositionToGametype("onesiderush", "de_chateau", Vector(2242.166260, 1220.794800, 0.031250), "gc_capture_point", {captureDistance = 256})

GM:addObjectivePositionToGametype("onesiderush", "de_dust", Vector(122.117203, -1576.552856, 64.031250), "gc_capture_point", {captureDistance = 256})
GM:addObjectivePositionToGametype("onesiderush", "de_dust", Vector(1998.848999, 594.460327, 3.472847), "gc_capture_point", {captureDistance = 256})

GM:addObjectivePositionToGametype("onesiderush", "de_inferno", Vector(2088.574707, 445.291107, 160.031250), "gc_capture_point", {captureDistance = 256})
GM:addObjectivePositionToGametype("onesiderush", "de_inferno", Vector(396.628296, 2605.968750, 164.031250), "gc_capture_point", {captureDistance = 256})

GM:addObjectivePositionToGametype("onesiderush", "de_nuke", Vector(706.493347, -963.940552, -415.968750), "gc_capture_point", {captureDistance = 256})
GM:addObjectivePositionToGametype("onesiderush", "de_nuke", Vector(619.076172, -955.975037, -767.968750), "gc_capture_point", {captureDistance = 256})

GM:addObjectivePositionToGametype("onesiderush", "de_piranesi", Vector(-1656.252563, 2382.538818, 224.031250), "gc_capture_point", {captureDistance = 256})
GM:addObjectivePositionToGametype("onesiderush", "de_piranesi", Vector(-258.952271, -692.915649, 96.031250), "gc_capture_point", {captureDistance = 256})

GM:addObjectivePositionToGametype("onesiderush", "de_tides", Vector(-182.13874816895, -425.63604736328, 0.03125), "gc_capture_point", {captureDistance = 230})
GM:addObjectivePositionToGametype("onesiderush", "de_tides", Vector(-1120.269531, -1442.878418, -122.518227), "gc_capture_point", {captureDistance = 230})

GM:addObjectivePositionToGametype("onesiderush", "dm_runoff", Vector(10341.602539, 1974.626709, -255.968750), "gc_capture_point", {captureDistance = 256})

GM:addObjectivePositionToGametype("onesiderush", "de_train", Vector(1322.792725, -250.027832, -215.968750), "gc_capture_point", {captureDistance = 192})
GM:addObjectivePositionToGametype("onesiderush", "de_train", Vector(32.309258, -1397.823120, -351.968750), "gc_capture_point", {captureDistance = 192})

GM:addObjectivePositionToGametype("onesiderush", "cs_assault", Vector(6733.837402, 4496.704590, -861.968750), "gc_capture_point", {captureDistance = 220, capturerTeam = TEAM_RED, defenderTeam = TEAM_BLUE})
GM:addObjectivePositionToGametype("onesiderush", "cs_assault", Vector(6326.040527, 4106.064453, -606.738403), "gc_capture_point", {captureDistance = 220, capturerTeam = TEAM_RED, defenderTeam = TEAM_BLUE})

GM:addObjectivePositionToGametype("onesiderush", "de_prodigy", Vector(408.281616, -492.238770, -207.968750), "gc_capture_point", {captureDistance = 220})
GM:addObjectivePositionToGametype("onesiderush", "de_prodigy", Vector(1978.739258, -277.940277, -415.968750), "gc_capture_point", {captureDistance = 220})

GM:addObjectivePositionToGametype("onesiderush", "de_desert_atrocity_v3", Vector(384.5167, -1567.5787, -2.5376), "gc_capture_point", {captureDistance = 200})
GM:addObjectivePositionToGametype("onesiderush", "de_desert_atrocity_v3", Vector(3832.3855, -2022.0819, 248.0313), "gc_capture_point", {captureDistance = 200})

GM:addObjectivePositionToGametype("onesiderush", "de_secretcamp", Vector(90.6324, 200.1089, -87.9687), "gc_capture_point", {captureDistance = 200})
GM:addObjectivePositionToGametype("onesiderush", "de_secretcamp", Vector(-45.6821, 1882.2468, -119.9687), "gc_capture_point", {captureDistance = 200})

GM:addObjectivePositionToGametype("contendedpoint", "rp_outercanals", Vector(-1029.633667, -22.739532, 0.031250), "gc_contended_point", {captureDistance = 384})