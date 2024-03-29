util.AddNetworkString("GC_ROUND_OVER")


GM.RoundWonCash = 200
GM.RoundWonExp = 150

GM.RoundsPerMap = GM.defaultRounds
GM.RoundsPlayed = 0
GM.MaxMapsPerPick = 9
GM.MaxGameTypesPerPick = 9
GM.MaxWeaponBasesPerPick = 5 -- why did we need more?

GM.TrashDealingMethods = { -- how to deal with trash props (small props with a small weight that the player collides with and then everything goes to fuck)
	REMOVE = 1, -- will remove them
	COLLISION = 2 -- will set the collision group to debris (does not collide with the player)
}

GM.DealWithTrash = GM.TrashDealingMethods.COLLISION
GM.TrashPropMaxWeight = 2 -- max weight of a prop to be considered trash

GM.VoteMapVoteID = "votemap"
GM.VoteGametypeVoteId = "votegametype"
GM.VoteBaseID = "votebase"

util.AddNetworkString("GC_ROUND_PREPARATION")

function GM:trackRoundMVP(player, id, amount)
	self.MVPTracker:trackID(player, id, amount)
end

function GM:dealWithTrashProps()
	if self.DealWithTrash == self.TrashDealingMethods.REMOVE then
		self:removeTrashProps(ents.FindByClass("prop_physics"))
		self:removeTrashProps(ents.FindByClass("prop_physics_multiplayer"))
	elseif self.DealWithTrash == self.TrashDealingMethods.COLLISION then
		self:makeDebrisMovetypeForTrash(ents.FindByClass("prop_physics"))
		self:makeDebrisMovetypeForTrash(ents.FindByClass("prop_physics_multiplayer"))
	end
end

function GM:removeTrashProps(entList)
	for k, v in pairs(entList) do
		local phys = v:GetPhysicsObject()
		
		if IsValid(phys) and phys:GetMass() <= self.TrashPropMaxWeight then
			SafeRemoveEntity(v)
		end
	end
end

function GM:makeDebrisMovetypeForTrash(entList)
	for k, v in pairs(entList) do
		local phys = v:GetPhysicsObject()
		
		if IsValid(phys) and phys:GetMass() <= self.TrashPropMaxWeight then
			v:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
		end
	end
end

-- this is the default round over check, for gametypes with no player respawns
function GM:checkRoundOverPossibility(teamId, ignoreDisplay)
	if not self.RoundOver then
		local allPlayers = player.GetAll()
		
		if #allPlayers < 2 then -- don't do anything if we only have 2 players
			if allPlayers == 0 then -- if everyone disconnected, reset rounds played
				self.RoundsPlayed = 0
			end
			
			return
		end
	
		local redMembers = team.GetPlayers(TEAM_RED)
		local blueMembers = team.GetPlayers(TEAM_BLUE)
		
		if #redMembers == 0 or #blueMembers == 0 then -- if neither team has AT LEAST ONE member, we don't restart rounds at all
			return
		end
		
		if self.RoundsPlayed > 0 then
			local winner = nil
			
			if self:countLivingPlayers(TEAM_RED) == 0 then
				winner = TEAM_BLUE
			end
			
			if self:countLivingPlayers(TEAM_BLUE) == 0 then
				winner = TEAM_RED
			end
			
			if winner then
				self:endRound(winner)
			end
		else
			self:endRound(nil)
		end
	end
	
	if teamId then
		if not ignoreDisplay then
			self:createLastManStandingDisplay(teamId)
		end
	end
end

function GM:canRestartRound()
	if GetConVarNumber("gc_randomly_pick_gametype_and_map") >= 1 then
		return  self.RoundsPlayed < self.RoundsPerMap - 1
	end
	
	return true
end

function GM:endRound(winningTeam)
	if self.RoundOver then -- we're already restarting a round wtf
		return
	end
	
	hook.Call("GroundControlPreRoundEnded", nil, winningTeam)
	
	print("[GROUND CONTROL] ROUND HAS ENDED, WINNING TEAM ID: ", winningTeam)
	local lastRound = self.RoundsPlayed >= self.RoundsPerMap
	local canRestart = self:canRestartRound()
	local randomMapAndGametype = GetConVarNumber("gc_randomly_pick_gametype_and_map") >= 1
	local canPickRandomMapAndGametype = not canRestart and randomMapAndGametype
	local actionToSend = nil
	
	if canPickRandomMapAndGametype then
		actionToSend = self.RoundOverAction.RANDOM_MAP_AND_GAMETYPE
	else
		actionToSend = self.RoundOverAction.NEW_ROUND
	end
	
	if not winningTeam then
		SendUserMessage("GC_GAME_BEGIN")
	else
		for key, obj in ipairs(team.GetPlayers(winningTeam)) do
			obj:addCurrency(self.RoundWonCash, self.RoundWonExp, "WON_ROUND")
		end
		
		net.Start("GC_ROUND_OVER")
			net.WriteInt(winningTeam, 8)
			net.WriteInt(actionToSend, 8)
		net.Send(player.GetAll())
	end
	
	self.MVPTracker:sendMVPList()
	
	if self.curGametype.onRoundEnded then
		self.curGametype:onRoundEnded(winningTeam)
	end
	
	if canRestart then
		timer.Simple(self.RoundRestartTime, function()
			if self.nextVotedMap then
				game.ConsoleCommand("changelevel " .. self.nextVotedMap .. "\n")
			else
				self:restartRound()
			end
		end)
	else
		if canPickRandomMapAndGametype then
			timer.Simple(self.RoundRestartTime, function()
				self:randomlyPickGametypeAndMap()
			end)
		end
	end
	
	self.RoundOver = true
	
	if lastRound then -- start a vote for the next map if possible
		if not canPickRandomMapAndGametype and not self.nextVotedMap then
			self:startVoteMap()
		end
	else
		if self.RoundsPlayed == self.RoundsPerMap - 3 then
			self:StartNewVote()
		end
		if self.RoundsPlayed == self.RoundsPerMap - 2 then
			self:StartWeaponBaseVote()
		end
		if self.RoundsPlayed == self.RoundsPerMap - 1 and self:gametypeVotesEnabled() and not canPickRandomMapAndGametype then -- start a vote for next gametype if we're on the second last round
			self:startGameTypeVote()
		end
		
		self.RoundsPlayed = self.RoundsPlayed + 1
		self:saveCurrentGametype()
	end
	
	hook.Call("GroundControlPostRoundEnded", nil, winningTeam)
	
	self.MVPTracker:resetAllTrackedIDs()
end

function GM:startVoteMap()
	if self:canStartVote() then
		local id, data = self:getGametypeFromConVar()
		local mapList = self:filterExistingMaps(data.mapRotation)
		
		self:setupCurrentVote("Vote for the next map", mapList, player.GetAll(), self.MaxMapsPerPick, true, nil, function()
			local highestOption, highestKey = self:getHighestVote()
			self.nextVotedMap = highestOption.option
			local mapText = "Will switch to '" .. self.nextVotedMap .. "' at the end of this round."
			
			for key, ply in ipairs(player.GetAll()) do
				ply:ChatPrint(mapText)
			end
		end, self.VoteMapVoteID)
		
		hook.Call("GroundControlMapVoteStarted", nil, mapList, self.VoteID)
	end
end

GM.PreviousGametypeFile = "previous_gametype.txt"

-- doesn't actually remove the gametype, it just removes any mention of what the previous gametype from the file was, in case you switch maps a lot and want to have all gametypes up for voting
-- bad name for the method though
function GM:removeCurrentGametype() 
	file.Write(self.MainDataDirectory .. "/" .. self.PreviousGametypeFile, "")
end

function GM:saveCurrentGametype()
	file.Write(self.MainDataDirectory .. "/" .. self.PreviousGametypeFile, self.curGametype.name)
end

function GM:getPreviousGametype()
	local data = file.Read(self.MainDataDirectory .. "/" .. self.PreviousGametypeFile)
	
	if data then
		return data
	end
end

function GM:hasAtLeastOneMapForGametype(gametypeData)
	for key, map in ipairs(gametypeData.mapRotation) do
		if self:hasMap(map) then
			return true
		end
	end
	
	return false
end

function GM:startGameTypeVote()
	local possibilities = {}
	local prevGametype = self:getPreviousGametype()
	
	for key, gametype in ipairs(GAMEMODE.Gametypes) do
		if self.RemovePreviousGametype and prevGametype and prevGametype == gametype.name then -- this gametype was already played, so skip it
			continue
		end
		
		if self:hasAtLeastOneMapForGametype(gametype) then -- only insert the gamemode if there is at least 1 map available for it
			table.insert(possibilities, gametype.prettyName)
		end
	end
	
	self:setupCurrentVote("Vote for next game type", possibilities, player.GetAll(), self.MaxGameTypesPerPick, false, nil, function()
		local highestOption, highestKey = self:getHighestVote()
		
		self:setGametypeCVarByPrettyName(highestOption.option)
	end, self.VoteGametypeVoteID)
	
	hook.Call("GroundControlGametypeVoteStarted", nil, possibilities, self.VoteID)
end 

function GM:StartWeaponBaseVote()
	if self.wepbaseLocked then return end 
    local bases = {}
	for num,base in pairs(GAMEMODE.WepBases) do
		table.insert(bases,base.name)
	end
	self:setupCurrentVote("Vote for weapon base in the next game", bases, player.GetAll(), self.MaxWeaponBasesPerPick, false, nil, function()
		local highestOption, highestKey = self:getHighestVote()
		local key = self:GetIDByName(highestOption.option)
		--self:SetWeaponBaseID(self:GetIDByName(highestOption.option))
		game.ConsoleCommand("gc_wepbase " .. key .. "\n")
		local text = "NEXT WEAPON BASE: " .. highestOption.option
		print("[GROUND CONTROL] " .. text)
		umsg.Start("GC_NOTIFICATION")
			umsg.String(text)
		umsg.End()
	end, self.VoteBaseID)
    
end 

function GM:specCount(num) 
	local Amount = 0
	local players = num - 1 -- commander is special unit
    if players < 2 then
		Amount = 0
	elseif players > 1 and players <= 4 then 
		Amount = 1
	elseif players > 4 and players <= 6 then 
		Amount = 2
	elseif players > 6 and players <= 10 then 
		Amount = 3 
	elseif players > 10 and players <= 12 then 
		Amount = 4
	else 
		Amount = 5 
	end 
	return Amount 
end

function GM:restartRound()
	if not self.curGametype.noTeamBalance then
		self:balanceTeams()
	end
	
	self.canSpawn = true
	game.CleanUpMap()
	self:dealWithTrashProps()
	self:autoRemoveEntities()
	self:runMapStartCallback()
	self:adjustDoorSpeeds()
	
	if self.curGametype.roundStart then
		self.curGametype:roundStart()
	end

	
	self:setupRoundPreparation()


if GetGlobalBool("SpecRoundEnabled") then 
	self.GlobalSpecRound = self.GlobalSpecRound - 1

	if self.GlobalSpecRound <= -1 then
		local randomround = table.Random(self.SpecRounds).id
		self.GlobalSpecRound = self.DefaultSpecRoundDelay
		self.CurSpecRound = randomround
		net.Start("SpecRoundUpdate")
		net.WriteString(randomround)
		net.WriteInt(self.GlobalSpecRound,31)
		net.Broadcast()
	else
		self.CurSpecRound = nil 
		net.Start("SpecRoundUpdate")
		net.WriteString("None")
		net.WriteInt(self.GlobalSpecRound,31)
		net.Broadcast()
	end

else 
	self.CurSpecRound = nil 
	net.Start("SpecRoundUpdate")
	net.WriteString("None")
	net.WriteInt(self.GlobalSpecRound,31)
	net.Broadcast()
end 

	--self.CurSpecRound = self.SpecRounds[math.random(1,table.Count(self.SpecRounds))]
	--print(self:GetSpecRound())

--end
if GetGlobalBool("RolesEnabled") then
	for k,v in pairs(team.GetPlayers(TEAM_SPECTATOR)) do
		player_manager.SetPlayerClass( v, "soldier" )
	end
	for i = 1,2 do
		local classcheck = self:getGametype().ClassGive
		local classoverride
		if classcheck and !classcheck[i] then
			classoverride = "soldier"
		end
		local maxcommander = 1
		local maxspec = self:specCount(team.NumPlayers(i))
		local maxdemo = 1 
		local demoamount = 0
		local specamount = 0
		local commanderamount = 0
		for k,v in RandomPairs(team.GetPlayers(i)) do
			if classoverride then
				player_manager.SetPlayerClass( v, classoverride )
				continue 
			end
			local randomdemo = math.random(1,7)
			if maxcommander > commanderamount  then
				player_manager.SetPlayerClass( v, "cmd" )
				commanderamount = commanderamount + 1
			elseif maxcommander <= commanderamount then 
				if maxspec > specamount then
					if randomdemo == 1 and demoamount < maxdemo then
						player_manager.SetPlayerClass( v, "demo" )
						specamount = specamount + 1
						demoamount = demoamount + 1
					else 
						player_manager.SetPlayerClass( v, "spec" )
						specAmount = specamount + 1
					end 
				else 
					player_manager.SetPlayerClass( v, "soldier" )
				end
			end
		end
		--print(self:specCount(team.NumPlayers(i)))
	end
else
	for k,v in pairs(player.GetAll()) do
		player_manager.SetPlayerClass( v, "soldier" )
	end
end
--self.RoundOver = false
--self:updateServerName()
--SendUserMessage("GC_NEW_ROUND")

	for key, obj in pairs(player.GetAll()) do
		obj:Spawn()
	end
	self.canSpawn = false 
	self.RoundOver = false
	self:updateServerName()
	SendUserMessage("GC_NEW_ROUND")
	
	self:resetKillcountData()
end


function GM:setupLoadoutSelectionTime()
	self.LoadoutSelectTime = CurTime() + self.RoundLoadoutTime
end

function GM:setupRoundPreparation()
	self.PreparationTime = CurTime() + self.RoundPreparationTime
	self:setupLoadoutSelectionTime()
	
	timer.Simple(self.RoundPreparationTime, function()
		self:disableCustomizationMenu() -- customize
	end)

	net.Start("GC_ROUND_PREPARATION")
		net.WriteFloat(self.PreparationTime)
	net.Broadcast()
end

function GM:countLivingPlayers(teamToCheck)
	local alive = 0
	
	for key, obj in pairs(team.GetPlayers(teamToCheck)) do
		if obj:Alive() then
			alive = alive + 1
		end
	end
	
	return alive
end
