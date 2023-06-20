AddCSLuaFile()
util.AddNetworkString("classinfo")
util.AddNetworkString("killnotification")
local pl = FindMetaTable("Player")

function pl:ResetClassInfo()
   self.plclass = player_manager.GetPlayerClasses()[player_manager.GetPlayerClass(self)]
   if GAMEMODE.abilityEnabled then
	 if self.plclass.DisplayName == "Commander" then
		self:GiveAbility(1)
	   elseif self.plclass.DisplayName == "Specialist" then 
		self:GiveAbility(math.random(2,table.Count(abilities)))
	   else 
		self:DeathAbility(true)
	 end
	else
		self:DeathAbility(true)
   end
   net.Start("classinfo")
   net.Send(self)
end 

hook.Add("PlayerDeath","TeamkillNotification",function(victim,infl,attacker)
	if victim != attacker and victim:Team() == attacker:Team() then
		if victim.Ability and victim.Ability.name == "Disquise" and victim.Ability.active then
			return
		end
		local role
		if victim.plclass and victim.plclass.DisplayName then
			rolestr = victim.plclass.DisplayName
		else 
			rolestr = "Unknown"
		end
		local nick = victim:Nick()

		net.Start("killnotification")
		net.WriteString(rolestr)
		net.WriteString(nick)
		net.Send(attacker)
	end
end)


--[[util.AddNetworkString("NewVote_Get")
util.AddNetworkString("NewVote_Start")

GM.NewVotedPlayers = {}
GM.NewOption = {}

--GM:ClearNewOption()

function GM:ClearNewOption()
    for k,v in pairs(GM.NewGolosArgs) do
		GM.NewOption[table.Count(GM.NewOption) + 1] = 0
	end
end 

function GM:StartNewVote()
   for k,v in pairs(player.GetAll()) do
      net.Start("NewVote_Start")
	  net.Send(v)
   end 
   --[[timer.Create("VoteTimer",30,1,function()
	self:ClearNewOption()
   end)
   
end 


net.Receive("NewVote_Get",function(ply,len)
	local cvrs = net.ReadTable()
	if not GM.NewVotedPlayers[ply:SteamID64()] then
		GM.NewVotedPlayers[ply:SteamID64()] = true 
        for k,v in pairs(cvrs) do
			if v == true then
				GM.NewOption[k] = GM.NewOption[k] + 1
				print(GM.NewOption[k])
			end
		end
	end
end)
--]]


--[[
	if you wish to setup specific things for the gamemode ON THE SERVER, you should do it here
	this file will never be changed in future updates (except for being included in them), so you're free to adjust the gamemode as you see fit here 
	the code here will be run after everything in the gamemode has been initialized 
	
	this is also the best place for the "GroundControlPostInitEntity" hook (added with hook.Add as usual)
]]--