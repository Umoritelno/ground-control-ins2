AddCSLuaFile()
util.AddNetworkString("classinfo")
util.AddNetworkString("killnotification")
util.AddNetworkString("updateclientcvar")
local pl = FindMetaTable("Player")

function pl:ResetClassInfo()
	local class = player_manager.GetPlayerClass(self)
    --[[if !self.classcheckcomplete then
		print("Players class was changed cus class check isnt completed")
		class = "soldier"
	end--]]
   self.plclass = player_manager.GetPlayerClasses()[class]
    if GAMEMODE.abilityEnabled then
	   if self.plclass.AbilityTable then
		self:GiveAbility(table.Random(self.plclass.AbilityTable))
	   elseif self.plclass.RandomAbility then 
		self:GiveAbility(table.Random(abilities))
	   else 
		self:DeathAbility(true)
	   end
	else
		self:DeathAbility(true)
    end
   net.Start("classinfo")
   net.WriteString(class)
   net.Send(self)
end 

function GM:ReRollRoles(tbl,role,replaceRole,amount)
	local index = 0 
	for k,v in pairs(tbl) do
	 if index >= amount then
		 break 
	 end
	 if !v:Alive() then 
        continue 
	 end 
	   if player_manager.GetPlayerClass(v) == replaceRole then
		  player_manager.SetPlayerClass(replaceRole)
		  v:ResetClassInfo()
		  index = index + 1
	   end
	end
 end 
 
 function pl:RoleReRoll() -- when player disconnecting or changing team
	 local rl = player_manager.GetPlayerClass(self)
	if rl == "cmd" then
	   GAMEMODE:ReRollRoles(team.GetPlayers(self:Team()),"soldier","cmd",1)
	elseif rl == "spec" then
	   GAMEMODE:ReRollRoles(team.GetPlayers(self:Team()),"soldier","spec",1)
	end
 end 


util.AddNetworkString("NewVote_Get")
util.AddNetworkString("NewVote_Start")

GM.NewVoteOnline = false
GM.NewVotedPlayers = {}
GM.VotePlayersCount = 0
GM.NewOption = {}

local ShutDownCVars = {}

function GM:CheckNewVoteValid()
	if !self.NewVoteOnline then return end
	local count = 0
	for k,v in pairs(self.NewVotedPlayers) do
		if v == true then
			count = count + 1 
		end
	end
	if count == self.VotePlayersCount then
		self:EndNewVote()
	end
end


function GM:ClearNewOption()
    for k,v in pairs(self.NewGolosArgs) do
		self.NewOption[v.cvar] = 0
		self.NewVotedPlayers = {}
		self.VotePlayersCount = 0
		self.NewVoteOnline = false
	end
end 

GM:ClearNewOption()

function GM:StartNewVote()
	if self.NewVoteOnline then return end 
	self.NewVoteOnline = true
	self.VotePlayersCount = #player.GetHumans()
   for k,v in pairs(player.GetHumans()) do
	  self.NewVotedPlayers[v:SteamID64()] = false
      net.Start("NewVote_Start")
	  net.Send(v)
   end 
   timer.Create("VoteTimer",self.NewVoteTime + 5,1,function()
	self:EndNewVote()
   end)
   
end 

function GM:EndNewVote()
   if !self.NewVoteOnline then return end 
   print("New vote ended")
   local half = self.VotePlayersCount / 2
   for k,v in pairs(self.NewOption) do
	if v > math.floor(half) then
		ShutDownCVars[k] = 1
	else 
		ShutDownCVars[k] = 0
	end
   end
   if timer.Exists("VoteTimer") then
	timer.Remove("VoteTimer")
   end
   self:ClearNewOption()
end 


net.Receive("NewVote_Get",function(len,ply)
	if !GAMEMODE.NewVoteOnline then ErrorNoHalt("Vote isnt online") return end 
	local cvrs = net.ReadTable()
	if !GAMEMODE.NewVotedPlayers[ply:SteamID64()] then
		GAMEMODE.NewVotedPlayers[ply:SteamID64()] = true 
        for k,v in pairs(cvrs) do
			if v == true then
				GAMEMODE.NewOption[k] = GAMEMODE.NewOption[k] + 1
			end
		end
	end
	GAMEMODE:CheckNewVoteValid()
end)

hook.Add("PlayerDisconnected","NewVoteDisconnect",function(ply)
	if !GAMEMODE.NewVoteOnline then return end 
	if GAMEMODE.NewVotedPlayers[ply:SteamID64()] == false then
		GAMEMODE.NewVotedPlayers[ply:SteamID64()] = nil 
		GAMEMODE.VotePlayersCount = GAMEMODE.VotePlayersCount - 1
        GAMEMODE:CheckNewVoteValid()
	end
end)

hook.Add("ShutDown","NewVoteBeforeShutDown",function()
	for cvar,bool in pairs(ShutDownCVars) do
		GetConVar(cvar):SetInt(bool)
		--print("Mega geistvo")
	end
end)


--[[
	if you wish to setup specific things for the gamemode ON THE SERVER, you should do it here
	this file will never be changed in future updates (except for being included in them), so you're free to adjust the gamemode as you see fit here 
	the code here will be run after everything in the gamemode has been initialized 
	
	this is also the best place for the "GroundControlPostInitEntity" hook (added with hook.Add as usual)
]]--